Return-Path: <kvm+bounces-58452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B72B94461
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56DD218A72DA
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6404F30DD24;
	Tue, 23 Sep 2025 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JJ3GsJdS"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCD2594B9;
	Tue, 23 Sep 2025 05:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603862; cv=fail; b=MnG2iGHsBm9D/Gz0CeEeR0ipXe0vco3YROarusiGOLcZaWOc+dYkYw9Ii/qyNZ3jvDT/i4YvJtsDoerV8ZfvgDcQ48VwK49Pz6JK4KSg8eGdLN0+ItXum94M52koDJEAJE1khA3DeVITjlF3RiKQlqrqYDxPV9fALNYhRH57Ddo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603862; c=relaxed/simple;
	bh=2HOfSbraWO/t9s373LMC5Wx2tB8tyL2KGdkOkNbYYAQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5ChgWhLamH1yrHFEzcV0rXmDG3zx3kslid7QRJgkch+XZC984Bo4Ggoq9hr4c23LpLMIALCR50RmkmT5Xt0z9W7g+XMM+S9sD12QcvPPAVRHT9lyuLcFJvq2n35dJYMw+84W8WNlrcM1S4pG2554ZLzGK4U7Bu0+9Cr0/JD678=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JJ3GsJdS; arc=fail smtp.client-ip=40.93.196.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0G++0aShtp84MwJX3lozHBmB/uiZZwF04K5uy1d27YZPkveY5OuOkTlTc4v4C6ZB52EsXWs0Z/TqxmipwTzl2u4BrNzlqU6izbZPzVzZckUaLqNkVMnXdGf62WUfUdZX90vg8q1FDVuojjB7M3kSY2Jnzkw5Hq2it2lNsx2xjqVq+WiWjVX66oiE0HKoHDpJZR6T1vHO+ARdaVH+r2XgbxAlGEOASQe5+1a/b0gyavVzamrW5HSkpI5fVqpFY7gSH+lQJYdth5xFv0YIEQYDym+oePC5sJf77f9MWkFkjIUrEzdkjKBGpwoODC5elQCIwKsxov3xb0/qi9QUfcEPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqYlm2qNWJG/uD6vhjzrpqGvwXUW2UufEzhkIBnUiK4=;
 b=EsO09uM67clBQfWZGVx4Ae4vU3nNc74RmPAgBbUaKZfs4jLF5yWhkZM3aiuzOkEVLr572m37qZnmCJcuhNS88blSjeUBKif+6d0oyJFJKg/xEPOn+wvy1iD7rqM17tI4jbDk3bfm+qYWUorvNfGXMlL8NXjUg9/3LqswXnVfaG/yI7nmZAlfviJLWQ7fXJhFkO1BTxzaqc/kL4bixF/1Ow9+lTLPlBmI/gXjorZpCNPPDbwTNfseU5V9QQtTGrrUWm1eFOQvZLUcluWceNiYlwmThmpy8w4QVLKVQt2cruPPYK4850l4MB9epwUewARDr1m5MTmw7SQVg1CeUrwuTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqYlm2qNWJG/uD6vhjzrpqGvwXUW2UufEzhkIBnUiK4=;
 b=JJ3GsJdScVATX+GHYBv0M3b2JbEQGFosdpAisBNZVOlEijBjvrIo+m5cldablngrlW+XsbQvuxTZGf+xWREmvmhuR8YDx/RtkH/HHwyEM3K87trWBkrNOtLcCa9k2I2tADkJKDKi04WTUfCdj98edSd7vsbywT4hpypdh2qwZyY=
Received: from BY1P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::6)
 by CH3PR12MB8934.namprd12.prod.outlook.com (2603:10b6:610:17a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:04:14 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a03:59d:cafe::c4) by BY1P220CA0002.outlook.office365.com
 (2603:10b6:a03:59d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Tue,
 23 Sep 2025 05:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:04:13 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:03:59 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 02/17] x86/cpufeatures: Add Secure AVIC CPU feature
Date: Tue, 23 Sep 2025 10:33:02 +0530
Message-ID: <20250923050317.205482-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|CH3PR12MB8934:EE_
X-MS-Office365-Filtering-Correlation-Id: 14ed459a-a94e-4c7a-b451-08ddfa5ea395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YT9WiT7FpSGcZe4ru8Y0II9u/0+tfzNau6BdGt1NebqI57I4lmZQqgAo56mN?=
 =?us-ascii?Q?P9syu8Jnbd7DO34HMROr0BXxBMt9RSIAPTuB+DK45eCmxo2NswBK381CMfn1?=
 =?us-ascii?Q?yaS4vzzLXKtU8TZuKIcUSlKEh/hL+Wl0EHzDemSmvMfH7kSSjBlLNTxldCwt?=
 =?us-ascii?Q?PLofuS5Kv3SGdXz4mkk0kg8mfVZjhJ9Z26F02UIJ+cCQHRHIYcBXYJDovmMv?=
 =?us-ascii?Q?DHBCHCprRPktHDdq7AH9g+AOvAg6iFR30ULMSc96OK8IOgX+1M7fK+2m1Zn5?=
 =?us-ascii?Q?7F8WsDWHOgFd5RUY+VeCRdQ0C+dY3gMICwduM0udj/PzYjWMt8Zf5a1g1CDF?=
 =?us-ascii?Q?HkbX6AH8EV4sSZxtHDG6CEa60MqoBGTWvBXa0TpEb57R+vTTJ7i/3rWN3aqX?=
 =?us-ascii?Q?SPkkrzOMoBu3k1g5/PaFGTATMDBust8pig/X3uXMSs1+Mw5BvyGaXdDWILRY?=
 =?us-ascii?Q?mw/mmbMfBMywGQwe7p00g4/hyYTJzz9qx3+vU8ZxP0p+QJJU791rXNlmlCYx?=
 =?us-ascii?Q?8z5zFRcS9kMlw+5er22g2rKWUTfoxrAaKq8n59YugLH4+8dHk9yVsafcQfRe?=
 =?us-ascii?Q?agCxconw0wvPgLV6jI1wwsIzqlTXnvfeZg3rKLUykbCQ+ZKYgvO3N4ox6XMh?=
 =?us-ascii?Q?PKN+hlwfLUKNJcj7hwQEiRXYxqxw7GKs1yKT/zXW23iedJ5yokgup7wHXLzU?=
 =?us-ascii?Q?iebE6J7nMyqp0m/U7aL51i4M8pi3DoA2cxrRzHm1UpPVL3scROP6BJWLSAlE?=
 =?us-ascii?Q?Q+m8Jsf7jKYytTVjeKj/XSYWA0A73nCoXZbweHmOllbUR75vMGagKkhtJKfm?=
 =?us-ascii?Q?B4xYO29fnsz8tcu3ec4lZYFu9TTv3h4Exu2FMUMZkHRc1MFB+d7EkyZvbk91?=
 =?us-ascii?Q?rsvfRgob7GrJOk2JGDP1HBj5amAatpF2uDIjgOxJ50uh2aqqN+uRphHMZj50?=
 =?us-ascii?Q?1E4rdcCUzScouAjYoXvLCiXDRB21idmZlL2BElzYPO5MYxVHx7lWI+/bQmay?=
 =?us-ascii?Q?T99622jQIineH2u2mzBrYfce6fRUaiz1XnCjlQzwCs+2hDaYSKamQw/Q6bF/?=
 =?us-ascii?Q?0hP4jNlw1JB1PhV/TUrm5Irq+b9Ioha0NKTgL1cqXWc4HpGlgf76E26juLdn?=
 =?us-ascii?Q?BwSAyOCHixKcsITrCOf7BVQW5Nst3lSYun1rhrPekUPHWPSXWdrRAwofm0Jv?=
 =?us-ascii?Q?7PAIt8GNBDVXG8MPZzgkEp5BaI2W9WLU7sVB74qpUzCXWbrfoNk3MaCQLDSS?=
 =?us-ascii?Q?zDqcen0USyR6pBGzLhv9FGLJvSZ869VdqPGe0YYTG473dSQ72pR4WU7PbM0H?=
 =?us-ascii?Q?ojqYZYlfSc68b7OTl/HnoYIXk/2S2F12gDr7iJP6YhtUeLZxyAlvL9EOW30s?=
 =?us-ascii?Q?OoNhaFnmUoAwLXQcjzvtrsLFMy3uxHfj23m+2cNF1xNwCwsEBhLQcB/zq190?=
 =?us-ascii?Q?8bJQNvK6vZdvDzdhdFnafcugFnC1y5qjPF7yfor2CnzH2EEcSsL4/u9RTjTT?=
 =?us-ascii?Q?I6SVEQ49hPe9UO/IYisustQlNkiWJNc49Jw3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:04:13.3393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ed459a-a94e-4c7a-b451-08ddfa5ea395
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8934

Add CPU feature detection for Secure AVIC. The Secure AVIC feature
provides hardware acceleration for performance sensitive APIC accesses
and support for managing guest-owned APIC state for the SEV-SNP guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 06fc0479a23f..d855825b1b9e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -449,6 +449,7 @@
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
 #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
 #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
+#define X86_FEATURE_SECURE_AVIC		(19*32+26) /* Secure AVIC */
 #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
-- 
2.34.1


