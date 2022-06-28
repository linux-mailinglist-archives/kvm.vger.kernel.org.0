Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5E455CD2D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344915AbiF1Kdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344904AbiF1Kdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:33:36 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D79E230F62;
        Tue, 28 Jun 2022 03:33:35 -0700 (PDT)
Received: from anrayabh-desk.corp.microsoft.com (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5346C20CD15E;
        Tue, 28 Jun 2022 03:33:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5346C20CD15E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656412415;
        bh=hCGQYhHwpOSkpnLZXxvS6HfcNgQdwWClPUDXMEaPtE8=;
        h=From:To:Cc:Subject:Date:From;
        b=N4vRaqAOXEV7lTUTiRazbLlEcbdIZ0naG9MKtQxPVGLlRGmh3WiuYQEWYBPwNjQsm
         Zoo9L8ZSUWa8C87d8wqR9lxv5FLiL6mmPnYsQyRAOBOcftKhQqwSev7hyBLQs8cUwg
         xQw651inTey5aY1EmSs6JE3la1OMjWIrVbfKq/FY=
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ilias Stamatis <ilstam@amazon.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: Don't expose eVMCS unsupported fields to L1
Date:   Tue, 28 Jun 2022 16:02:41 +0530
Message-Id: <20220628103241.1785380-1-anrayabh@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running cloud-hypervisor tests, VM entry into an L2 guest on KVM on
Hyper-V fails with this splat (stripped for brevity):

[ 1481.600386] WARNING: CPU: 4 PID: 7641 at arch/x86/kvm/vmx/nested.c:4563 nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
[ 1481.600427] CPU: 4 PID: 7641 Comm: vcpu2 Not tainted 5.15.0-1008-azure #9-Ubuntu
[ 1481.600429] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 07/22/2021
[ 1481.600430] RIP: 0010:nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
[ 1481.600447] Call Trace:
[ 1481.600449]  <TASK>
[ 1481.600451]  nested_vmx_reflect_vmexit+0x10b/0x440 [kvm_intel]
[ 1481.600457]  __vmx_handle_exit+0xef/0x670 [kvm_intel]
[ 1481.600467]  vmx_handle_exit+0x12/0x50 [kvm_intel]
[ 1481.600472]  vcpu_enter_guest+0x83a/0xfd0 [kvm]
[ 1481.600524]  vcpu_run+0x5e/0x240 [kvm]
[ 1481.600560]  kvm_arch_vcpu_ioctl_run+0xd7/0x550 [kvm]
[ 1481.600597]  kvm_vcpu_ioctl+0x29a/0x6d0 [kvm]
[ 1481.600634]  __x64_sys_ioctl+0x91/0xc0
[ 1481.600637]  do_syscall_64+0x5c/0xc0
[ 1481.600667]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1481.600670] RIP: 0033:0x7f688becdaff
[ 1481.600686]  </TASK>

TSC multiplier field is currently not supported in EVMCS in KVM. It was
previously not supported from Hyper-V but has been added since. Because
it is not supported in KVM the use "TSC scaling control" is filtered out
of vmcs_config by evmcs_sanitize_exec_ctrls().

However, in nested_vmx_setup_ctls_msrs(), TSC scaling is exposed to L1.
eVMCS unsupported fields are not sanitized. When L1 tries to launch an L2
guest, vmcs12 has TSC scaling enabled. This propagates to vmcs02. But KVM
doesn't set the TSC multiplier value because kvm_has_tsc_control is false.
Due to this VM entry for L2 guest fails. (VM entry fails if
"use TSC scaling" is 1 but TSC multiplier is 0.)

To fix, in nested_vmx_setup_ctls_msrs(), sanitize the values read from MSRs
by filtering out fields that are not supported by eVMCS.

This is a stable-friendly intermediate fix. A more comprehensive fix is
in progress [1] but is probably too complicated to safely apply to
stable.

[1]: https://lore.kernel.org/kvm/20220627160440.31857-1-vkuznets@redhat.com/

Fixes: d041b5ea93352 ("KVM: nVMX: Enable nested TSC scaling")
Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
---

Changes since v1:
- Sanitize all eVMCS unsupported fields instead of just TSC scaling.

v1: https://lore.kernel.org/lkml/20220613161611.3567556-1-anrayabh@linux.microsoft.com/

---
 arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..f88d748c7cc6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6564,6 +6564,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		msrs->pinbased_ctls_high);
 	msrs->pinbased_ctls_low |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+#endif
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
@@ -6580,6 +6584,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->exit_ctls_low =
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+#endif
 	msrs->exit_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
@@ -6600,6 +6608,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		msrs->entry_ctls_high);
 	msrs->entry_ctls_low =
 		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+#endif
 	msrs->entry_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
@@ -6657,6 +6669,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		      msrs->secondary_ctls_high);
 
 	msrs->secondary_ctls_low = 0;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+#endif
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
 		SECONDARY_EXEC_ENABLE_RDTSCP |
-- 
2.34.1

