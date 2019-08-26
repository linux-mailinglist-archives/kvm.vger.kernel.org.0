Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2263D9CE58
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 13:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfHZLnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 07:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729569AbfHZLnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 07:43:45 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 107EF368DA;
        Mon, 26 Aug 2019 11:43:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCE6610016E9;
        Mon, 26 Aug 2019 11:43:41 +0000 (UTC)
Date:   Mon, 26 Aug 2019 13:43:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
Message-ID: <20190826114339.4x2wmjwz4dfn3ea5@kamzik.brq.redhat.com>
References: <20190826075728.21646-1-peterx@redhat.com>
 <20190826110958.lyueasf5laypkq2r@kamzik.brq.redhat.com>
 <20190826112244.GE1785@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826112244.GE1785@xz-x1>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 26 Aug 2019 11:43:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 07:22:44PM +0800, Peter Xu wrote:
> On Mon, Aug 26, 2019 at 01:09:58PM +0200, Andrew Jones wrote:
> > On Mon, Aug 26, 2019 at 03:57:28PM +0800, Peter Xu wrote:
> > > The dirty_log_test is failing on some old machines like Xeon E3-1220
> > > with tripple faults when writting to the tracked memory region:
> > > 
> > >   Test iterations: 32, interval: 10 (ms)
> > >   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> > >   guest physical test memory offset: 0x7fbffef000
> > >   ==== Test Assertion Failure ====
> > >   dirty_log_test.c:138: false
> > >   pid=6137 tid=6139 - Success
> > >      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
> > >      2  0x00007f3dd9e392dd: ?? ??:0
> > >      3  0x00007f3dd9b6a132: ?? ??:0
> > >   Invalid guest sync status: exit_reason=SHUTDOWN
> > > 
> > > It's because previously we moved the testing memory region from a
> > > static place (1G) to the top of the system's physical address space,
> > > meanwhile we stick to 39 bits PA for all the x86_64 machines.  That's
> > > not true for machines like Xeon E3-1220 where it only supports 36.
> > > 
> > > Let's unbreak this test by dynamically detect PA width from CPUID
> > > 0x80000008.  Meanwhile, even allow kvm_get_supported_cpuid_index() to
> > > fail.  I don't know whether that could be useful because I think
> > > 0x80000008 should be there for all x86_64 hosts, but I also think it's
> > > not really helpful to assert in the kvm_get_supported_cpuid_index().
> > > 
> > > Fixes: b442324b581556e
> > > CC: Paolo Bonzini <pbonzini@redhat.com>
> > > CC: Andrew Jones <drjones@redhat.com>
> > > CC: Radim Krčmář <rkrcmar@redhat.com>
> > > CC: Thomas Huth <thuth@redhat.com>
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  tools/testing/selftests/kvm/dirty_log_test.c  | 22 +++++++++++++------
> > >  .../selftests/kvm/lib/x86_64/processor.c      |  3 ---
> > >  2 files changed, 15 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index ceb52b952637..111592f3a1d7 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -274,18 +274,26 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> > >  	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> > >  
> > >  #ifdef __x86_64__
> > > -	/*
> > > -	 * FIXME
> > > -	 * The x86_64 kvm selftests framework currently only supports a
> > > -	 * single PML4 which restricts the number of physical address
> > > -	 * bits we can change to 39.
> > > -	 */
> > > -	guest_pa_bits = 39;
> > > +	{
> > > +		struct kvm_cpuid_entry2 *entry;
> > > +
> > > +		entry = kvm_get_supported_cpuid_entry(0x80000008);
> > > +		/*
> > > +		 * Supported PA width can be smaller than 52 even if
> > > +		 * we're with VM_MODE_P52V48_4K mode.  Fetch it from
> > 
> > It seems like x86_64 should create modes that actually work, rather than
> > always using one named 'P52', but then needing to probe for the actual
> > number of supported physical bits. Indeed testing all x86_64 supported
> > modes, like aarch64 does, would even make more sense in this test.
> 
> Should be true.  I'll think it over again...
> 
> > 
> > 
> > > +		 * the host to update the default value (SDM 4.1.4).
> > > +		 */
> > > +		if (entry)
> > > +			guest_pa_bits = entry->eax & 0xff;
> > 
> > Are we sure > 39 bits will work with this test framework? I can't
> > recall what led me to the FIXME above, other than things not working.
> > It seems I was convinced we couldn't have more bits due to how pml4's
> > were allocated, but maybe I misinterpreted it.
> 
> As mentioned in the IRC - I think I've got a "success case" of
> that... :)  Please see below:
> 
> virtlab423:~ $ lscpu
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> CPU(s):              16
> On-line CPU(s) list: 0-15
> Thread(s) per core:  1
> Core(s) per socket:  8
> Socket(s):           2
> NUMA node(s):        2
> Vendor ID:           GenuineIntel
> CPU family:          6
> Model:               63
> Model name:          Intel(R) Xeon(R) CPU E5-2640 v3 @ 2.60GHz
> Stepping:            2
> CPU MHz:             2597.168
> BogoMIPS:            5194.31
> Virtualization:      VT-x
> L1d cache:           32K
> L1i cache:           32K
> L2 cache:            256K
> L3 cache:            20480K
> NUMA node0 CPU(s):   0,2,4,6,8,10,12,14
> NUMA node1 CPU(s):   1,3,5,7,9,11,13,15
> Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single pti tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm xsaveopt cqm_llc cqm_occup_llc dtherm arat pln pts
> virtlab423:~ $ ./dirty_log_test 
> Test iterations: 32, interval: 10 (ms)
> Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> Supported guest physical address width: 46
> guest physical test memory offset: 0x3fffbffef000
> Dirtied 216064 pages
> Total bits checked: dirty (204841), clear (7922119), track_next (60730)
> 
> So on above E5-2640 I got PA width==46 and it worked well.  Does this
> mean that 39bits is not really a PA restriction anywhere?  Actually
> that also matches with the other fact that if we look into
> virt_pg_map() it's indeed allocating PML4 entries rather than having
> only one.
>

Yup, that looks good to me.

Thanks,
drew 
