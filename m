Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF41B4A829B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbiBCKqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244178AbiBCKqd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQ3pPESnhQbauB1FGg255dNNz6/McqZEKS3BZuHialw=;
        b=EN1j6zStYdIvL8E+rTqkL32gf2VNnbpg7uXxGhlvLPsW67OmbY1OF6mQuTN+tK6JhmUHqG
        QILOIjy/FPW/r5gjRF5lKgtp66md+TJmEFfv88iRNSST5HTK9fxVNHFZhioxRl7wBQChAK
        MROrbkaL1h05KCWKBAcB8KpMNhkenQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-4O3V7YY6P-KQLCHBmWkYhA-1; Thu, 03 Feb 2022 05:46:29 -0500
X-MC-Unique: 4O3V7YY6P-KQLCHBmWkYhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43D3C190A7A2;
        Thu,  3 Feb 2022 10:46:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18D92108BB;
        Thu,  3 Feb 2022 10:46:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] KVM: selftests: nVMX: Properly deal with 'hv_clean_fields'
Date:   Thu,  3 Feb 2022 11:46:16 +0100
Message-Id: <20220203104620.277031-3-vkuznets@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
References: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of just resetting 'hv_clean_fields' to 0 on every enlightened
vmresume, do the expected cleaning of the corresponding bit on enlightened
vmwrite. Avoid direct access to 'current_evmcs' from evmcs_test to support
the change.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 150 +++++++++++++++++-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   5 +-
 2 files changed, 152 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index c9af97abd622..cc5d14a45702 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -213,6 +213,25 @@ struct hv_enlightened_vmcs {
 	u64 padding64_6[7];
 };
 
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP                BIT(0)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP               BIT(1)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2             BIT(2)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1             BIT(3)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC             BIT(4)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT            BIT(5)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY            BIT(6)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN            BIT(7)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR                     BIT(8)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT             BIT(9)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC              BIT(10)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1               BIT(11)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2               BIT(12)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER             BIT(13)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1                BIT(14)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL    BIT(15)
+#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL                      0xFFFF
+
 #define HV_X64_MSR_VP_ASSIST_PAGE		0x40000073
 #define HV_X64_MSR_VP_ASSIST_PAGE_ENABLE	0x00000001
 #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT	12
@@ -648,381 +667,507 @@ static inline int evmcs_vmwrite(uint64_t encoding, uint64_t value)
 	switch (encoding) {
 	case GUEST_RIP:
 		current_evmcs->guest_rip = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case GUEST_RSP:
 		current_evmcs->guest_rsp = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC;
 		break;
 	case GUEST_RFLAGS:
 		current_evmcs->guest_rflags = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC;
 		break;
 	case HOST_IA32_PAT:
 		current_evmcs->host_ia32_pat = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_IA32_EFER:
 		current_evmcs->host_ia32_efer = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_CR0:
 		current_evmcs->host_cr0 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_CR3:
 		current_evmcs->host_cr3 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_CR4:
 		current_evmcs->host_cr4 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_IA32_SYSENTER_ESP:
 		current_evmcs->host_ia32_sysenter_esp = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_IA32_SYSENTER_EIP:
 		current_evmcs->host_ia32_sysenter_eip = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_RIP:
 		current_evmcs->host_rip = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case IO_BITMAP_A:
 		current_evmcs->io_bitmap_a = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP;
 		break;
 	case IO_BITMAP_B:
 		current_evmcs->io_bitmap_b = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP;
 		break;
 	case MSR_BITMAP:
 		current_evmcs->msr_bitmap = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
 		break;
 	case GUEST_ES_BASE:
 		current_evmcs->guest_es_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_CS_BASE:
 		current_evmcs->guest_cs_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_SS_BASE:
 		current_evmcs->guest_ss_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_DS_BASE:
 		current_evmcs->guest_ds_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_FS_BASE:
 		current_evmcs->guest_fs_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GS_BASE:
 		current_evmcs->guest_gs_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_LDTR_BASE:
 		current_evmcs->guest_ldtr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_TR_BASE:
 		current_evmcs->guest_tr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GDTR_BASE:
 		current_evmcs->guest_gdtr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_IDTR_BASE:
 		current_evmcs->guest_idtr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case TSC_OFFSET:
 		current_evmcs->tsc_offset = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
 		break;
 	case VIRTUAL_APIC_PAGE_ADDR:
 		current_evmcs->virtual_apic_page_addr = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
 		break;
 	case VMCS_LINK_POINTER:
 		current_evmcs->vmcs_link_pointer = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_IA32_DEBUGCTL:
 		current_evmcs->guest_ia32_debugctl = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_IA32_PAT:
 		current_evmcs->guest_ia32_pat = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_IA32_EFER:
 		current_evmcs->guest_ia32_efer = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_PDPTR0:
 		current_evmcs->guest_pdptr0 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_PDPTR1:
 		current_evmcs->guest_pdptr1 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_PDPTR2:
 		current_evmcs->guest_pdptr2 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_PDPTR3:
 		current_evmcs->guest_pdptr3 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 		current_evmcs->guest_pending_dbg_exceptions = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_SYSENTER_ESP:
 		current_evmcs->guest_sysenter_esp = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_SYSENTER_EIP:
 		current_evmcs->guest_sysenter_eip = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case CR0_GUEST_HOST_MASK:
 		current_evmcs->cr0_guest_host_mask = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case CR4_GUEST_HOST_MASK:
 		current_evmcs->cr4_guest_host_mask = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case CR0_READ_SHADOW:
 		current_evmcs->cr0_read_shadow = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case CR4_READ_SHADOW:
 		current_evmcs->cr4_read_shadow = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case GUEST_CR0:
 		current_evmcs->guest_cr0 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case GUEST_CR3:
 		current_evmcs->guest_cr3 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case GUEST_CR4:
 		current_evmcs->guest_cr4 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case GUEST_DR7:
 		current_evmcs->guest_dr7 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR;
 		break;
 	case HOST_FS_BASE:
 		current_evmcs->host_fs_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case HOST_GS_BASE:
 		current_evmcs->host_gs_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case HOST_TR_BASE:
 		current_evmcs->host_tr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case HOST_GDTR_BASE:
 		current_evmcs->host_gdtr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case HOST_IDTR_BASE:
 		current_evmcs->host_idtr_base = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case HOST_RSP:
 		current_evmcs->host_rsp = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 		break;
 	case EPT_POINTER:
 		current_evmcs->ept_pointer = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT;
 		break;
 	case GUEST_BNDCFGS:
 		current_evmcs->guest_bndcfgs = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case XSS_EXIT_BITMAP:
 		current_evmcs->xss_exit_bitmap = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
 		break;
 	case GUEST_PHYSICAL_ADDRESS:
 		current_evmcs->guest_physical_address = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case EXIT_QUALIFICATION:
 		current_evmcs->exit_qualification = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case GUEST_LINEAR_ADDRESS:
 		current_evmcs->guest_linear_address = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VM_EXIT_MSR_STORE_ADDR:
 		current_evmcs->vm_exit_msr_store_addr = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case VM_EXIT_MSR_LOAD_ADDR:
 		current_evmcs->vm_exit_msr_load_addr = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case VM_ENTRY_MSR_LOAD_ADDR:
 		current_evmcs->vm_entry_msr_load_addr = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case CR3_TARGET_VALUE0:
 		current_evmcs->cr3_target_value0 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case CR3_TARGET_VALUE1:
 		current_evmcs->cr3_target_value1 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case CR3_TARGET_VALUE2:
 		current_evmcs->cr3_target_value2 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case CR3_TARGET_VALUE3:
 		current_evmcs->cr3_target_value3 = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case TPR_THRESHOLD:
 		current_evmcs->tpr_threshold = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case GUEST_INTERRUPTIBILITY_INFO:
 		current_evmcs->guest_interruptibility_info = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC;
 		break;
 	case CPU_BASED_VM_EXEC_CONTROL:
 		current_evmcs->cpu_based_vm_exec_control = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC;
 		break;
 	case EXCEPTION_BITMAP:
 		current_evmcs->exception_bitmap = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN;
 		break;
 	case VM_ENTRY_CONTROLS:
 		current_evmcs->vm_entry_controls = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY;
 		break;
 	case VM_ENTRY_INTR_INFO_FIELD:
 		current_evmcs->vm_entry_intr_info_field = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT;
 		break;
 	case VM_ENTRY_EXCEPTION_ERROR_CODE:
 		current_evmcs->vm_entry_exception_error_code = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT;
 		break;
 	case VM_ENTRY_INSTRUCTION_LEN:
 		current_evmcs->vm_entry_instruction_len = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT;
 		break;
 	case HOST_IA32_SYSENTER_CS:
 		current_evmcs->host_ia32_sysenter_cs = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case PIN_BASED_VM_EXEC_CONTROL:
 		current_evmcs->pin_based_vm_exec_control = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1;
 		break;
 	case VM_EXIT_CONTROLS:
 		current_evmcs->vm_exit_controls = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1;
 		break;
 	case SECONDARY_VM_EXEC_CONTROL:
 		current_evmcs->secondary_vm_exec_control = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1;
 		break;
 	case GUEST_ES_LIMIT:
 		current_evmcs->guest_es_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_CS_LIMIT:
 		current_evmcs->guest_cs_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_SS_LIMIT:
 		current_evmcs->guest_ss_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_DS_LIMIT:
 		current_evmcs->guest_ds_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_FS_LIMIT:
 		current_evmcs->guest_fs_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GS_LIMIT:
 		current_evmcs->guest_gs_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_LDTR_LIMIT:
 		current_evmcs->guest_ldtr_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_TR_LIMIT:
 		current_evmcs->guest_tr_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GDTR_LIMIT:
 		current_evmcs->guest_gdtr_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_IDTR_LIMIT:
 		current_evmcs->guest_idtr_limit = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_ES_AR_BYTES:
 		current_evmcs->guest_es_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_CS_AR_BYTES:
 		current_evmcs->guest_cs_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_SS_AR_BYTES:
 		current_evmcs->guest_ss_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_DS_AR_BYTES:
 		current_evmcs->guest_ds_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_FS_AR_BYTES:
 		current_evmcs->guest_fs_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GS_AR_BYTES:
 		current_evmcs->guest_gs_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_LDTR_AR_BYTES:
 		current_evmcs->guest_ldtr_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_TR_AR_BYTES:
 		current_evmcs->guest_tr_ar_bytes = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_ACTIVITY_STATE:
 		current_evmcs->guest_activity_state = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case GUEST_SYSENTER_CS:
 		current_evmcs->guest_sysenter_cs = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
 		break;
 	case VM_INSTRUCTION_ERROR:
 		current_evmcs->vm_instruction_error = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VM_EXIT_REASON:
 		current_evmcs->vm_exit_reason = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VM_EXIT_INTR_INFO:
 		current_evmcs->vm_exit_intr_info = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VM_EXIT_INTR_ERROR_CODE:
 		current_evmcs->vm_exit_intr_error_code = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case IDT_VECTORING_INFO_FIELD:
 		current_evmcs->idt_vectoring_info_field = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case IDT_VECTORING_ERROR_CODE:
 		current_evmcs->idt_vectoring_error_code = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VM_EXIT_INSTRUCTION_LEN:
 		current_evmcs->vm_exit_instruction_len = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case VMX_INSTRUCTION_INFO:
 		current_evmcs->vmx_instruction_info = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE;
 		break;
 	case PAGE_FAULT_ERROR_CODE_MASK:
 		current_evmcs->page_fault_error_code_mask = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case PAGE_FAULT_ERROR_CODE_MATCH:
 		current_evmcs->page_fault_error_code_match = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case CR3_TARGET_COUNT:
 		current_evmcs->cr3_target_count = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case VM_EXIT_MSR_STORE_COUNT:
 		current_evmcs->vm_exit_msr_store_count = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case VM_EXIT_MSR_LOAD_COUNT:
 		current_evmcs->vm_exit_msr_load_count = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case VM_ENTRY_MSR_LOAD_COUNT:
 		current_evmcs->vm_entry_msr_load_count = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		break;
 	case HOST_ES_SELECTOR:
 		current_evmcs->host_es_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_CS_SELECTOR:
 		current_evmcs->host_cs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_SS_SELECTOR:
 		current_evmcs->host_ss_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_DS_SELECTOR:
 		current_evmcs->host_ds_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_FS_SELECTOR:
 		current_evmcs->host_fs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_GS_SELECTOR:
 		current_evmcs->host_gs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case HOST_TR_SELECTOR:
 		current_evmcs->host_tr_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
 		break;
 	case GUEST_ES_SELECTOR:
 		current_evmcs->guest_es_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_CS_SELECTOR:
 		current_evmcs->guest_cs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_SS_SELECTOR:
 		current_evmcs->guest_ss_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_DS_SELECTOR:
 		current_evmcs->guest_ds_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_FS_SELECTOR:
 		current_evmcs->guest_fs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_GS_SELECTOR:
 		current_evmcs->guest_gs_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_LDTR_SELECTOR:
 		current_evmcs->guest_ldtr_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case GUEST_TR_SELECTOR:
 		current_evmcs->guest_tr_selector = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2;
 		break;
 	case VIRTUAL_PROCESSOR_ID:
 		current_evmcs->virtual_processor_id = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT;
 		break;
 	default: return 1;
 	}
@@ -1070,7 +1215,10 @@ static inline int evmcs_vmresume(void)
 {
 	int ret;
 
-	current_evmcs->hv_clean_fields = 0;
+	/* HOST_RIP */
+	current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
+	/* HOST_RSP */
+	current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER;
 
 	__asm__ __volatile__("push %%rbp;"
 			     "push %%rcx;"
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 4c7841dfd481..655104051819 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -76,8 +76,9 @@ void guest_code(struct vmx_pages *vmx_pages)
 	current_evmcs->revision_id = EVMCS_VERSION;
 	GUEST_SYNC(6);
 
-	current_evmcs->pin_based_vm_exec_control |=
-		PIN_BASED_NMI_EXITING;
+	vmwrite(PIN_BASED_VM_EXEC_CONTROL, vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
+		PIN_BASED_NMI_EXITING);
+
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
 
-- 
2.34.1

