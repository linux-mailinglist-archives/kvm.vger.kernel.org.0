Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF74E9139
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 22:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfJ2VGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 17:06:21 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:54953 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbfJ2VGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 17:06:21 -0400
Received: by mail-pf1-f202.google.com with SMTP id 2so12358110pfv.21
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 14:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7GmrFIGIPo229824iF8tjRIB4ZcL3cegUAEOQuJCxb0=;
        b=LvAVzqySMh7iGPz/F+fUClWtPxleNA6Egg67HQRkVVt/so+GMqlH72hjEJaYLta5yu
         vMreKtFZwaD95AvcXhyPdjZeqzSaWDTsOHlWQOinn3CwC/fPsic8y32ADC4inVdB31aS
         3WK+Ep1VCyu0CR7v2bnTlBwGmLPukbgHkc/qjUpFGxjf772EP6EBClaND9WfVoQQSYf+
         i0eAN9Y45lpW2XdDovMFVtJcqKUnUY03DMsr24UjdJv/yuwXPGMbia7F2SP6vFpV7rPD
         cc5d64zymgRIuTl+hr35PFAHHgCCHiJNZikEEeEFayB82FB+5zRVz66AJuo/V4ITLshh
         eMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7GmrFIGIPo229824iF8tjRIB4ZcL3cegUAEOQuJCxb0=;
        b=FRJq0cQ0z5Efixw39gWmoNqTOIjYxsQi9xsTwQhabAksisheJe6nL4Gy8n2TFW02YF
         cx7tzhd56f+0Kjv6yLs95Ny0XxzIOTQmfomEbb+xUW4Pc9NkhFODKma8jf6PCofQRLlt
         4pzFNqdI6FO3YmNwO36NAlMFUsXDueOCjjub48rcZW0hrr6WsBjiyCvuMbFsfs9YT30S
         vPXXt1m3wAA2fV2otPzZAD4ID6K7hHb5eNqnQ76niig0WitGJg0jpdgEnNEcBigJqpRc
         /6PyeFDBd3Nd3fBP/70dXnD1FJk+EobThZt5nEasHJghNJbO5GTBR8JY5nID683S5zom
         JfMw==
X-Gm-Message-State: APjAAAU8OXY6XJ+H7kvczDocKp4PLcngL7I3nxDu5+aHMNptkNk7Wfux
        nLJS5C171NSQG8j7Y4ADDY42brIQrXnYCCrQLjTO37hlazaxqK1ZyFvJlIxVBgJh/ye+SLM4cJQ
        OStgVuukIFyWC6+VQ5/t5Sb2P73I5HGbLVk/qBpn27zgBbM5P2v3kBun2NSn0/dsMwqZw
X-Google-Smtp-Source: APXvYqzK3JWU+betAyFUuPjqjKDR3q1IDBXGdHPbuJrD8mkEZHrE2QX0IyA2gIuXqOOWPPg8BO1UT0h3K4JhoI/H
X-Received: by 2002:a63:cd47:: with SMTP id a7mr28410809pgj.29.1572383180315;
 Tue, 29 Oct 2019 14:06:20 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:05:55 -0700
In-Reply-To: <20191029210555.138393-1-aaronlewis@google.com>
Message-Id: <20191029210555.138393-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 4/4] KVM: nVMX: Add support for capturing highest observable
 L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
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

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I876e79d98e8f2e5439deafb070be1daa2e1a8e4a
---
 arch/x86/kvm/vmx/nested.c | 91 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h    |  4 ++
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b058d7b9fcc..19863f2a6588 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -929,6 +929,36 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return i + 1;
 }
 
+static bool nested_vmx_get_msr_value(struct kvm_vcpu *vcpu, u32 msr_index,
+				     u64 *data)
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
@@ -963,12 +993,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
 			return -EINVAL;
 
-		if (kvm_get_msr(vcpu, e.index, &data)) {
-			pr_debug_ratelimited(
-				"%s cannot read MSR (%u, 0x%x)\n",
-				__func__, i, e.index);
+		if (!nested_vmx_get_msr_value(vcpu, e.index, &data))
 			return -EINVAL;
-		}
+
 		if (kvm_vcpu_write_guest(vcpu,
 					 gpa + i * sizeof(e) +
 					     offsetof(struct vmx_msr_entry, value),
@@ -982,6 +1009,51 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
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
@@ -2027,7 +2099,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	 * addresses are constant (for vmcs02), the counts can change based
 	 * on L2's behavior, e.g. switching to/from long mode.
 	 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
 
@@ -2294,6 +2366,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
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
2.24.0.rc0.303.g954a862665-goog

