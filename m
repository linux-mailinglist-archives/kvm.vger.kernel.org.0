Return-Path: <kvm+bounces-22394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AAD93DBAD
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BF0A1C23339
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC6B17F4FE;
	Fri, 26 Jul 2024 23:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TL73I/QC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B4417F388
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038025; cv=none; b=akRgkKaUjNIkailwpSgd+IcNFuEAs4lsyAC7fnwfIm3hKk2WAXuxSfkx5v5gvK4fA1FKExJ3bs9/O7XugT6aCYR5vM8C2wcA9lOcBB04UqfIvl/HqeG9/z+ZIZ8xicJqKBjgR2xazeomn9VvIPX6rLBGwpKV37WUcMdfKRop0dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038025; c=relaxed/simple;
	bh=nCm8qj+MbqzUxjzjIu3NKNvGTRrvffksoQ9gtbIzG0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c1pkcyvSxydosmqgjf2H2UGCvIADwD1IGmKTjkua/gCe/Ft0h9FFWECK7m1fHx/jcuOUKQyvZmwpwV8xaIUQns0u78gAgkZmY5gy+n+BDRmSJ3FducUa5N8leydmdY39yHoYSiJvTEMlZzJbRCGZ0dch+LB1aFdoL2S9K3aoocY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TL73I/QC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b2ac67a53so433836276.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038022; x=1722642822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XPLhffmLB4ZFWgxHZuTKpVpsLNVQ+RH00jdWHKAirBA=;
        b=TL73I/QCzpredBGzgxkj0Fl3mBbOun4EGU7qYtrqlxO58O52lIY/CPvwBSyW9bGjUQ
         IGIK0LXkW8+vQkQG0A7qKcz4/c26baxs4a8hg3h6Jv5FBmGdiChr/DOlg8o/sjs6rkZ8
         bZCZJhREVSyLe4XV6C7kVQ6VD7bUpIfhSa0mw+z8t/QGalpvf/7FYekdS/n3LnhWctKQ
         OYhyTeQ54QKbyVIfGvi+1puD1IvBvV+OZaW7p6JYmfUA5+1TemyzherGdG5Ecfl8SOHY
         yO6dCOTDX3siGAolFLL9cKsCheFCpOYgTxBTfX5ZMFEf8+JCvl7dwFKaTp1yBxDBLgIB
         VD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038022; x=1722642822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XPLhffmLB4ZFWgxHZuTKpVpsLNVQ+RH00jdWHKAirBA=;
        b=Y1gcQyA4fHT9Wu2XpxizSnNiZhaTgx4x1Bf8yr47bAVzZBKmOzeCMfUw2L3Kxjvwfv
         kGVMHelTuIWu/oOONpnSifMWhhxmTJjUYfVeTo23L0Ti2QDdp603XKQWIYTXnXuq3ReL
         8duP7jzQmhc+ZPRsVWa7wKcTBHxf44OywdT0Q2wMGWmOJvZtELZ6+9hNKvZ88bDW9yEP
         VcR/SjI//Vv0tcZzrY0+fTO1XtG26Qs2sJhN2WnWA9u0DrzxGN15tVXIbq5HhDJJkb6p
         PlUO/iDpAKk1KjgsXfN6PwpY7heB6C2TjS+MZ9mv8DFTK/iG6wyIlMn0vb661s9bTTIt
         25Pw==
X-Gm-Message-State: AOJu0Yzf1bhnjbu+cQlZwcO85skea3F5KR0xvKCP9zpdm0Dz5QxFgDTj
	MRECkfEGoI59I6Tj8ZDWdCvk1RXP5/uLn/wFD9PXCImhIBT6PRdyEoL/ICWy2R60t9aIv6Fhjau
	Lig==
X-Google-Smtp-Source: AGHT+IGBhzeuzUiyouvcvFTiXgb/HBxmg2MAS0wOhJT2px7pnvcCfHG92BiTIsAz4jQy3aPwc+Eekl1Ce9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6844:0:b0:e0b:3432:73d4 with SMTP id
 3f1490d57ef6-e0b5560e6b3mr22860276.1.1722038021685; Fri, 26 Jul 2024 16:53:41
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:40 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-32-seanjc@google.com>
Subject: [PATCH v12 31/84] KVM: Pass in write/dirty to kvm_vcpu_map(), not kvm_vcpu_unmap()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Now that all kvm_vcpu_{,un}map() users pass "true" for @dirty, have them
pass "true" as a @writable param to kvm_vcpu_map(), and thus create a
read-only mapping when possible.

Note, creating read-only mappings can be theoretically slower, as they
don't play nice with fast GUP due to the need to break CoW before mapping
the underlying PFN.  But practically speaking, creating a mapping isn't
a super hot path, and getting a writable mapping for reading is weird and
confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 include/linux/kvm_host.h  | 20 ++++++++++++++++++--
 virt/kvm/kvm_main.c       | 12 +++++++-----
 6 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e5..23b3a228cd0a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -922,7 +922,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_svm_vmexit(svm);
 
 out:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 
 	return ret;
 }
@@ -1126,7 +1126,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 
 	nested_svm_transition_tlb_flush(vcpu);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a16c873b3232..62f63fd714df 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3466,7 +3466,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 
 	sev_es_sync_to_ghcb(svm);
 
-	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
+	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map);
 	svm->sev_es.ghcb = NULL;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..742a2cec04ce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2299,7 +2299,7 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
 	}
 
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 
 	return ret;
 }
@@ -4690,7 +4690,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	svm_copy_vmrun_state(map_save.hva + 0x400,
 			     &svm->vmcb01.ptr->save);
 
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 	return 0;
 }
 
@@ -4750,9 +4750,9 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	svm->nested.nested_run_pending = 1;
 
 unmap_save:
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 unmap_map:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3096f6f5ecdb..f7dde74ff565 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -231,7 +231,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map);
 	vmx->nested.hv_evmcs = NULL;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
@@ -318,9 +318,9 @@ static void nested_put_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map);
 	vmx->nested.pi_desc = NULL;
 }
 
@@ -624,7 +624,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map msr_bitmap_map;
+	struct kvm_host_map map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -647,10 +647,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			return true;
 	}
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &msr_bitmap_map))
+	if (kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &map))
 		return false;
 
-	msr_bitmap_l1 = (unsigned long *)msr_bitmap_map.hva;
+	msr_bitmap_l1 = (unsigned long *)map.hva;
 
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -714,7 +714,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
-	kvm_vcpu_unmap(vcpu, &msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3d4094ece479..82ca0971c156 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -285,6 +285,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool writable;
 };
 
 /*
@@ -1297,8 +1298,23 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
+
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
+		   bool writable);
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map);
+
+static inline int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, true);
+}
+
+static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
+					struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, false);
+}
+
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a9b99c11355..a46c7bf1f902 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3136,7 +3136,8 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+		   bool writable)
 {
 	struct kvm_follow_pfn kfp = {
 		.slot = gfn_to_memslot(vcpu->kvm, gfn),
@@ -3150,6 +3151,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->page = NULL;
 	map->hva = NULL;
 	map->gfn = gfn;
+	map->writable = writable;
 
 	map->pfn = kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(map->pfn))
@@ -3166,9 +3168,9 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 
 	return map->hva ? 0 : -EFAULT;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_map);
+EXPORT_SYMBOL_GPL(__kvm_vcpu_map);
 
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
 {
 	if (!map->hva)
 		return;
@@ -3180,11 +3182,11 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 		memunmap(map->hva);
 #endif
 
-	if (dirty)
+	if (map->writable)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
 	if (map->pinned_page) {
-		if (dirty)
+		if (map->writable)
 			kvm_set_page_dirty(map->pinned_page);
 		kvm_set_page_accessed(map->pinned_page);
 		unpin_user_page(map->pinned_page);
-- 
2.46.0.rc1.232.g9752f9e123-goog


