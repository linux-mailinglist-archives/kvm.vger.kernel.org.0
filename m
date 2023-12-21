Return-Path: <kvm+bounces-4991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F4A81B1CC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260BF1C226DE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3B04CDE7;
	Thu, 21 Dec 2023 09:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpanSWS6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6134D109;
	Thu, 21 Dec 2023 09:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149428; x=1734685428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rs0sLmUkvny/jzDhJajlhzctZKCGIsR8BlL5L8UWwmc=;
  b=dpanSWS6x8TEKO6PNf7ceqBT1ofOnd6cnKOrM7XA8QrrYkvpdFwaIUI6
   QLxnRtyS3HEE5yPa3bcHLlLXb3fgDrkNpSuX2kE2ikDNMvEx6JDc6eXUt
   BnH000FYd4n9d/QVGuXBfvqCIKldc8xJpKnyPxgXVAhsI/5PKcQ8Mhshd
   A/oZlDhXa44XUX3NnO9GKKG8lVbgHf+BOC615cz1HvhO6KLPriWIRsTJu
   LIGdrpKmtz3XAEUr2/r6Tya5tvcyxnH67BORMzXpZ9v4PmdyfvIFN1705
   zWfH1peBHias62cPKDSG8T2OVdVTE27LwK5Z66MIerYjcrhZZHnzTy5cD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729630"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729630"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028583"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028583"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 07/26] x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
Date: Thu, 21 Dec 2023 09:02:20 -0500
Message-Id: <20231221140239.4349-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel dynamic xfeatures now are __ONLY__ enabled for guest fpstate, i.e.,
never for normal kernel fpstate. The bits are added when guest FPU config
is initialized. Guest fpstate is allocated with fpstate->is_guest set to
%true.

For normal fpstate, the bits should have been removed when initializes
kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
xfeatures contains kernel dynamic xfeatures before executes xsaves.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b..83ebf1e1cbb4 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -185,6 +185,9 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest &&
+		    (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.39.3


