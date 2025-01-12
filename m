Return-Path: <kvm+bounces-35223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3A7A0A810
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2642618887AF
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4101D1A8415;
	Sun, 12 Jan 2025 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MyiqCQSE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FFE18FC74
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675739; cv=none; b=S5BZKzVF49wSr2X+TZQvLdgrEpvUvKeUGxpFgOVUB1fABs2GuAUVH2jk13iP4bNCZp7LjFIvPIOI3bbsq1g0livKBlZfF5irDJFFkOoekqPQjGzv6OOnFIdPY35D+ABAirBfOHRgTnypfSThkA+Las+lP5HHB4UIx81to2XV1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675739; c=relaxed/simple;
	bh=zXt8gel/yANsANDIs5B5Mdvh1QFGb9YfZgkI8pbrooQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2XPGjF7mFZtlkit/6zOnzd5CKPvUmKidDKpHa8EpRqkeBgrLM80OYQOZYl9pZWZOXN3gyaGikWWZ8v2Wmgxg+ErWwNepwt/T0Pl8FjrHKHcufiAD7GohHJO5GP4jp/Lc4tIJG9VqZRgpMz91X1rjaGSlNFw7RlX0R3FD5KDuks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MyiqCQSE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q2g0sdh+W5glSkagx457PsA9cI+PMduPyER5qBCP9uo=;
	b=MyiqCQSEX9/f5RPFMIV9OXNz4JZLjEaeXiNHzT7FyJVa7aCMW4thttRvgeAr8gNTfrR2fu
	Y3bbIjE+LyEhMZiF2rHFYug+6yDgCWp8HYPgEpfUz1Wp5WbWVLkYXXi+jsXTZUuMSh0/Oc
	BheqC1ZSZiH89PfGCLX1NqY1E2eVca8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-AktupQARMUeowRVosCKcjg-1; Sun, 12 Jan 2025 04:55:35 -0500
X-MC-Unique: AktupQARMUeowRVosCKcjg-1
X-Mimecast-MFC-AGG-ID: AktupQARMUeowRVosCKcjg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa69e84128aso266640666b.1
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675733; x=1737280533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q2g0sdh+W5glSkagx457PsA9cI+PMduPyER5qBCP9uo=;
        b=CvcvCXonnd78C3K2Kb0HODEIMmEZWaj8yowg5UUzF94jwAceIxc2gWmNnvj7AYbyLN
         zithEnSFvvn1pIYBYiKmAzBc631OEbAoi7a9S3sqH/BBQVla+kaxJnNUsKjwOsF3iaj9
         bnFTMU+FrKOGJxs58gXz9qtoZEoGRHxdYSf68LkVnXA9qodeuxzCSY7B9Vj2nlX6Alm2
         DjVYAmeX2vKglCDskCwEj+Y8KM5T2esbaJHgVKDG4RkAw3Rxe9D5l5g4fEcOP/HICuug
         GIhUKbZ9OMfxzMueMUZaqhNCf4E5NEagaP6PYnqeItXG2FCOtYQBPaCYp6dvf2bzekc9
         JPBA==
X-Forwarded-Encrypted: i=1; AJvYcCVWaLleqY1fqILi8PnpbzvNF+Dy3/dpK02wvKzZoMb3xwloFmDY6H4G7x11LjduoJ80UBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGtjxusl0LegK+RodKTHRiwR1yRzGuX8e0Z7K93H5EwMbgMUbp
	TSE7k58fcCYGn3yTMoiYGaQLdyXeC9Ro52FjrHXZBL/bVjlKKo6wCD6+QaOQ1lbwgpD7Mq+0A5b
	BsgQ038CH70Vi0zi9nAzRKug8SdgoPVxE2mVSlJmmUn7NkWQtoM+cJ7FXcYdV
X-Gm-Gg: ASbGncuSPth6IbGeA6BHUCZItIJONm6BUFtj6UQGlyfSVCcyMOvD8E5WYrE0QNGCYnc
	ycxI1XYPTLMWiACMDFFhn1nCKCPs1OcxqLR8P5IAOJDflc4uyzMAfjeoLPnNtj2WS7jo1a8keml
	NORnjskLKW5cCyRWWxPSIpWdm3rJNbi90RthbbP0fqPq4BPhQGQUBQdlkL4LO8hLwtEcvnYMlLY
	dm2/6zupDXFhV0G48RJWSmAbZTS/0GX2aUaeBPA0pRA0dGWnPTvNnwfsPM=
X-Received: by 2002:a17:907:d1b:b0:aac:23f4:f971 with SMTP id a640c23a62f3a-ab2ab70a173mr1753854666b.33.1736675733514;
        Sun, 12 Jan 2025 01:55:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxwq3cSzmX3Sr/t/JxywDCCAqRMgXJsypEs7qUCiLJx2f+d/bQof+BQSWZDWOMCFQMp6aY9A==
X-Received: by 2002:a17:907:d1b:b0:aac:23f4:f971 with SMTP id a640c23a62f3a-ab2ab70a173mr1753853166b.33.1736675733170;
        Sun, 12 Jan 2025 01:55:33 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95647absm352956366b.118.2025.01.12.01.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:31 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	stable@vger.kernel.org
Subject: [PATCH 1/5] KVM: e500: always restore irqs
Date: Sun, 12 Jan 2025 10:55:23 +0100
Message-ID: <20250112095527.434998-2-pbonzini@redhat.com>
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

If find_linux_pte fails, IRQs will not be restored.  This is unlikely
to happen in practice since it would have been reported as hanging
hosts, but it should of course be fixed anyway.

Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index e5a145b578a4..6824e8139801 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -479,7 +479,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		if (pte_present(pte)) {
 			wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
 				MAS2_WIMGE_MASK;
-			local_irq_restore(flags);
 		} else {
 			local_irq_restore(flags);
 			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
@@ -488,8 +487,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
+	local_irq_restore(flags);
+
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 
-- 
2.47.1


