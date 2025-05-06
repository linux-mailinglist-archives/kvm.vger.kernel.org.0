Return-Path: <kvm+bounces-45638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFA4AACB5D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30854505943
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B132882C0;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzSBZe8N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04381287501;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549854; cv=none; b=DYQP7Qq/8jxRaotTdGSdUzzyv1J9ihD0dR8rJZbcwkCrmFNT0dEXCwpIJH6i8zIEjbrFdjsfuCKUVUhIFoGishrSa6y2tavBBm5KI5C1f2noo4HZZnJxu8AB6ICnE1cIaZpt8yy9kVbx1rSoFQ5ebnTAhhqMvXBhX5XVINGXFBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549854; c=relaxed/simple;
	bh=QlIqmV68xTmqg1xztLJcaMauQklC0Pa/jGY/+EYEyfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LJI+tXv7UcgqxzKx90/JfAlS42EmYeA7/fa33On5wrVd8AOricixE8i3PScIzAdSlDTIhQwejXipFDO8yUMrR+apt6zvbpIazHEDwGx8heLMBg11vvzjWwAwAIDEDh3Zo46G1nPAB3cILg6a0OUbl5aM0KOiWonuLVaQOerKsKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzSBZe8N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D889BC4CEF2;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549853;
	bh=QlIqmV68xTmqg1xztLJcaMauQklC0Pa/jGY/+EYEyfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzSBZe8NuErTBkqoyVPeIcryz0ZN7/5Xe2l9e/3FBbAvVvUB8lOrb5EUHiei295xf
	 Wy2r/IMpLzdsKOXxLJ0uDZJxXypf4f6kjt8cvhrAXRVx3BSPB0JcOERsKLH0RSRQQF
	 iUmOFILxTzuUzg58fab+sGkPKS+JG9YwwBJ7dlv7yatw29GUhBl835D4gBewBLBow/
	 VtD5rMD3rEcHrZt5nZc6Iau1SUBugfI/OsA9pNCu2ACLE8Igm6jNzfeH3/366Qlp2h
	 QgIXM0UWY3Ndzoi+wZqpydfbADcclu5mKjO5JDh5mDCFnH2jW0O48vSPBDoJVXMMJ3
	 A5COOutt9GHLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOu-00CJkN-45;
	Tue, 06 May 2025 17:44:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 26/43] KVM: arm64: Propagate FGT masks to the nVHE hypervisor
Date: Tue,  6 May 2025 17:43:31 +0100
Message-Id: <20250506164348.346001-27-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The nVHE hypervisor needs to have access to its own view of the FGT
masks, which unfortunately results in a bit of data duplication.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 7 +++++++
 arch/arm64/kvm/arm.c              | 8 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c  | 7 +++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 95fedd27f4bb8..9e5164fad0dbc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -621,6 +621,13 @@ extern struct fgt_masks hdfgrtr_masks;
 extern struct fgt_masks hdfgwtr_masks;
 extern struct fgt_masks hafgrtr_masks;
 
+extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(hfgitr_masks);
+extern struct fgt_masks kvm_nvhe_sym(hdfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(hdfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(hafgrtr_masks);
+
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95feef..8951e8693ca7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2450,6 +2450,14 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 
+	/* Propagate the FGT state to the the nVHE side */
+	kvm_nvhe_sym(hfgrtr_masks)  = hfgrtr_masks;
+	kvm_nvhe_sym(hfgwtr_masks)  = hfgwtr_masks;
+	kvm_nvhe_sym(hfgitr_masks)  = hfgitr_masks;
+	kvm_nvhe_sym(hdfgrtr_masks) = hdfgrtr_masks;
+	kvm_nvhe_sym(hdfgwtr_masks) = hdfgwtr_masks;
+	kvm_nvhe_sym(hafgrtr_masks) = hafgrtr_masks;
+
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is read
 	 * while the MMU is off.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef02618..ae55d6d87e3d2 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -33,6 +33,13 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+struct fgt_masks hfgrtr_masks;
+struct fgt_masks hfgwtr_masks;
+struct fgt_masks hfgitr_masks;
+struct fgt_masks hdfgrtr_masks;
+struct fgt_masks hdfgwtr_masks;
+struct fgt_masks hafgrtr_masks;
+
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
 static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
-- 
2.39.2


