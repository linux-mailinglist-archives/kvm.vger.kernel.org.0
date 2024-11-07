Return-Path: <kvm+bounces-31187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6019C1131
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1580D1F24DB3
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10C7218D99;
	Thu,  7 Nov 2024 21:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYLNIOy0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5CC2185B9
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015707; cv=none; b=fpVXd/q63v3tUVOUSCdJWjSssP+mBc1PQEJPlP3nq6WMGexDx2nMxd8a9RKxAlslQuCeKRIX5sEVd3z2H+4qUBHMaN+I3Tp+FdRh1VWlKXY6g9nqoHcJVqLvgQPLdROXmUPFwUkgpmNi9gotRCX9PA6j4c4NP2O8FRFY/uA3/wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015707; c=relaxed/simple;
	bh=ycEwchMVeREbQDrNSvN/2lCAjf1GulsvRaTBPk8AK3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q4uY2J32bhVv62b+RB+8PKC+rmX/RyrjEX+UGh0iETT3xlH9Kj8sDoofgMJXpMxX1ULHfZu10KX2hKloAO2I2061SIJ5MveLQsxOGegQcfD+XLEc5OLByzh+ZU060jaHdPpj8zFiMtIPDFFvWWW8Ow0H4NH4HuMQHT+szSZ4dOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYLNIOy0; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e330f65bcd9so2268533276.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015705; x=1731620505; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+HGLva8x9odObzptOfMBkr9/TxQLRpKS7Miz1lBZC1M=;
        b=TYLNIOy0exkmQPD7bdgm8fqZDGARQ+cT/AbKEd76gYI4FZpMJ/Ip5b/L4hmdh35YJM
         nbX5MovZiuNeLVecTl45+I6WTrUB0ZJwLiPVKPh2Mxo4CYrjzXwZN0opRW/0k8A24fe0
         4nqOBtgWHEwsalLozgVCkOA7/F1PSILX2GEk+G8ZGlf7Ut1L3aqB7SMpf+tVGnEG36OE
         iLJIOI4CSAnNWjfVBwUj4AQwYuM6UNBGM0ToBFTd4jOsBTKdbS+BsPgUM0NefNeP+6I/
         7ghoq96VrdDA3EuV4gIDzp/1jijNNOlpCfus0zSvTYH4X3nX4JkgNTYvQcLXhmt9otKS
         HE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015705; x=1731620505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HGLva8x9odObzptOfMBkr9/TxQLRpKS7Miz1lBZC1M=;
        b=ZAxiz0g4vF74yyf2Fv4tUEvsLjz+K2+f2HD62KzQg90JpplYoFaNUQzy6pltRKXXjG
         NyAW+Uq7c49zqWm8Ik11ScG3gBCIm7fXFDJw6h+4elx3gAletgpEpwJ6jCUYGEI9GllP
         dpQqz7wSEag4tpaxmNKjgI4WVL49vaqRKPX6AB/hOgPsvmu53r1Z4073orNd/1/vZzPw
         EudmjM3TppOq0gNpF8jFFAP21KXdnoHIEekI8h0sQipZppGSuBezZ57M504UcDdn4J5C
         GtZyHKcEop5onkv7hoFLnbouzbZ1FINReGbFfXV+qB0+O9BQX/So+nmRxqrV5uqrcSJl
         sVKw==
X-Gm-Message-State: AOJu0YzwjIROM3s1+HHc8Sr1GQ0FFJDqsv3tdh+DKBxSTbYfpcPqkgF/
	gc0yRSYDMKocEGlCdccrDgtZy4sHZmq8y0StCRkJS6F4VEsfNK/Qv2lsP89+u0NvkwGA2tUin9I
	ODVr/P6XLad5Wa3TdWCzSnFxVHu8xHlGvLND7CX33aT4NbfRkC9vxCKIV/EKDe7jDVYXY1/x0Vt
	ka1Yw4Sg47c56ZkQzuRd0yPhiwt1UF32SIzYbrfCqo5q0FN9Nq3Tp+J3A=
X-Google-Smtp-Source: AGHT+IFc0PLyo+kb0an1Crt410TnBfN08WjncHVRt9wOAEQvXdRMVzovySNeUUyzLZxRzXVJhn2du4OY9kLn+4Hz5w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:abac:0:b0:e2b:db24:905e with SMTP
 id 3f1490d57ef6-e338017a945mr1306276.5.1731015704930; Thu, 07 Nov 2024
 13:41:44 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:35 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-4-jingzhangos@google.com>
Subject: [PATCH v4 3/5] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

In all the vgic_its_save_*() functinos, they do not check whether
the data length is 8 bytes before calling vgic_write_guest_lock.
This patch adds the check. To prevent the kernel from being blown up
when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
are replaced together.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with the new entry read/write helpers]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba945ba78cc7..9ccf00731ad2 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2086,7 +2086,6 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 			      struct its_ite *ite, gpa_t gpa, int ite_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u32 next_offset;
 	u64 val;
 
@@ -2095,7 +2094,8 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, ite_esz);
 }
 
 /**
@@ -2239,7 +2239,6 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 			     gpa_t ptr, int dte_esz)
 {
-	struct kvm *kvm = its->dev->kvm;
 	u64 val, itt_addr_field;
 	u32 next_offset;
 
@@ -2250,7 +2249,8 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
+
+	return vgic_its_write_entry_lock(its, ptr, val, dte_esz);
 }
 
 /**
@@ -2437,7 +2437,8 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
+
+	return vgic_its_write_entry_lock(its, gpa, val, esz);
 }
 
 /*
@@ -2453,8 +2454,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
-	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
+	ret = vgic_its_read_entry_lock(its, gpa, &val, esz);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
@@ -2516,10 +2516,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * table is not fully filled, add a last dummy element
 	 * with valid bit unset
 	 */
-	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
-	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
-	return ret;
+	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
 }
 
 /*
-- 
2.47.0.277.g8800431eea-goog


