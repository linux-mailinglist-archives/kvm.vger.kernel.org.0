Return-Path: <kvm+bounces-37192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5654A268B5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81C9318850E6
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1651D86323;
	Tue,  4 Feb 2025 00:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTg5c4IK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBE270823
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629660; cv=none; b=T91HCgNMDaaKmn8VRkC0/GDNR0kBST62RvHW9ti0Hpjfc6phfDTGaRMD7VU9QuqgMaYVLc4WbsEhujdDdPpSYmPt4HKwuPlJcyuHpsYaN3Cu5VisYZ05GypJOseAa904S4JERWV2EN6QOTKEQ4G9TpL7Knc2TmsZPXmVkZ1ACyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629660; c=relaxed/simple;
	bh=d6Z0Qr4CTc08P9WkJMHZwVj8gKSLjMo2tlv6iVU7it0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r9LW8P8ZSMauVcI98OsY5jMwxDyU8f/o4jNQw+qQr2jDKA2YLDntEGxck/VvTHZpNNw2v3ZWuXbgu3jcBzmYDVd96AKIoJ5y5+Nt39XoPgsEl+fwUGTwQ/7cXSoJkyxuSLWQbbTB6nbbjzi6vJi7DMBBge65qhcC1mVdg/oM8Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTg5c4IK; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-51844b3dbdaso706134e0c.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629657; x=1739234457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8EVTlPHi7Mb2Te93qLO1p412b+GgWZ4HCCPa7QLCB4=;
        b=DTg5c4IK4uqeuKtprc8dCv/TZ7A4uurNkQMARBgJxO+sjnAeHiw8rFBELPn6xJP5uC
         xgJfetwG8KkHjqgLqiwIKmMJria6QEul1ClGwcQ3fPKRFbqo8xIfN8WUK5NkGLGBpmXd
         9IVxv/pkg0IeWlG9S5kp04FDegDFP4FlD9eebRcu7p+uSU8x6THomfAV9aVzDT08bWJ1
         6xsOo0TDwPuqVx3NRUNjKXgR8ObT1AGkb9Wdp7Xxp7U1JMJVZQW5Pq/qiWCxB/m53djr
         2TFRspj9z/Pw23JuoJZDv3s5Oav9LvjH46cxLrHPJut+nKDZ0qSt48U5VyTbres1KwFE
         3CtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629657; x=1739234457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8EVTlPHi7Mb2Te93qLO1p412b+GgWZ4HCCPa7QLCB4=;
        b=bNQGVALwuED+jaLikECdzLBBPNw+HOmByqyrw1iBpUqTKshKUtPiBlzshvdJJpWY2J
         9dEDwqJz5UBeLgvBQxiR8doyPiWqoVyLDKVhpXVC6pRWB4fNrSj+F3B2hbMFCgemnexa
         CVBHBXY1qq36L0vwf9P/OerOZrGLEGR1RHA6NV+8Y0EjoH1FxfT9dtsIUESWHy4mtPNy
         JGm+nkNPFARVv3WKVahO+uzru2YBLm5G724xMGvn4KlozqQMwgyUgQDiSXY/iz1QlAje
         OIeAUg2VqgjYe+E6w7HH3hZh20GHqrAcIpudEcYkq1O1OrJI45EBHt3iIiKngbyS2S2E
         k6YA==
X-Forwarded-Encrypted: i=1; AJvYcCXjYCSmJqg7Oy/+M9PrYlTgxtaXeCTt7TnW6DbT8znaTTs4cd8hnZ+tzpg3MVlhoIY8y9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ7LZViwtD831puBfVWgUIRcHKFnCejxPFeBT8gL/KYUDEPXDr
	sHM//RuA9986/HcsWx6Xs7XUWPqs3QH79R/wBp4yakMa3lvmWJDpqVztq2Af/us+SEmgKlTRttd
	pdks7b9ObpqANHE2EvA==
X-Google-Smtp-Source: AGHT+IGHq940BRezUkVwlNOCiT1XgwqRxT3qyHCt+hNVEw0Fg5bWPvg40CR+xh2gIgoPsc7fxthizhVN+hgnsK9w
X-Received: from vsbid8.prod.google.com ([2002:a05:6102:4bc8:b0:4af:ed99:8589])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:c0f:b0:4af:c519:4e86 with SMTP id ada2fe7eead31-4b9a4ec4902mr18110648137.1.1738629657558;
 Mon, 03 Feb 2025 16:40:57 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:30 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-4-jthoughton@google.com>
Subject: [PATCH v9 03/11] KVM: x86/mmu: Factor out spte atomic bit clearing routine
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
follow-up patch to enable lockless Accessed bit clearing.

Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 047b78333653..9135b035fa40 100644
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
@@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
 					  u64 mask, int level)
 {
-	atomic64_t *sptep_atomic;
-
-	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-	}
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
 	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
 	return old_spte;
-- 
2.48.1.362.g079036d154-goog


