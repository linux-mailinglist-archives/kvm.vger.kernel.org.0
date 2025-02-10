Return-Path: <kvm+bounces-37720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 771DBA2F78F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A4593A2160
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A2325A352;
	Mon, 10 Feb 2025 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+Zcta8T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5952586E4;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212922; cv=none; b=AJDQR6Jj/PyhY775rn68mJMbcqiHFLTOwv5H+7fN9T/sFVoi+G46+jpMQkg//DgxrURm458rp3Ogh8KEQTI60lPxdqA+etr/KE1OcrlzkJnb3n//0FxeO6RR5YGIc7lsjQ273fiD3wUQhhl8Phjk9jDVuhPFEGJKtuaL6fMYEyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212922; c=relaxed/simple;
	bh=IyvY/24emCJGPMedHKkmlSSiSl5QbFscoFIXQQzs/r8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WNplaeya+mgi+iXVPEYlkEZZ6SY9kl0S22GmVq+dGG3dj/mO6wupGDb245i7yJytb98xOmk8XW+foVpkCbdZLAVnLmSFz6xYA6UEBfVEDntokuJAkn9QO5gxv6W2b5/4y86nh0jZ7GK79hX9l0GsbZUG26ttZa5xVZ+Z2EMTPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+Zcta8T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0685C4CEE9;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212921;
	bh=IyvY/24emCJGPMedHKkmlSSiSl5QbFscoFIXQQzs/r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+Zcta8T/6qX5+RD8RJPrv1BTAVXF2WYQciSYDFAo79speh6oPI9uFf70UKYcReWj
	 xfcGuVA7eodVwr9O/+Exvzoy13YGzIlBjHdZAuGAzK2TcXzjjfeasZ+jr8dJXvh3Jp
	 SphqcD6Zq/VJ4/cQJvVNIobLvjappuBxyGByvZQrHWAzFz5O3V8AvYzfVAqHWYTdyw
	 yO2Os/vof30brTZg1PThKp3XJeEHK1oKtEgDwFV3MqkQNC9ukRq0KABMylPCzHtlSa
	 /0+fHPpA6E9bbB7jMEwYLn9FWMEJxxE7ohNrggrhHN3P3di8Z7QH0ZqrZfAaEl6tnx
	 6uNERHF92XzZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjH-002g2I-PP;
	Mon, 10 Feb 2025 18:41:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 11/18] KVM: arm64: Propagate FGT masks to the nVHE hypervisor
Date: Mon, 10 Feb 2025 18:41:42 +0000
Message-Id: <20250210184150.2145093-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
index 4e67d4064f409..7220382aeb9dc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -583,6 +583,13 @@ extern struct fgt_masks hdfgrtr_masks;
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
index 071a7d75be689..0747ab90fc283 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2414,6 +2414,14 @@ static void kvm_hyp_init_symbols(void)
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
index 6c846d033d24a..2add6e4c33f1e 100644
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


