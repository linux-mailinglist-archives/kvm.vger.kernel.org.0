Return-Path: <kvm+bounces-46294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92387AB4C9F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 352FE1B41062
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75C61F1301;
	Tue, 13 May 2025 07:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6Lk5bmQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69D11F03CF
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120988; cv=none; b=EzqBrQPxBARUTspMJ/VZ6+xmUIm2Zcrbu3wFGt4RBuSTA33/VDzQWXyEQfA8jp4p66eZyRFk/ubLmZfrYOPsNqkmyaevKzBheSqKSXLXfeKKG16tiJr6XsEYlFocmRJaGDoOZ8yfGFQZumIxwGtEw8gvn0EPHxdI6QE4JDTilxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120988; c=relaxed/simple;
	bh=EPC6U6yiCK6g7OuDEcRZQieAypoiB/RRi99ssf4cCRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzlWljusqH/apIwrhdDNKmCv2GnUp7E/DlYw9R+1//h3MzZhwtOrLf8kKbcWZ5jWmcie/VcE99l9FlJsuIFjPtpwetay3Bkvqy7Y+Yzp7+78hqP3QwwCnGteXHbfMIlIROCVhYBntdyKj8aVjkcaKlHiff6TndEw3CabON2N4O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6Lk5bmQ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120987; x=1778656987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EPC6U6yiCK6g7OuDEcRZQieAypoiB/RRi99ssf4cCRA=;
  b=m6Lk5bmQIj7gP9ObZAUPlmeWqFKUeFPHTfFYlOYPYFvsLAeSr/XTM+TC
   ZsA1XWFMsICty3axzcwteANDxJyzD6OVQXVw2rRiXPQWW/4QEtB6WHDoz
   94r9e29ODOAA+bqI+viGnbe+GOVclStiIn07K3ga7vbm0m5ViSct4ItNe
   jQqBuF39aI/iEGNzZX5kHvUogOrgJdP95efJ2qmdGI8JMWbZaHu+895rx
   ObTl1oTLmEy5K58dBxw1E9Evf4vaV/m0X31wehowpj3BwbuboH0UNjHn9
   /+yjGSkVBiU4ha1kV1HHX5rpuxagDMVgzrf1y2x4VAOp95rZ0LKONotdM
   w==;
X-CSE-ConnectionGUID: zcpi4lpzR9aH3braNwANjQ==
X-CSE-MsgGUID: krvUchKARgm7RsFDrE11ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941012"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941012"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: lemLWooLQgyJJAGnFoNvcw==
X-CSE-MsgGUID: NklkadLXT/S9p6QzkWrQtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740612"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 5/8] x86: cet: Use report_skip()
Date: Tue, 13 May 2025 00:22:47 -0700
Message-ID: <20250513072250.568180-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

report_skip() function is preferred for skipping inapplicable tests when
the necessary hardware features are unavailable. For example, with this
patch applied, the test output is as follows if IBT is not supported:

SKIP: IBT not enabled
SUMMARY: 1 tests, 1 skipped

Previously, it printed:

IBT not enabled
SUMMARY: 0 tests

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 3162b3da..5b7d311b 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -59,12 +59,12 @@ int main(int ac, char **av)
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
-		printf("SHSTK not enabled\n");
+		report_skip("SHSTK not enabled");
 		return report_summary();
 	}
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
-		printf("IBT not enabled\n");
+		report_skip("IBT not enabled");
 		return report_summary();
 	}
 
-- 
2.47.1


