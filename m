Return-Path: <kvm+bounces-6835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3A283AAA9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 14:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94E7628AA9F
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 13:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8AE77F07;
	Wed, 24 Jan 2024 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HT65R6BC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF38777622;
	Wed, 24 Jan 2024 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706101752; cv=none; b=b6CwT6hPioh+lbgF8nmtSA6dPBYJ1OsJqIELc06KLOHvp36oTue3tltRBEwh1yYQ835mwBUgBqeSCDBl7jYO9tCbf9xQXeszivbDTEo/OplBUn+URu9ln01deGuNv8WQRBkcTYfU3MCKHXGpFAHLbkFEOpmqq7azWTUtngcYAnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706101752; c=relaxed/simple;
	bh=NFxolRs646jfhfXCCby0HyE2+Jgy/482MfM1tdDgMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NLRGW6PSt8mayIntNbrXMzkKJLNqK60amsFyNsJahjBobXIVPpunXutUxReVDySol6QWCeLYPj++4FzuprEfFPFtOSvXrHTxpM5fhuJ58pR3jY1bNYw8Gf+jV/EzdCbQ93c4CLbrh5TF6uNCBFE9BnzIcegTbh100E/5M74OmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HT65R6BC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706101750; x=1737637750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NFxolRs646jfhfXCCby0HyE2+Jgy/482MfM1tdDgMV8=;
  b=HT65R6BC7no+3XQinNRlOrpAmMtSb7AAZ1AQm6tz/JrSQJUiCEm6R+cx
   siJ13n8WknxSDbcZ/6XLgXUnbRb+IT7/bor8APRHmjWqcKUrq45tCxx7Q
   79HTqtUP0NVaoCUIAwcPJYsewej7TmqrzRuIOG16BqrU7fCcokJ4osRiH
   3wpTK6clZfwpaJfMKrDFcgKwxDAlc+OgLyRtejwL5T/VYIA8tLDIxkqzo
   Rkj83w/czGsCyNwZM+QECp53s5+xPFZo/5aFxBSB61mFK0L5ikt6aI3zi
   OWDLQ6hQ6ta9ewxfBKS3DVDGyMkNbQAjhF5rtqggUjHjiIBeCPeb9GU3b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="8597952"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="8597952"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 05:09:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="735925597"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="735925597"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 24 Jan 2024 05:09:05 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id A140F9F; Wed, 24 Jan 2024 15:03:23 +0200 (EET)
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
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH, RESEND] x86/sev: Fix SEV check in sev_map_percpu_data()
Date: Wed, 24 Jan 2024 15:03:17 +0200
Message-ID: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.43.0
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
Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with cc_platform_has()")
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/kvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index dfe9945b9bec..428ee74002e1 100644
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
2.43.0


