Return-Path: <kvm+bounces-15154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8BC8AA35B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7D781F23B6E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430601BED77;
	Thu, 18 Apr 2024 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bsb+al/+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C605D17B4FB;
	Thu, 18 Apr 2024 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469656; cv=fail; b=k7jVOupQzXPlL5onddR0SydxnGqE1wPPhM392Ag0Wckw4PB+fmlRZRMtMjTl8vECIFpS6Wj7S9jXi3A1d9ETjc00FpJRTXe/NG1BGnf5wqVQa1JhdtZIhhdyQbZBYu3NwEUN9GspyQjRSo7OPqtHHLTIwVrhN0wEZnOBVv/Yzm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469656; c=relaxed/simple;
	bh=g9tHXGN7Gd4ZxowzjJN85wi2+mbrn2r4BlJL8jkwBvg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AP94+NDNVyhnj7D7e1HbhfuFPPQYZ1TIAhp8swrmUt+CwAbHi7+ie5ro76miPgVxTU89eTeGtB9ccVf5Xy8luvfoHLsnnLDjlxDRfiDXI9PgEUYYdtwvOfyG2SZhn2SUKrSqpLOObn5XTUNKeyGd07uDYNblekD5DAkoxSTYgcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bsb+al/+; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHzeVApHM3eBAGnk0zS0FIomV9X0ZYN5tWVDRDHGj4ixBqOx4zgcSOySKt/0C8uTq3q27PqitCiMfvJ39MGDnWJfpju+xQfdsrgBIGffk646TSvamgVuWuKFepbG562cxomybv7ClTAbXDSNXwnJIHLK70LZMng6ademG6VhjKcwmWJ6jTRKhIugw5J8cU13qRML2oKbsH0B6BDedZoqOO+JTHJ2ebN/+k6+uctp74Qnwb30JKjdZRQoVyfShimR0x0V/RAeXm8UvucFVUn/pzWxZ7FJoz2CQ8vRgMbZhb4UNPTg10eHPSOWKTo8fDKaXD0nshRma+mVQjLUJHAHvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+G51mueTV+Sdz0lYR3YMAwLh9NKNaUf/zMQeba424ks=;
 b=BqNkf/ye2xzurnXRFICMKSd/HPS0DPQFuSrezazL5rZ28uAE9tUI12i5n5mdRx17LpMMNKGKQ6dM4v6lrRKhGPa38Ns20ZraCqi8HIbzvtTYx6JdG37s0piUN8cYXSE/o7ubLqCq9KxN7aia6P3cQgzjEJbMX8Lyvr5iSqJxISl0q2rUiywmf0oL2DH3/c3A6rucAR9s4y7rrrLJu3bWsTjfT1nJ3uKirhnfiKixwW9WIsxVmiXSvqS4IgSgSnv+7J9qUBkeia0NORPwCDyjiJPth6tCl2juMAXbjyd7fs9KtQRWR7hr6lfqrQLh58WoON0v7IGMizR5GLLioc2agA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G51mueTV+Sdz0lYR3YMAwLh9NKNaUf/zMQeba424ks=;
 b=bsb+al/+F4BEopdNimTPOHk4iTera7y/a+fqa8S/mezNfUExyaNNej9Zcfpcq35bNr7r1uXPrNB05rV1NBRsGisnBW0v1r7h0tDRSAHwvvZOglMNB6FJYUfiWkybzpdiFa3MVK1ID+9+V+hgLLHQhsMpNJ1lZ4tOj0qq0iDa8fs=
Received: from SA9PR13CA0167.namprd13.prod.outlook.com (2603:10b6:806:28::22)
 by SA3PR12MB7902.namprd12.prod.outlook.com (2603:10b6:806:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:47:30 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:806:28:cafe::fe) by SA9PR13CA0167.outlook.office365.com
 (2603:10b6:806:28::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.30 via Frontend
 Transport; Thu, 18 Apr 2024 19:47:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:47:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:47:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v13 22/26] KVM: SVM: Add module parameter to enable SEV-SNP
Date: Thu, 18 Apr 2024 14:41:29 -0500
Message-ID: <20240418194133.1452059-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|SA3PR12MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 7058a6d5-b1e0-4d76-897a-08dc5fe061ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	haObDg2x85k+C5Ve+hXk0voAqj9oHsBc3A4T6pGb4rNvxqGbrgtv2h9q6sxzCroX2J1binc6t18HZrt5Qdl1BCr1xYcjLji61S+9+rsHYZX1b0IT7xiRTA25SEnVLYGNvg5YyTWYrsDfRcOIMnt71gnm/IHipQWpUhfAjqy1mGbnQiURFJHxASNxZZ/CV3ABUe7Gx9pUoyO3rA2vtoMEnIYEnpoHBfOJLlzqpz63fnl6OUPJeViyzVhdUHW1kbS87s0ja7QoO19zqDcd4Fjw1p8Ihx5yYGpJBhLIG/6PhKTulIyMtE3VpQMZPEfCMpQne8ElF50JL6A3tX5+TCYcrU6Ug/XxEEaI/uwz2AXNWtVyy30v7Sfnst8V5u0/vurI4K96/Y3W0W5hmsh7ny79wEZ5r3KD7lwZ+Tl4eF51lM6WwNvPb6OQcnfrhxy0Id80lUyM0+4xh0mA0DI2XVhGFQqGRd43K/hxkbALVlac+1PpaJ359lh1+ZZttlRA7CQ7BQPjCiDFBEyuM5lB0Qqxcbl7esDaFmmgl77/wA0FuNj8gHfsqKFiNuvSOHkVLgid55/YHXm42jMKlOTUeeaRZGIllgM/PtJI5cYRlgqO6bJ3f6a1TiT2Uqd37ElHaEYBNcM7rl4GFIWMjCKSjTDZXbFJo6n1k6SwdvPpIXdKZjLWdwoSOwoXKsk3LrYH/+G/+fSnGu66Q1w1MynjghE6ty6Q0SghEDJVpRSOx3rf4Nz+Q+cucwoIUfe0fKk/6vdm
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:47:29.9231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7058a6d5-b1e0-4d76-897a-08dc5fe061ef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 03bfb7b9732d..de51c3aa0040 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -48,7 +48,8 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
-- 
2.25.1


