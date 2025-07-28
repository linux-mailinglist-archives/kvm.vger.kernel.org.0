Return-Path: <kvm+bounces-53538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9499DB13A83
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D526E3ACDD4
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 12:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21AE265CC5;
	Mon, 28 Jul 2025 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzckbcWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6DC267F48;
	Mon, 28 Jul 2025 12:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753705764; cv=none; b=EMHLjRjw4HRGY76uk3EaNIa36EPL+YikKhlAo9ZG7Gfdtk2m08chOYNpxas3tWzpLn+NqHNWVmP223K1Ih7Rki9HxnCN1uWDi0kBeGZd+tR3vNwzZDmpOHn+LUmaOhMLzmTHeMs7lFv+doMqPtOesIoiujLhLB7aiLhzFfAvVKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753705764; c=relaxed/simple;
	bh=RsTYyFppNTiESBzQNoFuQKFcG+PMIx4if+miTEOIJtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKy5oidoZx2/sMVltAJMLBqGyK4yfwr56QFaTWexJAXZi6c5p2RGBC9xplUpDjozRDMFlkFGVyo9e5E+k7MQ/TdqdDbJIw0buUG4/3YMKe9Og6hwknZz7D6Wk+KcHpc9UUrhT3H1GPWcuzLOLLzHpNbXEcszY4URhzD/CFAYcXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzckbcWu; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753705764; x=1785241764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RsTYyFppNTiESBzQNoFuQKFcG+PMIx4if+miTEOIJtA=;
  b=mzckbcWuEmq6T5rL5x0RbHNwtQ/F7unkOHt+q10M42lm7T8j+Td7XVKY
   gftZFyLNZALTqShRpZnAsluGOpqxK0d2Bz4ju36bS2hfqsdL2nyV/E1BH
   45dI61KrHUVGNYPMFD4q6yTm711JM3Egw8EZ6vhawD6XyOtNDuXBrtxhM
   MNW20Lii1b29n1DQ2i25XyOZ3sZHuqT43lXJ/w+SBhxS/cl1ipNlgkXx+
   yD3CssOHl8qgkHfUTbky7CFJyMHR861KTMm5+P69Z1JzYPi+5ZzM5JCf1
   xvhLY1mddocjCGdx5IL0NgY2Vy32fT8y3VRGGEuv4CScEerP7lnh/yHt6
   w==;
X-CSE-ConnectionGUID: j4FJupUyTfi7xpDxya8+gg==
X-CSE-MsgGUID: sDoC+0mLSdeUmjJMAKKKtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="56043361"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56043361"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:29:23 -0700
X-CSE-ConnectionGUID: dO9NC3SMTgiNUoZO53KqCQ==
X-CSE-MsgGUID: ZpaRA0SnTai35JC012hHIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="193375645"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.205])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:29:18 -0700
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
Subject: [PATCH v5 5/7] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Tue, 29 Jul 2025 00:28:39 +1200
Message-ID: <d9cc81ba095b9735a496a12b4502201b780628e1.1753679792.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753679792.git.kai.huang@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
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
2.50.1


