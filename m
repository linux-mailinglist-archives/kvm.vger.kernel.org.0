Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0D725B392
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 20:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgIBSQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 14:16:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:65383 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgIBSQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 14:16:56 -0400
IronPort-SDR: hZGOky0LlUBQ0fZeNqF751FpRfsoyPLUYgeS8XM3xYMYeXVxttnZpRUkwtPBdxciTgPOhKysng
 +c6CEGRUiQMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="145195649"
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="145195649"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 11:16:55 -0700
IronPort-SDR: xbfRcJGUKUdWeZJRSSgZeskvNFte+Y8dH0W3yx3f8sJLpDxJRdgePMgu/lNju4cG/agZMEQpHt
 TZkrLyLr2PNg==
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="477744209"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 11:16:55 -0700
Date:   Wed, 2 Sep 2020 11:16:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] KVM: nVMX: Update VMX controls MSR according to
 guest CPUID after setting VMX MSRs
Message-ID: <20200902181654.GH11695@sjchrist-ice>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
 <20200828085622.8365-4-chenyi.qiang@intel.com>
 <CALMp9eT1makVq46TB-EtTPiz=Z_2DfhudJekrtheSsmwBc4pZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT1makVq46TB-EtTPiz=Z_2DfhudJekrtheSsmwBc4pZA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 01:39:39PM -0700, Jim Mattson wrote:
> On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >
> > Update the fields (i.e. VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS and
> > VM_{ENTRY, EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL) in
> > nested MSR_IA32_VMX_TRUE_{ENTRY, EXIT}_CTLS according to guest CPUID
> > when user space initializes the features MSRs. Regardless of the order
> > of SET_CPUID and SET_MSRS from the user space, do the update to avoid
> > MSR values overriding.
> >
> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 819c185adf09..f9664ccc003b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -345,6 +345,7 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu);
> >  static u32 vmx_segment_access_rights(struct kvm_segment *var);
> >  static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
> >                                                           u32 msr, int type);
> > +static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
> >
> >  void vmx_vmexit(void);
> >
> > @@ -2161,7 +2162,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                         return 1; /* they are read-only */
> >                 if (!nested_vmx_allowed(vcpu))
> >                         return 1;
> > -               return vmx_set_vmx_msr(vcpu, msr_index, data);
> > +               ret = vmx_set_vmx_msr(vcpu, msr_index, data);
> > +               nested_vmx_pmu_entry_exit_ctls_update(vcpu);
> > +               nested_vmx_entry_exit_ctls_update(vcpu);
> > +               break;
> 
> Now I see what you're doing. This commit should probably come before
> the previous commit, so that at no point in the series can userspace
> set VMX MSR bits that should be cleared based on the guest CPUID.
> 
> There's an ABI change here: userspace may no longer get -EINVAL if it
> tries to set an illegal VMX MSR bit. Instead, some illegal bits are
> silently cleared. Moreover, these functions will potentially set VMX
> MSR bits that userspace has just asked to clear.

Can we simply remove nested_vmx_entry_exit_ctls_update() and
nested_vmx_pmu_entry_exit_ctls_update()?  It's userspace's responsibility
to present a valid vCPU model to the guest, I don't see any reason to
silently tweak the VMX MSRs unless allowing the bogus config breaks KVM.
E.g. there are many more controls that are non-sensical without "native"
support for the associated feature.
