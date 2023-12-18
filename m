Return-Path: <kvm+bounces-4724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E91D817257
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FCFD1F24049
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09F54239A;
	Mon, 18 Dec 2023 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7ugJDmm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C3A42389
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 14:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702908349; x=1734444349;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U8UJM3rqJjghoB/WtsGQMHJEz6TQ4VHpaLIM+nVRdDw=;
  b=l7ugJDmmgLzM+1ThHEdfNE5dUQN78Z1eDV/88srHyhAvAkwmsmxXUrOI
   p0tt+0e9KTYnKcM1zdecWsqO2JLPGwLqabX3qSRALP/XiGVhYQ9+L0Th+
   vhN5CVwtgXsurGKeX0F19UKZ1i5UweebJF6cQFaUWVTfhbGqxjfm/2i3s
   W/PxlIYKFpeWPgQfKxvNlD3hQUvhoR9OH1Gxrpqa4RG7H9eRF8q223zer
   f0DpPh3F3QFHC7JqsTS0hkNwgMLa2b8Yh9+I35MpWXQxtGAMF89S26PZP
   iYko88UtmyShO7VIzabJ5ELEgxWGBWdkJPvSst58Nv/kWHekHqxpKJtXX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2346348"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="2346348"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 06:05:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106957744"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="1106957744"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga005.fm.intel.com with ESMTP; 18 Dec 2023 06:05:44 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com,
	yi1.lai@intel.com,
	xudong.hao@intel.com,
	chao.p.peng@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH 0/2] x86: KVM: Limit guest physical bits when 5-level EPT is unsupported
Date: Mon, 18 Dec 2023 22:05:41 +0800
Message-Id: <20231218140543.870234-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When host doesn't support 5-level EPT, bits 51:48 of the guest physical
address must all be zero, otherwise an EPT violation always occurs[1], and
current handler can't resolve if the GPA is in RAM region. So, instruction
will be re-executed again and again, which causes infinite EPT violation.

Six KVM selftests are timeout due to this issue:
    kvm:access_tracking_perf_test
    kvm:demand_paging_test
    kvm:dirty_log_test
    kvm:dirty_log_perf_test
    kvm:kvm_page_table_test
    kvm:memslot_modification_stress_test

Just report the max supported physical bits and not host physical bits to
guest which is limited by TDP.

[1]
https://www.intel.com/content/www/us/en/content-details/671442/5-level-paging-and-5-level-ept-white-paper.html


Tao Su (2):
  x86: KVM: Limit guest physical bits when 5-level EPT is unsupported
  x86: KVM: Emulate instruction when GPA can't be translated by EPT

 arch/x86/kvm/cpuid.c   | 5 +++--
 arch/x86/kvm/mmu.h     | 1 +
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 4 files changed, 18 insertions(+), 2 deletions(-)


base-commit: ceb6a6f023fd3e8b07761ed900352ef574010bcb
-- 
2.34.1


