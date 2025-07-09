Return-Path: <kvm+bounces-51844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EB9AFDE3A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA2ED1C233E2
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B86D20468C;
	Wed,  9 Jul 2025 03:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D36dAc8w"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68B11DE2C2;
	Wed,  9 Jul 2025 03:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032176; cv=fail; b=YyizYHhHeyX2ts3HZs1bIxENf195LJKL1JgjQVjq4+XXQIfwaH4BztXbg9RMmfZOBTCZiJ0np7GjfVaOqvohRfcbW2DOXDeyRZ1ils5I5gdjph2hzfnqGGF0PPnbs3aYU+JpzaV2idk4zdjU3xDHcWuIGcQHrBVtApNCdB+o1Zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032176; c=relaxed/simple;
	bh=cY+TVSWR6om78RXjh9DaktbTe7dOqmIknzEkxe7PZGk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1bq4Um0vZ8zCxqfRECmzQn/aol/KrhB0eEGSz9aLMQ83i+0MDiChPVJSU83H8TpJtA3+IydBYDZh462MdZBk1kvFanQKtkD7f8M23rzVtLuDMkJhPz7faj7HnuAqW4XMYNaA2N/vAkAY7qJ2YwNw4wSEr4HKEVSD4SoK7FGKuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D36dAc8w; arc=fail smtp.client-ip=40.107.102.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzB0HxHmukHRCm5T5zLsMoCeOX3Al+QF7uX99/qt+h9O7BUX7ISIGPIXfzSzwfaGjfd4il6IPPDSKxZh+Bf1DhLaIdyk71Iw85GqBhIhQLOSgA2FV4oLDKTikLTeuWJ/kOio9saBKI4iQ+EVPrBIsKBSxg8ds1ogNKJ7eVsK59lDUU7mw+NNGZT5XKpAlr77AWaiibZtvwLlAWS2s9fZieknRC/uH646wDhMq81/8gUBd/5kuGWsv0zE8yunt7ZtFoomFereLC1I5ZAZ+PnJm85f0KqLNrbJ8SMwALBogb6MHky1bKB65QhueSNMJvshS++B9fMnxCAe1c0Z0v7JoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX7Ax/0IY5mkn+BVIGyYGKMVjKgiPzBFsTfZ3drsWr4=;
 b=of5KZWcYmCT22ebEg9I/O9sLTFO5SgYXx6jUwUvQZJH+k68QV87y8W/zU4lYu5xwPJImKfg4egf/FA5l3Mpk4oAR0bHT15NPOwOI5M7IL+e/SMGvdUbZ1Oldv062Aj9NPAYLfUTuvBvhVRjhG8AAByglRbl9mUbsFCBIl/Hy38+mKhbo1FcUqoktZ5TT9xDLb0Uqw2XbdxYCzjDMfMm5R2dczO1rwt/bZyRfkIZ7bGjMfXEihfCwMNYFXtAN8zJNmLtOFO7jqBotW54dRh2fhDP12CJwsXkVQ5ll+UdAoSsM5avBWMQgQvho9NrLm0wuj/KVWxLerddrZYR44DmzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX7Ax/0IY5mkn+BVIGyYGKMVjKgiPzBFsTfZ3drsWr4=;
 b=D36dAc8wr8mIuWemniSK+M4u/928XVh0fq9rsaDwIz/nM6OsS3imeJv5iG69QkWoFRJCM52M+l0Uq0BQ7wDmBNEhldXCZI+7TZ6qlglUr1WkrLmsSR2ufwyv2yxt4zPF2Y7pSxcSJRhYsBdx9R8ptNUKjseWVrs0BorlMmKhkuU=
Received: from PH0PR07CA0105.namprd07.prod.outlook.com (2603:10b6:510:4::20)
 by SN7PR12MB6840.namprd12.prod.outlook.com (2603:10b6:806:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 03:36:10 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::7c) by PH0PR07CA0105.outlook.office365.com
 (2603:10b6:510:4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.27 via Frontend Transport; Wed,
 9 Jul 2025 03:36:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:36:10 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:35:59 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 10/35] x86/apic: KVM: Move apic_find_highest_vector() to a common header
Date: Wed, 9 Jul 2025 09:02:17 +0530
Message-ID: <20250709033242.267892-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|SN7PR12MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e397c23-c0b6-403e-596d-08ddbe99bf69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BwHUNC2s416KmE5ZxXuv5ms0geEl28GEAhwCQqENrwY8MdPy0JyUEobKc1va?=
 =?us-ascii?Q?O21mtZMAuDlv98tP6Sr9XJ7Pjh3iLduGyWnlQO2wScRhhhLOKJSY9VoU57+3?=
 =?us-ascii?Q?5CyuSD1PG/SWUkeXYxkQCuFu0S/mPPn/ybHNMR9xQ9u1AT1DxQmORdJ5W+XU?=
 =?us-ascii?Q?jrO57kNxXcYmDvErEi7ZTGCS7tpLmJQT8nyTYqq/gbUnmiAL4sUeYn9Bq9W+?=
 =?us-ascii?Q?qfkr0+UWF8tAf2bD6kYju5Yi/gnjz44PrDs4lh7hXLVg2+dupR7e5Hw8i96k?=
 =?us-ascii?Q?eghbikV6zt6Fq2dcYAYqaoi95MtJykQTn71XRPopF/G9p6gc8wsNx2ykSI/7?=
 =?us-ascii?Q?plqa/J/eNu893FBZ17lCMcByIF1W6+u/8wrtyXBbMewuXS19ub41VijS/zNy?=
 =?us-ascii?Q?cYDTe2oyVq9M9MdEbblKZ2DttUJTSfxZS5XF7lkJ/U9PuYDoW8uIgAwTUMg0?=
 =?us-ascii?Q?/kBj2XUQn7/LpIGi6RN2ZapacoHtGjgby2/owIZ8Z9GdUOiDP8W4gw60L+t2?=
 =?us-ascii?Q?c7/vn00SXRDI3qSfMvjFiXhCB+OireZuA6lVL/m1QPnlq4CQeWERhWCmnRW6?=
 =?us-ascii?Q?SHg+Zzpe/1Py6SKjzOSdvcfu++sAq4MYiIiH7zpPSegPpzwphJE8/TDC2z/o?=
 =?us-ascii?Q?jvRa/9EMkwa90t1e56wYKBaV40uwGfQyQb0lzuOnudvWCr0T8VoXVCUplVu+?=
 =?us-ascii?Q?xLAL5e8+tGE/GQDaoeBPH3Z+ht+EsilnJ1OMytd9Bv0QDmWt54LKEe2z0Dsy?=
 =?us-ascii?Q?UtORzW9xdb4FxmK8xoykcXME36S+PsRTXpMV/3fD0C6FWVbyzEGpNTdRPl6w?=
 =?us-ascii?Q?zM4H1PqLa4S9TpUuQMq7wAo9TIlBClbujLdr8LM02Qk0TRKVaULWSpW60d+a?=
 =?us-ascii?Q?rxvHgkgjn8Bk4LTZGTHNTlOpOIecpMhbxyNmIhoHnGrNQ59G9orVyr5ALMIx?=
 =?us-ascii?Q?qVBye9sAlzb3d6Mn+dp0ZngzWUnkr4eL1vBmscaIK3vrTE/nuKs9sirEvczX?=
 =?us-ascii?Q?wQ2I+ylunC4S8S7G3NvfXZDirtJ3JFYblkJqkwoNNaXbS5Bv0xTCQzGnE4hQ?=
 =?us-ascii?Q?xddFtpKgQbo5r5oik2jsOC8YDklq0/OWqk0ElZQAaCG7u4QACscKS08ewPVu?=
 =?us-ascii?Q?1wXqjhoWLjzTGix5gL70xuCbWtXKbX7WLc+A7TDoROklG4KphK5QnhOr2m2F?=
 =?us-ascii?Q?R4cIcPBfqP0jx3PFF5aFpUvBe1OpcbfSixb0HvNFoVp8q/bd6hBSHotwX5UG?=
 =?us-ascii?Q?qoKXqPlk6olI1wIYmJjVA3w7lePU8+n3ARYu+nliVXlZemhBO1Ac+clUO5Bk?=
 =?us-ascii?Q?cSTRqw/CMW2WC0db0OB8coovkmPbVa0pY/sJim4hoajjXBgI+b3cr7sdCLky?=
 =?us-ascii?Q?oEDY9NZQynUoQRPfGyioxOumaH/hDP6tWFRJNZo7SCosnJnWSeAbTpxVo7CH?=
 =?us-ascii?Q?OaQj6p5qBwHHfNhf8FmayNlSg6budoO7rd449Zx3OKLjN3HleVSAfF1lOjAT?=
 =?us-ascii?Q?Ym8f3qCHeGU3M1EJC9fN9qzz9HH6do1oM8oS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:36:10.6225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e397c23-c0b6-403e-596d-08ddbe99bf69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6840

In preparation for using apic_find_highest_vector() in Secure AVIC
guest APIC driver, move it and associated macros to apic.h.

No functional change intended.

Acked-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Squash marking apic_find_highest_vector() inline in this patch.
 - Applied Sean's Acked-by.

 arch/x86/include/asm/apic.h | 22 ++++++++++++++++++++++
 arch/x86/kvm/lapic.c        | 18 +-----------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c84d4e86fe4e..c7355bcbfd60 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -503,6 +503,28 @@ static inline bool is_vector_pending(unsigned int vector)
 	return lapic_vector_set_in_irr(vector) || pi_pending_this_cpu(vector);
 }
 
+#define MAX_APIC_VECTOR			256
+#define APIC_VECTORS_PER_REG		32
+
+/*
+ * Vector states are maintained by APIC in 32-bit registers that are
+ * 16 bytes aligned. The status of each vector is kept in a single
+ * bit.
+ */
+static inline int apic_find_highest_vector(void *bitmap)
+{
+	int vec;
+	u32 *reg;
+
+	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
+		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
+		if (*reg)
+			return __fls(*reg) + vec;
+	}
+
+	return -1;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 069f3fe58def..018abf2ff890 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
+#include <asm/apic.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
@@ -55,9 +56,6 @@
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
-/* followed define is not in apicdef.h */
-#define MAX_APIC_VECTOR			256
-#define APIC_VECTORS_PER_REG		32
 
 /*
  * Enable local APIC timer advancement (tscdeadline mode only) with adaptive
@@ -616,20 +614,6 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static int apic_find_highest_vector(void *bitmap)
-{
-	int vec;
-	u32 *reg;
-
-	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
-		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
-		if (*reg)
-			return __fls(*reg) + vec;
-	}
-
-	return -1;
-}
-
 static u8 count_vectors(void *bitmap)
 {
 	int vec;
-- 
2.34.1


