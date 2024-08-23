Return-Path: <kvm+bounces-24978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BED6A95D9FB
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 789FE282FFD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD39B1CCB48;
	Fri, 23 Aug 2024 23:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JE8Wkgdl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21461CC14E
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457419; cv=none; b=e+F8NHHDfo9q/M6IP3wVl/M66yjn+mqjVjJHKem62z0l5v6CFj7Z9KP6OG3azB7tdcxn/e70eRc0nd7GIEB6bsaqX780BJyy2qCMuDW2FTq1XEGxWh+LtFzZvnlZR0zEPcgp6GSXuBX+1xmr6xgJDtOi8bcfEl2jGw29wj7epYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457419; c=relaxed/simple;
	bh=zHdpot0rRQyVDNMiIG5Rx0qAPITLbODwrupzz3NA1GA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XOLNVa6Bh5OPa/bgbvvJBRHbK0tpSuVLYECE0gxeNXE33MInOfwZlibabsWoBIGSL078w0P5DOU389Rgn0h2A8s/RyE8XZgV/h5zdbFUUbBbbnEUo5xhSu7ZHV7mTqtgfyPioAjQ1uE6LoaR7csadkkz2QURbPB/DmUKQ9tofas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JE8Wkgdl; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e117634c516so4230283276.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457417; x=1725062217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tK9C7H+Jo5ZSkTQ+Rj/u5LNiqXw4I6yn7QJvBCSdj+Y=;
        b=JE8WkgdljAu9QFmmiIK+Zl9ybUr6M0StdjI9vHTIGBfkbqyX5XndUAFypC3xOAORji
         rcKe7m602kKt6P7TQpKENC2wlKVgkeBdNSlz0J/Yqegx+GdzOAHsoziSV9GTXf2ZXFfq
         k1CWKSxn4kBwyCaLQHtW1qPKihdHLsL9fHqTpVqzl3Pc6g+12H7qnSeB+j7t1fTLX9Zr
         IxC6qAq+EhSAaodG1+E0KdOuBcdu977PA+D6HsSZmgqFWNQGmZ/40pyHejk7JS7dSkFi
         hNd8tRJBguuuBZtuIo6J8ii/Ri5KbJHxRE+x8/iV4VUSkybdoqf4cZWB0EPBRBkbcWye
         RILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457417; x=1725062217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tK9C7H+Jo5ZSkTQ+Rj/u5LNiqXw4I6yn7QJvBCSdj+Y=;
        b=OjibWf4j7fOLhCJpqYfi7e360ePHoAMwm39cId3l2lfzdY5PBJN1EHX9vV5JUbf5uv
         gO288IEHFhHsStsu8gfe6wg5xoefz/yqRZJ/xOidUaw5yNZRl52xkbKMw3erN8eZH2Yf
         YmNou6WKJn3/VWmNPvVh+izZHYk3Kqr+rBiEl7+YK7+EBrLNQHoxCz0WTaNl99Cflre5
         +aRnyA2p6N1NmGq6/itoZHYjpe67Z1ueQI8NOYkIMH0WUvQkI0MhiCjxGnwN/+KGihrz
         h12wlbtMFSfU3bsn0CUPxovNgqvxbe40StmEJi+PBPgEnqrEMG0kU8+K3h7lk48VX4Ke
         LKQw==
X-Gm-Message-State: AOJu0YwfZfywXHDBa8T5/HDTVe8V32PlXl4U1RpLUEvQy/WQNyPWHAxq
	e1sLn1e0msSzYIpi3QWlCqyaeicOnrh7tc3SQugeKhu4mmFSTnxVMRvHSN1c5feGRgzG3in3As8
	oyic4tJ8lQQ==
X-Google-Smtp-Source: AGHT+IHymdtkwriKWRHKcyPBdCdaXtFrh+eSQuHP6N1OeXb5SX+15GaOL1/+05hBPh88rajumOhpoeAQkLxq4g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:bf91:0:b0:e16:67ca:e24f with SMTP id
 3f1490d57ef6-e17a865aba3mr5523276.10.1724457416618; Fri, 23 Aug 2024 16:56:56
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:45 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-4-dmatlack@google.com>
Subject: [PATCH v2 3/6] KVM: x86/mmu: Refactor TDP MMU iter need resched check
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor the TDP MMU iterator "need resched" checks into a helper
function so they can be called from a different code path in a
subsequent commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27adbb3ecb02..9b8299ee4abb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -646,6 +646,16 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
 	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
 
+static inline bool __must_check tdp_mmu_iter_need_resched(struct kvm *kvm,
+							  struct tdp_iter *iter)
+{
+	/* Ensure forward progress has been made before yielding. */
+	if (iter->next_last_level_gfn == iter->yielded_gfn)
+		return false;
+
+	return need_resched() || rwlock_needbreak(&kvm->mmu_lock);
+}
+
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
  * to the scheduler.
@@ -666,11 +676,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 {
 	WARN_ON_ONCE(iter->yielded);
 
-	/* Ensure forward progress has been made before yielding. */
-	if (iter->next_last_level_gfn == iter->yielded_gfn)
-		return false;
-
-	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+	if (tdp_mmu_iter_need_resched(kvm, iter)) {
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
-- 
2.46.0.295.g3b9ea8a38a-goog


