Return-Path: <kvm+bounces-8754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88ADE8561A8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FC02290ADC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CD012F361;
	Thu, 15 Feb 2024 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FLP5ZNCs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5FA12E1F8;
	Thu, 15 Feb 2024 11:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996755; cv=fail; b=Ycl6SwOoxtsvf48bmzAH6G7sEdQqV2wmZYXG+5LEfo/KrighwIHbQjkCULZ/a3ydNp1jGUaWDgJ5xXEbhwVIkw3AEZ39PjhkT9rF20JzD+tKN41NxJG/b/s+bfMGv1QsjSIBJKyI/a3er5ZJCzRwLfr8f11siVmSF759LEnhhJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996755; c=relaxed/simple;
	bh=bXcI8wQzH5Y8PNfXYkO85JgU9z0v+W1di+HQKnsKJ6w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aqy4JoI17LkO5KUsxmeLqpM3imrFG1CRSa5YdijFL10iIbV4R7vSvtPm3UQa3e2sTjgl8Z1tRwN5Su+bSbbsB4nvgWwAJrutxq1lx+jjsv7+ntmefAGlFd1xZTuE8asA4A84tYgt7pak6/e4aXxjiHrejvn+7BFApCIIEvRMUyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FLP5ZNCs; arc=fail smtp.client-ip=40.107.95.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiQpZz9+TQE0NiddzpQbSqcJ9MyZYJfy9y35em7bi82zabSHhYazzd9PwQTQhyWk/M2xmo/CUvrLladjmPBUyLlAgf7F9cPU6U/WPkK4Hc0P6O16bAGlpLRJ3S8btb9MYzSL1z+0pJ2/o2hvuqlOVXtEwLK+sH5RILUD9LFlKq7eLEgFo+pTwurUAB7iFUlMc38UHaTg64DuXdXqlj3Y4UGG/ZF5o/lfwmYiM9+Ufx1UEuqdgWntNMX9ZRURg3HB3l1vIrkvPpfywe4ScPx87HK2l6FieCSHUKb1lx6WaVDJRG/+Nr8ByCW1V51JxgSgklRyXUcmVWU/DfQ7pleGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+Hhe/UAyfEe0bEr47t0KuvQzkC0mtGNZDMS9InoxEU=;
 b=RIuA5qJR8/yJrczihhwxsXchbtT81OrhF9evgMvVlFSu1BDtyg8m3GtEhYqZt8YglejsWLhLfAd6pimVyhWvNBJAS7K+CyrCkeCnjINPERmRuaR030+Glcb4SZgMvQKTUwBDjjBmg0Zxw5y7gU1BwpWq1lGvdoahRQZzH8fTe1zvC7tK7IVZ5cs7JngPfSQ/I98iSxQdYLxEQoJzsBxEPQw4osYPTgufxpBuqto7zSfYPaFg96YBhT77ggPkwZUY8YGSM9zRVEsIvnNhwoPVPlpTFcSVWb6r2UFk4cN1Lujm2JpPOP/WQllVqrcQwFLscpdGQHufkjGLAC7K6c90Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+Hhe/UAyfEe0bEr47t0KuvQzkC0mtGNZDMS9InoxEU=;
 b=FLP5ZNCsx2kYXrQQvffPUEFwlQZeBQYqaLeqDJpGOg0Vr2yULRivu9yoXLLNcZ/fN7QFzX/aLUIkTSjfA8+qQ7g67INwgwS4jut+pdXbY6s4yLZQY5fEACkI5DoWL2Bjokum5yofeCv5IQAb2OlAtzGjsrfOCJjXFYc2tv871x4=
Received: from PH8PR02CA0006.namprd02.prod.outlook.com (2603:10b6:510:2d0::23)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:32:30 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::a6) by PH8PR02CA0006.outlook.office365.com
 (2603:10b6:510:2d0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:29 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:23 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 08/16] x86/mm: Add generic guest initialization hook
Date: Thu, 15 Feb 2024 17:01:20 +0530
Message-ID: <20240215113128.275608-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: b1cbac2b-f8b2-4e83-e244-08dc2e19cb30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6FlmaZJmbCNM3hrMoxPPlWdS2k9NkzQM/nFEhPdRoieUWhfiWHMQ/ACkpooLx0t1xluBxQVBrqFyAvB3zhXIFwB4qzDbrIsJyUNJiC2fjvIIHlFYAENBBKaKY6PAxej10ntNWO5JbGQxFxWKMyq+tRMkIEHKU82Dz3WnXwKCXzVnw3S+8XaG9etb+pGTaGvyPnD6jqXw8s1gxU2voTh96z9cYNy4PHkiD8enWe2YRx0UOyUlLNRGYQ3q0fss46zvvsf4Y2tTvNtSbvIqDuMrSgToNoGTC7rxUrMRF4zOGsH497xSlNqRyydj3bUIwy4/eZWqXkSIyN8ozL/XIE7bdiUW0V6xRmcj26al/oVyRoUpWPjU8/xy8xV8CRWuT8bcNqjbsIK228Lyr0SRBJaG4Tsp+JyLUUlLOAYM2vDRH1bROG9XNB6WIZwrefOmgQKYo5fVqrqxmhjCndPIKJ3Wbu2R0b5thNO9ZK9KuLiA8HttO0ggV5jdmTuQKZOTz4O+Kwkr/uzT+4JmSFwf26GlFb3vEu54dq70gqaZjJNiLa7pkBDlncB95U2NMOPHA/eNGSl0RGDvxX9swd1onjt2xABPKyBjqrkgSk0MDZgWq+TsG22E067jbJWi5yof3xSMK9bOAiRmbgSvysN9F5NtsVl9K98xK2ucwO1Qh1brmaI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(186009)(82310400011)(36860700004)(64100799003)(1800799012)(451199024)(40470700004)(46966006)(70586007)(70206006)(41300700001)(82740400003)(81166007)(2906002)(7416002)(16526019)(4326008)(8676002)(8936002)(316002)(356005)(5660300002)(83380400001)(54906003)(110136005)(2616005)(426003)(336012)(36756003)(7696005)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:29.7181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cbac2b-f8b2-4e83-e244-08dc2e19cb30
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269

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
index d035bce3a2b0..68aa06852466 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -89,6 +89,8 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	x86_platform.guest.enc_init();
+
 	print_mem_encrypt_feature_info();
 }
 
-- 
2.34.1


