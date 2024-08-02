Return-Path: <kvm+bounces-23139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D12946479
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E90E1F219B7
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCC512E1DB;
	Fri,  2 Aug 2024 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R+EkXq70"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975DC763F8
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631149; cv=none; b=X7WiF+K4LtN/KIYQMi6ZcsAo97GBgt10plJKpuD4ww1h/scMITWBmOPRrML9muynJAkDRnjIyWJkS0LgtM0qUfGQWC1J9cIkAZy+BuvSDKS/NaaxTVHi8BXDkYc/LO9vmLj14HcB+oClB/TL8lxk9sRV/YNQw4bwA7iep5f+4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631149; c=relaxed/simple;
	bh=wK7gvcPluzFLYAgCx110aK6DlBTtzRCvOU4RMwEP21U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eskHsB2J+FNMviNFGQI04anAlVBrZL9i315U4fqUdDMo1AhGoQvh8sp7go9wZxbtosWNwHu7kYviIhsj1uViFfQOICBsvp7cLxbaBbP021SqckAI0ilV/WnycORigCp6gGe8XhJX3JyKbw+yMqPvznT33/n0EzuB5CaMWhUlu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R+EkXq70; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb696be198so8773111a91.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631147; x=1723235947; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lhZfJ+eif378+aP65STvVCIFX2Uzw5vooug8NPmiLuI=;
        b=R+EkXq70xPxurkb69ywwZXuXnOBR2Pzj0swqypYlxehccYz4qgsFwP/YLnpjdp13KL
         q5dIdLMgU12U8CEvqRLqdwzHA4S9Um/0YWSP04taZZhdIFvIUauEFrOJgWu63BlgHzMG
         HSMIyyO1pEu5mtcygRxGuA3rmIof6Cvf5Zw5oUnawA18c+Uc1fJq9Vhw0eNhhHhwAbDo
         ieqJKLpfEJ2pBHZZtLfZ5jhifH8lfI2WQdvardiE1XZA/KnJTTSlMCTSiubfqsLomH4e
         9EsIPiYUOxzuG+T2MdOakNpCQ+zPDO0btXvHraEMIWWJdTLboKJ40RHO55pxCRQSh/g5
         Y5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631147; x=1723235947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lhZfJ+eif378+aP65STvVCIFX2Uzw5vooug8NPmiLuI=;
        b=T9qam6FjzAr6CHC+Qv35jUdXZD9TrXeoeEOJo4M6nePm+G9M9HLos2xyAz/KNZvY0T
         d6pnyDoWGx3ThXcqyYMsI0+5vZdxYB3BlqbYoCix0QiMwL4cu5A0Dxfe69viDqoABqIb
         /7ukv8iIFR7QrCcn76+4/bNqsr0maGs6vae2xblgGVijACxY7hrijXonJf1lO1HzUUJ2
         5TIw5CpCZ10Oi2uv1dnEGWk4HIuNglhdXjOO8Wz4bS5tc9R79Vw1q1rALIbTNjZirY7n
         tUA2PPwog19ZNB4CTo/QPwjUxO8B1udUOBG/Q2N/5zMgFKJw87tdG+1tfeI8Fp6G7P/u
         tQeQ==
X-Gm-Message-State: AOJu0YzTjgbXJnD8PEPmD40DfHFp1A/IADBgBGyyJi4z/CxjKR7IAnze
	oZGjAF0tpkpsRK69PbAHz2fvynsL1eU/MRVNH2vMTGdqXsLJZ04fEy64ipd7N/xfY23KXVtQyL1
	D9Q==
X-Google-Smtp-Source: AGHT+IEBDd6K3pOLPAqR+BBCXxX6Cd9PwpLbhI/q8t6tG4WEhlza6f+vxGhPQHeXbKP6WWFy3TfBCoa51nI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2305:b0:2c9:5fae:4f80 with SMTP id
 98e67ed59e1d1-2cff9570addmr120536a91.8.1722631146764; Fri, 02 Aug 2024
 13:39:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:38:59 -0700
In-Reply-To: <20240802203900.348808-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802203900.348808-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802203900.348808-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Drop pointless "return" wrapper label in FNAME(fetch)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the pointless and poorly named "out_gpte_changed" label, in
FNAME(fetch), and instead return RET_PF_RETRY directly.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0e97e080a997..480c54122991 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -646,10 +646,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * really care if it changes underneath us after this point).
 	 */
 	if (FNAME(gpte_changed)(vcpu, gw, top_level))
-		goto out_gpte_changed;
+		return RET_PF_RETRY;
 
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
-		goto out_gpte_changed;
+		return RET_PF_RETRY;
 
 	/*
 	 * Load a new root and retry the faulting instruction in the extremely
@@ -659,7 +659,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 */
 	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa))) {
 		kvm_make_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu);
-		goto out_gpte_changed;
+		return RET_PF_RETRY;
 	}
 
 	for_each_shadow_entry(vcpu, fault->addr, it) {
@@ -699,7 +699,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * protected is still there.
 		 */
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
-			goto out_gpte_changed;
+			return RET_PF_RETRY;
 
 		if (sp != ERR_PTR(-EEXIST))
 			link_shadow_page(vcpu, it.sptep, sp);
@@ -753,9 +753,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 	return ret;
-
-out_gpte_changed:
-	return RET_PF_RETRY;
 }
 
 /*
-- 
2.46.0.rc2.264.g509ed76dc8-goog


