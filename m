Return-Path: <kvm+bounces-5421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 847C5821CEC
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 14:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 781561C221B9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 13:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018A7156E2;
	Tue,  2 Jan 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KGRsTZul"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C840156DB;
	Tue,  2 Jan 2024 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704202688; x=1735738688;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=idFpEvgzmeEYhH1RrghpYHvogfuzDBzKNdkrsQpu4BY=;
  b=KGRsTZultAITMkjduy8Cy2DFtqlR4NgevSz/JUPOiiy814ZJy+tQBCZQ
   oMI/NZwn6oGsur4nt9ucbKUPiwdXgqrNq86p4Iq2WgjbHpOPF8Bdfk+n3
   DIt8ys1v9Ok6Gi93pDvOPSqe+Vqny1HmWSBdN8huTUMir4fy7ybaE+t2a
   YTVvtQpAsaTPgJnK90pBeBizME4zMK5hjQtAgJubG97wZHe1ZwLohBECd
   i953M3YUvhNXJSr9hnwcFIBjtQSb/kIKHLkz1b4UZeWkpbvn0L84dAQhv
   KFcUMYaRQLxh6e0tnCZKt0YHCWG6EsvZw9mFDPbq+Kz5MD5bCXrsGVyQo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="377035320"
X-IronPort-AV: E=Sophos;i="6.04,325,1695711600"; 
   d="scan'208";a="377035320"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 05:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,325,1695711600"; 
   d="scan'208";a="28066458"
Received: from rmuntslx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.36.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 05:38:05 -0800
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 9C36E10A568; Tue,  2 Jan 2024 16:38:01 +0300 (+03)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] x86/sev: Fix SEV check in sev_map_percpu_data()
Date: Tue,  2 Jan 2024 16:37:47 +0300
Message-ID: <20240102133747.27053-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function sev_map_percpu_data() checks if it is running on an SEV
platform by checking the CC_ATTR_GUEST_MEM_ENCRYPT attribute. However,
this attribute is also defined for TDX.

To avoid false positives, add a cc_vendor check.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/kvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 0ddb3bd0f1aa..5b495cfc79bc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -434,7 +434,8 @@ static void __init sev_map_percpu_data(void)
 {
 	int cpu;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+	if (cc_vendor != CC_VENDOR_AMD ||
+	    !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return;
 
 	for_each_possible_cpu(cpu) {
-- 
2.41.0


