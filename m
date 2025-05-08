Return-Path: <kvm+bounces-45937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F04AAFEB3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C388B420E9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572E027A934;
	Thu,  8 May 2025 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoVbPzJT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4767E792
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716802; cv=none; b=nl47UX53TQ4rFEEOu3QiVV/TqIa0yRWxEYsNNMq+Yx7vnehdqXJc/0vm4eSUIMzjHm1EuB+llCRZLmDZitYH6O8Ot4dcQWfxbu51hkgzchd0evLigUfm38TJ6V9py6KzwCdZZrjbonF25PdnSmRmVctmpF7HGshqHDTu5xCcCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716802; c=relaxed/simple;
	bh=htgMoepnRRm85RzXkxzGm9FC+zja4crME7UX1m1yuW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/ilKMfeTR4gy6Cx3Dp2StoTvayDJI6GNe/oHchxaJ7ynSolOjrJWlImLSwD7FREB9sZXQ6ksFGfc+b34BWj74D1ecQ4C8Kb77u7uA4iBm5BPS069AUKCEeWh3TPdiUasIHCJxERp0g/nC5X2yAk2PRWzNGIPI6YuqyiYE0QEYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoVbPzJT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716801; x=1778252801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=htgMoepnRRm85RzXkxzGm9FC+zja4crME7UX1m1yuW8=;
  b=PoVbPzJTrV4bzSXYnRdgmcSPKYYX346az1OqOGfT5KbZNCh/hjUKlry9
   GHU2oq+S0aRM8urDGbJKReJy0tdBWSJrsDu1j+8qmh9pxrtSSoK7IkJp3
   74SMsribx01ZDHb0f8582Xtj8kKMjOkMiX85PtM6T+f2pQx7f4PNG9k9t
   hgaNsqM3r3xEaNI6/vMxGt8QRBdHn5kGIBkYW0qiT5ix4pDtRZnL9h9xn
   dUQbIAZ5/7ydXoDJtjIi13sc9C+oJ55tYsgchF1jj/vCNh5S69HIGILzS
   CsdDuwAoV9YDcvfZMzB8RzqxstexzWRID2xvIQTJlVITW5DptJqol+M9z
   Q==;
X-CSE-ConnectionGUID: fwT7X2zpRdW7IYf2qGednw==
X-CSE-MsgGUID: qRaAZEPSSIGWcvzhp9y8yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888300"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888300"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:40 -0700
X-CSE-ConnectionGUID: 5OblsYRgSraDVToUvnhg2g==
X-CSE-MsgGUID: +N9koNTJRmmdJG7hi/emMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440204"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:37 -0700
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
Subject: [PATCH v9 34/55] i386/tdx: Force exposing CPUID 0x1f
Date: Thu,  8 May 2025 10:59:40 -0400
Message-ID: <20250508150002.689633-35-xiaoyao.li@intel.com>
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

TDX uses CPUID 0x1f to configure TD guest's CPU topology. So set
enable_cpuid_0x1f for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0d6342b51dbc..32c8f0ba968d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -407,7 +407,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
 
 static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 {
+    X86CPU *x86cpu = X86_CPU(cpu);
+
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+
+    x86cpu->enable_cpuid_0x1f = true;
 }
 
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
-- 
2.43.0


