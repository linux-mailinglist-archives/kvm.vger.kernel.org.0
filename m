Return-Path: <kvm+bounces-62563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CE6C4890D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B45961894059
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7940733557D;
	Mon, 10 Nov 2025 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vj1TaIsJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF04335073;
	Mon, 10 Nov 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799098; cv=none; b=DwxI5RJ2kfZm9BU3D9AZ8K1qw6ciYJvp5ayFUdbNen0tjGZJ6bhUFcmgK+Jgt0nQBl6xhEIril1NXbhHLEGBua7n+AU3oMZvd1NHYmWwlIvIVQ36H/EJg+RHU/MxXv7clPkLI76DQiXfAV8zue2hfll3mYaps+LXD2WTg9CpXd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799098; c=relaxed/simple;
	bh=jYFK422XN5sDK4Xy8kxd03KOHseSRDbyhejfWJIw0VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAAxNuCHmMdFoCkUHyRMu+YRbq5IpJf8PCCDNLJRrjSXojtE/thB/qoQ/YhY2y7CZFWwexzAn/eS4SFguZ3hmXPQYxhlWLEwfPz4mppGDvEODfd/5I00iDRnP5knerePToWXMqxg0v7m/SBS28EyfEkyVb7mLQSFyqAbNk8AJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vj1TaIsJ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799097; x=1794335097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYFK422XN5sDK4Xy8kxd03KOHseSRDbyhejfWJIw0VI=;
  b=Vj1TaIsJ1jeOujevc6/6D7Z372lGzpXMR2ERdG31TldiBHoZG6iu+slB
   bOCGbUrdG26obtTLK3HS5+lEoxhQJT8C89PdhM0fSJpUAlB0edOaUaLnI
   65+jKK41WDXdaTZJJz/AK8DWv70vvikchg6XSowbxZ8xtVP/gqNOtSQMJ
   pTlO16ycPake0Px2Dn9bPy451dRyCCqi+T7XsvB4Jo+BcGcdxq54y8oaV
   RsjCjnQt/UhCu96FgoeMGORk2K3IeVKf+o1XsEaPy/zA2AbTj7CbNdk83
   CWP41IfsVHgI20r3bFLjt5HwuqZ+JWH9iv9V4qulBYLhd/C5g32m9ufn4
   Q==;
X-CSE-ConnectionGUID: tadtMYcHRruXTo3B6EROcg==
X-CSE-MsgGUID: 9Kn2Gzf0St2bP5I6+oRTZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305512"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305512"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:57 -0800
X-CSE-ConnectionGUID: 4Up46sQJRluOi5ufeHeApQ==
X-CSE-MsgGUID: 1xWoI8fFQnipwr6GO8/8ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396175"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:57 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 12/20] KVM: x86: Support REX2-extended register index in the decoder
Date: Mon, 10 Nov 2025 18:01:23 +0000
Message-ID: <20251110180131.28264-13-chang.seok.bae@intel.com>
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

Update register index decoding to account for the additional bit fields
introduced by the REX2 prefix.

Both ModR/M and opcode register decoding paths now consider the extended
index bits (R4, X4, B4) in addition to the legacy REX bits (R3, X3, B3).

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9c98843094a1..ed3a8c0bca20 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1084,7 +1084,8 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 		reg = ctxt->modrm_reg;
 	} else {
 		reg = (ctxt->b & 7) |
-		      (ctxt->rex.bits.b3 * BIT(3));
+		      (ctxt->rex.bits.b3 * BIT(3)) |
+		      (ctxt->rex.bits.b4 * BIT(4));
 	}
 
 	if (ctxt->d & Sse) {
@@ -1124,9 +1125,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
 
-	ctxt->modrm_reg = ctxt->rex.bits.r3 * BIT(3);
-	index_reg       = ctxt->rex.bits.x3 * BIT(3);
-	base_reg        = ctxt->rex.bits.b3 * BIT(3);
+	ctxt->modrm_reg	= (ctxt->rex.bits.r3 * BIT(3)) |
+			  (ctxt->rex.bits.r4 * BIT(4));
+	index_reg	= (ctxt->rex.bits.x3 * BIT(3)) |
+			  (ctxt->rex.bits.x4 * BIT(4));
+	base_reg	= (ctxt->rex.bits.b3 * BIT(3)) |
+			  (ctxt->rex.bits.b4 * BIT(4));
 
 	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
 	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
-- 
2.51.0


