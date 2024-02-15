Return-Path: <kvm+bounces-8755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B6A8561AA
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65F8A1C22E11
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C3E12F36F;
	Thu, 15 Feb 2024 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5lYLpbWX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8818F12DDB9;
	Thu, 15 Feb 2024 11:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996756; cv=fail; b=ewyy57vOu3MG+9NCgslQscybRGdewT5XhPwOVZW0nB6FRXc+08ythMlk8BH4vC+Rd6UE2Dwp9EZr1W1eg2D+2SEFKAEB+n1T3e5POBkvSmH7bnK/vgvimyQgV89WzXbqxFhG8dxbJYKIZmuB3gWsU7C7y/8JprrzXepfNn5eBTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996756; c=relaxed/simple;
	bh=VQZ3BesnENu8A8Gl6qTO+hs2Sq/VgfOqBsxR+4rXzLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIuIE0u+NZ0phQA/x61Dc9CuurjhOAuR2u4fMnqOu77fwSdbeH5UdoDbmTF1hHarmXuvEOwfc+GB/OrzQlGTwPmwBElI6Fcdzu0L4yZzluFj9Ex/a/0erbX6XNqV68b/5qkS+JkrFciZBXxY3Sof5/o+fg0ZOArcGDJUrYWj0T0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5lYLpbWX; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktIilezRTECDyzOVv2LyYBDTIm/+VapA0ucIkqdDCkwBksLSUZ9jswKdtcnezover4coY5mpkldxPoX/+rwiIWLI5WHf3DnhqbNknEUCnbYA2/8AQbFTv63eS5GIgpFpiwqQQdLrE/qr/UjFGyc7gGe6dTws2HK4WdBkgMRC95gi+m4Lxw+ra+5t1xH11d9+5MEW+0b+3o0OEFkTSuFvME4eGvNug4To8m5yl1T3zv5X1lDyn8t9hL7wndM7jsGUwzzKMjuRpN5t3nsK5+jtzWKgGjgE2bCDV5YR3Hf8rQ2cqtQNZjh5IVTb8G0QxLyilOJ7qy1ynwRYpL/4qkH3pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/By/Hf/11UJJ209XpWOPJCZHYL2kjCtEz+pLL7Z9nkw=;
 b=CSot5rPyS0SLT53FqF+m+Ca1MriC7u5sWPUcwv6U2YBvW+UXRxp2Qcv/SwdC/JzGS6oVYPXEvXph7ZkvZhx55YV0J0d1xpS05Ug4K7uHSqQzvm+zhfLqRWev+CPm3If9DO8EdsiKaBwjwyYRdWnJoiEyxz1p6EwMMYMip9KDanYLYF7k0mk4aq6yY0kGlN+jnBNeDllU38PNv1OO8Pww0N5JBbm68Jxbtyjl49ZEABMzU0qCNootjZ542SDrGxYGdae7TSkHXygOkYrMkf30To0It5GF9m2R2KKZjGD/kz6JqL098FCLljzfzr7ChVOJoCtpWkAo3pycnhOG3xUqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/By/Hf/11UJJ209XpWOPJCZHYL2kjCtEz+pLL7Z9nkw=;
 b=5lYLpbWX2tpD0GiYC8WJzHJP+GFw9JWsTJHKif6eqcL8q4q3XIjjRazuFydUGywSCk2KM2V+B9mt5Ydl7VhQTEzn91ztwt2UeDELfBvZJx7IN252ASYybmqtg9W5/NXLDmYpphzsvYjIBxsbuz02wm2DrFl2/6oLd6V805QT1YY=
Received: from PH8PR02CA0022.namprd02.prod.outlook.com (2603:10b6:510:2d0::12)
 by BY5PR12MB4870.namprd12.prod.outlook.com (2603:10b6:a03:1de::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.30; Thu, 15 Feb
 2024 11:32:32 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::a4) by PH8PR02CA0022.outlook.office365.com
 (2603:10b6:510:2d0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:31 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:27 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
Date: Thu, 15 Feb 2024 17:01:21 +0530
Message-ID: <20240215113128.275608-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|BY5PR12MB4870:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba24eeb-f153-4560-5d6d-08dc2e19cc70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dezS2avW6A2b3FCXDGF3QCphgtgtNKRIUYq9C2BQWup3GZAUvyMWgWTT7g1lO/FCaV0cLvJVWhb6nkHW+nZJAqpcwDpDwSWgoZZxYjJOjcClTNw95Gn2oj2NUy77iTtkPzhhBAn8iyNtRv432xX6+xcT+rQSv3oZ1AQ66rklZbQI539DvvzMJVEcBo4qH9AhMK2rFzPvv8+PELJrEBDnYDLsEDAyfKCVz/8rEmerxFhaCFfZQ8fBst8Y451S6XM/ZqxpGi+Ik860o81NDOLtaIcXKi1OdtDd8pgYB+c9uqfwoG4XXbZssBoWkS5uqQpklqdbqbPOnFuNnP14zBQIwPLT2wvYRKGOG3Dc13J1gnYC9YmHwKbkNb456N33gHKmeUDqZH2zdgpVTiw+QWfiTqn2vuopa0jkPg+56qbokbAGT0OKOJ2CwwMPKf1sf+Xmw3ZTzmFIIpKE4OAIetW4+3xToctFprPbY4O0chw1cVa/zlWsN3fmi80KU8xSY9qpzbXM8oruDEelIjumR5mQC3IRY9dghtrf8Ox+DZ2en4WZh9nA55QKv6fmM1rlk6mzTjNZc4JH1e1QW1fx0UXTuHuJWL+cy1GVIImu3L55SyP7SfLpnb5L9ROIe3gyueu2PWY9BaCBUvv611G7NL9Mb9wJxaZuPNjXbMQfPZGjDAQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(39850400004)(346002)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(36860700004)(40470700004)(46966006)(5660300002)(7416002)(2906002)(4326008)(8936002)(8676002)(83380400001)(16526019)(26005)(1076003)(336012)(426003)(82740400003)(356005)(81166007)(36756003)(478600001)(316002)(70586007)(70206006)(54906003)(110136005)(2616005)(6666004)(7696005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:31.8118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba24eeb-f153-4560-5d6d-08dc2e19cc70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4870

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
index 0fa702673e73..24ac7fe97806 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -236,6 +236,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* "" PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* "" PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_SNP_SECURE_TSC	( 8*32+23) /* "" AMD SNP Secure TSC */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
-- 
2.34.1


