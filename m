Return-Path: <kvm+bounces-53539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01298B13A86
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25BF517CB3E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 12:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167C126A0C5;
	Mon, 28 Jul 2025 12:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9K+8wtr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D5F264627;
	Mon, 28 Jul 2025 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753705770; cv=none; b=IfdX/zQ9JLq0cgsMNb66fJF5JsR5l0DmiuDwlK1bbFyGXK625OvL5MwLcZ0abvokNDoX+ddK2ix0aUTKAZVIro3teB8q67oEa7HzeTRDlF28Wvs4zXCNfmqZp4v3iwGr7oJhXIAR488ujJpCO/z/kVBNX7T1zdAImjWggu7X6YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753705770; c=relaxed/simple;
	bh=WUHLDpzN4yyBJ03WNWSWNPYEC4Nh6LTe3WOYShwnaxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8xgPMwItp5C38CO3EPRT+KXMu5Q+Z1/tAinIuKtrRr1nrKDyfPpZsBZEPJOFOJeHLZ2ffQG5xvbIXd7HIdSFdM16AK4UMtxjJDu7poVOukmWsG2dtBb384g7jgFKnkUPiEDdpDpbsx7DR+/WRhAqvBOV1vzx1Q+nh+6Wy/u1Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9K+8wtr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753705769; x=1785241769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WUHLDpzN4yyBJ03WNWSWNPYEC4Nh6LTe3WOYShwnaxQ=;
  b=U9K+8wtryLGrGgaTqaAAlSx7UOllZzT9DvTAxtm5UMlPF1FO0OOtp78S
   IWUWtIUx8RbklExJrZ66smBRQrUaBmcntOGTZ/r+LvteafHn3AvOevMU4
   iTVQrtQYcJ802ZHGFsk47H5xeAiOV2tkCn+W5ibD8Djli3q7DdN2+yZkq
   MNrIA/QzEGICofY4z81QF567N05Sc1zbFU2ElxaAHGwnWu09J89um/0DH
   9VHOoYFhTTddYPiUqPr7UpdUU6cN9mF0cv7nLZp9h2YCUizW+t0aFDVO8
   hrfQ+Abijc/GK/VVtZ3AGWRS0OzMDVy9opUQ20WdlBXbV0dkwtyMMZyxF
   Q==;
X-CSE-ConnectionGUID: I2tbL9XAQXCkyR9u0TVveQ==
X-CSE-MsgGUID: HXBD05M+SjWeof4ouOJwng==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="56043376"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56043376"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:29:29 -0700
X-CSE-ConnectionGUID: d7G9FBOjQwiZUQsKMc37cQ==
X-CSE-MsgGUID: e6FbP7+tSmWLcIICkPmEXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="193375648"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.205])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:29:24 -0700
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
Subject: [PATCH v5 6/7] x86/virt/tdx: Update the kexec section in the TDX documentation
Date: Tue, 29 Jul 2025 00:28:40 +1200
Message-ID: <3389378e2e239e4067294b1ae05b0dde65cb5bba.1753679792.git.kai.huang@intel.com>
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

TDX host kernel now supports kexec/kdump.  Update the documentation to
reflect that.

Opportunistically, remove the parentheses in "Kexec()" and move this
section under the "Erratum" section because the updated "Kexec" section
now refers to that erratum.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 Documentation/arch/x86/tdx.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 719043cd8b46..61670e7df2f7 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -142,13 +142,6 @@ but depends on the BIOS to behave correctly.
 Note TDX works with CPU logical online/offline, thus the kernel still
 allows to offline logical CPU and online it again.
 
-Kexec()
-~~~~~~~
-
-TDX host support currently lacks the ability to handle kexec.  For
-simplicity only one of them can be enabled in the Kconfig.  This will be
-fixed in the future.
-
 Erratum
 ~~~~~~~
 
@@ -171,6 +164,13 @@ If the platform has such erratum, the kernel prints additional message in
 machine check handler to tell user the machine check may be caused by
 kernel bug on TDX private memory.
 
+Kexec
+~~~~~~~
+
+Currently kexec doesn't work on the TDX platforms with the aforementioned
+erratum.  It fails when loading the kexec kernel image.  Otherwise it
+works normally.
+
 Interaction vs S3 and deeper states
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.50.1


