Return-Path: <kvm+bounces-30838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B77519BDD36
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12417B237DF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CA41917CD;
	Wed,  6 Nov 2024 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCJ/jQ82"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F8518B47E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861412; cv=none; b=jbxIA7abtg/kPW/K914vjcQ072kbZ1TRucVl2WKkmqf7f/JnsLQd0/+p3woR18nlNYYkGr8vJNLiIFSdKOYjwNj4lvA34dvCi5xtkr+BIkA5FFs802h+Rpdz+9BWHGt8u9WLZU4RlEZI89p3dKXvmmwdlTa8Spdl96TAFLjpe78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861412; c=relaxed/simple;
	bh=HwNeX5BRFdrce3Z7AoO6W2SxOR4OlRNekMyhln01fPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QnTKmPdo9YtJCGLhowfkLWGiIofzavZ3Z2KJtq26pjy8bD8JEeS8r1Kqo+mn9A6atvc8s69PBZ4LYVXi16fgnIEZl0IzHPkOUW31u4QYZ6qhnPtc84PhIuCYa291bRqrB8vUwNwSPbhDX1WslzZYr5Pf9aSSR2GoXB5AHKoQi/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCJ/jQ82; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861411; x=1762397411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HwNeX5BRFdrce3Z7AoO6W2SxOR4OlRNekMyhln01fPU=;
  b=eCJ/jQ826WbyN+JMnGhuPwpiJOZFnFwbAA5lUOxPegM8PU8cB/zgWBQz
   XaxWE11PP1tdkkzuY8kXOMscSkdBSs2A+QAECqw4c2d/ziq6MCgWM33Sq
   RI9P07jiuC7PVuPpQ164CXJ+gyMokXyYfuUzcON+hNxBx2y0CXHE1CdwB
   CXbzc9Jr5LnvzdSW+MRijYNLWEm7Y1ngiJHbsY07a4mAxwl/eXqBNmrS0
   KVlJuoSDNaELxEVfhbw7hlqZK1jxhnkUxTFSdW8yhWjlCXn/cGpBc4i5i
   zhKK76Sy0dfgPrjbv7uAn0haTsIUIjNDriK9V5MGMWno9/UjxoQrnaM/Y
   w==;
X-CSE-ConnectionGUID: zsKAvF7eRPW2oKl0mwUjeA==
X-CSE-MsgGUID: /BH42PkkStekqWcRWIKgTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492289"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492289"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:11 -0800
X-CSE-ConnectionGUID: vozJa8rjS9qsShoUlaABqQ==
X-CSE-MsgGUID: C5vwVy8DQBCqiUKnZ6DHjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078013"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:08 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 07/11] target/i386/confidential-guest: Fix comment of x86_confidential_guest_kvm_type()
Date: Wed,  6 Nov 2024 11:07:24 +0800
Message-Id: <20241106030728.553238-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the comment to match the X86ConfidentialGuestClass
implementation.

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/confidential-guest.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 7342d2843aa5..c90a59bac41a 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -46,7 +46,7 @@ struct X86ConfidentialGuestClass {
 /**
  * x86_confidential_guest_kvm_type:
  *
- * Calls #X86ConfidentialGuestClass.unplug callback of @plug_handler.
+ * Calls #X86ConfidentialGuestClass.kvm_type() callback.
  */
 static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
 {
-- 
2.34.1


