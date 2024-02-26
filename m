Return-Path: <kvm+bounces-10001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0365F86832B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 304D4B24DED
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79CA3133411;
	Mon, 26 Feb 2024 21:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vkjXY38N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C513247C;
	Mon, 26 Feb 2024 21:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983203; cv=fail; b=HBnMakpTQpQDdhYtwpRrw3BBY1f325gT5AKPZZmRkBEVnsSWlwCbU1tHWwad1Y9Jsht0vXBksQRRiWTFXGwAXybgDr2Nfe+IFdjjuBvTJUAIQDkfvHeBBsdLg025VTuDrHY8FSkOZ7y5RdEOD5rXP9h+m9k1+aa6wZFH6m4XbjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983203; c=relaxed/simple;
	bh=1TkrsaUUi9mF1kWRi7rFDTa6weQnnlwxMAsLrEwfR7c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clS0cYSoobnlRVoXE2fjgFodqT3phneP4rms9S2drnk2cWqCt3+5nuH7szYLosj6XkWhV+UT6PkfmpaJnR0lj+t8fUSEMZt/naLQgIpyNLgf8hE4d4rJ5p32k30vdGyC0UVBnNbSASj4xXET54PWXgVCfT99+i3eeWVXqJFTFC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vkjXY38N; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NemWL0OAcdxPKWE5VwhQqkSComZLoI0H+eCTBzGej6zn+W2JyWbd4SgUnVPuAzVjELJq0cTkVP9vyGVYp2IA955AUfYkdkUGJP3c94ZXrVBocCGJyttnUA68nW3N3Mg7awgGuk4+kDi1MuPYsqflWXoWbcoMfSdfVqJnFiiiedizXjPw7xM4jIIVfq28IVf9+FCpL4ZQXcnXQRw0KPVBcPGB/kVhyC35el+YUWtcXfvAmRGnzSL/nuHygqL3ud/IHq+sCt6vPfLROg4Jo9cK03eURzqgqRQTp/41qMN/ROUZuFKGqkt9hiq9Mxpw8SpIAGEdy+TtC47gWO4mSPwmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dB9LwhudYW6UmKBiw2KUxpzIr+HrXSN6qNTvq/Iov7Q=;
 b=nxjwbQPi6tLwgzjJkCduRi6mq1Blzb4AhhzoggGgRTxIn4+PCGUzoCsglTqJ2NwDiwr4jB3qzf7BiWgl/kG0aytJJIWRSg0ufrXXbYpgIts/Yyp4bEwY2xwBp/P5wmUmBBU2MgRs5C5N+4/RZnFjYKyxTSYv4ISE4gZit5LGVT3b2PA7/xhOSPtk0wkXqcBDqfKAtzaCRw0z2d/wuhYVJIpwGg5hpmpfJumubq37CEmzJPteZbAKSjAVg6BcGDnM6OYwoPpixnj6m68+8NRnROEf67y3S09WL/W+7+0LQI5oYfk5yo32io+5RM4sGu92JK5rcva2LpgmnQmFWyvi2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dB9LwhudYW6UmKBiw2KUxpzIr+HrXSN6qNTvq/Iov7Q=;
 b=vkjXY38NF1yHMYP82Rdl/SKw5aJ9ueyLOJJ+ws9gR/hnzyGjCnA/HFsyArqIOkeLZJMF829h9R75wdSlzoKtk/bxiy5ZXPp7ex5oXpKu/E6MQY7ZE3f4qniSU0V23b+TVCs3y1CFRujHVjpkOxzp0VndZBQ6Txzstjv/Xxc4A2c=
Received: from CH0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:610:b0::35)
 by SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:17 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::75) by CH0PR03CA0030.outlook.office365.com
 (2603:10b6:610:b0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:17 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:16 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 3/9] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date: Mon, 26 Feb 2024 21:32:38 +0000
Message-ID: <20240226213244.18441-4-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: a99b3da6-bbd1-4e6e-37f1-08dc37128b9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wojdGW1MzIxP0ufPp7bwuYqgq84phnm6esfOrhB0Qy4TySHQ5q48DeD7YX2kH8dSLWVNWNk3kwA5xeiGfY8lOPBgWTlhau6o4T6ErR8V0vkdNgLGtZcvioKkZRIZUVLkLsqFJEnL4Sg/JunYkpfqAkYy+dRd3YOk8CLemSyGkdiHU+vk6H6S00ytY8LR3Lkt1NbejcO+pb+z/SqcP+2JvT+KS47MmhlnXBt/tqPbaURip+cYXsMJLnlq61zyXQb689VcLNiJKBzagN5PJ/koAnULSK9pAGtPpMoV+Dmo/KjpGHKRqOzhoqWXQtVWJTzPfguDF9Mc4OY0QlOde7RjTJXGvbgmCavBUHC3VpMKDAPhUfNHTTpDdyoizxkqOxumZsKnHHj5wF+AhsyXkASjIXWWihfvLyMPp3inFU/370YLSurl4zCHQsnsBY5eL/CTmCSlDiw4eyLh0kXvpcsW1n0TGu9FBwK/BFcIxbBTsFxF5JYkLNXd4PgmD+BkrOWXsTRnh6ZX4ZZkhj55TGIALgjqyS7hmnmM15SG6wiOxgL9wprACWTgPRvVL6cMA+TwbOOmH05Vh1S8ag5AdWNTu63XmJ4utWDe7CXtnl8fIaBXDkaJ2TL2zTtkl8XwHuqOh0uW+kuH/sEcAv0kkPbJlTad3XeRm0fyIK153EngTSbzV3QBK0ioLdXI3QLQUbrrlhODHgeXH8W0kB05G2ufB1Odk/qUYd4G0wwr5MB66Zz277RpY81mLUUv4LS+9Dlf
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:17.0483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a99b3da6-bbd1-4e6e-37f1-08dc37128b9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143

Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
and U_CET which are only inlcuded in the SEV-ES save area.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 70f6fb1a166b..0b8b346a470a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3431,6 +3431,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.40.1


