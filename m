Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F2B412FEE
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhIUIMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 04:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhIUIMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 04:12:07 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F87EC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:40 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k17so4393088pff.8
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+30wEd0qPykkQFIQZ4HkTpt+CXX50j+PYHWtyQl6vRc=;
        b=bqzAhp5WeQKf1XBVbKjDSt4Wf/ujjv81U8vpoVXiEwFjgbExKZ9+KoTyVQLN5gVDHh
         MdPt83xwB9gNP7d+F0uMmr99mZUjUlwl5ua3kRXhHUTFnQChLadyQV897rblhbZXyMLn
         1+3gWUz5RXWH/ioW11uu4ExfCh+vXoiSsB6bE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+30wEd0qPykkQFIQZ4HkTpt+CXX50j+PYHWtyQl6vRc=;
        b=6cUmzWEOJjKmt0nvUHpILUrJgx7nHMbUQhrNf2HfUE510dlUyMskmkN/0CZ7muduqi
         YQjM33cFhTnb7qS5Z3UnBbKNuJ9nVuKSu3t6dw5Nk9fem55KaTtLt/6xt2ok2ePni0ig
         qGBY0yDzVriPrnY0UCimCiQP8ArGEbJZWBA9uTv2Lr9+vLIkXpvARHC455xMCTWXbVfC
         ebzLIOkAk7u7MlaKc24A+JnIxUFbpbhOKSZi+SyFPgiyhJ8emsZYqQWAiu09ZEH1jPQ5
         ySi+idQCyr3+9yLwIg6ZKV9aYlgs/G/OHZZM3zzroCpX1QLAH7U1dqgfZgIOxAJPweYt
         zTcQ==
X-Gm-Message-State: AOAM531benvX+Tuwz7fc9Oix2/80bGI7R+PXXS8cI6Acha7qC2kcaWsg
        rVefi+O7mFO2jZv7E/QX6d7N3XJcpyDlrQ==
X-Google-Smtp-Source: ABdhPJyz20FY1BueYn2d92a4fnYRdZSoX8b5fqYSOKSgk3xMifwWcVMIjY9BWK/ot5bwACPJwfC4uQ==
X-Received: by 2002:a63:6e02:: with SMTP id j2mr27490957pgc.157.1632211839398;
        Tue, 21 Sep 2021 01:10:39 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:2b35:ed47:4cb5:84b])
        by smtp.gmail.com with UTF8SMTPSA id y15sm17291404pfq.32.2021.09.21.01.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 01:10:39 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 2/3] KVM: x86/mmu: skip page tracking when possible
Date:   Tue, 21 Sep 2021 17:10:09 +0900
Message-Id: <20210921081010.457591-3-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921081010.457591-1-stevensd@google.com>
References: <20210921081010.457591-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Skip allocating gfn_track arrays if nothing will use them, to save 2
bytes per 4kb of guest memory. This can be done when there are no
external users of page tracking (i.e. GVT-g is disabled), KVM is using
tdp, and the guest doesn't support nested virtualization.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/asm/kvm_page_track.h |  5 +++--
 arch/x86/kvm/mmu/page_track.c         | 25 +++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c                |  6 ++++++
 arch/x86/kvm/vmx/vmx.c                |  6 ++++++
 arch/x86/kvm/x86.c                    |  5 +++--
 7 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..99b0254305ea 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -18,6 +18,7 @@ KVM_X86_OP_NULL(hardware_unsetup)
 KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP(nested_enabled)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_NULL(vm_destroy)
 KVM_X86_OP(vcpu_create)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..ba29f64d16d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1049,6 +1049,7 @@ struct kvm_arch {
 	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
+	bool mmu_uses_page_tracking;
 	/*
 	 * Protects marking pages unsync during page faults, as TDP MMU page
 	 * faults only take mmu_lock for read.  For simplicity, the unsync
@@ -1302,6 +1303,7 @@ struct kvm_x86_ops {
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
+	bool (*nested_enabled)(void);
 
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..92e9e2c74219 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,11 +46,12 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+void kvm_page_track_init(struct kvm *kvm, bool mmu_uses_page_tracking);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 269f11f92fd0..c553bc09d50a 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -29,11 +29,16 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 	}
 }
 
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
 				  unsigned long npages)
 {
 	int  i;
 
+	if (!IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) &&
+	    !kvm->arch.mmu_uses_page_tracking)
+		return 0;
+
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
 			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
@@ -61,10 +66,15 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
 	int index, val;
+	unsigned short *arr;
+
+	arr = slot->arch.gfn_track[mode];
+	if (WARN_ON(!arr))
+		return;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
 
-	val = slot->arch.gfn_track[mode][index];
+	val = arr[index];
 
 	if (WARN_ON(val + count < 0 || val + count > USHRT_MAX))
 		return;
@@ -143,6 +153,7 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      enum kvm_page_track_mode mode)
 {
 	struct kvm_memory_slot *slot;
+	unsigned short *arr;
 	int index;
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
@@ -152,8 +163,12 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return false;
 
+	arr = slot->arch.gfn_track[mode];
+	if (!arr)
+		return false;
+
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
+	return !!READ_ONCE(arr[index]);
 }
 
 void kvm_page_track_cleanup(struct kvm *kvm)
@@ -164,13 +179,15 @@ void kvm_page_track_cleanup(struct kvm *kvm)
 	cleanup_srcu_struct(&head->track_srcu);
 }
 
-void kvm_page_track_init(struct kvm *kvm)
+void kvm_page_track_init(struct kvm *kvm, bool mmu_uses_page_tracking)
 {
 	struct kvm_page_track_notifier_head *head;
 
 	head = &kvm->arch.track_notifier_head;
 	init_srcu_struct(&head->track_srcu);
 	INIT_HLIST_HEAD(&head->track_notifier_list);
+
+	kvm->arch.mmu_uses_page_tracking = mmu_uses_page_tracking;
 }
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..bcc8f887d3bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4049,6 +4049,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool svm_nested_enabled(void)
+{
+	return nested;
+}
+
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -4590,6 +4595,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_exit_info = svm_get_exit_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
+	.nested_enabled = svm_nested_enabled,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..1b21ed01e837 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7225,6 +7225,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vmx_update_exception_bitmap(vcpu);
 }
 
+static bool vmx_nested_enabled(void)
+{
+	return nested;
+}
+
 static __init void vmx_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -7637,6 +7642,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_exit_info = vmx_get_exit_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
+	.nested_enabled = vmx_nested_enabled,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..cc47571a148a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11174,7 +11174,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
+	kvm_page_track_init(kvm, !tdp_enabled ||
+				 static_call(kvm_x86_nested_enabled));
 	kvm_mmu_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
@@ -11474,7 +11475,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
-- 
2.33.0.464.g1972c5931b-goog

