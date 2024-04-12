Return-Path: <kvm+bounces-14487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A2B8A2C64
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA33B1C21F44
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE9A3FBB2;
	Fri, 12 Apr 2024 10:34:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5147826AF9
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918064; cv=none; b=KRmkkgJjeTU71oU7csbQTp2GQpmVFOwDarqkY7CIUSFuOx9fs/XvDiRRmhoOQ+L+JCJSKBPi98jBUXglN5GiiGaPGQ+4JbZvlj4C+mdmUqX+Rx60sP5Xi7blz1ByVOQhXSHq0IqppnHHizGm4d4B2pMmvB5caRPoZLKdR6fCO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918064; c=relaxed/simple;
	bh=Ctw8vJJkDEIvSuuFhIzpRsRR2XQ5C75jFGA7+4iX4b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rwFSRb7D2cFfiHr7RuL5xKEjHsFfyOLVosl+lZ7ZYSHpTrz4Sp1F5ZI/n0uWbRhd6870AuCXp0eVmeo/GPs47PRM0Mh0ztlqoan96Sw8QUMrHQd1QtCbZtaHxWsMxblyjup1mR0GNLOXrgfRE3VivxmlM068Sit8khyDmZ7ZGxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0A03113E;
	Fri, 12 Apr 2024 03:34:49 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F06293F64C;
	Fri, 12 Apr 2024 03:34:18 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 01/33] arm: Add necessary header files in asm/pgtable.h
Date: Fri, 12 Apr 2024 11:33:36 +0100
Message-Id: <20240412103408.2706058-2-suzuki.poulose@arm.com>
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

We use memalign() and other symbols defined elsewhere without explicitly including
them, which could cause build failures. Add the necessary header files.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index d7c73906..aa98d9ad 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -13,7 +13,9 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
+#include <alloc.h>
 #include <alloc_page.h>
+#include <asm/setup.h>
 
 /*
  * We can convert va <=> pa page table addresses with simple casts
-- 
2.34.1


