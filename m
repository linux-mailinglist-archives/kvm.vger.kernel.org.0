Return-Path: <kvm+bounces-34917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 322FEA077E0
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E655E188AB7B
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BE6221DB3;
	Thu,  9 Jan 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH3g+COC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CBF2206BB
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429913; cv=none; b=ma2GcGwHvldPguz6sNCAPTNCfHUTLfj9WMJzCvshmQPX6HjNaLeLsYdEry/QIFwk7I/oEI89n08CKxYFy+kEwnEp2dcxUUD4FItdO5oqiv/F9WSqp+OSndVGBMoV+uLBT/yV/giKDF/toMXqPoRR65ay35BJWofHg7uRj2o3x1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429913; c=relaxed/simple;
	bh=CLPtAWyQrS2entG2WH31BYmUD0uC+KITDZ/IYJGu0jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faWX1jPyODeygWIY5NQK1CTApFQbAzNqnG6Bi+R6cLId0qxrmT0mOzsikUGBHA51bkvl8x3vsHp34fruelHKZEtDnlkxPrpvmfWGjTX8nS0FLg3StSdE/3/YxjxVLEisqV9vzPPhiTEEs739ayqW6aQ/8FTetL3g3lv3/rLzzY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH3g+COC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/K9YNVS7ltWEgnQj5oYbH5hWmhcl5BqPq+/x8nLjmU=;
	b=YH3g+COCDCLjHJUN4O4SS+yupzd4iXUTfYQZPijMLdzGBBYY0cJsNoxP0krWC0bp+Vn6is
	JF2+d8+eWfM3XXU1bpzum6HE7NLLw1xLv9kcXqixVB3OypRKJHDQ020PEUfMYwmjDn1tG3
	+JUtqTweqFFRMN6PVoxB+LSEr5T0leM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-b7oVtHaONCWp2Axzhso61w-1; Thu, 09 Jan 2025 08:38:27 -0500
X-MC-Unique: b7oVtHaONCWp2Axzhso61w-1
X-Mimecast-MFC-AGG-ID: b7oVtHaONCWp2Axzhso61w
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6732a1af5so97122566b.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429906; x=1737034706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/K9YNVS7ltWEgnQj5oYbH5hWmhcl5BqPq+/x8nLjmU=;
        b=ox7QOY8y2Tg8lq5rfh4qOGQwdQi9Pz+sS6Ck9yWg7OJs7Xyy/Zm8hrYrGl4BLFoQkL
         wRSlX8gwHav2WDsd5dw4w/PhIO5AdmXPNi9qFD7dFh/gfCAenbb9Icu6+Zxi4ApYUifs
         t5UUZB8LFjwzC0J82FLHXWkTHbN4itTckGyGvdTvLoOkuXjJrG4E+8/DeyK8qmGBhZoZ
         ufX7e95Xv5F+8zfnpi9d6KFKyLTKcbXTePdHhVHK/SbZT7/V0xzYgsGaZbdISmmPVO0d
         BKFQYz13JQYGKpbvpyTBQ8ilFmZLZ5ARGQ7Chb8e8MGVl2XF7Zy26BT4dAqOHgEHa25I
         C4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCVy7pua7dyusOS3itqM5sVS+dNMtG6oA3veby0+A+ybNaGPYp85FsL1e/7+sFk2UiJxbak=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgE5wNBb9tbpLfhHBub1fqndPIos4ZGSsqUU8iz4hdvegrrwD9
	J0H5iIBH317/EZbDKujMhiqvIQ0JCo9CCNkvBXkBg7QIcs5lepjIbwdLjxyc2kiGHRNzTgczBP2
	14jyCzd7A3cT6Gkmu09tq+YsquKt/HZqnJM1qEfc88DChl8B42A==
X-Gm-Gg: ASbGncv+XBSN4RqrUe3UH4tzY4y3bwDWeHV1ZPK/N0pDVKkdVtfOaYNBpnxxtdGwcQx
	dYQE9vsRATPUFOOOPwtfNEBbaYADcy/XPpsdAHN6glq64zdHO6FBbZ2xCfVdijY2bO0itMkRak6
	fPfcVKPpLr3ce7BWJ3PjLT1pBISgKJKQSTMiyp7w3HYuITmyt9ofljQEXstN91fdPK1e6fCUpRg
	01oCrPz3tfkWeZEuVa8CHw5miUvKLhUFJ5knGoImpBp5XtEKB5LpvCevKTN
X-Received: by 2002:a17:907:94cc:b0:aa6:7cae:dba7 with SMTP id a640c23a62f3a-ab2ab6a851amr624677166b.4.1736429906033;
        Thu, 09 Jan 2025 05:38:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTbBeYDIBQ3z954w6dfAEk3XY9Iu9HEUTdIMdZmv3AtPH2uw4HEV5T8fdkL1pcscV4BnFyug==
X-Received: by 2002:a17:907:94cc:b0:aa6:7cae:dba7 with SMTP id a640c23a62f3a-ab2ab6a851amr624675766b.4.1736429905640;
        Thu, 09 Jan 2025 05:38:25 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95648e7sm72802566b.95.2025.01.09.05.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:23 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev
Subject: [PATCH 2/5] KVM: e500: use shadow TLB entry as witness for writability
Date: Thu,  9 Jan 2025 14:38:14 +0100
Message-ID: <20250109133817.314401-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109133817.314401-1-pbonzini@redhat.com>
References: <20250109133817.314401-1-pbonzini@redhat.com>
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
index 732335444d68..06e23c625be0 100644
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
@@ -493,10 +491,11 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
-	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
+	writable = tlbe_is_writable(stlbe);
 
 	/* Clear i-cache for new pages */
 	kvmppc_mmu_flush_icache(pfn);
-- 
2.47.1


