Return-Path: <kvm+bounces-5350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12BA82073A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 795992816D5
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CA514AB9;
	Sat, 30 Dec 2023 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nzLcd3/P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4661428F;
	Sat, 30 Dec 2023 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsGC/hPGNEFBhq09hVKjCcs15yOjTfDY8ZPaYRKDjpJRt56LUCf2xhNPxKbWJ9fwEB/UHROT7qr1S9hhEbiMy+3mfVYE3DklXZIbREhVMNn0IOvgHFQi5cF0K2eDGScodqe/QkLtSR+O8sXA1LPaB45D2/9/gdrfMgd+npGWIMoaK2SocleTra4mWUjeWuy18gWIALbYCfdHILQ8bTN33n+Eg9Ls6mS9cBVv9FjVo7RQw9Q1pP4GDmA+//B281MZOy/ZoO7NPkEnuHV3ZlBgPvS2zKAsGbh6ZLb0da7oS5kWjb5eygLWlyeGwlJ4K/o94VyBaEM+K/GsQDT0xh3RhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AiVvp+np7A+xrED5Xr7DhTlkRvWTwZgGfMO/veOUKsM=;
 b=FNk13BP113SR0fjHAxaOSSm4V+dCaoAAY6IMw66nHW0NxgxQzIV45kbwSKB+VwV+Qj8u45K/5EVPzoVurbJOA+3j8H/nEUWMrYKXHfOL4VtLbMBWYQEnvFOUV9eTtoxY6WhT4gCJdHdLUVVQa4H5DPPzNyFseksiPJk7dW/gTGquxj4ypLq2QI/HNlKn5OCTQZv73HqYGu6uF0zwItXWvU9WosyCkvsf/rx4veNzcIO1mV6tzsT5MMs6YV84SrJo1r1XPwXpjqqgtaW0lrkZRESDGSI5/S2RZ/hXepGXBQp6bQIJtktUe8gk/y+Xxj7J5Uh9Ok2rnb/6W3rOSLVX7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiVvp+np7A+xrED5Xr7DhTlkRvWTwZgGfMO/veOUKsM=;
 b=nzLcd3/P30gySK0fWmLGafwBAFElCemdelDCU4GUXVMz60SkdjCFGOJA4XtkKiHydiqiugFzt02oEO8vEuvtWAcrWqAEZzr9SWD+J4Ow0tO7OvTK5TFYCyXffyYGNHLZmTO7lxiMScyucOdb0M0iSuc+BF+WyCtZfJBR6BeV1qw=
Received: from DM6PR13CA0016.namprd13.prod.outlook.com (2603:10b6:5:bc::29) by
 CY8PR12MB8411.namprd12.prod.outlook.com (2603:10b6:930:6e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.27; Sat, 30 Dec 2023 16:23:51 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::be) by DM6PR13CA0016.outlook.office365.com
 (2603:10b6:5:bc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 16:23:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:23:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:23:50 -0600
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
Subject: [PATCH v1 15/26] x86/sev: Introduce snp leaked pages list
Date: Sat, 30 Dec 2023 10:19:43 -0600
Message-ID: <20231230161954.569267-16-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|CY8PR12MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: 09363be5-f9e1-44a1-c6a8-08dc0953b5a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dJcooFPE4Nx3IM4yDP3YucBYaZDT6vCL3yXzJgh1HOfYG4x1KxnGWWX/1iZ7QNH5BkH5cWpmFmtvYvjG2ZIHCZljWZf/inSu3vTmufS4799ywsI+qSzRVKfKie4juSxRaEer5MYdQudlBa6Y71mnJDxJdwR+Wg9NWoE+px6o7eJfYVk60oRbvzZicVw8N+H0Xr27EqMPF+nyn5IDYc8dgmJpoBgM2hkNhkYI95x7VBvz9X0s6sz2XN56rl3ibzcxHuS2pb+YeVFHvp31LYgPkronuRYEfzDZunWKI4gT5Isow2hrTg0iQRPlqRh36hjq2cihucPYKQ8iS9wOBaGZpsIG31qjNGnsvURsuOQh9nkzZULCFHRRRVe6Z1Rea49iEIVYKS5y3eKzYzs4PgiuybJYku24Kv30KQOz9S5c0RQCmRQR9fAH5PRW6dYn7F+8+y07+n2d0yc+283WhZ0/ZftUN0JZAHFRUm44oy/EAtoN1i//4eMeegAAjnoaIELjyDulcMeeWrdCAXsxtcikcnCZkT6thcUIQckurKPKgjy4mOi/6lY4UeO2PeNHSQujlg/gWOW0VIPbPQumXRN9CKs6fft46PoZHbEtGhgZwZDcntujbzaFXbUA2jimf+eAZ7ULtM0zDqITe+hFgtDHbJl7NjhPA2swO4zgqTPXd+SQJO7ETPvQVhNx4UGPDXGVNPfm6RZjtcvYyVh15gpp+jmT3pWTVj2PRWfBmjXIBtx5KeF1uX9FRLdh36mvd/caU4xhsM9kOv5n8SjVHxTUig==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799012)(46966006)(40470700004)(36840700001)(40460700003)(16526019)(426003)(26005)(336012)(1076003)(2616005)(44832011)(83380400001)(5660300002)(4326008)(7416002)(8676002)(36860700001)(8936002)(6666004)(41300700001)(2906002)(70586007)(6916009)(316002)(478600001)(54906003)(70206006)(86362001)(82740400003)(47076005)(7406005)(356005)(81166007)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:23:51.3331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09363be5-f9e1-44a1-c6a8-08dc0953b5a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8411

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are unsafe to be released back to the page-allocator, if they
have been transitioned to firmware/guest state and can't be reclaimed
or transitioned back to hypervisor/shared state. In this case add
them to an internal leaked pages list to ensure that they are not freed
or touched/accessed to cause fatal page faults.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: relocate to arch/x86/virt/svm/sev.c]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

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
index ee182351d93a..0f2e1ce241b5 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -60,6 +60,17 @@ static u64 probed_rmp_base, probed_rmp_size;
 static struct rmpentry *rmptable __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
 
+/* List of pages which are leaked and cannot be reclaimed */
+struct leaked_page {
+	struct page *page;
+	struct list_head list;
+};
+
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static unsigned long snp_nr_leaked_pages;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -476,3 +487,27 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	return rmpupdate(pfn, &state);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
+
+void snp_leak_pages(u64 pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct leaked_page *leak;
+
+	pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn, pfn + npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+		leak = kzalloc(sizeof(*leak), GFP_KERNEL_ACCOUNT);
+		if (!leak)
+			goto unlock;
+		leak->page = page;
+		list_add_tail(&leak->list, &snp_leaked_pages_list);
+		dump_rmpentry(pfn);
+		snp_nr_leaked_pages++;
+		pfn++;
+		page++;
+	}
+unlock:
+	spin_unlock(&snp_leaked_pages_list_lock);
+}
+EXPORT_SYMBOL_GPL(snp_leak_pages);
-- 
2.25.1


