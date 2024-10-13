Return-Path: <kvm+bounces-28703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBA999BB93
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 22:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5ADB1F2153F
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 20:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8D81A4F23;
	Sun, 13 Oct 2024 20:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="BjEE0w0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13886149C4A;
	Sun, 13 Oct 2024 20:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728850703; cv=none; b=Wb5Ya+cyp9xEt+vfioXEd3fMgORJ1VW40YWPKrGFvC4zI7hIWn/EiYF9kizm/xnyb+sXLdoOA+zGDk5wzaitR1C8g14XWeGwyelaoCzVEbG9Wz8CYbmw+dJ6nxMXi20MsxRux2DqebgebQvkcbRh5y+DzrX9ijoYjliRg28UGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728850703; c=relaxed/simple;
	bh=vMJfnVodG7JCqHrEDQ3Q01QvpSiNIoX2WLWWcUybw9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=usl7kNnfF+Ag8fYCDiBGTZgHB2Vr7YsvKrRfKbcH6mXtxybyG+TeeNpTbdUSVBKjBFf67wNizuBWhVr9Zp6Ot6vqi5wTQC5gcaHcr43o+wZeg8UA7hQjKspQrctgtYQuP9sCRDqz553WpPsKWU+Rzs7C6Ya58ARfAzriUXaWYEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=BjEE0w0C; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fZBINeODAqFt0yXVx70sf+neXSqrWQCexwg4fqNcrVs=;
  b=BjEE0w0C1UE0dff3FmRZ6xajer7q+nb21CHSMK9f8c1lLjt6/yeyZjHH
   y+SLuXnqlDQOC0O12siE/8WDEQJqwj9UaNUDRNxSAyTKbwIpMuHXfi68y
   bJivpTd3/YtK8ocBUBIcJq0vIm0c7B9a8VxSkF9QSHoQZvo6PMh0Bp+WJ
   k=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.11,201,1725314400"; 
   d="scan'208";a="98968288"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:18:01 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: kernel-janitors@vger.kernel.org,
	vbabka@suse.cz,
	paulmck@kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/17] KVM: PPC: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun, 13 Oct 2024 22:17:00 +0200
Message-Id: <20241013201704.49576-14-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed and since
commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
it is not necessary to use call_rcu when the callback only performs
kmem_cache_free. Use kfree_rcu() directly.

The changes were made using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 arch/powerpc/kvm/book3s_mmu_hpte.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_mmu_hpte.c b/arch/powerpc/kvm/book3s_mmu_hpte.c
index ce79ac33e8d3..d904e13e069b 100644
--- a/arch/powerpc/kvm/book3s_mmu_hpte.c
+++ b/arch/powerpc/kvm/book3s_mmu_hpte.c
@@ -92,12 +92,6 @@ void kvmppc_mmu_hpte_cache_map(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 	spin_unlock(&vcpu3s->mmu_lock);
 }
 
-static void free_pte_rcu(struct rcu_head *head)
-{
-	struct hpte_cache *pte = container_of(head, struct hpte_cache, rcu_head);
-	kmem_cache_free(hpte_cache, pte);
-}
-
 static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
@@ -126,7 +120,7 @@ static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 
 	spin_unlock(&vcpu3s->mmu_lock);
 
-	call_rcu(&pte->rcu_head, free_pte_rcu);
+	kfree_rcu(pte, rcu_head);
 }
 
 static void kvmppc_mmu_pte_flush_all(struct kvm_vcpu *vcpu)


