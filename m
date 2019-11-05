Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A666F05D4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403756AbfKETT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:19:28 -0500
Received: from mail-vs1-f74.google.com ([209.85.217.74]:44452 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390734AbfKETT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:19:28 -0500
Received: by mail-vs1-f74.google.com with SMTP id d75so3617793vsc.11
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TCMHo2rdlOpxl/wt7piVn2IQvOGL4FMZMET/QQNUf0g=;
        b=JlVGq/zGS3c0tKx/52+/t4qsxHROuyJigTCCBnbBSHxwPj7zeRQ99nAGiO2KTt5AtS
         8i/2HKrDM2vmUaIfH5JX6cAZzNiRdejtSC5tZMA4KqlwuaSDX/mxEcznTQK3CSSFQJJj
         rP48HjD9L7qI7jnCEgYYV2RsPVPsFalXa1JuUf9FZrJauztr6d8CIhP8BWrB3S3wr6q9
         9qmjIpLHzOZYyRivWD6LkGLrmShHvse84eS2mSQHxsS9qyiA3yaOCRVu4HdOL7x5pCqx
         Pu1fIIOl7X/xZtQQrNJ9CUy13TW72p5gjnU6WEdH6Rr3pS7ElBSILehguPBfYM3a7Jis
         8wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TCMHo2rdlOpxl/wt7piVn2IQvOGL4FMZMET/QQNUf0g=;
        b=K2aknb3sxFcVfjIfaLytmpdi2Rr8KonqpARGWxFax/4jtscdodf5/Ot+oSYoG9KxHq
         P2DT6aXWAQmeh0yK6AoSvzzpHEDP7Wa0dLq0PSkA+uB+tp07wiSLRU1bv5ibcn5DnY5s
         X+ComlB0X6Vdx79BjBliUwKxQzWTkL1XbKwU9+0KL+h+0azoaTHY4fSmvw2FCQ2PMyLA
         v7FveLLA1JLHJgwyxrYRCR2wGXCWsC7CnKQftgxxIF5ukLTMtbLJdhZ9mRZaf7eSY2j/
         amfz1XTej6SAntN2rwECVbwYv7qtXFcbOl4RV205XcCNJTZScuerxfPF6Uk2XUpTHtTY
         IFiw==
X-Gm-Message-State: APjAAAVrjZF+RECnntUCoRAvgKNdtRFcO8QKSjLhTPBjBDXsi1NgMH/Q
        x7cGgfDcP0kPlJrXA31xOkeQQnCWiK/vpw2DXW5B2XqbIw/kJw4zp55GhD1F3fwSRwit+4CxxFe
        8QmErj0YhLwnnxOBSGANS6o/gf9z9q9i+Rrkyh6CqSF3giKgmI+D4CdycQJsGmVtCczur
X-Google-Smtp-Source: APXvYqzVpD6lniCigiePR3BVCOyzMZhWmj0+NYcMJ2thkorl9cGHmiZQQ5Yzj2/2TuAUJRqPsRXHsv6fKDhc3wFA
X-Received: by 2002:a05:6102:1d2:: with SMTP id s18mr7455447vsq.197.1572981566872;
 Tue, 05 Nov 2019 11:19:26 -0800 (PST)
Date:   Tue,  5 Nov 2019 11:19:10 -0800
In-Reply-To: <20191105191910.56505-1-aaronlewis@google.com>
Message-Id: <20191105191910.56505-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v2 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
TSC value that might have been observed by L2 prior to VM-exit. The
current implementation does not capture a very tight bound on this
value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
during the emulation of an L2->L1 VM-exit, special-case the
IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
VM-exit MSR-store area to derive the value to be stored in the vmcs12
VM-exit MSR-store area.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/nested.c | 92 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h    |  4 ++
 2 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b058d7b9fcc..cb2a92341eab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -929,6 +929,37 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return i + 1;
 }

+static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
+					    u32 msr_index,
+					    u64 *data)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * If the L0 hypervisor stored a more accurate value for the TSC that
+	 * does not include the time taken for emulation of the L2->L1
+	 * VM-exit in L0, use the more accurate value.
+	 */
+	if (msr_index == MSR_IA32_TSC) {
+		int index = vmx_find_msr_index(&vmx->msr_autostore.guest,
+					       MSR_IA32_TSC);
+
+		if (index >= 0) {
+			u64 val = vmx->msr_autostore.guest.val[index].value;
+
+			*data = kvm_read_l1_tsc(vcpu, val);
+			return true;
+		}
+	}
+
+	if (kvm_get_msr(vcpu, msr_index, data)) {
+		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
+			msr_index);
+		return false;
+	}
+	return true;
+}
+
 static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, int i,
 				     struct vmx_msr_entry *e)
 {
@@ -963,12 +994,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
 			return -EINVAL;

-		if (kvm_get_msr(vcpu, e.index, &data)) {
-			pr_debug_ratelimited(
-				"%s cannot read MSR (%u, 0x%x)\n",
-				__func__, i, e.index);
+		if (!nested_vmx_get_vmexit_msr_value(vcpu, e.index, &data))
 			return -EINVAL;
-		}
+
 		if (kvm_vcpu_write_guest(vcpu,
 					 gpa + i * sizeof(e) +
 					     offsetof(struct vmx_msr_entry, value),
@@ -982,6 +1010,51 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return 0;
 }

+static bool nested_msr_store_list_has_msr(struct kvm_vcpu *vcpu, u32 msr_index)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u32 count = vmcs12->vm_exit_msr_store_count;
+	u64 gpa = vmcs12->vm_exit_msr_store_addr;
+	struct vmx_msr_entry e;
+	u32 i;
+
+	for (i = 0; i < count; i++) {
+		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
+			return false;
+
+		if (e.index == msr_index)
+			return true;
+	}
+	return false;
+}
+
+static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
+					   u32 msr_index)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
+	int i = vmx_find_msr_index(autostore, msr_index);
+	bool in_autostore_list = i >= 0;
+	bool in_vmcs12_store_list;
+	int last;
+
+	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
+
+	if (in_vmcs12_store_list && !in_autostore_list) {
+		if (autostore->nr == NR_MSR_ENTRIES) {
+			pr_warn_ratelimited(
+				"Not enough msr entries in msr_autostore.  Can't add msr %x\n",
+				msr_index);
+			return;
+		}
+		last = autostore->nr++;
+		autostore->val[last].index = msr_index;
+	} else if (!in_vmcs12_store_list && in_autostore_list) {
+		last = --autostore->nr;
+		autostore->val[i] = autostore->val[last];
+	}
+}
+
 static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	unsigned long invalid_mask;
@@ -2027,7 +2100,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	 * addresses are constant (for vmcs02), the counts can change based
 	 * on L2's behavior, e.g. switching to/from long mode.
 	 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));

@@ -2294,6 +2367,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
 	}

+	/*
+	 * Make sure the msr_autostore list is up to date before we set the
+	 * count in the vmcs02.
+	 */
+	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
+
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 34b5fef603d8..0ab1562287af 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -230,6 +230,10 @@ struct vcpu_vmx {
 		struct vmx_msrs host;
 	} msr_autoload;

+	struct msr_autostore {
+		struct vmx_msrs guest;
+	} msr_autostore;
+
 	struct {
 		int vm86_active;
 		ulong save_rflags;
--
2.24.0.rc1.363.gb1bccd3e3d-goog

