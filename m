Return-Path: <kvm+bounces-41363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A98A66A98
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96BCC17B849
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEF61DEFFE;
	Tue, 18 Mar 2025 06:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSLfT7bX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7BA19F47E;
	Tue, 18 Mar 2025 06:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279752; cv=none; b=EWcFtIeyUeR8txxup5s8jqf8NPgdSf7SttnLXZ+WdoHVcZm51gR+B/fwU4xkhy98h+j0eMhqpBY/H5Jw6LyUp82VfEuwQpf9f2IheJ49BboBqadDhZ1/h0eKcMDM8Z4AlXwkDshwJ4Y3w9eFP4/dCO5gn6QaFrz1J4JdImhIMxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279752; c=relaxed/simple;
	bh=uP7eKufn3JgmU5kbRTG9Xy3/qL1jXgSZ5x6WrAHn+Wo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nGHGniKMT+VEFANks8Ps/JHuHyoMxfJOaAdnWfmToptvE6i+FnrvzXjBAL/aXRl27DOuEWy6HHD4s4FNCZdcmyfxmn4PbUeeUc8k53Scb6viKpRM7GDXhdagjjkVw7dT4zEcQO+l20Xwcux+xBvoq6UJPnImQjZUw5j+ZU2quhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSLfT7bX; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742279751; x=1773815751;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=uP7eKufn3JgmU5kbRTG9Xy3/qL1jXgSZ5x6WrAHn+Wo=;
  b=aSLfT7bXS1jTft1PosX68hoS41blOhQqucbTFYuFpaNHqy8WDt/WNWuw
   4NOFwZ6T4o+jG5bQfrx+0Bdo8P7+XaxiXgrLYeYBrISyhom5W/d+0dlHx
   iNC71/2FbpKHGddVMRnqNuuqJwBfckYtwLqsmQ0iVffBlZRqO5LGTrvzh
   ZQMX6kPEijSN8p0GUJd3Fw9ylPMHXbfsJx9UMdN9R4HmXi3TMopTwKmhQ
   5L04E9lQmh3GqOg7NkiB7GBuxmoZBTc6+yjx+vqunPQ/dUGe611Mi8SJ7
   jk2PSXYqzuGQQ2Mc8ftMBFqphSVvxMPiFIGlzMtqKCPxySrUPk2AGd2rP
   g==;
X-CSE-ConnectionGUID: dgo6iRIdR+uoIrmCy0e9IA==
X-CSE-MsgGUID: 9PF/FMPxSoWzv3fvSDkQNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53613410"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53613410"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:49 -0700
X-CSE-ConnectionGUID: WILfZigVRk6+FTfgaqLbiw==
X-CSE-MsgGUID: mVPQ8lvVRlGah2BNZuzz1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="153147531"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.109.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:48 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 18 Mar 2025 00:35:06 -0600
Subject: [PATCH v2 1/4] KVM: TDX: Fix definition of
 tdx_guest_nr_guest_keyids()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250318-vverma7-cleanup_x86_ops-v2-1-701e82d6b779@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Binbin Wu <binbin.wu@linxu.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=uP7eKufn3JgmU5kbRTG9Xy3/qL1jXgSZ5x6WrAHn+Wo=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOk3RZxdn9dJ7tzAe27j99MqZgELXLIyHmS18PedsDXXk
 PK+JpLQUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgInU2TH8lfw65UrIYi2W9k/q
 VVLz2R72GK9bdGKFftyuyqdqCXHbMxgZToTyfLCc+PX/5Qgvdrf5PEsnClXZldta/zn5LPDV6vV
 ifAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

When CONFIG_INTEL_TDX_HOST=n, the above definition produced an
unused-function warning with gcc.

  error: ‘tdx_get_nr_guest_keyids’ defined but not used [-Werror=unused-function]
    198 | static u32 tdx_get_nr_guest_keyids(void) { return 0; }
        |            ^~~~~~~~~~~~~~~~~~~~~~~

Make the definition 'inline' so that in the config disabled case, the
whole thing can be optimized away.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/include/asm/tdx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e6b003fe7f5e..fbc22bf39cfd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -195,7 +195,7 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
-static u32 tdx_get_nr_guest_keyids(void) { return 0; }
+static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */

-- 
2.48.1


