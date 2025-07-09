Return-Path: <kvm+bounces-51837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93891AFDE28
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E08661894960
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0006E224FA;
	Wed,  9 Jul 2025 03:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o4pEOk7C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E101DE2C2;
	Wed,  9 Jul 2025 03:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032039; cv=fail; b=UkTPCB4MMeC/xywRaEM+oVvp+nwTfYZuzT1bCh7M9WKAEoNSpRoU3RcXVsKYSsWgaEPlnjcP7YWzCU02ELE8W4CtwpiYlxU/DJRGIc760rOjngcj/cPT6nkZpEoaZ6wKBkP8WPg56LpI5Xxr0vuZmOZ5TBz/ui+wtiI8MfBE2y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032039; c=relaxed/simple;
	bh=gKag/YYmjVfUlL///DuKuHw71DqA0VGKJkXtyFZmay0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sHryytX0UXgh/Gd1A1lcjYTz8r2gdynol1A1KrrE90ixCFSbWjYh5WJsDnHUakz5tWX8gHDcDqzPYY2jAr9DvXXWomI4zf3sTXN1SrQl15Q5Q/tSQI3jaiGghKbEWOqbUEEQVbKfwAweo9zNiSqbvsuiQ2rtBOTUMDgAqMMIjAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o4pEOk7C; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VRIA7iB27JM7EGcS4n4L84J8vyfyUokHLwV0UHXUMXsh1jy6q5Z2Q3L3BjSE14VRjsjT0qqFzYdxo5OqKbkF/KlclBXb4ssg35ahYqo+Ej6rBRR2wOnTIuVoZCY0qCCrHfPSoGGvzASA2Z2tLlBxpFlz702GwKDOWE+sriq9DQe4Yn4i3lb9jjeGUCVJ4l8YtJviseEZOgnXHFX4YAl0uaQq/aOgjmRGNliq57StCNoSw/Rz8uraay8/TbemN73RTxRkvcNsyVMxhlIBL8TqGq69VnZK8FtZnP8Fi2rE114Ic2UvuSTBt7UmNBkSPEuF6Y9KiMZvLcM5i7Tp3lbnrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMYmA8N6qDUh56yowVOby32oPPpbXkSiY75xTe7tfHc=;
 b=dxcMe1vmspWJAMGbJc7gJnBQbcqzWi1TUNFSHFCq+qmNZMD60q+osKk2fwbU+UM1UjJWLmE4bhTY5PiRHm7C6G5EpGajcPzQM9PSawxvvI41vfzh+pmd+IXfYpSptiML2HO3fllJj+Orf6nqo2L/t4N2BkjvQIEDrZzpSlpRCpU2s8Sfk3EetAfCGwHzsQLIFSDHBQ+DMeEf2+HOyUTiQPikTdN82L6TNbrNeRmkPANodqiMbRuJb+7g1ME6+UXhxdWFVyXQrQXVlv0LJSEeMHLgIkmIcpvXZ5quZaosCnbHSYFt3Y5fEqmLK0ph4RnW5apnsjXa5U0v1Hs8BAf1lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMYmA8N6qDUh56yowVOby32oPPpbXkSiY75xTe7tfHc=;
 b=o4pEOk7C8Vvz1UHIeD3RIo5HrZIbux7uB0Ws2khkagKB95YP/+HI9xKpDNGm4SsWVPW9FNrFmMdmQQZaVb0zAaVgLhqco7nvdnFVOXApnVqn3vzMpjIn6CfHO5btjgGVQKD9Gr4nJc3W324AohKl0Bq0rYLhHb/XOCVt1xUSarI=
Received: from PH0PR07CA0116.namprd07.prod.outlook.com (2603:10b6:510:4::31)
 by PH8PR12MB6771.namprd12.prod.outlook.com (2603:10b6:510:1c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 03:33:52 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::68) by PH0PR07CA0116.outlook.office365.com
 (2603:10b6:510:4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:33:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:33:51 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:33:45 -0500
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
Subject: [RFC PATCH v8 03/35] x86/apic: KVM: Deduplicate APIC vector => register+bit math
Date: Wed, 9 Jul 2025 09:02:10 +0530
Message-ID: <20250709033242.267892-4-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|PH8PR12MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bce798e-3db3-4a67-dfce-08ddbe996c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?elS2QR66yk4c2ZxnTGaeGP+Yjzi+WQyO06BL1Xjazr7Kkwc3jzHa2pcdqTX+?=
 =?us-ascii?Q?cn/Q3GD0F6cNY/2S7XQu91L/lMwykKIwPP0vYFEqSKgLI4Z8xcOlHqYv87Oq?=
 =?us-ascii?Q?xTiZ4IBShCL0BmGXFmLwi/BG/Tl2GrOaVVyMwwZ79B1z8ojNfQwhdQk0kHMd?=
 =?us-ascii?Q?X2Nfr0LypllTQ0eUNruZUd8rHLWkHrMc5yEgqSO9u09i3abixiWYqUOcz5Vq?=
 =?us-ascii?Q?o4TXXg/7wVMsitNOnPjrty24hpQaese1C04IY8YEgx8VFT+ZPxim93ioK32I?=
 =?us-ascii?Q?qIGqDkZxKC1WuP07p64JEUFWB9VsQ4c1L0gq5zLHBYMzNSfKKg3yELl2HnDs?=
 =?us-ascii?Q?7jc7MnUh4k2mhGlAQsFTa9Nc6iZmwtoFn5SN5gSexRXwHR/du49Z5VEk3V0p?=
 =?us-ascii?Q?hK0Rs5+bcMHViwsKVIBOn6NyiUzbpQvJkfH5ff13rg7ZIhK3KUIGw+Sug0r7?=
 =?us-ascii?Q?gOAENYG9sPQt1zu8hNyMwtlJWSc3XVeux3mD2nFaHEpWv3UGCzEPozC+vhsa?=
 =?us-ascii?Q?Dmgn0owGVxphh0jdaSG27CvoLuauFXa9b7kMZgwGjzC2tjsRCsVEUj8Sdujl?=
 =?us-ascii?Q?mtIybXpBqdyQlKgJQcReyij0Jib176nTTgHyKyRiK/4b0TkeNjcKDZIMWAHh?=
 =?us-ascii?Q?rxx0RdN4NGLUy6nNLh5jwn4R4kb6W2mRRkEK/h7Lamwa9vuTJ2yD9NfARZ2m?=
 =?us-ascii?Q?/EbfKMNbcfbyNm3OmFfIfGfOXBWWHtUA5dISeSsNkOYfRCkQKaxE530eGRGH?=
 =?us-ascii?Q?yQ4xvQ9uOuQ97UhAEVyYeB9LTBP/Zvonz/sbHh88OHMsD/s09vaEXII4JA5J?=
 =?us-ascii?Q?XnZ+PVBxzT7pw9vnoNBMnlGQa3nTbiTl4y7voI7JYcu5gtI5/StPzvtyBQ/O?=
 =?us-ascii?Q?EvO3kaFyQZDUA6G+cCbl5Kwq7AHiB6MpJdLuexdaZR7zedEPSUu9pNbw8J4u?=
 =?us-ascii?Q?JxZ8pNVdy/kU+XVjxupvAQKp54KJzjwZttWwlwj08vtzIfnl5wIICdDKTKRW?=
 =?us-ascii?Q?boUPSjFOtfQ5la2uucrtn1GQbK8+Q7AcQURs0eks3tZJmwYaXjfzfTSRt4CJ?=
 =?us-ascii?Q?P2b7EcLSMtESK2HJzqH2PF0xfh8HHv2/w6e4SCgW67lpLsbv+GaNLAaKHqQf?=
 =?us-ascii?Q?r1VZrIPQPgx4bh6R9pTJyLyzknOXcUHGVu4UCyfX4TtAcBs2CB93sD7JlGlg?=
 =?us-ascii?Q?kIttKGHy0xqiGc9nOUEXrGqRTRTaKHOWjtPUQJ5GQAVHBwC/IpU32LPfuUy0?=
 =?us-ascii?Q?evE7hcdgu0u3WOlvJEZu92enFTc4/wRvOkmC3klqUSS6NxN89NDvoF1k1XFK?=
 =?us-ascii?Q?COZr1JLruc6xVE0flJPlyJjkGw3gy/XMUgex+XfbEPzeVE5AHdBI8eiKzZ2x?=
 =?us-ascii?Q?AJAz7DcYZD4p/j9GF5sZUP5/7w2sWCjmjvjf7YhHcWSxNk5Fb4SJneNQYkNW?=
 =?us-ascii?Q?0MST+1zMRD/WgAu8ylqV6tqgPYr+m9jyiUIBMaSA4She42ocs7MPu/h8Ytpw?=
 =?us-ascii?Q?Ozx+BFeha05L1vVFdoiyBD+8iVDZlHYNbNp/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:33:51.6628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bce798e-3db3-4a67-dfce-08ddbe996c95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6771

From: Sean Christopherson <seanjc@google.com>

Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
open coded equivalent logic in anticipation of the kernel gaining more
usage of vector => reg+bit lookups.

Use lapic_vector_set_in_irr()'s math as using divides for both the bit
number and register offset makes it easier to connect the dots, and for at
least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
better code with gcc-14 (shaves a whole 3 bytes from the code stream):

((v) >> 5) << 4:
  c1 ef 05           shr    $0x5,%edi
  c1 e7 04           shl    $0x4,%edi
  81 c7 00 02 00 00  add    $0x200,%edi

(v) / 32 * 0x10:
  c1 ef 05           shr    $0x5,%edi
  83 c7 20           add    $0x20,%edi
  c1 e7 04           shl    $0x4,%edi

Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
in KVM, and because the shorter names yield more readable code overall in
KVM.

The new macros type cast the vector parameter to "unsigned int". This is
required from better code generation for cases where an "int" is passed
to these macros in KVM code.

int v;

((v) >> 5) << 4:

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((v) / 32 * 0x10):

  85 ff       test   %edi,%edi
  8d 47 1f    lea    0x1f(%rdi),%eax
  0f 49 c7    cmovns %edi,%eax
  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((unsigned int)(v) / 32 * 0x10):

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

(v) & (32 - 1):

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

(v) % 32

  89 fa       mov    %edi,%edx
  c1 fa 1f    sar    $0x1f,%edx
  c1 ea 1b    shr    $0x1b,%edx
  8d 04 17    lea    (%rdi,%rdx,1),%eax
  83 e0 1f    and    $0x1f,%eax
  29 d0       sub    %edx,%eax

(unsigned int)(v) % 32:

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

Overall kvm.ko text size is impacted if "unsigned int" is not used.

Bin      Orig     New (w/o unsigned int)  New (w/ unsigned int)

lapic.o  28580        28772                 28580
kvm.o    670810       671002                670810
kvm.ko   708079       708271                708079

No functional change intended.

[Neeraj: Type cast vec macro param to "unsigned int", provide data
         in commit log on "unsigned int" requirement]

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/include/asm/apic.h | 7 +++++--
 arch/x86/kvm/lapic.h        | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 23d86c9750b9..c84d4e86fe4e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
 
 extern void apic_ack_irq(struct irq_data *data);
 
+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
+
 static inline bool lapic_vector_set_in_irr(unsigned int vector)
 {
-	u32 irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+	u32 irr = apic_read(APIC_IRR + APIC_VECTOR_TO_REG_OFFSET(vector));
 
-	return !!(irr & (1U << (vector % 32)));
+	return !!(irr & (1U << APIC_VECTOR_TO_BIT_NUMBER(vector)));
 }
 
 static inline bool is_vector_pending(unsigned int vector)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1638a3da383a..56369d331bfc 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,8 +145,8 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) ((v) & (32 - 1))
-#define REG_POS(v) (((v) >> 5) << 4)
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
 
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {
-- 
2.34.1


