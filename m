Return-Path: <kvm+bounces-19916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9756F90E19D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 475B01F23E1B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 02:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29FB26AC6;
	Wed, 19 Jun 2024 02:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K7yNuHHF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F9E54784;
	Wed, 19 Jun 2024 02:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718763628; cv=none; b=mL1uRM+50RKb7fV8/sys4iEE9AQseD6r1BSxm6gIVvO7hdhdBKEEklyPYfoKzKBu8zf8TMqsQRyfxSD58ktGkOszJFee8yXN4IzKkM7oqvhRUpWmUXvWoX5a9Q4iq+PNN0YmXt/BEl6h99VSzFzruywBIbixZMHQGZy9HKAWC9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718763628; c=relaxed/simple;
	bh=ajFH7YOCEsLxNE9uC32ipfoM37FPLBtYKxMW8/jxlcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aX81W1jZa7zWx5h4yVobKFVdO//4ifYJKtgEXsNclD5C3SHQpkzDRRN9W4nQq5AQWxmKRd0DEcW+13XcJCYa0fh8GQN/y2mP2pkFR16GwHZw0Q75dtjxHUPG3/EppNyOXc2wl3K3bb9E92kuENezFhi/tfzBAyFN4VPVKnrSyTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K7yNuHHF; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718763628; x=1750299628;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajFH7YOCEsLxNE9uC32ipfoM37FPLBtYKxMW8/jxlcg=;
  b=K7yNuHHFw/kTh81H4cyP7dzrCaEaEkkVe1BXSK78bSaSGOtFrONbQFwF
   ejDVn6aess22+fr5wvWJMfSHbZ6n364Hulc5LNII7CuR7ULgACWnr1fQf
   M1e/QEYRObWltqum6VSP75QEDM5Wk8D3ereubwzSPUpFa3Ro+Jmsxdxgb
   30+oTMRqFWoDSq4kDUU1kt0PvLVlqyr+B62L9OxGdCcFHtifrYSznkk8f
   TufnTsbtBTCCl2fqZ7aavgmtpm6/zSQ5PKPqgIrJTN/WngS8TLBcChF6N
   Zly1oVGD5dU6h/s3xgy+tPFy7bvIj9ACHAEHB4GFP4xYS1BkZBvh3Kj8M
   w==;
X-CSE-ConnectionGUID: itI4koKoQJmSLRlDGFkAXg==
X-CSE-MsgGUID: G6WJ5i8aQkuj9TG9AoUw2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15648161"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="15648161"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 19:20:27 -0700
X-CSE-ConnectionGUID: aL9Ny94MS0yg0kmGquyU6Q==
X-CSE-MsgGUID: oo6zYS24T7GR1/bbaxgpag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="42470854"
Received: from unknown (HELO dell-3650.sh.intel.com) ([10.239.159.147])
  by orviesa007.jf.intel.com with ESMTP; 18 Jun 2024 19:20:23 -0700
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [PATCH 2/2] selftests: kvm: Reduce verbosity of "Random seed" messages
Date: Thu, 20 Jun 2024 02:21:28 +0800
Message-Id: <20240619182128.4131355-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Huge number of "Random seed:" messages are printed when running
pmu_counters_test. It leads to the regular test output is totally
flooded by these over-verbose messages.

Downgrade "Random seed" message printing level to debug and prevent it
to be printed in normal case.

Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ad00e4761886..8568c7d619c3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -434,7 +434,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	pr_info("Random seed: 0x%x\n", guest_random_seed);
+	pr_debug("Random seed: 0x%x\n", guest_random_seed);
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
 
-- 
2.34.1


