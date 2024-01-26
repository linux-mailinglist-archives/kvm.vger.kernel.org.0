Return-Path: <kvm+bounces-7070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5F783D3B7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADAF91F299D4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E53CBE5D;
	Fri, 26 Jan 2024 04:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g7M43fZ2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30914271;
	Fri, 26 Jan 2024 04:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244429; cv=fail; b=Y5oxP8cJVQ+9XRGqexrKjENNOTIksfKKxwySd2FdZ5++27PPCn/TOo22Xr7BJubI0UZ5chHhgM5+yRXsyAT75uNDe9RdBlPT/RPlRNJVDZUtZk4bJkfsL5OFBo/2TM4oGM+6eghz9d2BgJTVP1Nkwcfla0S4n71DsPwpkOa/hdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244429; c=relaxed/simple;
	bh=PNdzzfGx9ahSVL9ujRxHwj9+OpHXi2TWOg5j8N6Fcyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0II68Bi70u0N186YLVSf/LKqaoztp1cffbGipgp/+V6hhz2e2RaxdwkqeUWaqB6NZxGixponA1j95Iqk1POp/zCDRhF9dI2XywSsRkEyZWXsGwxCyuiXdDUDOQ/Px/tHrH0EBkUINVm4HiHfRo1N5Ttx8h76nnb/lO3fF7zyU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g7M43fZ2; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1DTrrrnFBhNV5pH5i1/g1svc2pOWwA6mbno5u1u6jQoIR6X0OEXQcIq4q8qHppLbdtP4qBVIDCkRf7pd+/6thOxS01jXqfIiseR9qWTRUuR/hBS46Lwgwjf1BjTBhAbLmbf2ZyMy+TX4Io/FNJEo0lQAitTEvnFytN88LDv9ezeLMvwOQ50FCQLreCHl16wT22YYGTAoJBmltEdqICt4pc00thAsF7rJDPQ7CSBhordYox9tsYc3S3bnjdWeRYDYm3y9OvVK2fF0VueFPlDFUCFO9SIpJPrG/f+fk/qtqSgdEQCFYhBfhypzcwvT7m8IquQYRlf9othIKxD+MxONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42bfQ6FeSVGZCam3Ke+AMjdPhfDYAoqjZO55LNOmw0E=;
 b=FHx2D6PZoZd8AXxyflBKlaH7SoO74ERApwJRBbmy9goF9e58cFXg2Ro1GEFeto1b6o4j7ibgiJU//CLQi6EwYImXRozUXK6Cx0YTVOkagw4UToeOMnYLVzbeI3TQVXjl/q614SqMTuR6cfq3dosla2rCBm7xHpcyoU0WAldsNE5UtjC49qikHUaKNrSdHsjZQzJQF19rf+K0LNbIYwgnqBNOoXiEqw+OkQwPdH7DmyFJj5IOHKv5yCHFhro0eM9lMqXUHfDE86H4kyljz5jcnrIv2p8QbvYJwmILa/szwTpbco9oz1I0EoCGfwvlHOcpV7Wdi11Mfo8qtV9sVhwPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42bfQ6FeSVGZCam3Ke+AMjdPhfDYAoqjZO55LNOmw0E=;
 b=g7M43fZ2184zswG+joUmgvnGGK+5ZAgKnlNvpuK+a/RFJa3hn88deiXQ9UJ71uZt69heDVoc2Q7Np5FCKsG7XmfhEeX8KX/Vh5BZG71VgMAswvMI0L0rJ/2xGTSEKTsegaPrZburUjZwUvs6hyKzrdZd6Ll3j8WaS5gX36mme3I=
Received: from CH0PR08CA0025.namprd08.prod.outlook.com (2603:10b6:610:33::30)
 by BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:47:05 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::93) by CH0PR08CA0025.outlook.office365.com
 (2603:10b6:610:33::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:47:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:47:04 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Kim Phillips
	<kim.phillips@amd.com>, Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v2 02/25] x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled
Date: Thu, 25 Jan 2024 22:11:02 -0600
Message-ID: <20240126041126.1927228-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 75451af7-cfca-47bc-91bb-08dc1e29d834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PPYG51viIBgn3zzeikdi6PnXSoSYJYqYcUwGNM7bWLs/PMAfI/4RLnOjnw99COLAewhy6+XExTVpGi8jLR/fTeZyEVz05bKCIxAr56XQkzqWzk0NF9hWNYDOHxagxJNde3EBpy+SE991JzXL3qAlwJBtTgniP0NSwhhX5HJCT6F2PLCYnc7a3hzy9fn/BRuZihVqgt2fUVivFY5jM8SIOqR/LkmQyDDGXks/2VfUG9RNl4YpCOxDeLzff5+08VlmhfrON3/FV09Hl1SQLHliPVfnCrMq0BArPOjtrWS10EfG6MU/Fe8D/WPvRSHFNomxSedKlFNyS7qPEx7mecZmCkyzrZQE48Pc38kc+a2Mc+NHsT/tPKQgMcJYDnOh3+M28c7kBW4iVb7BraGGQKeVyV3uOyA11EjNdiuVYvfcfkNvA8/0kqc0dHX1YdvBNxNYfYoFZ1L//6vYY8VziGN9ebNOviIT08MaNG6mRdGvnIJHw6OyNIpi6rByr6K8PR5CWjIVZhkoNDBo67NnsAsED1iZTTqtfjyHeBK8QSxTfmaotsXXF5tum6c4LOrIc48dNLLzKIxWY+3Gsydq2pUl+ggB3su84F6UslVfJwuf30DX2E9rAnMXKONaXpN8gJidQvj0W/vdvtQJg/mXg1U947M6g/n2DrUMbOPhwET66tQ4qsA8b4eynvtca8OtndfBXrnS9XdvNrM9HvMyCwPRchDgDVAtdz5K0c5Tc1NfNMSPIVxOW5qGQR0bfh66CEFD3UIb4z+/A9RpV+F91kaBLw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(230922051799003)(186009)(64100799003)(451199024)(82310400011)(1800799012)(40470700004)(46966006)(36840700001)(8676002)(7406005)(7416002)(8936002)(4326008)(2906002)(316002)(70206006)(44832011)(5660300002)(86362001)(70586007)(6916009)(36860700001)(36756003)(47076005)(54906003)(356005)(82740400003)(478600001)(81166007)(2616005)(1076003)(426003)(336012)(41300700001)(40480700001)(26005)(40460700003)(16526019)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:47:04.8802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75451af7-cfca-47bc-91bb-08dc1e29d834
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995

From: Kim Phillips <kim.phillips@amd.com>

Without SEV-SNP, Automatic IBRS protects only the kernel. But when
SEV-SNP is enabled, the Automatic IBRS protection umbrella widens to all
host-side code, including userspace. This protection comes at a cost:
reduced userspace indirect branch performance.

To avoid this performance loss, don't use Automatic IBRS on SEV-SNP
hosts. Fall back to retpolines instead.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
[mdr: squash in changes from review discussion]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8f367d376520..6b253440ea72 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1355,8 +1355,13 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	/*
 	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
 	 * flag and protect from vendor-specific bugs via the whitelist.
+	 *
+	 * Don't use AutoIBRS when SNP is enabled because it degrades host
+	 * userspace indirect branch performance.
 	 */
-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) ||
+	    (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	     !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
 		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-- 
2.25.1


