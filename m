Return-Path: <kvm+bounces-35225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC2FA0A817
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 10:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3075D1887F67
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 09:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B72199234;
	Sun, 12 Jan 2025 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPw9wnow"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2F1AC88B
	for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736675745; cv=none; b=StRE37oTjXKrXkZJeLCFizgT5jMGtA/cqpRMRMv9EBKNhq0Cky435a4DTC3pKWlBqldEIHo/Y1NYtE7DUGgAzWLYvFklu0Suk+gJl6UWWDbMLIs8ALhpsWvHmIkLpPVRBBiwRk6fKf+2vwCbt83iB49ookky8J0lWYeYLyN5VQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736675745; c=relaxed/simple;
	bh=PYlVa2Y/YXHDakzTrdegPPAivF2UKPgqtms42a4RRMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwJuZ4L/Xn9XZGzsAkZCVFmWOZtD4Ad7nMKKUIQQGJfhlpgJ+WRau38ehSAaCfndbh3E3SNCHC00RjdPk9wki32F4p4SrmZjQCxJcAQJXSYx0ff3gkzFEE5OLlQt+T5IyUvFdh0dnvUksMl4LpJ+C8pWgm4hQtOzyv+82s0HglQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bPw9wnow; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736675742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZOi2vhUk9IqOWLL4VjvE3yvErD9voRzbqxDd4bb0e4=;
	b=bPw9wnowqcwKRJRYZGQ/jyaH3WX2DcQ4BXJgTWV3cJiXQ7bTr9She/My2WtvZkgrAGilm+
	Wsi3dXapEaPSU14uF7qpCFb0OoL250bVBbilgyBpUIQRwpZjbLAGhkGqwVcOO+H2ZJ4Egc
	dK51UBvidGAjfyIH9mdHDIC1m08JwxE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-qWWX-L79PKaGn2UkwXMxVw-1; Sun, 12 Jan 2025 04:55:41 -0500
X-MC-Unique: qWWX-L79PKaGn2UkwXMxVw-1
X-Mimecast-MFC-AGG-ID: qWWX-L79PKaGn2UkwXMxVw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aaf8f016bb1so318040866b.2
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2025 01:55:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736675740; x=1737280540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZOi2vhUk9IqOWLL4VjvE3yvErD9voRzbqxDd4bb0e4=;
        b=WWKM20GRz7JGBzQlyP2edcpJzrpHqZ0gxgrAxcjeJ170wBm6M3wiHZ0wHTcTJjN9Dl
         /LJEn+RZH/Eq7ujUeAgczVxBB6a5RIlzxbdc3C6xI47eHTiZLrppvmsJ0Q1DelsLYjNj
         aoBpEipx9lBfnMCq0xqXuyXNTKTjBzoxH/tZAc6nr4P51i64wpHbCvRSBy8VaokvhfEt
         0OJaQGHh2lQkGFBOlUR3Um6HXgob3rdffJtChAb0KbsCWeBFOKtmMAmcBOK0TQFNOHLF
         K6bRjhFsiHNf5rhHH/+SUQ5QGmYx96R9Y/etVfo6jpzFDSM453oHnbvKAKnv1TdgCmDj
         DFuA==
X-Forwarded-Encrypted: i=1; AJvYcCXBEhPh0jtyExLe+83omKwPvs1JwGqsjKxStu/bdeuO3NS2HDzGkjLxikumeZM/AOEHh5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvZqbnmX7RfzJ5CORODe2LLSZfMLGuw5mUG0LZ3kSuZE7cd2Xo
	xlKTx7DxvAVNjRLQu7qU7kPva8aVmpp/GtKLInj5riHZjgA0o2LuKCnYc+vGQQeyN9YXC36oQ6d
	bPnWn1csbkjdDm/sM/l1j+1HjP34c4Yphn6F56LJjvzlm5IAPUg==
X-Gm-Gg: ASbGncsus7zUDY2pGGe4cFmYUccBqQfuuqVtGEw4JxIUZ5QM8Hvu9d/868ZZTosk4X2
	9PUrKHnNhYMnGgaOzNEk/rf26LcBk0zN11XR+cg5li91xKLCHVQ2FLKUBHkKM1vRcqciK4fKykZ
	C+ohEJCaTcvXMBeySSYgsTcePnE8GJiC0PcB2KZka5Bo5GIuJ3iKZgQtSrpTVT+ZyodEU85gp7P
	AeKmXXRhG43HPLRoKbygITMCkfcnVpoiUzLgCGfQzPJREi7VvtvCHpJDzg=
X-Received: by 2002:a17:906:f58d:b0:aab:f014:fc9a with SMTP id a640c23a62f3a-ab2ab703f01mr1331418366b.22.1736675739788;
        Sun, 12 Jan 2025 01:55:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYiuGhI+4msFAOUKvZ179BJ3utaua0uWFviKs7CY/tGCvPWvPtqZvorhRWNQWYuMTsu6u8Aw==
X-Received: by 2002:a17:906:f58d:b0:aab:f014:fc9a with SMTP id a640c23a62f3a-ab2ab703f01mr1331416766b.22.1736675739453;
        Sun, 12 Jan 2025 01:55:39 -0800 (PST)
Received: from [192.168.10.3] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2e8c753fdsm226853266b.184.2025.01.12.01.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 01:55:37 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH 3/5] KVM: e500: track host-writability of pages
Date: Sun, 12 Jan 2025 10:55:25 +0100
Message-ID: <20250112095527.434998-4-pbonzini@redhat.com>
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
index c266c02f120f..b1be39639d4a 100644
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
@@ -487,7 +494,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	}
 	local_irq_restore(flags);
 
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, true);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 	writable = tlbe_is_writable(stlbe);
-- 
2.47.1


