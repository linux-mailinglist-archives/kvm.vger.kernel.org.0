Return-Path: <kvm+bounces-11998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FA387EDDD
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53B5CB21D92
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C636555C1B;
	Mon, 18 Mar 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HKmXTHdT"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E004A9BF;
	Mon, 18 Mar 2024 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780431; cv=none; b=Gtl32L5vVjVx94schzFqlon71AK2PvW3eJqmSIcshFjC+E+IvZQfrhgiGfnNlx8EsFF8b4LQBKcLWhfPFzhmmJFmSXyLwtrzSgKH6DKxkVMOlqJqzaang1v86yqfDpck4P1F9JdgobFIKzgFyOLZZRkaP5X7vqjWmx13yuuySeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780431; c=relaxed/simple;
	bh=DLpACTWgg6UtjxsumUlE13iTjn9+HG31gwbzCwRyKA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAS3yP4vba/wiF2F1Kf885dIqSvYBzvJ2hOrPReFdbT7M6IZ46TsdTXDJkEy5L5/s64o+iC8gQJ1SCzbFZbImv4+zYDifHLyTYG3NbqT9WeD3wdfSUxKpsY2Tsj++Vkm/D2J3chbl07UxICAqP23P801jBTBFB6pd7wpM6FU9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HKmXTHdT; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gpbsniFgtOHZgJp8y3v9VSnosB7+jAV6rr5l+o89n6M=; b=HKmXTHdTTZMqF1ebxpIkrA5AsZ
	C8J6BC5ZewVFQ8NI16Fla1sRbIWFe4/EAa9bMgApSmJe/DQUBE5esC/8gW+J+lwaLng2I8MAsLHv6
	sG2By0Y0OJ5BlRDi0oUqUQnpVVTe8ZY3gGHBbMrYI6FYK5B47f2Nv7Mmv/mr8aeTTdfCdGWXffweK
	viBXqYUP0AZIR+70B6ffXypChI3qF724oGBbD1MlJ7lTNQyrmVnDrOH7KwRfY8bseXoRKZqU8mknX
	EPP7e9pJ6zg4Idtvnbna4SduTAVenAQ/NTmruHGv1MqT6W+ZeK+AL9o61BQNr7zQWixDzsyqKivwJ
	s2fIwQUQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8Z-0000000CjyC-1kfg;
	Mon, 18 Mar 2024 16:46:59 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8W-00000004F1D-0s8n;
	Mon, 18 Mar 2024 16:46:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v2 1/4] firmware/psci: Add definitions for PSCI v1.3 specification (ALPHA)
Date: Mon, 18 Mar 2024 16:14:23 +0000
Message-ID: <20240318164646.1010092-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240318164646.1010092-1-dwmw2@infradead.org>
References: <20240318164646.1010092-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The v1.3 PSCI spec (https://developer.arm.com/documentation/den0022) adds
SYSTEM_OFF2, CLEAN_INV_MEMREGION and CLEAN_INV_MEMREGION_ATTRIBUTES
functions. Add definitions for them and their parameters, along with the
new TIMEOUT, RATE_LIMITED and BUSY error values.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/uapi/linux/psci.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 42a40ad3fb62..082ed689fdaf 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -59,6 +59,8 @@
 #define PSCI_1_1_FN_SYSTEM_RESET2		PSCI_0_2_FN(18)
 #define PSCI_1_1_FN_MEM_PROTECT			PSCI_0_2_FN(19)
 #define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(20)
+#define PSCI_1_3_FN_SYSTEM_OFF2			PSCI_0_2_FN(21)
+#define PSCI_1_3_FN_CLEAN_INV_MEMREGION_ATTRIBUTES PSCI_0_2_FN(23)
 
 #define PSCI_1_0_FN64_CPU_DEFAULT_SUSPEND	PSCI_0_2_FN64(12)
 #define PSCI_1_0_FN64_NODE_HW_STATE		PSCI_0_2_FN64(13)
@@ -68,6 +70,8 @@
 
 #define PSCI_1_1_FN64_SYSTEM_RESET2		PSCI_0_2_FN64(18)
 #define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(20)
+#define PSCI_1_3_FN64_SYSTEM_OFF2		PSCI_0_2_FN64(21)
+#define PSCI_1_3_FN64_CLEAN_INV_MEMREGION	PSCI_0_2_FN64(22)
 
 /* PSCI v0.2 power state encoding for CPU_SUSPEND function */
 #define PSCI_0_2_POWER_STATE_ID_MASK		0xffff
@@ -100,6 +104,19 @@
 #define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
 #define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
 
+/* PSCI v1.3 hibernate type for SYSTEM_OFF2 */
+#define PSCI_1_3_HIBERNATE_TYPE_OFF		0
+
+/* PSCI v1.3 flags for CLEAN_INV_MEMREGION */
+#define PSCI_1_3_CLEAN_INV_MEMREGION_FLAG_DRY_RUN	BIT(0)
+
+/* PSCI v1.3 attributes for CLEAN_INV_MEMREGION_ATTRIBUTES */
+#define PSCI_1_3_CLEAN_INV_MEMREGION_ATTR_OP_TYPE	0
+#define PSCI_1_3_CLEAN_INV_MEMREGION_ATTR_CPU_RDVZ	1
+#define PSCI_1_3_CLEAN_INV_MEMREGION_ATTR_LATENCY	2
+#define PSCI_1_3_CLEAN_INV_MEMREGION_ATTR_RATE_LIMIT	3
+#define PSCI_1_3_CLEAN_INV_MEMREGION_ATTR_TIMEOUT	4
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
@@ -133,5 +150,8 @@
 #define PSCI_RET_NOT_PRESENT			-7
 #define PSCI_RET_DISABLED			-8
 #define PSCI_RET_INVALID_ADDRESS		-9
+#define PSCI_RET_TIMEOUT			-10
+#define PSCI_RET_RATE_LIMITED			-11
+#define PSCI_RET_BUSY				-12
 
 #endif /* _UAPI_LINUX_PSCI_H */
-- 
2.44.0


