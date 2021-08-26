Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9443F90B0
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhHZW2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:01 -0400
Received: from mail-dm6nam11hn2239.outbound.protection.outlook.com ([52.100.172.239]:3008
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243752AbhHZW16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:27:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mX2QD2Hau4qzjDM7GbJVxmTk9cfjvHyF+//UhG/meW15/m/bnxM3wrfz1osYyrMQo76yOO2YOm1nn9pfCEdgKRQESEasPIolh7KLAMi2qBhI21HEK8VapSfKjzx6ix0larthqD8A4Z+b0vlYzgXrGqB+41OWVY5EWsIfBBC2Y5gnLgWvVXitfsfiRws1J94150kVf2KKA81RHim3svbvdLj6LunCx2JP57Tfrwd52BiQ79OyVNQFTWsU0JzkHciuvoaiQLAZu54hvytlPYRFqDhoNHvP52mW8dqD4OlpuP3n7pUghmqmZty6C8AK5i+zGowYRoLnRg1oXLCHJJxiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptkfNS7CJnmRZOVylvDJ4BEuceFQJsPgNWd50EsnjsI=;
 b=HB1yYBZkP+Z/B08dYDG7HncIxecaKrgO21FxPu+PgBrYFq3x4kqK+k23COL/db77uXlsgX4tq9iAwvC52M8FTLsGGC2JhZDdu9eCkxqpe0sMvxyGLuyMv1lFBnSpiMnPJ8paW8/dyv6+AAG15HCMm9zBCoghCU/556vIrNAXu1qtY+nLKcBEg2rOwrHHSBSnb1QXKX2PB3gH1+L56X26ecCaCc3etfJhI9aac0MXGsNWZsN0DS7S9CYVxx+3Jp2hen+YU1TUbN5cSj9mTTceScxv5qiT+wilJIGvQYPIku9sg7j11DxaIJNmEOAHmpxYes2WpsK2NkYdfb1/IGC18g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptkfNS7CJnmRZOVylvDJ4BEuceFQJsPgNWd50EsnjsI=;
 b=bV2HmFT+wureybpabzmOos2VNiZA/7etMaI+rySIt6Q5FzN4SuSVyrGECFsKerERNEgpyQpHKjL7Atyg0TJd0ezbg7fr56+V/nizlXsBN2W5L5wsnPRmzTYAltXZII9+/HP7QxQxUykXazhQomdXXJywiN3yU1GxfXXwL1YqPtQ=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 22:27:09 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:09 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 10/12] target/i386: add new EPYC CPU versions with updated cache_info
Date:   Thu, 26 Aug 2021 17:26:25 -0500
Message-Id: <20210826222627.3556-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:806:f2::12) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SN7PR04CA0007.namprd04.prod.outlook.com (2603:10b6:806:f2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:27:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcb9eccd-bd82-463e-bf05-08d968e0a454
X-MS-TrafficTypeDiagnostic: CH2PR12MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4293588B896926DEC7481B0595C79@CH2PR12MB4293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r5wARpzZVzGw0zxLE02RRcqvRhuUg2ffkQFGmhFoiF+Z/OFT8rOBynRKzcs0?=
 =?us-ascii?Q?dzrSW/d54LG6C8ZaQhly+wulw+Sg/z2I1zjQncZApkHENhn3Vx+eA2ULPxP7?=
 =?us-ascii?Q?WMf85sUh742kxt45F3bp8XAA7rLlADsI6ePbmn182dgsqb2zP/zhcJQo4oW5?=
 =?us-ascii?Q?etOSMSanIy29+VIuxWJasFexNVXr7OrG+uTit38I2Gi6Tnvu93xiUlZ3NlZk?=
 =?us-ascii?Q?3vF83OGVTWNTS0J/MYaDpd2Fz5LJo2yax7ZUMEUaDLiObIuKKHYNUhliqiPe?=
 =?us-ascii?Q?qIidH5K7O7FRmxBGfhbzkYGMkDYFVlfNPU7jTg/3WjL9r7CZwQSRtIp00ZVk?=
 =?us-ascii?Q?kMTjV79sxC4CgNrBozh2uysQ1lPBw6Mgd88LRIfKj4DVRyhLrTlATJ8M7Ehw?=
 =?us-ascii?Q?NtwnNUaRcs3hCCxPi9eGjofdEJF1/5vL7wi6wBNKPXpLA5LHEtiyDxWhST5P?=
 =?us-ascii?Q?qBDtlWxdIVFdVRx2GjOOH40JvtjR1LB4pRdj+L7LnZ7XC1iarVlFZWRTbBYD?=
 =?us-ascii?Q?x7vtbOBIDtv0ESWxF2/fE8Tv0DdDIsDH318u8Om9k5SdOowm12N+ZnST/AAY?=
 =?us-ascii?Q?c21Iq9vldXcEWmAWIeI+KEfBieAySeFj1JLNzcKyW0L0igMFx2LE76voIM5z?=
 =?us-ascii?Q?5zbTqcbYSSCBeoSoiPRibHo6DTwUB4QVu8PKoxlpGxMI0nuSswYEFjQom9L2?=
 =?us-ascii?Q?KfCjq2I4VvVqlZbkCKh1EdCZwdyCDHTZulOMcxZ/+klTe3LH6b/4Usa+aSt+?=
 =?us-ascii?Q?2cI0Cu0xZmfj5S5VSj8jBOLqll37KTBKsIzhLQ6Y6D+0rxv9bFyGy0gePnkE?=
 =?us-ascii?Q?2PUWqOGougo8yw1v6BiG4hdTdOU1IVHaHNc55Qzz72buTWwEOaHpn4KEcd5f?=
 =?us-ascii?Q?J6qzpHaGFnXLKr6PoIZ8DO5rlmwW2nf+4h5PqJAGqBIYOcfhsm72NgXFNd6j?=
 =?us-ascii?Q?cWG6dnQ53qks1/5CT9QwIgqWurAzTYH7jvH996NSslSFoujivqggt6AqJmZa?=
 =?us-ascii?Q?/s4ifI2oXDgT/cnYhhecVLi4/vQLUAafTUEby08JiGvBqAk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(38100700002)(38350700002)(508600001)(6916009)(54906003)(15650500001)(66556008)(66476007)(1076003)(2906002)(5660300002)(6496006)(8936002)(52116002)(86362001)(316002)(186003)(6486002)(6666004)(2616005)(4326008)(26005)(83380400001)(66946007)(36756003)(44832011)(956004)(8676002)(7416002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T3bcylOwBB5V46Zc+kSDzBH69jx1gHsRD2jK9aCNyVVaMwyX0/v2Gk0whulq?=
 =?us-ascii?Q?wIIf12LVQNwFvuA0yChPoYlDzZ+JxVEdMbGC0RKXB2etR3LnkjfvqAlWgA4S?=
 =?us-ascii?Q?iXxzUlXSjQFW2qwTCfPiF/Nqf3JFleSab0ygPVgUqxt2NKFvEsJQDLIhkp+A?=
 =?us-ascii?Q?HqXlwlb+NLNgLeGoKIR9UoLPHwoYpsq0diXAWHTA82YtoeZ9aLN31MUdSuza?=
 =?us-ascii?Q?irnP7ldVUK3w8PbXQc2pLssB+fho1vgCb9sDEguThaHNhHBXQ/9z4EkjD6p+?=
 =?us-ascii?Q?cHjYNXtiFmI41UOhm17PMbWbVAOGhdxUWWqUZ6VnDMxcS3qOf1N0XijaY4xv?=
 =?us-ascii?Q?FDCUzi8Dkk2B/hA3Z/IgrT6RVXiw6EYfYQsHlPwimYJr3r3cGUmwV6jy0ka5?=
 =?us-ascii?Q?MQyPzmWXsDLhZGc2C+Cg8di7wliAbjIlAcezRpbbbEFAMX/wYUfwPvs+6Aub?=
 =?us-ascii?Q?myOrATU0c5jhioTH3RDgHvOox4HrlFRH744ovAMlY+E7KKXPTlDYotXiNbJm?=
 =?us-ascii?Q?L0i091pNI394M83WkLj4KED/h2H1lmmAGwQJFEz3+kYy/2Q1Owc7fRxipp5d?=
 =?us-ascii?Q?oUoW/G1eyJOIRzmbjBoG+cHcX9Hlum3KNAiqANfI34NuNZVyrrmwCP2u2ifR?=
 =?us-ascii?Q?cIqXM00wJr2P6sczjsfro1cozOylCz8KAKGhzTTHiLkiiTA4GMl85z6jmkwS?=
 =?us-ascii?Q?RVSkxpKnVmQ4zAd0GEL0jeyYgaL4MUvUs7YOLrd7MyBh4jjoPpXz42sIDiib?=
 =?us-ascii?Q?Ny1iejCPqJhMzbuNsNHUnoh+gfAiywtSyt7thblAiB8HTUPK9KuIsefdmRbf?=
 =?us-ascii?Q?m7uH9dlEdARf6RwG6HF74wg0H0zSIverSHIU8sgaRmkE8i9EnnyGL0smLpLF?=
 =?us-ascii?Q?HEqG6X2Ly9ixc8Zd09USrXq9+YtqylT1U1E+unvubskHl20VZJvXb6wiUmVe?=
 =?us-ascii?Q?zs9dhNvNNMMuyPAEggSSO2nKLFiwkYMhCEXmzc/iITV1L4GpwLCOtybLBS9b?=
 =?us-ascii?Q?iIZIoFlLWUJtc+3g4/KdXU56LYNgDZDkWWIUlt5guFiJcqfc6VVBpXNOIGku?=
 =?us-ascii?Q?mtqTXwAV7rWlBJQbD0gZ+PCmMXfzxkWHBjqfDK6HTsGau4tl4CAey/U66Td/?=
 =?us-ascii?Q?0G0adICnyxaB/xgBhlHXS9NPCW/k12XQmJ/o2d8Hmno8m7AcOKY2b9AdQ70o?=
 =?us-ascii?Q?f/zLfg0sm/Mtbr4EclVhFLPRJowgAYtXyOEYcV5o8IrouXTAJEzafErozTV7?=
 =?us-ascii?Q?qbph7G/kPd0iEISJe0CLO1eHgCm4yjxX5zg6jQ/4Rk2K2JC0jQnHojktLMEu?=
 =?us-ascii?Q?tOEN5DwyWPgF1poM4iuNM0BI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb9eccd-bd82-463e-bf05-08d968e0a454
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:08.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJ7/4YncYxyzXJQXPrtTF0KRzbL1P9tP5NOm1WNeblaavTBxTyPgLkZbBzIC9xD8PDtMVO8MACL3ueYIqXw9Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces new EPYC cpu versions: EPYC-v4, EPYC-Rome-v3,
and EPYC-Milan-v2. The only difference vs. older models is an updated
cache_info with the 'complex_indexing' bit unset, since this bit is
not currently defined for AMD and may cause problems should it be used
for something else in the future. Setting this bit will also cause
CPUID validation failures when running SEV-SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/cpu.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 85d387163a..45e456b557 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1567,6 +1567,56 @@ static const CPUCaches epyc_cache_info = {
     },
 };
 
+static CPUCaches epyc_v4_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .line_size = 64,
+        .associativity = 4,
+        .partitions = 1,
+        .sets = 256,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 8 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 8192,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 static const CPUCaches epyc_rome_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -1617,6 +1667,56 @@ static const CPUCaches epyc_rome_cache_info = {
     },
 };
 
+static const CPUCaches epyc_rome_v3_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 16384,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 static const CPUCaches epyc_milan_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -1667,6 +1767,56 @@ static const CPUCaches epyc_milan_cache_info = {
     },
 };
 
+static const CPUCaches epyc_milan_v2_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 32 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 32768,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -3935,6 +4085,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 }
             },
+            {
+                .version = 4,
+                .note = "compatible with SEV-SNP CPUID enforcement",
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-v4 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_v4_cache_info
+            },
             { /* end of list */ }
         }
     },
@@ -4054,6 +4214,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 }
             },
+            {
+                .version = 3,
+                .note = "compatible with SEV-SNP CPUID enforcement",
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-Rome-v3 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_rome_v3_cache_info
+            },
             { /* end of list */ }
         }
     },
@@ -4111,6 +4281,20 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x8000001E,
         .model_id = "AMD EPYC-Milan Processor",
         .cache_info = &epyc_milan_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            {   .version = 1 },
+            {
+                .version = 2,
+                .note = "compatible with SEV-SNP CPUID enforcement",
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-Milan-v2 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_milan_v2_cache_info
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.25.1

