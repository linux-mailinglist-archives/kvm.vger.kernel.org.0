Return-Path: <kvm+bounces-5346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D024182072E
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B54E7B211EA
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DEAB65E;
	Sat, 30 Dec 2023 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZuJzSlCa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C1AB662;
	Sat, 30 Dec 2023 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoL16X+qAFGVXXca49eeyDOhVVgHK+Hi49GGmMW6l0LUV6CDnH6/5Ntu6FJJoqlxoo2IqEny/oM8+B8VqLOhtaf+pUJCZ1mE10MWbczKomy8cOGmQUaSDPsL5t4+Fs/MzrH35e8r1/mBEN29GkCfaWNlxvdp5QO1ZVXPmF/4OTe7jVhB+YtdsPOjVHDqMsYX2diL4PH+iBAIu1yJUYiYLb6HEytFWJFAqG7ol6cxxoP8HjUHEiKfYRoaOV66gJhbChP3FA40ERMsnod9Tpk0hYs7tAKYL3TjiwVRv2xCr4NxodpQzBD7/RVNkUP6oAexvdARDX0xdCp4chSfn24qZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOuzjFN27QpzXdMKytPaV0gZ1paWDl02O8pOtEiViog=;
 b=SIrvLorsRmxuIe2gz3xaQBbWePuLTQ0LrnGh4SOMB7TMAGiYvnTSV8kNUpDzVH5/AYkYLEy+sIFNjyPguo3840nMhEqAwXJk7Ob+y8zZzB2I8/KQc8kNt1ge9oWlOn4qfqcK9MUpxOiaTQRxKDONCUMAYTX9J8eTIT6sbMaV9/E01jhVlT77JfAgLfWWoFu8J2QHMLo4mvNgrRUBoszp6Gs+wRhv6+v5e0FrkfiovI0UmtRXlr32LHJyufRSuQ9P2iK+Q+4onDci6/vS9bD9p10nlSwFaRTn6rOHeYQE8oFazP5cwSgWeMRYlg7ACaA9oZ67NJYq3VrrSRxqJlA9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOuzjFN27QpzXdMKytPaV0gZ1paWDl02O8pOtEiViog=;
 b=ZuJzSlCaqZGTp+HurfBPB3F6WaazJp4MB4uMjLF+alkibhqYZl+nsTBuUhMbYtL+8QdjiuEQEIcniHIlzC09b9WGkN2wyMXLU5Qi2IZl9lb8kcgwmgpnFBdxylZuUTr/pra2phmrnfmf5Frf0TJuaxrZ1xKX+Hum0ZsS6sky4K4=
Received: from DM6PR03CA0097.namprd03.prod.outlook.com (2603:10b6:5:333::30)
 by BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20; Sat, 30 Dec
 2023 16:22:28 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::e8) by DM6PR03CA0097.outlook.office365.com
 (2603:10b6:5:333::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Sat, 30 Dec 2023 16:22:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:22:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:22:27 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
Date: Sat, 30 Dec 2023 10:19:39 -0600
Message-ID: <20231230161954.569267-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae231f5-290c-4eee-b903-08dc095383f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LuRxEJb2D2e5f4boGKuli9N0C9NTJnAM1oh1urScsnxkPnCpiA2/I/FUO0Y2uRJVprhVUz6oU54nwq7Mm6E6T1Pf+wv+gDUaAJrX9nvuOxIbh4oqkUavrleh0vk3Ye+IB+G6+MuQxTzwqPEUhBkZfwK4v7F9wzjUwk0Y+jzHRVv6P0JaoMHWhP8+wFL6C0jFvY8cTVRMPW529PqKckRL2plFtMnr3quYOvVNdEHkyiMjBQ14tVqIhk6kBZe6Xrj6ozg/MYcdYpcBg7nhEFZyE8Qb/zF2v1Ao3MQQw2ab2Bbxp+zaia2rzj5fVnSN4hOutdrc2CqkeFZCzAwg5kaOY3gJZKhNcLrg/3wtXPCXuyS89kahfdTqkxyDAxp4cMa2rRi4quE0YnXTmhgRlFl39ya7/Pdi43XCS2A9wSqG0eCu1AnZTmB40+pNe7EMjrMKiIMXG0/3FAmqRCHMctW0MT17jpE2TEwNnIoWs4bATLtlfeulfnvIE8yRhKGaE4cjqE9jeCXG4XmW/VRjYRSVW0rSuT4fnl7Nvkd+sqiJKqgYoFJosi8QRcxDRBEC4/a8Y/ilY1L2bPFZcPlcEntSy+7nCocvBR+6xlLgqvcUDQv9FdMhhKXCR5AagaYmJSFnNfk55UpfYz4IOM65QONbi/02II8+kL0d5n18E+74z7sIlmI4L8IQgOznipG9BcGhoNGm7DwcX65u+lYO4LDkkeZex3y9TsKzQmnFRMPRcSob180A6NpxfUQtcgoRjHU802tYfzzMeeLXChGOpJA9FA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(186009)(82310400011)(1800799012)(64100799003)(451199024)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(47076005)(36756003)(81166007)(41300700001)(356005)(83380400001)(40460700003)(70206006)(70586007)(8936002)(8676002)(426003)(336012)(2616005)(7416002)(6916009)(44832011)(82740400003)(7406005)(5660300002)(316002)(4326008)(54906003)(6666004)(86362001)(478600001)(1076003)(26005)(16526019)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:22:27.9841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae231f5-290c-4eee-b903-08dc095383f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922

From: Brijesh Singh <brijesh.singh@amd.com>

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used with standard x86 and IOMMU page tables to enforce
memory restrictions and page access rights. The RMP check is enforced as
soon as SEV-SNP is enabled globally in the system. When hardware
encounters an RMP-check failure, it raises a page-fault exception.

If the kernel uses a 2MB directmap mapping to write to an address, and
that 2MB range happens to contain a 4KB page that set to private in the
RMP table, that will also lead to a page-fault exception.

Prevent this by removing pages from the directmap prior to setting them
as private in the RMP table, and then re-adding them to the directmap
when they set back to shared.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/virt/svm/sev.c | 58 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ff9fa0a85a7f..ee182351d93a 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -369,14 +369,64 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		pr_warn("Failed to restore direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+
+	return ret;
+}
+
+static int invalidate_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		pr_warn("Failed to invalidate direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+		restore_direct_map(pfn, i);
+	}
+
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmp_state *state)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	int ret;
+	int ret, level, npages;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENODEV;
 
+	level = RMP_TO_PG_LEVEL(state->pagesize);
+	npages = page_level_size(level) / PAGE_SIZE;
+
+	/*
+	 * If the kernel uses a 2MB directmap mapping to write to an address,
+	 * and that 2MB range happens to contain a 4KB page that set to private
+	 * in the RMP table, an RMP #PF will trigger and cause a host crash.
+	 *
+	 * Prevent this by removing pages from the directmap prior to setting
+	 * them as private in the RMP table.
+	 */
+	if (state->assigned && invalidate_direct_map(pfn, npages))
+		return -EFAULT;
+
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -386,12 +436,16 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	} while (ret == RMPUPDATE_FAIL_OVERLAP);
 
 	if (ret) {
-		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);
+		pr_err("RMPUPDATE failed for PFN %llx, pg_level: %d, ret: %d\n",
+		       pfn, level, ret);
 		dump_rmpentry(pfn);
 		dump_stack();
 		return -EFAULT;
 	}
 
+	if (!state->assigned && restore_direct_map(pfn, npages))
+		return -EFAULT;
+
 	return 0;
 }
 
-- 
2.25.1


