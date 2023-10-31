Return-Path: <kvm+bounces-169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 266897DC951
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8700FB20CA9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E466213FE3;
	Tue, 31 Oct 2023 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uqjq+UmR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEB823A8
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:21:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D752B3;
	Tue, 31 Oct 2023 02:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698744108; x=1730280108;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yjOXbjPiGipjy8R9wCtdAqsCejHtbndkyznTFcK3Fpc=;
  b=Uqjq+UmR2IvTvPCDG7eO9mT2BFhfE3yq80xVVJT+JMrtLjkAlxRuDQd0
   +raHSMUmHLSUqh18OZPG7Y1K9QU4HF5vraK85DcR0/RdEnFyore2vm8rK
   /PTyZyxhs6kXCopsk4rNVKO+Q49YOuHWJKXvSdwvkAYhMvufZQCkzTtOq
   A7oaePsptLh547N3LUTOwYpp++UnBQGM+xR8CLXR88QfYz3CEhnUTW2Zg
   SuuoXfMWUdqX3yUiFy5NcrzXO4O9142/ZNQJ9YAmZ8XVjZ0MPgfV7AXkM
   Z5DGH4G4qNT0xi8J3BO5QBixVOCpFkzlb0CfIxfDXKrbe7ma2iZl4NYck
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385435948"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385435948"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="877445514"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="877445514"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2023 02:21:44 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v2 0/5] Fix PMU test failures on Sapphire Rapids
Date: Tue, 31 Oct 2023 17:29:16 +0800
Message-Id: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on Intel Sapphire Rapids, we found several
failures are encountered, such as "llc misses" failure, "all counters"
failure and "fixed counter 3" failure.

Intel Sapphire Rapids introduces new fixed counter 3, total PMU counters
including GP and fixed counters increase to 12 and also optimizes cache
subsystem. All these changes make the original assumptions in pmu test
be unavailable any more on Sapphire Rapids. Patches 2-4 fixes these
failures, especially patch 2 improves current loop() function and ensure
the LLC/branch misses are always be triggered and don't depend on the 
possibility like before, patch 1 removes the duplicate code and patch 5
adds asserts to ensure pre-defined fixed events are matched with HW fixed
counters.

Plese note 1) this patchset depends on the Kernel patches "Enable topdown
 slots event in vPMU" 2) this patchset is only tested on Intel Sapphire
rapids platform, the tests on other platforms are welcomed. 


Dapeng Mi (4):
  x86: pmu: Improve loop() to force to generate llc/branch misses
  x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
  x86: pmu: Support validation for Intel PMU fixed counter 3
  x86: pmu: Add asserts to warn inconsistent fixed events and counters

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |  5 -----
 x86/pmu.c     | 54 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 33 insertions(+), 26 deletions(-)


base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
-- 
2.34.1


