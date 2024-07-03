Return-Path: <kvm+bounces-20864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 381A0924D8D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2B941F23F6F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD24134B6;
	Wed,  3 Jul 2024 02:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxbsfYUN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1804BE65;
	Wed,  3 Jul 2024 02:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972756; cv=none; b=tAqVJxP1KURuj6kQ+FnPo+iOFLwk5PJ1Ff2s5sHhcibFOk4DNRnx2geSeOspnUnd8KORe6AlXutth0cPRhrgKoLoxkuKUC9CMSB0Wm7zNgzOyHIimq3+ym32BvYXWDoO/+UMq+wIGtsEuMTFknZU89ZC/8ucfaQrNowylNtGPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972756; c=relaxed/simple;
	bh=UBSN3tAHv7Ks50wCX/Fi8DfPkqAzLtxONkTJalnh9Eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DGri5EHt+WZA6WZTIerD0VJSL55ckSaqT8ckv0pla25i/R4y4l3R/HJlGBjMExgooTMG63QG3VYnVkd+AVSd5Nm/FDScVCwiMjqIBayYn6fcuku+Ka+GBcqA3fCsOcHK3MmSrZRkULthDBRqsCgSoNGZn/SV55ipl1uePOPQ9Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxbsfYUN; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972754; x=1751508754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UBSN3tAHv7Ks50wCX/Fi8DfPkqAzLtxONkTJalnh9Eo=;
  b=NxbsfYUNobK/qETqFkQOmAtd518Enskv+UnB9ieg/Sd9LbB1lCGZya7g
   0G/Q/rHzEf3lTl7wrye6pWg58f0V6RpfBVeT1TpkoxFPHHkxzSPBacnWc
   yx35e4ImKw9gwQ73bU4fNAKWnVx5uU2rlB2+xqYq9Gks+Zt4lqYfKV6U9
   QdjHvdyfr+TP9pF0AHCiM8mUCHTQgXF9yId8KHgQjgx8I/N9zIg5yu399
   /KQXPeWQx/x5CL4rG0qs517Iz0QQeDjtZHuS/upRvau1g9LpGVcqNydmA
   k2JLy9CrKLordyPLg4tqo3CaPRq4iOk4v5A50t3Ii7xVhZIWmtWBHtQm9
   w==;
X-CSE-ConnectionGUID: SKP3bhXMQT+c+PqUmsz6hg==
X-CSE-MsgGUID: IoXSXtarTVCBkYM4NuAH8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310947"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310947"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:34 -0700
X-CSE-ConnectionGUID: yHfTQ/H9S8mDC5ZLKvpEmg==
X-CSE-MsgGUID: I8UY/wLqQj6Oyb42x2KIxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148521"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:32 -0700
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
Subject: [Patch v5 02/18] x86: pmu: Remove blank line and redundant space
Date: Wed,  3 Jul 2024 09:56:56 +0000
Message-Id: <20240703095712.64202-3-dapeng1.mi@linux.intel.com>
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

code style changes.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index ce9abbe1..865dbe67 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -205,8 +205,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min  && count <= e->max;
-
+	return count >= e->min && count <= e->max;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.40.1


