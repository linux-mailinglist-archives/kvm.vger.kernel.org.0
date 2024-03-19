Return-Path: <kvm+bounces-12132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B98EF87FE4E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AF87B23DB5
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBCE823A3;
	Tue, 19 Mar 2024 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DyPVefyk"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEC180BE1;
	Tue, 19 Mar 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853814; cv=none; b=p70RJxeszwwOXO9d7c3yp/EmG2ZyHWnqCH1odbwnIF3Uw9T3W6mSHuCTHov7iAv865kQInRwPMQG4RezV5UnTcrRfc9+CK6dyH5xuG0qDIMlcF7VkTvVqlHpv4/HF8pdqjkQnYGwKTifu5+QC7p++te64OP/o5QCthBxiMi+dyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853814; c=relaxed/simple;
	bh=DLpACTWgg6UtjxsumUlE13iTjn9+HG31gwbzCwRyKA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwNHDs0H8gPGkOPFaxrdSbC2XNhufau8mIAVqy75dZUDYPf1DR8qiFwlY+VODf8uFmfOk9+LQfDntNqqiLiDqcuhVcEf/Ez3znpI3PZIXmTHRMuLgmaQQFCG6nwPkc/n1KtFnpVLUucC4EejxrG8anE/sALbUu3lkVCsbg4Fmn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DyPVefyk; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gpbsniFgtOHZgJp8y3v9VSnosB7+jAV6rr5l+o89n6M=; b=DyPVefykUib1KIPMoegj8g39X/
	/nDPObhLkeoMI7u4nHxah1kVx8au4kx5ZEyDFD+ZDuheFFVB46BP3rnww/3MwZrYKl8URuB1F5nEy
	oW7VOzLSLhSpWwYJZeV3zL7VwGBpllJTgnKXWpn/77f5YnoSSL7QmwAqKjyFxk1xqPcxRQHzvgGOI
	5AGqNRj81DbPSZxtuV+JgKBEiPIOZCJ/i2O746DtfsY2u8pJ9peBZwS9+YUxyXwOLoZcfxB6zMrvS
	Ob9EIW/z0Lzu9cBAC1TN5VDAltEziSO82DRyUuaqebv/O6DmXBgihg5EdDmrJeNMO2q5USR5VfmmS
	MHbW4Vtw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZEA-0000000DDlw-1jEz;
	Tue, 19 Mar 2024 13:10:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE8-00000004PMq-3p6r;
	Tue, 19 Mar 2024 13:10:00 +0000
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
Subject: [RFC PATCH v3 1/5] firmware/psci: Add definitions for PSCI v1.3 specification (ALPHA)
Date: Tue, 19 Mar 2024 12:59:02 +0000
Message-ID: <20240319130957.1050637-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319130957.1050637-1-dwmw2@infradead.org>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
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


