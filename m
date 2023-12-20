Return-Path: <kvm+bounces-4943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E207581A20F
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71CD41F23D48
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F68482C1;
	Wed, 20 Dec 2023 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NSqIWlH3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6198747A6F;
	Wed, 20 Dec 2023 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhlSPRxPGw/DhLzMYxs/mp34z23dK94GpptZFXaRRJ+3hVSYhbj75QRet74+m2O6dJz1FszGcJoh0HqP6ueJ7jodp6pATHzaoWwWdLOQR/sGBjuJT2TUlRbezPoDTtuCaP1e/OyyNHxsNCL52nIFxYjkadsn+KO01nbHTSf0Gscn8alXp6HgiUo4txVb6ey76DjJmn1aX/t6nhWVUvA/V5ASQv5unFyhd13JCLOxKHc9/q5ilLuNzJxqKobx+FONTCBQ/Oi7FurGhFaw7L9QOMP4RZcODiOwFKXRTD4op9bYgD3EmJeAdQKTMq8vBzbHO/M/i32zFT32queNt97tNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/BrqZDQRR940wuFRqJCBv463apXFPX/NaDCxIwGFj4=;
 b=n+POcvks/cID1dng3Xl7vI81uWtSq9AAepGO9ptuJ+HJgcEpuAIZB1R4dMweZScVgBjZiL169KofT29rfJBrSKxCKRJxdxn/FD7jmdMwbG3g/6BlmBz2TUDYkBs9Vp35LJ0sCEkQtDSPfSQAJhLiUsFuDGWGD0zVbTjjumUSAJuDnrZZSX+vRhKRuR+dTGJfxca1HiDEaZpjiB9KncXMQQBKr6LFVSd4FwB2E7LOcnaAxusJjAtOVyVHliZp93bl+Tb6Wjen+AgmtaAVdebwElTfvDRA0o5j3stTbYWCNYUTOdO9GqY5qqKaEKZ3D3+TZBNnQybJsYsNsh1JpYUB5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/BrqZDQRR940wuFRqJCBv463apXFPX/NaDCxIwGFj4=;
 b=NSqIWlH3I2XXmxmFRWFHyppapjZYwRqZtpNWgkKb9aIpS03uCqKscaoMTZxfSmfObB1YSpxwNCoByMxBJHDUmr5KAtir4/rKjojK8OUcx23g9ovWjUWaie7q4b+I922lQwMiMgooz+IZl+Zh2YHA8i+h0OTdRk0Uk4gl6fNfC1k=
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by CH3PR12MB9454.namprd12.prod.outlook.com (2603:10b6:610:1c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:42 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::e9) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:42 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:38 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 08/16] x86/mm: Add generic guest initialization hook
Date: Wed, 20 Dec 2023 20:43:50 +0530
Message-ID: <20231220151358.2147066-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH3PR12MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 1162b5d5-ecd7-49b6-709b-08dc016e8880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4+3Kg7BxewFRlliEzIMkgwURrpqm+2nqAJNTnLJ/ag945bBole76ifYzPfy5SNHJoKE7w4BGsTh0yI1+L7hKgZ5sqXA2yBiCwyM63aRs6E6BUXlMjJjyrpM3LFUTgv7g/Po7N8S83YiY2MEkUzEVaun5wN+5sMCZ/e/73AVtVJw6RIVTU1qgyzWAP8qakAC9oBfv2KoHThvWBS3sE61pChyL52llHNi26TjZP5wu20xFybLs6rWSj/n0b0faeQ7Cfekhl+dXBFfSdB+6mGLbgmw9XPvhORzX2DGAN2oeO+Mf0dl3p29L4GDlJk1PjbyLJRvMRiFWTSNvD17bNXAVh2IgktBSzGzGRkVG4PXz71O309Cb8qm8cswBPrpmI9Zizmge2Lcx1OVuwg8AEIFImRDqN7qAiWBWZQ5A0Mnl/O42v3LAXAOQWI0zdSw24dm6EXXE+1whEtCjg+6F5BtF23o8N43L5OhAmV2g7xAZzut6ayw4jeXhltwE+duCT8tpFXo//DolkgZCOxXDBBy/aMyV/K+N+r0AUwqkbJGPg52z4+nqslMDtf3ZsmSTt536bGrrBACZC19xllBaMW1T1EALPyYO6rdC903irQJ7eUIPFqEHIjX/RC9kCuq+G5Yoc663unqgbwSPeFoIX4Ogja0oLppQbhKwn8Cq7TkAr9ewTHH9VlOmwzr2Sq99MTKIWQtdvmO1n/h5U2pomKFwRWRwyip8VfRdRudQegxT6w7ba00R8TtD9gFmdY50zll0td2uC7VID6KB6nQnQ5ycpUJ0xHelIJv72r3/4MmH6A0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(36840700001)(46966006)(40470700004)(2906002)(47076005)(36756003)(356005)(82740400003)(8936002)(8676002)(5660300002)(7416002)(4326008)(36860700001)(478600001)(1076003)(26005)(81166007)(2616005)(40480700001)(41300700001)(16526019)(336012)(426003)(7696005)(6666004)(83380400001)(70206006)(70586007)(40460700003)(316002)(54906003)(110136005)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:42.7135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1162b5d5-ecd7-49b6-709b-08dc016e8880
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9454

Add generic enc_init guest hook for performing any type of initialization
that is vendor specific. Generic enc_init hook can be used for early guest
feature initialization before secondary processors are up.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/include/asm/x86_init.h | 2 ++
 arch/x86/kernel/x86_init.c      | 2 ++
 arch/x86/mm/mem_encrypt.c       | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c878616a18b8..8095553e14a7 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -148,12 +148,14 @@ struct x86_init_acpi {
  * @enc_status_change_finish	Notify HV after the encryption status of a range is changed
  * @enc_tlb_flush_required	Returns true if a TLB flush is needed before changing page encryption status
  * @enc_cache_flush_required	Returns true if a cache flush is needed before changing page encryption status
+ * @enc_init			Prepare and initialize encryption features
  */
 struct x86_guest {
 	bool (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
 	bool (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
 	bool (*enc_tlb_flush_required)(bool enc);
 	bool (*enc_cache_flush_required)(void);
+	void (*enc_init)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a37ebd3b4773..a07985a96ca5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -136,6 +136,7 @@ static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool
 static bool enc_tlb_flush_required_noop(bool enc) { return false; }
 static bool enc_cache_flush_required_noop(void) { return false; }
 static bool is_private_mmio_noop(u64 addr) {return false; }
+static void enc_init_noop(void) { }
 
 struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_cpu			= native_calibrate_cpu_early,
@@ -158,6 +159,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 		.enc_status_change_finish  = enc_status_change_finish_noop,
 		.enc_tlb_flush_required	   = enc_tlb_flush_required_noop,
 		.enc_cache_flush_required  = enc_cache_flush_required_noop,
+		.enc_init		   = enc_init_noop,
 	},
 };
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index c290c55b632b..d5bcd63211de 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -85,6 +85,8 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	x86_platform.guest.enc_init();
+
 	print_mem_encrypt_feature_info();
 }
 
-- 
2.34.1


