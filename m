Return-Path: <kvm+bounces-27520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E59D7986A7A
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9316B1F22ED9
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF9E185935;
	Thu, 26 Sep 2024 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hkFfrtNo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88766175D42
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314521; cv=none; b=S3AwIy3c+UUvj6oIzdWhd2baHziFWqiA6zSzzZo//k2xqTR0ItJWqnRJgYRKogGcMtSK6xJvYdsJHWM1OLty0Qdan9kkX6Sh2nc9KmFrSKAh4PWz2dJsSF/fH8CbPsHbIDWFWoKvWMJ6TaJCYhklLC+kzR3KRANMLKrB6SxBrCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314521; c=relaxed/simple;
	bh=LXeRxqanC6hgm//uBKuWRGkPuW268d3E0Jk8XF6EZn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OsbO/jZosSxi+xG7RCOLElKFlzPdVjMTWPJ70nkQJ8mfH2AXOiEpH5kdpn59/vnSdLUR1j+iWsZjq6uw1cIeAT015S+1G+dX1KwTLSkgxjtvD/SdAQMfhPxEiEckQxaS4fxnMsfcg1zWunXp8unXURiQuPlAe79sArSs2XYVeKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hkFfrtNo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-69a0536b23aso13421507b3.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314518; x=1727919318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CIRgMt/tPt8dDHjlNVeDudvk1PSxwGvmBpyKYz5f4us=;
        b=hkFfrtNoec1yRcXv24pnRpLHXmbsLnZ9lnI+bVu4IWbUK7jtup7ZDPU2kEYOn1cCHs
         xU8CfMNAGzvjiLuastARaTCBgxvkpyUGOVrG6SN4PtBwZnHd4CGdRE0yaEACB9hGbIkf
         h95169iSJMWvN3gydyhMQIe+25D2Je+ZLNOWv8u2M7TXPACcoB7GnOLmuTEmxG9ZC+tk
         JG6uhOMzx/TPEU7xQeerGEFDJNKMQ8ZrW23AIp5FavhV8RFwWtNG6Fai9MpGbzAsEE8B
         4jvxsUZe04qnggdR93yWRirPG9Vub51uZDBzSt+GIxPvs2+LkDnaU+wADQDwzYf11hGj
         KzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314518; x=1727919318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIRgMt/tPt8dDHjlNVeDudvk1PSxwGvmBpyKYz5f4us=;
        b=DvW7a0b0a7W0pM9rhdBoonUTb/E4Z9tSozZHjOFCijKxEe5oDrW5Bi3xOmXtMNFeyN
         +8rGx058Zr++EshHlkzZqC8ntnRLECB+akGIHgQdl51KG2Uwu1A6sZKxBCMk8kTR3obl
         aF7iyOqXdGq3ls1m/DS8h0EOPaXN5ZvZK7YcSqQY0I1frolPXxW1x7BYnwgA5YjAJkWt
         ZqrqLP6eDrsnLjWK9XKg15rYSi0tKzwudv+d/obCjNRwvBoijwKDIZWU1Vg/96QTgqs8
         Pn8IQh2k4a7JO4nuwnuHehlB8kRCu8rkBp0jVO8FlfG8F4qM7XwLrl/PDK6upVwGYNz7
         3mmg==
X-Forwarded-Encrypted: i=1; AJvYcCWH+WhGQt5z+lRvZMf5Uq6JoESjNZRl6Ui9EyUVRDZuFZ9ct9XMfM+4WidVee6j3KqFJX8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9vunVb+qaBDbdw8/k6Fle8c8JmGAggzlNDEhHcIgbMtizspR8
	T//I1OSIdB3mrpdOTM2AmEZtDRFu9+JA08jG5b8G5npwC3Uwnr91vHdV58wRhodsqcchoHypujm
	MGs6IC6P+Cs8FCxmtpA==
X-Google-Smtp-Source: AGHT+IHo9npkiN5cwqAiCiI3e58k0AahBEai2pKIEYXOCcGxS2Z6C3puLSeMWFdZt66z08Hill7horZ6pvVyPTNq
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:4a08:b0:6e2:371f:4afe with
 SMTP id 00721157ae682-6e2371f4d7dmr1417b3.4.1727314518344; Wed, 25 Sep 2024
 18:35:18 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:51 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-4-jthoughton@google.com>
Subject: [PATCH v7 03/18] KVM: x86/mmu: Factor out spte atomic bit clearing routine
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
follow-up patch to enable lockless Accessed and R/W/X bit clearing.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..ec171568487c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 	return xchg(rcu_dereference(sptep), new_spte);
 }
 
+static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
+{
+	atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+
+	return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+}
+
 static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 {
 	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
@@ -65,10 +72,8 @@ static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
 {
 	atomic64_t *sptep_atomic;
 
-	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-	}
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
 	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
 	return old_spte;
-- 
2.46.0.792.g87dc391469-goog


