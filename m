Return-Path: <kvm+bounces-29847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02ED29B30A8
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:44:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A37F81F216A9
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F4F1DE3D4;
	Mon, 28 Oct 2024 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJADRT44"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE641DB928;
	Mon, 28 Oct 2024 12:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119334; cv=none; b=uNkPJ5zgU9htjIQUIfM/Z6mAhp11Gm13X5tsKzY18EkewzhLC7SrwcW6dRG4r4fhExMCvfQfN887no6j2CNobDVGqtUi2QB8md1GWUpVjN5PFY+nKetWyx7hd76bkozdIFMs/ErxL2mdlQxt9V5GBOyzMi+R6+R0mW4oDLqp6+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119334; c=relaxed/simple;
	bh=URmEjMJeWmPfaZ7ekc/vyFJ1i248/g1nmASADfGoXeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbJ9tmxk2ZXc2xCUYUr9BSh4MdZu2y2NBXjmxLqCTSHVvfzbBOTS0Tjct21phSWw2OJ/ocH6aR3WAS9XWkP0cF6ccY2HxzCkwG1JNwyoQuoh/saSqT4aqSk4aMjpZyUatW9EzjRADAMPSe91LZixfgTmgRFt4HMxr4aJkh1ELqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJADRT44; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119333; x=1761655333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=URmEjMJeWmPfaZ7ekc/vyFJ1i248/g1nmASADfGoXeY=;
  b=SJADRT44HUDwDp7Wwkqb5POl5nW3RyzUBzzZSvjqA7gmWnZD+eNoLhsV
   ZpJHYRBwtLqhyMC2fDiLhLwKypc1IyTDM7GnG8nAZa6HWrebcMZu/qCDk
   1/Kg94+ol03HibSpUw51EJ87y153pGsb1lPMDnXIwxCSfUuHhlBWQWupc
   avX0QQj9PGz1f+ygBDL891i/MM0cHXgRHVOHyOks0V4UpCGIEnvbQ3fDI
   w0utX1iS/h5vQ496NTM/EthdC4C6jjNG8uSwKeyOLkzf44I/HS+PT4RnJ
   CBgil11FkdO/UbekHp5t8UeWqaDYZozAwaDG9hGpUwDEsHt8GU0EiF7Ug
   g==;
X-CSE-ConnectionGUID: MwN0k7neSMugMP3AQXgsrQ==
X-CSE-MsgGUID: LF3/VYIEQn2kmceVx6ggZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575345"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575345"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:42:12 -0700
X-CSE-ConnectionGUID: 16UT0wELThuvJ8OP+tYWYQ==
X-CSE-MsgGUID: vTK4IaBcQcOuodK6CdP5KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420960"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:42:02 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 10/10] x86/virt/tdx: Print TDX module version
Date: Tue, 29 Oct 2024 01:41:12 +1300
Message-ID: <57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any TDX module version information.
In practice such information is useful, especially to the developers.

For instance:

1) When something goes wrong around using TDX, the module version is
   normally the first information the users want to know [1].

2) The users want to quickly know module version to see whether the
   loaded module is the expected one.

Dump TDX module version.  The actual dmesg will look like:

  virt/tdx: module version: 1.5.00.00.0481 (build_date 20230323).

And dump right after reading global metadata, so that this information is
printed no matter whether module initialization fails or not.

Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9bc827a6cee8..6982e100536d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -312,6 +312,23 @@ static void print_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
 	}
 }
 
+static void print_module_version(struct tdx_sys_info_version *version)
+{
+       /*
+	* TDX module version encoding:
+	*
+	*   <major>.<minor>.<update>.<internal>.<build_num>
+	*
+	* When printed as text, <major> and <minor> are 1-digit,
+	* <update> and <internal> are 2-digits and <build_num>
+	* is 4-digits.
+	*/
+	pr_info("module version: %u.%u.%02u.%02u.%04u (build_date %u).\n",
+			version->major_version,	 version->minor_version,
+			version->update_version, version->internal_version,
+			version->build_num,	 version->build_date);
+}
+
 static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret;
@@ -322,6 +339,7 @@ static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 
 	trim_null_tail_cmrs(&sysinfo->cmr);
 	print_cmrs(&sysinfo->cmr);
+	print_module_version(&sysinfo->version);
 
 	return 0;
 }
-- 
2.46.2


