Return-Path: <kvm+bounces-45956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BB6AAFEC6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 343F33B9B36
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB1F288523;
	Thu,  8 May 2025 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOCNHvlg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89928851E
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716860; cv=none; b=Uws2wrE1Mu9sEcPeEEe4Rm2G032criD09l72VwL0ScXh1PdhThmv3YaRzsSYuiZ/LOk9adRi+B+SvYLS48cnuV788uzcFO34fNenk01bXEztb9WkM0+47kzNUwaHcXvSeSQaoqM7kXFMyN9qgF4f5J9j7k6g0v7l0lQjWEJauMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716860; c=relaxed/simple;
	bh=RnPUkkVptiBkzoG1PZzbzX6SNfcRkotJXQDy/R78Sro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFQv+tKLsJv7nuaMIeFVM76898qby43HUzJ4hlfQxMuK+PR/SjuFPuWc1c7FgY1nz0mWKWG9J9aS2i25xwkBzYUi93Ji4bXSFZ6RuFw1UA6fbb8q4+gy0Lq1lfU/CgW4lnY91Ho3s6cmTZAFNEqaK809/AVMQrv8M7R2L5PK3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOCNHvlg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716859; x=1778252859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RnPUkkVptiBkzoG1PZzbzX6SNfcRkotJXQDy/R78Sro=;
  b=gOCNHvlgCqh3QN5IUppaHQdjSFlxLWsn0uSfe0a7pCfiXsy4TCBPFz6s
   ibk7D6wGiC6lbDYiYP4HcsexDfe2U4wc/B8kFiO9GGDM9v7eT5LpY/KZb
   GcLDifiIfDJkjcil871iCk6FfgKY0n7gicu9XK+a5Fjkly+KWlbUaSxtU
   buPunNDPMR4tz4NvIMMvugm/76bT0vMC/CkTPXR6yKD8zZwHLl1lLlqJD
   jmqm+DJDAUwjFog9eueX81ZsNVvVUby4ZHchrFQvePclV8F2quDuRM6Ky
   UQ1iabIjufpo8uvoPcv4qrvhpmMgmTuOKP2UbGFFghH0jhwo0b8IhlVBl
   w==;
X-CSE-ConnectionGUID: BhxQEBG+SJyxEfhswZa68Q==
X-CSE-MsgGUID: xC2/PRlERGqHMw5Ydu6lAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716568"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716568"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:39 -0700
X-CSE-ConnectionGUID: Ar4o2wnjSGqd0GLgwhsxrw==
X-CSE-MsgGUID: xqj2rnT5QPC72IKLc5lneA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440575"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:35 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 53/55] i386/tdx: Make invtsc default on
Date: Thu,  8 May 2025 10:59:59 -0400
Message-ID: <20250508150002.689633-54-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because it's fixed1 bit that enforced by TDX module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e9c680b74040..6aeb4fcc4975 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -749,6 +749,9 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
 
+    /* invtsc is fixed1 for TD guest */
+    object_property_set_bool(OBJECT(cpu), "invtsc", true, &error_abort);
+
     x86cpu->enable_cpuid_0x1f = true;
 }
 
-- 
2.43.0


