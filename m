Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C4E615E68
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 09:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKBIyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 04:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBIyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 04:54:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F951A04C;
        Wed,  2 Nov 2022 01:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667379261; x=1698915261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/XRD4QRaEl90JV9MjJKQm91dlEzeeoviOfTasdxuFxs=;
  b=nxOqUFakAnZ0nmdTCGh82wX2t44IqD3dapOMNmU2tmOEAG9FX2xbPKdj
   ZZKALxEQhb/4+fdvxgm0c2ZdaXnK6oNa4TUiQCdzbItgRHVaK+jNcAro/
   435wUIJvdvYo9ln6FUCUKGY8bPuBX/DuBIxqku+hM9cLzsnAT1bmxQfO/
   cn1Qjc6w+rXbEH+jFG4aTcSdhE0F3sbECVsBiRHQM8y3KXPIs+1OQBm0A
   E0N51hZEbZoChEq8ZvgO0AQzJNsyeg/PDrplM11g06YaN3bHr/OM8Gafn
   rh/ICbAX6xnlqFeGSa3YJz8DpjPtmDuiRqR0+W4ahrZBLyTw4+zEdgNfw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="336027672"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="336027672"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:54:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="628879854"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="628879854"
Received: from zhuoche1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.255.30.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:54:16 -0700
Date:   Wed, 2 Nov 2022 16:54:14 +0800
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
Message-ID: <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2FePYteNrEfZ7D5@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 05:58:21PM +0000, Sean Christopherson wrote:
> On Tue, Nov 01, 2022, Yu Zhang wrote:
> > On Mon, Oct 31, 2022 at 05:11:10PM +0000, Sean Christopherson wrote:
> > > vmcs_config.nested never becomes out-of-date, it's read-only after __init (not
> > > currently marked as such, that will be remedied soon).
> > > 
> > > The auditing performed by KVM is purely to guard against userspace enabling
> > > features that KVM doesn't support.  KVM is not responsible for ensuring that the
> > > vCPU's CPUID model match the VMX MSR model.
> > 
> > Do you mean the VMX MSR model shall not be changed after the cpuid updates?
> 
> No, I mean that the virtual CPU model (CPUID + VMX MSRs) that is presented to the
> guest is the responsibility of host userspace.  KVM only cares about not enabling
> bits/features that KVM doesn't supported.
> 

Oh, I see. We need to guarantee the userspace VMM can not successfully
set a feature in vmx msr, if KVM does not support it.

> > And for VMX MSR model, do you mean the vmx->nested.msrs or the ones in 
> > vmcs_config->nested? 
> 
> vmx->nested.msrs.  vmcs_config->nested is effectively the VMX equivalent of
> KVM_GET_SUPPORTED_CPUID.
> 
> > What I observed is that vmx->nested.msrs.secondary_ctls_high will be changed
> > in vmx_adjust_secondary_exec_control(), which can be triggered after cpuid is
> > set. 
> 
> Ugh, that path got overlooked when we yanked out KVM's manipulaton of VMX MSRs
> in response to guest CPUID changes.  I wonder if we can get away with changing
> KVM's behavior to only ensure a feature isn't exposed to L2 when it's not exposed
> to L1.
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6b4266e949a3..cfc35d559d91 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4523,8 +4523,8 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>          * Update the nested MSR settings so that a nested VMM can/can't set
>          * controls for features that are/aren't exposed to the guest.
>          */
> -       if (nested) {
> -               if (enabled)
> +       if (nested && !enabled)
> +               if (exiting)
>                         vmx->nested.msrs.secondary_ctls_high |= control;
>                 else
>                         vmx->nested.msrs.secondary_ctls_high &= ~control;
> 

Indeed, this change can make sure a feature won't be exposed to L2, if L1
does not have it. But for the feature bits that L1 has, yet cleared from
the vmcs_conf->nested.msrs.secondary_ctls_high in nested_vmx_setup_ctls_msrs(),
there's no chance for userspace vmm to reset it again.

Well, I am not suggesting to give userspace vmm such permission(which I believe
is incorrect). And IIUC, vmcs_conf->nested.msrs.secondary_ctls_high shall serve
as a template to initialize vmx->nested.msrs.secondary_ctls_high. So maybe we
shall not mask off some features in nested_vmx_setup_ctls_msrs() at the beginning.
 
> > Since KVM's config(vmcs_config->nested.secondary_ctls_high) is done during init
> > by nested_vmx_setup_ctls_msrs(), which only kept a subset of the flags from the
> > vmcs_confg->cpu_based_2nd_exec_ctrl, the vmx_restore_control_msr() could fail
> > later, when userspace VMM tries to enable a feature(the only one I witnessed is
> > SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE) by setting MSR_IA32_VMX_PROCBASED_CTLS2.
> > Because the vmx->nested.msrs.secondary_ctls_high is updated by cpuid, but this
> > bit is not taken from vmcs_conf->cpu_based_2nd_exec_ctrl by nested_vmx_setup_ctls_msrs()
> > for vmcs_config->nested.secondary_ctls_high.
> > 
> > The failure can be fixed, simply by adding SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE in
> > nested_vmx_setup_ctls_msrs(), e.g.
> 
> Assuming KVM actually supports user wait/pause in L2, this is an orthogonal bug
> to the CPUID-based manipulation above.  KVM simply neglects to advertise to userspace
> that ENABLE_USR_WAIT_PAUSE is supported for nested virtualization.
> 
> If KVM doesn't correctly support virtualizing user wait/pause for L2, then the
> correct location to fix this is in vmx_secondary_exec_control().
> 

Sorry, why vmx_secondary_exec_control()? Could we just change
nested_vmx_setup_ctls_msrs() like below:

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

Note: I did not use "if (cpu_has_vmx_waitpkg())" here, it looks like to
take off one's pants to fart(no offense, just a Chinese old saying meaning
unnecessary acts.:)).

> > > > Another question is about the setting of secondary_ctls_high in
> > > > nested_vmx_setup_ctls_msrs().  I saw there's a comment saying:
> > > > 	"Do not include those that depend on CPUID bits, they are
> > > > 	added later by vmx_vcpu_after_set_cpuid.".
> > > 
> > > That's a stale comment, see the very next commit, 8805875aa473 ("Revert "KVM: nVMX:
> > > Do not expose MPX VMX controls when guest MPX disabled""), as well as the slightly
> > > later commit 9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> > > VM-{Entry,Exit} control"").
> > > 
> > 
> > So the comment can be and shall be removed, right? 
> 
> Yep.
> 
> > > > 	if (cpu_has_vmx_vmfunc()) {
> > > > 		msrs->secondary_ctls_high |=
> > > > 			SECONDARY_EXEC_ENABLE_VMFUNC;
> > > 
> > > This one is still required.  KVM never enables VMFUNC for itself, i.e. it won't
> > > be set in KVM's VMCS configuration.
> > > 
> > 
> > My understanding is that, for VMFUNC, altough KVM does not support it,
> > SECONDARY_EXEC_ENABLE_VMFUNC is still set in the secondary proc-based
> > vm execution ctrol. KVM just uses different handlers for VMFUNC exits
> > from L1(to inject the #UD) and L2(to emulate the eptp switching). So
> > it doesn't matter if we do not clear this bit for vmcs_config->nested.
> > procbased_ctls_high. 
> 
> Ah, you're right, I didn't realize KVM enables VMFUNC in L1.  Enabling VMFUNC for
> L1 is silly though, it's trivial to clear the feature in vmx_secondary_exec_control().
> 
> That said, enabling VMFUNC in vmcs01 is an orthogonal topic, and it _is_ indeed
> easier to keep the feature in the reference config.  Now that the nested config
> is derived from the non-nested config, nested_vmx_setup_ctls_msrs() can do:

Agreed. BTW, do you know why KVM took pains to do so? I mean, emulation for
L2's vmfunc does not rely on the existance of vmfunc, right? So, for L2,
we can just set vmcs02's SECONDARY_EXEC_ENABLE_VMFUNC based on vmcs12. And
for L1, we can just disable it by clearing it in vmx_secondary_exec_control(),
and remove the #UD injection logic from KVM?

B.R.
Yu
