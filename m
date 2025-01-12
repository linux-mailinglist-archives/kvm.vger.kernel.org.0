Return-Path: <kvm+bounces-35224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB382A0A816
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A88711888748
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B650D1AF0BD;
	Sun, 12 Jan 2025 09:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGWhKRkq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0671A8F8E
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675743; cv=none; b=A5iA9q7aMyGSkxgsW+dvV2I+EhjDoiP3a1m5bOaosqwOKbalIn9z8PUA5MU0BYO6pGWh2LvDPD4PvrhMpBUWbvQmT9SS781eyQEEsVxwSB/4ia+p0bAitIE2JK2BVmMdx0YysGzCDkj3qm0XZswvgEGyk5Wyx/h5NfizkTAl/C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675743; c=relaxed/simple;
	bh=RUtYNoQ9BCw8rR1uJmMHYjgVRzEI8pcTkgifDneD3LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCuUt33pqgPhFIaOY/Zudet2H4xioWA2BD1OvnnQiJsZMqYmI8iAN5Cjk1A4jVjnUZemQLDqa5r78lyQ8lg4mY2nFMhAutYtWUbyqWKc9hYPwzsEbRW1maN6Zg8ceockenrTm0SxcXCsdvTNyBLU6ZQY/fA61vDGMJBEu4zwYZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TGWhKRkq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ia6sv5K1rPK0oxjj8pHkn374uhH5Bs7h1d/ShzUvYRM=;
	b=TGWhKRkqI4FJL/iZYxN9527HZOhpdpoMIHyz2PUt39+dY8LlRW0gOmmO9Qk52AHGveFDa8
	MH0/Wy9IL1CM0WRU8VslyLct8uzgBCCvgxWHDKW/V6GrFeFepS8rcuG/lZkJ3Sd3yoGhxS
	eWEVpEs9BZ8E01DyVM5ZSbTVCy4MnFI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-Iyz-Hcm7Pa-SjY-9loRl2w-1; Sun, 12 Jan 2025 04:55:37 -0500
X-MC-Unique: Iyz-Hcm7Pa-SjY-9loRl2w-1
X-Mimecast-MFC-AGG-ID: Iyz-Hcm7Pa-SjY-9loRl2w
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6732a1af5so359838866b.3
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675736; x=1737280536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ia6sv5K1rPK0oxjj8pHkn374uhH5Bs7h1d/ShzUvYRM=;
        b=vutd5MpZWpnlfm2nof7wr5Zy7BIGZeW0oMoqKw3t2Lg1dIyM+hJJtkvine8b9v0FX8
         0hy7dhhzaokWgQlyBZ9sFyr6ogCScW5joP7lWOi+GhAoI784I3oH3Pi7Sh2G2Lx6/5vH
         Zrye2v6j5qZ7bo1JP/P6OnGuHS84JoigRqewMFT28wXnvJN9qLvz3ju9ji/HiDdGCbZS
         IMtOuf+diBw31SDQAMdkXu7gu2MtFZQgE9pgtIHm/egr3rqpqa0XI5NF49RjUFMmX3Qh
         5VdCVVfF22l/n4OzhKCEwAAKa9TWC/CdCQP2KiNw8jrg22lfWiC2NjJTcUL5yKbLA8YX
         kSiw==
X-Forwarded-Encrypted: i=1; AJvYcCWTWDqm+IVJjL8dJQOi2SoT+DETUDDRWutr6umG/6DUiErPvb+K0DDDdqKHMbwODnECC2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhkF/WDV1E/roi/w/ERWtYyUO/O9CmwXebd6RjxBWk27YryJ81
	BCWhgoyKGXekFXZRg5Zp57oWY628YwQ8Ty6am0c3QkHCsw5TVAJ+P5+bxbXUDKZhOb6uh/FDs45
	WpeP95f1sbqgRtPK029LudsQ4dljGEa5RnuHHgh95v5sEAH1lmQ==
X-Gm-Gg: ASbGncvKQxGkXtHEHmy7aT+/6ErgyPR2v7+BHOyUtYBEj/cSTdoT/BUOSCmA1u771ln
	fKWiizeahK/eu/O+nx7cXyiyDqAirQw5W+F9rfsvE/LCw8EMqMzY+XTpMN2DZ7PChp252giXDTH
	kbfkrSmAoEkvodmbWPIT63u6B3YD0ZSV6EeznpljI++MkkxKlzGf0MRnzc7box725pjv3vJ08+p
	je2CiHzD8IRNSfLP9feaNXZvVHTxS71MLLxFKyh8nmq9GKOFQCdz9IHY9U=
X-Received: by 2002:a17:906:478f:b0:aab:dc3e:1c84 with SMTP id a640c23a62f3a-ab2ab703f93mr1611128366b.17.1736675736618;
        Sun, 12 Jan 2025 01:55:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE57lWwmpDxmyLrpFomxsQp5nUpO/tCN5jrf13BA6wccxa5tYF5ClNyyJ2YVR15koS+dU7MVg==
X-Received: by 2002:a17:906:478f:b0:aab:dc3e:1c84 with SMTP id a640c23a62f3a-ab2ab703f93mr1611127466b.17.1736675736279;
        Sun, 12 Jan 2025 01:55:36 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905e283sm356143866b.31.2025.01.12.01.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:34 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH 2/5] KVM: e500: use shadow TLB entry as witness for writability
Date: Sun, 12 Jan 2025 10:55:24 +0100
Message-ID: <20250112095527.434998-3-pbonzini@redhat.com>
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

kvmppc_e500_ref_setup is returning whether the guest TLB entry is writable,
which is than passed to kvm_release_faultin_page.  This makes little sense
for two reasons: first, because the function sets up the private data for
the page and the return value feels like it has been bolted on the side;
second, because what really matters is whether the _shadow_ TLB entry is
writable.  If it is not writable, the page can be released as non-dirty.
Shift from using tlbe_is_writable(gtlbe) to doing the same check on
the shadow TLB entry.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 6824e8139801..c266c02f120f 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -242,7 +242,7 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
 	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
 }
 
-static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
+static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
 					 kvm_pfn_t pfn, unsigned int wimg)
 {
@@ -251,8 +251,6 @@ static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 
 	/* Use guest supplied MAS2_G and MAS2_E */
 	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
-
-	return tlbe_is_writable(gtlbe);
 }
 
 static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
@@ -489,9 +487,10 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	}
 	local_irq_restore(flags);
 
-	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
+	writable = tlbe_is_writable(stlbe);
 
 	/* Clear i-cache for new pages */
 	kvmppc_mmu_flush_icache(pfn);
-- 
2.47.1


