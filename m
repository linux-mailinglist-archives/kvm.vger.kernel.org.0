Return-Path: <kvm+bounces-5480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3D1822570
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87D9EB20F1B
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535D317745;
	Tue,  2 Jan 2024 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ch71h+Fw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3317732
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 23:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yfhc/zOK33h/lCCpUSwA+UahsUivuNpge+Bc02+eAGuNFsGkebxyuYyzlR2N6GwlyKGoecrGJ3Ad5afNS6F35XKewSbO3Tua/QVfb6YToSc6VzXEmSyIv3+2ua476oLubBnKFOTta81OXqtbI1Ze7RIlJmADm3I0ZOEsI8KGpoiVRjB1MDVzJk64YsfOTJYvHIU5/RzoFS/e7y1nseDocz6SKXw3nparDOoYXfCSLo45IoZT9vjEwWvPmyjdJpgBSNTKDyvGuw351rqQFkcyyW4CY7z0vnh2B9srlpSeDqRzr8ZGFRx6cYI81a7vdwfyww8DVWSQITqeQVcd4N8mfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WynkN7U2JmduBf8YTYAa+Wx7B0uuUTbhGBXJc1kBmUc=;
 b=maydPzkIx4FGc/2q++e9ksT8HkUY1/9NULGM03epBD971znLgQFoDJgRMpHxBXTsN/+nysja4vs/bVaclW0nhukZ2IBfQyJQYxJP9ZXxN8290eft3RIRJrjY3s7pAXIovckeq2WDTfIC1YcTTgKrM84eXgfiw+y1p0ds9l+Pbg1bgJ3aA7zhqTFfiCo7SxPmpE5dsD2flaJR7f7BdL2Ex3XpmqzeVDwEL/WAEkMr0fTCTXAfblHB0Ef7/i5FNb09fGGPQlDeg49wOumwa/FKzFOUHoCRUE4tVk557hGr5bmVSGCmRDaS5+D0y4rxmoJjFp9jCt3O3WrDcWwMUYH0Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WynkN7U2JmduBf8YTYAa+Wx7B0uuUTbhGBXJc1kBmUc=;
 b=ch71h+Fw/IL8vuZiYoTMoSPhexcp8yeRQu/Uw3AhepA924Y1LmKQepZKsOIoqDhhGt2/wZpZEcKPy9jiJDNDZ2E781gfomyrZ9JhZlx7ThPsD78DDA8T2FtqtVCikS6r00vZKQLAAoIPBJO4kEYgvguBMFwj4GvuX6hMjYQ0GZg=
Received: from DS7PR03CA0017.namprd03.prod.outlook.com (2603:10b6:5:3b8::22)
 by IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Tue, 2 Jan
 2024 23:17:55 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::d) by DS7PR03CA0017.outlook.office365.com
 (2603:10b6:5:3b8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25 via Frontend
 Transport; Tue, 2 Jan 2024 23:17:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Tue, 2 Jan 2024 23:17:55 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 2 Jan
 2024 17:17:54 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC: <babu.moger@amd.com>, <weijiang.yang@intel.com>, <philmd@linaro.org>,
	<dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
	<qemu-devel@nongnu.org>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<mst@redhat.com>, <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
	<jing2.liu@intel.com>, <vkuznets@redhat.com>, <michael.roth@amd.com>,
	<wei.huang2@amd.com>, <berrange@redhat.com>, <bdas@redhat.com>
Subject: [PATCH v2] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Date: Tue, 2 Jan 2024 17:17:38 -0600
Message-ID: <20240102231738.46553-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e87214f-5b09-4b35-daa0-08dc0be90d00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WPnmAwBOHhdn04eGPevDrw2QlJgk5wkZmnGzBL5U3w3vgQfalLCSnvj/6vK4hsHys5a+40cS1eCRZ/nyO5SbLWR8dz+zEcnUANFZCdF+ou42KBGEtDH0PgXARgBVeTFWo81NzBtDFRpzIsAJk2JSypbJKwYugbjfk7w/GDcbpePv5bFMEXg4efGTUcensB77g9bu8U+N7H3BxG5QaWUXQX+ruAQ2NKg+YheL3X/srzEWvYJm8HgNxdvuyj1jKT5RWhP8hP/mjqw+9VeDjr7BN+Cl7KtyZP18BrbUKU7TSRHlxXzcbVdef4o7vXAzMRUzQIcjuUAft12P55J1Tqwmpctf2VKZmMz1ryPVoCQGuSPqTiKjJClJyMfDLEIEZBEpoFQu22cLsweXjPzcuSPaGcFIG1WGunvzycEGvcQynTySQwt+/sXINjwiCNBmP+U8neiL7ZHBSSK9k3Zys0oJVoaGtjXFRj/tByt1I/JZkkXxT7lWdKkwnjQR8VLM88ULkviml9T5IkAG+XQ/CxlSq4+dhiW8nX2KCQdr9X+jHqOwXCEv0bYhwV6crpadg/DAdrkMPizaXBLt8Q8/r9RlTobU7i7SeF+icW2aWIZEdbaw2VCbOV63eEGRqChsepF6PEH0EIqbmB+pcUC6M47qwtbLekBZyTFUrq5qKq8fMuGJLiTsuAYJ9WCRU07rGlzNX6SmO5GtAPNi5/Yjv7oPFSowuGugkfh264ohnQ3yMg5FciNTQ3vVoRiqL9sRXiQkAauGVAOUAm70iOAN5LEN9g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(376002)(396003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(36756003)(40480700001)(40460700003)(70206006)(70586007)(86362001)(336012)(16526019)(81166007)(356005)(82740400003)(1076003)(5660300002)(26005)(47076005)(41300700001)(83380400001)(2616005)(2906002)(6666004)(426003)(44832011)(7416002)(478600001)(7696005)(4326008)(966005)(110136005)(8936002)(54906003)(316002)(36860700001)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 23:17:55.2431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e87214f-5b09-4b35-daa0-08dc0be90d00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222

Observed the following failure while booting the SEV-SNP guest and the
guest fails to boot with the smp parameters:
"-smp 192,sockets=1,dies=12,cores=8,threads=2".

qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
qemu-system-x86_64: SEV-SNP: failed update CPUID page

Reason for the failure is due to overflowing of bits used for "Node per
processor" in CPUID Fn8000001E_ECX. This field's width is 3 bits wide and
can hold maximum value 0x7. With dies=12 (0xB), it overflows and spills
over into the reserved bits. In the case of SEV-SNP, this causes CPUID
enforcement failure and guest fails to boot.

The PPR documentation for CPUID_Fn8000001E_ECX [Node Identifiers]
=================================================================
Bits    Description
31:11   Reserved.

10:8    NodesPerProcessor: Node per processor. Read-only.
        ValidValues:
        Value   Description
        0h      1 node per processor.
        7h-1h   Reserved.

7:0     NodeId: Node ID. Read-only. Reset: Fixed,XXh.
=================================================================

As in the spec, the valid value for "node per processor" is 0 and rest
are reserved.

Looking back at the history of decoding of CPUID_Fn8000001E_ECX, noticed
that there were cases where "node per processor" can be more than 1. It
is valid only for pre-F17h (pre-EPYC) architectures. For EPYC or later
CPUs, the linux kernel does not use this information to build the L3
topology.

Also noted that the CPUID Function 0x8000001E_ECX is available only when
TOPOEXT feature is enabled. This feature is enabled only for EPYC(F17h)
or later processors. So, previous generation of processors do not not
enumerate 0x8000001E_ECX leaf.

There could be some corner cases where the older guests could enable the
TOPOEXT feature by running with -cpu host, in which case legacy guests
might notice the topology change. To address those cases introduced a
new CPU property "legacy-multi-node". It will be true for older machine
types to maintain compatibility. By default, it will be false, so new
decoding will be used going forward.

The documentation is taken from Preliminary Processor Programming
Reference (PPR) for AMD Family 19h Model 11h, Revision B1 Processors 55901
Rev 0.25 - Oct 6, 2022.

Cc: qemu-stable@nongnu.org
Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
v2: Rebased to the latest tree.
    Updated the pc_compat_8_2 for the new flag.
    Added the comment for new property legacy_multi_node.
    Added Reviwed-by from Zhao.
---
 hw/i386/pc.c      |  4 +++-
 target/i386/cpu.c | 18 ++++++++++--------
 target/i386/cpu.h |  6 ++++++
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 496498df3a..a504e05e62 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -78,7 +78,9 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
 
-GlobalProperty pc_compat_8_2[] = {};
+GlobalProperty pc_compat_8_2[] = {
+    { TYPE_X86_CPU, "legacy-multi-node", "on" },
+};
 const size_t pc_compat_8_2_len = G_N_ELEMENTS(pc_compat_8_2);
 
 GlobalProperty pc_compat_8_1[] = {};
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 95d5f16cd5..2cc84e8500 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -398,12 +398,9 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
      * 31:11 Reserved.
      * 10:8 NodesPerProcessor: Node per processor. Read-only. Reset: XXXb.
      *      ValidValues:
-     *      Value Description
-     *      000b  1 node per processor.
-     *      001b  2 nodes per processor.
-     *      010b Reserved.
-     *      011b 4 nodes per processor.
-     *      111b-100b Reserved.
+     *      Value   Description
+     *      0h      1 node per processor.
+     *      7h-1h   Reserved.
      *  7:0 NodeId: Node ID. Read-only. Reset: XXh.
      *
      * NOTE: Hardware reserves 3 bits for number of nodes per processor.
@@ -412,8 +409,12 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
      * NodeId is combination of node and socket_id which is already decoded
      * in apic_id. Just use it by shifting.
      */
-    *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
-           ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
+    if (cpu->legacy_multi_node) {
+        *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
+               ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
+    } else {
+        *ecx = (cpu->apic_id >> apicid_pkg_offset(topo_info)) & 0xFF;
+    }
 
     *edx = 0;
 }
@@ -7895,6 +7896,7 @@ static Property x86_cpu_properties[] = {
      * own cache information (see x86_cpu_load_def()).
      */
     DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
+    DEFINE_PROP_BOOL("legacy-multi-node", X86CPU, legacy_multi_node, false),
     DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
 
     /*
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index ef987f344c..6ef4396fc5 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1989,6 +1989,12 @@ struct ArchCPU {
      */
     bool legacy_cache;
 
+    /* Compatibility bits for old machine types.
+     * If true decode the CPUID Function 0x8000001E_ECX to support multiple
+     * nodes per processor
+     */
+    bool legacy_multi_node;
+
     /* Compatibility bits for old machine types: */
     bool enable_cpuid_0xb;
 
-- 
2.34.1


