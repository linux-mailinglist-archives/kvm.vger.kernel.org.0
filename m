Return-Path: <kvm+bounces-19274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC46B902D8F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B4E91F22788
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455E11EEE9;
	Tue, 11 Jun 2024 00:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kAwitgTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46303BA45
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065326; cv=none; b=VuY9tk8b60SaovCn33sB4FDNdvg11EHf2d9+l7gvr2INHY8RYKOywN1rXIi3qfz7Tc0pYQ9b5cHCsnVB+CGqtsQFVsInmkQKUTya/ExKkkJWoam0uFolYtPt7Ke/MgFqoyb5bhyGL5CuzzIRrImDsF2gZtn8WJCBshLkc9zGQrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065326; c=relaxed/simple;
	bh=l1kb8WAhH7ZZEnNCv7caRH5R11IxtoWpLxiHG3YPghg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZdUAc21uq5DhAQSwFLRk9P/V5i3Pey5BaHyIEJqFqnOPzI53i31hOdKaxS+fmYBvUWTY/8wK/33q9LuATZM4kLFoySKsUthwRXMquy37jDxPzoKIR7OgoB7ECHTrR9+IjggpctP8dLIIDaneYSeaeATYTtkpHtbSNhA16yXVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kAwitgTJ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62834d556feso95965307b3.3
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065323; x=1718670123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JyxqE8JQbjAibPP1L18H/WB5ae5upDraVd7kSoejAF4=;
        b=kAwitgTJAEsVLjJILkRH+txVpp4zbwURiYkW/bc8pAKSSVaokMDVw/9KHcHcprl5Sy
         jgnrrMcgUgM7cjlffBddG9pnqilLBTyYnXZqTIFzyhped4aDftzrtIkxeqnYpcjXewYY
         QRgWHMpkfTEJlEQcdHL+SOPQceNSjmo0Rfb2eWm8/6frtw+nYxULIMf5UWHUVNz07ZiD
         yZoPJ30tZUbHOejNOzKXqaGS21PN/meJqT+p+Ex7zO3BACemZZkMYNtIPX1ZMnUKYr1W
         DluFf1veWMoKNqFUm8FtLtXs1A7Vea/mWiERSU0SPMD2CAYdsj7dD/ERstVwoj40iA1s
         hLfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065323; x=1718670123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JyxqE8JQbjAibPP1L18H/WB5ae5upDraVd7kSoejAF4=;
        b=UY/Kw2tp3e4aWPg6NAnk7QK5TV/IUAgBb0ZeODW1iXMYDTT/+UdG3S2MP8YGirDbZC
         hj3BJOuwNFiMD1GHrKRbkXIhiZfDAmGCTUNJIXiKwUwr1g4FqpRv0yAp4ynWs27gFSA6
         wzIl/TDmAkvdpfpTzEN8h5OrVRpH5GYrzDD6Y9J1+6ENZlLcc6KiWBKAZggLimUmKK2P
         8yY69CKGznWKEmNWaEvSPjX9cfN2znO7ui4CCPk8QAuw8lZgd5G+w1CF+LpgDAvTlSk9
         d3AYxH/fQpqHSuvMspv1aR2D1nVjUbrG6K5rH8iekAsEhs/r9LHNfqMvk1HppFYTnmeq
         s4hg==
X-Forwarded-Encrypted: i=1; AJvYcCU6NvExO2lzXmVIpThGx5SpqdvsgVNQ9wcpNZ4nGG4FWY1BgqIFosT2/PIzxZDzIA+zsPGz6+vWzjtrnSnKtJzv7I3C
X-Gm-Message-State: AOJu0Yw8TpcSXymn4vYOGxksQ/SbAcWtuzdY1xKEGxUb8mrHWkdl6o/T
	Gx9aWGAHhRptoaS4xvw+qVAQZPa1VETqMNxF0GjMv1tjAWRSFqqIN5QFPW40uAfXfL7EffdDX3t
	jVVMkWlhScYSydkxCrQ==
X-Google-Smtp-Source: AGHT+IE2AKcYsstInOqgudHKTQp6Jdm0LGHMNfnLB4IVzasoq6oW0Y69RVWgTVatpoFZnw0nHcf4J+vZvg80MMrE
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6101:b0:62a:2a39:ccd9 with
 SMTP id 00721157ae682-62cd5663caemr27714337b3.6.1718065323356; Mon, 10 Jun
 2024 17:22:03 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:41 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-6-jthoughton@google.com>
Subject: [PATCH v5 5/9] KVM: Add kvm_fast_age_gfn and kvm_fast_test_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Provide the basics for allowing architectures to implement
mmu_notifier_test_clear_young_fast_only().

Add CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER that architectures will set
if they implement the fast-only notifier.

kvm_fast_age_gfn and kvm_fast_test_age_gfn both need to support
returning a tri-state state of:
  1. fast && young,
  2. fast && !young,
  3. !fast
This could be done by making gfn_handler_t return int, but that would
mean a lot of churn. Instead, include a new kvm_mmu_notifier_arg
'bool *failed' for kvm_fast_{test,}_age_gfn to optionally use.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h   |  7 ++++++
 include/trace/events/kvm.h | 22 ++++++++++++++++++
 virt/kvm/Kconfig           |  4 ++++
 virt/kvm/kvm_main.c        | 47 ++++++++++++++++++++++++++++++--------
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d7c3e8632e6..e4efeba51222 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -258,6 +258,9 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
 	unsigned long attributes;
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+	bool *failed;
+#endif
 };
 
 struct kvm_gfn_range {
@@ -271,7 +274,11 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+bool kvm_fast_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_fast_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
+#endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
 
 enum {
 	OUTSIDE_GUEST_MODE,
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..7ba6c35c2426 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -489,6 +489,28 @@ TRACE_EVENT(kvm_test_age_hva,
 	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
 );
 
+TRACE_EVENT(kvm_fast_test_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end, bool clear),
+	TP_ARGS(start, end, clear),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+		__field(	bool,		clear		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+		__entry->clear		= clear;
+	),
+
+	TP_printk("mmu notifier fast test age: hva: %#016lx -- %#016lx "
+		  "clear: %d",
+		  __entry->start, __entry->end,
+		  __entry->clear)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 0404857c1702..77ac680af60c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,6 +100,10 @@ config KVM_GENERIC_MMU_NOTIFIER
 config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
        bool
 
+config HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+       select KVM_GENERIC_MMU_NOTIFIER
+       bool
+
 config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8fa0d617f12..aa930a8b903f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -699,7 +699,8 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
 							 unsigned long start,
 							 unsigned long end,
-							 gfn_handler_t handler)
+							 gfn_handler_t handler,
+							 bool *failed)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -711,6 +712,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.may_block	= false,
 		.lockless	=
 			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
+		.arg.failed	= failed,
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
@@ -901,7 +903,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn, NULL);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -911,9 +913,32 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	trace_kvm_test_age_hva(address);
 
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+					     kvm_test_age_gfn, NULL);
 }
 
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+static int kvm_mmu_notifier_test_clear_young_fast_only(struct mmu_notifier *mn,
+						       struct mm_struct *mm,
+						       unsigned long start,
+						       unsigned long end,
+						       bool clear)
+{
+	gfn_handler_t handler;
+	bool failed = false, young;
+
+	trace_kvm_fast_test_age_hva(start, end, clear);
+
+	handler = clear ? kvm_fast_age_gfn : kvm_fast_test_age_gfn;
+
+	young = kvm_handle_hva_range_no_flush(mn, start, end, handler, &failed);
+
+	if (failed)
+		return MMU_NOTIFIER_FAST_FAILED;
+
+	return young ? MMU_NOTIFIER_FAST_YOUNG : 0;
+}
+#endif
+
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
@@ -926,12 +951,16 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
-	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
-	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
-	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
-	.clear_young		= kvm_mmu_notifier_clear_young,
-	.test_young		= kvm_mmu_notifier_test_young,
-	.release		= kvm_mmu_notifier_release,
+	.invalidate_range_start		= kvm_mmu_notifier_invalidate_range_start,
+	.invalidate_range_end		= kvm_mmu_notifier_invalidate_range_end,
+	.clear_flush_young		= kvm_mmu_notifier_clear_flush_young,
+	.clear_young			= kvm_mmu_notifier_clear_young,
+	.test_young			= kvm_mmu_notifier_test_young,
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+	.test_clear_young_fast_only	=
+		kvm_mmu_notifier_test_clear_young_fast_only,
+#endif
+	.release			= kvm_mmu_notifier_release,
 };
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
-- 
2.45.2.505.gda0bf45e8d-goog


