Return-Path: <kvm+bounces-35002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EDCA08AAF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:48:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 853F77A11FF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6858209F27;
	Fri, 10 Jan 2025 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="dvIoj2Ua"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.7])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227082080E8;
	Fri, 10 Jan 2025 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498913; cv=none; b=N9MGVwb7K10oEVc9vJaquUEiLuBFPLWZPl5yIBfnZV0uabIqGyTlwssx+N45bQrhmgKe4ZxujowYt3TVqc6zpypfieDKJbtK2b7g/O5CLwndgCzmpN+ft6ZopB2NRm+KAGz69nctZPynaysoM6eOUQIRiRU8QegyGmW94FwUpcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498913; c=relaxed/simple;
	bh=ub1sZHXFb/F+AxJ6AHCti3HnWJ7GR+UwU33f6KDJfXY=;
	h=From:To:Cc:Subject:Date:Message-Id; b=oiKSTRduPrfsQ6Sc9dW5Guu7oK9KQXt2QxCSwdwrKmAvzC14wT2OqsNk1MvUPZ8ZBVoAXsOrRQEr2FN/bLfWxfkoCD+X3qW+eCvFsWjG76Qe0aJYVPRGg0YjrM5zAYktL4UfIcdGenLcsfUOJn9x5s6VnTCm1IhtB61omc4ofUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=dvIoj2Ua; arc=none smtp.client-ip=220.197.31.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=GzjIOLyHp5IdO2BVyK
	Ai1LLovEreSuoc5dzKWXy2fas=; b=dvIoj2UaqQFk7LP+J1xjhOmMe1vvXf2XCU
	CuvEQ4YpSBP03luS7A/mLmp4B9/ktRYKrSL2mJ9fMidozquyB3fr76+OgkCx26xh
	bsaajBlzelgX90fzEZou1ef7kYifYwR9h1WYTjaY81xbxAZsiYpLXKC5P3V1QXr4
	SA1fxSyro=
Received: from hg-OptiPlex-7040.hygon.cn (unknown [112.64.138.194])
	by gzsmtp2 (Coremail) with SMTP id pikvCgDXj6zI3oBnEUEFDg--.13619S2;
	Fri, 10 Jan 2025 16:48:08 +0800 (CST)
From: yangge1116@126.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	michael.roth@amd.com,
	21cnbao@gmail.com,
	david@redhat.com,
	baolin.wang@linux.alibaba.com,
	liuzixing@hygon.cn,
	yangge <yangge1116@126.com>
Subject: [PATCH] KVM: SEV: Pin SEV guest memory out of CMA area
Date: Fri, 10 Jan 2025 16:48:07 +0800
Message-Id: <1736498887-28180-1-git-send-email-yangge1116@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID:pikvCgDXj6zI3oBnEUEFDg--.13619S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar4rZry8JF18GF4DCw13twb_yoW8WFy3pF
	4xGwsIyFZxX3sFyF92q3ykurnruaykWr45AFn7Z345uwn8KFyxtr4xZw1jq3yDZrW8XFnY
	yr4rWrn8ZF4DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRolk3UUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbifhzQG2eA2StPegAAsJ
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: yangge <yangge1116@126.com>

When pin_user_pages_fast() pins SEV guest memory without the
FOLL_LONGTERM flag, the pinned pages may inadvertently end up in the
CMA (Contiguous Memory Allocator) area. This can subsequently cause
cma_alloc() to fail in allocating these pages, due to the fact that
the pinned pages are not migratable.

To address the aforementioned problem, we propose adding the
FOLL_LONGTERM flag to the pin_user_pages_fast() function. By doing
so, we ensure that the pages allocated will not occupy space within
the CMA area, thereby preventing potential allocation failures.

Signed-off-by: yangge <yangge1116@126.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd07..35d0714 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long locked, lock_limit;
 	struct page **pages;
 	unsigned long first, last;
+	unsigned int flags = 0;
 	int ret;
 
 	lockdep_assert_held(&kvm->lock);
@@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
+	flags = write ? FOLL_WRITE : 0;
+
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags | FOLL_LONGTERM, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
-- 
2.7.4


