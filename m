Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3148E61ECDD
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiKGI2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiKGI2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:28:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972BF14095;
        Mon,  7 Nov 2022 00:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667809694; x=1699345694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LugKo+zcP0kZRcCVxWxirYwkdXpvIezIspsEyRp4wak=;
  b=fPRKdG0wxB5En6DCVeltIIR7iIXty2udT54Z5eZnbDpdb6Pq56CfJ0wt
   5bsUESJMYmP9A504/nuKswPZQCO9mMevmHXHfYRFfKQyDtix/gK5IKkAt
   zhrbncmKs3KjutlarBcTl6gC5Yi4pheuWGKEUub4l0T4mrD6gnbgwsEBF
   K78nPijcLShdQB/h1aDENmRCoEOhUW5u3b8HXnNrSyFVlHGIpfOdZ7dYk
   Yn3PAXfu5GQ7PAshwIIkU67ydWe28q+UPB1smP2w9oCBhwjIPHvqkn56G
   5a5x76wVwI/Qk6wbAAqXVNxUef0wujXbdszZPeRpgCb+OmEYKdtfBgX4i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="307980495"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="307980495"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 00:28:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="725053447"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="725053447"
Received: from unknown (HELO localhost) ([10.255.28.213])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 00:28:07 -0800
Date:   Mon, 7 Nov 2022 16:28:02 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2Px90RQydMUoiRH@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 04:53:11PM +0000, Sean Christopherson wrote:
> > > 
> > > Ugh, that path got overlooked when we yanked out KVM's manipulaton of VMX MSRs
> > > in response to guest CPUID changes.  I wonder if we can get away with changing
> > > KVM's behavior to only ensure a feature isn't exposed to L2 when it's not exposed
> > > to L1.
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 6b4266e949a3..cfc35d559d91 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -4523,8 +4523,8 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
> > >          * Update the nested MSR settings so that a nested VMM can/can't set
> > >          * controls for features that are/aren't exposed to the guest.
> > >          */
> > > -       if (nested) {
> > > -               if (enabled)
> > > +       if (nested && !enabled)
> > > +               if (exiting)
> > >                         vmx->nested.msrs.secondary_ctls_high |= control;
> > >                 else
> > >                         vmx->nested.msrs.secondary_ctls_high &= ~control;
> > > 
> > 
> > Indeed, this change can make sure a feature won't be exposed to L2, if L1
> > does not have it.
> 
> No, that's not the goal of the change.  KVM already hides features in the VMX MSRs
> if the base feature is not supported in L1 according to guest CPUID.  The problem
> is that, currently, KVM also _forces_ features to be enabled in the VMX MSRs when
> the base feature IS supported in L1 (CPUID).
> 
> Ideally, KVM should NEVER manipulate VMX MSRs in response to guest CPUID changes.
> That's what I was referring to earlier by commits:
> 
>   8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
>   9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL"")
> 
> E.g. if userspace sets VMX MSRs and then sets guest CPUID, KVM will override the
> nVMX CPU model defined by userspace.  The scenario where userspace hides a "base"
> feature but exposes the feature in the VMX MSRs is nonsensical, which is why I
> think KVM can likely get away with force-disabling features.
> 
> The reverse is completely legitimate though: hiding a feature in VMX MSRs even if
> the base feature is supported for L1, i.e. disallowing L1 from enabling the feature
> in L2, is something that real VMMs will actually do, e.g. if the user doesn't trust
> that KVM correctly handles all aspects of nested virtualization for the feature.

Thanks Sean. Let me try to rephrase my understandings of your statement(
and pls feel free to correct me):

1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes.
2> What makes sense is, if a feature is 
	a. disabled by guest CPUID, it shall not be exposed in guest VMX MSR;
	b. enabled by guest CPUID, it could be either exposed or hidden in
	guest VMX MSR.
3> So your previous change is to guarantee 2.a, and userspace VMM can choose
to follow follow either choices in 2.b(depending on whether it believes this
feature is correctly supported by KVM in nested). 

Is above understanding correct? 

But what if userspace VMM sets guest CPUID first, disabling a feature, and
then sets the guest VMX MSR bit with this feature enabled? Does KVM need to
check guest CPUID again, in vmx_restore_control_msr()? 

I do not think above scenario is what QEMU does - QEMU checks guest CPUID
first with kvm_arch_get_supported_cpuid() before trying to set guest VMX MSR.
But I am not sure if this is mandatory step for all userspace VMM. 

> 
> In other words, the behavior you're observing, where vmx->nested.msrs.secondary_ctls_high
> is changed by vmx_adjust_secondary_exec_control(), is a completely separate bug
> than the one below.
> 
> > > 
> > > Assuming KVM actually supports user wait/pause in L2, this is an orthogonal bug
> > > to the CPUID-based manipulation above.  KVM simply neglects to advertise to userspace
> > > that ENABLE_USR_WAIT_PAUSE is supported for nested virtualization.
> > > 
> > > If KVM doesn't correctly support virtualizing user wait/pause for L2, then the
> > > correct location to fix this is in vmx_secondary_exec_control().
> > > 
> > 
> > Sorry, why vmx_secondary_exec_control()?
> 
> You missed the qualifier:
> 
>   If KVM doesn't correctly support virtualizing user wait/pause for L2
> 
> If KVM should NOT be exposing ENABLE_USR_WAIT_PAUSE to the L1 VMM, then NOT
> propagating the feature to msrs->secondary_ctls_low is correct.  And if that's
> the case, then vmx_secondary_exec_control() needs to be modified so that it does
> NOT set ENABLE_USR_WAIT_PAUSE in vmx->nested.msrs.secondary_ctls_high.
> 
> > Could we just change nested_vmx_setup_ctls_msrs() like below:
> 
> If KVM correctly virtualizes the feature in a nested scenario, yes.  I haven't
> looked into ENABLE_USR_WAIT_PAUSE enough to know whether or not KVM gets the
> nested virtualization pieces correct, hence the above qualifier.
> 

Got it. I'll check that. Thanks!


B.R.
Yu
