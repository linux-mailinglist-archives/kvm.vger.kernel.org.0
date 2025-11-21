Return-Path: <kvm+bounces-64081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9054C77F0F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 44852293E0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE1C330D54;
	Fri, 21 Nov 2025 08:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="umNvGlud"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011023.outbound.protection.outlook.com [40.107.208.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FFF28640F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714216; cv=fail; b=l6WHrRyh17OwlyvRvBMJtD8I6OZf6bGJR4iqQ3gSkCE1xHKVKh0Fsc9+Nhy+p3IFEx3HidxCIB5t6zm+Rnek++bUO/ILOQydNSSmjXuOMHaAVb09pHUxuOcKgvM4VEbFXBya0ZvnO1GGZwPTB+Z0nrsflQBFbtGWkuXGJqlNU3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714216; c=relaxed/simple;
	bh=vq45yZ+ty9ofQlV94Xjd1R6HbK5CmaR0DhFp0km3vUI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Poh8q4fWuSAnIgfdDsj4gpG9BpGcLVTPJ7LoBAYbDoD4S7GToajfEtFGdS0Xm6CzydVqwLTKRHoITyMhXGvioiDBI0qJKHMNce2k7o8fgSZ8ZiP9kKCLbWadCOTBZSXjZZH7oxnR1QOl2xtSqiSDCWN77zq+bcy2gVRnXYiuAxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=umNvGlud; arc=fail smtp.client-ip=40.107.208.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkr0TbeeJDeizRG9jmWihDp1vvP8ICYDvHoFSv9DplMWpXARFfu+nTgWHd/AMrfwM20AxFPcqwQXR+nyz7um/J1m92KoxymwDrCZHtlF3mLcdIW8IByzITg8fth5VCdUCOySBgNCNhSDyJH0cRvo1Nmp9f2GjdP6+EwIEeHdZ/qgMTSfj2oIwwx+C6kFGKJqOh1X8FhyAx8BNmRg+8qZ+9hXagu8/jk1ghxnKceQxuAm9yFT81+wWG6OIxkTznEA93kHBLJumTRZUQSOGlCiL2SUT95J842XWlJ8+dmfnptIC0rR98CqsyKT+xfpBPuleZg2qJLeAcTRdFXoGGyjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deJyHN+Z8DoZzHVeFyoB0co5whkZUqI2937I3WDC2WE=;
 b=TFj4h8GNqGr63psKWFLQVnXfEA3IBWhKqianh0ICOaABBXnehZ2TbHKaXOK5rfVSZ+cRNaiH68fCzyJT/33gMT+EAgUIhAt1Amg05PTVQJXm2v7GY2t5DmzLahZu1yltSR3uTF6NbbR+izdIUD4Cm7BncaqcIGXCLYSp1cYXeAg/qIbqxr1oVLamQD1h11sF2RRg5doVg75CMHacqj1uMVBbeh8tlWFUwyY3damqAChP8080snHUDCrxAcMkNVfVaqReAROiHOIyfyxm4BrqrMsY6PDhIUdZMnb9fH1XSMPfEnT2jWGIdMgiLZlTwbloYfVwTxnJ45/x74qNNt2CMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deJyHN+Z8DoZzHVeFyoB0co5whkZUqI2937I3WDC2WE=;
 b=umNvGludCGkv5RKkijNqgF2aFxrz/uJEp4y1ekrkKd8YZRFygPAkHhHyzNDM3RGgXImoy16tBLFZZOmFpkGt7YAj/VM/5Z339raeE75oczkCSxKd7zowlcz4NzrQsTbdLXRrVNSVaUHNgSGs4bUib1WcuU5j/itVpeiLqFXtS0Q=
Received: from BN1PR12CA0007.namprd12.prod.outlook.com (2603:10b6:408:e1::12)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:36:47 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::75) by BN1PR12CA0007.outlook.office365.com
 (2603:10b6:408:e1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:36:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:36:47 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:36:44 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 1/5] i386: Implement CPUID 0x80000026
Date: Fri, 21 Nov 2025 08:34:48 +0000
Message-ID: <20251121083452.429261-2-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 0039a8e8-09ec-45f9-d75a-08de28d91bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jNU0GnnymknY3qPymtL6zeNCYtDO2Rk09Z2szYowIh83KZT+tnaOyecLUcPJ?=
 =?us-ascii?Q?tDizthjR8rpjAqwKvyYAz+HorRYX89L/9V1izR0FCd0uxhzRNdJEvftIg+lH?=
 =?us-ascii?Q?IPzFNofSkz8lA+7unMLEg0FnSgTcpXj5wZ4fVZJ+YdgexAt31S1xVUuPGO+t?=
 =?us-ascii?Q?Xz2UXApT7YFdVTHpxBvgwv3om5LoPSxxQdmS9pxBxrjyAeKrseJR0rVZjmS3?=
 =?us-ascii?Q?3hRIqpo7Wyx/6tFcWs4bOAB2jYKEoZuywKqE2sUOJ9ZCcMyWScZJgjDs1Fz/?=
 =?us-ascii?Q?lGvT+7X4iKERUwcWQx+hrnoOIH2FeDz9i5bCEhpdYH7t+HDfxqao0dHFxLFp?=
 =?us-ascii?Q?kcpWQgDe9niHh29jZ52q9tmKP4R+9BRDvRYOrs2E/SsYS9YKx2on0ZesTOZN?=
 =?us-ascii?Q?HPkhAYXxNNnxUG7fbkUp+GB1bxaPb75GI4Owmuy5T8Eq36yH8NU37m1Mnob6?=
 =?us-ascii?Q?QyHYT/PsiIAMr3TwyabKh39PeChCdyBZQdGmhE1BEatItQ15b2iT0McAdRGb?=
 =?us-ascii?Q?KI7P9lrbClqJJDc5PvAlKlPv/UrpRlc/Gqdk4CdK7dcgHoQkQnGLPe8S0A1R?=
 =?us-ascii?Q?B9eLYzUApIlNhA4oqDC1euG5Ayh/+Q5Iau660DUGdUlSp8isoEI9fGN7ANSF?=
 =?us-ascii?Q?KJSOYa8vNybk/5DDJEIvuJUyD0de+dQ0dS9joD29LgThAoa21nBKsgnMy5Lb?=
 =?us-ascii?Q?rLzLJh5fcZ27Owm0bl/XJ0RWN15j+dmO0nmiQzIygNauBXzd8HbN93mQA7i3?=
 =?us-ascii?Q?C0s4FbFF4h8hntnKgmNjUEym6kA2bZLY4ntBpDWtkKmwULgGAK3Nrv9IVTva?=
 =?us-ascii?Q?7Qva67es7z1FpIIw0tsKxoe79mC2Wuz/LisSHoJ2oGgP+KxEVuM2XOOJbo+c?=
 =?us-ascii?Q?5glLC+6qTPdzLJGko0d/njxcOVBK1V5EkX7UUYEdzKOCuylRWq6KJlYjY45+?=
 =?us-ascii?Q?FyLeUsArn7LYwVL3x+VLOv1co8mCTK7CH/u6ov9suRra2BqEmVTCcqF3Qx4P?=
 =?us-ascii?Q?4TRgF6pc3TJBQ5BY+NgRqRPXPMtbq/bllVwMeucJkup7ikpihAOaXdFw5Xxs?=
 =?us-ascii?Q?youk5fZaXsXrg6WGHCMLAG+3fz2l2pfb1KEKiH6d/Bt175L8qIC3DMcdoZLw?=
 =?us-ascii?Q?4KL4xGt+DvdusgNQCt7whNY8vyYGADq6gxMOt7ignXnsvarFuTScANt4yAM+?=
 =?us-ascii?Q?rC2d2A+Njpcrqb01M3xr0bgRy9AyjI5sEWpd3Ml1e0Rw6PbsqOU0IEnP61f7?=
 =?us-ascii?Q?KcEWlSOWCoNCmAsdVaEM6QXCjGlNpj/cN4NXDMwTMKMGyiTrreSkuGeDHAqV?=
 =?us-ascii?Q?ihjELYuEVjn3U1vVKg8v35tyjBiQKuAQOUM9Cb1aYt2P4mIgUoS9D+JoX1Gz?=
 =?us-ascii?Q?J+KcWrsMC3T+LsnA55LppXWVuSMjd8ZeC404FP+JE6090xurZyO5COwIWN0Z?=
 =?us-ascii?Q?v1WPRuqB8NOCA1G3lKwV5jeQQifYFg71f6a0JupeKFw6GBOlQ+6o6pNxQu9i?=
 =?us-ascii?Q?G/tDzcKJzziVfAXTGfnuRj5V2ZXvMEEJd3X+qrGGFppK1nSpb5vtAQEKGjO1?=
 =?us-ascii?Q?409Dt7fjWPJEh3GkyMA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:36:47.1799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0039a8e8-09ec-45f9-d75a-08de28d91bc6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770

Implement CPUID leaf 0x80000026 (AMD Extended CPU Topology). It presents the
complete topology information to guests via a single CPUID with multiple
subleafs, each describing a specific hierarchy level, viz. core, complex,
die, socket.

Note that complex/CCX level relates to "die" in QEMU, and die/CCD level is
not supported in QEMU yet. Hence, use CCX at CCD level until diegroups are
implemented.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 target/i386/cpu.c     | 76 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c | 17 ++++++++++
 2 files changed, 93 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 641777578637..b7827e448aa5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -495,6 +495,78 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
     assert(!(*eax & ~0x1f));
 }
 
+/*
+ * CPUID_Fn80000026: Extended CPU Topology
+ *
+ * EAX Bits Description
+ * 31:5 Reserved
+ *  4:0 Number of bits to shift Extended APIC ID right to get a unique
+ *      topology ID of the current hierarchy level.
+ *
+ * EBX Bits Description
+ * 31:16 Reserved
+ * 15:0  Number of logical processors at the current hierarchy level.
+ *
+ * ECX Bits Description
+ * 31:16 Reserved
+ * 15:8  Level Type. Values:
+ *       Value   Description
+ *       0h      Reserved
+ *       1h      Core
+ *       2h      Complex
+ *       3h      Die
+ *       4h      Socket
+ *       FFh-05h Reserved
+ * 7:0   Input ECX
+ *
+ * EDX Bits Description
+ * 31:0 Extended APIC ID of the logical processor
+ */
+static void encode_topo_cpuid80000026(CPUX86State *env, uint32_t count,
+                                X86CPUTopoInfo *topo_info,
+                                uint32_t *eax, uint32_t *ebx,
+                                uint32_t *ecx, uint32_t *edx)
+{
+    X86CPU *cpu = env_archcpu(env);
+    uint32_t shift, nr_logproc, lvl_type;
+
+    switch (count) {
+    case 0:
+        shift = apicid_core_offset(topo_info);
+        nr_logproc = num_threads_by_topo_level(topo_info, CPU_TOPOLOGY_LEVEL_CORE);
+        lvl_type = 1;
+        break;
+
+    case 1:
+        shift = apicid_die_offset(topo_info);
+        nr_logproc = num_threads_by_topo_level(topo_info, CPU_TOPOLOGY_LEVEL_DIE);
+        lvl_type = 2;
+        break;
+
+    case 2:
+        shift = apicid_die_offset(topo_info);
+        nr_logproc = num_threads_by_topo_level(topo_info, CPU_TOPOLOGY_LEVEL_DIE);
+        lvl_type = 3;
+        break;
+
+    case 3:
+        shift = apicid_pkg_offset(topo_info);
+        nr_logproc = num_threads_by_topo_level(topo_info, CPU_TOPOLOGY_LEVEL_SOCKET);
+        lvl_type = 4;
+        break;
+
+    default:
+        shift = 0;
+        nr_logproc = 0;
+        lvl_type = 0;
+    }
+
+    *eax = shift & 0x1F;
+    *ebx = nr_logproc;
+    *ecx = ((lvl_type & 0xFF) << 8) | (count & 0xFF);
+    *edx = cpu->apic_id;
+}
+
 /* Encode cache info for CPUID[0x80000005].ECX or CPUID[0x80000005].EDX */
 static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 {
@@ -8554,6 +8626,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                                                  R_EBX) & 0xf;
         }
         break;
+    case 0x80000026:
+        /* AMD Extended CPU Topology */
+        encode_topo_cpuid80000026(env, count, topo_info, eax, ebx, ecx, edx);
+        break;
     case 0xC0000000:
         *eax = env->cpuid_xlevel2;
         *ebx = 0;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 60c798113823..ed3d40bf073e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2037,6 +2037,23 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
                 c = &entries[cpuid_i++];
             }
             break;
+        case 0x80000026:
+            /* Query for all AMD extended topology information leaves */
+            for (j = 0; ; j++) {
+                c->function = i;
+                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                c->index = j;
+                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
+
+                if (((c->ecx >> 8) & 0xFF) == 0) {
+                    break;
+                }
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    goto full;
+                }
+                c = &entries[cpuid_i++];
+            }
+            break;
         default:
             c->function = i;
             c->flags = 0;
-- 
2.43.0


