Return-Path: <kvm+bounces-34918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB224A077F8
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 664823AAA47
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833D221E0A4;
	Thu,  9 Jan 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPL/VTle"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2BC2206B9
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429913; cv=none; b=bGqcqOFMO1wKFv6EIQwtMh+cRzzqQl/vkeXMN/QZ+/mkkR67eIV3qEBnN0KlFdaczQHL8BYriDfsh5k1OSUrMzz+HMenFv91gBmmtR1ww+8WIzHUD+YN8mGADebHu7/XYybrIbG4/yb9bxyMHc5RT8vYYjqkMXIpwxIoTtmsgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429913; c=relaxed/simple;
	bh=sE3kc+9sHBVpfMHODBVRzxlEUWaM8pbPMewDEM8p2rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNtzbl58t7TxqDH5IvIhpn6WjyZ8ooTVfa4VQWXQTAZei3n/xAhtJhVHK6sxgs8hXlcbHzO7yXBQrY6dL3f1TjccBlBX9upphl2EDZWHxAiq9HH4W/vNR9QAXmbHRBCGkSEE+xWwfmMVx/B78Xy6vz3JuWyxXcLEXU+EKhRtweE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPL/VTle; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zguszej+6js0jv121He/RU1+H3xrJy3UeZApbWTSTbc=;
	b=aPL/VTleUzRwTxINAaBioSqm4ksH0Z23ChPE5HHZI3uVtfNmMJ7vHEuJPrdFJcBHU/0YmU
	eEaTq0vaAL+GT8DK38ZLVTEnCCE5sLfsiAjzADDi4/xeevxaU387I0IjIKaA1ZJ5wdg9WV
	85iTjgZp8cw9Xi+SCWfAK1TDF0Gmfp8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-QByXxKtnN7qmIIzgcX5PLQ-1; Thu, 09 Jan 2025 08:38:30 -0500
X-MC-Unique: QByXxKtnN7qmIIzgcX5PLQ-1
X-Mimecast-MFC-AGG-ID: QByXxKtnN7qmIIzgcX5PLQ
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aafc90962ffso95561966b.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429909; x=1737034709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zguszej+6js0jv121He/RU1+H3xrJy3UeZApbWTSTbc=;
        b=JilzMcyyhRjfm0O8A1vvy2upMx6VwUleRqSiPS2sjRSznAID7hTQJdtBb+APm/oO+H
         qKkyQbZ49xN+5+xAn1eV5pmDhkyuh4Nhhn2NJUEZHDBq+fKmSf1vM2a+o7R0HpGBVJim
         gX6rUBnMuaSPbKmdcpfqgqzqS8/0uTo6isl9b8ezF+6531R54PC7AxRaItATs/Vrq3kV
         O14eCdQZJLfxUbOLY3dDALWkNu/mCnWmiOWe096FBLJhhvxpDV8D1KXfa9xVSKM9RBnc
         LWW+llomaoCUq9v5ou3wKw1UUmNkdJxR0b4mvClaYn3RDBxrTt++0xa+RWZoO2U+AzBh
         ksbA==
X-Forwarded-Encrypted: i=1; AJvYcCVNmU9dfVv98GOQJctgE4Mo22ctOt9m+Fd+6nThGkNOhsfqe0h8j79MCv2T8LGZo+sKqis=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+uutdv9Ll96xSaGU1Kc4mmcXMB7wshVQz3MwuXudjvO9OaHoe
	LJ3ktkeKOrxB/mUdIg/pWsRxChmqyWJzv7lhyzJH8yL6npFzaVr6MGqHBwoNDl3Zn/tCSDkugLd
	VoPDvB0wfDU9mpWe9Xkd7FlPssKwgyLJmlKoniOCPSDFtcjIi9A==
X-Gm-Gg: ASbGnctoFbwvva2IvI+sWR3bhGU3LTRwp7DzsjN2JsL2MA0F/vAtvoB/ojjOxcfpfeC
	rYatOi/v63P2jHcc8YflybvD86OCFOtu4QjRxO73Bf1x7/+BaZilkxhxiWnSLzSBhM/drRYC+v9
	BWMNmgm4atG5aVLUiA59R/4YbzSFLoQYjdO1e+98d8Vf1v0mKkOn/CbENxtLe43VZAeyUJl1o5p
	SMGA0H4+KWrRSWH8yNf4u+Vyo0ptLU42V3hx6zwvZuCcCxCNDPBM39JI794
X-Received: by 2002:a17:907:724b:b0:aa6:abb2:be12 with SMTP id a640c23a62f3a-ab2abc91b53mr573667666b.37.1736429908683;
        Thu, 09 Jan 2025 05:38:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGo9tyQhMRCjTpqjQKY5ONk4yRTr2KDDRMNsirKe/0lHnxJJpvXbaOhKUZHyIFh2cUX8sdNHg==
X-Received: by 2002:a17:907:724b:b0:aa6:abb2:be12 with SMTP id a640c23a62f3a-ab2abc91b53mr573664766b.37.1736429908325;
        Thu, 09 Jan 2025 05:38:28 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95af187sm73137566b.142.2025.01.09.05.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:27 -0800 (PST)
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
Subject: [PATCH 3/5] KVM: e500: track host-writability of pages
Date: Thu,  9 Jan 2025 14:38:15 +0100
Message-ID: <20250109133817.314401-4-pbonzini@redhat.com>
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

Add the possibility of marking a page so that the UW and SW bits are
force-cleared.  This is stored in the private info so that it persists
across multiple calls to kvmppc_e500_setup_stlbe.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500.h          |  2 ++
 arch/powerpc/kvm/e500_mmu_host.c | 15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/e500.h b/arch/powerpc/kvm/e500.h
index 6d0d329cbb35..f9acf866c709 100644
--- a/arch/powerpc/kvm/e500.h
+++ b/arch/powerpc/kvm/e500.h
@@ -34,6 +34,8 @@ enum vcpu_ftr {
 #define E500_TLB_BITMAP		(1 << 30)
 /* TLB1 entry is mapped by host TLB0 */
 #define E500_TLB_TLB0		(1 << 29)
+/* entry is writable on the host */
+#define E500_TLB_WRITABLE	(1 << 28)
 /* bits [6-5] MAS2_X1 and MAS2_X0 and [4-0] bits for WIMGE */
 #define E500_TLB_MAS2_ATTR	(0x7f)
 
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 06e23c625be0..e332a10fff00 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -45,11 +45,14 @@ static inline unsigned int tlb1_max_shadow_size(void)
 	return host_tlb_params[1].entries - tlbcam_index - 1;
 }
 
-static inline u32 e500_shadow_mas3_attrib(u32 mas3, int usermode)
+static inline u32 e500_shadow_mas3_attrib(u32 mas3, bool writable, int usermode)
 {
 	/* Mask off reserved bits. */
 	mas3 &= MAS3_ATTRIB_MASK;
 
+	if (!writable)
+		mas3 &= ~(MAS3_UW|MAS3_SW);
+
 #ifndef CONFIG_KVM_BOOKE_HV
 	if (!usermode) {
 		/* Guest is in supervisor mode,
@@ -244,10 +247,13 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
 
 static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
-					 kvm_pfn_t pfn, unsigned int wimg)
+					 kvm_pfn_t pfn, unsigned int wimg,
+					 bool writable)
 {
 	ref->pfn = pfn;
 	ref->flags = E500_TLB_VALID;
+	if (writable)
+		ref->flags |= E500_TLB_WRITABLE;
 
 	/* Use guest supplied MAS2_G and MAS2_E */
 	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
@@ -303,6 +309,7 @@ static void kvmppc_e500_setup_stlbe(
 {
 	kvm_pfn_t pfn = ref->pfn;
 	u32 pr = vcpu->arch.shared->msr & MSR_PR;
+	bool writable = !!(ref->flags & E500_TLB_WRITABLE);
 
 	BUG_ON(!(ref->flags & E500_TLB_VALID));
 
@@ -310,7 +317,7 @@ static void kvmppc_e500_setup_stlbe(
 	stlbe->mas1 = MAS1_TSIZE(tsize) | get_tlb_sts(gtlbe) | MAS1_VALID;
 	stlbe->mas2 = (gvaddr & MAS2_EPN) | (ref->flags & E500_TLB_MAS2_ATTR);
 	stlbe->mas7_3 = ((u64)pfn << PAGE_SHIFT) |
-			e500_shadow_mas3_attrib(gtlbe->mas7_3, pr);
+			e500_shadow_mas3_attrib(gtlbe->mas7_3, writable, pr);
 }
 
 static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
@@ -492,7 +499,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, true);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 	writable = tlbe_is_writable(stlbe);
-- 
2.47.1


