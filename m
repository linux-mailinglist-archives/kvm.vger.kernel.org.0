Return-Path: <kvm+bounces-10006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 004A0868336
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94B14B2231F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF4B130E5D;
	Mon, 26 Feb 2024 21:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c/9yfnJY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540BE132C0A;
	Mon, 26 Feb 2024 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983220; cv=fail; b=EkDT9oNBkdPCitdiujSzdRIlvcxzQjxkZURMIxvP3ly+10C9X03X3iDWWCiKavUlgLDuFREipn1TgMT7/SFoYaWwkHL+lDYxw/j1UukM/qtvRQ0yvG3mRb0Zr8doVPS5jEZ5YsWXtbEpgQggBXxSVJvoqMPUmcOgwCLABWP4HlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983220; c=relaxed/simple;
	bh=7ob0I6tysZJ/J4Wduw57ZmYcN99yyGsSZbO5/ew3sTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jaVYoOpnJAPKCdgHroqA339gaaNNxX4zH44sEz2sP2dylK+QCtwgkP/NhZUeeX+pc3BrN4OZJPzH9AAygLyjVi5/jMc2T6Zywxghg0LOsToM12wTJ+3mX44z3tRtBgewxGQTqHv8+WMB5caZDnfdWfb92fLhPKHz9j+OXqbriiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c/9yfnJY; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juaT0lU89/hFRR4p01XJhXhmPxfPQfpDtzuPVBlggA3B0WpNmnuDVCVAo6ljtPrBvgQ9yqbsyh/Hwinf9JZHE4wNpTYacP0driP0TW4wlnHDdZtQuyRkGSQFi2FGaQ1qYJW53lH4VoVwTIOEHcRM6G7gGFlnmgc4lYd3hTQTCCxPoZPnsUwEKBzxjG9KHlmmSO+sX0WfTEqVjaLS1ZGWQMPTzfPnCbX+Wuro0S0Gd8+hjNxO1z0rGK85pq3QMjxYe0nhFBLYU4mQn5r7AP9UO2Vl50M42ev/DcxCQljEu98rgT5ZYMLs64HenBAn2QK6k0/O1GenkLoy+QHbGHmVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdKCaSdJgqE3ljWDqNuC2Vw9YeeoMmkN76MoNaolgSg=;
 b=gOQ1MZBNA61AJ3CoWmdp8imXG2i22UpeI1OQ4drbedOSDdGRNAPw9547fxGkUR5K4jlNuw9ZiPERN7FczriQHPf2KpzyXQmsmagpR2CqF4SAjKDjJLa+M6VsDso2fqSa93tq3Lb/6MhxewexkUoGwnq8LGpCWqeThNcsOQw9SMQigrbYELs3nXY9rrfTUIlow/krUycTpTMWQZiy3eGa/F9UpiztwUEf/6iDOY0s0+sTJKJKer/pOUNYmJU5FrLZRUdB2zyurmhzCDZn+xRFZPposA3ORerUFzhQR4BOQuWlaaDJAP3PmljK1mB3qDMY1vv4EPSkAlknp6t6fBZGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdKCaSdJgqE3ljWDqNuC2Vw9YeeoMmkN76MoNaolgSg=;
 b=c/9yfnJYoT61FdKIA3RZtkXDjQQOlNuRkJt0+wbsMJOnkpLcrV/o0GZRXLBmdQXGk4pkGt09Q+TcJzUARt/cs/DtlU9f0QSTbmSoLCKju8QIXyc1zPCVXbGCYcbx8Kk58sYx9zmO02cYDaczvboOwqkI2+7YUk7B9s68n60TtcM=
Received: from CH0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:610:b0::16)
 by SA1PR12MB7443.namprd12.prod.outlook.com (2603:10b6:806:2b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:35 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::85) by CH0PR03CA0011.outlook.office365.com
 (2603:10b6:610:b0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:32 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:31 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
Date: Mon, 26 Feb 2024 21:32:42 +0000
Message-ID: <20240226213244.18441-8-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|SA1PR12MB7443:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ff8780-f622-4ac9-40c0-08dc371294c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0LRjpCn7+RMe0JhaWSXpVIsN0r37QE6MiPGFqhiXvXeA1hp4fXSeX90rSEjnVmNClvG/RnbWSibtd6HVkGcVKmwD7Fds2DQLdnkYuK/5QEy/WU4IJhx1tRmTwxjGjVrR2h5dwND7ortiy/5hyrI3ERiOUpgleCMkGez6Kt6k1VqEJgmbAL1v5QmeeZLAxRfghfgOxUyD2uQIBR3KXiRs/b4mTfIMtY4DtyCTFusdAWb5K3E6iNW3h1PUJqAguHFEa/aYTYUVW98+pxdLbxWsiukR2wGHrGkkZNMI0jvizs8jiEhlvhZ5qsawyQhAXMxiHvDx64ozUUmaRz2/9Cz/y9pv8whp/SaMmgTVBQNB/uukUNhwRdCQ7HxhIllLhrPQFBmbPGX0S+s+lI4+8NNOotaU4oLAOn/ai5FH3wsznhJh9pGnaJoLiRb33uva46QN/l1oKD4hSNCxccCXDRIJ//6wXXhkjmPWQKfyC7tF+daIalHgUrK+Q918L8SnnV4FECy4xqV4cn44T9BhoV+iy6ZBET8MbrPUk3eEB+HmbZjrB93bgNglDVNeDGDKezErwynZ6aaZzLiUmpXWk+jQ4IIbMsOi5MPLx5ubFyJ4dVD4msBCwL6aX2pwvXf2spl5O1mlQZDRw8M9hpfu5DPJQdi6mM+LoRdPXie6/RpDAGuye2Esl7GZGPt0sfj2jQgB1RoEfpilNmk2GtxWpn+msDiDq90ohJr59ish/qUsJOVPESt21tKlDW5pzEs0mnGg
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:32.4233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ff8780-f622-4ac9-40c0-08dc371294c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7443

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), the hypervisor may intercept and access the guest XSS
value. For SEV-ES, this is encrypted and needs to be included in the
GHCB to be visible to the hypervisor.  The rdmsr instruction needs to be
called directly as the code may be used in early boot in which case the
rdmsr wrappers should be avoided as they are incompatible with the
decompression boot phase.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Use raw_rdmsr instead of calling rdmsr directly.
---
 arch/x86/kernel/sev-shared.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 1d24ec679915..10ac130cc953 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -966,6 +966,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
+	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
+		struct msr m;
+
+		raw_rdmsr(MSR_IA32_XSS, &m);
+		ghcb_set_xss(ghcb, m.q);
+	}
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.40.1


