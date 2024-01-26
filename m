Return-Path: <kvm+bounces-7058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FF483D393
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D244E1C235CF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A26BE5B;
	Fri, 26 Jan 2024 04:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v8hHeC2Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFEC125BD;
	Fri, 26 Jan 2024 04:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244179; cv=fail; b=j0kcOrCaUw8IXd0C+0pPRpfQiMiZ6LgbXdv6S/G1iwJ0LktQgaq/JnI01I/4oYKMVNweEKcPtdzcFeA35UC7P8+POj9LIlsCSmNEfcDwW1QaUJ5T/yIf8tMYeYtMN2nrs6YzZmSHNZ0fHRu340VPxPhi6zLNbFwQ2MFcvjPDW10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244179; c=relaxed/simple;
	bh=8WG9mvX+ER3kj3ktqQI1hihoyCWprSHX96lyN1TI3PY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hs4S0S+R8QAU1GbbzNjl0AfBLN3siTS7F8zGD8JUVYGLZFyXqfa+0rGVQ3W1oLRcMGiWk+zLqwlhA7V/eTvgV3h5AYiFfDORx2NXsWnFCaltSihoteNplqlT7MkFlWFe5EYeyoEWQ4XHg4iqoUQAfBouA1R7YfrlDm1laSReKqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v8hHeC2Z; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3KHWAjOLss0WZGMPcO93hZBx4wMrFIl5x6c8R4VZDaeZKvg7sM6WTI1Y1RhuGD4yx8W2U2gb6pm95jGsj4Ck0StcIj9nlNCcIGT3yh/KTToi21eJpgumttIvTG5sj4AuroS+2l9zufe8p2ArdGAi+rX2zFte1KWp7gQH7hvHFFIq4I0uLJL9M8CYALuA+TBxLAXPlztFfyd4QBOFeVkhvDsx+nmRNMfg9Y2rsN2U81Pnhn+2CeS33nnP36vfpNq5WNTyaidrrdxiNJ5WRtnKQq9R2t7HAABa9dT9/0AfZ3nCpGz3teXthMEJIV1HnV5ISXrIn5lRHLcC4h8Kq/fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szaFyuq6iYA2lOSQBax06TCzQzV99C7hyp/FnL8i7Hc=;
 b=Syb6hp+01eXb9Kf8lTtpasYkhYeUv+BkC5eUJKc/KRODblm2lYxyoerlh6HEk1R2OAXQXN2qBKdtE6grnlMbdTplkT1jSJZGGLK4entwZ2Y4suxYOFJbOEtM2xVB5JbULKtZQ/MXk3Edsnc+7+6bWTwuzBgsDWhTSUYmJsbdnFAh1xCmYo/YDv8xEuCK39GxYh1nBz3k8DMpxjDdWpDVRAmP20J6bB4f+8dM1vjXqEP0IIeyr5ewTrCpk/FDHI1Qb5YEGoEKKryHh+f6QU17aMMq68s0Tc8ZXVVUtASsx/R7LTv0x0eQbr9/kaqPgRBNP/jtfOYS4hCGO6krVcjuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szaFyuq6iYA2lOSQBax06TCzQzV99C7hyp/FnL8i7Hc=;
 b=v8hHeC2ZdIIanohNyWdlhUZjGeSkSMI5qQZ7fV/BdYDTMknwJ0ZeTPUplf68QasTPI+cyEB9FpjCD4JYsw5Bftu+Xhl9xR+iJRpNKaKX6dzA6Z2ABvX8uANb32EUz/3st4lUNINQg/cu4Ks+dVwckXBUKWBtgCljiK2RNwNLkoQ=
Received: from MW4PR02CA0028.namprd02.prod.outlook.com (2603:10b6:303:16d::7)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.33; Fri, 26 Jan
 2024 04:42:56 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::9) by MW4PR02CA0028.outlook.office365.com
 (2603:10b6:303:16d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:42:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:42:54 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 15/25] x86/sev: Introduce snp leaked pages list
Date: Thu, 25 Jan 2024 22:11:15 -0600
Message-ID: <20240126041126.1927228-16-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|SA0PR12MB4543:EE_
X-MS-Office365-Filtering-Correlation-Id: b8048db2-57b5-4e12-66fd-08dc1e2943cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hr7bMntL6Ht3VXhxEwbcLo8pEpeNGsPsvPPPpQJXzNGfYzxT0+SECARMwBUcFeGQ95bjUlnIGg4VQJo6GoAaG1qmQv+SKnrQ92zKzGAK7ND2qIutYu1D7dtgWTlBzfKbs+W+75EYumDz1vFrGntvjKTj/nkIcGf9+DDZEVkZELSUQ21Vqygh7Z2yxcXqKqHaQSs+O/zZmcRvnzP7j3/XBHt/HxX9WGDZzQYADL0zmQj4gLeDlPVVLgRnL9y66QPvyT6wrL37+IxoWcGShg0I3u7zqrO71xe1j2HUqzQ+U4aZBIuq4AP8Mv1qSKUO8lpfCWBMy0LO7fNFCCKTeno4hyKGX17YOnJI5DHsRA9Yn385qWXhdQn4O4trVT0/+MiTtGHMdt1zleltjwnSUYBJnKJRmnMRzfkIuJFOmbNDnDvnz6mupgFs8uw1Wb72+yncGfH54hB31TVQ49NI8N+CPPqy7vEic6wodPdjzl1ZmHxrU/Ns9bSCK78XNwJZtolMchgKt/7g3ug5kCN4gwxzt1PoBofW/UDS39B7cSY2j2KYnv8lK0ws2Qcwki5NS7OiZH+2yvcoDVjHBDC5hpHPH2STzWtI5zWw8QHSo/sf+vxHHrehp1EgEnphhYWldqE9UD9dO9qfN474SzAzyLbPvnLqtBUs8aQrzlg+80U7IYI6K0XxHQktZBUkexho/PzyhoUagOJeexZKciE9ITY0GEliXVrzsx8d7cUqO6l2QJHF6Rmt6VdiSA/0LWSIWMQT76BR2N40K/RlU573Pnv+4w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(346002)(396003)(230922051799003)(82310400011)(64100799003)(451199024)(1800799012)(186009)(46966006)(40470700004)(36840700001)(356005)(81166007)(82740400003)(1076003)(41300700001)(2906002)(36756003)(6666004)(4326008)(40480700001)(336012)(40460700003)(426003)(8936002)(8676002)(83380400001)(26005)(86362001)(2616005)(70586007)(70206006)(54906003)(316002)(7416002)(16526019)(6916009)(47076005)(5660300002)(7406005)(478600001)(44832011)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:42:55.8323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8048db2-57b5-4e12-66fd-08dc1e2943cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are unsafe to be released back to the page-allocator, if they
have been transitioned to firmware/guest state and can't be reclaimed
or transitioned back to hypervisor/shared state. In this case add
them to an internal leaked pages list to ensure that they are not freed
or touched/accessed to cause fatal page faults.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: relocate to arch/x86/virt/svm/sev.c]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d3ccb7a0c7e9..435ba9bc4510 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -264,6 +264,7 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void snp_leak_pages(u64 pfn, unsigned int npages);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -275,6 +276,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1a13eff78c9d..649ac1bb6b0e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -65,6 +65,11 @@ static u64 probed_rmp_base, probed_rmp_size;
 static struct rmpentry *rmptable __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
 
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static unsigned long snp_nr_leaked_pages;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -505,3 +510,32 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	return rmpupdate(pfn, &state);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
+
+void snp_leak_pages(u64 pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	pr_warn("Leaking PFN range 0x%llx-0x%llx\n", pfn, pfn + npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+		/*
+		 * Reuse the page's buddy list for chaining into the leaked
+		 * pages list. This page should not be on a free list currently
+		 * and is also unsafe to be added to a free list.
+		 */
+		if (likely(!PageCompound(page)) ||
+		    (PageHead(page) && compound_nr(page) <= npages))
+			/*
+			 * Skip inserting tail pages of compound page as
+			 * page->buddy_list of tail pages is not usable.
+			 */
+			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
+		dump_rmpentry(pfn);
+		snp_nr_leaked_pages++;
+		pfn++;
+		page++;
+	}
+	spin_unlock(&snp_leaked_pages_list_lock);
+}
+EXPORT_SYMBOL_GPL(snp_leak_pages);
-- 
2.25.1


