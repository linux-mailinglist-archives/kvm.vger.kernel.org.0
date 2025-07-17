Return-Path: <kvm+bounces-52803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBBCB09683
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:48:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A0217B26D8
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4960247291;
	Thu, 17 Jul 2025 21:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VI7MySrq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618ED23A563;
	Thu, 17 Jul 2025 21:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788860; cv=none; b=ozr1IRH7sAoHmmyzae/2J1/x/FwHG+4/hJex5xhDDrk8XnB2YQgh9CvewxJiz+BgI9a/S8iXjg8ulVXAvyQSsJ67hrngBc7hKGSn8M1CG9mC1Q8A/fFs4FV7j5wbcrQPrX0sCPrYGilip2PlCd/t5fcV5mXjlHXm8zVd3YOVaFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788860; c=relaxed/simple;
	bh=9OR/ASG/rWDiMrfQLxRxrU+wLWwPeQ/hqJqOKsFyV/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JODAD/86ew+T+9NSNMxNiUW/nFpr6jSXZ2S5f6dDRVbsudHkJaZM2DWPH1wds0Jr6phtM6t7HdZKGvAnEKrnBHlxR2Cv8Njva9WOqG0+GZ+qTKRSqzIuWlLM53XW3AShiSjA7yQh2oaCH9WTaU2PnqXQLAx9ep/YTwwHtLOh5hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VI7MySrq; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752788859; x=1784324859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9OR/ASG/rWDiMrfQLxRxrU+wLWwPeQ/hqJqOKsFyV/o=;
  b=VI7MySrqwSQbK/gJZY1E5sirNEbzgOoK8OeKBy0nZeu2Msf8x7LxDb+T
   W5Mkale/udigH1yIjxk2xzT+aC9xHYOFtXFT621jNA7ovQSaiiNhE9qTP
   JkTGjlCTD+B4HuEFL+vZ8ycQk3G+Az1nK6S3DS/YwcBs6vfJmUa7KPvEW
   VK7Te2cYZ9vKWvT+OoTkg7kiHODskvJZVBDVFaWaapCUNw4HngiqIpRLD
   Xdz9jhrpQWcwTB4fqHY+WqTvi5HnN+n/vV+ZwuUOEDnsNk94DN21kM+4X
   fLKYahgFd3a5okXOsKJPdYrO7P0iZH8z/JQsbV+Vr4S0AvqzAiari6TjK
   A==;
X-CSE-ConnectionGUID: cUz10YecRvySBp+B1YNH7g==
X-CSE-MsgGUID: VcYx93b6SdCUqPgC+esr2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66527815"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="66527815"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:39 -0700
X-CSE-ConnectionGUID: 14nrw7LIRveY4h5G013b2Q==
X-CSE-MsgGUID: kl44EH6CS5GbQGVevjfOrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="157295545"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 14:47:33 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v4 5/7] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Fri, 18 Jul 2025 09:46:42 +1200
Message-ID: <33eecfdd6297a0039c6898eaf2e17480fbf3782a.1752730040.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752730040.git.kai.huang@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During kexec it is now guaranteed that all dirty cachelines of TDX
private memory are flushed before jumping to the new kernel.  The TDX
private memory from the old kernel will remain as TDX private memory in
the new kernel, but it is OK because kernel read/write to TDX private
memory will never cause machine check, except on the platforms with the
TDX partial write erratum, which has already been handled.

It is safe to allow kexec to work together with TDX now.  Remove the
!KEXEC_CORE dependency.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e924819ae133..41dfe282cf7a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1900,7 +1900,6 @@ config INTEL_TDX_HOST
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
 	depends on CONTIG_ALLOC
-	depends on !KEXEC_CORE
 	depends on X86_MCE
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
-- 
2.50.0


