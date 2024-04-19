Return-Path: <kvm+bounces-15189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0652D8AA760
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66C54B22B18
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F67A20DDB;
	Fri, 19 Apr 2024 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NLjHJ1dy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169E179F9;
	Fri, 19 Apr 2024 03:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498347; cv=none; b=DMPw1wINQyTkHwWqYnUNL0y9tUt95HI90TfnPDFy75ZgvvJTKEDc1YgGESUl37qwnn7Hs+wbt/PoI0g0BK6TUL/zNx18Ph01e9mRgApnWKXGU5a+H+H1lT+/9SfzlPK0/X6eBlGjpjn+6U3SMApcoWlj4gnwtzOuJca4deM3JHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498347; c=relaxed/simple;
	bh=NZsLuZu/5ti+G6Ydn1XN7FYIKHLkE4jtT7DJv0eWE1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oVrBS1c3B2AK960mS3NGmEu6MYsItS7/OpqDoMzG3gAqoAZdhv0PP3hTPLuVrBiQNwgmYt++mcWOp2R3gqimKCV6Ijt/OaqBYqyRH6Np8F7MbueGzQLsnCgE6OdkaKTD0+0/Y8makBhRbUW7wGMWbrSE+7UUYgKny7pchAqnxLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NLjHJ1dy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498346; x=1745034346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NZsLuZu/5ti+G6Ydn1XN7FYIKHLkE4jtT7DJv0eWE1o=;
  b=NLjHJ1dyH685VLeE0ORMQnDtkaSBCsUIaWjT2iO8dM3KZQknaPd5p/cV
   hDOH8mlr8Skx+8qNa03ITyvFblgwFvhYFLquEcS+kz9jEMjGNmRfqa/Yz
   UD76qyax+qnTpSDHN3KBAA8I8OaTMzzsfnnp8SW0oq2To15ntzGQRJ18l
   itKJAH64y33RrxswYbOt6C5gwkjMgQVuOunG3ysDYw3HwwT/2k+uRvZQj
   WdHj/906vKr/KtbC+BlDUXoiWsASdRMasOGQke+CGFSDdgCj6Cl7h/z9n
   s4fm3YmZVVE+S0j6MMPzmMcSK7BjxQXXFIL9qHdI665MEoXQsbwZ7HM7+
   Q==;
X-CSE-ConnectionGUID: h61CPVycR66Sh/IuareZXw==
X-CSE-MsgGUID: Rou8wjJtTZu41nWypDXSzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565418"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565418"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:46 -0700
X-CSE-ConnectionGUID: KKNFX8YoReOhSWUr/EmbxA==
X-CSE-MsgGUID: 1yc7TGEMQXObYBVkNLm2iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410140"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:43 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 04/17] x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
Date: Fri, 19 Apr 2024 11:52:20 +0800
Message-Id: <20240419035233.3837621-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
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
index c971386db4e6..5fd7439a0eba 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,9 +20,9 @@
 
 typedef struct {
 	uint32_t ctr;
+	uint32_t idx;
 	uint64_t config;
 	uint64_t count;
-	int idx;
 } pmu_counter_t;
 
 struct pmu_event {
-- 
2.34.1


