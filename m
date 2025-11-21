Return-Path: <kvm+bounces-64084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A16B0C77F21
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2092534CDB4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F0C32F768;
	Fri, 21 Nov 2025 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2evXGuiO"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0813777E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714272; cv=fail; b=Q6Gwncz+70QAHRalgiaXsW3C+iBlsu01Akc2mhbNk7j2a+/FMMbym0esE+f80ZLDly8/ogfEDtSHHNcKBLO+/GFA4LBCbbJ4hFN+DNdNNQZoQQhocKdqpCYZ467JTjRXQiQ0yhPkjqoEKU9HlplnSaA7+ww2bPO+Hi1RJDXQMDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714272; c=relaxed/simple;
	bh=nSLM2a0KEOqU953+gbZ37XzCtgmRz+2n3bM2zaqCiZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTrw2N7Ce31+SaJE8n41b1EVR0Zlil1GDqAMwx7ZR6IICO3EuBh8DVXz89gZj+AVZYrwxeo4VRgdsQIn7bzu3GQwbPDCVaYLVVIaIqEXbX6oTGKTTtTn4Rmymcz7qr5+neJdQz9MOrVuS4xZhkyxxZT5//fUI/mT9m0yRomr8Bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2evXGuiO; arc=fail smtp.client-ip=40.93.198.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSdEJUDJPYcJdFlVyomXI6RjRvm4B95u3hfMFd7RkEyKNGhkz5G8rj10mmGAOfCAFWw69Skr1effKVHqZ2zpAUHiBRF0Y/AOLVA7DsCGvkscD2oSpXh5ag/xeXoVAVE5rKuy9jbOBWmFMTJS760cgDD+jwkhf72s7tMewCWVI+dFpSPoZrH8mHuqQMaacJ12eE/pMv6U2gl0XRCxCgiqAbkr3BdeY7NodkZdIjDZxMS08yr+PAu3yAq+YQM8xYfyXALIoT3FSK6F+iW6pQNQGVGZutKrCnqwrmsP1Sy+MkQGhUsE7YPNCsuDe3MeGU1Cns9+/a+gR2FYe5INEEe+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8R6BVjSDZP6lhstmdFD8xZnLsbVMFiBgo3iX6PFKJg=;
 b=L0yvaaik8ZZWvefM9QVdImU1yBmn6X13Sa1aduI/4e+MSKBgjI8KIHQrlN5MqyuSatqsYUr//nDOctvnUsyJ2ML7e/R7EOniTAsvAgjeiS1CDEMm26gWLkJW80W8XsClcMalCy1iXmfTHLRai6WjTko5kbmFDAv9falaKJUj3Y+xYdYBS5JUR+syDfDKCuZamO4Wz8bHm4m9ZH+Tr6ZFD3EwOUA3W/MMAY793t6qdadIVJ3r46j3DVKe95m8X0d/XErF8frtPihDvIXFPPt4Ki6Vo5C5kKAj6y6ej2SJQ3KPWENn1pp9tpOUlonLKs30G/9GGxieNIPMaf4Qo4Jjcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8R6BVjSDZP6lhstmdFD8xZnLsbVMFiBgo3iX6PFKJg=;
 b=2evXGuiOFx8kAbo4rEQghn7q4DfpOrTjzN2t1WLyPbZGUHraHDp10RVU3o5PGj0zKH8CEj36n8s8bTBaCtZoytT4DT+hoZkOvKSFTI2hMILgo/uclXeLQf/V85q//iyJ4Qjc6F1ZGsJOgSEBKtRO8iyTXvCQ7Q/c0hz8trToK6c=
Received: from BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21) by
 IA0PR12MB8932.namprd12.prod.outlook.com (2603:10b6:208:492::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:37:47 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:208:71:cafe::2f) by BL0PR01CA0008.outlook.office365.com
 (2603:10b6:208:71::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.13 via Frontend Transport; Fri,
 21 Nov 2025 08:37:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:37:47 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:37:44 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 4/5] i386: Add Bus Lock Detect support
Date: Fri, 21 Nov 2025 08:34:51 +0000
Message-ID: <20251121083452.429261-5-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121083452.429261-1-shivansh.dhiman@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: 407bcec0-b86a-4d27-96e4-08de28d93fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RpM065m7BHYvTgzB77PVxapBkS1YERvooB9XZ/T9NsykhERKn96isHv7hpDk?=
 =?us-ascii?Q?w5wwom4LajYfQlMQnJW+87SXx/eW9Z4ZDRbWGXLJRzWy1tqHz/0W+fJbIckP?=
 =?us-ascii?Q?ssasocZk8P4A8TjGV7KSbPncogarPu0lnVd6BEwk3+US0WjTIFMQR5DZwVXU?=
 =?us-ascii?Q?xZt2sJ5H6yiHgNzEHFqVKUvXadae+TMPWEC0xa6pz6jNHnMyEl7vxJweXoNE?=
 =?us-ascii?Q?lJuLctp8FYPfT7nx9s4y7/oqQugOwJfQ/Qul11Mxdiq9wEHwRjzZrgMmOmr3?=
 =?us-ascii?Q?uV/81P2Lg5ZA8akTgAk5gB1HT0UKivkYgp6UnHKZBUipAxv4xC+kQo4sYE/d?=
 =?us-ascii?Q?cDv/KaihVPyEUc9DroQTLxQEfCULDnI7FrVsl3wBLijB03CIEJRRnIkECFeh?=
 =?us-ascii?Q?R4LITA9Cn+3rJ5NYuVfeHnLeJTfXWCe9wnPuwVqCaxjvNTBJAJEOP8KJjkGs?=
 =?us-ascii?Q?tmXhdBNULAZrs1hTa4K6o5zThA8IQasE3eQORZumtHqpWr2toLSAR787M9Pw?=
 =?us-ascii?Q?xV9E3iJK7crCm6+ufW5OmSIGoNYfQLHIW4FfGyoXmMTN9YGIo0AWc0U2P0ze?=
 =?us-ascii?Q?a0P7x/MoEHeq4/s+Wd9ZvlzfEFdBeMGCRop91U+Vxvf6Ry9swAspFxOeDTkF?=
 =?us-ascii?Q?/tZy/hXLRRFaxpUI/JhgG7UWb1Fs1LvpOKW7Cz2aolEOtCBKXmuQsMHoifoI?=
 =?us-ascii?Q?dYp+3HYYAa9keAFd2A+KlnPlbgz1d8O+31bvGWddZgcyqYgpviTYmMSDs1MW?=
 =?us-ascii?Q?2ZNw31qKxE+Y2r10WzFHeOxWbip4GLnjUq64bo1RaYiSy3C9E1DVD+UoyIkm?=
 =?us-ascii?Q?cp3izsl6VHZ6Km1MyjRylODGACQk1tJ0RrXSJUIem+6/GQbPwkKymSJ0tVDP?=
 =?us-ascii?Q?7pD3n1wLY6EohnvbBnnomveI16MYU7iyDFfwx8GdQmPniZTRWVIL52V3MFDL?=
 =?us-ascii?Q?glQleUk58SCx7/bOFXXhppv4vR9jFFplAN4qIEYzullqwSlW+Nxk8zyn8eDr?=
 =?us-ascii?Q?U8c5RlU1J1pts2UFULcZ0SkOMr9f2uas8Gvbzh+cm0J7vQS9uCKuZuBz6PYr?=
 =?us-ascii?Q?F/i1cEpHtmUM4GaW4AQXqjqeMvL0YT8YRKZOK6WzhK7yh1OFE1G425fg+Esu?=
 =?us-ascii?Q?ljcTcR9XYkFOdszRz/PCujpyGuFQaIjQ3eA3ezBlBq+kmFXwsIHCKw0+A/pr?=
 =?us-ascii?Q?iUoCyj0UAWi+U9Ix+Bf37zyvuVWg7cXLLZe1rW4FoImlr8PcVNdO7oj0TiZ6?=
 =?us-ascii?Q?cvr80hot4eoNJVjPViEEeFpFsQEfjJ3h5IlV2R36aBVA5aVcELnPu7sqQmAG?=
 =?us-ascii?Q?eTn85kJztYICnwmc6xScniWbgkRLBa9r1SZYaO2DB3d+tZIJNT5vTV38ApO1?=
 =?us-ascii?Q?0HiCOTGGmNAVXl6M8y8TzwOLvCrbI8hTUBVzx/dVhNEheSxRPwbiaYfw6nH9?=
 =?us-ascii?Q?J5LU5b0EtZJRpAhZgbbWFrJx+qS7ocw3aCjpYGX7+EHeSz68aI5z3WNmVPEn?=
 =?us-ascii?Q?Q3TqSMxHefl3F3yhTXMbgxF75zIrKSv2XsVNIcDcyQa8FeJO3+x8AuBZJSc1?=
 =?us-ascii?Q?JQG60xBHtEV1CudmUC4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:37:47.4705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 407bcec0-b86a-4d27-96e4-08de28d93fb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Ravi Bangoria <ravi.bangoria@amd.com>

Bus Lock Detect is enumerated with cpuid Fn0000_0007_ECX_x0 
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

Qemu supports remote debugging through host gdb (the "gdbstub" facility)
where some of the remote debugging features like instruction and data
breakpoints relies on the same hardware infrastructure (#DB, DR6 etc.)
that Bus Lock Detect also uses. Instead of handling internally, KVM
forwards #DB to Qemu when remote debugging is ON and #DB is being
intercepted. It's Qemu's responsibility to re-inject the exception to
guest when some of the exception source bits (in DR6) are not being
handled by Qemu remote debug handler. Bus Lock Detect is one such case.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 target/i386/cpu.h     | 1 +
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0fecca26dc4a..852b3a33b54d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -276,6 +276,7 @@ typedef enum X86Seg {
                 | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
                 | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
 
+#define DR6_BLD         (1 << 11)
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
 #define DR6_BT          (1 << 15)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ed3d40bf073e..00c44c2de650 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5864,14 +5864,14 @@ static int kvm_handle_debug(X86CPU *cpu,
     } else if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
         ret = EXCP_DEBUG;
     }
-    if (ret == 0) {
+    if (ret == 0 || !(arch_info->dr6 & DR6_BLD)) {
         cpu_synchronize_state(cs);
         assert(env->exception_nr == -1);
 
         /* pass to guest */
         kvm_queue_exception(env, arch_info->exception,
                             arch_info->exception == EXCP01_DB,
-                            arch_info->dr6);
+                            ret == 0 ? arch_info->dr6 ^ DR6_BLD : DR6_BLD);
         env->has_error_code = 0;
     }
 
-- 
2.43.0


