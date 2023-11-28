Return-Path: <kvm+bounces-2606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4EF7FBAC1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5357E1C2146F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FDA56453;
	Tue, 28 Nov 2023 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gJDaKY+t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F078F1BC8;
	Tue, 28 Nov 2023 05:01:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5Vk5YlQkdcSe+htD+sjmEHI85ycfFkIkngKIq+byellY5CXjKCq6oIWn6zNI2+yteujAr2EwITrGQ1lifxV2aH1P7UvzpnDJPKKTZKTUSd/TzWMr81W4Ruo+IrmGb8CeSfzk5msmgNqrmqYFRX85ah2HVaEtj2SqL7ti0BO8OfXi3wiZ/yeF6I2lceTqRb3Tv66/9XzpzpAWxc4C1pNK+xLFifH9hV0YlfkjvJ2aom8ztdgvui9HIh8CKd8a3gDfz/Qn0PSVbZP8ljK9h8C+0pc0fP41JDGHl/vZirzXJ3Z3A5Q/Fv04657m0ZLh/8eHm6nQymR+woQreNJ66QlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1doADTfMpzMq67BcBHqxGYADOT6CGy0ZxSQU1MsnLo=;
 b=ffdETtvEHlexGmgzoCd+MYaxUTjX1T2QutzC22jQcBcQNlUvBrB2wXOH8i3ALB/PhwaxdeeQywv7hgsWVKYZx+yOTB5u3Ej1E/O22Dx4bJAMq1+ZtuY+1hcVhcYpTdbYpJRx5GI4gfmonSs5sOsFeTjh42ePmkmb01ZmJpc33JZ5W8jqm1wm/eUK9jyyodOwvN9GzlvgmAwVZe+Nc1r/ZY0cacgbqcXKRzjInua6NYqiWxvUAbsSLBAhvSYyj956EDBSCeNe09PzHV38lO+8mnDhhV9dpogx8oN9pbFw4QNz72Ur/fTD8IsBUkUz29e+O+tV0aYkpc5VuN/aIgDmGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1doADTfMpzMq67BcBHqxGYADOT6CGy0ZxSQU1MsnLo=;
 b=gJDaKY+t/PljRVePfv8olNB8CSefWoM95YDSmFZh52XUzUVTKDVpcq5a1pYxPBKCBkMYUsvuE0PI/s1bfBF9I0DZ4U82j3KpJ4G+VpVqKPtygmUKHc4gy2gCDijKrruNQ4sGbkiBQszzlsabFb/AI+i8OQ2SAgv1YeA3HGTD4fo=
Received: from DS7PR05CA0030.namprd05.prod.outlook.com (2603:10b6:5:3b9::35)
 by BY5PR12MB4869.namprd12.prod.outlook.com (2603:10b6:a03:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:01:33 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::7b) by DS7PR05CA0030.outlook.office365.com
 (2603:10b6:5:3b9::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:01:26 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
Date: Tue, 28 Nov 2023 18:29:52 +0530
Message-ID: <20231128125959.1810039-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|BY5PR12MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: 66805b6c-51d9-4fcd-8277-08dbf0122513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zeCCV4lVhPTG2apRl7j1XyBg2yjLeCW28gWer4zIvL2sKOYJci9DOmF7wULz3TvRUWOisbruBGuUEjazO1ROjCvFLvCFdDpfamw2g1LIbqZ1gDqnnKizV8Piz8WaRA2v0SWLeW5cVxzxAwV2uVHOrZwCHAldkZyED7PBnJ2KN6KzSCiMdPzpfmTu5Ttv17+iiUjp7ZH7lJH6+n0KYXYQ/7ZrjFdfodbOHIPmZl+nEgX8N2CewB1t99qCE9IbHnyK3RLb9ahHDY6t9vYvufND9RylPYydAQxEZOA8/K6IViomyKY3VqZwxtEIwQiw13SHhgDVXh5EGEXJpskiUDajx5Lmhy/s43ozd0a7BnH6t+Ub5nx04uxDF6qPEQyjKCz1vGGnkH3uciUuDF/QeVvOiOC5mDd1L/w+d4BLQj6nQ9FTrImQkP2mKXK8JyGDC+J+nnXP/zbFxLcNJONR/tkK+R8lQaNAQRkCWDOF9vuXibf7h5YDCIgjY/f71mxQryR5uhP8YoR6tWkQYA6k4Omq5qaA8uG8rjuAinwj5UPL5+PTQRRdG6W5+7aLBeNorY7RoU6c7e1AAzfZv51ncv3tClRdDtQLH/9voNLR55Mc4FTBtVF57O/odpfLRifQbEhUVwBf70b5pdqyEMH+xArPM7fEA/t0noXRixehCS1C3pIKJydd76TjILGLKNJWhe1Ry2bCswzzVrYO58zRsEdL9HLLkLS7VrdLLiXvLt/JAqqp2x9TDHMMvYW2PJff7UJpr0jQZxKHAFDmPFK+PbkFsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(82310400011)(40470700004)(36840700001)(46966006)(7416002)(5660300002)(2906002)(4326008)(8936002)(70586007)(41300700001)(110136005)(54906003)(8676002)(316002)(40480700001)(26005)(16526019)(478600001)(6666004)(1076003)(2616005)(7696005)(426003)(83380400001)(336012)(70206006)(47076005)(40460700003)(36860700001)(356005)(81166007)(82740400003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:32.3920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66805b6c-51d9-4fcd-8277-08dbf0122513
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4869

Add support for the synthetic CPUID flag which indicates that the SNP
guest is running with secure tsc enabled (MSR_AMD64_SEV Bit 11 -
SecureTsc_Enabled) . This flag is there so that this capability in the
guests can be detected easily without reading MSRs every time accessors.

Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
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


