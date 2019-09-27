Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6E1C0A7B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0Rf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:35:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:31860 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbfI0Rf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:35:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 10:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="204208768"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 27 Sep 2019 10:35:26 -0700
Date:   Fri, 27 Sep 2019 10:35:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
Message-ID: <20190927173526.GH25513@linux.intel.com>
References: <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
 <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
 <20190927171405.GD25513@linux.intel.com>
 <CALMp9eRpW++f1R7inMhu33s7GmerbD21+rGwyRmKphEEvdTDLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRpW++f1R7inMhu33s7GmerbD21+rGwyRmKphEEvdTDLQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 10:30:38AM -0700, Jim Mattson wrote:
> On Fri, Sep 27, 2019 at 10:14 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Sep 27, 2019 at 06:32:27PM +0200, Paolo Bonzini wrote:
> > > On 27/09/19 18:10, Jim Mattson wrote:
> > > > On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >>
> > > >> On 27/09/19 17:58, Xiaoyao Li wrote:
> > > >>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> > > >>> they are free from different guest configuration since they're initialized when
> > > >>> kvm module is loaded.
> > > >>>
> > > >>> Even though some MSRs are not exposed to guest by clear their related cpuid
> > > >>> bits, they are still saved/restored by QEMU in the same fashion.
> > > >>>
> > > >>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
> > > >>
> > > >> We can add a per-VM version too, yes.
> > >
> > > There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
> > > ioctl.
> > >
> > > > Should the system-wide version continue to list *some* supported MSRs
> > > > and *some* unsupported MSRs, with no rhyme or reason? Or should we
> > > > codify what that list contains?
> > >
> > > The optimal thing would be for it to list only MSRs that are
> > > unconditionally supported by all VMs and are part of the runtime state.
> > >  MSRs that are not part of the runtime state, such as the VMX
> > > capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.
> > >
> > > This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
> > > MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
> > > Unfortunately, that commit was done because userspace (QEMU) has a
> > > genuine need to detect whether KVM is new enough to support the
> > > IA32_VMX_VMFUNC MSR.
> > >
> > > Perhaps we can make all MSRs supported unconditionally if
> > > host_initiated.  For unsupported performance counters it's easy to make
> > > them return 0, and allow setting them to 0, if host_initiated
> >
> > I don't think we need to go that far.  Allowing any ol' MSR access seems
> > like it would cause more problems than it would solve, e.g. userspace
> > could completely botch something and never know.
> >
> > For the perf MSRs, could we enumerate all arch perf MSRs that are supported
> > by hardware?  That would also be the list of MSRs that host_initiated MSR
> > accesses can touch regardless of guest support.
> >
> > Something like:
> >
> >         case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0+INTEL_PMC_MAX_GENERIC:
> >         case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0+INTEL_PMC_MAX_GENERIC:
> >                 if (kvm_pmu_is_valid_msr(vcpu, msr))
> >                         return kvm_pmu_set_msr(vcpu, msr_info);
> >                 else if (msr <= num_hw_counters)
> >                         break;
> >                 return 1;
> 
> That doesn't quite work, since you need a vcpu, and
> KVM_GET_MSR_INDEX_LIST is a system-wide ioctl, not a VCPU ioctl.

That'd be for the {kvm,vmx}_set_msr() flow.  The KVM_GET_MSR_INDEX_LIST
flow would report all MSRs from 0..num_hw_counters, where num_hw_counters
is pulled from CPUID.
