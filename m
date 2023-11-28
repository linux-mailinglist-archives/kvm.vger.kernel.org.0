Return-Path: <kvm+bounces-2611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B48A07FBACB
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55F22B22439
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF26858AA2;
	Tue, 28 Nov 2023 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TOk6rHj2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3B11BC6;
	Tue, 28 Nov 2023 05:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpzXL3tKA1xbZdTASFCi4lxvz9+Ycnu2lkPsEPDtVNOB5ZtuIcZ5v0A+g2rgPBJC9HhlI9rg4QjNf2RWYNAUvwubIABuhTmwW6Sh8vgNQ3nVkIS/eko6ItLPHvkTEkFNvIWk3T7ZEZ7aC86So+haJcIZZbhkEeSDxWAfy/xDA2ZzHK4x2ba1LYGjkdWsx7r8PILbmzpc8GaaWkFzSo2iRGgaQdkrpL6Bag6o5BKHsbIheXtmj0Ke12dz48GWk4E0tRcRCE0xJeGiQdgHQWtzkCRfydXt9xJlgdvwFKFi9de3AqJAPwi2PIrSuZ7phKc05Nojd+oodQko8Bskk758zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcicsXzeHKGsZEHzGC3Fwt0OSe+q3g1tdVXDopm2fUk=;
 b=R7AmRD0E7AJOBAkA6k+IcOS0TnFOJ8IThgEQswfTzF4e0ZS32X2q96DGPWAWBafn1lX/eAa9d5nLYpvWHhVOn7GcaTDglis9VCCNckxonwi6I9dZTteokgK4j8Otw90KO9W+JjPhVlskAqo0WGV2CgjRjy9Kozf03yGEppAzB4OI92o2HaN+waNCf+twD5hV5+rtN6fFvO94fF+/eP2058m+dEy/KVxmpeq/4u0Zp1gv2/Mi6msdXTyYYHAiFNFVfLnK7kGfZHDvtP6QiH8Is2nhMXEHvqWH/VimKKFGYyb7q4BUE36wBjR8BFfXTZn7gaJz1nVR/rQhvmIhhD4F3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcicsXzeHKGsZEHzGC3Fwt0OSe+q3g1tdVXDopm2fUk=;
 b=TOk6rHj2DpChmD+6wy6EZE7qrcMWgvfC/LHgceLut1i2qn47y+0aFlpr/W8r/MOUL/AcxKD6k29Dpl1YmciLgBpHM7WckzR3DSsm/yYZWLhW/AW/sHqF1DJZ57YSMR8AvZflkmy58TUIt47yIzDQR3o9kmrKTubYk0Lb1lL3a6I=
Received: from CY5PR19CA0113.namprd19.prod.outlook.com (2603:10b6:930:64::9)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:02:09 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:930:64:cafe::54) by CY5PR19CA0113.outlook.office365.com
 (2603:10b6:930:64::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:02:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:02:08 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:02:03 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 14/16] x86/sev: Mark Secure TSC as reliable
Date: Tue, 28 Nov 2023 18:29:57 +0530
Message-ID: <20231128125959.1810039-15-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: f3683ba9-4087-4223-31a8-08dbf0123acf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	663YGp0GjRXV/LFAnd+3kqoY3xu8q0YBgDnhhcfTIpr/v7sD8YcnE6d+P66UfbDN9ErFmt/1oJ9cwrveDC38M8DOecjdNN32QcsWZBXVAH8iJvc+u/IFyY0Nrs4k6o3vjva4+h7pJnFA9uVLo6BLVdHCYEz2fi6zCGrtD5HiDwAZq4akRhi/fgzhkATY7b43mry1xKqgMlBNeFtk8WyGqi4QRhiiYAx348dDvoGoI3Xsnq/cA0HTYDY1NSfR68wLXGWwpSNPgqbE5uA3/aWACFlhj9lN+l7DJB+jYhvYzYbNIZKN25vNOuf61zMhq8EuC98kyOCPDa0EKY/BUIBcWhKFgakblfPEOa0GSxj30JPeBzm0KboBahpDSSqBgyAE1XwCi2kZJvEPf4MK5kQGa0BOVT/MXnRzKdzlMSKKFmb3dTupUwWrkTb4BG1E2LHIFAPjxCAnXlezvqIEP7jeKhIyVRTlywTtslExQZ8abJKNzbF2ARFv4/1gxa+wZXl+i7vgqRie5ZYL5CSuQCSaRIhM/y1I7dmUoJd0hcZP3HCvBZlrlemThgUlQjlVK3V/86Fankj5RxBiGcaM35V2cgT8cBJDGCeO0u9pCjOgrGdVFQ8wsd5JW96h1vWzWp/aiRM5kqpjtWgZ9iEi15pcYDK2t3M5HS/38EMrHF/3Nxv9RaauZQYzLii//4wdQRsWQqUo71TnJXyVdDdEWwTiKFlIA9IpqT2RKlhFYb7rWkq18m7JEj0FhX04wkCJZ4ilsuEDLY0hMtGbhncn7wWKtA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(2906002)(4744005)(7416002)(110136005)(316002)(54906003)(70586007)(6666004)(7696005)(70206006)(41300700001)(4326008)(8676002)(8936002)(478600001)(5660300002)(2616005)(16526019)(26005)(40480700001)(426003)(336012)(83380400001)(1076003)(47076005)(36860700001)(40460700003)(356005)(82740400003)(81166007)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:02:08.8698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3683ba9-4087-4223-31a8-08dbf0123acf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851

AMD SNP guests may have Secure TSC feature enabled. Use the Secure TSC
as the only reliable clock source in SEV-SNP guests when enabled,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index f561753fc94d..8614c3028adb 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -487,6 +487,9 @@ void __init sme_early_init(void)
 	 */
 	if (sev_status & MSR_AMD64_SEV_ES_ENABLED)
 		x86_cpuinit.parallel_bringup = false;
+
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


