Return-Path: <kvm+bounces-14502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0278A2C73
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EBCEB2133C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AA556751;
	Fri, 12 Apr 2024 10:34:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F17C56472
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918092; cv=none; b=QZcyxU61jbJB6MuWiZsS9QcLZ+aorAGQ05hUtZQztFsrXXg69jNYFKrNkHbcVVouyJGta+Ish7zjiYzGOXOQomrRxwUUzzC0BNgXh+4IOJ6DGop0+0kDbDIjuAAuo3fgrEHwnvQIAPvbxa9Ay4CfGXGsVS4xBpS1xWOVPsa/75o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918092; c=relaxed/simple;
	bh=ZtoAmbW+izceMK05Sk9cQC0HsyKwu1PdMxZlvB63Xp4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u3tbTflS6R5n3bzfh3VVNKhNBN1o6jhDtv/d45zdzwl0/gL6VyUAH74/OuD68oEYJanI8NllQE5xS6whwAcNKJLpdVB8fZjiEpQ5Hxeu36TFdOx4+vzU6UXZJGpucD/X9CiH5r+TTiwu0iQeZbmeKLULDAYpFT78EXzQNOxATmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C18D1596;
	Fri, 12 Apr 2024 03:35:20 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C66B3F64C;
	Fri, 12 Apr 2024 03:34:49 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 16/33] arm64: add ESR_ELx EC.SVE
Date: Fri, 12 Apr 2024 11:33:51 +0100
Message-Id: <20240412103408.2706058-17-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Add the SVE exception class, so that SVE exceptions are not printed
as 'unknown' exceptions.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm64/asm/esr.h   | 1 +
 lib/arm64/processor.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 8c351631..335343c5 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -26,6 +26,7 @@
 #define ESR_EL1_EC_SVC32	(0x11)
 #define ESR_EL1_EC_SVC64	(0x15)
 #define ESR_EL1_EC_SYS64	(0x18)
+#define ESR_EL1_EC_SVE		(0x19)
 #define ESR_EL1_EC_IABT_EL0	(0x20)
 #define ESR_EL1_EC_IABT_EL1	(0x21)
 #define ESR_EL1_EC_PC_ALIGN	(0x22)
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 06fd7cfc..eb93fd7c 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -43,6 +43,7 @@ static const char *ec_names[EC_MAX] = {
 	[ESR_EL1_EC_SVC32]		= "SVC32",
 	[ESR_EL1_EC_SVC64]		= "SVC64",
 	[ESR_EL1_EC_SYS64]		= "SYS64",
+	[ESR_EL1_EC_SVE]		= "SVE",
 	[ESR_EL1_EC_IABT_EL0]		= "IABT_EL0",
 	[ESR_EL1_EC_IABT_EL1]		= "IABT_EL1",
 	[ESR_EL1_EC_PC_ALIGN]		= "PC_ALIGN",
-- 
2.34.1


