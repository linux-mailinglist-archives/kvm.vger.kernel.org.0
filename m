Return-Path: <kvm+bounces-6515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CBA835D67
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A9D91F213D8
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE12A39FE2;
	Mon, 22 Jan 2024 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MeYJvrPq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C28E39FD8
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705913643; cv=none; b=ONSs/8jx5BQfCyCHHNUsB86DrHO2bZ2jVk5ASnoIxyjYov4877r9lbDyXqW+rGhZxRTsN/PTfk0qtgON9MpVNPgvlCRor3jrImdkVta/pDb6kJ5fIAvBDaytykw6vgQGDHTgxLaHx2rVzQ32k8JcimhmV++PBpt54IWYIyv5r6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705913643; c=relaxed/simple;
	bh=lq28X1/epSacC/ixYFdRDd7sWkt8ZSwLWID3XTeqCGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cfNRcvakNVpQzyRDrDibCXa1vf/Yh8rR5Br6KObWGCEHmgQeUExO5TS4qDuJZBha15qXY4h4VF8omi49xRb+mgxR/nYajt1KehTlM0fAEb5A2Idys0WOzno2PWW56f7cbnpCR4idMoHKVangF+V5IWyJuGjRaEgEaECl4rrbkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MeYJvrPq; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705913642; x=1737449642;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lq28X1/epSacC/ixYFdRDd7sWkt8ZSwLWID3XTeqCGM=;
  b=MeYJvrPq34AkHaOgYU5/lhytjkEpK81EbewVn0GGH4w7rbJ/SwqvVD5D
   6f8YS98Um0lLl9RJ1W8r7PDdHi7roEnA1Hq0KofTHq5whtH38FwLYMQVM
   OoOmmODk2IDpCuK2wkcYxENztEJpgCCPXC2aX5/5YapfbtLxRoFJ322ZN
   Md/TTOf3iHvU+1gfYJVoMM0iE69AZfm3GIvkt8Js0ZVEpHdkf3L9Kh2uq
   U+O1aox7MU8koMR0Wehb6IeCzKIBWFvoOXoV/kntLLwJckZhk0lxKgZGP
   NCGVHUH9saSxhIVqAYjQSohjAgLKuPMGfF/ym6hwcYcEFDHFuDZCAnw/G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="8536143"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="8536143"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="785611587"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="785611587"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.10.49])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:53:58 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v6 0/4] x86: Add test cases for LAM
Date: Mon, 22 Jan 2024 16:53:50 +0800
Message-Id: <20240122085354.9510-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata.

The patch series add test cases for KVM LAM:

Patch 1 makes change to allow setting of CR3 LAM bits in vmlaunch tests.
Patch 2~4 add test cases for LAM supervisor mode and user mode, including:
- For supervisor mode
  CR4.LAM_SUP toggle
  Memory/MMIO access with tagged pointer
  INVLPG
  INVPCID
  INVVPID (also used to cover VMX instruction VMExit path)
- For user mode
  CR3 LAM bits toggle 
  Memory/MMIO access with tagged pointer

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)

---
Changelog
v6
- Fix a comment [Chao]
- Use write_cr4() instead of write_cr4_safe() to catch unexpected exceptions. [Chao]
- Use a non-canonical address that will be canonical if LAM applied as the
  tagged address in the descriptor of invvpid. [Chao]
- Add a reviewed-by from Chao in patch 4.

v5
- https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/

Binbin Wu (3):
  x86: Allow setting of CR3 LAM bits if LAM supported
  x86: Add test cases for LAM_{U48,U57}
  x86: Add test case for INVVPID with LAM

Robert Hoo (1):
  x86: Add test case for LAM_SUP

 lib/x86/processor.h |  15 +++
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 319 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 x86/vmx_tests.c     |  52 +++++++-
 5 files changed, 395 insertions(+), 2 deletions(-)
 create mode 100644 x86/lam.c


base-commit: 3c1736b1344b9831f17fbd64f95ea89c279564c6
-- 
2.25.1


