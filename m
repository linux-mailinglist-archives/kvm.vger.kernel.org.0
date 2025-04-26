Return-Path: <kvm+bounces-44437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D327A9DAA5
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC16174A9F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26AB253F05;
	Sat, 26 Apr 2025 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfxP2y5b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241D2253953;
	Sat, 26 Apr 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670538; cv=none; b=M9YHtRtBl9eA7ObBZCzoHZjVvEVSaRZgJNeGtitNWgPlKP06FsHrUpjeestlyyc8VtDWZ0OQJGIEfNv2Aa+MqX8r3S9zPap8dLn41JmjOr1LLClMqNx+3NwmLs7RwPao8kdPwCwEHBPQgtI29vKtHVQwLZ+tWUhtaFSmM+SiqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670538; c=relaxed/simple;
	bh=QlIqmV68xTmqg1xztLJcaMauQklC0Pa/jGY/+EYEyfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gtnFN7/0Znl4VhT0NCf9CKXttx//rhLCBdI4vei3OwKmelCTlp7s32emuf5oXTbk/3EUUsXMAsCwwm6NSX7C1HlGmxfLhyhSiSXUafWztUH81hDfIc0ew0QFUv6kfiZrLjVR5dg+DFziuPY1Vqy6a7C7ET/rDi/u9jsj1p78RK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfxP2y5b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA0C4CEEA;
	Sat, 26 Apr 2025 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670537;
	bh=QlIqmV68xTmqg1xztLJcaMauQklC0Pa/jGY/+EYEyfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfxP2y5bk92GbwEUSqGikFVOEomKuhlcpYgk0Zgm6zcRS9G5UkEJuIbRUU73wN+SS
	 71GmKzjmVTRlP7qySoNWSvOP50E6soE6JW7rh9NpVCeLOHTvNtYNzUjq35Ieq4j7fP
	 HAgKHJNVkcpVDtEVJ3qtO72Fcq+5h2+kd9FMNrr/d7/YVPbtW3u6Gt6w1Z21ZdrFNW
	 Drxndu81hLgICs7XBt1F7LWwUQFswfIOUs1HYo8r2rKqe5DI82EKFMYYsDr/aSsqUX
	 cMAKEQ4c/kIdITATEYhpUW6ZuYi4HWrLeF9TUJYg7DcVPTrjrxJ8qZzf9Cl11pvp/q
	 9hIZveazPb9xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeN-0092VH-LT;
	Sat, 26 Apr 2025 13:28:55 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 25/42] KVM: arm64: Propagate FGT masks to the nVHE hypervisor
Date: Sat, 26 Apr 2025 13:28:19 +0100
Message-Id: <20250426122836.3341523-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
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


