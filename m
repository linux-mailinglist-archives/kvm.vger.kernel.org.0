Return-Path: <kvm+bounces-22411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B19B93DBE7
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF5671C21799
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AE518413D;
	Fri, 26 Jul 2024 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEeqY9bl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B074218410A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038059; cv=none; b=doJgkwJnWP/F9f+rMVn76TYPJGvqAgYVEwHOErElazG52Lq1z4Kcw4kAicp8TYctHq16gejXn2sbQY4PTaAriGtU1YXDye0W0sTv2HJQ2I+601azOHccYQJw0bfnpavyLCWXkBLlWIHVFUN1FF/wWKdvJtap0Ugumn4Vwi2ou8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038059; c=relaxed/simple;
	bh=hkAHN3MSFE4PtSlKJPDsUtFG5ZVNRUuBMTGsadq3yME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HZuEBBvaHDWQLusMd1qaQ5EBXj5oSh930879uuWF6Uiuy97+ukjpo49Cz+p/CGo/MoAp1Dj7fWhoERd+bUZ6s1cUD19yoawWeU0YwD/v/94hWBLimbZpI0/7bMdREGnM+CXlcuXxrgjNhPfoTF01t6jUtO8TAJJgiOqMcOlLdCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEeqY9bl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd9a0efe4eso11319165ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038057; x=1722642857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l9BW/dK5c/4ryaOpC0RxFiUBYVnD4MPO1UqGokFlyv8=;
        b=LEeqY9bltXOZWjLYoMQlFaufi9j1THXUXcixDH7CTGZDdWho8QRTPu8BDeSK93KfeM
         At5khpGNbLtc36mPK7S9WcFSO/Y0vDQuv8TM1Dlqrzh4txI0tNimo/GhV6DrS504/Yio
         oUuqKDtxGDdy6bpZMiwDq3gGcKMGS11jJBF2PWQ7oyAb+uEvXZ7a7fZLBpd9VYH8Nzh+
         Lz8Pwtmwnh8d0zLKaTItr41SldeCJDQelAfHgPBCZwwf0QY3XG5DMZ2D33dI8tQViCK6
         frW7Cs8DS57A0tq2rZwEF0bRCF34+eJAZA8ajX5dcSJlL40lDTfn07IEdMFMZ7wAl5ob
         c3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038057; x=1722642857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9BW/dK5c/4ryaOpC0RxFiUBYVnD4MPO1UqGokFlyv8=;
        b=qDlV3qIRUs7FpIoVTCCNFKNqtLQdq1EeRR+wCkCvMv3GGnZDonwKjoFGNhbSEuACi6
         0R7RTipjm/xIRxzTRNmOnD0aHmVOIavqAQNAQdClIzp23p14WZtSsIZ4KEEYSqvbnppW
         pug7nIlRozuJ278d/4ClbTyPNswNJQxb2Srecoepv/s9X8gDqfWzHDgjqEYpT6u7t05H
         Ml3b4oFWA+eY6Jg5cHzTiIyx4aYAOWfKTLiR1ClJstRpDwp3uEp41BYfbH3MP1Nwfe0Q
         tPT0104trsxJxStJeWouz31Z8gY2tYqzp8BLfDXvlRO77oGhZvhuPkmWYKar6QEuqNuV
         qsOw==
X-Gm-Message-State: AOJu0YxzlX/YGziet/dEeB/lOjy8I9XtyFlHOYQexmhB47NG8ejHGw9I
	sICQOqdaqaPp3dfs/FORuKkqanJkbA5iSXPXyzhw68CNN/tnU1qrnkus8JRnvsXZ2sxihynkKer
	4SQ==
X-Google-Smtp-Source: AGHT+IH3COIaUp2rXSDrmiVRXNOzjzCRiof8RV2PU1lQ3pUgA2jXVKIIsmrd9aJoYDTjtMdA3IOsVNqBhcc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea06:b0:1f9:cbe5:e422 with SMTP id
 d9443c01a7336-1ff0488dbf2mr744395ad.8.1722038056933; Fri, 26 Jul 2024
 16:54:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:57 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-49-seanjc@google.com>
Subject: [PATCH v12 48/84] KVM: Move x86's API to release a faultin page to
 common KVM
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

Move KVM x86's helper that "finishes" the faultin process to common KVM
so that the logic can be shared across all architectures.  Note, not all
architectures implement a fast page fault path, but the gist of the
comment applies to all architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 24 ++----------------------
 include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 95beb50748fc..2a0cfa225c8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4323,28 +4323,8 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
-			    r == RET_PF_RETRY);
-
-	if (!fault->refcounted_page)
-		return;
-
-	/*
-	 * If the page that KVM got from the *primary MMU* is writable, and KVM
-	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
-	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
-	 * the GFN is write-protected.  Folios can't be safely marked dirty
-	 * outside of mmu_lock as doing so could race with writeback on the
-	 * folio.  As a result, KVM can't mark folios dirty in the fast page
-	 * fault handler, and so KVM must (somewhat) speculatively mark the
-	 * folio dirty if KVM could locklessly make the SPTE writable.
-	 */
-	if (r == RET_PF_RETRY)
-		kvm_release_page_unused(fault->refcounted_page);
-	else if (!fault->map_writable)
-		kvm_release_page_clean(fault->refcounted_page);
-	else
-		kvm_release_page_dirty(fault->refcounted_page);
+	kvm_release_faultin_page(vcpu->kvm, fault->refcounted_page,
+				 r == RET_PF_RETRY, fault->map_writable);
 }
 
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d2a97eb30e4..91341cdc6562 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1216,6 +1216,32 @@ static inline void kvm_release_page_unused(struct page *page)
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+static inline void kvm_release_faultin_page(struct kvm *kvm, struct page *page,
+					    bool unused, bool dirty)
+{
+	lockdep_assert_once(lockdep_is_held(&kvm->mmu_lock) || unused);
+
+	if (!page)
+		return;
+
+	/*
+	 * If the page that KVM got from the *primary MMU* is writable, and KVM
+	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
+	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
+	 * the GFN is write-protected.  Folios can't be safely marked dirty
+	 * outside of mmu_lock as doing so could race with writeback on the
+	 * folio.  As a result, KVM can't mark folios dirty in the fast page
+	 * fault handler, and so KVM must (somewhat) speculatively mark the
+	 * folio dirty if KVM could locklessly make the SPTE writable.
+	 */
+	if (unused)
+		kvm_release_page_unused(page);
+	else if (dirty)
+		kvm_release_page_dirty(page);
+	else
+		kvm_release_page_clean(page);
+}
+
 kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
 			    unsigned int foll, bool *writable,
-- 
2.46.0.rc1.232.g9752f9e123-goog


