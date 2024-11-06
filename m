Return-Path: <kvm+bounces-30866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5408A9BE0F9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4395B24763
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B553D1D5ABD;
	Wed,  6 Nov 2024 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZgQrkVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EF810F2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881844; cv=none; b=siNJ/Ut2chqYqrqUYuSF0tcwrlUIkXgHK5OsJRZQXbnD4TT6APbq+yS4Y0p8+wMuJpVb+m1x76RtfUpZ+ZOhqqI1FQ6sc3c/maxhMt8na09GzCCQYdT0eZcQfRF5Ji7K4D+GQASJAVx0WSadt4UOgnMzmvm+WU262kLnVfcikm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881844; c=relaxed/simple;
	bh=yF+g4F+OY52/0KR1mFa7JxszhZTeu/CQOWPnoX3pVpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oYoTkFOC5Xp2I7MDXeOQfnZt8whqhXKElq7b9+Zpa8yEOrn4wi+1+rqtW2VG7Q0DygTcbm0oKqlgrHYKtxkjQ6cg4QZEXY2+ECw0XPASE8yGenFZoX6v4zaHQ49y0r26QMA6V3VtKDz6pu6Ney9O6OA8gd+PcULPtvl8XUA0X8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZgQrkVm; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so11338374276.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 00:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881842; x=1731486642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4GbN8ZDurMjcmVHL6T0Xi9xUq1GYOGvqk92rYIEnWQ=;
        b=pZgQrkVm4KgLsfmgiNSe4uCBlY8VOKl2xEm5iNdZv943Fe/523Fy0cRVzfCRhE+rIM
         mSZ46W4+r08KoIOqKvdtqKnuMfYMKUHyvL/ALt7yQ6TuX6w6950TuZ/x5lusflKc2rsm
         /KF5Qz+NK9cEB5h6q2MH3Ba2U5lVf/stILBWWz22VpDKBWEhW+w3NaqgKW5+hSO5WcJY
         X+/4PHBUt9ReOXukkD12h7vJnUFaZgJk/TKvB77M4aHx4A1kOfh0U5kLq9iaohjClrDU
         rJMtidg4VjQwJzZrxvCCUZc4259L9Qym6CUhvzeHHgOoQBWcQz0aRVaLirZQO66peFgM
         lUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881842; x=1731486642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4GbN8ZDurMjcmVHL6T0Xi9xUq1GYOGvqk92rYIEnWQ=;
        b=vviV36BCuWVrCt/X8GJ0M+78oYqFQAiHzWatV+WF5a9RF01URR5I8gNcC7gSu/5EfX
         xxLRLzxlhAGC1bUZcfYnk2mNVVqWVnuGmRPFFXW4uCgXTO9eNVzzzyORLXKw5OuRl3Sb
         xjtZDIbayUAWFTAU06IuSVwc7WkR7o17yX86jBlYtapdtZvRSJtdnot9mU6b+dEqOGg4
         sPbelWWSzYrm2LzrZlLApXdo+hFyBHQ/SBeFcZnPsuYp0vZ0Q5daE4YNOFlyZT0aWTKl
         7ddO7N6P1m45LvstaJ0xuOKFFooEKBULSuq2cHvaMorokk0l5OeO1RF5yZbhuSPn5ENY
         63fw==
X-Gm-Message-State: AOJu0YwzCydDDMN1BFIRRtClLZlmbXMPk6/naqr08fjO2P7xGHJkleWm
	q7mJCiDewnjs9oI9E0acVFh1Ls284RUskNgX5Nv7tIIFWp95vOY8Gqfr+q5OQ+WKB6fgEL7G/1T
	6NZNrRHQlVdN5EMyRuTjdB5FaZDedB1HlZooa7qfAWbpDD7a4mOC2taP5oxZR0R59NgMogBmXEk
	8rlyPTSg1U/T0N77xOxBGfIazmJU2yIK/9yCwS3ZCkC7aDE0w3jJ+5nec=
X-Google-Smtp-Source: AGHT+IESgZ2HUDGTGAdUvYoZM+ViRqBFK9RcS/H99OhminhorZqyukanemB5KOr2KI9Z7I4wBJZ181jopq1rHk8LBA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a5b:308:0:b0:e33:2432:8b75 with SMTP
 id 3f1490d57ef6-e3324328dedmr19767276.7.1730881841856; Wed, 06 Nov 2024
 00:30:41 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:32 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-2-jingzhangos@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

In all the vgic_its_save_*() functinos, they do not check whether
the data length is 8 bytes before calling vgic_write_guest_lock.
This patch adds the check. To prevent the kernel from being blown up
when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
are replaced together.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba945ba78cc7..2381bc5ce544 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2095,6 +2095,10 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
@@ -2250,6 +2254,10 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
@@ -2431,12 +2439,17 @@ static int vgic_its_save_cte(struct vgic_its *its,
 			     struct its_collection *collection,
 			     gpa_t gpa, int esz)
 {
+	struct kvm *kvm = its->dev->kvm;
 	u64 val;
 
 	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
@@ -2453,7 +2466,9 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
 	if (ret)
 		return ret;
@@ -2517,7 +2532,9 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * with valid bit unset
 	 */
 	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
+	if (KVM_BUG_ON(cte_esz != sizeof(val), its->dev->kvm))
+		return -EINVAL;
+
 	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
-- 
2.47.0.277.g8800431eea-goog


