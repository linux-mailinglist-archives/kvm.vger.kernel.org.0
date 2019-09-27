Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3861C091E
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfI0QEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:04:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:24556 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbfI0QEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:04:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 09:04:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="202066420"
Received: from lxy-dell.sh.intel.com ([10.239.159.46])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2019 09:04:52 -0700
Message-ID: <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Date:   Fri, 27 Sep 2019 23:58:40 +0800
In-Reply-To: <87a7ap68st.fsf@vitty.brq.redhat.com>
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
         <20190927152608.GC25513@linux.intel.com>
         <87a7ap68st.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-09-27 at 17:46 +0200, Vitaly Kuznetsov wrote:
> > > > > > Is this something known already or should I investigate?
> > > > > 
> > > > > No, I didn't know about it, it works here.
> > > > > 
> > > > 
> > > > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
> > > > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
> > > > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
> > > > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
> > > > it against nr_arch_gp_counters and returns a failure.
> > > 
> > > Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
> > > to be checked against CPUID before allowing them.
> > 
> > My vote would be to programmatically generate the MSRs using CPUID and the
> > base MSR, as opposed to dumping them into the list and cross-referencing
> > them against CPUID.  E.g. there should also be some form of check that the
> > architectural PMUs are even supported.
> 
> Yes. The problem appears to be that msrs_to_save[] and emulated_msrs[]
> are global and for the MSRs in question we check
> kvm_find_cpuid_entry(vcpu, 0xa, ) to find out how many of them are
> available so this can be different for different VMs (and even vCPUs :-)
> However,
> 
> "KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
> varies by kvm version and host processor, but does not change otherwise."
> 

Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
they are free from different guest configuration since they're initialized when
kvm module is loaded.

Even though some MSRs are not exposed to guest by clear their related cpuid
bits, they are still saved/restored by QEMU in the same fashion.

I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?

> So it seems that PMU MSRs just can't be there. Revert?
> 

