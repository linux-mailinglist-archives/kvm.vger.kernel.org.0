Return-Path: <kvm+bounces-30799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB3F9BD5EA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB391C220D8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62A520E010;
	Tue,  5 Nov 2024 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h6bqx5Yi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995BD20D4FB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835281; cv=none; b=ZSPyYt58acdk1ZLb5QRLP3tisXk+ez4X4jLOpbmhS/C0KUU1hYWcNlIokw83VsVybkgIg0F0xIPSJ1ZENcv4rhNgzsnLDel449LCNv93miNiUD7K65RjI/Oj0kwErdSY2Bn6u4fcNJN9NXI3/84acpdm6GJQdimP2C82qT0ZoTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835281; c=relaxed/simple;
	bh=xdNcukuTERaKxdjm3d+G9aBE5BSfY/AAIxxR5qezXks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YBTN2D/y1Kvy0X60VaC90t4DaCug0BcFbA6shuIhQrmsFd8lDOHinGEZYtdFVIZgrE3fkxNovzFw9NIis5VP0YK6VhRdzhXFl0VLWsi5PxBx/eO3Bgm1KtzGrLLyL2L8xv1UGUpiSKFkNQ6VsgjkwZAvlcN7WK3/2g99XvLIU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h6bqx5Yi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e479829c8so7460562b3a.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835279; x=1731440079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BFajokhhFV4XM1IVMgUFGnhvSX98bkK7pakRqkac4YA=;
        b=h6bqx5YiEmHVyV/56ppEhtUvMl7WRgmaHmMPugdb2UaGEBHAeyPgD2Ov0jGcfYh+jq
         JaeqFhfDnuTDcpfHaqOzZ3kbdybVQSeMuvKU7kDn+fQmR0hKE5ZgcPHuz45+cyY2d0sn
         3OunY2oQbvnEhXkzl8YDIJqzHTq8++p2+aoUjsVvbKHgtaHoDEjFWQqHfiE0TiL46ezi
         gXFNXyVUosiekzfQfsz/BVx+tF/3vfdylrvC2xsCHI9yhRx7cDPPJ84e2+goMIn9F2YF
         oVSsmt+45R0po+E9dw83VFzCmsj2kHDbOwUN2Ph/dCYmnRSSWQbfzCpC0KlUcelAV7Od
         9odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835279; x=1731440079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFajokhhFV4XM1IVMgUFGnhvSX98bkK7pakRqkac4YA=;
        b=uqPbAOAhCWN6LZP3GJI4YBpabNuko9XAtDs7YREtp4n3EBuuDEVMBmt4ys2G6y2nSg
         Hov5RtCJZ82o78scbLZQwdBA6q1YNjsX6kQh7G8M7C9XXyZmv31yq1FWGBZBuekY6gHt
         XmkNxYk9NPqLgM2IoOWrAeI1cguIU2pR/k3nGBY5H4MPsi5xw8+1i4TujzdVtanEy12k
         XYtZDMUVA1lUf4fybTlRm05qRmUAsJPv6EsNXdoPHYPPnULWQL0SOCrT+ZEx2qwHt2pP
         0Nb3dlVhh/IRjmSRc3kJVui/Qh/HdKuYuGkXteRfuIN5wMVrPrzvJ8zkyHMzUb2qXDn9
         Q3eA==
X-Gm-Message-State: AOJu0YzAJJpTjulJrAPVaZfBTrSGxg2SSodPW5fZfjGIUzaXkhW0WGy0
	b3GrE0e4HzzbfAd831wXPxFVd71uZEY+rwSKFjNVdcZ/zmAXkQ2BBWUJ25kGjunS059MzQnIavk
	qRuLINaj0X2W+1lxIEeq5TcwFjtBInHCnCRCx3g/4I502CgVP4Tz+3XK4fWohphTig5p04Vg5gY
	UK72/SY4FoECpXZyNKUn4JQAh7R4T5FAngAqL4QVtNIQRnHU0vTiyyn7Y=
X-Google-Smtp-Source: AGHT+IFs0jYQAmFSrOyPS5Iq6Vm6Duf7I7Iw8B4nNyWqeL8ps99nDwFFCl2y98EAYFGlrxHTSsLPk7Pni5p9u/hvxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:73a1:b0:71e:5b2b:991c with
 SMTP id d2e1a72fcca58-720ab661957mr65760b3a.5.1730835277696; Tue, 05 Nov 2024
 11:34:37 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:20 -0800
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-3-jingzhangos@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: vgic-its: Add a dummy DTE/ITE if necessary
 in ITS tables save operation
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

In device tables/ITTs, DTEs/ITEs are implemented as a static single
linked list. But the head of the list might not be the first DTE/ITE in
the table. That's why in the restore operation, the DTs/ITTs have to be
scanned to find the first valid DTE/ITE (head of the list).
Add a dummy DTE/ITE in the first entry of the table if the first entry
doesn't have a valid DTE/ITE. This dummy DTE/ITE points to the first
valid DTE/ITE if there is a valid one.
This change paves the way for future incoming changes which will utilize
the fixed head the DTE/ITE list to avoid scanning uncessary table
entries.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 56 ++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic.h     |  6 ++++
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba945ba78cc7..953af024d94a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2176,10 +2176,12 @@ static int vgic_its_ite_cmp(void *priv, const struct list_head *a,
 static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	struct its_ite *ite, *first_ite = NULL;
+	struct kvm *kvm = its->dev->kvm;
 	gpa_t base = device->itt_addr;
-	struct its_ite *ite;
-	int ret;
 	int ite_esz = abi->ite_esz;
+	u64 val = 0;
+	int ret;
 
 	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
 
@@ -2198,7 +2200,24 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
 		if (ret)
 			return ret;
+
+		if (!first_ite)
+			first_ite = ite;
 	}
+
+	/*
+	 * As for DTEs, add a dummy ITE if necessary for ITT to avoid uncessary
+	 * sanning in the store operation.
+	 */
+	if (first_ite && first_ite->event_id)
+		val = (u64)first_ite->event_id << KVM_ITS_ITE_NEXT_SHIFT;
+
+	if (!first_ite || first_ite->event_id) {
+		val |= KVM_ITS_ENTRY_DUMMY_MAGIC << KVM_ITS_ENTRY_DUMMY_SHIFT;
+		val = cpu_to_le64(val);
+		vgic_write_guest_lock(kvm, base, &val, ite_esz);
+	}
+
 	return 0;
 }
 
@@ -2328,8 +2347,11 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_device_table;
-	struct its_device *dev;
+	struct its_device *dev, *first_dev = NULL;
+	struct kvm *kvm = its->dev->kvm;
 	int dte_esz = abi->dte_esz;
+	gpa_t dummy_eaddr;
+	u64 val = 0;
 
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
@@ -2351,7 +2373,35 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 		ret = vgic_its_save_dte(its, dev, eaddr, dte_esz);
 		if (ret)
 			return ret;
+
+		if (!first_dev)
+			first_dev = dev;
 	}
+
+	/*
+	 * The valid DTEs in the device table are linked with a static single
+	 * linked list, but the list head is not always the first DTE. That's
+	 * why the restore operation has to scan the device table from the first
+	 * entry all the time.
+	 * To avoid the uncessary scanning in the restore operation, if the
+	 * first valid DTE is not the first one in the table, add a dummy DTE
+	 * with valid bit as 0 pointing to the first valid DTE.
+	 * This way, the first DTE in the table is always the head of the DTE
+	 * list. It is either a valid DTE or a dummy DTE (V= 0) pointing to the
+	 * first valid DTE if there is a valid DTE in the table.
+	 */
+	if (first_dev && first_dev->device_id)
+		val = (u64)first_dev->device_id << KVM_ITS_DTE_DUMMY_NEXT_SHIFT;
+
+	if (!first_dev || first_dev->device_id) {
+		if (!vgic_its_check_id(its, baser, 0, &dummy_eaddr))
+			return -EINVAL;
+
+		val |= KVM_ITS_ENTRY_DUMMY_MAGIC << KVM_ITS_ENTRY_DUMMY_SHIFT;
+		val = cpu_to_le64(val);
+		vgic_write_guest_lock(kvm, dummy_eaddr, &val, dte_esz);
+	}
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2486b4d9f95..93314f249343 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -86,6 +86,12 @@
 #define KVM_ITS_L1E_VALID_MASK		BIT_ULL(63)
 /* we only support 64 kB translation table page size */
 #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
+/* Macros for dummy ITE/DTE */
+#define KVM_ITS_ENTRY_DUMMY_SHIFT	0
+#define KVM_ITS_ENTRY_DUMMY_MASK	GENMASK_ULL(15, 0)
+#define KVM_ITS_ENTRY_DUMMY_MAGIC	0xdafe
+#define KVM_ITS_DTE_DUMMY_NEXT_SHIFT	16
+#define KVM_ITS_DTE_DUMMY_NEXT_MASK	GENMASK(48, 16)
 
 #define KVM_VGIC_V3_RDIST_INDEX_MASK	GENMASK_ULL(11, 0)
 #define KVM_VGIC_V3_RDIST_FLAGS_MASK	GENMASK_ULL(15, 12)
-- 
2.47.0.199.ga7371fff76-goog


