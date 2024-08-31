Return-Path: <kvm+bounces-25605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE0D966D64
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 727B71C21CC2
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B968F16D9AE;
	Sat, 31 Aug 2024 00:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mfp6PDTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966E7111A8
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063385; cv=none; b=MfPtQ6LUjo/axYXwLWQxkDJyWSSH6gydzI33U+ZtRVwMzaSQKNpN+amOxrjoPtDvTmfU4Yy5YJ9vyYTsFe/FM/PJZMnnQvTwBhNu6KlvxaA8ztQ9or2SstlETiL1q51RnPamY8SNHOxhC1V/oXfCdoE3kVM0uAKXrRVyb7eQQQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063385; c=relaxed/simple;
	bh=0jH6aGUfJ6nXVSowsfjSHGcTxPjzpE2W+Gg/9Z921x8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lKv5SEM0x6yBdPqsaRJsAt/stUKp52sPi8czfAFUOeIiAOK6Cs1XcUhloQyBiknuO5ZvgcILJ/vUJxbb3rqLvA6PzEDOI8ZM7NdGIIfLAr73ocbOjyF1m3SnnLRyAjMylpaqCqaBSlvOBch/alzfiMZsitVCTUzqQcjAHXAGolg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mfp6PDTM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7b696999c65so2107869a12.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063384; x=1725668184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DYB5QhEfP12JFKsEt0nbZ8L014oKTm3YJf7/Et6tdYI=;
        b=Mfp6PDTMjZtwF95ui7Km+FWChJKeWWZT+yE1ZWOqar5RRPsgXglDh7YnKZ8e1tUCdS
         Z1YKJw9s4gmLmacMPNxmIhhSyT91I3w6EkkD2HKMwaE7/HIzS3PBsPXgR2lT6XllzoQ8
         wy3Um6tjd+5x7vh+J+57J0YS7Ktjjb9LAhZ5IoAJTjg8VqN39mTZ1j9F1xHU6dAG6qXj
         jsHPOd5/6GdpTV0ljohtsWiuZFd4PhIs1NZkBrHGoJznxYKVXI2cB4a3iScfLu5d/IL6
         i7fvHI3HuFxjj4PWMUTAVXp2o2vMJlhLhD2c9Ge0hhVi7xnIF5FVkhl4LnqK0njd1jCj
         0HKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063384; x=1725668184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DYB5QhEfP12JFKsEt0nbZ8L014oKTm3YJf7/Et6tdYI=;
        b=E6UoW1kfcOlYCaONYgnsv1JhaHCNnP0Jx1z+jJyEtNz/IIQ0erSGGPTx7b6zvBwUG1
         Wh951dNNmd4z0d9CV3CblZYPLtOs4hG52RmMLgaS6SVoAexQgAcERzq1MfghNxbllq1F
         nYhJKlC2lmtzEhfdYKmW8we1SXbkFpuXT41Q1AApvfQAu7Wr2TseO78kST3S32NtpCkE
         1nagC2PVXNRsfGHZdkuE2HP6hQnZPN+fa0uwCWQ4l6BJKqpix974nWPe43t2CmWH6YJ8
         WSc5a5ooESC9Po+0+XxjF7lvBceM9yBjPIdUrofLCarZP1F/cs+ucvwNBqgEUJqSE833
         ONFA==
X-Gm-Message-State: AOJu0YzEJa6QBjl64+S4QXBZKEqK/OgtEQXl+peQDdjDwFslb0Fubf/q
	mDBg+0JmS8IYBcLxNfy/Iqg1o8HaaBQxm8qYofXalMmNxISD8aAWOHGBassUZSyPMlEDm/uMpNm
	eVA==
X-Google-Smtp-Source: AGHT+IG9Caf/Ygx0zgVnN7lUuRoljiEi/rAgaAN7Ize+jtz+IuGMkKmmeQheo0RyBKXbT93DJK9xVvlhHb4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c7:b0:1fb:716e:819e with SMTP id
 d9443c01a7336-20527669412mr2026595ad.4.1725063383865; Fri, 30 Aug 2024
 17:16:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:36 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-22-seanjc@google.com>
Subject: [PATCH v2 21/22] KVM: x86/mmu: Detect if unprotect will do anything
 based on invalid_list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly query the list of to-be-zapped shadow pages when checking to
see if unprotecting a gfn for retry has succeeded, i.e. if KVM should
retry the faulting instruction.

Add a comment to explain why the list needs to be checked before zapping,
which is the primary motivation for this change.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d042874b0a3b..be5c2c33b530 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2721,12 +2721,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			goto out;
 	}
 
-	r = false;
 	write_lock(&kvm->mmu_lock);
-	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
-		r = true;
+	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa))
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-	}
+
+	/*
+	 * Snapshot the result before zapping, as zapping will remove all list
+	 * entries, i.e. checking the list later would yield a false negative.
+	 */
+	r = !list_empty(&invalid_list);
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 
-- 
2.46.0.469.g59c65b2a67-goog


