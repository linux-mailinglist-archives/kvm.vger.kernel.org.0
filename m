Return-Path: <kvm+bounces-19365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7981E9046BB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF2F1C22E42
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87A83A8E4;
	Tue, 11 Jun 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cqv7ATU1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41F215531A
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143527; cv=none; b=Ef1nBZkaVCajUrRG9fMDoUayH+/cf7dOB8rGBaWgAX/y7mIR8axcz17Usk+QSFEe6e/d7ElNnzGb240szBTv0CBusGaiigJ28qIqaBArHTEgQ9/hCty2yhg7Wrk+L/mBUyDNKJbLymfN92oQwLYqx3utSGbY24Ckeonk+qKSE+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143527; c=relaxed/simple;
	bh=eJ//Sfy8cAge3Wfm8BzQCUM7ZYsp+rvNBG0LK8AgQRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lrG4BXFAi8wxOLXBx/LaMlLVSO37CUO2hkJjkjjJPPOCyWIeUdwQfweugiyAkCAUlr7r09HvMuSC3OXjdwYUu+TKN8CTFCQOXW6rnxlLXbIYA6iF2U1chzRsvGoCvHeNpdJw85oY6Ahf5paEe/YwG+wfQBreMpaUgUIDcEeQ5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cqv7ATU1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62d054b1ceeso53039257b3.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143525; x=1718748325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DUWBsEFIwb4pTI1yX8yUcgSMBcKADICY2lFC0KxNmpc=;
        b=cqv7ATU194uiBlQjQZZd+xOps2lxSHy2we/c59zI+TP+koqfDuk7FgUXtNU5IM7W4z
         xLAtEejGYqgzs94XtwsUVnnvbWGcv3F1heZPI8KFkrmc8vPEKrqoj5r588F/0yeZrqn4
         XXBupuVKs6r4dRqQCN0/44mKg62yvwVGL0mb/fDUZDfcmeo75n+iitPyzXh2Ifcm97Us
         QMiq1IpZ8+cL+rVhphaghLuv1S2tCAb86RsTQlLSQ4T3ihWt1dh0fsjakUuwjB+IDwuH
         dfnbaF1sL99pIeutXOHgIFnefE2CUGxZkAE8dyVBGYZ7LAutQW6dvCptCFfOHpzcZKUd
         3dqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143525; x=1718748325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUWBsEFIwb4pTI1yX8yUcgSMBcKADICY2lFC0KxNmpc=;
        b=U/AdHsPnDiZ5B6WQuJRE5/UPjSbw06kt7teWCfl8NVgYEpPtlEnt5zS5USTAkHH2LW
         SeVWvmqZzOzz1yBCP9t6qEYiN5aJ6DaRiyKRKTXUC91Igo2c8324t5jbudXj9Xp8n6pu
         B7E7yD74p5OUCZP6egXmoQDSbvAKayTf6Ga+jeEuxcONXSEXkgPGjalLW6lpjrf/W+xq
         rwUNefZe1keC/Bl74ElEsF39FFxgqNH8HULO9fExH5ekYjc1RcqhGHDjGNnMMRefYKzW
         +r/VgJB0pliUrWPSbJ22DCyYWC7q5Rx2mTly+QHWWoSijrUhlgT8lFIy8w9Ad49LW7ep
         jCgw==
X-Gm-Message-State: AOJu0YyECNzeREW89BfqxNiXbDOYLQ7uoIjHqIE3iJ3IxC/jmdrAYTdb
	UtUKyJiE+g9JPMJSj1jXOQIML7SaUryY0Di2PnS42em8r8TcRs5uOXadtHOeZp2FlHLTgMu/BL6
	zqKdqEgsnjQ==
X-Google-Smtp-Source: AGHT+IEtw+dbgGqLK+TqohKs4ltrJ5dY3k8g7GlcbbT36CmgWjab+PiCCe+vf0qxrWOERhHkhXBIgaF9FhWagw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:3810:b0:61b:ec22:8666 with SMTP
 id 00721157ae682-62fb6c1f4damr216507b3.0.1718143524510; Tue, 11 Jun 2024
 15:05:24 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:05:11 -0700
In-Reply-To: <20240611220512.2426439-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611220512.2426439-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611220512.2426439-4-dmatlack@google.com>
Subject: [PATCH v4 3/4] KVM: x86/mmu: Unnest TDP MMU helpers to allocate SPs
 for eager splitting
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Move the implementation of tdp_mmu_alloc_sp_for_split() to its one and
only caller to reduce unnecessary nesting and make it more clear why the
eager split loop continues after allocating a new SP.

Opportunistically drop the double-underscores from
__tdp_mmu_alloc_sp_for_split() now that its parent is gone.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 48 ++++++++++++++------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 09c6b16630ac..7e89a0dc7df7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1339,7 +1339,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1356,34 +1356,6 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
 	return sp;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
-						       struct tdp_iter *iter,
-						       bool shared)
-{
-	struct kvm_mmu_page *sp;
-
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
-
-	rcu_read_unlock();
-
-	if (shared)
-		read_unlock(&kvm->mmu_lock);
-	else
-		write_unlock(&kvm->mmu_lock);
-
-	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split();
-
-	if (shared)
-		read_lock(&kvm->mmu_lock);
-	else
-		write_lock(&kvm->mmu_lock);
-
-	rcu_read_lock();
-
-	return sp;
-}
-
 /* Note, the caller is responsible for initializing @sp. */
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 				   struct kvm_mmu_page *sp, bool shared)
@@ -1454,7 +1426,22 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			continue;
 
 		if (!sp) {
-			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, shared);
+			rcu_read_unlock();
+
+			if (shared)
+				read_unlock(&kvm->mmu_lock);
+			else
+				write_unlock(&kvm->mmu_lock);
+
+			sp = tdp_mmu_alloc_sp_for_split();
+
+			if (shared)
+				read_lock(&kvm->mmu_lock);
+			else
+				write_lock(&kvm->mmu_lock);
+
+			rcu_read_lock();
+
 			if (!sp) {
 				ret = -ENOMEM;
 				trace_kvm_mmu_split_huge_page(iter.gfn,
@@ -1463,6 +1450,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				break;
 			}
 
+			iter.yielded = true;
 			continue;
 		}
 
-- 
2.45.2.505.gda0bf45e8d-goog


