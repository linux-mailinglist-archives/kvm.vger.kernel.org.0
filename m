Return-Path: <kvm+bounces-20866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0088924D94
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F21BD1C22D46
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841081BDC8;
	Wed,  3 Jul 2024 02:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cdz2ZPhx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E98182C3;
	Wed,  3 Jul 2024 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972761; cv=none; b=GBxIYJjuaaB+6990fN3vrjqQnjQl3GGy/Yq2q1FU70dGa42looxwxEw5X64d7GUPurSPBMO/sBNrgrb23heuDbJR1JDtqUu+FCBCxBl9uAk7zq/3riOKTdSdBrAe1xpRAfyh2GvKviJ3moNAYmq8fEHsDUIYxsXkwC+fTlkQZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972761; c=relaxed/simple;
	bh=TFH87E5BhpwdqBCfxEk/wJnJqhSK4EU8CSnk++BqOsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jDwJiaohh466qbLf8mgfvyK9O6F7Zs10Cyqi0s6W7BNPDvSTwgEA/T42IWMY6heTSlIp8lW9BS4e6UaTvQI1jUdFlj5gdgvNViuNtJuS06SGAJcH94AEGP0n8oPhZCVJx02nFT4nZuLFcEYTEVFudKIoDfb3rUzWcmiQ3RmR5pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cdz2ZPhx; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972760; x=1751508760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TFH87E5BhpwdqBCfxEk/wJnJqhSK4EU8CSnk++BqOsA=;
  b=Cdz2ZPhxy/xulHUnrQoOv438+fX+qJ5DSQh36K/wige+VPxAxjj4Wpj5
   u5UnC1EyK5uCtoXqnNuNWgWKr3oYbZLgux/3nBE8Bu2u5J0t2jXcD+SP8
   ljjFGxLjxFcgaJuyr3aHwWv08/3YzRGpXtSak87IQvW7FxAQBkptRqEYh
   qZIwnmn3a0KiJBGi55RaNriVhOvUmqUG7zzHPqazq+OlD4yYMXkMl7o/z
   k46IyrBv3pEPnjCOOpWk0r2M8iHqtKoAzKyPoDFnZFrF6p93Xvx41awsk
   F1W4UqgkkCra5/t5R9ILJAdAiq0F8CIJd6HrrB8vKoZ5TcyCdEWmtpL/1
   A==;
X-CSE-ConnectionGUID: VZxpr5cHTQikydoDcHYHmw==
X-CSE-MsgGUID: 775jBBpGSMqcVt20kNUwpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310970"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310970"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:40 -0700
X-CSE-ConnectionGUID: DEAJOVxWRjmWyc5EXNRHLw==
X-CSE-MsgGUID: 03wZetivQ/a7OoeE/URnhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148548"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:37 -0700
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
Subject: [Patch v5 04/18] x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
Date: Wed,  3 Jul 2024 09:56:58 +0000
Message-Id: <20240703095712.64202-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
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


