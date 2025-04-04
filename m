Return-Path: <kvm+bounces-42675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 045EFA7C1D6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 229291B62830
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB9521770C;
	Fri,  4 Apr 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GEZUGsy5"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C6F21147A
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785586; cv=none; b=OFh2rs4+gdCZUPyElCN9ybRgwSblSQHXUPSoKVvQ9kGTODteM4s+S3oJyhZbAFZC3ne7mpj5R37D0jATmIwG7enTq6ALbIXA0Fw+2okLGkanZJVmFLsdIByJr2dvNBNSVQ4gZgY2Iq9dKsVSz2uCe+KOTjIBZrCV8j1ibnp5lpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785586; c=relaxed/simple;
	bh=kkPaVUgCFmbPdfGMiXEilhsHCLSdXhC5pk/a1F+6WuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZeldgnIvgOT+jhmBkBJvKl7xo9uQFaPYeWHbHYUoHCfqfF8p3L+FS6YDjnUHiuR/SpkeAcpK/IwI/CbPEELKsf/SaxfhSYzisuTy2PkMBnP32+f9l949SDmEzbGIOmPEPo8Xns8b5fUiHp6iMynrCY3J0b4t8lHXHsVbJp4QuO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GEZUGsy5; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bakQ/2npCdlW2yKfbWbcyOTSzI60F03Bg1vpazvE04M=;
	b=GEZUGsy5IbOcA0viH+bgaJUKSNh1AIzalBJI862RmOewH2GiC8IwOwES4/zXXPxRVpH8PU
	BB7y07kkHDULekbRe09/RTlombFJvzhLkRJFNblB2/IH7KwF6OWPby6bWltM4+orhchel0
	L8IrQAjbjnDKSnYwVdvCRyQh+kGajXw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 7/9] arm64: Move asm headers
Date: Fri,  4 Apr 2025 09:52:30 -0700
Message-Id: <20250404165233.3205127-8-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                                    | 1 -
 arm/{aarch64 => }/include/asm/image.h       | 0
 arm/{aarch64 => }/include/asm/kernel.h      | 0
 arm/{aarch64 => }/include/asm/kvm.h         | 0
 arm/{aarch64 => }/include/asm/pmu.h         | 0
 arm/{aarch64 => }/include/asm/sve_context.h | 0
 6 files changed, 1 deletion(-)
 rename arm/{aarch64 => }/include/asm/image.h (100%)
 rename arm/{aarch64 => }/include/asm/kernel.h (100%)
 rename arm/{aarch64 => }/include/asm/kvm.h (100%)
 rename arm/{aarch64 => }/include/asm/pmu.h (100%)
 rename arm/{aarch64 => }/include/asm/sve_context.h (100%)

diff --git a/Makefile b/Makefile
index 25ee9b0..3085609 100644
--- a/Makefile
+++ b/Makefile
@@ -182,7 +182,6 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/pvtime.o
 	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
-	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
 	ARCH_HAS_FLASH_MEM := y
diff --git a/arm/aarch64/include/asm/image.h b/arm/include/asm/image.h
similarity index 100%
rename from arm/aarch64/include/asm/image.h
rename to arm/include/asm/image.h
diff --git a/arm/aarch64/include/asm/kernel.h b/arm/include/asm/kernel.h
similarity index 100%
rename from arm/aarch64/include/asm/kernel.h
rename to arm/include/asm/kernel.h
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/include/asm/kvm.h
similarity index 100%
rename from arm/aarch64/include/asm/kvm.h
rename to arm/include/asm/kvm.h
diff --git a/arm/aarch64/include/asm/pmu.h b/arm/include/asm/pmu.h
similarity index 100%
rename from arm/aarch64/include/asm/pmu.h
rename to arm/include/asm/pmu.h
diff --git a/arm/aarch64/include/asm/sve_context.h b/arm/include/asm/sve_context.h
similarity index 100%
rename from arm/aarch64/include/asm/sve_context.h
rename to arm/include/asm/sve_context.h
-- 
2.39.5


