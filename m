Return-Path: <kvm+bounces-30801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 397859BD5EC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A13D5B2224D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3326A20D50E;
	Tue,  5 Nov 2024 19:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0240DgsS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4CC20D4FB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835284; cv=none; b=cPsloUOghxsw2IurnuXUsjK9kFzS5QuI4ur99EzcECpCuwdx/lXRIYTDtJCPAoD5fU/lD9ocYWXjccaN8/9sCkFMIugCAhe+I1sD2aFd9v9xwQfRwqwaMf+a193Z8dUaBf2A4NoBueiTLBbcQUpGIMo38HcX7WGGPPJ1EhvfHTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835284; c=relaxed/simple;
	bh=xPd4i6jpgEFj3QDbxccFoSZ95IE5WTJsPwiUZwvNonU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HKHh9YA5UnG7O74uk+2EPCTwV8RsFjP4wuzQnHEdwYNw0+WSN6adge2aLI/IW+EKkVGIjOAwP0HrCvbZBB44er0cDCT+U+PQn3AUkrEMCCzICC/tVVclOqUEgJkbSpPY0bIStOXOn+EsPIAwx6/lB+LwbjWvvd2gIstSjESi5AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0240DgsS; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2939e25402so9057412276.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835282; x=1731440082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rG28HMeFmKNz149Y+Vw5VAUYNp3YmfGstywpzoeBNY=;
        b=0240DgsSBDx2uK7lLTM6mjfTsqpelD8VfKn7MkZzR6DTxA3ddkeWNlhKgU86IazVJ/
         /WgD63d7KrGzNg3Q/17to/fF46ACqKFBI2r9aKVcyZNztFE6QU8VVxRcrUdLhIkVCbpV
         ZUNAp4nP8XUoPL6xximF4661m9A8nUfElH4GBpPNFxIsMRwYxqWET2LPo842k9ZPwZ1U
         OTsgh+JDtF5fpVAneMNv3IuoxBvFurMUNa1rkBB8t+nvQhXyUEFN1lZvAnliWWt19mHO
         BAZG5MshVdW0sNmR/iiClR6iUzDcTJiEZUZpXROpEGhRKhUH8v2AGZA2ObhNp1Tdolza
         JUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835282; x=1731440082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rG28HMeFmKNz149Y+Vw5VAUYNp3YmfGstywpzoeBNY=;
        b=hK5cOz+7+LQPKiuTSUVV1V0UY7FNRlFGvQcQKGgZ4CxoQ58kqcZeIm0NGXqM3Lnxn1
         FQTEXP3pRZO6qD6uNuLgmBl1LUuPCAq9a2q2RHebShjeWNboaDg0w/swBJMeEOuGtEUr
         sUeM/bDodL7vyAEUU+nkLg6aNQBOX174Gzao5yfyI3Y1Cc5bCfULuNGABoJn0iFKc27F
         DfPCjMmwRJvctG8dd+ogtR/GymP1xL2MALx+6eLiy9DYMX73pmudfEUF6mozoAwSLduD
         wRdUqHtj8gR6xPLmWSk/OgDskPJ4J8irx26MzTEHAeAGnAj8tZNm3Vrik4UcZVT/fMun
         SeVA==
X-Gm-Message-State: AOJu0YzQIA0w1/1Dm2TE0APeJDShmGLYu+OXRfKpaLBRl30oJPdJH70Z
	9QoVt8apOZNq8udwzP6uXUIbuNV+gn6oR3J1jl+QYLtK1kGJNN10U+MDELgXd+wK9yxbTAn6AoX
	QqoNlDf9p2dWeUIUDRAbhAhuSkd7925OEaHfgzusrnKFTnIrZAxNcxhhH7D2Da5X4fLlF30lqca
	l2gchTPYXeQpJXNmBY7A/jlp8qNAMnJsI2fF2AdI6j0aNym8h9qsyftXM=
X-Google-Smtp-Source: AGHT+IHSwjlYAEmxZvE3K18uqtu/bNQVHl4DA7qztn64qZnoHG833wnp2QKrs1chSkfAHMYdTQ7wPLIAKTndfwX+xQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:d616:0:b0:e29:76b7:ed37 with SMTP
 id 3f1490d57ef6-e3302669387mr18225276.9.1730835281208; Tue, 05 Nov 2024
 11:34:41 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:22 -0800
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-5-jingzhangos@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: vgic-its: Utilize the dummy entry in ITS
 tables restoring
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Now, the first entry in tables is either a valid DTE/ITE or a dummy
entry pointing to the first valid DTE/ITE. Revise the DTE/ITE restore
process to utilize the dummy entry to avoid unnecessary (erroneous)
entry scanning.
This is not supposed to break the ITS table ABI REV0.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 46 ++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 867cc5d3521d..e07939613f5c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2129,23 +2129,30 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	u32 coll_id, lpi_id;
 	struct its_ite *ite;
 	u32 offset;
+	u32 magic;
 
 	val = *p;
 
 	val = le64_to_cpu(val);
 
-	coll_id = val & KVM_ITS_ITE_ICID_MASK;
 	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
 
-	if (!lpi_id)
-		return event_id + 1; /* invalid entry, no choice but to scan next entry */
+	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
+	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
+		return -EINVAL;
+
+	if (!lpi_id) {
+		magic = (val & KVM_ITS_ENTRY_DUMMY_MASK) >> KVM_ITS_ENTRY_DUMMY_SHIFT;
+		if (magic != KVM_ITS_ENTRY_DUMMY_MAGIC)
+			offset = 1;
+
+		return event_id + offset;
+	}
 
 	if (lpi_id < VGIC_MIN_LPI)
 		return -EINVAL;
 
-	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
-	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
-		return -EINVAL;
+	coll_id = val & KVM_ITS_ITE_ICID_MASK;
 
 	collection = find_collection(its, coll_id);
 	if (!collection)
@@ -2303,17 +2310,30 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	u64 entry = *(u64 *)ptr;
 	bool valid;
 	u32 offset;
+	u32 magic;
 	int ret;
 
 	entry = le64_to_cpu(entry);
 
 	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
-	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
-	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
-			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
 
-	if (!valid)
-		return id + 1;
+	/*
+	 * Since we created a dummy head entry for the DTE static linked list in
+	 * the table if necessary, no need to scan to find the list head.
+	 * But if the saved table was done without dummy entry support, we still
+	 * have to scan one by one.
+	 */
+	if (!valid) {
+		magic = (entry & KVM_ITS_ENTRY_DUMMY_MASK) >>
+			KVM_ITS_ENTRY_DUMMY_SHIFT;
+		if (magic != KVM_ITS_ENTRY_DUMMY_MAGIC)
+			offset = 1;
+		else
+			offset = (entry & KVM_ITS_DTE_DUMMY_NEXT_MASK) >>
+				  KVM_ITS_DTE_DUMMY_NEXT_SHIFT;
+
+		return id + offset;
+	}
 
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
@@ -2321,6 +2341,10 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 
+	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
+	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
+			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.47.0.199.ga7371fff76-goog


