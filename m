Return-Path: <kvm+bounces-23116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FDD9463A4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A40C21C21331
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCFA1547F5;
	Fri,  2 Aug 2024 19:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAD0YljU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130F81547CB
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722626187; cv=none; b=S2GsiYCOddbxham2t3dzPQwTWEzp/UZYQ/PkbNMIUyn/bgFpBXkJ6yS+cxdUsdPtmPV3BC045gzOglR3iaCBqt7K+y/gXBUxVY1kNIyHYxDp7CdYMo+f48f6IdWxg8VQm2BsQXIqVoFoAwGEMTWafg/4Kf0LJ9l/y4rO21pUpKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722626187; c=relaxed/simple;
	bh=cd3nERhRyP5WUA7DduGPP+BWpepjFRp3xf3fTSNPuWQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cL9x7SK8VuEF591vpWfpQMc1jtuv8vtg5VgaEMH7OdkpopjyHJBDU5gweRW5whmyHEEJSnJM/88UxVrcXvzbLLOpoj4Jw/AB6ASReGV47DNjHMoOtCPtj4UAJ+tcmfuOzan89IYc2MqytCjF1V8u3hAXbEksChmMAbwqoXHha1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAD0YljU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc54c57a92so65376025ad.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722626185; x=1723230985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIO+qgUdBIl41nA20oLk13lAMgqpqVOKXB0K8n0R60E=;
        b=oAD0YljULYV22N0DAGKDrah+IAvs15F6GN17b/XWi4T5QrzMcrAulymNApOErcPkVC
         QyHUEet/UKf/hOVMNn7WpVNclq5dJWsvQQQa+mlMjCMWl0cWhX8RA6+kRc8UhrfP427J
         7EH3YnEZ9l4SqJtLhQ0BDZwAdcQAw94SEORtPz4+RXVdDRXaeQEek4d9BfbBaWzdPjCa
         ekSsHQkVUKNqWQrKLqVqxxsFDmv4g3AKSPLJa9wbdG/KHu/jGQ7C69nI/YyWBTXLhDdq
         SNYU8O+wvqOaezr3Y/CsgIQUkhbdH3idX8EoFIvxbiaBW+7ehTEut5DBOaYmmGT0eMxP
         HxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722626185; x=1723230985;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIO+qgUdBIl41nA20oLk13lAMgqpqVOKXB0K8n0R60E=;
        b=iv/KcG5jIVwYp7BRq4dnDTQ7oJ5iJ2ahLwoxcIPv2D0qrfmDOipDeBcJJr8Knl59Zf
         4IT2jYLyMzeMH7b5NDl/mSTIz11Z9M34ymmggm31d0HQBLVXbEWeUPgGGbukAqQ8sngd
         AqPFAg0BDz8V1oUEuCJgEpI+xU7wSkvnwZuMV+Lb7yotIYdlR+2sZh1vWeZvH91FucVz
         8GI0KOOOLTHxpvTvAM2RfnGjfEAShmUPJmT5uv7pko9Guk1S3mlwWfia1jqbRuXyLJ05
         kc2N9hMgPH88Impf16jGl5K+C2HYK/6rt2/zgW9q3jhmc0LYQ7kRnPMiOVd3LCwlLHqg
         Cnng==
X-Gm-Message-State: AOJu0YxhXGOpar31OMcA0HeeuIc+I19BhnE30DsjXEZwaoGEyS8cX3yJ
	rWahtP2+9sMOnbiIubhq33yGPMIXgwPXKiklj6XdlgyXDFIVQcro6Urd3yT0HGMJF+GSR/FLuie
	8ZA==
X-Google-Smtp-Source: AGHT+IHp8m7VmlNHNgyndl5iB/Qrp58SL7daPo+m+ANFoMuJ9ymw7NFJIbT8yKQlLqeCw0sES7T/md/ku+4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c1:b0:1f9:ddfe:fdde with SMTP id
 d9443c01a7336-1ff573f60ecmr1961065ad.9.1722626184573; Fri, 02 Aug 2024
 12:16:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:16:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802191617.312752-1-seanjc@google.com>
Subject: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks when possible
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Do arch-specific range-based TLB flushes (if they're supported) when
flushing in response to mmu_notifier events, as a single range-based flush
is almost always more performant.  This is especially true in the case of
mmu_notifier events, as the majority of events that hit a running VM
operate on a relatively small range of memory.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This is *very* lightly tested, a thumbs up from the ARM world would be much
appreciated.

 virt/kvm/kvm_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..46bb95d58d53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -599,6 +599,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
+	bool need_flush = false;
 	int i, idx;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
@@ -651,10 +652,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 					goto mmu_unlock;
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
+
+			/*
+			 * Use a precise gfn-based TLB flush when possible, as
+			 * most mmu_notifier events affect a small-ish range.
+			 * Fall back to a full TLB flush if the gfn-based flush
+			 * fails, and don't bother trying the gfn-based flush
+			 * if a full flush is already pending.
+			 */
+			if (range->flush_on_ret && !need_flush && r.ret &&
+			    kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
+							     gfn_range.end - gfn_range.start))
+				need_flush = true;
 		}
 	}
 
-	if (range->flush_on_ret && r.ret)
+	if (need_flush)
 		kvm_flush_remote_tlbs(kvm);
 
 mmu_unlock:

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


