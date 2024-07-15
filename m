Return-Path: <kvm+bounces-21618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 790E3930D3F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3B6BB20E32
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E4E1836D5;
	Mon, 15 Jul 2024 04:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjyQGqMA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA8A139CF7
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018078; cv=none; b=R/H+SydPMkxTrNerQ4x5rmhR9S6tajxIPo0V7fOKaAiIx5EQk3ORdl1oQzJoXB4zT5LQbJFRDfbnqU0Khh9NAJrC13vCvH8v8CXSqlvjttSeZVfBn8gAkPUgmxTrCp7qlhVPdIXxkjBR++Hkc2/2YnYSX3T3yU53jV8tEWpF8q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018078; c=relaxed/simple;
	bh=u1cSsKiZS4LgVHWKLVbqsnZaR8V7g5t3vC4cMVukk+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gPa7uJAQjbp6tJZUJ/Tn2+D0ACs8mXFIPBxNZf/a3/5zsqHutysGEPub2HxAo1D8p9fy8pFCfo1vofHAi+WYzy9hCBlMGKooA1CqDJt9nOsBACbXIb7saEAkf6fca/pZ+UxAeyV8A3tTDI9ldvoPz0hjIYIUGr2P5DjK6KJNnWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cjyQGqMA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018077; x=1752554077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u1cSsKiZS4LgVHWKLVbqsnZaR8V7g5t3vC4cMVukk+s=;
  b=cjyQGqMAHrFBzHGmecLQmQBRSY/Ddiy7FB1Y1goxWOSqv4NdArLyteGG
   b1Zqc26kG1UxK+2dchjXXAAngv9GA6F+Ixb96saqJBwRcGRbaTdfsOQkn
   gLqmYCh5Lt7qW6GcO/CJXGajDKmn4h83RU/CnUnoI1MO9JZi+bpbaq05O
   s64Fppa44ObsJA0dcZljBJPe0ZzDcktXuItZMBhQNpOisyxqs8GRQKlPA
   qipwqB7CmRARUpx4kl2Gg4ejyh67jxJhFSxcWQj23CfVI6aSGGKtmf1Dw
   Mw57SfOED2KB1LefbSszSvb2eXBygimnV/kihKjYpS2qQhsLs3x4EH0CI
   w==;
X-CSE-ConnectionGUID: sQqZkRprQwmt99ZOh09FOQ==
X-CSE-MsgGUID: Fj8K9EOdS9eKSooQPTUgKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809850"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809850"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:37 -0700
X-CSE-ConnectionGUID: mkQ7gO4nQv6RF0012GTDWg==
X-CSE-MsgGUID: C+xQ9yLOT4aENov63PuQ8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043096"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:33 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 6/8] target/i386/confidential-guest: Fix comment of x86_confidential_guest_kvm_type()
Date: Mon, 15 Jul 2024 12:49:53 +0800
Message-Id: <20240715044955.3954304-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240715044955.3954304-1-zhao1.liu@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the comment to match the X86ConfidentialGuestClass
implementation.

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/confidential-guest.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 7342d2843aa5..c90a59bac41a 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -46,7 +46,7 @@ struct X86ConfidentialGuestClass {
 /**
  * x86_confidential_guest_kvm_type:
  *
- * Calls #X86ConfidentialGuestClass.unplug callback of @plug_handler.
+ * Calls #X86ConfidentialGuestClass.kvm_type() callback.
  */
 static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
 {
-- 
2.34.1


