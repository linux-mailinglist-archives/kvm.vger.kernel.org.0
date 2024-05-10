Return-Path: <kvm+bounces-17227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9C68C2BC6
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 281F61F279BF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B583113BAEC;
	Fri, 10 May 2024 21:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bjqk7uY0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0C13B590;
	Fri, 10 May 2024 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376129; cv=fail; b=GxdywOBGZ/utPhNAYrPGdWDbzbt0rMro2oOEhFW0ja+BwJdfMmV52nwbiK9jIWfQh77GjY5jLiIivtqEjrCdiUq8Ji7XHJd3VM7Pl0BzsUFVnXs97FmMmBXNm+oUEM+aboDOGfALXnHE2TDFIujiMim+VUl08m0Un/vcyICWPZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376129; c=relaxed/simple;
	bh=STMjBt7II5aOnU+44cO/x5WLmabjtUCTNFDO/iQNVPE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5FMGsSkx5WE/Ogpu6TFvq/x17QowuaBa8zAlI3eSeCsRK0OWC53c74yan+4g08H+tAuQXtvfwazVHCkeyyh46Ku0F7etnPpONGFiemKbr/87WqL86lLrZQTN5ksvhoDsrcrMZNH2ss3RdtnlSrwGo744kt+Op4U+RWKIYF1yE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bjqk7uY0; arc=fail smtp.client-ip=40.107.100.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jceqJhD8oLhQ7j8T+u1p8iW/kb9HFBXYShkPtbocL/jVWvG9sF3WnmiVMBKWMMHSZr+CGxUgUlFtPJrgY/A1j1c9jbHoebvnaqA6pNKMIyhFb9O4mOI02J6AaurQ+BGiENESUCmZKJ70e82gDTpJhU+gAAVvWuzA1G7ZljJDoTOYTkHPb5OlKE2xbmRECnKMLULSxROH80dK5G2xKT/FNPTS7PEeLiRXXz17WDZuSCAJP956j3R5gl8zmFfRH7ucfixY64h0OpC1qVpF2c9u9DpZtodYP7wtjCpUCikqkDn7ReRg4XDodgaC5fHfxhBuovDj+1tB3/w2VlkP46kEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKvVqd4yyJOwXD2ESQgT7LvEE6aJ85ssZ1I5Ppa11rY=;
 b=bDjlZbwJGQjf1Vk93g054Y6hyrYbOK43I9qDtYLJTc7Celc1uxjWRkHERXT/oYAlqCxAkRNEHq6xeWjcSgUTg+i/DA53J8q9gRBPfMGns8ZZaqxdTpEq7ng7bVMQhKKj966edQfa1lElRmUwV/chxTQzOggcYAZZoqEttLCMT7BePYZBpHu2L50aOFUlsl1lztjZ+M8F9vYBC7xfeFBdNcOhbOx1qPIlZHUJ5LuE9OAruzk90J1HPxDSvvifW6BZRtbuwS8Sn0tfJN1U4hHa0DagxwetDcMmkyeJDvLwPH/XAmcix3d492nXRGd961uht9BshjOcbSLOIOCEs9iJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKvVqd4yyJOwXD2ESQgT7LvEE6aJ85ssZ1I5Ppa11rY=;
 b=Bjqk7uY04q4HrhYnhMsT+Ty1CjqFbXBlhr+Ge4j8PWbjTVfYfkp1J6Pf3Sa6CXP2maJBM7Q51rYp/LdvZMyHmwhA5i8CCzv0AB+UOY3A4Z51bUgVtHxpYuYSgNX5OwSoOTPg7IVttRZGPTrS/ssc5zK7dBojkLCkVE/rp0Bni8Y=
Received: from BN9PR03CA0794.namprd03.prod.outlook.com (2603:10b6:408:13f::19)
 by CY5PR12MB6225.namprd12.prod.outlook.com (2603:10b6:930:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51; Fri, 10 May
 2024 21:22:04 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:408:13f:cafe::3b) by BN9PR03CA0794.outlook.office365.com
 (2603:10b6:408:13f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43 via Frontend
 Transport; Fri, 10 May 2024 21:22:04 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:22:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:22:00 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 04/19] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Date: Fri, 10 May 2024 16:10:09 -0500
Message-ID: <20240510211024.556136-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|CY5PR12MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: bc982f91-5807-4ab8-bb22-08dc71373cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?euGl1uM5bx0y4rrhC3Wn9GLTydNsff8vlIb297fz/mA4zPAuJu6tgTmwRu6X?=
 =?us-ascii?Q?C8EPEpGW1ahAm6Jr/6DnZNVpDFA8FHHru7VlMcPOpFZt4dw0D7KwZpvErp2c?=
 =?us-ascii?Q?1GJ2d7dftcpDBRANQNWYEpQKHU8OXOS3cR7VCuRdqBZrP9yq4drao/VtKdW0?=
 =?us-ascii?Q?1QjWbE/xF9Jvst6FgyIXY2DEE5Hf8cTpMdsqwmthhAnmY9Z9J+Tzn+2ontml?=
 =?us-ascii?Q?l/MTm7x9EHaVGoMd1D5Kmf2tyiIFhXfe54AgxfN1pI3BT3J7wAx3yF3AAkTj?=
 =?us-ascii?Q?EePYGmb2hJq1Xlx9vRVUxVvVf1/yfkCm1isA2eRtdN+JY04O4hCVPfqpYO3Q?=
 =?us-ascii?Q?4UKhEa1YMYEc+ndOkMoxjMD6iqrWoTA6E7zosQSfiZIm/nKHp+hmwHR6/0Gp?=
 =?us-ascii?Q?3bAagHpKyFu08eSAI0jfIsTKN65v0z7iboD6OBOSjJYDPtlh68YR9/Rzq46k?=
 =?us-ascii?Q?7G8i9g44VIGpe3WI8b163b5EkGiGWTcu6fM28IdDe18IRM4EfD08wlPiKLe0?=
 =?us-ascii?Q?Bc3+UtFr4wm1e62Ri85O6rhuP5ENCF65qL0VGzV6VQfAh4nl45I6fPW60KNu?=
 =?us-ascii?Q?Rtt08HS/2oaOxXN73xP349NN7ytBPFi9Wn/bOwkVJ+6478kJaSJNsAgXkA8l?=
 =?us-ascii?Q?ipOUurgTsxtNL5eQY4kYfsj8RYpRpArOSZ04XBJbECbvPMA9kO4fQ0p6Fxf9?=
 =?us-ascii?Q?WYDYWb8X0RySfB2kwrGBg8Bt0q8ZS6WmG5hRZSMPVIDf1DZ02gQs/AZCkgEv?=
 =?us-ascii?Q?aLsttSQXlA6I9gssFGsKpdM7vusB2J2u4w17kd9E0k4fHrtSc+kKCIxSPi6z?=
 =?us-ascii?Q?G6MYD2edbs2PCe3xKROHLcpXLrgwQX3+1+HtHxCCDNpHg+395gmyyNEhlyLM?=
 =?us-ascii?Q?BHb7jTtp+R56FKoyFoRNxoP5R2jEUHh1uvrBWIFuG7AoLtPcCsuPHIPjrBQQ?=
 =?us-ascii?Q?E0aVs7PZlqNMj04cvN1z4vvrpr1A0Zee3LlW5rHObeSVK0A2jlGyR3ZjNN8W?=
 =?us-ascii?Q?KWsqAB0vjgFqALfIzsotwmEDwpxpO60SciKB4oCX80Fg29x47eDezRMmz0N7?=
 =?us-ascii?Q?tyOmHngGXG7A9VojRnfxwIp5zCqseroVBkl+b+xL7PRsm0oZxVwV+w5c09kK?=
 =?us-ascii?Q?LNRwLzbJXCGICH+0UDXKjRmTQL3uuJieKcImYOGhmkQ+foqNIPcew2Ru6c5H?=
 =?us-ascii?Q?HYnZN9XhCnajzVI97x9RK2zzD2S4WkoK5otiZZUWsFq2B9UkqEsC66dHCiUM?=
 =?us-ascii?Q?14NM4KwhkbyOkDD+nKbUFSyyyqw6G9Mh+a11HqLvFZkYAywVS/vPeYjycwij?=
 =?us-ascii?Q?hPFgnIDOqEBXjoqk8EmJD6Vp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:22:03.5244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc982f91-5807-4ab8-bb22-08dc71373cb9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6225

From: Brijesh Singh <brijesh.singh@amd.com>

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. Other commands can then at that point be
used to load/encrypt data into the guest's initial launch image.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <20240501085210.2213060-6-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  28 ++-
 arch/x86/include/uapi/asm/kvm.h               |  11 ++
 arch/x86/kvm/svm/sev.c                        | 176 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 4 files changed, 212 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 9677a0714a39..dd179e162a87 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -466,6 +466,30 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest. It must be called prior to issuing
+KVM_SEV_SNP_LAUNCH_UPDATE or KVM_SEV_SNP_LAUNCH_FINISH;
+
+Parameters (in): struct  kvm_sev_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u8 gosvw[16];         /* Guest OS visible workarounds. */
+                __u16 flags;            /* Must be zero. */
+                __u8 pad0[6];
+                __u64 pad1[4];
+        };
+
+See SNP_LAUNCH_START in the SEV-SNP specification [snp-fw-abi]_ for further
+details on the input parameters in ``struct kvm_sev_snp_launch_start``.
+
 Device attribute API
 ====================
 
@@ -497,9 +521,11 @@ References
 ==========
 
 
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi]_
+for more info.
 
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d2ae5fcc0275..693a80ffe40a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -697,6 +697,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START = 100,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -824,6 +827,14 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+	__u16 flags;
+	__u8 pad0[6];
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b3345d45b989..b372ae5c8c58 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -59,6 +60,21 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_API_MINOR	GENMASK_ULL(7, 0)
+#define SNP_POLICY_MASK_API_MAJOR	GENMASK_ULL(15, 8)
+#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
+#define SNP_POLICY_MASK_RSVD_MBO	BIT_ULL(17)
+#define SNP_POLICY_MASK_DEBUG		BIT_ULL(19)
+#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
+
+#define SNP_POLICY_MASK_VALID		(SNP_POLICY_MASK_API_MINOR	| \
+					 SNP_POLICY_MASK_API_MAJOR	| \
+					 SNP_POLICY_MASK_SMT		| \
+					 SNP_POLICY_MASK_RSVD_MBO	| \
+					 SNP_POLICY_MASK_DEBUG		| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET)
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -69,6 +85,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -95,12 +113,17 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -1998,6 +2021,106 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	}
 }
 
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
+			rc, argp->error);
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. */
+	if (sev->snp_context)
+		return -EINVAL;
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.flags)
+		return -EINVAL;
+
+	if (params.policy & ~SNP_POLICY_MASK_VALID)
+		return -EINVAL;
+
+	/* Check for policy bits that must be set */
+	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO) ||
+	    !(params.policy & SNP_POLICY_MASK_SMT))
+		return -EINVAL;
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
+		return -EINVAL;
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc) {
+		pr_debug("%s: SEV_CMD_SNP_LAUNCH_START firmware command failed, rc %d\n",
+			 __func__, rc);
+		goto e_free_context;
+	}
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc) {
+		pr_debug("%s: Failed to bind ASID to SEV-SNP context, rc %d\n",
+			 __func__, rc);
+		goto e_free_context;
+	}
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2021,6 +2144,15 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	/*
+	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
+	 * allow the use of SNP-specific commands.
+	 */
+	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
+		r = -EPERM;
+		goto out;
+	}
+
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
@@ -2085,6 +2217,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2280,6 +2415,31 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	/* Do the decommision, which will unbind the ASID from the SNP context */
+	data.address = __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	up_write(&sev_deactivate_lock);
+
+	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
+		return ret;
+
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2321,7 +2481,17 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		/*
+		 * Decomission handles unbinding of the ASID. If it fails for
+		 * some unexpected reason, just leak the ASID.
+		 */
+		if (snp_decommission_context(kvm))
+			return;
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 583e035d38f8..305772d36490 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -93,6 +93,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
-- 
2.25.1


