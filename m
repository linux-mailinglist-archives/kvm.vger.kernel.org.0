Return-Path: <kvm+bounces-66454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FC5CD3BD3
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D48B43078A52
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED5B231830;
	Sun, 21 Dec 2025 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWiFT+ku"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E870723A9B3;
	Sun, 21 Dec 2025 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291511; cv=none; b=uosAr6VZeuRCYcA1b/GEbylSHQ3B5BU1kEXIQjCo+mYGBynKE5gBNR6VnMS/AtcpWvvOkKJCCKfCVVRp8+EHFVHgDkVd6iVVCCH5aFPFb4p4gr51+Tam82Pj5dg/AEU9UZpCMyNTy69d8kB7d4QFRggd+SUwxkGMZwy5U4P6Oeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291511; c=relaxed/simple;
	bh=TRr5hcoQqdjYrW9FJSXg+9zaWcUsOZHBSl3b977kPuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f94sesB8QWeviIEjmVcJL2k41C830mFDL+QJ8mtq29IDLNrpQi+1PaG/Lk+fuoPBnd4aC3d5j0NlSNQyj5Hkdb9/Ny0EmVcIFSSGXCW/KGLih5vQsCoz9xhx7Ee+gkC0uaHf3dljkr2KJuq5ikDO/5eREu5/djfSPHMqtF5t4sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWiFT+ku; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291510; x=1797827510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TRr5hcoQqdjYrW9FJSXg+9zaWcUsOZHBSl3b977kPuw=;
  b=jWiFT+kuLhiD/GdEzuG1t1/71Tmrdx+Kod6lmzKyOP1TeM4vnYa+57ti
   baqn2gIOuwi0mo/Apudf16e2oFI9GK4b5pynRegY5iOzRB94xWtFyJN6V
   FIjxqhvZ95da+0sxMJq+vOrzsB/u8Ry5QNRp6Ev82MjoKnTiB/+fHUSC4
   dlIykRWjE8yA8FUuXaYvSNHW5m5uOpYFVtU2oQDnsKtrKZ8ARRPUN/+Pf
   vZfE6TH67DrZZxWFVCE1a7ZLCDSw4IyK8JYNL39hDsDgxhN40vynsFGxy
   W/dnZGWrsf/0fl+ivEiYEL/iVZs0UBJq3uv/zOLI/icpYbbzpWnaJBUiH
   Q==;
X-CSE-ConnectionGUID: f6H0yxtrR06UAujypjIPCw==
X-CSE-MsgGUID: aQcs3AcbRj2yO6hMQxDXzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132430"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132430"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:49 -0800
X-CSE-ConnectionGUID: z6EMDUA6RTyvjTwRP9myPg==
X-CSE-MsgGUID: g3obFIl/TviXJC9sZsH2aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885037"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:50 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 12/16] KVM: emulate: Reject EVEX-prefixed instructions
Date: Sun, 21 Dec 2025 04:07:38 +0000
Message-ID: <20251221040742.29749-13-chang.seok.bae@intel.com>
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

Explicitly mark EVEX-prefixed opcodes (0x62) as unsupported.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Rebase onto the recently merged VEX series. Reuse the previously existing
  VEX-rejection logic and style.
---
 arch/x86/kvm/emulate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index fc065ef53400..820ae381e601 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5040,6 +5040,11 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d & NoRex && ctxt->rex_prefix == REX2_PREFIX)
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


