Return-Path: <kvm+bounces-64082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BEDC77F15
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 235DB34A6EC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9BE334C3E;
	Fri, 21 Nov 2025 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SJ2qbBgp"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010031.outbound.protection.outlook.com [40.93.198.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AC330D42
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714235; cv=fail; b=ir8GGn+mtdBztB4fd2YLH4sOftnEkgF5ol0Fb3MV6hjLdfH5i1OvIqwNb0SFlfx1EYZkTkXgBaYufMLXzKLHbVBSUw5rWQ2a1farLoShRv7Psnrs4XpJZeR53khsWOpqnnzp6SR3Kof8J9KJqZoOkgpStJ7B9C0k7yWfLk1m84Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714235; c=relaxed/simple;
	bh=/EHp4F2lw/qOEYtPyCneD9xx6uF3M53ANpFbEHwdc5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUFJDVyCFVtp4ygMzS3ZUmjlmAhA6lcvs7szB6pC5k/0yUCpaPvvAqbhXTpvOWW8vcuXpYVpjoRsERdKN42EllJlBTlAwTGRObWf9CsULIOg+JKAM3g4wuSrvCMLcBP+IlNub3UlYoOijviXkr1Z9r95W+u8F0171jUU7qn3Nfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SJ2qbBgp; arc=fail smtp.client-ip=40.93.198.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBOpUIQEOunXbH94WaamwHBsAknGT2LGR+5KbIHC2TL0nojayCZxYzqqmBZQn007/OeHd6EBalyFuT5BwQDKohGxfZ6DRxNnT8QiupwsbW7eHglKJa/OE/MT9gtifW5A4E2cR45vB76hdzBPoa6enk+Ncinq8pDudP1hCUM2chm0yVPr9Y8N1oZ1dBvNrCFjD71+vYUN8xh2ZeJYCsrn0gS30NH64zH4pvpMr7R+AS07fPa/yT+nTNfAG4zLudbMaPUuj9b62ycmzRpsOBGuKM52XEXtVb42j8FgF/dgLE7Y8OZAQSsspJbRicwJ5a568V10oJOuWKOGbgF8Aa/WBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G51lSEc6VqjRlnMr8fMP+FY47sjitLjNoVRPZrLeTQQ=;
 b=LWGjiUOBx/Iwe+caIyVO+89YCkwgpdmz8YODCSmHlrEUGsAMAslsbzi70lGlLzrXsMrc++kKdjCWKPnJ9Y3Af8xWZBzm2EQeIwJ5DqvNWSxk3gJU+KqbBIGWkDL+SelCq/IMR6jUOWjOwRBrT+N+9Iq9YqTZbk5yn6sPY0pjg/+1zSF/Zc7Hz/U+TNlCuv2tPk/b+aZ2ChkYb6Q5pjxJG7zZPq5y3i4dvchKDq9tVWG/cONsFDa/w481UNzxsfZKd9Mkuuxxin8QXN6TW+owtLT1KjfyCjwCvYbcDfmsHN5ZsgylIIuzXPimvbF49OyEiMB/8upehqpTFo/C7kfhLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G51lSEc6VqjRlnMr8fMP+FY47sjitLjNoVRPZrLeTQQ=;
 b=SJ2qbBgpPlqI1pz5sMajRsM24JMrwM/zMPeeiQGC1tgQ5wz5k/5YFH5pMw/iJGupheXAaSylrFfBozj7Enb2Gw7sL59FzAaTPsgXYgffGshRqrFiRPSlHiv8Nc5A/2JYUuz/yxIBPNU3mhlBNfxtOirt2bI3aFkLZ0J9tP3CFYk=
Received: from BL1PR13CA0069.namprd13.prod.outlook.com (2603:10b6:208:2b8::14)
 by PH8PR12MB7230.namprd12.prod.outlook.com (2603:10b6:510:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 08:37:07 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::1d) by BL1PR13CA0069.outlook.office365.com
 (2603:10b6:208:2b8::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Fri,
 21 Nov 2025 08:37:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:37:06 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:37:03 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 2/5] i386: Add CPU property x-force-cpuid-0x80000026
Date: Fri, 21 Nov 2025 08:34:49 +0000
Message-ID: <20251121083452.429261-3-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|PH8PR12MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: 92efa55c-068c-4459-5124-08de28d9278f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/hQN5uhv20Ybqs1GXCS0B4Zx+epvnn56av0BeFTAA7Zmv11Mig+1e0M5bAAX?=
 =?us-ascii?Q?LhMB1MMw5YiRmrpTFiFo+lzf3snbhfGJslRrK6mNPhnCtxfxXoQixhQtQ39m?=
 =?us-ascii?Q?3pdrRASVRjGpCPO7PvnrDFA2/irZY7DkZcqtA94ZBPz4MdzXbiZGIMFCw5st?=
 =?us-ascii?Q?mFPGkS4am+S4uQkxstvMGSqby76GqcmPaqmGWKwE14UhvDJbIYxvtwn80jxc?=
 =?us-ascii?Q?wGFawI19iJo+pG9hpK39GZSss3/LkLexHcIqy5vDdyyHU7RUdWrRDqYCh1Cv?=
 =?us-ascii?Q?m7oWQ8ru52U6MW3j33/a/nYLXFwDVnSnr0su+QhEgQt8ONKcv6QkFn6VW/Lt?=
 =?us-ascii?Q?gw+eK1JigTinNwGv1B8+CTFyTfN00W3eHDyRUEdO0InHF30pEw4/bsIXeQoa?=
 =?us-ascii?Q?eXzVFfqlh7Ra5eSl6/8qRgbjKLeCKLUm4x3mCTaFiyDqstZiIvrBBbW38YuQ?=
 =?us-ascii?Q?5cK+w4G5yoIJnXY2gJpkqJfyS1bs7Kc3k70iEX+iw9U/Q5gMtwdK6srsQDZL?=
 =?us-ascii?Q?4MR6Mn4NeMh5Px4F0IRvWcq3F3zCe8lOkXWYdCiMvvgroZwFSybr3vM2TCtB?=
 =?us-ascii?Q?2YyF22mDxZG77r5wEXDDj8WkQJhGP7KhtZFy3HcHDqL6AfeG02yRmCGdIilp?=
 =?us-ascii?Q?zcPCWusSeCrdrzEblP2TP/skv77MR8yn6G2o0gjnIu1uHCTd0IMbOVk6DB+M?=
 =?us-ascii?Q?ZFk2xl7uwQsufTXjVzFil8BR2kNpIwcPi/3dvNmizBzVSsL5MOkO2EN/fhSm?=
 =?us-ascii?Q?0/m3lyrthopCvda+7vSRGmJqFmVzhvKYMnn8yxD6tnFOc+kwqq4uGKWS0YQZ?=
 =?us-ascii?Q?X2ZhV9ApoY/PvpOLUWSEZB7dfZKm3PeL/AQZgF0frl7ob6vbbaY7Zo5R+M+W?=
 =?us-ascii?Q?yaXfkQx4ivCZHfApim+VL5z4zOLh1n/iXmCFb5Gd+n5dY6I3ptH+e91AMeyA?=
 =?us-ascii?Q?4s5Lcu/30dDh/DdjCiiiXTJjM4sVFTwyeQyj7CODsEpNe6Arg91QSqc0tjWg?=
 =?us-ascii?Q?Bzm1YT1lx6V1wJWC+lNMhpk44YNQ+IZO/7J6IwyRhIkx9cWu7gtRgHA0ubok?=
 =?us-ascii?Q?sdQFeP4XzdIEJzFkbgo+R8l6cPX+pm9d67SfNHCuupfzmHCQuYU+bae8B8QB?=
 =?us-ascii?Q?ZloAAePKSjWdXDXeM9DoghgLEJoZEyIpA/8BclUps8/tZolUJ9tZ+V1Z3WFU?=
 =?us-ascii?Q?g0wTlbV90SS+ZHW29mZHuDSzzG3p/jda0rLrZaXUzMgQUB9oJVII2fYGy3eE?=
 =?us-ascii?Q?hVu9PvGn2CKbXu+ruvDHmaXBtKdgUcvus5Xxb6oe39KMOenplP4c4AKPLhCg?=
 =?us-ascii?Q?TpZYYAY+BWs3s7RVxtm+vtztXFIm1xlqrrpE46zEwELpbzucSyqf0EDTiDPW?=
 =?us-ascii?Q?oWY0O9vfPpR7DjxLTKFDQ/bDjurldeHWMIZeW9Vc2+BbI9TLtCc+f5il7tBD?=
 =?us-ascii?Q?H55eNjgQWCwCqSStG5mkwGiaZ5fVVp/1E9qFgOVTwsNWg3cfdpVP3/UKrV04?=
 =?us-ascii?Q?4MZqEBDaFljap8O8E+Cz+ho8eRymgpKMkbXwgBmdyKOVe16Rf61Jmj3uJp+1?=
 =?us-ascii?Q?XiWkrqOIKC02Fn4DO0U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:37:06.9471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92efa55c-068c-4459-5124-08de28d9278f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7230

Introduce new CPU property x-force-cpuid-0x80000026 using which the CPUID
0x80000026 is enabled. It defaults to false.

If a vCPU's model is host, then CPUID is enabled based on CPU family/model.
Implement x86_is_amd_zen4_or_above() helper to detect Zen4+ CPUs using
family/model.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 target/i386/cpu.c |  8 ++++++++
 target/i386/cpu.h | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b7827e448aa5..01c4da7cf134 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9158,6 +9158,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
         }
+
+        /* Enable CPUID[0x80000026] for AMD Genoa models and above */
+        if (cpu->force_cpuid_0x80000026 ||
+            (!xcc->model && x86_is_amd_zen4_or_above(cpu))) {
+            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000026);
+        }
     }
 
     /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
@@ -10133,6 +10139,8 @@ static const Property x86_cpu_properties[] = {
                      arch_cap_always_on, false),
     DEFINE_PROP_BOOL("x-pdcm-on-even-without-pmu", X86CPU,
                      pdcm_on_even_without_pmu, false),
+    DEFINE_PROP_BOOL("x-force-cpuid-0x80000026", X86CPU, force_cpuid_0x80000026,
+                     false),
 };
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cee1f692a1c3..0fecca26dc4a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2292,6 +2292,9 @@ struct ArchCPU {
     /* Force to enable cpuid 0x1f */
     bool force_cpuid_0x1f;
 
+    /* Force to enable cpuid 0x80000026 */
+    bool force_cpuid_0x80000026;
+
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
@@ -2879,6 +2882,21 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen);
 uint32_t xsave_area_size(uint64_t mask, bool compacted);
 void x86_update_hflags(CPUX86State* env);
 
+static inline bool x86_is_amd_zen4_or_above(X86CPU *cpu)
+{
+    uint32_t family = x86_cpu_family(cpu->env.cpuid_version);
+    uint32_t model = x86_cpu_model(cpu->env.cpuid_version);
+
+    if (!IS_AMD_CPU(&cpu->env) || family < 0x19) {
+        return false;
+    }
+    if (family > 0x19) {
+        return true;
+    }
+    return (model >= 0x10 && model <= 0x1f) ||
+           (model >= 0x60 && model <= 0xaf);
+}
+
 static inline bool hyperv_feat_enabled(X86CPU *cpu, int feat)
 {
     return !!(cpu->hyperv_features & BIT(feat));
-- 
2.43.0


