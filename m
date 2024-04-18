Return-Path: <kvm+bounces-15135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 052F98AA308
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF288286FBC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB8F18413E;
	Thu, 18 Apr 2024 19:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ByET/fty"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9061917AD72;
	Thu, 18 Apr 2024 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469346; cv=fail; b=h4PnkGR3TtZzxwbpOvj/oBygLWEwDS8svL5lhzS1jsncdZEQNq94VjkUHJtoN4ulcH6jIJS7L38IpaBxrhayaEuv63rntehE7XZM4WHYD8m12vJS38ghhRkRKiv8qh6z+HmSqMDMz38B5DCB13fvksIkN6lTVgJiPJN2LUeQE6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469346; c=relaxed/simple;
	bh=RJKWEK3dDbWxs/FkNQoIK5dRBnTfv8xJC20wlZQT18k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NEaBVFjnI8REWds7blYaNRa/Pq5xTdAJw9haxGZdF20paxC8tHIZgGCMkaCAEYolEjSPR+n2XQJmNDHmF3ju3hxjHgCPfM2nh78a0h/X/WxZHRHQDSvvMeRHTHXOADXMIAnVfaYnyLzMqOousKYs7jlbI4gJNRV5cL6b3Hq3Sgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ByET/fty; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXXzt8QTjR3dILyPoRV9avROE3+sUurCydvbl0+THxzBDWl4F20rsFqodIRGDYmL7agWIGq54Xur/QxUTRYn4tBdJzm/3KszCQhyCJM/csa4G6x0udYOIuZLKT798tNHpRau+BVYXHXNW5P6TSB3AjtggcMAk/oJ49LoeeQMU1ShOVbStGsCgv/zFS0DJSqvSz1+Wx7zrKKjDcnInKegYLzz8rYRcCfiMAtc755sGMOCaKjRiVd0PPi0VBP2G6V5dTxuDS9U9A0ZA0SyQA5AocpDjPhTD06UbTSkgB007fEGFKBxc+6K92j/RjjGzGnUQ0UO0KWAHsz+eIcvjb8/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COQvOCPPz36ySA7UL+Y6YjQSSmYCvpSNn3OqqsJv6Vg=;
 b=m3Ri7zqMkC0NE956mtVVhfVvF9fn0Hz42LOr1t3K8nFkYatYBclP9rPgZp2JOmDPlwj2+fNxbFbOXkK9um9I8vH36xmRf9LVvJDxSmSrWOk4guZxT4GLPRKk0igxG/51O9tovg4PnIFA9Gcww8ieO6BgMti2fBZ6uBgOnhJmohdwo2cT1mek0yuYXrsrVKVUFot6YARVrHFOBT3ppuEUB62RVdSaeebpU9jTE4Loh4Jhgh4EIUfNgS9aQj0b+xVkM9jA6bU5pY+N7FbPAI83U2jVOt+D/bAh6f2CF+JDb+gqmfAE9IqhBAKCNOjWSYz4g9+Lf94IbLrWFCrfjyTNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COQvOCPPz36ySA7UL+Y6YjQSSmYCvpSNn3OqqsJv6Vg=;
 b=ByET/ftyQVhqXKSXB7bUAETO2VYfcvyxvJZXsE+SH7RxXu2dcul2eth2jBQrLwssW3Qm1m/et9PLsvRoPE9qkkY8efK7OiXfyR/nwcggC0HL3/TyPxBJ9LJmxiCq6OsxBRnqd3pAvoeeTtA3kedqCP6J/3MgP1T1N1PjmUGJ6W0=
Received: from SJ0PR03CA0350.namprd03.prod.outlook.com (2603:10b6:a03:39c::25)
 by MN6PR12MB8541.namprd12.prod.outlook.com (2603:10b6:208:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 19:42:20 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::f9) by SJ0PR03CA0350.outlook.office365.com
 (2603:10b6:a03:39c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Thu, 18 Apr 2024 19:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:42:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:42:18 -0500
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
Subject: [PATCH v13 10/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Thu, 18 Apr 2024 14:41:17 -0500
Message-ID: <20240418194133.1452059-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|MN6PR12MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e935b6-383f-443e-dda9-08dc5fdfa932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qyu7FPoupeHtg3kkeAlI3F6nTiCIdEvo5ThsQaiNaFE+yDMrzfCZakb38ml/AZXmZ3PiVnww0jPHZGXKVRU349pzEKd/Xvbs9033m+0BH8tUVj4yJ5QhqJGHtrfAWttx7yvfJlFXSIeCW4zM3NPdWgSn7ZBWvBeyE0pvEALz8qtAGbJt8ouXTuEcU5oZ5nQ7H1XQsYI2TFEq8npqE544crPSt+gYShCieH/FhRSrehE2smH8UKOEaCLXUdjUOk7r1NWy+v8mmlDxeQpUFiKXnjUUZqg0fcOP8dpus9eDgf1VY5DYixju6LVRzP6u+azKV1DU52qzwuE9umiJkLl52MDdtNhfxQrFDnqe1v0iO2MapmGBkYtqUb/+76hU7e0NeivYUzlzZT1nTFktUIX4IDtmh9Q6wAdmOks4U78Fl7iq12HJIGMcW0YzyXgEeG9O4bzzVtAOidZkPi0nx2ZNehLH7nriiHAlXcy5O7a9ariJu4HbLKjaHi5NnVNoY4qVHyUgMzcwarkQDqc3KLfSscML0yc+hVdhc+/Fcc47UhS26pP4N2lybipUjEtYVZCSCzQd7Ro4HqKoPnbmOYKupcVIW/JPQi5s9JfkM4MA7T2GZjcvQ/Ql8VthAMqpzI7wVxX9AoT9jlnGi+tZK575wXcBLgSSptRY5nsvwPqDJfx9s63F9UokunnBMmmMGacfP3LYcn13BYguymgfwTmQO8FyX0d+VHv/D8yztpmhOrzzpLTYEsiy3FYT2NmMIadH
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:42:19.9390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e935b6-383f-443e-dda9-08dc5fdfa932
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8541

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 218 ++++++++++++++++++
 3 files changed, 272 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1b042f827eab..1ee8401de72d 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
 
 See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
 
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provided
+data into a guest GPA range, measuring the contents into the SNP guest context
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that GPA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had the
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
+                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u32 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
+                __u8 type;              /* The type of the guest pages being initialized. */
+        };
+
+where the allowed values for page_type are #define'd as::
+
+	KVM_SEV_SNP_PAGE_TYPE_NORMAL
+	KVM_SEV_SNP_PAGE_TYPE_ZERO
+	KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+	KVM_SEV_SNP_PAGE_TYPE_SECRETS
+	KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
+used/measured.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bdf8c5461a36..8612aec97f55 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -699,6 +699,7 @@ enum sev_cmd_id {
 
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -830,6 +831,20 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
 
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4c5abc0e7806..e721152bae00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -262,6 +262,35 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ON_ONCE(rc)) {
+		/*
+		 * This shouldn't happen under normal circumstances, but if the
+		 * reclaim failed, then the page is no longer safe to use.
+		 */
+		snp_leak_pages(pfn, 1);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (rc)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2131,6 +2160,192 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
+				  void __user *src, int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int n_private = 0, ret, i;
+	int npages = (1 << order);
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args = {0};
+		bool assigned;
+		void *vaddr;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute set\n",
+				 __func__, gfn);
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			ret = -EINVAL;
+			break;
+		}
+
+		vaddr = kmap_local_pfn(pfn + i);
+		ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
+		if (ret) {
+			pr_debug("Failed to copy source page into GFN 0x%llx\n", gfn);
+			goto out_unmap;
+		}
+
+		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to convert GFN 0x%llx to private, ret: %d\n",
+				 __func__, gfn, ret);
+			goto out_unmap;
+		}
+
+		n_private++;
+
+		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type = sev_populate_args->type;
+		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret) {
+			pr_debug("%s: SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
+				 __func__, ret, sev_populate_args->fw_error);
+
+			if (snp_page_reclaim(pfn + i))
+				goto out_unmap;
+
+			/*
+			 * When invalid CPUID function entries are detected,
+			 * firmware writes the expected values into the page and
+			 * leaves it unencrypted so it can be used for debugging
+			 * and error-reporting.
+			 *
+			 * Copy this page back into the source buffer so
+			 * userspace can use this information to provide
+			 * information on which CPUID leaves/fields failed CPUID
+			 * validation.
+			 */
+			if (sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+			    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+				host_rmp_make_shared(pfn + i, PG_LEVEL_4K);
+
+				if (copy_to_user(src + i * PAGE_SIZE,
+						 vaddr, PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+			}
+		}
+
+out_unmap:
+		kunmap_local(vaddr);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, undoing %d populated gmem pages.\n",
+			 __func__, ret, n_private);
+		for (i = 0; i < n_private; i++)
+			host_rmp_make_shared(pfn + i, PG_LEVEL_4K);
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args = {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	unsigned int npages;
+	int ret = 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
+	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages = params.len / PAGE_SIZE;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
+		 params.gfn_start, params.gfn_start + npages, params.type);
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot = gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd = argp->sev_fd;
+	sev_populate_args.type = params.type;
+
+	ret = kvm_gmem_populate(kvm, params.gfn_start, u64_to_user_ptr(params.uaddr),
+				npages, sev_gmem_post_populate, &sev_populate_args);
+	if (ret < 0) {
+		argp->error = sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %d (fw_error %d)\n",
+			 __func__, ret, argp->error);
+	} else if (ret < npages) {
+		params.len = ret * PAGE_SIZE;
+		ret = -EINTR;
+	} else if (WARN_ONCE(ret > npages, "Completed page count %d exceeds requested amount %d",
+			     ret, npages)) {
+		ret = -EINVAL;
+	} else {
+		ret = 0;
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2230,6 +2445,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


