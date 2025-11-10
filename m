Return-Path: <kvm+bounces-62555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD0CC488D4
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20A10188F62B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C87132B9B5;
	Mon, 10 Nov 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNAuuxmx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25E2330B17;
	Mon, 10 Nov 2025 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799083; cv=none; b=stYEgJE9CQNheh+LwlijWJztRFl5T7Y6GhT+JGU60okPCaF0mOKGMK7OculAKl7k9u9ZJo4FUnd9stY4MGasVymtiHt7IGeo8UtTa1Abg3PD+h2nQfrztf3ymaXxV1YigZYbZrzVenvyRuP+HRslN7Z+WqcPBL7NFSjTN2vYObc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799083; c=relaxed/simple;
	bh=J56z5jm9hwNPN0i9sE+CDuzUkAEhWxjTGRWpBhhgLhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQEjqRqRzFyVq6BZ55fMXgJ7oYjHAsYZXSVjGZ3R01cKhc954obHYxG2Pqn8Ys3QhzkBB8P9gFilGG2V5v5iIClh34XM5Kje5Vn9cqj9K5XDl8oWOE/WxFv/R0eOGt9E142akpqqlafDxX1fgaf2vFiHsVya5Tr8n5BBAi5UG5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNAuuxmx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799082; x=1794335082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J56z5jm9hwNPN0i9sE+CDuzUkAEhWxjTGRWpBhhgLhk=;
  b=eNAuuxmx6AkcE/UXoCcosAom9L6JpYLA1kisnixcsbR6S8oVq14gv9PM
   zcSgwqAorTjZz+5QFtpnxgFr6+z9sB9UfDiggjm4N50PyjwGkw7N/t3vr
   RQaEKWG9jBysi/xli5hTBbym4tHKnD+Zo+B5TP0TTFvL5aVDhCU650W3O
   AOBG9iw2RdSPMvwKESb99nOdqcLhEKull9MKyBA9DhD4lCWQFelUE3OO9
   C9LYpb0lvLRxKp+d3gHEB4uyRN8JIyi19n0Om809kFvM/+rwjc9nZGhGT
   x8cR9cbOscUcTpxmMzQ/oxH6IyfqNhGyrVex7m16Gt8+xvEe5ubglF4cj
   g==;
X-CSE-ConnectionGUID: 8/zTmDEMQpWoYePc072gsg==
X-CSE-MsgGUID: epBIv7gaSJKVCwvTLQ4Kbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305489"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305489"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:42 -0800
X-CSE-ConnectionGUID: +94w+2mTQZaDsKMdmgTXsQ==
X-CSE-MsgGUID: EhK3mx4bSy2X5EhpTazMzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396095"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:42 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 04/20] KVM: VMX: Introduce unified instruction info structure
Date: Mon, 10 Nov 2025 18:01:15 +0000
Message-ID: <20251110180131.28264-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
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
 arch/x86/kvm/vmx/vmx.h | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ea93121029f9..c358aca7253c 100644
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


