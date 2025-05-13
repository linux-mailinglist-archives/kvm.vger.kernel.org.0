Return-Path: <kvm+bounces-46297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D3CAB4CA2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0D131B417CE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BE71F2360;
	Tue, 13 May 2025 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhfHmXDp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290E1F0E39
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120990; cv=none; b=HvSeM640snmtQJIb5e/vQwFCa3swMOvaohgS0OwZ+cRw/202w/3P20EObtSaiBLkUrpSkoI9Lsu7e6gGBSYGvmeHkMW7foI2BiE+QgEF4Cjy/Pr3dllsOUmGUC8Pi8AWRxXPf6th1MkkABuNOWGHBwJiBD8GPaQUtwWHMPWdngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120990; c=relaxed/simple;
	bh=iYNVoA1qR2nbztl9UDMv7iyeoXuMieRddKLZwHw4Gsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NKjWXIeNxWxgehoGVa3O/RUETOLi9ta6LCvHczGkajsTgmNLDDaPmjnAXvUH0rR38WZOHO0fWjF9HHJQgwVRCnnO6me21LpN1z6DR01Ti6TeRGcHZLpOT8Mx/b1JZlnK/aoRsmrZ/kKpzzuXF2gkrcXA4tlmAgBR23+qcSWruOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhfHmXDp; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120989; x=1778656989;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iYNVoA1qR2nbztl9UDMv7iyeoXuMieRddKLZwHw4Gsc=;
  b=nhfHmXDpA9XdJQoExv2AxWOChlXe7mZHDbzYf6HOGPsYFj1y2aVYVulV
   /+RiX+bcTfxjYkj2WEiLk5IdRMFuYSh8mC1Pi+r5XqQzCjUnKCqMafpO+
   uHdXy0egMOwggrGTV2IHDd62W34lKUNIWPDTVsuDdq6rSmsrd5djjXW07
   MxK0oxaqj+b22/7Ky+tgJHto39ys68/TMVaahlM1E3oXmdT6W1ghwqw5N
   Kx1pleHmN7YoKbIJ6T/z3XIrcivbrIK5cjmm0CWWM+QJnTfRONKsOLaui
   10qGsrRUMJUg7zSE2teD8WxpNA97JwM5r4dZ7f9SuVuXcU9VIGyWZucHl
   Q==;
X-CSE-ConnectionGUID: pVgGIjlaQByxnU+Nx+mJPA==
X-CSE-MsgGUID: xkiAnIttRO+SvG19HyZkvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48940997"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48940997"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: braFi5zqRJqcSxRVYXf11w==
X-CSE-MsgGUID: jG5sY8dXR0SdNIDI+15gPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740598"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 0/8] Improve CET tests
Date: Tue, 13 May 2025 00:22:42 -0700
Message-ID: <20250513072250.568180-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a bug in the current CET tests (the first patch) and do some cleanups
and add more tests for CET nested support.

New CET tests reveal that consistency checks are missing for CET states
during nested VM-entry [*]

*: https://lore.kernel.org/kvm/20240219074733.122080-27-weijiang.yang@intel.com/

Chao Gao (7):
  x86: cet: Remove unnecessary memory zeroing for shadow stack
  x86: cet: Directly check for #CP exception in run_in_user()
  x86: cet: Validate #CP error code
  x86: cet: Use report_skip()
  x86: cet: Drop unnecessary casting
  x86: cet: Validate writing unaligned values to SSP MSR causes #GP
  x86: cet: Validate CET states during VMX transitions

Yang Weijiang (1):
  x86: cet: Fix parameter issue when flush TLBs for shadow stack

 lib/x86/msr.h      |  1 +
 lib/x86/usermode.c |  4 +++
 x86/cet.c          | 43 ++++++++----------------
 x86/unittests.cfg  |  7 ++++
 x86/vmx.h          |  8 +++--
 x86/vmx_tests.c    | 81 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 112 insertions(+), 32 deletions(-)


base-commit: 695740795adee59b48599e2f1a6bf19866a77779
-- 
2.47.1


