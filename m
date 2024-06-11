Return-Path: <kvm+bounces-19277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13DE0902D96
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BD2F1C216DA
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1123399B;
	Tue, 11 Jun 2024 00:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCXwHRst"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE976FC5
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065328; cv=none; b=bWqGQB7Bzhg24iVZ/qUq8lFjynDXgFpXWtI1eTmQTfbl6LekWLoZ6xMSOk1XgdmX/fVJHIlanBRWBER1umSR4vaUcoH3Eh1uWJWPYl6KcdvBD9NfwWIlQUDg5vGtEc9K67M1fChGMpv1RR0nKmsBwRJLKeGTgRWscNLSeihH+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065328; c=relaxed/simple;
	bh=hrTHF1LPFXBYPkOeqn+Sm4a6LUN1ZOrT0EeRBRT4T7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qxLtWupzGpuqe3tob9sFvVBHc795KIdnpplujfWGnZfdpcu8Gs9xDg/D5E7qDovRaThBmck38S5oCG4G8l9hGPn1V2jqKKmSzXDm0T0tLLtbnvurccZyyFOETnjNUaFodDVw0j8V+wTwqJE+ylOtAATOahgFSX668hSecPrLncs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aCXwHRst; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62d032a07a9so9229157b3.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065322; x=1718670122; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6j3rWVw+E6yiyAll83pvyiHc59e6Q6WaEN3pW8ayg5o=;
        b=aCXwHRstM3P/cvDYwPBZtBQ8cHq5tbnCdkCqDPQ68M+15HsxXC8nKWh0FS/L2WiH74
         c0h1HyItpdC/y5wDhpHydJo2OKmF8Qkp8CCKe9d6xbsCNaUyiL9jhBLRrO04BgFBDJ+4
         G2mf7pOjglTa8c8nvmH6LHA+uFfmitFw2b/dFPgKXn+7W6tkqGYdvLkWMhZbG2grC1OO
         9u/vZxx6PTSWRNIreMu7N6OPVL4sP+hrFzN7n8ifRDaEu/ixgiSy5ZMtZj/GGQSa7M5W
         53Umnw2azVkhyMfnXpHPhqY93pIox+gzSQCz0Qt8ifQQHjulRtXVbIbjGySsefGmmX1W
         LZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065322; x=1718670122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6j3rWVw+E6yiyAll83pvyiHc59e6Q6WaEN3pW8ayg5o=;
        b=wia4nVmReq8RbmL8HrB6gxN4zzqKpcuy0NNBuXDhpak1CfBDKK3BOjDJRnblEK8GVJ
         Myp3b2PwvYV4wqa9zV37fUnKRBpkpkbVVr2O66XRL2e9tuv+XI0B5Q9OHe1Ft5vtnUyB
         m3Wp7BA9ewLmATPl9mtEBJHJ8gkGrjbYhImZSZw9f3Mlh07e0RWOX6/hjupqpDFFjjbs
         w3kt4jGLgZOoxCU1sI9F3gLRLO0Z3XxmjR4HcXgWWE29drOxNuyA+SSX9lMbGMjMu3aq
         Cys/dk01uCI6AUuVQ5CWkMU8juZnEsQsGoq4X5qYj9faAPNZpddndu5gtrtrcRZ4o+aB
         k7dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRjf/3Lj2v0nwKMrEPutDZft+KlFTHmtsRCkI78gtH89u4lZYPVwPyfXHboi3yLTFCGL5n/ffxLmp/xXEOb1exXeVa
X-Gm-Message-State: AOJu0YzA/7kj9+Gj65NojPlyITQNDGkBsae0Qps2F2ljIE5dROh4G6GM
	A+kFlpw7SykW0UGtDWqyS4122vamLblctwmlQkrhKuFvb/4tQpqssi7SpWoxb9ptQTSJGv6SlrS
	M3KoN+jIE+9Fl0FR6Yw==
X-Google-Smtp-Source: AGHT+IEvrN0k+l/fqR0GYBVcFmKI7zO7AJD796Zxk8tVrT0hIaj/Sm704UQ/Nq6b1QsHmo+//ovsajrvliWZ5C+2
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:4485:b0:62d:fbf:920a with SMTP
 id 00721157ae682-62d0fbf9666mr11256657b3.10.1718065322252; Mon, 10 Jun 2024
 17:22:02 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:40 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-5-jthoughton@google.com>
Subject: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
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

This new notifier is for multi-gen LRU specifically, as it wants to be
able to get and clear age information from secondary MMUs only if it can
be done "fast".

By having this notifier specifically created for MGLRU, what "fast"
means comes down to what is "fast" enough to improve MGLRU's ability to
reclaim most of the time.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/mmu_notifier.h | 50 ++++++++++++++++++++++++++++++++++++
 mm/mmu_notifier.c            | 26 +++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d39ebb10caeb..2655d841a409 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -61,6 +61,15 @@ enum mmu_notifier_event {
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
 
+/*
+ * Bits in the return value for test_clear_young_fast_only.
+ *
+ * MMU_NOTIFIER_FAST_YOUNG: notifier succeeded, secondary MMU reports young.
+ * MMU_NOTIFIER_FAST_FAILED: notifier failed.
+ */
+#define MMU_NOTIFIER_FAST_YOUNG (1 << 0)
+#define MMU_NOTIFIER_FAST_FAILED (1 << 1)
+
 struct mmu_notifier_ops {
 	/*
 	 * Called either by mmu_notifier_unregister or when the mm is
@@ -122,6 +131,24 @@ struct mmu_notifier_ops {
 			  struct mm_struct *mm,
 			  unsigned long address);
 
+	/*
+	 * test_clear_young_fast_only is called to check (and optionally clear)
+	 * the young/accessed bitflag in the secondary pte such that the
+	 * secondary MMU must implement it in a way that will not significantly
+	 * disrupt other MMU operations. In other words, speed is more
+	 * important than accuracy.
+	 *
+	 * Returns MMU_NOTIFIER_FAST_YOUNG if the secondary pte(s) were young.
+	 * Returns MMU_NOTIFIER_FAST_FAILED if the secondary MMU could not do
+	 *   an accurate fast-only test and/or clear of the young/accessed
+	 *   flag.
+	 */
+	int (*test_clear_young_fast_only)(struct mmu_notifier *subscription,
+					  struct mm_struct *mm,
+					  unsigned long start,
+					  unsigned long end,
+					  bool clear);
+
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
 	 * paired and are called only when the mmap_lock and/or the
@@ -383,6 +410,10 @@ extern int __mmu_notifier_clear_young(struct mm_struct *mm,
 				      unsigned long end);
 extern int __mmu_notifier_test_young(struct mm_struct *mm,
 				     unsigned long address);
+extern int __mmu_notifier_test_clear_young_fast_only(struct mm_struct *mm,
+						     unsigned long start,
+						     unsigned long end,
+						     bool clear);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
 extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
@@ -428,6 +459,17 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 	return 0;
 }
 
+static inline int mmu_notifier_test_clear_young_fast_only(struct mm_struct *mm,
+							  unsigned long start,
+							  unsigned long end,
+							  bool clear)
+{
+	if (mm_has_notifiers(mm))
+		return __mmu_notifier_test_clear_young_fast_only(mm, start, end,
+								 clear);
+	return 0;
+}
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
@@ -612,6 +654,14 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 	return 0;
 }
 
+static inline int mmu_notifier_test_clear_young_fast_only(struct mm_struct *mm,
+							  unsigned long start,
+							  unsigned long end,
+							  bool clear)
+{
+	return 0;
+}
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8982e6139d07..7b77ad6cf833 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -424,6 +424,32 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 	return young;
 }
 
+int __mmu_notifier_test_clear_young_fast_only(struct mm_struct *mm,
+					      unsigned long start,
+					      unsigned long end,
+					      bool clear)
+{
+	struct mmu_notifier *subscription;
+	int ret = 0, id;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(subscription,
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
+		if (subscription->ops->test_clear_young_fast_only) {
+			ret = subscription->ops->test_clear_young_fast_only(
+					subscription, mm, start, end, clear);
+			if (ret & MMU_NOTIFIER_FAST_FAILED)
+				break;
+			if (!clear && (ret & MMU_NOTIFIER_FAST_YOUNG))
+				break;
+		}
+	}
+	srcu_read_unlock(&srcu, id);
+
+	return ret;
+}
+
 static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 			       const struct mmu_notifier_range *range)
 {
-- 
2.45.2.505.gda0bf45e8d-goog


