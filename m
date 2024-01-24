Return-Path: <kvm+bounces-6758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39088839F66
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E427E289C04
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7145E1758C;
	Wed, 24 Jan 2024 02:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ve+5k0Cm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96EBF9E6;
	Wed, 24 Jan 2024 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064160; cv=none; b=U8KesVja0I9ENV5BX3LQe+/yHVDmG92RawTpmfCPpRaLj9ysQTCmaq2OazLAfGOzfZMdZPVa0aPxKd8nv37gIrfQ1Gczv4mlaTADIQR/FC+d+5DMlOWpg0gzyZRn/J8HKPbBigu3W67M7gQEwIQKLD1danLp5jeVX/7OKyT5SN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064160; c=relaxed/simple;
	bh=HiRiDRBJgwGeewv2BjjbZoB+AZJ6Z19DaJ2CBVn/WYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bBcT5MQDUpTUW6pkijBjR9st6deiHfZyPIv/rgNt9qmrP12Dsr4stb1f8ECey83W1QC971qsrLiF7uQvCkjhlmcrPsbovFd5LHxcuBsQ/mnlrElxDDDm9cBChRNI4g3HBU3vBvjlYaWkQb8//QwaWXbumqCWLNgDftf2usHZo2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ve+5k0Cm; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064157; x=1737600157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HiRiDRBJgwGeewv2BjjbZoB+AZJ6Z19DaJ2CBVn/WYI=;
  b=Ve+5k0Cm2k/fU5ade3DeiTkvWOsTwWLj3qfneI6ZCV5eS8LG9OMM4Dgp
   ZkgGFti9OEarAzhMFsHm97xZWpVowaSUpgcpsidXrLYdz+1OQSZzCH0l0
   3bFEKYkN40UJQwxzhZUBCQP/xCJVBUXIMpvcnhvh+t9ezmaQVTXSqWkJG
   1ZPChaYXwCyDa0u13Y6L9Y8NhUdIwb9HvySF1PRVvflP9a7170QmMJzme
   6t6tS0Cegju1VKbjSSa+zi0GA8rQud3EroRkGRhxhdv3/WvOG6o2Z4vP/
   TK4iFPPxNCBmrrVqLhDNvxUaIex+Wc3Xtn+O2vVQSHD6zNO+OZ6qDV1d+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586458"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586458"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825846"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:33 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 07/27] x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
Date: Tue, 23 Jan 2024 18:41:40 -0800
Message-Id: <20240124024200.102792-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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


