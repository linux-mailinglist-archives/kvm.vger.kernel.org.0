Return-Path: <kvm+bounces-26897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA52978E98
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 202B3288EC6
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901601CE708;
	Sat, 14 Sep 2024 07:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kj8qz5fE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC781CDFC5;
	Sat, 14 Sep 2024 07:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297276; cv=none; b=pn4G2cvIxz/35qAVCWBUKSDiklns+c7drKhx9lUcC0eS3TCRLtrvE4dJsUY0s5OYGkt8btJn5WCmbgiF3Dxx+xcnk/gCjm9F4pzEfCeOskp5sjpXAVe5RaFhOciVOHd2lojpucPQlWVA24MeMp/1BBHeQQ+4klrNr5fVYVRuimU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297276; c=relaxed/simple;
	bh=UBSN3tAHv7Ks50wCX/Fi8DfPkqAzLtxONkTJalnh9Eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uQwy1PocHb6aQYYELSLV72sKsE0gcvSHlBh3ISUEW2Q1AdlUdlEz5zXv4Ky4veUw6pqr2sRwqm5wN7aczW/OSCbbGXYmRIARfi4dBljUW93ve8pD47m/R21Ga2Q9KXuDrfJPiDJtI8pehBefbDNAW95bRaynRjPA17rBsXGYSQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kj8qz5fE; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297275; x=1757833275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UBSN3tAHv7Ks50wCX/Fi8DfPkqAzLtxONkTJalnh9Eo=;
  b=Kj8qz5fEzoYsst3IewtM/r4lDAG0AF60HdFbvXenmiy2J5H3FGkXisUW
   O4Me+bZpJHrQKT2qYqj7k8XA4OKwjpk5BKuLduJqAFMoWb3oszahMkvKQ
   h6Er9UvxZtaNHeSf8dZtTACB85JGukpEnUOyCPjxSiWIFBzVWrdlbMXFq
   vFIdp2FtKY+baFs9hUVsYHwExrp3L0ihe2IkRaoiyEFetFB/a+uoD23vt
   MUzisArRzH+tRTulzPrzDchuleAvIDuk3E7qQER7IZVmf0ffL75o3CfjI
   +oXYompJBlHhFAG1E3+fFR4PhIyQWqkDUarvWzkTqRbjTxIWcV8dy/Gre
   w==;
X-CSE-ConnectionGUID: zXm2cLfrTqSWVZ+qG5eGyA==
X-CSE-MsgGUID: eNk4kpcISm6YefctGdElrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778751"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778751"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:14 -0700
X-CSE-ConnectionGUID: gZYvSExUTUC89l/DUJ4LWg==
X-CSE-MsgGUID: DdxG5ZRRTba2BuyIEv5/FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950740"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:01 -0700
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
Subject: [kvm-unit-tests patch v6 02/18] x86: pmu: Remove blank line and redundant space
Date: Sat, 14 Sep 2024 10:17:12 +0000
Message-Id: <20240914101728.33148-3-dapeng1.mi@linux.intel.com>
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


