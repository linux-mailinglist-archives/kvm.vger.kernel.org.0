Return-Path: <kvm+bounces-54625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1D5B257FD
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06EFA88199E
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6939E2FF648;
	Wed, 13 Aug 2025 23:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LNPLmk4l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B7302753;
	Wed, 13 Aug 2025 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129598; cv=none; b=TrwT5RcctEwfVYmspreddraost2u9JQHhNVDD8Hf0yfkDWzA1xNDa9aI5tDiUQD/E20Y+wQEE1bUSDoPYlaePIdyNX4rczkAZgJChST3yQIGyTJH2jevsBZVwrWiXamGLr8OWfCsr5SZdkxAEuqEgsxeXpMdLJJTb1p5Vsxne7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129598; c=relaxed/simple;
	bh=WUHLDpzN4yyBJ03WNWSWNPYEC4Nh6LTe3WOYShwnaxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjkbRYNnpKUk2XIKDSo5Z8Xb2q/rgSeaoR8Id4wabaBDqMJILpFr6P7RW+aKjM93L9xUQkoNvJTJt/11O6TiS63ItJvWaelSc1w1jv8fKFaaCjEuEWndv34LwTKkUai4HnAOhSRCn3nQLmddYdCWQc/zWaLQAoQZFvqUow76OCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LNPLmk4l; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129597; x=1786665597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WUHLDpzN4yyBJ03WNWSWNPYEC4Nh6LTe3WOYShwnaxQ=;
  b=LNPLmk4lvZ2MX3OGiCmaIzkoEEQnKXvBBLtPrJIB+2nuUfugAUwiCYkx
   nw7LpSifCtBI17JYerny9hiZXxUzAD6EFjbLeSukz9d41y4NCLIxLqNmd
   lXKI4DFkejQYOivKAju+nYDZBgpY9gd5+ZM5Ql8a/1IHTWT8kofXUIEvN
   n7myBtrEzKQ2NYkRXijiIFhz4wHjw/IVb2Tu6Dri+5MgBZPr+uYPm50tg
   xgE/5XpBp89rBlrodsoA9zQHlJVcrI4vQpl1M8zYHrm6M+fAwyBx0LHkU
   kKZt+o61VDM1jURsAXCHd+vI2seBlXSjKGPK1OaFgXVHuhs+K5Sb0G93k
   Q==;
X-CSE-ConnectionGUID: GgNDApQBRumMg2DcDMkqqA==
X-CSE-MsgGUID: L6LzvwtgQcaKHE7AMIR40Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014740"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014740"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:57 -0700
X-CSE-ConnectionGUID: 7gL+YjEpQjOu7ht+J3/kYQ==
X-CSE-MsgGUID: DWy8hH41QR6f4R3yITT2xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105188"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:51 -0700
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
	farrah.chen@intel.com
Subject: [PATCH v6 6/7] x86/virt/tdx: Update the kexec section in the TDX documentation
Date: Thu, 14 Aug 2025 11:59:06 +1200
Message-ID: <baba4b44dd669ca72b0beb15424224f8103d5fab.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755126788.git.kai.huang@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
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


