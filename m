Return-Path: <kvm+bounces-19914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F36790E198
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8FB41F227D2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 02:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6AF4D8BA;
	Wed, 19 Jun 2024 02:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dzQ5eYTz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA745224DD;
	Wed, 19 Jun 2024 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718763623; cv=none; b=ptBDUtNLY3LCiW+kW+N6fCFfOB88CqYGwc40x4UgBV6hfk9YZa7ZRA3fQavJrorWc5djvzpUQwrvHUbLogbzN/8yHLTEomQMmY1yMx2PUJrAelw4pdxw4k5NoJGQf+WDmjZOtnOK8kQN4dsB3g8sD+xfzCg7k0i67ECHh3xt92U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718763623; c=relaxed/simple;
	bh=L4FZ6KZ4NQEXlCXFdqBaPb9Wfo46WVv6wjZlCzocA0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Sy+i1q60rCKlGabmRUJoCP/wpVF1+Esg0QrTuKzsPft6amL1Yd0lLgddoAIfLYxN3kxjuxoBtkAQNSYiEw3kf088xLsh/keGvt56fO3oW9P76zkm1JdStmUuGbVc/LSWZLTlVMXGWvbzNV78P8hslxjmxWBa4hcjItcchzCFm/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dzQ5eYTz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718763622; x=1750299622;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L4FZ6KZ4NQEXlCXFdqBaPb9Wfo46WVv6wjZlCzocA0Y=;
  b=dzQ5eYTzBn+JpZqIEkX/axlYZyqFYzfoQDXVl2N4O50gdvoZ3kp9Ksgl
   JLSNnMnA4g+tT0W27S5ajx0Za0VvaAPWHQm7WEpEV50FzcvTckhoV+KbB
   o4L1DINy0OsI81/VjtfmkZ30qLWEBCRWs+MHpLBKwhVO0aUS3SC3MCLS2
   x2Hz8X8pKTbRyoydS6y4s5EG3NOGOvyIOugC5Krxp531YY4T8rpWIsFLu
   XvzP60eJIPDlLdPqwX5L4e4poR/q1rT49ro+IkTh6I7GpuRihesQH/siN
   DFDDXJwCxoz2vVCjPgWFqwCZ0HoyRu9DedIJxBbhaKa8utt7MrY5ZuhtL
   w==;
X-CSE-ConnectionGUID: 7lQatKlhT06iRdoePEXpyQ==
X-CSE-MsgGUID: xJtHp/w+QOGcCEvssH7HXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15648141"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="15648141"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 19:20:21 -0700
X-CSE-ConnectionGUID: +5sIfbt4SNaj1Gmrp29TtA==
X-CSE-MsgGUID: AriEdL1KSFWvtuCR5Vp+zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="42470812"
Received: from unknown (HELO dell-3650.sh.intel.com) ([10.239.159.147])
  by orviesa007.jf.intel.com with ESMTP; 18 Jun 2024 19:20:17 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 0/2] KVM vPMU code refine
Date: Thu, 20 Jun 2024 02:21:26 +0800
Message-Id: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small patchset refines KVM vPMU code and relevant selftests.
Patch 1/2 defines new macro KVM_PMC_MAX_GENERIC to avoid the Intel
specific macro KVM_INTEL_PMC_MAX_GENERIC to be used in vPMU x86 common
code. Patch 2/2 reduces the verbosity of "Random seed" messages to avoid
the hugh number of messages to flood the regular output of selftests.

No logic change in this patchset and Kselftests/KUT PMU related tests
passed with this patchset.

Dapeng Mi (2):
  KVM: x86/pmu: Define KVM_PMC_MAX_GENERIC for platform independence
  selftests: kvm: Reduce verbosity of "Random seed" messages

 arch/x86/include/asm/kvm_host.h            | 9 +++++----
 arch/x86/kvm/svm/pmu.c                     | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c               | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)


base-commit: 0ce958282e66b3d1882e2bb2f503a5e2cebcc3ef
-- 
2.34.1


