Return-Path: <kvm+bounces-21723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63171932C77
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC782B2346B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668D619FA72;
	Tue, 16 Jul 2024 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NYwM/iwi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F87919E830
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145315; cv=none; b=NjyVEbzM7VoVmI/LN0vsxYZNuPdT9tEgOHKcwmADXkd8T1Dw2TSecS1aDFbz7KRjwNyklIhvPnm9L7Ud6RCGmPJasOHx3VSiZ/MRX774J8H7JJ8zKkelFr04EhuOVJMSdcK1oBOOcbzMzWNv7XbD5iRT2RMjJFYp/iNRb59FDpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145315; c=relaxed/simple;
	bh=u1cSsKiZS4LgVHWKLVbqsnZaR8V7g5t3vC4cMVukk+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OunR7mywXVrf6ZQOrWUJclYVmswoc9rOclKlvBR2973R+QuL2mm4Jgo7gZzduVD2FnqYIjvP3UGOn3jcymWexLvmXIlnrRbgkepe050MwlWMayxvMBJlJSsW2tBjn1cA43WBQbXv5jaFW2sE/jNr/NeZa+XiaaGLQF8BWWa3iEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NYwM/iwi; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145313; x=1752681313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u1cSsKiZS4LgVHWKLVbqsnZaR8V7g5t3vC4cMVukk+s=;
  b=NYwM/iwiuc4NvEsnemPETS3E3QG8vBizFqzUaTwqieGfJl7SOXY4KDt1
   4Sf6ICAG6r707xaW/dnbSyXecOjCbZFzqcjPrZN2OloxmGYWpjN3qbSQ6
   qM1ficu0Q2krixs68SWsInq8QvRReC+NzaChGZcm1vl4EP4VAawqWj+XP
   cdpQR2Bn5U2gm70tPKgPe4tGYMhaisd3CzCp/oqXYSaB5vkfS84DAAgCK
   FBsPlOHe91O/To1VCZME62+6Z4U9vwgZRiamuITLAcKprYYV4+Y4C6ffp
   7xaekmVmZJws6OUygm3E3Gl2ooxyq4NFqLXUVDxPh5HwvWIRAOQCqFoPJ
   Q==;
X-CSE-ConnectionGUID: 4x66TiYRSrWJSFNKKVc7Ng==
X-CSE-MsgGUID: hopVD+B6Tr6qEBoMGKXhSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743754"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743754"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:55:04 -0700
X-CSE-ConnectionGUID: AvJVzMyPQc68UJx2aqmsgg==
X-CSE-MsgGUID: L5VZ5PCHQ5u211w+4a4pKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788394"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:55:01 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 6/9] target/i386/confidential-guest: Fix comment of x86_confidential_guest_kvm_type()
Date: Wed, 17 Jul 2024 00:10:12 +0800
Message-Id: <20240716161015.263031-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
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


