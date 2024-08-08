Return-Path: <kvm+bounces-23645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1523394C3DC
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 19:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 460D21C2228B
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F432191F69;
	Thu,  8 Aug 2024 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OuKVxI9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F1C1917C4
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723138996; cv=none; b=mXossdFxwyxhl0DsTXUGrilelKyzdJWyP8N1P5N1tosROz321SmWPgBJe/lrxG4gP+l2qfJiU9M3u86Xa2dtOixwuqbbLnZJitRew4guQ/4E4e3AqNU8hkpffsrw4D11cGLMcvgmkyKvkUEYyD9PxdKdtqM3cuiZPHngC05Z5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723138996; c=relaxed/simple;
	bh=86H8Hq/QrVp+2XHWtnQLOHjNx6b6/aA0SVYTRipkXQo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YfKrMTxfC8aoVkh2imlNS/f/fUMm9iVFOyhS3znmLau3r8yfN7I7Jno8vOIRCBgAA+RYuxU/SqwaTj5KYatytiUhOijz6ufr8fXQiAUIRuN/knceDhSL9jj+I6mG8vSmFHNVk+IpMif8TB+r+qWLLbtvJp/oIwF1kGLbxJpl1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OuKVxI9F; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650ab31aabdso23473667b3.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 10:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723138994; x=1723743794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4+1jkb/kSvflaKrQy8nLqEfji7x/G0gMXefyaO4Ttzs=;
        b=OuKVxI9F1EAtyjDcKJc2jlr4v3pNNODGwfvGLvaQWYGvSjQ4JUFwHhc9wUV6nloSD9
         E10d5PWOH+qXvoBdBS0sQ541cZ+0o/um1uj8kiV2BCfgT+6lhRuDPCLBYgiYElLcfBEw
         JHSE71O0h0sJelJpIVKFkl8BfXOJ67HjheOzOwAASnvkAOxAVvvXyxqpGsDjTLAnSMXS
         ChwUh5J89UKsYQTfwydLWfDOcPbCTFMwcosG7m6hwrJwpig8Cz8uRzAjmJtSu9mox6cL
         zdvDx0N9Xas2itwM93tNM0snkj+advBMjVZQA/GaoBcJJv1kxo+K/3KH9VbCWK1CTuWl
         S3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723138994; x=1723743794;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4+1jkb/kSvflaKrQy8nLqEfji7x/G0gMXefyaO4Ttzs=;
        b=vQPa++pfJ3L/6UmpHXnz0u4yqcbMWROCW6woD47dQLX7wYkrVXH2ljGJ8rE3HULW1z
         4W7qPxenDPU8emVCH6zwZOOIPPTtjEmEkWhJg4qHaipDjxQUHEkZUGLk1v7qG9mHz0k1
         ksDi/QIkRPLGqa6r9u81BdcnbSAlYRgEj/mpSWxty6sSRubiap2WAKcqUU1m4nwRRM+S
         cHYSLHVp2kbtR4KVu9JPdmrReP8/oIRb1AtT/5Bytbyc/nUhi/gGPMk+RsDoD/bGNWwX
         QJH953/zGtPznB3Gzp1TYS2nXwVmk3fgfyrcIgfYP5uRpyjm+7QiK9+OQPwgbkm9Uxah
         ezcA==
X-Gm-Message-State: AOJu0YwXOYF8/RKbYtwLOVUUVG7h9sVEfvtJUa82DXXxxI8mu8pr6sLv
	nmwnN6oDW50HPVAGiLartfyeQmVwU1S3uFfUZ7VQFUQFWTuoLWzbm1x1AwfReAJgqXz7I3/nZ+Q
	6nXIB6BAbyBE1ctfqeCOodTKBSQiZ5jQvEaZP9pvQcZaixGVnsdTz9LMli0K/Nj3yKw9enuPI3G
	uPyqgnWxO1iLWwjEWr/MCpNSY0vMR5XeAf1Y1vds6WuM0MsXBlQ2zvDl4=
X-Google-Smtp-Source: AGHT+IFI0rnzef7ISFTxPTkBDSrqwcN8rzvq+R6/y07Cu867kKIpT/4oVZnVFq4JrZ5GCRkcJ1KbtYBJHpkWdkmDpA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:961:b0:62f:1f63:ae4f with
 SMTP id 00721157ae682-69bf6f7ec1fmr200267b3.1.1723138993566; Thu, 08 Aug 2024
 10:43:13 -0700 (PDT)
Date: Thu,  8 Aug 2024 17:42:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240808174243.2836363-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Move data barrier to end of split walk
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This DSB guarantees page table updates have been made visible to the
hardware table walker. Moving the DSB from stage2_split_walker() to
after the walk is finished in kvm_pgtable_stage2_split() results in a
roughly 70% reduction in Clear Dirty Log Time in
dirty_log_perf_test (modified to use eager page splitting) when using
huge pages. This gain holds steady through a range of vcpus
used (tested 1-64) and memory used (tested 1-64GB).

This is safe to do because nothing else is using the page tables while
they are still being mapped and this is how other page table walkers
already function. None of them have a data barrier in the walker
itself because relative ordering of table PTEs to table contents comes
from the release semantics of stage2_make_pte().

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

v2:
  * Added more information about purpose of DSB to commit message
  * Rebased to v6.11-rc2

v1:
https://lore.kernel.org/kvmarm/20240718223519.1673835-1-coltonlewis@google.com/

 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..9788af2ca8c0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1547,7 +1547,6 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
-	dsb(ishst);
 	return 0;
 }

@@ -1559,8 +1558,11 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 		.arg	= mc,
 	};
+	int ret;

-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	dsb(ishst);
+	return ret;
 }

 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
--
2.46.0.76.ge559c4bf1a-goog

