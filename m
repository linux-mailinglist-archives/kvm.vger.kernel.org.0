Return-Path: <kvm+bounces-34208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3CD9F8E52
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 09:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48320188C9DC
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 08:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CA11A8418;
	Fri, 20 Dec 2024 08:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gpp4cKzw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C13519D88B;
	Fri, 20 Dec 2024 08:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734684894; cv=none; b=swDhsAf0yOvvBZZVB84Grv3zFPFqVB7P/bwA4AAjCUGWiq0ndeehYy1SkbQze47hBLKKN05CFY0sakrhT1yh2+/3G7nGpdwO1pI5GVzUDDgp5+HEEzy3Ao83x/07XZLEbU1LaxmQD783vOfg1+mVAQ3sfiSBTVBUby1G63nQW5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734684894; c=relaxed/simple;
	bh=ePU/uE8OHvJJUNi6U7OwOYpHMZp+CfFWf0Iea5WEpBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gmKH2k+tFkJA2KMCAjxnm/Ok08YFG6DUl2/glJ9JvERPHmc2C0SVh+8cDIrT1P/+Ip1W2BU9iU/6XvbIpuGtGLVBhGS5BpMiRh7mHQ7D4rfkErR+6TTe7jP+tUWpyJ7efspmIV5pEh4mEzOOIof87EUs09bxIaEvO2okxUdSyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gpp4cKzw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734684893; x=1766220893;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ePU/uE8OHvJJUNi6U7OwOYpHMZp+CfFWf0Iea5WEpBU=;
  b=Gpp4cKzwuLlrpQSodvy8eyjRgh+14d/KzJJwQqVTQrhEd34kJOjzlDSs
   xAiKzFfB4INKugiWuI+Y2xgbw5+KqC9la7SSr5R2sAfsleCiVaIxPRoAc
   xQko81a0auvovOzLynDKLCZypFCtSENFKBlwtvdbPMAM/SRsBEZ4PS9AH
   QBniHPYYfCd3BdOiMBSHBtYiJ+B88/90/hehWqCoc7x3uzvKHZvwPjNrV
   vgVgqp1D2xWJygjxt8vXyQ5Mej1M+kO26UghA2hHJH6/etieVjRtfsQf+
   65iDcyn2AdZdxEIuX3nZIclm7JXe2qHfxz5ATybhMqb9LqxmTthu5gH4f
   w==;
X-CSE-ConnectionGUID: kIbZhazCQmeZof0RcZmcdA==
X-CSE-MsgGUID: yMr39yINTb2VOtdulPwwRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="35352226"
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="35352226"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:54:52 -0800
X-CSE-ConnectionGUID: R+1T2SMAQ6WKaM5+3YvDJA==
X-CSE-MsgGUID: CZWTUIvPSLm498ZMP/QuMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="98248078"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:54:49 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Fri, 20 Dec 2024 16:20:27 +0800
Message-ID: <20241220082027.15851-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi
This series is for a bug where userspace can request KVM to reset dirty
GFNs belonging to a memslot that does not enable dirty tracking.

Patch 1 provides the fix, which can be applied to Linux 6.13-rc3. Although
the fix is a generic one, its primary motivation is to prevent userspace
from triggering write permission reduction or accessed bit clearing in
mirror SPTEs within TDX VMs. This could otherwise cause mismatches between
mirror SPTEs and the corresponding external SPTEs, and in the worst case,
lead to the removal of the external SPTEs.

Patch 2 introduces a selftest for TDX VMs to demonstrate how userspace
could trigger this bug. If necessary, this test can be ported to the
generic KVM selftest (e.g., dirty_log_test).

Thanks
Yan

Yan Zhao (2):
  KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
  KVM: selftests: TDX: Test dirty ring on a gmemfd slot

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tdx_dirty_ring.c     | 231 ++++++++++++++++++
 virt/kvm/dirty_ring.c                         |   3 +-
 3 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c

-- 
2.43.2


