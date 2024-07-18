Return-Path: <kvm+bounces-21902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D2D9370B9
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 00:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787A91C20CDA
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 22:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEA5145FFF;
	Thu, 18 Jul 2024 22:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l7cwWVWX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91294146A62
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721342127; cv=none; b=CDYkF9RSx1Q8QaEUxTFz8HGuMmVjO5XyXE+toRCXoXzAZxRz7awjsgOefiITVQRsL00BFkedL/j3TIoDSOezg0+IMFeLPECFaI8JDcgHCzLbBeG1Q+mKtNeWCJ+zhrJ/B5ZmIGHZZb1XXfXMRE9nd2/pub3eAo4+YsHij5fvLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721342127; c=relaxed/simple;
	bh=YDpDr4yxWaBJNXkK2yYee40+CDxF3GQ0b52/63eIRv0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Cox8ti6Huq61qLE0K/LJozuLVn3Z6/NRiOxBPcWS1vZ7RCNPlTQWvMsOdM+L7dJ4HPDhTw5yITVzWxPKil9rgXDVhDAKjchseNKRqohTx9gkZuGWLFSe+BFQJ10d9sOyjzu7i4rT3w0lyrzvBmz2GXpGVX6J+jtMC65OyCmtxXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l7cwWVWX; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-665a6dd38c8so37114377b3.1
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 15:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721342124; x=1721946924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t17NNug3pGXskbylK7023fOephyseDv5XvuuntGRCyI=;
        b=l7cwWVWXYbvOX9Qf3qSUn/wGUoHJOn+UUKIf8b7HO3UNvpRUY4EvbFUvfq+0hqtBf2
         lT1DYPFB4beq0qBDO/16c1XjrUe9S6AhtcVpent3ZqFVu2agbP2iNQr2ugS0nle4n7e3
         dZ5FiHCR0FgAcVNXfN3/ktgEckxHkiNN6uWj0I6mKVMy+jGxlN9Lm0fjCF3kmuDSNNkf
         5FD+2k5YkLAzyIW+wvwn7ekjOBT+EwED/MlbIEQF4qx3jsD4ROf9NzO4Tl8u49Qn6Pox
         F62WERJsAmeu/LDNjSsdjzL32yNSYmz/QOSiTdr7nfs+CUicWQ1Opu21NHYWz/Aa3wPO
         oQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721342124; x=1721946924;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t17NNug3pGXskbylK7023fOephyseDv5XvuuntGRCyI=;
        b=YpAZtWcTRyK2wtOAPDR3BwiyegSGT1P1nwWSv6mIFi/rzKSLpmxF20Lz52V9OrwLc8
         S7UAmdZxydBKuoBcLBGyWvS9wfm+dgOKxjGpj3s0c4ZB5pAUKJUq/NK2yZr0+4EOalzT
         PpKq4m5VpazC5MNF/d/I6A0ian7qhBpUIwUo+m6STlPW8v9L+4d17BdahSlIJwzYWXV1
         x/ECDk+qvfuALztevMxH76HZ6E1TJnZOMy/UcTxiVq3RFw9irao5ffOkG0VAEDINhlYR
         7VazvnOs98voGqm/HZPVYMuBB6fyKd0SecshavQdq2jRTDV6bkxuc8vJD8/wVwZ5GL7O
         5xhA==
X-Gm-Message-State: AOJu0Ywq1MnNxel4heG8zBNWCBE6DuJGvmWQHiEmnQZZJjzZThPNCaND
	2QeaaLbRwKEUXCuTi7qSuJKKpbDYZ/n0Oqez2f5lniWoA4gjaMm99f/c952EtXvqxzf9vpU7iZZ
	duIuLcit5dfCbjBXKSnveczZPHo2cqiVyEbtNeUw9iAvISfpvkrRT2w5CMGouIY48PWgp6ps4Ew
	Dil5uToh/q3xFbOCwIxpNs/y1EH4bzOjQviaysrL9AQVTi0JjrIze0r3A=
X-Google-Smtp-Source: AGHT+IFAzxmz+xd5k+TsYOLSlTiwpUEcd3PMTkPrko0oISXqajR79Y7rD10ay46njNzlCvfw2OfNGwggk1RAW9y4Sw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:f94:b0:627:a961:caee with
 SMTP id 00721157ae682-66603127fa6mr1628197b3.4.1721342124251; Thu, 18 Jul
 2024 15:35:24 -0700 (PDT)
Date: Thu, 18 Jul 2024 22:35:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240718223519.1673835-1-coltonlewis@google.com>
Subject: [PATCH] KVM: arm64: Move data barrier to end of split walk
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Moving the data barrier from stage2_split_walker to after the walk is
finished in kvm_pgtable_stage2_split results in a roughly 70%
reduction in Clear Dirty Log Time in dirty_log_perf_test (modified to
use eager page splitting) when using huge pages. This gain holds
steady through a range of vcpus used (tested 1-64) and memory
used (tested 1-64GB).

This is safe to do because nothing else is using the page tables while
they are still being mapped and this is how other page table walkers
already function. None of them have a data barrier in the walker
itself.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
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
2.45.2.1089.g2a221341d9-goog


