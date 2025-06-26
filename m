Return-Path: <kvm+bounces-50825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBC6AE9BD7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C0513B67AA
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB79270568;
	Thu, 26 Jun 2025 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5FVc7lI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1254025B1D8;
	Thu, 26 Jun 2025 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934992; cv=none; b=P7SlfkkXQ3eXfxchiGUHlnW4ecbvMmcODNZ8KX6wSslXOyrQ7ysCHJQadiY1uVath2tUS222vY/Kd6gLGYoArrO62YcKUR9N7Q+n2K8nbP5NMtI3KCOPz0cvJGjB2FZk0KfOsag/9vvJirasipaRDUgixunIbrhHS2cT4n9mysA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934992; c=relaxed/simple;
	bh=nPbD5l0rheNy1UTotpL0AJxsu5rm2GIdag3PA3QGeXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQTdkBfsSziLU3GnRXRr/Gvvu4dXjJpKmsZJAZoBUk8CPLv1bLkwvlSRr1Y6uGzMzAQeJ8Kgbem1XCIVMfgfvH+zy8DdZAgZtc6FGTevu21p9dATSz/KfUdqEaW3QJEHipd5sYStjCKuEnihqLxDj2sywYklfix02j8EjqW4bBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5FVc7lI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750934991; x=1782470991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPbD5l0rheNy1UTotpL0AJxsu5rm2GIdag3PA3QGeXQ=;
  b=d5FVc7lIxhAbGcOkfVR99JJY3vBV8yOstcm2bSyr5KsR0ACuIOUxVtXT
   DefKvTFHzCDiQyaSUsMdMNzAwk2UnfLd/8S0peEjYfdUPVLVjj71DtdUU
   e0zuliWWjVgrCXnV2m3wqrPFcGWZLqzmoM3hTdbJWuBhJSktzhJ8NEkoF
   s2iWOzbHxqnfUv7/dp+j9mfbTlYzAYUkAoEioYA5bLpoR+UDVviCTXQlc
   9BU+5RXZKflgJptQHmja/qLPgnQoPhYSLhGatFdZcMTI/nPFXS48MqKyk
   cs9Mr/58NAsN6loH586+Oo4eqGH5DPMatZ2DVUF0jf571UNJ8aVWVXgHr
   Q==;
X-CSE-ConnectionGUID: h1KvSoQ/RfmVPzYTQVwiuA==
X-CSE-MsgGUID: RAyLy1jTTPilwIjrS6y0Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70655823"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70655823"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:51 -0700
X-CSE-ConnectionGUID: /poxqECsTbun26tn5RyVJg==
X-CSE-MsgGUID: Sf5k0uyIQaK7ejY2Lfy0YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152784355"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.86])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 03:49:46 -0700
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
Subject: [PATCH v3 5/6] x86/virt/tdx: Update the kexec section in the TDX documentation
Date: Thu, 26 Jun 2025 22:48:51 +1200
Message-ID: <f885089aadd485fb07fb9d18e3654ba4ef40f55d.1750934177.git.kai.huang@intel.com>
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

TDX host kernel now supports kexec/kdump.  Update the documentation to
reflect that.

Opportunistically, remove the parentheses in "Kexec()" and move this
section under the "Erratum" section because the updated "Kexec" section
now refers to that erratum.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
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
2.49.0


