Return-Path: <kvm+bounces-5394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6AF8207EC
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C20283D3E
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF72D2FF;
	Sat, 30 Dec 2023 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DAsba546"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E7414F6A;
	Sat, 30 Dec 2023 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDTcXQ+2O7QDBv1i77UUuEYEc66y7VvCYmZxqmWQjYnwqSbvMZptHp3o782A6Rr/fhhYc0c2VDc7MNbjJP2cKufsvotl1aotyAj3cxyZ7unwGcNVRDPnI6jo5oSv9hUXJL/IgHfDTrdp44WG4KJzvmlBrPzbFAq4Xk6ZV3OCYNKo+Eu+u0F5lAALjZc9TACw+zV63Z1y1OCpKmuUTZX1ZtpKMFDoUdCgtRzIi4QYVGwlby0kEHjsptTo3F/ai0omz0BG2SxMFvJUY6KYb3J9NhVe44AS5yDVJw9jdHgkJrT4tmwQNTPoXeRmndeOBOTUu3c4iAf0FKzakZNwF86O7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xi6JDzTfmVUpA1y8LRyTqKgiLlYzZFnL6ITEUbCEECc=;
 b=KWLom0F4lpyWg21uHrmGLOjSz7lDDLJcYTRIPGO5Jkv5baFAldccFFiPw1yiHE9V5FbAzODkgySGgegR/eaT4VJg6B5pBPa4RwshKC6usEBji/1C+wR7fEmkwtAbrHvmeLkOo8SCEWFS7VTETc5PPq7tqCvk76QOm1z7SgFFaUS3zcH8mXASxEOXruDma5on72vwlwwu/vowJTZVIUyeiwbvuGh/niDEqdWBshr0wZrSGVXMRfRuEMwXvChiXmKNB0pNqoIHO27slc2e0Dp+/PVkyzphMwEePe29mJuF7EP+NC0aRQzNO/uC0H0debZeMshBSe0rrdQnveoIEhVrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xi6JDzTfmVUpA1y8LRyTqKgiLlYzZFnL6ITEUbCEECc=;
 b=DAsba546ZsEnzmb/WMYPU5PyGXwpzSytZwvD67to0RMdpuBr9R4yA+DgZBZLJDlQY9l7h0KePtthU2x5yiqSS+e2e5WF/ggSZO9orEjq848xKnpsHtF+twycGEzHFJkrS2ulBjEH4v1GZ85j355sNeAFlrhrYqiqvcrcSxwW4Fo=
Received: from MW4PR04CA0068.namprd04.prod.outlook.com (2603:10b6:303:6b::13)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:32:42 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:303:6b:cafe::ea) by MW4PR04CA0068.outlook.office365.com
 (2603:10b6:303:6b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 17:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:32:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:32:40 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 02/35] mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
Date: Sat, 30 Dec 2023 11:23:18 -0600
Message-ID: <20231230172351.574091-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: d07f1a2e-047c-45c8-2309-08dc095d5383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A6wr6M5+B73F4sbAdk5nB8wcN4EFYF6GThu8HAg9mqZKR1SbD16Ur+B5aJcMqXu/zPw8TgueSxb/elf5Nb57VuWvGMP+4rVWWC2j+id9TFxXo8xmn12lAlWL4bIZNnTJsxH/TmdVm0aJ4v9OTGulA6Yf4XR5VBgSweL4RLOtNC/9ZLojlIIdpd3kZK8DsFtiM/irZQE0gv9oagxO7GxvM6DHevWrjm1mZdLFYFepqPVt5BhR6dG9r1A1ulSsWiGZH7gfHFXaY6QI7pm0GgLwEgeu13dFzHIVudQhIck1HAp4mieQPHVjml9NhXXzpHoeXXuMLh6lxFCCUWSToSXio8Ks8ezkOsh5JJgsx+iF8dshI0cU1bWV1iPlGSHHe3LjcRY5/up7ah7hM/3syDN/akWEziBhR/pL4VXDAnWkPnXhHRshBKDFeD5l3W11BNea+qaMK/EaobB6T0vf+6mV7LtlvhT33MZm4qCxMCpWphSyXfHu3mhlbnAlc0K1zPVIA4rACZGVcnpy66YkE2dGaW7KAbkIt+fh3itmNdsrabdLxtZj5+gTRtXOgpa6EPwlDqQ2/X7od0xbchyWeBNHh0TkcEr7NOQNRtxVZAyJ7804gVoG2AS+jmKXV++8AN6Xf+NU+HFvC+wpCqUUvkdIdkp5PlKPK1ePPJofZ2yjjc/w4scGUHtikALYESk21tlzdW+nCw6cYd9fd2oxfd2G9or9p1tUmEd2I+p4iFxEM8XwuX9i3iemUnmLFfrGfSWWk0a1zlQT4iQBIfflqmxPfw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(966005)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(81166007)(54906003)(70206006)(70586007)(6666004)(47076005)(336012)(426003)(16526019)(26005)(1076003)(40480700001)(83380400001)(8936002)(8676002)(2616005)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:32:41.5760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d07f1a2e-047c-45c8-2309-08dc095d5383
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223

filemap users like guest_memfd may use page cache pages to
allocate/manage memory that is only intended to be accessed by guests
via hardware protections like encryption. Writes to memory of this sort
in common paths like truncation may cause unexpected behavior such
writing garbage instead of zeros when attempting to zero pages, or
worse, triggering hardware protections that are considered fatal as far
as the kernel is concerned.

Introduce a new address_space flag, AS_INACCESSIBLE, and use this
initially to prevent zero'ing of pages during truncation, with the
understanding that it is up to the owner of the mapping to handle this
specially if needed.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Cc: Matthew Wilcox <willy@infradead.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/pagemap.h | 1 +
 mm/truncate.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c2d90588c0bf..b56081a3512e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -207,6 +207,7 @@ enum mapping_flags {
 	AS_STABLE_WRITES,	/* must wait for writeback before modifying
 				   folio contents */
 	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
+	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
 };
 
 /**
diff --git a/mm/truncate.c b/mm/truncate.c
index 725b150e47ac..c501338c7ebd 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -233,7 +233,8 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	 * doing a complex calculation here, and then doing the zeroing
 	 * anyway if the page split fails.
 	 */
-	folio_zero_range(folio, offset, length);
+	if (!(folio->mapping->flags & AS_INACCESSIBLE))
+		folio_zero_range(folio, offset, length);
 
 	if (folio_has_private(folio))
 		folio_invalidate(folio, offset, length);
-- 
2.25.1


