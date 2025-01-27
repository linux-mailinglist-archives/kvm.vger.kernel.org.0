Return-Path: <kvm+bounces-36638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4664EA1CF7E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 02:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C90921885FB4
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 01:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C8CBE5E;
	Mon, 27 Jan 2025 01:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BjynUDKV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA0D8460;
	Mon, 27 Jan 2025 01:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737942243; cv=none; b=mFz/O7fCVLSeWrDWBFFAkI04Udl1DVwK22+4p4KIlM26by9NuKffY57K4yNr7WDwVOeqRGk4KxSZtsLkqnB68bZFcvve8VUoqvX297GXasCDV5UZ9vxdy8cn66iWTadt6DRuPlW+H8b4n3bZL6Gi+F/ZlIHeIsZxsdTg/z2SVTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737942243; c=relaxed/simple;
	bh=h5lpYhAgdn1wJ32rXiIk8d1FtWJ8M8I7QivnS3fjJj4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WUd+/bp0nCKBoFjm8Lxpc1u90Iws+Y/fFl7O4vSMFJmwexEZGU3O3wdcemTx1v2SZuw/yyKSgOl5dIoo9/mWqasS5G+AFFf1U6OmYtshtzFAviOQ5kq3bAkhX4GrUwTE9oRG0FvTfIzfevVhZ3VfX52vUWGIf1/7Ox3RFp1zrOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BjynUDKV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737942242; x=1769478242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h5lpYhAgdn1wJ32rXiIk8d1FtWJ8M8I7QivnS3fjJj4=;
  b=BjynUDKVAmMn12lGbG7j2FjDVVeRJYllrREh6tGWQUs1HUirx9ZaHnay
   YRCmggJpNUNlryqkzMj5DfGGiPXlb53WY2ObDOA2vn05p6prCOF2IFqfJ
   SAZbdltD1RaRGmJRIm6+tKHs1baQg4U3ifvzaQb0VhkGIaPEVcmjG6RAS
   wnorIYB5iQUeXewmyzrqD31q5ov2FCd1ONwwRZFXSQwJZPUJ/5lovWodM
   0XFInvMUyS3arvrGKan4TOTtj7j9s7XHAqq1AHWDuBsGfD0rRNayUXkSE
   CZP2kUh8xpOyOZ0PHNk6clIQC56V9L5ZWGtdmINl+g8yxzckKwOx6GYMI
   w==;
X-CSE-ConnectionGUID: cC4hDWWARfWyBemHixbsOA==
X-CSE-MsgGUID: 4Zfn+qOpRleCJBtplJApfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11327"; a="60864546"
X-IronPort-AV: E=Sophos;i="6.13,237,1732608000"; 
   d="scan'208";a="60864546"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2025 17:44:01 -0800
X-CSE-ConnectionGUID: Ks7qIPaSTwiaJlzK5TXOrw==
X-CSE-MsgGUID: zUKGFoLHQLyv1V9voyhodw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112321628"
Received: from unknown (HELO HaiSPR.bj.intel.com) ([10.240.192.152])
  by fmviesa003.fm.intel.com with ESMTP; 26 Jan 2025 17:43:58 -0800
From: Ethan Zhao <haifeng.zhao@linux.intel.com>
To: hpa@zytor.com,
	bp@alien8.de,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	joro@8bytes.org,
	jmattson@google.com,
	wanpengli@tencent.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	etzhao@outlook.com
Subject: [PATCH v2] KVM: x86/cpuid: add type suffix to decimal const 48 fix building warning
Date: Mon, 27 Jan 2025 09:38:37 +0800
Message-Id: <20250127013837.12983-1-haifeng.zhao@linux.intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default type of a decimal constant is determined by the magnitude of
its value. If the value falls within the range of int, its type is int;
otherwise, if it falls within the range of unsigned int, its type is
unsigned int. This results in the constant 48 being of type int. In the
following min call,

g_phys_as = min(g_phys_as, 48);

This leads to a building warning/error (CONFIG_KVM_WERROR=y) caused by
the mismatch between the types of the two arguments to macro min. By
adding the suffix U to explicitly declare the type of the constant, this
issue is fixed.

Signed-off-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
---
v2: fix typo in subject.
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2cbb3874ad39..aa2c319118bc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1704,7 +1704,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			phys_as = entry->eax & 0xff;
 			g_phys_as = phys_as;
 			if (kvm_mmu_get_max_tdp_level() < 5)
-				g_phys_as = min(g_phys_as, 48);
+				g_phys_as = min(g_phys_as, 48U);
 		}
 
 		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
-- 
2.31.1


