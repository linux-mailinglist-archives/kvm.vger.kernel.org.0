Return-Path: <kvm+bounces-16371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 432838B909C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65E9DB21AD3
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA5D1635C7;
	Wed,  1 May 2024 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAqkBQLK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D5DF9EB
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595395; cv=none; b=bDGHoA0L08YFYxIXY7vrhCDcei70UK3UNbj0kzi6c9f4S99Jd389B8jYTSq9nbEEe1K41z5f5DxUhMZh2PZmGIiUurX+IpHVY8dzu9R59zX831ZKJ3Ic0V1xkyYjZWpmw8wptbZw8jLQv3frWwhu+XBS34nOhD1hngLztlsnTpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595395; c=relaxed/simple;
	bh=w8jYKZFvQbgnl2hyCDvwQDdjslVByhTjeMFVvpaWjxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OHMLOp0wosS8fLmtP9UbN8afzer+QRTTzMTuMiiGnU8/VBYSG8tsRlGLOg1S2dON8W0YF3+XA5udcItClfdWhtC9MCgaMCc0heAALW3S3jBe11dkX6xAjqs284kwyKcpk6d8F15LEIApxFL6nzKKn9kaxjJCxTSXwmUcRAeiqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAqkBQLK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714595393; x=1746131393;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w8jYKZFvQbgnl2hyCDvwQDdjslVByhTjeMFVvpaWjxc=;
  b=NAqkBQLKXrHO/qtPQeUtQKaIpVlIzQNP8wdCM6RFKcCzh7qtwGScq73e
   KKyPgBqTFFt5qwh3fTjtjU5h4j2v0oJfeEbEfvOkLAoYuWU9qrqJN0shz
   RV6lK6Z4gKCbuKO99wa9/Un4crCKRmXZaYY5hjtWm5wopSkEpPbJsP7f2
   i3VPGrEc7b6fnglt5Hb9tW454OxRjVk5VyDlnVqPUYr1j3L0Rqdv84Kcv
   wQVfFRgnOuJPUfokfNc0s66DEkKD05AlSo11I3XlIUIv9P0Y84S4gR7L3
   yNdLvavAzovsrQfiPjF1vk06C+AqlBl8YeDBdYGR/Y67we4qWSopcn5Fj
   w==;
X-CSE-ConnectionGUID: dCONCjdWSMSygj23Ra120g==
X-CSE-MsgGUID: obmAt4nRSS2Eo/KR4XpOQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10472606"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10472606"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
X-CSE-ConnectionGUID: JoTiF7twR5y+ZIvHfBlhJg==
X-CSE-MsgGUID: 0HRcQ21fT2OIDZ8C41DaRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26890441"
Received: from otc-tsn-4.jf.intel.com ([10.23.153.135])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
From: Kishen Maloor <kishen.maloor@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com,
	zheyuma97@gmail.com
Cc: Kishen Maloor <kishen.maloor@intel.com>
Subject: [PATCH v3 0/2] Address syzkaller warnings in nested VM-Exit after RSM
Date: Wed,  1 May 2024 16:29:32 -0400
Message-Id: <20240501202934.1365061-1-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series aims to close the loop on a prior conversation on this matter.
I have picked this up from Michal Wilczynski who had proposed different
fixes (v1 and v2).

v2: https://lore.kernel.org/all/20240123001555.4168188-1-michal.wilczynski@intel.com/
v1: https://lore.kernel.org/all/20231222164543.918037-1-michal.wilczynski@intel.com/

The issue was initially reported here:
https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com/

It is caused by setting nested_run_pending in the vendor-specific leave_smm()
callback from the RSM emulation. The syzkaller test produced a triple fault in
rsm_load_state_64() resulting in a nested VM-Exit with nested_run_pending being
set and triggered the warnings. The commit message for patch 2 has a detailed
description of the flow.

The patches do the following:
a) Move nested_run_pending out of vendor structs and into the x86 kvm_vcpu_arch
so it can be accessed by common x86 code (e.g., the SMM emulation).
The usage and semantics of this flag are common between SVM and VMX. 

b) Set nested_run_pending only after a successful RSM emulation.

This evidently resolves the issue, but I would appreciate feedback
(if the patches are acceptable) and/or suggestions.

Kishen Maloor (2):
  KVM: x86: nSVM/nVMX: Move nested_run_pending to kvm_vcpu_arch
  KVM: x86: nSVM/nVMX: Fix RSM logic leading to L2 VM-Entries

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/smm.c              | 12 ++++++++--
 arch/x86/kvm/svm/nested.c       | 14 +++++------
 arch/x86/kvm/svm/svm.c          | 12 ++++------
 arch/x86/kvm/svm/svm.h          |  4 ----
 arch/x86/kvm/vmx/nested.c       | 42 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c          | 13 +++++-----
 arch/x86/kvm/vmx/vmx.h          |  3 ---
 8 files changed, 50 insertions(+), 51 deletions(-)

-- 
2.31.1


