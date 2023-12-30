Return-Path: <kvm+bounces-5359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F662820755
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8263E1C21437
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6BDCBA45;
	Sat, 30 Dec 2023 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JoL2spqj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F814F7F;
	Sat, 30 Dec 2023 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=US/TTr9kFabWWorGOfEian9dQ5vwKsQtFCsKbqEQpCK+6TzhNvP50lCQMZznMhuVR/FaOX6aofFTGIj4k7dQOcQ81i2yilqhE/3UoXCouC/tW81j8WDsw9Vuviom+jtQNZ6r7M3BzolRDwxZ1dBDSXSAorP+6Qfpihugi5B6FEWnzzi2fQhJQ33cqd2YygsPVtuoZoqWV/ZJnksfv8kp08swzKDRI/ik1S+3NPtJnWAtnuUlStYcp+cUPNMhPanENoCcsZcmYET96pwAKTZeF5zov4iSadZjR2Gprqvv9+iBJdH+woenoM0SuVMTSaMPVKHF8+VJBieIQVXWnjMNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kAUVL5Cnrne8lfXqEnlYpDIUVTDcWGqObX7dXNuHFA=;
 b=WfFOxOMOc/gl5dhKyOVjM9alV/Fn1mIzo57mZjyyneEVzeMAG3uh7LzvuXmWczcHjpc2MKDd/iGs2LjTGjxfnO8ZUU10iTNmc1FHQvZKiBf7bUwN2EwB020NReI4dGWi+Jx01PseZnr4qK3SZjyzNQBAvdIgOvjW8n54uqcJ/zM8hMLQtNwGZsv+fwnsDeT8I7RTtQ0VBud492VerVYyiPZuln7k66VcIk1scC+dHbML3J8dKvwXq9++jbyaDSr+ckc/tnB3h/Qa6VO7t8efS7Do9AIe88ozUKBUj56SxeYwOb/pZ3O69XD26cuCocyv5PvBctzJbKPyPAxR8DNVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kAUVL5Cnrne8lfXqEnlYpDIUVTDcWGqObX7dXNuHFA=;
 b=JoL2spqjNL+1Gaz9sJsEK5gKUOz6ATfxIvucuRJbRPvdTz7/S5cORLdf+lfZmhZUeDGTl5rSf4bsNtg08H5ahUXGalw/WkUV7dJ28MZuvtwa4z6sMUxH7haGJjmnC5O/Nf4KaP2/3FvKVxAIG8hBPr3ML2UDSFFZQXKv7sA7Ifk=
Received: from DM6PR06CA0077.namprd06.prod.outlook.com (2603:10b6:5:336::10)
 by MW4PR12MB7481.namprd12.prod.outlook.com (2603:10b6:303:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 16:26:59 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::46) by DM6PR06CA0077.outlook.office365.com
 (2603:10b6:5:336::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:26:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:26:58 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 23/26] x86/cpufeatures: Enable/unmask SEV-SNP CPU feature
Date: Sat, 30 Dec 2023 10:19:51 -0600
Message-ID: <20231230161954.569267-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|MW4PR12MB7481:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f029b1-4130-45cf-1d1e-08dc0954255f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p1HhkywFCAEpqDjelHj2ZGxlEno6mQe0uEG0hAQsyGJ9eM3d6SGmYZ0HJWJp41eNu5/L5gZfsmO+StBGIX/2UiSeMVkd82E9kU7yDiGwK/o8zVbpqMypoF7Wl1REDz4kj0GrmrYoy+RCTkCJXVWBngPCt7M63Nbqj03Q2kem4tW2/0bnQq7V5KYZLLI9McDlMgUQaOfofnSGgxlqI1s1NjXNzUrdfpCHzeJpYI+6+MmnSDVBdFaFvuaPJperUlCaDCSM40FFrAnl4omRqaLOF1BG71zLbTqJaeoEMnbPgY+MrZ9ob41Z3njAwhdoTkaA334yXS1KHXvaCx8ro8ptpVqA10upkfXQ8Gs19SqBtpf1zPaMof74rnAnKN0enxnM2iAHrKc61cBSO1Op6icBk02Rq/Huu/DKGQjqnlaGS4m6M1h7AedmnCJ+7NRBXKQ2qrHM9H94EY28E7U77e77uI6lXjPb6gb1NJLSTNEQ32fu7bd4zFSmRujE3qw0LD801yLtNP/Ghn2EsJarlEaUQwN7oXJIxGUOxKe+vW0NV5Zhz2NI8ehQjnZMrCorXXR79aTto/nJKOmVhr70u/0WYrnbeiB2NRQbAAsS2cGn5cixuJlK3noqzQn2avIQsKrV4LOiaLGec76CrCyekksyQFxDMdi+6PMakiVPKJaG2MnI1126nRmOja6OYxUtnzx9usucUjHPOACDerHQtWFGH0entG0gM/BxXHTMGqZdC6+945cW3Rlg35a5d7atTlXIipU/STVkxttZ3rgfQJGqPwOmPgzMpDd4+vyi7neWL/pUWy6S7HErsOxkWJMesJr1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(36840700001)(46966006)(40470700004)(336012)(16526019)(26005)(1076003)(83380400001)(426003)(2616005)(6666004)(36860700001)(47076005)(7406005)(7416002)(5660300002)(4744005)(4326008)(44832011)(41300700001)(2906002)(478600001)(316002)(8676002)(8936002)(54906003)(70586007)(70206006)(6916009)(86362001)(36756003)(81166007)(356005)(82740400003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:26:58.8035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f029b1-4130-45cf-1d1e-08dc0954255f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7481

With all the required host changes in place, it should now be possible
to initialize SNP-related MSR bits, set up RMP table enforcement, and
initialize SNP support in firmware while maintaining legacy support for
running SEV/SEV-ES guests. Go ahead and enable the SNP feature now.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/disabled-features.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index a864a5b208fa..3332d2940020 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,7 +117,11 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
 #define DISABLE_SEV_SNP		0
+#else
+#define DISABLE_SEV_SNP		(1 << (X86_FEATURE_SEV_SNP & 31))
+#endif
 
 /*
  * Make sure to add features to the correct mask
-- 
2.25.1


