Return-Path: <kvm+bounces-7073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 809A583D3C0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D1ED28B027
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57D5111A2;
	Fri, 26 Jan 2024 04:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GGH8dCyR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB409473;
	Fri, 26 Jan 2024 04:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244493; cv=fail; b=UH56BirDQ4VUTHaqRrPn0bXrOKAep+DmPB6tREEMmKygIjzBvnxiCtw0nfCKXAysFfBq17/r1xbZKRj2YkBqc8C0UZU0Zdgh0plhNf8Cpm06tQinln96jrSpLRZtbrWCnPpwmFEOaCnVn053EpUVFSeaY8CZzP0lVC3Jmtcbldc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244493; c=relaxed/simple;
	bh=P5jpzUJLafbdnOaZ/RgRnbGNlccCFLWaNk39lLnmVcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSUSanZFOE5DbHZzRIVTQG5UKaUNfhj3Y5u4Z5qCw/RT151JBTabOTxZA23By0Im5WUIUw18Alzf2WhBq9GfM83A02ffz6jWyvuF4n+CZTU12GgXzM9oq4Oztw485Fl/buTeypELgHNsxXoZWZCsmmXgPe1ihonl5sYPgWtvugc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GGH8dCyR; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G64ZnOrSQROppcr6lqYkGKhzr0wev46JbWZseHfCdyix2mJeMj48ppMvN3gQwpG2ySfhxteo5r3lWjkGBTVpb37FQPejRXF/lp0X3uWGYZL8db50lyOrJnLXM7lGuUSMmyQsyCCviIVUAv/PduReYq3BCWAIAjKpZnf6a6iM1t8kzX6LAqxkb3WPuz/KCtszWYB64lp8k4PPe84C/bejCUqY59fmum6CGHG+61esfd+MGgKXrIwJtFTJvaIWddbdbkGPK9kbjqXT92X2QKRii1kjrDIosQdw4l2l5go6mp0DnNZBw05jJEsokD6CxFyNmRO2ZVxd+v8jhdfkN6nGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvsYf0n2GxElwqDzXGtfzBBHQRJyP8zKv4HrR1SkNBs=;
 b=Ggf88ZlPHV2fsrYYhg61blL9Cq7WdJNZfAAbpe1Zigzdim7+t6CLekvRXuMVguxe3TtQIQlc688bLmGGw0R130GgGekz8vG7vczIuY1SXjuU8llc3zY+vO8WRUEP6yb9fQ16zCU6GmkO9JPIbt+cwYxgj2b5Gz8e/QvyOY5T5H7NfuhBrE1ZXd1QiiW3B2D8za7o0+PDbw31Vvrbom2ZLHfP6wDz9QbLnmqF87GnLeV99pvnMvMnS9Sdenx5WD6lzZpHtaiDMqsWpo71Oex4zIcdeul8xV9TlPjKVPCsMt4FHmseB2KErcsvDhIBywrhbakqxyjudabtPv7DEjkVOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvsYf0n2GxElwqDzXGtfzBBHQRJyP8zKv4HrR1SkNBs=;
 b=GGH8dCyRDU6+gR1YN3f3N6MrlqPL3NNTs8JFYvJBRl3RcmBZi1QYjrOtbjx/8z7Fa+fKLfm8Rx8j9e3OXjqaULiXaabX77d3iajLbxcPkzh4S6swk2NBdHBHFDyeZAwnAT4QBKChrwhlxy1DemcYtQSC2ItdSHLMAV96fa0Yooo=
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:48:08 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:3b9:cafe::c6) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.10 via Frontend
 Transport; Fri, 26 Jan 2024 04:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:48:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:48:07 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Jeremi Piotrowski
	<jpiotrowski@linux.microsoft.com>
Subject: [PATCH v2 05/25] x86/mtrr: Don't print errors if MtrrFixDramModEn is set when SNP enabled
Date: Thu, 25 Jan 2024 22:11:05 -0600
Message-ID: <20240126041126.1927228-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|IA1PR12MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e26abfa-c292-41dc-b97e-08dc1e29fdd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qENmzQTe6sSqX1jQlR889VffXysS4HfjmVtEL7fThyLTV3e+6vQiG2wkT2Z+YIe5Q25rIsklg+mB4Kr2w+V4BCwsg6QJFv9WVMzXTl1zjVUjqev9ixpV6Z5jbYXonv972TJ01QOrPO9vLdcSLeZIv5z2NxfnZRYGgy4LiElCCoG7PZc5f0svx8dTyUlm1zv5lwNOlWVkwJOeJRmLiq19XK5zUzVYOqKLG/ZqUrI+WZPEJE8sV54dcg5lArc9HE18VtFRVQz3XkDeUm37jga9PGMlH8YTT8nJP1aYX6G/HAyvDkI1xFaZbNyYH8ldhUbXK5s5A/nqjc2KTS4SFE0vPBac3KVUXGT9y6lYXWfAkX9thKDhRbnTn9WxhL72aT8uHcjQvCGl8YtgwL4HGeBIbaLBx7LE1+7ETshDZ4BBRAcH+696iEfwC9TXMMUWtkg+pFa0TgVjq6NqFROmLIXZJ1wY0CKBSNoQQgzeulde8rre1Ll4DBEKiHDD2ktdqgxdgt9fTlhRMeGZvWBiioeuVFeBlH7gdJ19xG8KuwUCrsiaI2gzcXKXt4jjPrlst8uEIOi5LWCy8U3OQjQl+sfMxW0/JqLU7bjX7XTx1A9RGDx8XRLqczsWF4uJhbUGKftWbRJ2BLqKdiwYkCJCYLQluh6VATdPhd8tr93zqT4pYPrtMV54v3dxc99iVsADB2yEARCGcdiFxq0F0FZfC5NjcfbOzlmzK14dRk5xXWiOivyityNFkSquf5V0ntvmIVwfzVpMClifTwwMg5ZwWnjeKg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(46966006)(40470700004)(41300700001)(83380400001)(47076005)(16526019)(2616005)(426003)(336012)(26005)(1076003)(36860700001)(81166007)(4326008)(5660300002)(8676002)(7406005)(7416002)(2906002)(478600001)(8936002)(966005)(356005)(82740400003)(54906003)(44832011)(6916009)(70586007)(316002)(70206006)(86362001)(36756003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:48:07.9793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e26abfa-c292-41dc-b97e-08dc1e29fdd0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517

From: Ashish Kalra <ashish.kalra@amd.com>

SNP enabled platforms require the MtrrFixDramModeEn bit to be set across
all CPUs when SNP is enabled. Therefore, don't print error messages when
MtrrFixDramModeEn is set when bringing CPUs online.

Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Closes: https://lore.kernel.org/kvm/68b2d6bf-bce7-47f9-bebb-2652cc923ff9@linux.microsoft.com/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index d3524778a545..422a4ddc2ab7 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,6 +108,9 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >= 0x0f)))
 		return;
 
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
 		pr_err(FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
-- 
2.25.1


