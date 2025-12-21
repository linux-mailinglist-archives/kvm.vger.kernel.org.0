Return-Path: <kvm+bounces-66446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C864CD3BB2
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F6353017F1B
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956F622332E;
	Sun, 21 Dec 2025 04:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NBXDSwmS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01202236F3;
	Sun, 21 Dec 2025 04:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291492; cv=none; b=j6+SijNNsHRbo/nzmfiJREb4xCyVHcOKmHAqU1sCQpHxh23nWRY8qKtaZ+1obOjoCJsYp0U3VigXpND8GFchSr+ufCPYkiF7gfSkoco1ci73dxBQjIyGjRVUjEQ0rM2iGZ/p7EFf4avAXKvoaPw2miUD9+pqPFYDb0qxqQTD64w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291492; c=relaxed/simple;
	bh=ETFtYkEoPUqCgEgLksII29RG50I/Tk+UrB4MaRbwwWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCix+IrY/YAGBA04m7gO914/Vgnfgqq7Cz5nRNOuRXh2N2OS978eoAYvaqSjqfDk1L9Qjs6TGMUZnIkhIuloOjggcDI8LxU8R0aSmlCFFexZcAus9n4hQA9kYYPUeWp/Ut0b8PsR9+kWp10IBZGkSchAo1ByL+CPRXTOmtsJ2so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NBXDSwmS; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291490; x=1797827490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ETFtYkEoPUqCgEgLksII29RG50I/Tk+UrB4MaRbwwWo=;
  b=NBXDSwmSWHIgcBjKr3Rv5qg1+4a8G1NoZP27HyPWrzfkSs3DOW/9+5Q1
   Y58wxn+TlnoUm1O1fcharXL8NOBCcracJpYZiQhND9xyuKZpS8xSqohSx
   O3tMF/CP/zFTXJe7/MR0iy3iM47hi7US+tPw+/OjWVREQwixafdCMm/k3
   X5bdv8tNGUAahihgpkMgnkea9bIo12g2NtobaJrnnJaGsP3bM/X+0DdKQ
   x9LYAS9umO6paOj+u0CSbe+GTrtGbngfmUFrgxnBokB8LMlHdbRTevj4x
   OLPEOIV+FZF80ti+19e2A7lRRdaCsIHiZdx3luAIwMgZozNd4vGe7EnAT
   A==;
X-CSE-ConnectionGUID: P8w/v7qyRnW6WoAMtbbdOQ==
X-CSE-MsgGUID: cV/L13hmRlmymDHvwWcuKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132387"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132387"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:29 -0800
X-CSE-ConnectionGUID: 5Bv0qkJkSP++ZXZbf/Lg7Q==
X-CSE-MsgGUID: 71Aew747Sd+c2LyXiliP4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884965"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:29 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 04/16] KVM: VMX: Introduce unified instruction info structure
Date: Sun, 21 Dec 2025 04:07:30 +0000
Message-ID: <20251221040742.29749-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define a unified data structure that can represent both the legacy and
extended VMX instruction information formats.

VMX provides per-instruction metadata for VM exits to help decode the
attributes of the instruction that triggered the exit. The legacy format,
however, only supports up to 16 GPRs and thus cannot represent EGPRs. To
support these new registers, VMX introduces an extended 64-bit layout.

Instead of maintaining separate storage for each format, a single
union structure makes the overall handling simple. The field names are
consistent across both layouts. While the presence of certain fields
depends on the instruction type, the offsets remain fixed within each
format.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 arch/x86/kvm/vmx/vmx.h | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bc3ed3145d7e..567320115a5a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -311,6 +311,67 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
+/*
+ * 32-bit layout of the legacy instruction information field. This format
+ * supports the 16 legacy GPRs.
+ */
+struct base_insn_info {
+	u32 scale		: 2;	/* Scaling factor */
+	u32 reserved1		: 1;
+	u32 reg1		: 4;	/* First register index */
+	u32 asize		: 3;	/* Address size */
+	u32 is_reg		: 1;	/* 0: memory, 1: register */
+	u32 osize		: 2;	/* Operand size */
+	u32 reserved2		: 2;
+	u32 seg			: 3;	/* Segment register index */
+	u32 index		: 4;	/* Index register index */
+	u32 index_invalid	: 1;	/* 0: valid, 1: invalid */
+	u32 base		: 4;	/* Base register index */
+	u32 base_invalid	: 1;	/* 0: valid, 1: invalid */
+	u32 reg2		: 4;	/* Second register index */
+};
+
+/*
+ * 64-bit layout of the extended instruction information field, which
+ * supports EGPRs.
+ */
+struct ext_insn_info {
+	u64 scale		: 2;	/* Scaling factor */
+	u64 asize		: 2;	/* Address size */
+	u64 is_reg		: 1;	/* 0: memory, 1: register */
+	u64 osize		: 2;	/* Operand size */
+	u64 seg			: 3;	/* Segment register index */
+	u64 index_invalid	: 1;	/* 0: valid, 1: invalid */
+	u64 base_invalid	: 1;	/* 0: valid, 1: invalid */
+	u64 reserved1		: 4;
+	u64 reg1		: 5;	/* First register index */
+	u64 reserved2		: 3;
+	u64 index		: 5;	/* Index register index */
+	u64 reserved3		: 3;
+	u64 base		: 5;	/* Base register index */
+	u64 reserved4		: 3;
+	u64 reg2		: 5;	/* Second register index */
+	u64 reserved5		: 19;
+};
+
+/* Union for accessing either the legacy or extended format. */
+union insn_info {
+	struct base_insn_info base;
+	struct ext_insn_info  ext;
+	u32 word;
+	u64 dword;
+};
+
+/*
+ * Wrapper structure combining the instruction info and a flag indicating
+ * whether the extended layout is in use.
+ */
+struct vmx_insn_info {
+	/* true if using the extended layout */
+	bool extended;
+	union insn_info info;
+};
+
 static __always_inline struct vcpu_vt *to_vt(struct kvm_vcpu *vcpu)
 {
 	return &(container_of(vcpu, struct vcpu_vmx, vcpu)->vt);
-- 
2.51.0


