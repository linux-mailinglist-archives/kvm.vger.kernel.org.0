Return-Path: <kvm+bounces-2604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A30D57FBABF
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F042282B36
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3B856453;
	Tue, 28 Nov 2023 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BgQn9skk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCAA19AD;
	Tue, 28 Nov 2023 05:01:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REafcnPPUgTu40kxyFQQOR7xcUjEZAj79azYaw2rafr4+jT7GK/8fYZQC6OgQ/6ULM4b8TbbnreXKXhFBZyRbNcTu97MKiPmpDT1hDEkcDNyNHW6ub0G0osWzfiYK4UPYDnZloZ+3ExHb5tbHnfKmvPSRNNSN0e/M6RBbslrIDkoIIJ4aVfP3gYSvkV4hgV7CNAaK9X0gsP6omtHb7P0wROer/BwwRuDitFmZvIYiTxaqalVs9cbn3w44qmBqzGI+wrvr/JUaJvtIElOlR34X1fBbVfu04nwhc783qRA9qP91ZU24NHkXVjIFYD9MdDbuc+rzyZ9veEFbS79fp6bYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mz6cH74fUjTcEdarUP6Hj0uoBNbbwEcK3LmObPNnE80=;
 b=T1UUOC1X/2kIGXSyoujkQgrOhd0u9cMNa3nVdJTwRbSHrx/yiJI2yglDFFiQjZMAO2HP8RvRBWr/F7qxXfQyn19CPr9x8VFpl/W3SoWdnX+RwiZnXHHEjE+AmQQEGR3pd6Ga6PH1Snr7awclu+Hcf1kxzV/boAVLlbuhvu3nNgXSnH4CY31cJSXcU1BSvB58eUFNlpdxtNLOQOHMeJdQ4K1swiYxhryPzLz1erUbhWKv0ILt2GdVOCkERRgFfB38KOTTrxGvaBGfEN3l0ATXE0UZgBz62DGH80sM+ztvMt1hwjf9VQ4kS+Z/LFV8WCr9mOBuzbogeDce/EPIXVM2UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mz6cH74fUjTcEdarUP6Hj0uoBNbbwEcK3LmObPNnE80=;
 b=BgQn9skk/9g2k+LOms8J5Bapr49UvjB3lfCT0hoOJCRuZd6y70reVAYqyFrUhtQ2B2PmjHjeFG+mx1c+HpPKJEPVHtCQWRZwYh6WrzlDaqDfIjjR8kDzPkXrjXwC9hKBqHV1OtKz6CmdG7kri8XMCeQTTCEPoKLKYvyd4X35grk=
Received: from DM6PR07CA0132.namprd07.prod.outlook.com (2603:10b6:5:330::25)
 by IA0PR12MB7699.namprd12.prod.outlook.com (2603:10b6:208:431::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:01:27 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:5:330:cafe::dc) by DM6PR07CA0132.outlook.office365.com
 (2603:10b6:5:330::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:22 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 08/16] x86/mm: Add generic guest initialization hook
Date: Tue, 28 Nov 2023 18:29:51 +0530
Message-ID: <20231128125959.1810039-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|IA0PR12MB7699:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa4cb98-6b85-4a73-1bae-08dbf01221e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mJVRnSQRjTVFooOnEKUfLMlmzGLg19OmkrvpZ7tHE0a6WOXdAaX6XgBiv9fLtKK+icfMsup8psDPRwhlcfCVbDuKJkMDaCihTZMgWGX1uxfRw7pWKtgManEKz5yjzDDrdK+NgqNnA1/PbKNcnyxg+3hBroWcsxt5h5y0yfDMDl8N4f9/ufHFGx9K/uzrNdXfMZE9+xvAv8sbflYjTGkSLa5a47kGzjbK/KvWqEPYAWXLCqkr4ZiC8eWproN9hwzIvwX7UPfj1o/Ye6etvrktOWtKhDDXmugo0W6DMk7akOWpl9Zyq8JzWaEd3MzABuqP+6BnJrV1zt9y86UvgNcdtwrDB6SP83T62yr/2oh/vbMUE07mLLXhtf6qXT9xcC9flqjtZZd5ogfMbU+0rATBoXF+ccaino+Mi5zMWwWtusZ3wqSV2+b10/o7gMlCqhgTPrFK9Xlbs0iU6BPYDDSu/9c3TAULkmTzHMecoM2ltkN445TCArUKQ4X8dqM9Xfpgbw6ygK22oRdMauRX61rLqoOT+mvWpdEc3VvtcWQXOQkunijO0jbdAalgnMsW/4fZGVj3VWQR8eSjz5QVKcfyI4dwKRGYjXhVkn76XMQEynqKWUdmcElAWozm6xRGRKPa/YvnY7PkFpv6Ozyttne1HpAZ5o5l2eIHFbU0KTVEZ4LcptIJhxWX7SipY5o8BxzNdssICQPGViA/jbE0cM7n6myog1tZe6x77yJqRxKSGcZkww9qcYhfC3ezxVPfpI2ZxsPiuqOWBD71ZljbC3h6oHdGpWods0t/8vCWZ9eBWB8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(451199024)(64100799003)(186009)(82310400011)(1800799012)(40470700004)(36840700001)(46966006)(40460700003)(2616005)(1076003)(26005)(16526019)(426003)(6666004)(7696005)(82740400003)(336012)(8676002)(8936002)(5660300002)(4326008)(478600001)(316002)(70586007)(110136005)(70206006)(54906003)(7416002)(36860700001)(83380400001)(47076005)(356005)(81166007)(41300700001)(40480700001)(36756003)(2906002)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:27.0441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa4cb98-6b85-4a73-1bae-08dbf01221e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7699

Add generic enc_init guest hook for performing any type of initialization
that is vendor specific. Generic enc_init hook can be used for early guest
feature initialization before secondary processors are up.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
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


