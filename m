Return-Path: <kvm+bounces-30800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A89D09BD5EB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC6401C21851
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582D020E020;
	Tue,  5 Nov 2024 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rc5uf6xF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F620E011
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835283; cv=none; b=YlWiTD6kvtY1i1CN2Xtuno3+zmDlq4uZqpJfbodB4pwkhDJVJ1he8pWkpdiyVYp8El08s3aJUj4MNjPNG0/GDNw9rCV4JUVnV4rv1p3rUElOsQYg6T0j22V9eiqyFz6xH3neOxlQhLHNCEr6TYGRbX6E9lyJi1JantcJRdXgTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835283; c=relaxed/simple;
	bh=kInf2EvZvTDFfM9GExpyeELhxqydn4SRTx15KOOumDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kl9H2OG8aMegbi5HloVxG5VNbxXSjaM4lbcwVhdMYF5dlBMKyxBjeVY8BegALLavoSat1ypqIWNw/OF0jjfx/BgQwdzioiw0UoXmhyymo3xBoyIg4GAkclO3q/psEFqJVQlMxN3gpkuUXcilDRIwnkMI6C6z64pqJobsNw/IUB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rc5uf6xF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e789e56af4so5861135a91.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835281; x=1731440081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4Mhq6EID/2WIdk3/r42uHlqiQKnepXjHLSNkiOJBVU=;
        b=rc5uf6xFFW3qXIVGZg8mrWEuuVLmAF1Kdfa3vuFiY6yGW5npQSNFJJaoXW0kvsZeyo
         /2jUXBE8lbec5DHm/3yHKU22C9c+3LYO4VpEdfRyjEB0aqz+XHRAsX5LGFUSR3LM69w1
         o21vmuX6RuyMRVYLoug55fLYToY5op9szXc+bP3Tmjl0KHJKXPePCAvy+xrITgiqqSeo
         0dWAFHR3XhEUrtaxuC4XOTH66nYYkglOqEtORUznfCMgXpllFeFitNZNiT3mzq/vIoRw
         IC0JHjVrJxHtJCUz1/S2MUKGnRexXI7l8cB5Wpr3QkS0vW9NO1Cwjq5FDtiB/WfOc50T
         j+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835281; x=1731440081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4Mhq6EID/2WIdk3/r42uHlqiQKnepXjHLSNkiOJBVU=;
        b=dqQoYlpChZP3DWwpWNRPi6b1VPEuqXSBFQJVxISbei5OiQe3YpfBADJA1kN1SzwS1I
         RPNdjrrCnKxMoWOJZHz8x/DeE5rawx/U12F+EYJfurnGjVxEIzGABk7z+GpVG8kUo1QB
         PZxpg1S2GjUX+5NisfbT3La4jM5tCbjQGf3QZL5PBM2qzeYWG4F28vCHSO5FXv8t0WNF
         Vov/i0iSBsAi15Y+/7I8V2DlgSNJfvQkLiZoZy0boN9VO25L4J61udC1C6+VIRtA2fbR
         Nv5eUPzyWAtN0R8WzqaDv81VMpAo8i1mlw27sDzn7nYF0vtseKC/bGn0EnYWPG92lRFf
         26cg==
X-Gm-Message-State: AOJu0Yw4jYTxeNSx1oFOGOI1mLyK7mK6+up2fe8C66GGA+rpy/9xXVBi
	dd6M21M9CbnIWs2GjiXAomlmJIp4foCMWb/9XUUR8ii679BNt2HTFdOm0XstXrtoPGCJg+lfxIC
	qn6FDwubD3BTCPTjb/69QzF0rKZco+w4CqebJ153KChND2B694Q7Ut9yvJscDM0Lr69NFM3HAkC
	srKdxROBx4cvDWwvN1Zbp29jXRA9llDkNUUPKNo8P+mfAp6jnVQj3hnCI=
X-Google-Smtp-Source: AGHT+IHz87qcpvtxC/VkG/BAwyvAhbHecX6y27KXqrrfOGHWL9v2Og5+yEETZmaCHahb+olcpsw/2zunD1KFOhiGpw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:4b86:b0:2e2:a63a:22f1 with
 SMTP id 98e67ed59e1d1-2e8f12f0e78mr58808a91.7.1730835279381; Tue, 05 Nov 2024
 11:34:39 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:21 -0800
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-4-jingzhangos@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: vgic-its: Return device/event id instead
 of offset in ITS tables restore
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

In ITS tables restore operation, the id offset is passing around during
table scanning. But, e can derive more information from a device/event
id, since device table and ITT are indexed by the id.
Pass around the next device/event id instead of id offset to ease the
implementation for incoming changes.
A side benefit of this change is that the 2-level device table scanning
would be more efficient. With the deivce id, we don't have to scan the
L1 table entry one by one, the scanning can jump directly to the DTE in
the L2 table.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 56 ++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 953af024d94a..867cc5d3521d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2041,15 +2041,17 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * (non zero for 2d level tables)
  * @fn: function to apply on each entry
  * @opaque: pointer to opaque data
+ * @l1_tbl: true if it is a l1 table in a 2-level structure
  *
- * Return: < 0 on error, 0 if last element was identified, 1 otherwise
- * (the last element may not be found on second level tables)
+ * Return: < 0 on error, 0 if last element was identified, next id (device id or
+ * event id) of next valid entry.
  */
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
-			  int start_id, entry_fn_t fn, void *opaque)
+			  int start_id, entry_fn_t fn, void *opaque, bool l1_tbl)
 {
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
+	int next_id = start_id;
 	int id = start_id;
 	gpa_t gpa = base;
 	char entry[ESZ_MAX];
@@ -2065,8 +2067,16 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 		if (ret)
 			return ret;
 
-		next_offset = fn(its, id, entry, opaque);
-		if (next_offset <= 0)
+		next_id = fn(its, next_id, entry, opaque);
+		if (next_id <= 0)
+			return next_id;
+
+		if (l1_tbl)
+			next_offset = next_id * esz / SZ_64K - id;
+		else
+			next_offset = next_id - id;
+
+		if (!next_offset)
 			return next_offset;
 
 		byte_offset = next_offset * esz;
@@ -2077,7 +2087,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	return 1;
+	return next_id;
 }
 
 /*
@@ -2128,7 +2138,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
 
 	if (!lpi_id)
-		return 1; /* invalid entry, no choice but to scan next entry */
+		return event_id + 1; /* invalid entry, no choice but to scan next entry */
 
 	if (lpi_id < VGIC_MIN_LPI)
 		return -EINVAL;
@@ -2158,7 +2168,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	}
 	ite->irq = irq;
 
-	return offset;
+	return event_id + offset;
 }
 
 static int vgic_its_ite_cmp(void *priv, const struct list_head *a,
@@ -2238,7 +2248,7 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 	size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
 
 	ret = scan_its_table(its, base, max_size, ite_esz, 0,
-			     vgic_its_restore_ite, dev);
+			     vgic_its_restore_ite, dev, false);
 
 	/* scan_its_table returns +1 if all ITEs are invalid */
 	if (ret > 0)
@@ -2280,8 +2290,8 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
  * @ptr: kernel VA where the 8 byte DTE is located
  * @opaque: unused
  *
- * Return: < 0 on error, 0 if the dte is the last one, id offset to the
- * next dte otherwise
+ * Return: < 0 on error, device id of the current DTE if it
+ * is the last one, device id of the next DTE otherwise
  */
 static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
@@ -2303,7 +2313,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
 
 	if (!valid)
-		return 1;
+		return id + 1;
 
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
@@ -2321,7 +2331,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 		return ret;
 	}
 
-	return offset;
+	return id + offset;
 }
 
 static int vgic_its_device_cmp(void *priv, const struct list_head *a,
@@ -2409,33 +2419,33 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
  * handle_l1_dte - callback used for L1 device table entries (2 stage case)
  *
  * @its: its handle
- * @id: index of the entry in the L1 table
+ * @id: the start device id to scan in the L2 table
  * @addr: kernel VA
  * @opaque: unused
  *
- * L1 table entries are scanned by steps of 1 entry
  * Return < 0 if error, 0 if last dte was found when scanning the L2
- * table, +1 otherwise (meaning next L1 entry must be scanned)
+ * table, device id of the next valid DTE otherwise
  */
 static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 			 void *opaque)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	int l2_start_id = id * (SZ_64K / abi->dte_esz);
 	u64 entry = *(u64 *)addr;
 	int dte_esz = abi->dte_esz;
+	int dte_per_table = SZ_64K / dte_esz;
+	gpa_t gpa_offset = (id % dte_per_table) * dte_esz;
 	gpa_t gpa;
 	int ret;
 
 	entry = le64_to_cpu(entry);
 
 	if (!(entry & KVM_ITS_L1E_VALID_MASK))
-		return 1;
+		return (id + 1) * dte_per_table;
 
-	gpa = entry & KVM_ITS_L1E_ADDR_MASK;
+	gpa = (entry & KVM_ITS_L1E_ADDR_MASK) + gpa_offset;
 
-	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
-			     l2_start_id, vgic_its_restore_dte, NULL);
+	ret = scan_its_table(its, gpa, SZ_64K - gpa_offset , dte_esz,
+			     id, vgic_its_restore_dte, NULL, false);
 
 	return ret;
 }
@@ -2460,11 +2470,11 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     handle_l1_dte, NULL);
+				     handle_l1_dte, NULL, true);
 	} else {
 		l1_esz = abi->dte_esz;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     vgic_its_restore_dte, NULL);
+				     vgic_its_restore_dte, NULL, false);
 	}
 
 	/* scan_its_table returns +1 if all entries are invalid */
-- 
2.47.0.199.ga7371fff76-goog


