Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4361754B53A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355424AbiFNQAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 12:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345441AbiFNQAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 12:00:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE44A3CFE3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 09:00:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cx11so8858912pjb.1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 09:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AjEnIp3i/SaMEtzwhDdPJn8ss5djkc2rozWj+2o5TxI=;
        b=nBYw+Em2PtAzVr8+taeocf/e1+91IM2pnG7C0wOkrxqNzPnx3YU9Z/gUQiVkiQ+7GK
         4AWBKVLbuOGUGOrzVqCRIjjhCz0Gc5rstRVsy/peHrmIysPYIvtJpZkwaYXD2WEB86my
         /mBugJxiP2N05Vqo8YOXIoqrX392+Be60QmcPR9wL93aJaWZNwbSRg5XiwIsKrjRuJ4Z
         VzUsh+aq/sp3DwSR5OHWfNxuUPqwFBsnLejRJkICXe33oumtCqbomXrJZ5b2fAanX3Gz
         2tcFPAFgMEwjaxJuJRhhePHIScpAYnOSXlJ8smnazEtKPvRa+ISw42JTppqm94Je+xy4
         zWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AjEnIp3i/SaMEtzwhDdPJn8ss5djkc2rozWj+2o5TxI=;
        b=MHhmfWMCQ8dCHc/kY8d4VRcRZf3nqG1b7VmentouXpp4x0ZTAGlVt4ccdmGlojYPX6
         VSU9Ay3zMuzusDkZ/6TpbXLFTRVVMUsfATpAIvBUQBNPe3a0bJP9sNJjANvZLmRjLYWQ
         VzezhcAO56tIn80QvP6IghpF0HIawGl2WyrI6E1yh+PxtB7LtFdnJPHAAyAKRY4NRBlx
         Aebw6dB4N+78LRt/AMLocOhxrTR6tqnlb7aQoeH9QgQEVON1f0bpxQENqTstUPEKlVpJ
         u3TEGHbLVFXugtE1Qi9V/2zI8inRqiseo7l5wfTl38HERrGZ+oGOhSDcs1/EuaHsgSZA
         mH2g==
X-Gm-Message-State: AJIora/qSkaR/7qWnbseQ6BR6OEXAVKKuTthyGLr5aAdeHCj06c82T9N
        iTdc15em3x2h+zSYP2vDsjmptg==
X-Google-Smtp-Source: AGRyM1vg8+YLClBw8HLKjID9h7c+UP7PRptQfE2z0PMqdLfxw3GM+aA/0/Hg/l7XqKn5h311b60FVg==
X-Received: by 2002:a17:90b:4a92:b0:1e8:2c09:d008 with SMTP id lp18-20020a17090b4a9200b001e82c09d008mr5366166pjb.169.1655222436939;
        Tue, 14 Jun 2022 09:00:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ij11-20020a170902ab4b00b0015e8d4eb1f9sm7424820plb.67.2022.06.14.09.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:00:36 -0700 (PDT)
Date:   Tue, 14 Jun 2022 16:00:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YqiwoOP4HX2LniI4@google.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com>
 <YqipLpHI24NdhgJO@anrayabh-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqipLpHI24NdhgJO@anrayabh-desk>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022, Anirudh Rayabharam wrote:
> On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:
> > On Mon, Jun 13, 2022, Paolo Bonzini wrote:
> > > On 6/13/22 18:16, Anirudh Rayabharam wrote:
> > > > +	if (!kvm_has_tsc_control)
> > > > +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
> > > > +
> > > >   	msrs->secondary_ctls_low = 0;
> > > >   	msrs->secondary_ctls_high &=
> > > >   		SECONDARY_EXEC_DESC |
> > > > @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> > > >   		SECONDARY_EXEC_RDRAND_EXITING |
> > > >   		SECONDARY_EXEC_ENABLE_INVPCID |
> > > >   		SECONDARY_EXEC_RDSEED_EXITING |
> > > > -		SECONDARY_EXEC_XSAVES |
> > > > -		SECONDARY_EXEC_TSC_SCALING;
> > > > +		SECONDARY_EXEC_XSAVES;
> > > >   	/*
> > > 
> > > This is wrong because it _always_ disables SECONDARY_EXEC_TSC_SCALING,
> > > even if kvm_has_tsc_control == true.
> > > 
> > > That said, I think a better implementation of this patch is to just add
> > > a version of evmcs_sanitize_exec_ctrls that takes a struct
> > > nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
> > > 
> > > 	evmcs_sanitize_nested_vmx_vsrs(msrs);
> > 
> > Any reason not to use the already sanitized vmcs_config?  I can't think of any
> > reason why the nested path should blindly use the raw MSR values from hardware.
> 
> vmcs_config has the sanitized exec controls. But how do we construct MSR
> values using them?

I was thinking we could use the sanitized controls for the allowed-1 bits, and then
take the required-1 bits from the CPU.  And then if we wanted to avoid the redundant
RDMSRs in a follow-up patch we could add required-1 fields to vmcs_config.

Hastily constructed and compile-tested only, proceed with caution :-)

---
 arch/x86/kvm/vmx/nested.c | 35 ++++++++++++++++++++---------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..67cbb6643efa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6541,8 +6541,13 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
  */
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 {
+	struct nested_vmx_msrs *msrs = &vmcs_config.nested;
+
+	/* Take the allowed-1 bits from KVM's sanitized VMCS configuration. */
+	u32 ignore_high;
+
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
 	 * the control fields which may be 1) should be initialized by the
@@ -6559,11 +6564,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 */

 	/* pin-based controls */
-	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
-		msrs->pinbased_ctls_low,
-		msrs->pinbased_ctls_high);
+	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, msrs->pinbased_ctls_low, ignore_high);
 	msrs->pinbased_ctls_low |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
@@ -6574,12 +6579,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		PIN_BASED_VMX_PREEMPTION_TIMER;

 	/* exit controls */
-	rdmsr(MSR_IA32_VMX_EXIT_CTLS,
-		msrs->exit_ctls_low,
-		msrs->exit_ctls_high);
+	rdmsr(MSR_IA32_VMX_EXIT_CTLS, msrs->exit_ctls_low, ignore_high);
 	msrs->exit_ctls_low =
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;

+	msrs->exit_ctls_high = vmcs_conf->vmexit_ctrl;
 	msrs->exit_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
@@ -6595,11 +6599,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;

 	/* entry controls */
-	rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
-		msrs->entry_ctls_low,
-		msrs->entry_ctls_high);
+	rdmsr(MSR_IA32_VMX_ENTRY_CTLS, msrs->entry_ctls_low, ignore_high);
 	msrs->entry_ctls_low =
 		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->entry_ctls_high = vmcs_conf->vmentry_ctrl;
 	msrs->entry_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
@@ -6613,11 +6617,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;

 	/* cpu-based controls */
-	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
-		msrs->procbased_ctls_low,
-		msrs->procbased_ctls_high);
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, msrs->procbased_ctls_low, ignore_high);
 	msrs->procbased_ctls_low =
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->procbased_ctls_high = vmcs_conf->cpu_based_exec_ctrl;
 	msrs->procbased_ctls_high &=
 		CPU_BASED_INTR_WINDOW_EXITING |
 		CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
@@ -6653,10 +6657,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 */
 	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
 		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
-		      msrs->secondary_ctls_low,
-		      msrs->secondary_ctls_high);
+		      msrs->secondary_ctls_low, ignore_high);

 	msrs->secondary_ctls_low = 0;
+
+	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
 		SECONDARY_EXEC_ENABLE_RDTSCP |
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..fae047c6204b 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,7 +17,7 @@ enum nvmx_vmentry_status {
 };

 void vmx_leave_nested(struct kvm_vcpu *vcpu);
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps);
 void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9bd86ecccdab..cd0d0ffae0bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7139,7 +7139,7 @@ static int __init vmx_check_processor_compat(void)
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
@@ -8079,8 +8079,7 @@ static __init int hardware_setup(void)
 	setup_default_sgx_lepubkeyhash();

 	if (nested) {
-		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);

 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)

base-commit: b821e4ff9e35a8fc999685e8d44c0644cfeaa228
--

