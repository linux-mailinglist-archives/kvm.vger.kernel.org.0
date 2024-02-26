Return-Path: <kvm+bounces-10007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289F1868337
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A8531C23111
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF62112F593;
	Mon, 26 Feb 2024 21:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VsC9rVbE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D341353E9;
	Mon, 26 Feb 2024 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983225; cv=fail; b=e5tUSDzRndlijx73Ty7qhYOvtRJPn2ZmniD5Wg93TpR6e5Awgu7gy+tvI8n19X4PVaOh2gphzrIPV5O8bCV2X+XDgW699iJpb+FY4ogC/s7/UTbESfJN1pYiR1ti3dSITWTS/gXhggLSEFDq6sxUy7bgZC9J7VS2g2tc2J/7eCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983225; c=relaxed/simple;
	bh=H9YXNTWjqPnp1YfKoDowcyg6Zv1FbLoFTq1TUm6PiWI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpVGVAL5KM7gOfbwjFRAKu07B4j0/QmBAffslJWLP265Es+npmg+MIevydbYQjqaZlOBU3hSYm8UVEXYzHd582ZMWe4sjQqJdw4BeTGIBHTz2CogiPzaFFBts8UkgUH+yvCDDo8eqaAM5+b0nv/altWAk1NWvHDVZDQ0SYk4mSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VsC9rVbE; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RntYAE0Q6/hZdDKniIXmToEhi8ZqOunArHSMGN1tZ/fs08hf5eize+ZGTxPk+cuWSQ7EfiJuju5/x5I2UgVJ4openngG0gxf2SCksJP9ukl+vMs942qITMs5653icPlh4LxWcxDTU/6qkmpsMxEQ7XZyvWNeHFrHiRVvh53HGHJXweaoXAVLGHPhFLK8sC/1X8+4vFfvWpj515lCIskOvwLb8+PR9db7sAMUym0nyPQZWfxPhEnXHYXk0g3z2il2OhqMFjpNBMaRHS1o4tfp+kauePOSFMK1BBjXG6NpBoINhvxGYXtyPlhSlQojqWgq8Xf3PQxmI649VMfrZey2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kG+9PySf9s/IXt/ytfi0Dr0DGxifcANasQNJu38+Owo=;
 b=KFG3ifTHx9qvcMOf4xsh7pSjIX7WFp3Ngp+fHZNkI8NWMqnD7C4i9YihT6j3B7e9DtYD6kNNL7lpdCrbtmC+7E8Gyz7KFig0CKO9GlezSmASX49YTW0RZs2d0klB1aoW0fmMvl/tz09oSUvL6NDNeYDgox9lh0YR+xjJVElIC7vAc7E5XmG6bBozXh+oXkjkdGh25tJtpPHIngIMlCSqoYM9RjJ5vqQ1wmhp/1RKC2u67cJbApUb9ivvUwmeERrtQBtOwuaD3BF+Wf6bCtpLqeSug5JLmOWPfWHFv/taG9gY1gqfXQMLo2KVH/Ga1MF3ZAK/any0FpFJ5KN3jfgBGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kG+9PySf9s/IXt/ytfi0Dr0DGxifcANasQNJu38+Owo=;
 b=VsC9rVbEaov+uPTaF2p7p76dvvXJ3Uxy4BMZPqpSZoWdgmDY0lAk2QP7QcMMI2qqvy5P2WzKAjWU5ep5D0Kxydm1DDQwl/8K/dnU4mxesaxJIgnXa2XyWC2XQk+VBDL+YT2xcmZW4zPqKwZMjLg29G6B9nSOaCRd2HmvvMPqRJw=
Received: from CH2PR19CA0018.namprd19.prod.outlook.com (2603:10b6:610:4d::28)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:40 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::35) by CH2PR19CA0018.outlook.office365.com
 (2603:10b6:610:4d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:40 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:39 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 9/9] KVM: SVM: Add CET features to supported_xss
Date: Mon, 26 Feb 2024 21:32:44 +0000
Message-ID: <20240226213244.18441-10-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: dab00498-e7f7-4965-a835-08dc3712996d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cdbiX+YVpO22KpS5cU0mJxmUlrrYjj2QTsxTXJMkZyLpyByUIn9JsLDhzyKop8t0InL1XnF2+/B9wA34QryfSR8AwrSuB2WgPu3u+Aoy84WYgHt83qnK7SJt2ryW1Deg1zbM6U+yHe/O18FyKNma/RqVxQf1M8bQYUIpuG1qlExKCJu9wwHBIFJxl7HOaAAsxk8irwm51rBbqHYdRmAYFEQ8pl8Hp1X/B0I3Hf3+WOK09148WicPuTnD+fXHDPZ3LJsXHw538eklnUUDkg1ljVaEgmLtw4lHmutOQ44NrlmRIpWKMbwQt1vOq96wym6KYkY+ZpMe1tkN6NqaCVIKJsrhJLYU0pQbfE3Gym8XA5hzoD3YlNSvW8xv/cZXx8NrOeJx3YbzRs5C7uH7G6Kp0d3pdTzpSS3KqxUFKn1Ykd2CGz8+fSV8TvaWEGaJzGwI5apqSmOFhD081qPMNcbBNyV2yUTx48gmlhxPDjxsHEJOeSxz31WM6DoeiGpWobxLg95uduJdG/+ftfa7E3R41NpByUTnftx46M00YTFr2L+YT671FikwpL548SSzi34seZUytlegGADUXlWbSnY14UeRKp2pe4rRxaotvS0+qX7nJ8ndFg07u50sOWkUtmJ1r6l58eQDyh09495w0H6qideRBwAJTSzWBfBa/c21AqnlMS5SRT2OOydIRF0hI39kUhSuG/oeWIQ3xVYaZunpIbUk2sJXvZFay7OM5/8XqKJa71YIfEsUff5MDh/htCZS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:40.2182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab00498-e7f7-4965-a835-08dc3712996d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087

If the CPU supports CET, add CET XSAVES feature bits to the
supported_xss mask.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1181f017c173..d97d82ebec4a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5177,6 +5177,10 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
+					  XFEATURE_MASK_CET_KERNEL;
+
 	if (enable_pmu) {
 		/*
 		 * Enumerate support for PERFCTR_CORE if and only if KVM has
-- 
2.40.1


