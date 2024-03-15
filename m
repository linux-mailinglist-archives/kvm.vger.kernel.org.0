Return-Path: <kvm+bounces-11945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4566287D724
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0198B2847C4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3587C5A796;
	Fri, 15 Mar 2024 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nx2xfPQs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47D524C3
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543951; cv=none; b=NaFZZ6jbJ9sBKBBUfELgjFjx4pMqyztjoEKL2l2Jhp+E2SLu8hcQAhmFgbRp2hGYtibp2BO5/v36WXSLfXUMQ9WhmHhuKDySBkjTF+GpxVF4wTm8/uzwNM3YAXsl0qqR1KxUfjG0gtkafX7ZZtYoQIDrb0pUgcUJeNyfIei4L9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543951; c=relaxed/simple;
	bh=Cov+K61W3yOa0ObcP5pESyRYZi1gcNyUFK/aJ3wNmNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=orI423zGY9g3PRfw6vqnyHOs6WFA/8AUtEnNkJrLbzhz/Z3mr0FW6ypf/ASvXYvatIJGcTSUJE9coP/ZtfqsdTZjkaXsEIKrNYbdkuuCptmO8EHVJx2Q9SScYClidQLSGrfoffMYsdrnt64Q1ciYVo6FSXhOvrpE/Vo7Fu5WjXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nx2xfPQs; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso4086525276.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710543947; x=1711148747; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jq6dTiQO4a7GzTIlCZ/7Sr+NoQ1v4+WQzk26lh1YhWg=;
        b=nx2xfPQsmrlIMvymOTajI1vWZCq3JXkc3DqiDKzlAVi1Boe7XR5uZRuO8NyXiFMz0a
         KUBiattLFvFkbUF8Q53ZVNTJ1x2Gbk8EdFPh072SlxwvUd+hcgOHhfpjXKdkbqckEhu/
         Uo6yqc3hMx6i6ed6+08daFtEobEdnkoXExMwExvjzIh1lbuvr7MWyLJRXKIkR3/RN1a4
         0fQxGqxx1gyPego0cypJil5xXHC22AFRnTaX+scyc0z8FtZ1lRa68wV2Zf8spscYqP8c
         UhAksR1hFFzrfFUyZd9dYIPwENlWDSeamzOZlWvqcLkE4sNCn7xtA63Ry4Yw1IA6JGj3
         ARzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543947; x=1711148747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jq6dTiQO4a7GzTIlCZ/7Sr+NoQ1v4+WQzk26lh1YhWg=;
        b=gkbwMgc2NtzoYz0c6TUXUbXyoH81wWdUbYVFmoGnuTB0AjQb6aOcSoMIr8dP3Fb387
         LXr7iENbjoc/mWtIAHWpdG/S4wUPIvcK1/1+E+lMzdJBIhbhwwlGIJXpK09qIgDAyTEA
         13bydhuhwwhnJ0CAg7PU1ccSjRY8780iNJ7znf0R978qDQba5L9jsMTtLpACZW/pPHdH
         4lVaUrV1gHVIG2KpM2XsMBSscY2aTUwf0HLlqLrhyWkg4WNkPVM8v/4BYh7u6Z66FPCV
         BxW/6GKWPWH2GP4xrnk24OhY/g+Cqro0Qxs0MKdm3y3i+ncwNlPUhPNKn4Kq4vjIyUvi
         h4Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUcza9RWL4bw1h/LIjuPu5n1VSHIvOFOJ+ejCy1Ufh6mr7cmwqsqJVrsPU8ecRXFRkcyj7uxIuXfzIzwocLphIEn13E
X-Gm-Message-State: AOJu0Yw4ebqF3l0ZGdSkFuI/0VSuiOsBLndJItGwfZfHqHGKuU6R8Dgn
	hvFbpnpGeXVpcyXxnqCKmmho17e+MhH0T/FHgGansdp+ipubo/MWJd0o4RaxWL8sbYNAgRIWiZi
	kJ5CWEnaCww==
X-Google-Smtp-Source: AGHT+IFwIWtAdHF9qqf2R5hkb2fp5Hri3uJzjkEaEVE9KnILaqL8bJMQ8Iv75zE4rNjwop2zjTqbg6D2eL2TPg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:2301:b0:dc7:865b:22c6 with SMTP
 id do1-20020a056902230100b00dc7865b22c6mr338437ybb.8.1710543947439; Fri, 15
 Mar 2024 16:05:47 -0700 (PDT)
Date: Fri, 15 Mar 2024 16:05:38 -0700
In-Reply-To: <20240315230541.1635322-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315230541.1635322-2-dmatlack@google.com>
Subject: [PATCH 1/4] KVM: x86/mmu: Check kvm_mmu_page_ad_need_write_protect()
 when clearing TDP MMU dirty bits
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Check kvm_mmu_page_ad_need_write_protect() when deciding whether to
write-protect or clear D-bits on TDP MMU SPTEs.

TDP MMU SPTEs must be write-protected when the TDP MMU is being used to
run an L2 (i.e. L1 has disabled EPT) and PML is enabled. KVM always
disables the PML hardware when running L2, so failing to write-protect
TDP MMU SPTEs will cause writes made by L2 to not be reflected in the
dirty log.

Reported-by: syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900d58a45dcaab9e4821
Fixes: 5982a5392663 ("KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot")
Cc: stable@vger.kernel.org
Cc: Vipin Sharma <vipinsh@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6ae19b4ee5b1..c3c1a8f430ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1498,6 +1498,16 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
+static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
+{
+	/*
+	 * All TDP MMU shadow pages share the same role as their root, aside
+	 * from level, so it is valid to key off any shadow page to determine if
+	 * write protection is needed for an entire tree.
+	 */
+	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled();
+}
+
 /*
  * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
  * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
@@ -1508,7 +1518,8 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			   gfn_t start, gfn_t end)
 {
-	u64 dbit = kvm_ad_enabled() ? shadow_dirty_mask : PT_WRITABLE_MASK;
+	const u64 dbit = tdp_mmu_need_write_protect(root)
+		? PT_WRITABLE_MASK : shadow_dirty_mask;
 	struct tdp_iter iter;
 	bool spte_set = false;
 
@@ -1523,7 +1534,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (!(iter.old_spte & dbit))
@@ -1570,8 +1581,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-	u64 dbit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
-						   shadow_dirty_mask;
+	const u64 dbit = (wrprot || tdp_mmu_need_write_protect(root))
+		? PT_WRITABLE_MASK : shadow_dirty_mask;
 	struct tdp_iter iter;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -1583,7 +1594,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!mask)
 			break;
 
-		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+		KVM_MMU_WARN_ON(dbit == shadow_dirty_mask &&
 				spte_ad_need_write_protect(iter.old_spte));
 
 		if (iter.level > PG_LEVEL_4K ||
-- 
2.44.0.291.gc1ea87d7ee-goog


