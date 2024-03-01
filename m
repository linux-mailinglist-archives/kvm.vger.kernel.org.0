Return-Path: <kvm+bounces-10628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A34E586E00D
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 557B9282F27
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7586D1A1;
	Fri,  1 Mar 2024 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ap+wXX4d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219BD6CBF7;
	Fri,  1 Mar 2024 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292059; cv=none; b=T7HXNreFL+hXZnMO4b/Ry0qc1tY0V3HE0NY9uXzLp9lyQGJ+2sIWAFOiYV3iAz4YkXkppenqOAUtdaepGfRH6fIWQWqv0kVfbUUbYJQ56OUlhMMM2NBIK+ddzw+hLImVv9lQUQTcXyH11Qvg/31GDvFm9Ukc5ka09+0k5FPindQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292059; c=relaxed/simple;
	bh=RvFOMtve6JbPnJm8Y06EMADvK3SIt9TrmBxajx/qPAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVei3dHE64z9cktfMl3R47V/dyJs8cdjlRhkyJTlOKUv1bGuY4W9UVoVPEMvby95vOKVNMRTS6I9b6BaaPWK/HjAFdVTbvBjrzhDfvG4CChqNmbpiO4tMJ8YyBCmAlikvPtiWGV/ri9eH6bRsmMEztmkPNqSgopIt/Ws9aa8Eb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ap+wXX4d; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292057; x=1740828057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RvFOMtve6JbPnJm8Y06EMADvK3SIt9TrmBxajx/qPAA=;
  b=ap+wXX4dblhEZmOZqQ7QsltO2h6M6LFHj4H/I9xb7ewzpZ8QXDvfztdg
   lEb16nKG5TUJomJNi7R3tDvvpBvgafZtJdN+rLsCcWy94pcxQs6S3zusJ
   b1odKNqejbYbTSUcjKI9CbNcOSlmuSQVV8aAJgIssfUbxhBpJ7p6O855w
   EzDYPwqa5Sxexi2OFWuZSlJ7zybkEnTq0av8DmNtLogDEhcv3RaznugHD
   163DYXdvuAsUQat3M3K85AiYjytcHHYT+Rk0hj1T5Zy7irHlBJ2LjCT2R
   ZtBm0DB5UYQzLorkdSegabqJDUEJXkkfs0s3xYgDs9267JZrFQovQYT6d
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14465032"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="14465032"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:20:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="31350675"
Received: from rcaudill-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:20:53 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	isaku.yamahata@intel.com,
	jgross@suse.com,
	kai.huang@intel.com
Subject: [PATCH 1/5] x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
Date: Sat,  2 Mar 2024 00:20:33 +1300
Message-ID: <a55e86430c81274af86d2d1c23cdce2f53fef7d6.1709288433.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1709288433.git.kai.huang@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TD_SYSINFO_MAP() macro actually takes the member of the 'struct
tdx_tdmr_sysinfo' as the second argument and uses the offsetof() to
calculate the offset for that member.

Rename the macro argument _offset to _member to reflect this.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4d6826a76f78..2aee64d2f27f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -297,9 +297,9 @@ struct field_mapping {
 	int offset;
 };
 
-#define TD_SYSINFO_MAP(_field_id, _offset) \
+#define TD_SYSINFO_MAP(_field_id, _member) \
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
+	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
 
 /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
 static const struct field_mapping fields[] = {
-- 
2.43.2


