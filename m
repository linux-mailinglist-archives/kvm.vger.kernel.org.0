Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61A9268E23
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgINOp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 10:45:29 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35962 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbgINOpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 10:45:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 01F3B57689;
        Mon, 14 Sep 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600094703;
         x=1601909104; bh=oKjIpLANNuuokrHHbXyCbGj4qkyLR7Y/6x0lRldxMF8=; b=
        f0FOAnf691RFa3eHebwOGakoDoyBf2swd90IUfF+BbzK6eNq2ErdSMv/ubnY6xE7
        g3Q/itwJ3km4xGvVurjj8w9tWP3jFWXk+X2kGBZFKBnTQA9QslKqclHGacZpVfj7
        dlcMmooDRq1YwVtwWnjyIP8HP3YMfEXebJzzWR+ooCc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G8GzKn6QG-3y; Mon, 14 Sep 2020 17:45:03 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9DA67574F1;
        Mon, 14 Sep 2020 17:45:03 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 14
 Sep 2020 17:45:03 +0300
Date:   Mon, 14 Sep 2020 17:45:02 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
Message-ID: <20200914144502.GB52559@SPB-NB-133.local>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 04:31:03PM +0200, Thomas Huth wrote:
> On 01/09/2020 10.50, Roman Bolshakov wrote:
> > .gitlab-ci.yml already has a job to build the tests with clang but it's
> > not clear how to set it up on a personal github repo.
> 
> You can't use gitlab-ci from a github repo, it's a separate git forge
> system.
> 
> > NB, realmode test is disabled because it fails immediately after start
> > if compiled with clang-10.
> > 
> > Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > ---
> >  .travis.yml | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/.travis.yml b/.travis.yml
> > index f3a8899..ae4ed08 100644
> > --- a/.travis.yml
> > +++ b/.travis.yml
> > @@ -17,6 +17,16 @@ jobs:
> >                 kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
> >        - ACCEL="kvm"
> >  
> > +    - addons:
> > +        apt_packages: clang-10 qemu-system-x86
> > +      env:
> > +      - CONFIG="--cc=clang-10"
> > +      - BUILD_DIR="."
> > +      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
> > +               hyperv_synic idt_test intel_iommu ioapic ioapic-split
> > +               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
> > +      - ACCEL="kvm"
> 
> We already have two jobs for compiling on x86, one for testing in-tree
> builds and one for testing out-of-tree builds ... I wonder whether we
> should simply switch one of those two jobs to use clang-10 instead of
> gcc (since the in/out-of-tree stuff should be hopefully independent of
> the compiler type)? Since Travis limits the amount of jobs that run at
> the same time, that would not increase the total testing time, I think.
> 

Hi Thomas,

sure, that works for me.

>  Thomas
> 
> 
> PS: Maybe we could update from bionic to focal now, too, and see whether
> some more tests are working with the newer version of QEMU there...
> 

no problem, here're results for focal/kvm on IBM x3500 M3 (Nehalem) if
the tests are built with clang:

PASS apic-split (53 tests)
PASS ioapic-split (19 tests)
PASS apic (53 tests)
PASS ioapic (26 tests)
SKIP cmpxchg8b (i386 only)
PASS smptest (1 tests)
PASS smptest3 (1 tests)
PASS vmexit_cpuid
PASS vmexit_vmcall
PASS vmexit_mov_from_cr8
PASS vmexit_mov_to_cr8
PASS vmexit_inl_pmtimer
PASS vmexit_ipi
PASS vmexit_ipi_halt
PASS vmexit_ple_round_robin
PASS vmexit_tscdeadline
PASS vmexit_tscdeadline_immed
PASS access
SKIP smap (0 tests)
SKIP pku (0 tests)
PASS asyncpf (1 tests)
PASS emulator (125 tests, 2 skipped)
PASS eventinj (13 tests)
PASS hypercall (2 tests)
PASS idt_test (4 tests)
PASS memory (8 tests)
PASS msr (12 tests)
SKIP pmu (/proc/sys/kernel/nmi_watchdog not equal to 0)
SKIP vmware_backdoors (/sys/module/kvm/parameters/enable_vmware_backdoor
not equal to Y)
PASS port80
FAIL realmode
PASS s3
PASS setjmp (10 tests)
PASS sieve
PASS syscall (2 tests)
PASS tsc (3 tests)
PASS tsc_adjust (5 tests)
PASS xsave (4 tests)
PASS rmap_chain
SKIP svm (0 tests)
SKIP taskswitch (i386 only)
SKIP taskswitch2 (i386 only)
PASS kvmclock_test
PASS pcid (3 tests)
PASS pcid-disabled (3 tests)
PASS rdpru (1 tests)
PASS umip (21 tests)
FAIL vmx
PASS ept (8636 tests)
SKIP vmx_eoi_bitmap_ioapic_scan (1 tests, 1 skipped)
SKIP vmx_hlt_with_rvi_test (1 tests, 1 skipped)
SKIP vmx_apicv_test (2 tests, 2 skipped)
PASS vmx_apic_passthrough_thread (8 tests)
FAIL vmx_init_signal_test (8 tests, 1 unexpected failures)
FAIL vmx_apic_passthrough_tpr_threshold_test (timeout; duration=10)
PASS vmx_vmcs_shadow_test (142218 tests)
PASS debug (11 tests)
PASS hyperv_synic (1 tests)
PASS hyperv_connections (7 tests)
PASS hyperv_stimer (12 tests)
PASS hyperv_clock
PASS intel_iommu (11 tests)
PASS tsx-ctrl

Here are results for the same server if tests are built with gcc:
SureSS apic-split (53 tests)
PASS ioapic-split (19 tests)
PASS apic (53 tests)
PASS ioapic (26 tests)
SKIP cmpxchg8b (i386 only)
PASS smptest (1 tests)
PASS smptest3 (1 tests)
PASS vmexit_cpuid
PASS vmexit_vmcall
PASS vmexit_mov_from_cr8
PASS vmexit_mov_to_cr8
PASS vmexit_inl_pmtimer
PASS vmexit_ipi
PASS vmexit_ipi_halt
PASS vmexit_ple_round_robin
PASS vmexit_tscdeadline
PASS vmexit_tscdeadline_immed
PASS access
SKIP smap (0 tests)
SKIP pku (0 tests)
PASS asyncpf (1 tests)
PASS emulator (125 tests, 2 skipped)
PASS eventinj (13 tests)
PASS hypercall (2 tests)
PASS idt_test (4 tests)
PASS memory (8 tests)
PASS msr (12 tests)
SKIP pmu (/proc/sys/kernel/nmi_watchdog not equal to 0)
SKIP vmware_backdoors (/sys/module/kvm/parameters/enable_vmware_backdoor
not equal to Y)
PASS port80
PASS realmode
PASS s3
PASS setjmp (10 tests)
PASS sieve
PASS syscall (2 tests)
PASS tsc (3 tests)
PASS tsc_adjust (5 tests)
PASS xsave (4 tests)
PASS rmap_chain
SKIP svm (0 tests)
SKIP taskswitch (i386 only)
SKIP taskswitch2 (i386 only)
PASS kvmclock_test
PASS pcid (3 tests)
PASS pcid-disabled (3 tests)
PASS rdpru (1 tests)
PASS umip (21 tests)
FAIL vmx
PASS ept (8636 tests)
SKIP vmx_eoi_bitmap_ioapic_scan (1 tests, 1 skipped)
SKIP vmx_hlt_with_rvi_test (1 tests, 1 skipped)
SKIP vmx_apicv_test (2 tests, 2 skipped)
PASS vmx_apic_passthrough_thread (8 tests)
FAIL vmx_init_signal_test (8 tests, 1 unexpected failures)
FAIL vmx_apic_passthrough_tpr_threshold_test (timeout; duration=10)
PASS vmx_vmcs_shadow_test (142218 tests)
PASS debug (11 tests)
PASS hyperv_synic (1 tests)
PASS hyperv_connections (7 tests)
PASS hyperv_stimer (12 tests)
PASS hyperv_clock
PASS intel_iommu (11 tests)
PASS tsx-ctrl

The difference is only realmode test which doesn't work if built by
clang.

Thanks,
Roman
