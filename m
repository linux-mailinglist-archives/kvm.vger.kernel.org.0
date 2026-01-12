Return-Path: <kvm+bounces-67865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24491D15F8A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC628305674C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A4125F98B;
	Tue, 13 Jan 2026 00:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlGNhldN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B59239E8D;
	Tue, 13 Jan 2026 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263522; cv=none; b=mmV4CzhEssy6qanMFNnWNDRe4Yjn1FH39IYWEV31aETNYPiQZxIFWTuBvHgAPo2KNP5DundYJ8uDTx2G2ZNf2inQq4m55iAoqj1lwsk29Y3bsTkbdE5PwHM/qjnxA+felB5XlCBtZU+I4E6v9BNpsEM3Rq4TNQFaJ3xcfXeLytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263522; c=relaxed/simple;
	bh=07tJVhnezqFATaqeMdkaSGexLoth5B59/ayi8yiBDaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5MlUUSPEXOCCXVkoYan6kSy72Bcaj9kAmnDFyrivwv4Fe2PM7onHebQuoINxvH0btMad+TOuVuX1Vu0aQRRI0D4cM1pM1TazrvKX2O29L9cIaptQO1kZkPS4SQUAjSaNtQ+7TG2fWDrvS4D763fYN6z6WtLrF2nRwYGREOAt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlGNhldN; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263521; x=1799799521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=07tJVhnezqFATaqeMdkaSGexLoth5B59/ayi8yiBDaQ=;
  b=ZlGNhldNGfV8se8sagDaUCI79TJuMKtBCjNwc7qyGQuIT99krUBhaSvS
   DnWyzZhTyHQJ+N/0tLsSdZJqQsVslTnSaAVV+DvUzBPU9MGNR+mWI3fNc
   a0Bb1UxYSE0Yb9V1DdnxWNq9ch2w7VUNrYfI1BEcRCDDxjOZERo4FvWNb
   lNg+kfmu+4Ql33TNDXU5vEP6XDi1YYhYvBcVOAjPdBBrhC7FXGAUGr/qQ
   YdRMSZbSOoXhP1WBke5wA0GGzYcoqrYEfZ5kPfmrGYEhGaZ6713CO+/wP
   0dSIPXoYzI7XSImYsoVQWFHVgUalWkVm7gUATemcR0yyrX6zrKeSnDHPh
   g==;
X-CSE-ConnectionGUID: LaH5VquBRcGrKpOnMxZChg==
X-CSE-MsgGUID: dJqSg2A0R1mFhxszceAqEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264267"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264267"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:40 -0800
X-CSE-ConnectionGUID: 0XxsBxu6QCiI+cjd9k5a7w==
X-CSE-MsgGUID: RQPZbfijRVWgBh5uhR5wMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042294"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:41 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 12/16] KVM: emulate: Reject EVEX-prefixed instructions
Date: Mon, 12 Jan 2026 23:54:04 +0000
Message-ID: <20260112235408.168200-13-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Explicitly mark EVEX-prefixed opcodes (0x62) as unsupported.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1a565a4e3ff7..c5cb356f1524 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5040,6 +5040,11 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d & NoRex2 && ctxt->rex_prefix == REX2_PREFIX)
 		opcode.flags = Undefined;
 
+	/* EVEX-prefixed instructions are not implemented */
+	if (ctxt->opcode_len == 1 && ctxt->b == 0x62 &&
+	    (mode == X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) == 0xc0))
+		opcode.flags = NotImpl;
+
 	if (opcode.flags & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
 
-- 
2.51.0


