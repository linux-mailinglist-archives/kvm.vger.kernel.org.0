Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DA1536658
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354197AbiE0RHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 13:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbiE0RHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 13:07:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BC676281
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h13-20020a170902f70d00b0015f4cc5d19aso3140396plo.18
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/UYpE3ORfUWUOgObAVh8AEEShSSgV4nNzE6TIkUvoL4=;
        b=TQeHEjgzosI03XNozW4xpCMZ9JxfuOpyVuGRddKE0ma/DiCtuvES/HGw8OCoLGaaVm
         FXr+UDQOUghyc8ovjUi+J/5fUG4E0TqoRGE/9BDUmv18uG0XVW6ciqTSD7yuQGrJ1i0l
         BquCrdDen83aMQ+FJvy9BKijtWgUXWD2EPsSFLBIfBYPEqrmYwQ1FaIfGNp7j/5x+UyJ
         +hjb1NRq/OEPbEbdJUuE51nrckFUuH40hY48qbAzp2dXxzwk7KyEdrjQW5GYVvfz40Lu
         GcR4kFxEv3iQeJqee+8IPGGcOJOBgs4XH6rP8EmOJ9H/JnrNZwpRuQSyVG5y0Mpqmhrj
         ks0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/UYpE3ORfUWUOgObAVh8AEEShSSgV4nNzE6TIkUvoL4=;
        b=j/0PZi7NpBZuBCAlA5RcnNSu3gF/fsi0r430AZVY77yDY3uEpxkA597SDdzhxawasF
         qSIemlyJwV/GFP6ddvsXuyvNR6GU3Kn5beQ5gAkxmyyEiiXIRKHgRY5A/Z/OyFMvwbIE
         7nM9+l+ClnAOeCKsK1gLsbPdNJflCCN9hLKyoEdcvaHBtgm7gGHHmR6FJhGiesd1x/JD
         NpO6Eyhg2WQhArJfz7bKshGQx4WJaETUlAF/0zfDc/24oIwzPXZgiFe6yT8XzEKCfXSW
         kLe2sAl7FA42BopIR/GODsA+lx7n7Rap5GjoKIWhkMh67MZ06Mvk+z5zvohytq/jU0Rc
         1DaQ==
X-Gm-Message-State: AOAM532UIOXGoqF6ObXbaYlU8MnDbqqCdjQsrTXQWnzOwotAFHNEJjcF
        flRNXYgy4Ciq2yreMp165jZGU0gRb8w=
X-Google-Smtp-Source: ABdhPJzKD8foVyPbZhCsSXtLbePPpsaS3Oi+ipHHra/WbFzZbW5aDHKJGWu55k2n9gGuWs4O+81BestqKnA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bb90:b0:158:a031:2ff2 with SMTP id
 m16-20020a170902bb9000b00158a0312ff2mr43681179pls.117.1653671224527; Fri, 27
 May 2022 10:07:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 May 2022 17:06:58 +0000
In-Reply-To: <20220527170658.3571367-1-seanjc@google.com>
Message-Id: <20220527170658.3571367-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220527170658.3571367-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 2/2] KVM: VMX: Reject kvm_intel if an inconsistent VMCS
 config is detected
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an on-by-default module param, error_on_inconsistent_vmcs_config, to
allow rejecting the load of kvm_intel if an inconsistent VMCS config is
detected.  Continuing on with an inconsistent, degraded config is
undesirable in the vast majority of use cases, e.g. may result in a
misconfigured VM, poor performance due to lack of fast MSR switching, or
even security issues in the unlikely event the guest is relying on MPX.

Practically speaking, an inconsistent VMCS config should never be
encountered in a production quality environment, e.g. on bare metal it
indicates a silicon defect (or a disturbing lack of validation by the
hardware vendor), and in a virtualized machine (KVM as L1) it indicates a
buggy/misconfigured L0 VMM/hypervisor.

Provide a module param to override the behavior for testing purposes, or
in the unlikely scenario that KVM is deployed on a flawed-but-usable CPU
or virtual machine.

Note, what is or isn't an inconsistency is somewhat subjective, e.g. one
might argue that LOAD_EFER without SAVE_EFER is an inconsistency.  KVM's
unofficial guideline for an "inconsistency" is either scenarios that are
completely nonsensical, e.g. the existing checks on having EPT/VPID knobs
without EPT/VPID, and/or scenarios that prevent KVM from virtualizing or
utilizing a feature, e.g. the unpaired entry/exit controls checks.  Other
checks that fall into one or both of the covered scenarios could be added
in the future, e.g. asserting that a VMCS control exists available if and
only if the associated feature is supported in bare metal.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a592b424fbbc..74202512f861 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -119,6 +119,9 @@ module_param(nested, bool, S_IRUGO);
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
+static bool __read_mostly error_on_inconsistent_vmcs_config = true;
+module_param(error_on_inconsistent_vmcs_config, bool, 0444);
+
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
@@ -2574,15 +2577,23 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					     CPU_BASED_CR3_STORE_EXITING |
 					     CPU_BASED_INVLPG_EXITING);
 	} else if (vmx_cap->ept) {
-		vmx_cap->ept = 0;
 		pr_warn_once("EPT CAP should not exist if not support "
 				"1-setting enable EPT VM-execution control\n");
+
+		if (error_on_inconsistent_vmcs_config)
+			return -EIO;
+
+		vmx_cap->ept = 0;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
-		vmx_cap->vpid) {
-		vmx_cap->vpid = 0;
+	    vmx_cap->vpid) {
 		pr_warn_once("VPID CAP should not exist if not support "
 				"1-setting enable VPID VM-execution control\n");
+
+		if (error_on_inconsistent_vmcs_config)
+			return -EIO;
+
+		vmx_cap->vpid = 0;
 	}
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
@@ -2642,6 +2653,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
 			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
 
+		if (error_on_inconsistent_vmcs_config)
+			return -EIO;
+
 		_vmentry_control &= ~n_ctrl;
 		_vmexit_control &= ~x_ctrl;
 	}
-- 
2.36.1.255.ge46751e96f-goog

