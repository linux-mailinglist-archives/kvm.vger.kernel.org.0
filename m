Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA5412FEF
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 10:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhIUIMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 04:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhIUIML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 04:12:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4B4C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 5so12832627plo.5
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZaPD0afvShGe4v0fn38fl1H66ICVahlmkFLFvCamco=;
        b=hX0/JMqYSNri5hBXw6Te8PjCPqs/ww76NjT1aZxKhu/zWgVUMiXFq/ZSSKPUI4JBsK
         JxWBOlhNxhCG+4jWWYPnbhqavZb6V3oKOTzxCwLJ0Rnxvu3mqei8NtKYZIzSekfqVD6A
         rtasEPkfSIgIuSAi4s2SrInR1EPZbnnHXGVWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZaPD0afvShGe4v0fn38fl1H66ICVahlmkFLFvCamco=;
        b=AGe9a9ZEkC/4sDqev+w2HOx9lM3vvdexcCUotLHU1j3pG2QZVf9lX3wltmxQpHkbTG
         erVp+XON1Syn0OD9lQ6J6smPbDId/wN1Tvh9Rv1sijUVEJOeIMI69C9IRbsZ68FlRkC/
         QqLBk60NIcuvRCKIxREvQqANUaV+jhtTW6dnh6M/ilIoFYfbo2yDdepwudADXn/ITnP7
         WaqDafR0DLYSEewMtHZYWLRPI5jhSAyCWOQhfm9oBk+8pnYsSHkV/+E79i25rqlCbVmD
         WrGl/z9PmPra57JIvZoPrEGVdULQv1QimKBQkUGjCX23Ev2WzSjbdQ9I7VlLjojd3LIE
         XhTw==
X-Gm-Message-State: AOAM530GrQwKqXBjJrh11oFRbmuSDgy5eqbtcW3MCYfHzofDVi9hnANW
        rnN7nQt3Jd+DWm9A/kwbDqoY+kTXVA57iQ==
X-Google-Smtp-Source: ABdhPJwYSKopMqh8ifvMSn7UNd8mYqRfM63o0v0U97ggPCfrhjqX8F4oYavGdUmD66p0nEspiST1LQ==
X-Received: by 2002:a17:903:1207:b0:138:e2f9:6c98 with SMTP id l7-20020a170903120700b00138e2f96c98mr27149217plh.11.1632211842917;
        Tue, 21 Sep 2021 01:10:42 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:2b35:ed47:4cb5:84b])
        by smtp.gmail.com with UTF8SMTPSA id o20sm1552630pgd.31.2021.09.21.01.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 01:10:42 -0700 (PDT)
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
Subject: [PATCH 3/3] KVM: VMX: skip page tracking based on cpuid
Date:   Tue, 21 Sep 2021 17:10:10 +0900
Message-Id: <20210921081010.457591-4-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921081010.457591-1-stevensd@google.com>
References: <20210921081010.457591-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Consider X86_FEATURE_VMX when determining whether or not page tracking
is necessary, since that flag can be used to control whether or not a
particular guest supports nested virtualization. When the flag is
toggled, it is necessary to free/allocate gfn_track arrays for any
already existing slots.

If cpuid is heterogeneous or is modified after KVM_RUN, page tracking
may not work properly. This may cause guest instability, as per the
caveat on KVM_SET_CPUID{,2}. Host stability should not be affected.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/include/asm/kvm_host.h       |  2 +-
 arch/x86/include/asm/kvm_page_track.h |  2 +
 arch/x86/kvm/cpuid.c                  | 55 +++++++++++++++++++++------
 arch/x86/kvm/mmu/page_track.c         | 49 ++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |  4 +-
 arch/x86/kvm/vmx/vmx.c                |  7 +++-
 6 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ba29f64d16d3..dc732ac0eb56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1302,7 +1302,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
-	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
+	int (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 	bool (*nested_enabled)(void);
 
 	unsigned int vm_size;
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 92e9e2c74219..f917cea1b4b1 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -49,6 +49,8 @@ struct kvm_page_track_notifier_node {
 void kvm_page_track_init(struct kvm *kvm, bool mmu_uses_page_tracking);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
+int kvm_page_tracking_mmu_enable(struct kvm *kvm, bool enable);
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
 int kvm_page_track_create_memslot(struct kvm *kvm,
 				  struct kvm_memory_slot *slot,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..fb011b0e76e6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -150,10 +150,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
-static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
+	int ret;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
@@ -198,14 +199,20 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_hv_set_cpuid(vcpu);
 
-	/* Invoke the vendor callback only after the above state is updated. */
-	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
+	/*
+	 * Invoke the vendor callback only after the above state is updated. If
+	 * it fails, continue the function and let the caller roll back to the
+	 * previous cpuid.
+	 */
+	ret = static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
 
 	/*
 	 * Except for the MMU, which needs to do its thing any vendor specific
 	 * adjustments to the reserved GPA bits.
 	 */
 	kvm_mmu_after_set_cpuid(vcpu);
+
+	return ret;
 }
 
 static int is_efer_nx(void)
@@ -261,9 +268,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
 			     struct kvm_cpuid_entry __user *entries)
 {
-	int r, i;
+	int r, i, orig_nent;
 	struct kvm_cpuid_entry *e = NULL;
-	struct kvm_cpuid_entry2 *e2 = NULL;
+	struct kvm_cpuid_entry2 *e2 = NULL, *orig_e2;
 
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		return -E2BIG;
@@ -298,13 +305,25 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		goto out_free_cpuid;
 	}
 
-	kvfree(vcpu->arch.cpuid_entries);
+	orig_e2 = vcpu->arch.cpuid_entries;
+	orig_nent = vcpu->arch.cpuid_nent;
+
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 
 	cpuid_fix_nx_cap(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
+	r = kvm_vcpu_after_set_cpuid(vcpu);
+
+	if (!r) {
+		kvfree(orig_e2);
+	} else {
+		kvfree(e2);
+		vcpu->arch.cpuid_entries = orig_e2;
+		vcpu->arch.cpuid_nent = orig_nent;
+		kvm_update_cpuid_runtime(vcpu);
+		kvm_vcpu_after_set_cpuid(vcpu);
+	}
 
 out_free_cpuid:
 	kvfree(e);
@@ -316,8 +335,8 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries)
 {
-	struct kvm_cpuid_entry2 *e2 = NULL;
-	int r;
+	struct kvm_cpuid_entry2 *e2 = NULL, *orig_e2;
+	int r, orig_nent;
 
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		return -E2BIG;
@@ -334,14 +353,26 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	kvfree(vcpu->arch.cpuid_entries);
+	orig_e2 = vcpu->arch.cpuid_entries;
+	orig_nent = vcpu->arch.cpuid_nent;
+
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
+	r = kvm_vcpu_after_set_cpuid(vcpu);
 
-	return 0;
+	if (!r) {
+		kvfree(orig_e2);
+	} else {
+		kvfree(e2);
+		vcpu->arch.cpuid_entries = orig_e2;
+		vcpu->arch.cpuid_nent = orig_nent;
+		kvm_update_cpuid_runtime(vcpu);
+		kvm_vcpu_after_set_cpuid(vcpu);
+	}
+
+	return r;
 }
 
 int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c553bc09d50a..e4d0e6ad2178 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -19,6 +19,55 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 
+int kvm_page_tracking_mmu_enable(struct kvm *kvm, bool enable)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *s;
+	unsigned short **gfn_track, *buf;
+	int i, ret = 0;
+
+	if (IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING))
+		return 0;
+
+	mutex_lock(&kvm->slots_lock);
+
+	if (enable == kvm->arch.mmu_uses_page_tracking) {
+		mutex_unlock(&kvm->slots_lock);
+		return 0;
+	}
+
+	for (i = 0; enable && i < KVM_ADDRESS_SPACE_NUM && !ret; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(s, slots) {
+			gfn_track = s->arch.gfn_track + KVM_PAGE_TRACK_WRITE;
+			*gfn_track = kvcalloc(s->npages, sizeof(*gfn_track),
+					      GFP_KERNEL_ACCOUNT);
+			if (!*gfn_track) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; (!enable || !ret) && i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(s, slots) {
+			gfn_track = s->arch.gfn_track + KVM_PAGE_TRACK_WRITE;
+			buf = *gfn_track;
+			*gfn_track = NULL;
+			synchronize_srcu(&kvm->srcu);
+			kvfree(buf);
+		}
+	}
+
+	if (!ret)
+		kvm->arch.mmu_uses_page_tracking = enable;
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
 	int i;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bcc8f887d3bd..af904e9f4be9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3981,7 +3981,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
-static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+static int svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
@@ -4047,6 +4047,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	return 0;
 }
 
 static bool svm_nested_enabled(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b21ed01e837..6455759907d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7166,7 +7166,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7223,6 +7223,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	if (tdp_enabled)
+		return kvm_page_tracking_mmu_enable(vcpu->kvm,
+						    nested_vmx_allowed(vcpu));
+	return 0;
 }
 
 static bool vmx_nested_enabled(void)
-- 
2.33.0.464.g1972c5931b-goog

