Return-Path: <kvm+bounces-20865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFE4924D90
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4825F285D20
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40811803E;
	Wed,  3 Jul 2024 02:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LiXRxKNz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C09717552;
	Wed,  3 Jul 2024 02:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972759; cv=none; b=K2q0koUBZ2+sQJaakDHz6wb+Sx+LLfcy7MspgI/tSdUhjoW31weiaTS5T+7q/eVrY2SGBDQQBUmTkxEyVN+oe0eRhZgI9Wa1u9Wlqkum30XPcoWpnrRoAa6ASzj7x3GuYqZ4mdw0ArGx0Q6z5wznTVzpNXoCIOXRQW60zxlG7Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972759; c=relaxed/simple;
	bh=KhG3sJ5luiiC8MFnE8cG6eZUNJPJ5V6DemW66c/WrE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ni6GUuZDNUpfLfAG+quYGcTAq8QEkeqc7oexpiG3pde8BZCH4AGdxtjj307OWgulHsniGzwW5CBV4JB1RLrNSPlPxSLsGOkC9VDR7+ZyvIbnWNtjjJ32j2Pn1X/WCADJd3L/PkvuTnoHchitKdW1xobryIQuUKH6R+v98Jz8LZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LiXRxKNz; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972757; x=1751508757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhG3sJ5luiiC8MFnE8cG6eZUNJPJ5V6DemW66c/WrE0=;
  b=LiXRxKNzlrVwKuv8e5CRG9wi7D30ONh34ajd5+Y4anqIsHXHC/Mw2iTB
   K1FT42ofNAbsmjyF2LnRbzgXLIUvya/+zMrrHsV2mMMcqMfmAQhfKepz4
   cjU2DIchmQHoDZfrP2YDuWMPFyEKIIiQTwVaNc3FfnAgKH0DNdnkX2JrW
   E5wR8LACfrct15Pk4RAL0pDRlQgXYgZXDTF56tYXbK/bBjImpIxLpBa1m
   I5m7s3CjYuzX8JWWQBePaY9A6hs9707O0xldg2xYW/JhIrdDxKkU0uWFj
   o1m5NWrinzpviarQFNcevEXVxWOUBAadeulTURObKT3Rx8YVDCiS+2iKq
   w==;
X-CSE-ConnectionGUID: 01Dq6B5qSzGP/Y7jHInvsA==
X-CSE-MsgGUID: yXzm0mx5R8uTkIfhTpzCuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310959"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310959"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:37 -0700
X-CSE-ConnectionGUID: CYW1qWbHR6+ERb9dcgelBQ==
X-CSE-MsgGUID: GAK1yrreSKSxOSPKwIjinQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148535"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:34 -0700
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
Subject: [Patch v5 03/18] x86: pmu: Refine fixed_events[] names
Date: Wed,  3 Jul 2024 09:56:57 +0000
Message-Id: <20240703095712.64202-4-dapeng1.mi@linux.intel.com>
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

In SDM the fixed counter is numbered from 0 but currently the
fixed_events names are numbered from 1. It would cause confusion for
users. So Change the fixed_events[] names to number from 0 as well and
keep identical with SDM.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 865dbe67..60db8bdf 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -45,9 +45,9 @@ struct pmu_event {
 	{"branches", 0x00c2, 1*N, 1.1*N},
 	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
-	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
-	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
+	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
+	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
 char *buf;
-- 
2.40.1


