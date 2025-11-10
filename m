Return-Path: <kvm+bounces-62562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C15A0C48901
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B56F4F0DE1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B599932C92A;
	Mon, 10 Nov 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fpE6kmuI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4A334C13;
	Mon, 10 Nov 2025 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799096; cv=none; b=Dz2xf2k8k2fzMcwR/8C4j6Gnk5bGUi12ViwhykqMFtLCgRmdpbHSO5WCVMKPoK+PmN6iaIDNg/uihpY+h9Rn0Pi8xYEaiDB010zurtxjBCmV830/qSzKMLxn4NQTpcBeI1LFMNSb3hElrCJWJo0Q0He9c8pjdy5/GuFu3QaHBMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799096; c=relaxed/simple;
	bh=iCND/GY/Tsl4VP6nvvL9lsH1G26oXP1yAWuJhJB9LJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RanyF0aliczjFEg/XzxCph4TnU11wLtBvaMG1VWqvmZwbY5fTbLC1iJPfhtPba4BhoLLIh6X2i6lDvfwlOtSYICrHSbrml764Iwl3XZpLrar5PPdWEn5Cp1UbPJW1nvQZDXlmuGXekOCWRDzVSHqJUZb+SqxOXurFWyS1LWgljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fpE6kmuI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799095; x=1794335095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iCND/GY/Tsl4VP6nvvL9lsH1G26oXP1yAWuJhJB9LJM=;
  b=fpE6kmuIDyypZJ8ZiqEbUemFm+uBaSAs08SrwTejPy9tsAi9qDlAK8pN
   k+Y3Q7X5kao5gQYWptlAoTVXZ2PwJ4ItWH+t9JllebIYcCaO95AEnQ62h
   r5HmJ9H+0vLXmojDPkzhQgNzV0IfYP7wjkllSmwgH0F4jaxB7i+mujROx
   /Zr17vwUdpeVOkSn7te2LCRFdTFkuX0NBW4Ivm1rKpkZAVcNQy5GpHC63
   S9vSG8u885pjg6KoUVKeQc/pJzOn/qNLRyAPfxSnxIFS1nGGiVD5gF00t
   Jk6RROT2tNWunnQ8GaFjrnpOmEF8J4QrqHEcX1EX5wt1tcoqk6wjXLEjm
   g==;
X-CSE-ConnectionGUID: mV7rBniSQMWuqcw/ftrYCA==
X-CSE-MsgGUID: 1gZym6G0SbakwT0zHfqPww==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305509"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305509"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:55 -0800
X-CSE-ConnectionGUID: hQXlYiacQGSI50wQClE6ag==
X-CSE-MsgGUID: 3zChTSL8RC21vL6O8EuRJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396171"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:55 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 11/20] KVM: x86: Refactor opcode table lookup in instruction emulation
Date: Mon, 10 Nov 2025 18:01:22 +0000
Message-ID: <20251110180131.28264-12-chang.seok.bae@intel.com>
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

Refactor opcode lookup to clearly separate handling of different byte
sequences and prefix types, in preparation for REX2 support.

The decoder begins with a one-byte opcode table by default and falls
through to other tables on escape bytes, but the logic is intertwined and
hard to extend.

REX2 introduces a dedicated bit in its payload byte to indicate which
opcode table to use. To accommodate this mapping bit, the existing lookup
path needs to be restructured.

No functional changes intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 763fbd139242..9c98843094a1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4773,7 +4773,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	ctxt->_eip = ctxt->eip;
 	ctxt->fetch.ptr = ctxt->fetch.data;
 	ctxt->fetch.end = ctxt->fetch.data + insn_len;
-	ctxt->opcode_len = 1;
 	ctxt->intercept = x86_intercept_none;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
@@ -4877,20 +4876,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->rex.bits.w)
 		ctxt->op_bytes = 8;
 
-	/* Opcode byte(s). */
-	opcode = opcode_table[ctxt->b];
-	/* Two-byte opcode? */
+	/* Determine opcode byte(s): */
 	if (ctxt->b == 0x0f) {
-		ctxt->opcode_len = 2;
+		/* Escape byte: start two-byte opcode sequence */
 		ctxt->b = insn_fetch(u8, ctxt);
-		opcode = twobyte_table[ctxt->b];
-
-		/* 0F_38 opcode map */
 		if (ctxt->b == 0x38) {
+			/* Three-byte opcode */
 			ctxt->opcode_len = 3;
 			ctxt->b = insn_fetch(u8, ctxt);
 			opcode = opcode_map_0f_38[ctxt->b];
+		} else {
+			/* Two-byte opcode */
+			ctxt->opcode_len = 2;
+			opcode = twobyte_table[ctxt->b];
 		}
+	} else {
+		/* Single-byte opcode */
+		ctxt->opcode_len = 1;
+		opcode = opcode_table[ctxt->b];
 	}
 	ctxt->d = opcode.flags;
 
-- 
2.51.0


