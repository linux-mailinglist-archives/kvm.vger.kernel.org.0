Return-Path: <kvm+bounces-61468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C20C1ECCE
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 08:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75F07189CA4B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8C9337BA6;
	Thu, 30 Oct 2025 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNdNviPK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1832DF710
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809851; cv=none; b=XcJVh1daIVfSD+UiBY2VDxpModMmIOwvua6FD+lYu8t1AAu4uD0GIOvYu/XUnWLjAvhlYwE4LGdNeC+kgH0P+Yxx1s2D821IU/H7AqxWivZDnzkcVfp0ha4FdyJ/OVA8BCFxUyFkuRd5obOllIUGs+x/KunmgWsyLxmD2QhHhj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809851; c=relaxed/simple;
	bh=H70XrBkeAneIH2dQ3vqaajL6Gomd0f6vsf9oyIsLt54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unTwrIEBCFllwB+18eMHvznxxFXfwg7NHwi8ydFlTplGAkbBGOf6oiPI+VgZqn/WVbJmXT6+ZwcZgO+XQi+M+qxQ7TVfLjkaoFQomlW7eeEZJ5kMSmM5HAMHgqJ9E8NR/dNnZ8m0W1U8mjDCn7Sx/nusm9nyJGv1fioniQvQRz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNdNviPK; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761809850; x=1793345850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H70XrBkeAneIH2dQ3vqaajL6Gomd0f6vsf9oyIsLt54=;
  b=aNdNviPKeb3dQj4GF4qCHB0AzgYBnfonyVLuaLdjuuXw99H3Jv2mFuMI
   TrbYU80qw5TNCKyB0LChvqMMbIEeUvtr4dD54zQ6AD1nymehRU7IhMwtE
   B2VUTQMuHlFH8mSWx12TyOKKFDXpZv3vCtx5FJrI2jpGZDxdLVDy/UkXR
   Uafll+ZgNq2uR1EpIZhXA+NpTj23PJalYYclrqpYeTywuDysOZfCuVPXO
   pYbbeknDN9bd0wTwp2ClRGmNTpsr2SIMRba6cqM32iHnL5FE4eP4Pyz6y
   UoW+Yct4YnoUydsHa4z1P7/bBPPXB7fu6do4q8QxI817o7h87/Wkkhubl
   Q==;
X-CSE-ConnectionGUID: u3n6k7UcRSmqJrLKzTDkFw==
X-CSE-MsgGUID: X/jNIGb8SP+arQtLGKrZfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63845618"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63845618"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:28 -0700
X-CSE-ConnectionGUID: fveEkhifRLq0Cb5N6XOIyg==
X-CSE-MsgGUID: ybBOYiT+RJySRlPhDQVn5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="186229659"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:27 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	minipli@grsecurity.net,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 2/2] x86/eventinj: Push SS and SP to IRET frame
Date: Thu, 30 Oct 2025 00:37:23 -0700
Message-ID: <20251030073724.259937-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030073724.259937-1-chao.gao@intel.com>
References: <20251030073724.259937-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the current stack segment (SS) and stack pointer (SP) to the IRET
frame in do_iret() to ensure a valid stack after IRET execution,
particularly in 64-bit mode.

Currently, do_iret() crafts an IRET frame with a zeroed SP. For 32-bit
guests, SP is not popped during IRET due to no privilege change. so, the
stack after IRET is still valid. But for 64-bit guests, IRET
unconditionally pops RSP, restoring it to zero. This can cause a nested NMI
to push its interrupt frame to the topmost page (0xffffffff_fffff000),
which may be not mapped and cause triple fault [1].

To fix this issue, push the current SS & SP to the IRET frame, ensuring
SS & SP are restored to a valid stack in 64-bit mode.

Opportunistically, drop the 'extern bool no_test_device', as fwcfg.h
gets included by eventinj.c.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/ # [1]
---
Changes in v2:
 - push SS to the IRET frame as well
 - push SS and SP for x86-64 only as IRET in 64 bit mode unconditionally
   pops SS:SP
 - remove "extern bool no_test_device"

 x86/eventinj.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 3f28b9b5..e72efa16 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -138,11 +138,9 @@ static void nested_nmi_iret_isr(struct ex_regs *r)
 
 extern void do_iret(ulong phys_stack, void *virt_stack);
 
-// Return to same privilege level won't pop SS or SP, so
+// Return to same privilege level won't pop SS or SP for i386 but x86-64, so
 // save it in RDX while we run on the nested stack
 
-extern bool no_test_device;
-
 asm("do_iret:"
 #ifdef __x86_64__
 	"mov %rdi, %rax \n\t"		// phys_stack
@@ -152,6 +150,12 @@ asm("do_iret:"
 	"mov 8(%esp), %edx \n\t"	// virt_stack
 #endif
 	"xchg %"R "dx, %"R "sp \n\t"	// point to new stack
+#ifdef __x86_64__
+	// IRET in 64 bit mode unconditionally pops SS:xSP
+	"mov %ss, %ecx \n\t"
+	"push"W" %"R "cx \n\t"
+	"push"W" %"R "sp \n\t"
+#endif
 	"pushf"W" \n\t"
 	"mov %cs, %ecx \n\t"
 	"push"W" %"R "cx \n\t"
-- 
2.47.3


