Return-Path: <kvm+bounces-30080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4233C9B6C8D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 068072829F1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA7721503A;
	Wed, 30 Oct 2024 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lKQVNaNs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A221E8850;
	Wed, 30 Oct 2024 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314859; cv=none; b=fRCZlBQwnE5Ub36zuDnGY5Af8rY9c0XRp9mOMaIXFMiy108EzCLR5Yx5DRlR0sAZ3frSie/EOcnCoMyETmsPPH///HaXFbLAAq69o/Eeo6U/wkItKpJ5MlXqRZemJNEvRDF6V/J9t+uNvh7t+m9Ke0u2KtXkVBDcIzve2BGFj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314859; c=relaxed/simple;
	bh=jl2tybTGxkzwlloval+G94gP9hQCDDzMKi+ZVsdOKT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjhWtKVotrcU6GG2EXbYRJKcSWHxFcSzL9ELLHrUwQp4RfvExbRonbngbMhFONQ23esXpaxyu+vw3K30o7uywuqg4OKvKqGrdXeFstwpBkk9PJoH3rGOyllH5N8Dhk8UUmwiCbZpKUWLeUasBv027DnTdBmy4C5lwStH0d2iujs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lKQVNaNs; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314858; x=1761850858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jl2tybTGxkzwlloval+G94gP9hQCDDzMKi+ZVsdOKT8=;
  b=lKQVNaNsqQghDl+/lSOo6zNU3a0Hx/i9SVIBiQvdQPBNSwHRRsdeNhQe
   DTfEvB4ApprkZkbQXr/upg3NF4UP76skaxzxggxZwd029AFEe0GjciEbd
   Q2pLNNEO4e8g7cvbITD3F/BFhGb56DvGHamv+23zE2/yvc0y3jDwKa29t
   HVULiddJCVlhFCRIlZyMk+WPcGN2jjSNKtS4+NqAk85iZZyTL4l5sIIHr
   5JrREff8VY5Yh4xR84go/WYuS1jGGbyvThhtXl2dACLbpKPAit1KwXPBl
   q55TFSIKrWS9IWBKv7YKHGqul5/TTwK58KKL/8Jh25PyiC/v2hsqn+k7M
   g==;
X-CSE-ConnectionGUID: jtlRHt7jSmezJ3OF3WbxQg==
X-CSE-MsgGUID: 6Tu0h+vKTtSos1GGUK926Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678714"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678714"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:55 -0700
X-CSE-ConnectionGUID: /2YVidyFRmmqSbT3+hjlIQ==
X-CSE-MsgGUID: nEM97a+7R8CQgU8SC6kQDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499310"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:55 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2 02/25] KVM: TDX: Get TDX global information
Date: Wed, 30 Oct 2024 12:00:15 -0700
Message-ID: <20241030190039.77971-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

KVM will need to consult some essential TDX global information to create
and run TDX guests.  Get the global information after initializing TDX.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8651599822d5..f95a4dbcaf4a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -12,6 +12,8 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 
 static enum cpuhp_state tdx_cpuhp_state;
 
+static const struct tdx_sys_info *tdx_sysinfo;
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
@@ -91,11 +93,20 @@ static int __init __tdx_bringup(void)
 	if (r)
 		goto tdx_bringup_err;
 
+	/* Get TDX global information for later use */
+	tdx_sysinfo = tdx_get_sysinfo();
+	if (WARN_ON_ONCE(!tdx_sysinfo)) {
+		r = -EINVAL;
+		goto get_sysinfo_err;
+	}
+
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
 	 */
 	return 0;
+get_sysinfo_err:
+	__do_tdx_cleanup();
 tdx_bringup_err:
 	kvm_disable_virtualization();
 	return r;
-- 
2.47.0


