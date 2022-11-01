Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD6614796
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 11:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKAKSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 06:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKAKSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 06:18:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0CF18345;
        Tue,  1 Nov 2022 03:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667297888; x=1698833888;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SHihEAg3nhNRPiYlYllEkTIhkYtcgJYGQVnysp8hIe4=;
  b=ARPD6N/e/muIhZtoFG0C3mTWUfQ0yEGgazdEZFyNRvRUo0V4EVwdH+ss
   /hDzLjtTHnenbk4q+Ll+BlkwP++2aUjnKf2PsM8+HgiF9bhf9nlPjIiZg
   Xkup0+r+hm1omO6uOEgSkxuPiQl1rVv8nSkthn31/ZpoUm+9DbVWCxjVF
   BI8M6e9IXTMVlqf7kFZpQH0ECVH0eiSQ+E5PPJcJAhMPoiyJvVfYofBef
   eTwPSgWftmQHf5g5zKYJ9yJnoULCpzSSr/g07OcLc3qV/p/2z7+SJ7IiM
   QhxBSIOXzROvFLtiVHWnfDhpZU5/d1thCcCwM5csIJCZ/fy3Y1Bb49OF9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="371188133"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="371188133"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:18:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="611807849"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="611807849"
Received: from linkunji-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.169.98])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:18:04 -0700
Date:   Tue, 1 Nov 2022 18:18:01 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <20221101101801.zxcjswoesg2gltri@linux.intel.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2ABrnRzg729ZZNI@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 05:11:10PM +0000, Sean Christopherson wrote:
> On Tue, Nov 01, 2022, Yu Zhang wrote:
> > Hi Sean & Paolo,
> > 
> > On Tue, Jun 07, 2022 at 09:35:54PM +0000, Sean Christopherson wrote:
> > > Restrict the nVMX MSRs based on KVM's config, not based on the guest's
> > > current config.  Using the guest's config to audit the new config
> > > prevents userspace from restoring the original config (KVM's config) if
> > > at any point in the past the guest's config was restricted in any way.
> > 
> > May I ask for an example here, to explain why we use the KVM config
> > here, instead of the guest's? I mean, the guest's config can be
> > adjusted after cpuid updates by vmx_vcpu_after_set_cpuid(). Yet the
> > msr settings in vmcs_config.nested might be outdated by then.

Thanks a lot for your explanation, Sean. Questions are embedded below:

> 
> vmcs_config.nested never becomes out-of-date, it's read-only after __init (not
> currently marked as such, that will be remedied soon).
> 
> The auditing performed by KVM is purely to guard against userspace enabling
> features that KVM doesn't support.  KVM is not responsible for ensuring that the
> vCPU's CPUID model match the VMX MSR model.

Do you mean the VMX MSR model shall not be changed after the cpuid updates?
And for VMX MSR model, do you mean the vmx->nested.msrs or the ones in 
vmcs_config->nested? 

What I observed is that vmx->nested.msrs.secondary_ctls_high will be changed
in vmx_adjust_secondary_exec_control(), which can be triggered after cpuid is
set. 

Since KVM's config(vmcs_config->nested.secondary_ctls_high) is done during init
by nested_vmx_setup_ctls_msrs(), which only kept a subset of the flags from the
vmcs_confg->cpu_based_2nd_exec_ctrl, the vmx_restore_control_msr() could fail
later, when userspace VMM tries to enable a feature(the only one I witnessed is
SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE) by setting MSR_IA32_VMX_PROCBASED_CTLS2.
Because the vmx->nested.msrs.secondary_ctls_high is updated by cpuid, but this
bit is not taken from vmcs_conf->cpu_based_2nd_exec_ctrl by nested_vmx_setup_ctls_msrs()
for vmcs_config->nested.secondary_ctls_high.

The failure can be fixed, simply by adding SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE in
nested_vmx_setup_ctls_msrs(), e.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..fa255391718c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6791,13 +6791,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
        msrs->procbased_ctls_low &=
                ~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);

-       /*
-        * secondary cpu-based controls.  Do not include those that
-        * depend on CPUID bits, they are added later by
-        * vmx_vcpu_after_set_cpuid.
-        */
        msrs->secondary_ctls_low = 0;
-
        msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
        msrs->secondary_ctls_high &=
                SECONDARY_EXEC_DESC |
@@ -6810,7 +6804,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
                SECONDARY_EXEC_ENABLE_INVPCID |
                SECONDARY_EXEC_RDSEED_EXITING |
                SECONDARY_EXEC_XSAVES |
-               SECONDARY_EXEC_TSC_SCALING;
+               SECONDARY_EXEC_TSC_SCALING |
+               SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;

        /*
         * We can emulate "VMCS shadowing," even if the hardware

But then I wonder, why do we need the bitwise and operation here first:
        msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
        msrs->secondary_ctls_high &=
                SECONDARY_EXEC_DESC |
                SECONDARY_EXEC_ENABLE_RDTSCP |
                SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
                SECONDARY_EXEC_WBINVD_EXITING |
                SECONDARY_EXEC_APIC_REGISTER_VIRT |
                SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
                SECONDARY_EXEC_RDRAND_EXITING |
                SECONDARY_EXEC_ENABLE_INVPCID |
                SECONDARY_EXEC_RDSEED_EXITING |
                SECONDARY_EXEC_XSAVES |
                SECONDARY_EXEC_TSC_SCALING |
                SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;

And then reset many of the remaining flags based on configurations such as
enable_ept, enable_vpid, enable_unrestricted_guest etc... But maybe we need
go through this case by case.

> 
> An example would be if userspace loaded the VMX MSRs with a default model, and
> then enabled features one-by-one.  In practice this doesn't happen because it's
> more performant to gather all features and do a single KVM_SET_MSRS, but it's a
> legitimate approach that KVM should allow.
> 
> > Another question is about the setting of secondary_ctls_high in
> > nested_vmx_setup_ctls_msrs().  I saw there's a comment saying:
> > 	"Do not include those that depend on CPUID bits, they are
> > 	added later by vmx_vcpu_after_set_cpuid.".
> 
> That's a stale comment, see the very next commit, 8805875aa473 ("Revert "KVM: nVMX:
> Do not expose MPX VMX controls when guest MPX disabled""), as well as the slightly
> later commit 9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control"").
> 

So the comment can be and shall be removed, right? 

> > But since cpuid updates can adjust the vmx->nested.msrs.secondary_ctls_high,
> > do we really need to clear those flags for secondary_ctls_high in this
> > global config?
> 
> As above, the comment is stale, KVM should not manipulate the VMX MSRs in response
> to guest CPUID changes.  The one exception to this is reserved CR0/CR4 bits.  We
> discussed quirking that behavior, but ultimately decided not to because (a) no
> userspace actually cares and and (b) KVM would effectively need to make up behavior
> if userspace allowed the guest to load CR4 bits via VM-Enter or VM-Exit that are
> disallowed by CPUID, e.g. L1 could end up running with a CR4 that is supposed to
> be impossible according to CPUID.
> 
> > Could we just set 
> > 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl?
> 
> KVM already does that in upstream (with further sanitization).  See commit
> bcdf201f8a4d ("KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs").
> 
> > If yes, code(in nested_vmx_setup_ctls_msrs()) such as
> > 	if (enable_ept) {
> > 		/* nested EPT: emulate EPT also to L1 */
> > 		msrs->secondary_ctls_high |=
> > 			SECONDARY_EXEC_ENABLE_EPT;
> 
> This can't be completely removed, though unless I'm missing something, it can and
> should be shifted to the sanitization code, e.g.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8f67a9c4a287..0c41d5808413 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6800,6 +6800,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  
>         msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
>         msrs->secondary_ctls_high &=
> +               SECONDARY_EXEC_ENABLE_EPT |
>                 SECONDARY_EXEC_DESC |
>                 SECONDARY_EXEC_ENABLE_RDTSCP |
>                 SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
> @@ -6820,9 +6821,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>                 SECONDARY_EXEC_SHADOW_VMCS;
>  
>         if (enable_ept) {
> -               /* nested EPT: emulate EPT also to L1 */
> -               msrs->secondary_ctls_high |=
> -                       SECONDARY_EXEC_ENABLE_EPT;
>                 msrs->ept_caps =
>                         VMX_EPT_PAGE_WALK_4_BIT |
>                         VMX_EPT_PAGE_WALK_5_BIT |
> 
> 
> > or 
> > 	if (cpu_has_vmx_vmfunc()) {
> > 		msrs->secondary_ctls_high |=
> > 			SECONDARY_EXEC_ENABLE_VMFUNC;
> 
> This one is still required.  KVM never enables VMFUNC for itself, i.e. it won't
> be set in KVM's VMCS configuration.
> 

My understanding is that, for VMFUNC, altough KVM does not support it,
SECONDARY_EXEC_ENABLE_VMFUNC is still set in the secondary proc-based
vm execution ctrol. KVM just uses different handlers for VMFUNC exits
from L1(to inject the #UD) and L2(to emulate the eptp switching). So
it doesn't matter if we do not clear this bit for vmcs_config->nested.
procbased_ctls_high. 

I may probably missed something. But I hope my questions are clear 
enough (though I also doubt it...) :)

B.R.
Yu
