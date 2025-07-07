Return-Path: <kvm+bounces-51708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA77AFBE5B
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 00:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F5BD480C4D
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A272550D2;
	Mon,  7 Jul 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GWcareNK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702528C2DC
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928511; cv=none; b=MDPbiQ1VlCN4pcbvYrgg65F6cGqm0ZFghlYTtlyIRasGkQ7mhIcW2QEZaD5T3NUiP/U44p6+BeDJPhLn2EFR1/jIGkq7y1CZBAOrUzeHJe0LQ5tc0xH9EUCEJKQTm38v1swKYpY8dMMkE9+OJl8NgA46mXzMSNKlHMC0in7Bou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928511; c=relaxed/simple;
	bh=LzKYRQCVuaJMqlGvxUBg23DAUAcSx2WIUPKtC6dbxMU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jBITWq/6rXaZoczM/1kPC5yQZiIKFbZASAs50DLi7IMGcuI1g8dX+phjW8Vm2SYGvKvDafTbFtNqCU7TakcCaKpxYKqo8scascVg6d1gKkzPqr68KlwzDnXELHt7JZmfNhxguIJOUGuNu8GMzOFo5XFdbRX2HsIrt2cZwzWjuMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GWcareNK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so3227839a91.2
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751928509; x=1752533309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kyLCHmkUQILbp25o/Y3USfag+DNv6QnpeB4rV3o77kE=;
        b=GWcareNKYUGFL2h2/u30T0QJR38Vwkia93mIHnRqf0+Tc6VUPFHzqrnMDuOvv0sftE
         4M2QuUMbclhoc6VnXcb7BqWh9/oIp127n16HgDVZ4fOIPzxKrYUonYLrKft36SoGgDPI
         zsjxU4xKkPoyf579apH1FdNvft5sJadRKjwYEhW3HNoqssmApSdlu9eZxEuWot5hJzdu
         9YfOe352l3/8oX60KuVuRprZR99aXc6ecI4bhlS/CG7UKzFz6A6mmcjKRKr3V7HK/ylt
         yr9ZEZOMvyBtaOagmH5xSBalYQW0bgJ0Mj1oDW05jqWyFRNQbi6FXpNRaoN05mhQtHv4
         iCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751928509; x=1752533309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kyLCHmkUQILbp25o/Y3USfag+DNv6QnpeB4rV3o77kE=;
        b=Mcc3tq1tfFxb2olYtHsnMbPqLVVpxsFLPOUm1VzsQQqSi3eJsWYu75qQ8EtaA8r8N1
         MHQvdAzk10sLMSJtJYukUvMT/ibUW7+9D+EEBBj8a1zqf1A/OQ7GsDPx8m3a91M4BH4o
         oxW8iIpT49IF+zc0SgdQAkIaNBub14/+Br3oJ404IKLwer/BFmqRQYlIdaLG+Xo+Nve9
         qMUNxo3oaFWpa6uEpSP0J4gApJXrSfwpJ4b4g9bh9HekKmPS+6lrJe3n3mTuztRoG3fY
         QYMFOvNO79g2J8f3Gjnab1dNnDah8/GeTVHjvD8+2ttKYyr7lD7q/asBkXIWE2xyfbaB
         ebdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUzxP8EMxdUVdXmpSSqKeJ5yAQWZYVrIGQLaLO8QR5AWZ0AS5/2FLXrjifakCrQU/6fCY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh37DnZMx1+9MhzBMEHYgCvhn/uocm05q3AoJSPXianlluCC/2
	i6K5Gy4auWYd8muY5g1eVbw5Ryixopoc2ggkB7QO8sQ4sVuBiu5+i6SPSvNBmJ3nSaReiA4XpKa
	1iKpT1dZ4SFN9WuAGCgMZ6A==
X-Google-Smtp-Source: AGHT+IEES6dWaYObQEJRBDnpbfu3sljQUDi7DMpVdgtUHxweHCDJwqF3Bnh9vM7cmXgUWD6fPN0ZK/bTTYK4yTL5
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:313:2213:1f54])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c0a:b0:315:c77b:37d6 with SMTP id 98e67ed59e1d1-31aac4dfa9emr17263064a91.23.1751928509156;
 Mon, 07 Jul 2025 15:48:29 -0700 (PDT)
Date: Mon,  7 Jul 2025 22:47:15 +0000
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707224720.4016504-3-jthoughton@google.com>
Subject: [PATCH v5 2/7] KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better
 indicate its purpose
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Vipin Sharma <vipinsh@google.com>

kvm_tdp_mmu_zap_sp() is only used for NX huge page recovery, so rename
it to kvm_tdp_mmu_zap_possible_nx_huge_page(). In a future commit, this
function will be changed to include logic specific to NX huge page
recovery.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f44d7f3acc179..b074f7bb5cc58 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7607,7 +7607,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 		if (slot && kvm_slot_dirty_track_enabled(slot))
 			unaccount_nx_huge_page(kvm, sp);
 		else if (mmu_type == KVM_TDP_MMU)
-			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
+			flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 48b070f9f4e13..19907eb04a9c4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -925,7 +925,8 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_unlock();
 }
 
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp)
 {
 	u64 old_spte;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a00..bd62977c9199e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,7 +64,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 }
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
-bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
+bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
+					   struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_tdp_mmu_root_types root_types);
-- 
2.50.0.727.gbf7dc18ff4-goog


