Return-Path: <kvm+bounces-41998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06601A70C43
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9CCA1889369
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9EA26980F;
	Tue, 25 Mar 2025 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pFSzJycL"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB617269806
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938799; cv=none; b=fsHDsR1rjD+2iLqEK8Zwddxe5CeJ+89Ej24/8ou/vcKrY81ob4GckDr5okIdpG0VMUo9wRFv0/LZLtS8hwStHfn9XzeljX7XLNGbDAoSR6JPUbtckt3mVy79xedCWLkvsZYpNi/YHU0nEBImRIsJgT2tn9TmRfXKFNrvHXz2NL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938799; c=relaxed/simple;
	bh=3R09RuiAnBU8D6+J9O8s3Vb56r8kBcF+H5LbCga2D2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DfNMBZMnvpNj9iNIuCpWFE17vRKHzwfLptwfaL80stAg9AakwSyCnO8+Aceia5wqFtzaqu9seNH7Etz+Ygrk+IX8IZV/vYEfmpB1s9oxGMsI0Me8aOlJfD98yRK6MquxHTWS1bSf+pqsM56XTrbCicTuElE3MQM3b2BCdHWgk9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pFSzJycL; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=99Sb0eJWHhItpr3BqfyKTZVUmxWKVyySy6BYybNLtew=;
	b=pFSzJycLvYS6cAhgk6QZVrDh5/DwYFMaNeJN7N/5Oj91w/1irncfgSZJdgoia4NKgdgaP3
	Z3YeI3Y7omNjKaAL/RjBxvcKcihHHHlwZ1iL6qgkK3uSBADXGo23s2/13wlIdE3KjqjPSn
	V0rsTGPZaNT7VklqzN2s1RWMQsy1pB4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 2/9] arm64: Move arm64-only features into main directory
Date: Tue, 25 Mar 2025 14:39:32 -0700
Message-Id: <20250325213939.2414498-3-oliver.upton@linux.dev>
In-Reply-To: <20250325213939.2414498-1-oliver.upton@linux.dev>
References: <20250325213939.2414498-1-oliver.upton@linux.dev>
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

Acked-by: Marc Zyngier <maz@kernel.org>
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


