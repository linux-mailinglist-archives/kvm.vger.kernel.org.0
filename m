Return-Path: <kvm+bounces-71274-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oM03N14qlmkRbwIAu9opvQ
	(envelope-from <kvm+bounces-71274-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:08:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CB7159C7C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFA743041785
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519DE34A789;
	Wed, 18 Feb 2026 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cPYwEcoe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A80321445
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448905; cv=none; b=Lf9fjbJvkRfLKjqi+wJndb3QkWFUv9FPT9/ykzQSlBbAy4hICTOqdT7MMmwfWaWlDXuzqjmpUyKkGfQZE/f2J+epbMf352s/FQDewIjb6BRQF+B9HjZ9D5jjev1ob+1vDnMyajhj1WAdpzlwz2WomaDvJeuKONjEB/0vTk2y4I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448905; c=relaxed/simple;
	bh=yLwfb23qneQ17+KcyrsMlq4Ia8MemXqZ860cY5RxEnI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sajxqjSm4TvXcmNvu/9qXs+b0UBk7NgwYMk30+EusG3l7H8Qfvu0LsULQp43tSqVcfB3kcAqb9FtWwpGsvmfGMcE+0DPT4I3yc+v2sui0a5wUtZ+N0bndgfzhl4xYErLisc3aSA+4fZUaJ7eHKO8XVmM7/scwkQ/y9+nCa6r9HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cPYwEcoe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a77040ede0so2005085ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 13:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771448903; x=1772053703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMfKcLi903KmsmaeWQNJHAt3zeCXijek5HgaZQMpTfU=;
        b=cPYwEcoefNxdokILXJdEluXf3UtcecUsYqTp4M9oAElUbFkql2VA/1PDWqO7nN5YxJ
         mO3spxpa8wyI4UNTiM5a5kzYRFrss8SWAfkZpaFaNHxZeSEXZ3kbG7na5IeZRreOmfhH
         +5Z0SsWdytBc70tO5ZWGNQh5a64b8VcqF5SZr7oDi/hvkBW99fRQ6atUw4j6goYQd1BK
         Tp+sywEz2K+XijHnqnjYa7HrdwI5trGGby033sdC04LcqggFsjyvLzPcnKSeKfvXfnQd
         KXrUyy+Im0WhXJ7h2SWsYdaF3Wa7RSdnWU525S2smGYGVfFbW2QpSKm/+BLhlbnIgqhG
         Bc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771448903; x=1772053703;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMfKcLi903KmsmaeWQNJHAt3zeCXijek5HgaZQMpTfU=;
        b=c7fJF3ETvUmK67mdsZumW0UfRBxFyhfOeb1ToxvWgSk7f4IDkcW4jFaDcQ8bQCrwpe
         2HtxQbZKmE4teDsmX9l8FryF/REEWDqshqYek0YP9AB+TqLq8uhp0HoBNFtEd5q3fgbS
         9A0ZBvYRoR/n/vF5w8EwAUUHr4JB6KrcI6afYd+2yqu7yvj5eGt0PnYUzwV8VxEk4qYT
         7vaUQLVbjBGBY31F8pjZL2n29/h6A5AtdCVrcqbCdpu4s6tKWh3uH+XM32flSzbHrBsD
         iHU+PUKyPxQGVxtM+sM8rj4G9vtJmfzQgobi3MfqKpLbWFCM3K4XYMZqApBmz7ySA5mo
         m4IA==
X-Gm-Message-State: AOJu0YwAu0c2uW4lPSdB3/+q4ZAOqCb3Jykxfz4kKexhE+9pd6Su/XTt
	v3b+iHk+SpPylZnzhdM+K4U6OTFlVV4s8leGh/+mRsg89ipfm0ZREMmkph9Gox3tFz4p2J+sZCa
	PSVci5g==
X-Received: from plim13.prod.google.com ([2002:a17:903:3b4d:b0:2a0:d5bf:714e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:384f:b0:2a0:a33f:3049
 with SMTP id d9443c01a7336-2ad50e75799mr28433235ad.4.1771448903199; Wed, 18
 Feb 2026 13:08:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 13:08:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218210820.2828896-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71274-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 46CB7159C7C
X-Rspamd-Action: no action

When splitting hugepages in the TDP MMU, don't zero the new page table on
allocation since tdp_mmu_split_huge_page() is guaranteed to write every
entry and thus every byte.

Unless someone peeks at the memory between allocating the page table and
writing the child SPTEs, no functional change intended.

Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c26038f6b77..7b1102d26f9c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1507,7 +1507,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sp->spt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.345.g96ddfc5eaa-goog


