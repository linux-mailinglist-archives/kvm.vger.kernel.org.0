Return-Path: <kvm+bounces-26899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B56978E9D
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A871C24EB7
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414131CEE83;
	Sat, 14 Sep 2024 07:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bON52U7B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C91CEAAB;
	Sat, 14 Sep 2024 07:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297281; cv=none; b=XsyPUcLtCeGg+2DEIxsFYaPQexhyy8t8EsMx5tMP7+IF+ZrMt/3TyJeUB8BSegc6lsu9MRW/GGQNy68VvDmk+DchOgJnjuvRt+5X22NZutJw7wCR9F1C9oydB9ZvKG8sr1Y0NgnBvBGRnn2h/zOi6oT/ZhwS80fYhKSwEHUeM3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297281; c=relaxed/simple;
	bh=TFH87E5BhpwdqBCfxEk/wJnJqhSK4EU8CSnk++BqOsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ouU720UVxpq8MnQNoG8UWRD/8z8YJXSCcfTDWYPOeofis3pBZu2tFqV5Cy/vG3FQJ89kWxx5jmAq5RPu5KUUpKZ4y961QrzDUbTS7nBU+kuJr7/DoqMS6cLPwTq/+9jBPzic2+s45Az3wuCbA4MBvgo2VBdYejMWNdq2SYpx0ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bON52U7B; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297279; x=1757833279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TFH87E5BhpwdqBCfxEk/wJnJqhSK4EU8CSnk++BqOsA=;
  b=bON52U7B8XPhxdFVXpYndjk/hQFyj9d+Yk6y6lw10koXN5wyE8OQft4T
   caObfebLtCYCfBc/RL3Ea7SbgiOP3NblB0NGR9bEStkrIGO0XZdUcFF9l
   okJd6JxPMcmaQHio9ty0eH2SZLxbM+K8UGsLg5/9Zlsl98WrlmellXCew
   q0i6dxKqAUx8tvmz59GfLrdv6CDyymjosrsBP2hDBC/768r2Um497v/UD
   oO0dyALZaojbOmA3CL1NI+pKw1lRNkJGU4IV+QubegQKNg4VAbG+nP6oU
   DTUxuT0gi+Wl29Ach7+YlrZMf77tqjmVXbGAVTRbDPvV09NUFyFgG/Hrn
   w==;
X-CSE-ConnectionGUID: hqbfNxhJSG2vmHAjWtbZ6A==
X-CSE-MsgGUID: 2rlyqjmoQCKR5YAJksnTAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778763"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778763"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:19 -0700
X-CSE-ConnectionGUID: 6BwvalokSHmdZpvP+lvGKA==
X-CSE-MsgGUID: VLItPEOgT7amraXiQFEC8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950852"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:09 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 04/18] x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
Date: Sat, 14 Sep 2024 10:17:14 +0000
Message-Id: <20240914101728.33148-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on SPR, the following #GP fault is reported.

Unhandled exception 13 #GP at ip 000000000040771f
error_code=0000      rflags=00010046      cs=00000008
rax=00000000004031ad rcx=0000000000000186 rdx=0000000000000000 rbx=00000000005142f0
rbp=0000000000514260 rsi=0000000000000020 rdi=0000000000000340
 r8=0000000000513a65  r9=00000000000003f8 r10=000000000000000d r11=00000000ffffffff
r12=000000000043003c r13=0000000000514450 r14=000000000000000b r15=0000000000000001
cr0=0000000080010011 cr2=0000000000000000 cr3=0000000001007000 cr4=0000000000000020
cr8=0000000000000000
        STACK: @40771f 40040e 400976 400aef 40148d 401da9 4001ad
FAIL pmu

It looks EVENTSEL0 MSR (0x186) is written a invalid value (0x4031ad) and
cause a #GP.

Further investigation shows the #GP is caused by below code in
__start_event().

rmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
		  evt->config | EVNTSEL_EN);

The evt->config is correctly initialized but seems corrupted before
writing to MSR.

The original pmu_counter_t layout looks as below.

typedef struct {
	uint32_t ctr;
	uint64_t config;
	uint64_t count;
	int idx;
} pmu_counter_t;

Obviously the config filed crosses two cache lines. When the two cache
lines are not updated simultaneously, the config value is corrupted.

Adjust pmu_counter_t fields order and ensure config field is cache-line
aligned.

Signeduoff-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 60db8bdf..a0268db8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -21,9 +21,9 @@
 
 typedef struct {
 	uint32_t ctr;
+	uint32_t idx;
 	uint64_t config;
 	uint64_t count;
-	int idx;
 } pmu_counter_t;
 
 struct pmu_event {
-- 
2.40.1


