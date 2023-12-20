Return-Path: <kvm+bounces-4944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7F681A212
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC1B72883BA
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E58482DD;
	Wed, 20 Dec 2023 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vuCJL2Vj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361A247A7E;
	Wed, 20 Dec 2023 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSZSisECxFhHBj7ZosZlPq/7gXFS9902+1H/K/Vo7K5WzaEnSk19EtEnj3IIlrjVmGw/hxo0+Ehn6T4YJRJkKVJGsLatT6MkLGCZBMpbhDVJkXlJ331KxlnuFrjJa+m1C0HPC+kI1DbZWIBIBuyebwrWT7/evvTYpscWRFaTa8agFvdHwMOeyLXMJcgP4FKvRmCbrfmxNz2sm6H0wCM+vyK6BPNV5qyICEpzQdpKbxCEijJOIZTA3r7XZ1+DzUYOw2oMpZdAxE3ZqmAebr2MLa32ApBNIjsm9zBoNJ+1Gvd6RKrxLkBYbAwYFCjTDN31PoY/8TdSLGUEmNjRvYuVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm34llylE9Hdr8O4++I/di4YmJkEQg9RxXiiaLC6sYY=;
 b=Hyyam/GYwuPxA/z/ZOBPCwOfoWeMuojMQ7EJ7jF6xBFz86VLzNgZCO6i/ojrinZeFyk8Xqdo9apH2qarTp9OaKkj+LzaUmC1dq2MvBj18v5FaBADK3dHlc5URNBtrvEbFt3s6eJt5fx05gO8RABV/ETXu5zOTjfDIrTAz0rp0lithlLKtGx3QUiUIiX2gZeo+TFJjTfLOq8J6XL1WsCdWjuNC6yQmSVil2NXDJG0cr1KY8c7mRNin4UoboeCSJ+Pdixn1D4IBVnUpPLq21/YlW4ZYlrHSyusuDvfLrL6LtwQzDiJe5trAE6dSmyu8C9loHio/N/eL29ReVQc/zWRnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm34llylE9Hdr8O4++I/di4YmJkEQg9RxXiiaLC6sYY=;
 b=vuCJL2VjT9iPyZ/xSt+KYJli3LjO0rFpZCJMu7riIxSqDT6h6cgKUyEs7LPTGD46YuY7G6tI/soq2Hkte77hp+glNxKObyujXEKUutx9REAQdv0Y1xft6QQ2qhdg5L3UpvTtObB5btpcE3S7tbk0PUOfHSiVp9l68sz3oZlmsxE=
Received: from CH2PR19CA0019.namprd19.prod.outlook.com (2603:10b6:610:4d::29)
 by IA1PR12MB7519.namprd12.prod.outlook.com (2603:10b6:208:418::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:47 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::3b) by CH2PR19CA0019.outlook.office365.com
 (2603:10b6:610:4d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:46 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:42 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
Date: Wed, 20 Dec 2023 20:43:51 +0530
Message-ID: <20231220151358.2147066-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|IA1PR12MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: c01b695a-e43b-4ee9-e330-08dc016e8aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CBdbrsLwlnQjmX3P+xSAnzw0S0O+/EuP7FpDnMFXwZyFHUYJVuF8NYela910jnRFs/JtXBh/IHAuMjkJFGElPt8NF3NRUuhR2gyitDeZyEzENZPQqfZADj9khSMeLHdeLUBm9Kbb2rqqUfQ1uSeH1KVOt3mRZ29/TIlFMhGslyONJN+dJIhwMFr7fEJrDm1rWqE1NVX5s8I35KgHwA8Ze2076cuBM3iTqebS6OZieVAwVHaH09L93zPJZhS6ENKs/hdeK4pPA8ugNJmdU3cxhOPSacfb3KYXw7fMQb4pIiAoiUPS94oJJWiKGZJEErhO9YbJvdpOBRNijxtYvp57NKgrV8VC96WN/+kn9OUnSp4uo+Msu96cGlQomV4LsrOr0+emRmsXelakfWvTug6tsKX/MlEAxG9WZpHf/UiMm3Z3uYvIwEO0QxxlMVggJOHTPK/LdswOCofaVUYnUpzF1IcqCXfQvLwozMOBoRV+e0xNLwTydeek+frDzMXo+061D3MD5bLtJZK7ElpXR2QahXgrtuYY/1A5FpNbkEgssXeY394Sb7Ef+tMMSgnFXfLturdXNSGYybgpDjaO8iHAM8bj3ZpKSW3QjX3wxIQuQUf1pYR3A4ixW9Q4kPvEoI6m2qx2IMnskwo1E9YHtbj++0xpCReEPyoWuqliz+Qnw0EMinjwKkkDlqZnMnKhiGs4zg+iBHCPihztb3wRovQcitNCmrMKOTUbtSX1z/YCYNpLrWzeszkdEvBaczVRkRW2uqotdwXSUtOsspi8skS3dw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(396003)(136003)(230922051799003)(82310400011)(64100799003)(451199024)(186009)(1800799012)(36840700001)(46966006)(40470700004)(478600001)(110136005)(70206006)(70586007)(316002)(36756003)(356005)(81166007)(6666004)(82740400003)(41300700001)(7696005)(54906003)(5660300002)(1076003)(26005)(4326008)(426003)(336012)(83380400001)(36860700001)(16526019)(7416002)(8936002)(2616005)(47076005)(8676002)(2906002)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:46.6728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c01b695a-e43b-4ee9-e330-08dc016e8aea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7519

Add support for the synthetic CPUID flag which indicates that the SNP
guest is running with secure tsc enabled (MSR_AMD64_SEV Bit 11 -
SecureTsc_Enabled) . This flag is there so that this capability in the
guests can be detected easily without reading MSRs every time accessors.

Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4af140cf5719..e9dafc8cd9dc 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -237,6 +237,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* "" PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* "" PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_SNP_SECURE_TSC	( 8*32+23) /* "" AMD SNP Secure TSC */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
-- 
2.34.1


