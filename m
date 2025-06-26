Return-Path: <kvm+bounces-50824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CD8AE9BD2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:51:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1D83AF1CD
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB4226E6F1;
	Thu, 26 Jun 2025 10:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQScZq+x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7F825B1D8;
	Thu, 26 Jun 2025 10:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934987; cv=none; b=qJ5DUXtnDBibZUg3Ry9nrOwS6onip9Y9kTgqbm8JnmF1cRR1fumFCaJkDPI1fpiz0PA1juFd9QCJupc5rovzh3z7Qjlh0kIZNYrfsNVuRIKEYRYFabARyGuUUaW826tOrGsRCpUClS31ZuLikOX8up5dMJ8mXcSzLTDBuAUFjMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934987; c=relaxed/simple;
	bh=UnEPQjbST0yIQL5kAKbK+dXltux/87JOeue/+D47lnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffqFOinaW9fupjMljv+Wn4TXyZyhAVTkvbk5KWYHySSXOoJ0T+GCVTbEDXSJtCnbXQRKu2tDjU6sCDgUIxF40KXiLZ+QIQtKOG9H1PZyKhjb05FebQbicMogAjS44R5kF3HMCYqlEn2+zbBHCwjBmJzGEBNQAq6xVvNTrKyN48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQScZq+x; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934986; x=1782470986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UnEPQjbST0yIQL5kAKbK+dXltux/87JOeue/+D47lnw=;
  b=FQScZq+xjQGi/LzB3IvO0/YC41ibu39Gf7+4HPS6wxHuYjEYLCKREu3f
   I3PujXCkjOwp/2FcZA4e5ay9wfWJfPxK+nccRLIdfVqboiO66jCmnvbnI
   39Vn4Feqq7co5pw3FWLb9Hp9s0FHEpdLiEhHLdtEGhQCxXThlGotmAPYt
   didiK6wWZVIE22Qmr/SUtgZQtU4E0Vr/WN/LcbWXv6Yw0sci6xpnuga1Y
   vzMhu3fIC8pSpDcniJZjZUAG9Gdd+QICu3rTFhX/+KYBqXQ74ENXN28sC
   E/DxbOfYbPTKIqQ7o8+Fp7xSOluMNyiqZowEeIHy2VhhEhN996SB2hpAt
   A==;
X-CSE-ConnectionGUID: XTaqbdbXTYusNGI9eYP7cw==
X-CSE-MsgGUID: F07V3iv2RI6NgELoI03TTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655804"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655804"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:46 -0700
X-CSE-ConnectionGUID: q7IeTlpFRre97LBms66Sbg==
X-CSE-MsgGUID: CVI+DdBOSdK+R73pK4IYCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784343"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:41 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	sagis@google.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v3 4/6] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Thu, 26 Jun 2025 22:48:50 +1200
Message-ID: <a80915684a5eaec7a27ac1900dc5125a36b330ab.1750934177.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750934177.git.kai.huang@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
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
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 71019b3b54ea..ca1c9f9e59be 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1899,7 +1899,6 @@ config INTEL_TDX_HOST
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
 	depends on CONTIG_ALLOC
-	depends on !KEXEC_CORE
 	depends on X86_MCE
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
-- 
2.49.0


