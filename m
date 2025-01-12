Return-Path: <kvm+bounces-35226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE09A0A81A
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A12116411D
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1001B3724;
	Sun, 12 Jan 2025 09:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aOqwnfXH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FC61B140D
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675750; cv=none; b=B2okHL4aRl5YPyTmd0EhkjCH0IalNqheUk21GGRcfP7Gv8qXZB9TsKv7lRGTAklXfy5XSeUwR/xNM0oYzWvMKDa+5Bo4znGr2+WPIRLbI14WYSgJ3jLC6F1E15VRtunozZrbzFWQiwpaRju8sBJv2ycxHGAWIphgm39VkFc8rak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675750; c=relaxed/simple;
	bh=2SDn49FT0scN9brUsaT1uzAqhvETvcU7A9zYxcIRZEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9QdT2JpT5Rbr4tQnHox/Wqbrv/Q1JT9E2Kr3LQnlSxqgcsx1QZpIuozVgFtx1pXD+3yVXJbcJHgsuvi9BUVpj0RFRinArgl9ZCkMn4vQal/dZUIE/6ktTzK+RTrU74jw1qgiItd66hiaHBWrSzVSOQv8ZYaEijzBu2c+HNe818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aOqwnfXH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=53tOW+li8LibaZME0FEdug9t3b3VYRiHfAOklFpMuVY=;
	b=aOqwnfXHXIIMd82SZWUW7AHe2WPYns6JRqdzXdMDZYp2ogQdV6g9z6GYi/9yqJ902KNWrD
	U5RgKm161IhEcQplJSAE6Ol2Gy/RlpXTnXmUbDdW+6ByJkSA/PjkX1SJI8dHhQNyTYe4JG
	qMYNlBtzFRiCdbeE3ZHmOYb88vUlMOY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-BvsvCi8PNzGF_MPtYQ12wA-1; Sun, 12 Jan 2025 04:55:45 -0500
X-MC-Unique: BvsvCi8PNzGF_MPtYQ12wA-1
X-Mimecast-MFC-AGG-ID: BvsvCi8PNzGF_MPtYQ12wA
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aafba50f3a6so325323766b.2
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675743; x=1737280543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53tOW+li8LibaZME0FEdug9t3b3VYRiHfAOklFpMuVY=;
        b=wutVd3UaNvSlOjc3DDoykncENBEeaqimIub7BXr68oWbrnXBUcOTwaBBEXE9Lli3C+
         aDxOcK/XobAQCgYHF3CRJ99Bqcl0rmHu4yN4ugSf9guxT+/ISqfFu8C/xTLkKk2UhhMe
         cCURkUVLiQOJBhhqXjOWSCJgEOfNrvekAOW5EZyGDzOZmiI+PCWLMjnAcfvRCipKRlwI
         Tfh+LiT5Co3AWRlLDNnWiZR8ae18DruwwkkwTfvr+YDoXpkVHGYSsu1L8b10zaqENeGS
         l5BtsNj8+4Ws47XAOLwlXNU1TV/e8+XW82gMFmJvkO2z1zjxWW2BwaQj8Bv9K1pZSr5H
         cDlA==
X-Forwarded-Encrypted: i=1; AJvYcCVV5zVMN+S5UrJgfYeRzsF174z6YRc/4zVV3pvGRiC6NwsRig7YqQ89cnPxRDIkoAFaf2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxocGsLFYFa04o0IqC0QENZCqjBFE0F0mv/Qw6vF7QHA6FEyWRV
	LRoaW6U5jWMEuBugJxCQZXoT2gYTeSW5tqx3Puwxq52i0OLnIyQxZClfta8C4b66n69NaaAIMfv
	5mp0Oc6jNcSV1B8/4RJyA9agLzR/7QrPrTjk9q+kgE+8Rl4At91TK93hPQy+j
X-Gm-Gg: ASbGncszhXd7V1v8GQF6LOG1fsdq23I5WxCeAJFihN6Ux1M4k8YizcTg/UhHqTpvTQP
	5xBIFVjJjxDQHQNaSf6bEXAZVQZ5ollwoCz0MTyE6iFLHHAz/fqrazh0zcqJuVJvanu264hK2J8
	piQZ7bg5NoRIYipRHmhkRT52v53mg9fNB+aj7C/9Fk87mQBpScN9Zg1NCUAHBKbdqzTChm0eKvh
	Kg7uMffZkQEIpU/fH0ndZsCH4YLfLq2A+CxbNtcppNrYfG6xGyWC0ExSTs=
X-Received: by 2002:a17:907:7f1e:b0:aab:c78c:a7ed with SMTP id a640c23a62f3a-ab2abde30a8mr1561037766b.49.1736675742913;
        Sun, 12 Jan 2025 01:55:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGJlu2i7msf3zvSzymzm23VI3HB+hujDx3jJa79Xm9BhmbLM60jNLT6BqjxStf0JBpA+edAQ==
X-Received: by 2002:a17:907:7f1e:b0:aab:c78c:a7ed with SMTP id a640c23a62f3a-ab2abde30a8mr1561036366b.49.1736675742572;
        Sun, 12 Jan 2025 01:55:42 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905e2ebsm363088866b.10.2025.01.12.01.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:40 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH 4/5] KVM: e500: map readonly host pages for read
Date: Sun, 12 Jan 2025 10:55:26 +0100
Message-ID: <20250112095527.434998-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250112095527.434998-1-pbonzini@redhat.com>
References: <20250112095527.434998-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new __kvm_faultin_pfn() function is upset by the fact that e500 KVM
ignores host page permissions - __kvm_faultin requires a "writable"
outgoing argument, but e500 KVM is nonchalantly passing NULL.

If the host page permissions do not include writability, the shadow
TLB entry is forcibly mapped read-only.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index b1be39639d4a..b38679e5821b 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -374,6 +374,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			unsigned long slot_start, slot_end;
 
 			pfnmap = 1;
+			writable = vma->vm_flags & VM_WRITE;
 
 			start = vma->vm_pgoff;
 			end = start +
@@ -449,7 +450,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
+		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -494,7 +495,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	}
 	local_irq_restore(flags);
 
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, true);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, writable);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 	writable = tlbe_is_writable(stlbe);
-- 
2.47.1


