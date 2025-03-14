Return-Path: <kvm+bounces-41119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95595A6207A
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9A37421232
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628D81C860B;
	Fri, 14 Mar 2025 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SOBCin/c"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE86A1DEFE0
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991674; cv=none; b=JzHZSR4eX9CyCuT+0s08rlS+uRCumEytDo2DCWEJkfY8b2RM0tBgpoVKyejqw32u9+DoMSiIEfv++13vvgry+NOdaIbHkveLD96z+gBppjiadyiJcDTnSBm8beugS3Jhy7S1hzsu1zpMBTofpqhMK2TgjcGV34JC8ocJz+38CM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991674; c=relaxed/simple;
	bh=z9629gb1tOIskh/aiHMKTA2rpMX9SSwAz3UTWcKmXKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OWQYVJFCxQw5+e82py77oYrBsLmaQMXZkHgH192vXVggwbA3oHk+0ewU5g7325pNk6OQBTKIt+4UG7uWEDHKMPOOPiuiAAjtTQ5ZpFooc+tPH15wCq1O+vRH2n+QyTwWNjCaVbjidzYcaTQmxamLOd4etsP0awaXf520un3U5vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SOBCin/c; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pge9pC0vSB5KypfN1MoQzc/bwCss0Z4P3hh9JP1x4uQ=;
	b=SOBCin/c2dRMFZgU53vCb/Xzb1DjdXYTAayP6EJCQg4V476CAnp5JCh/or5E0Yn+phF90P
	BFALCBW999o0MJPwcDXcOW5RRultqPlTTmZx2Xo1wf0gjr7RWAEKIn8xshab1HbTek4Zl6
	5Dhcm3Vqw1IyyDZmU2u1gmEtfMk21kQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 2/9] arm64: Move arm64-only features into main directory
Date: Fri, 14 Mar 2025 15:25:09 -0700
Message-Id: <20250314222516.1302429-3-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start the backing out the 32/64-bit split by moving arm64-only features
up a level into the main arch directory.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                    | 6 +++---
 arm/{aarch64 => }/arm-cpu.c | 0
 arm/{aarch64 => }/pmu.c     | 0
 arm/{aarch64 => }/pvtime.c  | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arm/{aarch64 => }/arm-cpu.c (100%)
 rename arm/{aarch64 => }/pmu.c (100%)
 rename arm/{aarch64 => }/pvtime.c (100%)

diff --git a/Makefile b/Makefile
index 462659b..cf50cf7 100644
--- a/Makefile
+++ b/Makefile
@@ -178,11 +178,11 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/pci.o
 	OBJS		+= arm/timer.o
 	OBJS		+= hw/serial.o
-	OBJS		+= arm/aarch64/arm-cpu.o
+	OBJS		+= arm/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
-	OBJS		+= arm/aarch64/pvtime.o
-	OBJS		+= arm/aarch64/pmu.o
+	OBJS		+= arm/pvtime.o
+	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/arm-cpu.c
similarity index 100%
rename from arm/aarch64/arm-cpu.c
rename to arm/arm-cpu.c
diff --git a/arm/aarch64/pmu.c b/arm/pmu.c
similarity index 100%
rename from arm/aarch64/pmu.c
rename to arm/pmu.c
diff --git a/arm/aarch64/pvtime.c b/arm/pvtime.c
similarity index 100%
rename from arm/aarch64/pvtime.c
rename to arm/pvtime.c
-- 
2.39.5


