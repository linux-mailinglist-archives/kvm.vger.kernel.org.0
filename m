Return-Path: <kvm+bounces-22153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 798A693AC08
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 06:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8D6FB22709
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 04:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF983B295;
	Wed, 24 Jul 2024 04:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Axm+iU+v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A617C6A
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 04:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721796491; cv=none; b=r9nitqdh+xpeYOyELw4MSr2mClyApi/pXIcTJe0R/e6dTK/9jTqkClmattgrWGGQO624rLXD2Sv25WZIO7mfIrc/h1YvycBIvc2XDiHffBLtDtb7t0CM52xD+mVkNG3PbuLwsoLjvOhOS50GztbWAf/EzDJpyJfgtin+0uCm4Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721796491; c=relaxed/simple;
	bh=7QaXskviPwlTzXKbI0BfTIXq232Tn4a2Pn2hcS9RXbw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BqJVxjBC+rzeu9WcfTGOr0tsNtGY0X41OqHCfe+OF2Jcr+2oF0lAly9x1ih9XmFgYVjGqZcENn4SMYXCw63mC0DZ13ziVf1fLc1HAI1phhoB/5+TGiDzmKAeaP9wcDqSI7Zy7wobCiuEf2bQzYiPUnwSfQyXZpSZZuQ4+uhcOx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Axm+iU+v; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721796489; x=1753332489;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7QaXskviPwlTzXKbI0BfTIXq232Tn4a2Pn2hcS9RXbw=;
  b=Axm+iU+vC6jXEXjFX0TbOOIuA5P1ZQB4rNcyIa8cvTe2C4invi4Y+HZA
   5BSTWbUr93uRaWmYv55uaOztvfOLq6bQ1BssJIKByJy8LMZpxKioBm3G4
   a9xn9O344OSkbaH7P/Lh/qukuXPy7OVsnD3ev60SStma/mZKwLOklzJ+a
   oADv3hSrWuFN3HwRDYmW5NU+78whvgqv7mIpYalXswoyCzp7tX0pTSM+o
   AuUuW8JC8PHSq+ppAZtLlkWiTSnEBQP+tR29FABVcZo7G0AF5aD8P8kVw
   ZwFVRYLaYM/PHfEWWGhVpAaPFUpnjnkpMV/ESqo0Qi21HwHxhcWvzfxf8
   g==;
X-CSE-ConnectionGUID: 9VnMno9mS4CCaWoGsMxwlA==
X-CSE-MsgGUID: uVb1bZLzQnOdfycdzqgwWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="19600661"
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="19600661"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 21:48:08 -0700
X-CSE-ConnectionGUID: ehDl1NmqTlyqPyQoq1tTGA==
X-CSE-MsgGUID: RiJj7L0vQ3+Np32vc7o4/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="52524352"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmviesa010.fm.intel.com with ESMTP; 23 Jul 2024 21:48:06 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: x86: Reset RSP before exiting to userspace when emulating POPA
Date: Wed, 24 Jul 2024 12:45:29 +0800
Message-Id: <20240724044529.3837492-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When emulating POPA and exiting to userspace for MMIO, reset modified RSP
as emulation context may not be reset. POPA may generate more multiple
reads, i.e. multiple POPs from the stack, but if stack points to MMIO,
KVM needs to emulate multiple MMIO reads.

When one MMIO done, POPA may be re-emulated with EMULTYPE_NO_DECODE set,
i.e. ctxt will not be reset, but RSP is modified by previous emulation of
current POPA instruction, which eventually leads to emulation error.

The commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
emulator detects exception") provides a detailed analysis of how KVM
emulates multiple MMIO reads, and its correctness can be verified in the
POPA instruction with this patch.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
For testing, we can add POPA to the emulator case in kvm-unit-test.
---
 arch/x86/kvm/emulate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e72aed25d721..3746fef6ca60 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1999,6 +1999,7 @@ static int em_pushf(struct x86_emulate_ctxt *ctxt)
 
 static int em_popa(struct x86_emulate_ctxt *ctxt)
 {
+	unsigned long old_esp = reg_read(ctxt, VCPU_REGS_RSP);
 	int rc = X86EMUL_CONTINUE;
 	int reg = VCPU_REGS_RDI;
 	u32 val = 0;
@@ -2010,8 +2011,11 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
 		}
 
 		rc = emulate_pop(ctxt, &val, ctxt->op_bytes);
-		if (rc != X86EMUL_CONTINUE)
+		if (rc != X86EMUL_CONTINUE) {
+			assign_register(reg_rmw(ctxt, VCPU_REGS_RSP),
+					old_esp, ctxt->op_bytes);
 			break;
+		}
 		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
 		--reg;
 	}

base-commit: 786c8248dbd33a5a7a07f7c6e55a7bfc68d2ca48
-- 
2.34.1


