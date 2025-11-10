Return-Path: <kvm+bounces-62566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC7AC48916
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1AEA4EE590
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB043337681;
	Mon, 10 Nov 2025 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoXDQOIp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85C336ED8;
	Mon, 10 Nov 2025 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799104; cv=none; b=DpPNUox/af9XQy4DJpUcqUZwGGvRu1fti/A+FYrD/igFoAIWRdnhoM0yZvPf2c8Nrol+nQs6bbXSSrtNygs8yW2IBokczAitPCHzQJe+BLLwGFvCiTKcDxB4F9nluPcpUnLv62REzbawKHWddfpweY9PRAGYg9QvdbsCiJCk4BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799104; c=relaxed/simple;
	bh=tqLsilKH4UEbDrll02cVHYgerxD+VGQCU4DswF/lNkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJaIPv1oFJ1GIscdp8cOOaUzRYbKzmIPLR5ElKCJWMQFI6KN6pDicAaZjvi+vWoTxPZLMPO0HsCcgeYWlomAuF5w6c7Pb3pdaMg4n9KR5ZRFnj0MGFZPnnUZocC9CxWJkQK94OO0E3ezRq4UMI+hTwCKzYS7lVo3ojgdIgHUJ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoXDQOIp; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799103; x=1794335103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tqLsilKH4UEbDrll02cVHYgerxD+VGQCU4DswF/lNkI=;
  b=PoXDQOIpLvcrY4mXia4H9rvui3XGsMZk9d3A1ro80nvMSn38xiZispO9
   RAIY3FnGjKZj6WDE8qzebUCeekXHnd8nmSaYzIq4kczpVSJk912F9d/g3
   Z8UEF9O6HNAi26RUcKwBvdZoCFfoc7JtwNfl0krAwFB9kUpv/IkcyhFQ+
   3EGJEEs6U8OF6EF0dFRPsnLXNg5zKkFGwFYUYkno1dJ2QBTpfaJSNbB04
   FamwyZF8O90yPsw79CHYU+F9w0yDSiwDQf1o8XP4q4Wqgk2krp6PBKxwn
   w1nmv3fHpAgXfKTAsgR5cT5STnoyYQEPJOh4RN6gZllK642hjefjFtwur
   g==;
X-CSE-ConnectionGUID: +Y0wD/YZT324Ydvcd7LxGw==
X-CSE-MsgGUID: WYSieWSpR9KIFW/l7sI/wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305520"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305520"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:02 -0800
X-CSE-ConnectionGUID: 01SKmm4dQASedW0QvfwzYQ==
X-CSE-MsgGUID: dt8VZuIiTHawoBgDxdjc5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396202"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:03 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 15/20] KVM: x86: Reject EVEX-prefix instructions in the emulator
Date: Mon, 10 Nov 2025 18:01:26 +0000
Message-ID: <20251110180131.28264-16-chang.seok.bae@intel.com>
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

Explicitly mark EVEX-prefixed opcodes (0x62) as unsupported, clarifying
current decoding behavior.

While new prefixes like REX2 extend GPR handling, EVEX emulation should
be addressed separately once after VEX support is implemented.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 03f8e007b14e..9bd61ea496e5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4952,8 +4952,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
 
-	/* vex-prefix instructions are not implemented */
-	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4) &&
+	/* VEX and EVEX-prefixed instructions are not implemented */
+	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4 || ctxt->b == 0x62) &&
 	    (mode == X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) == 0xc0)) {
 		ctxt->d = NotImpl;
 	}
-- 
2.51.0


