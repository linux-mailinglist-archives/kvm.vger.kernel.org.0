Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E36C0885
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfI0P0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:26:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:16864 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfI0P0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:26:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:26:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="184013821"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2019 08:26:08 -0700
Date:   Fri, 27 Sep 2019 08:26:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
Message-ID: <20190927152608.GC25513@linux.intel.com>
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 05:19:25PM +0200, Paolo Bonzini wrote:
> On 27/09/19 16:40, Vitaly Kuznetsov wrote:
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> > 
> >> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
> >>> Paolo Bonzini <pbonzini@redhat.com> writes:
> >>>
> >>>> Queued, thanks.
> >>>
> >>> I'm sorry for late feedback but this commit seems to be causing
> >>> selftests failures for me, e.g.:
> >>>
> >>> # ./x86_64/state_test 
> >>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> >>> Guest physical address width detected: 46
> >>> ==== Test Assertion Failure ====
> >>>   lib/x86_64/processor.c:1089: r == nmsrs
> >>>   pid=14431 tid=14431 - Argument list too long
> >>>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
> >>>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
> >>>      3	0x00007f881eb453d4: ?? ??:0
> >>>      4	0x0000000000401287: _start at ??:?
> >>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)

That "failed at %x" print line should really be updated to make it clear
that it's printing hex...

> >>> Is this something known already or should I investigate?
> >>
> >> No, I didn't know about it, it works here.
> >>
> > 
> > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> > it against nr_arch_gp_counters and returns a failure.
> 
> Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> to be checked against CPUID before allowing them.

My vote would be to programmatically generate the MSRs using CPUID and the
base MSR, as opposed to dumping them into the list and cross-referencing
them against CPUID.  E.g. there should also be some form of check that the
architectural PMUs are even supported.
