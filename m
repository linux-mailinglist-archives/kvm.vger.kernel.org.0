Return-Path: <kvm+bounces-6899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA65983B739
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A3661C216E5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AD35C9A;
	Thu, 25 Jan 2024 02:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jv7tm8mW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52176FB6
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 02:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150426; cv=none; b=M4p5Ze22WOTyTAO/9Y6GMRN52DnqdK/wRdTqH2dUVG1PqRvT9I5Ft8W2rK+g5dGdSDF38huj1ou1fbIznA96JQIEq0aCvw5qk2Wa6LhDnr4ZtuhffBO8C1cUG+2zNIWAxqtmWYFbZGcRq9hZ7iud5Ss6tAwe5ocb28GfVqrHyTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150426; c=relaxed/simple;
	bh=AckTspWNDYDrRLMW6Dhxf2nPnuEuHbcix4yyarI2Zew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kOo/jR3qs+Bcoi6zp1VtUerrSsK7iej6DIV9tMpTwNVQMRy6+54oBkWi0vjcCTmARfERC/ks2pINVQRtXZiqGawh9BJ6wSaoE6Xxwpl+Hr3aw+lmNWwaE18VSgk9iEIECLwQjqP1a6Go+p7I0khRN+ItXGy+MgdHCghRNEs/jLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jv7tm8mW; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706150424; x=1737686424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AckTspWNDYDrRLMW6Dhxf2nPnuEuHbcix4yyarI2Zew=;
  b=jv7tm8mWj7GPF0tGHL0EDLt5SLeiwyB6hJEij/xDbSwW5FuVGVWb8R6d
   L8+M6pWE8khUSSfktGxdG0TO64OS0MZSbkdrZ0eNB9BtNdtgt5Wzf02zA
   VWbndvuGy1G9EbDzQT4YOey/bspyPQ+SIT7bKrlHo+izswaP1T/dSRvar
   CE9+sGJJuS2K7vznO/UC3vr4WIfxeSTHJxKyKUFzVKWMuTg+k3cfAXrzv
   uJIlApF3rfydQED9jgC/tZ7YTXwsnTW45ss7xWluEPPjLX6DmIuUl+BL8
   KVv7xkrfXOw/o4/YTmFaXzT1jnEuQCn2ScjfRJ/+lSoyd/y7NwpuBdraH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="401687457"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401687457"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:40:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2120534"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa003.jf.intel.com with ESMTP; 24 Jan 2024 18:40:23 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH v3 2/3] i386/cpuid: Remove subleaf constraint on CPUID leaf 1F
Date: Wed, 24 Jan 2024 21:40:15 -0500
Message-Id: <20240125024016.2521244-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125024016.2521244-1-xiaoyao.li@intel.com>
References: <20240125024016.2521244-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No such constraint that subleaf index needs to be less than 64.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by:Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/kvm/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index dff9dedbd761..9758c83693ec 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1926,10 +1926,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
                     break;
                 }
 
-                if (i == 0x1f && j == 64) {
-                    break;
-                }
-
                 c->function = i;
                 c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
                 c->index = j;
-- 
2.34.1


