Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8A35527B7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbiFTXJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347369AbiFTXJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:09:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3233524086;
        Mon, 20 Jun 2022 16:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D17VusvhH5jE9yiZVR81sCQSE3knb4M8mcUrk6a4NFAveapxC8PH08b3yqsconKeqfl8jwW1c0ncl0VY6VuqMfRQa1x8GaQt5bTP+VGV/fSblEqhr3neax4dI1mkwIDjPkUWh+7JkytKNEl6QR+A/zR1WhrjAwbJHJVmYeLspzMz++jSZ8tj8k6mwwf8nM4EfFgsXzOM4XsrtBVD2/9f8ZG5zm2vWpBy9jH+LzMQhTnqt4N1Bs6/Cj5Zyitb6/oH2/Y4VnxJulmA8kXVYnwle/hHwdGPxVzgqMfys3FtOGVOGemqJBbgZNzi4bzYRkiXwWQB7cFX0NHJ7KOq+QUmdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YH8FDbFKxuICJFboEdrcM0sp93Kt/D2c91JS5GxhN3E=;
 b=MKp+oV+tKygh46/c7gm+fK7ItWbNB5AUeQ/Qm8MVgMZJrYx873rT7fVX7edwi9DY2gZzccLKw2PTAEBsdwoqEozd24SHss4iw8DBPSDJ2GO9gU4N8f/1qn/33wTn87+t83SfhzT4hVDTtzdEUXmkat97vAAocjbHTqoqnFJETOD0OmJhq+cfUuRzylTmCIs6zpmHHs1NIRJ6TG9Aaesk9hB2ppjNbCqpHJeUL5aVUyw5RJ3W8APM4HKYtUol44+SkWJTeZgHX/HrRtivhh3m1WhJPnZbcEOp1vVHOn82Xm6ddqkOGtPyWXLzhZ6XUDQ2b4DnIL7mFnIrxa06zJQKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH8FDbFKxuICJFboEdrcM0sp93Kt/D2c91JS5GxhN3E=;
 b=ySI/swSTWl00ovHzWXOP3JdZjrfcDVtV8WLPpLr9HI3sboE7L6rId8/6ZbUn3iaLP/aypIN9sLcvDCYRRcwFD6QFXQyqrFIViZS3anCcooRIsK03vwT72ewb9jDzWySv0qOrvP4cn/HbHtuU+y4U7bR7ekAtMA+G0d8U0KqoB24=
Received: from BN6PR19CA0083.namprd19.prod.outlook.com (2603:10b6:404:133::21)
 by DM6PR12MB2809.namprd12.prod.outlook.com (2603:10b6:5:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Mon, 20 Jun
 2022 23:08:17 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::ba) by BN6PR19CA0083.outlook.office365.com
 (2603:10b6:404:133::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 23:08:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:08:16 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:08:14 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Mon, 20 Jun 2022 23:08:05 +0000
Message-ID: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e64d0fb-d092-45fe-0e63-08da5311c286
X-MS-TrafficTypeDiagnostic: DM6PR12MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28094D5A894E09C60FA6DE648EB09@DM6PR12MB2809.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jA1f96lRtligdrs81CJ0HOqjwPqa6ySF0EcfxGJJSzGmaZWsXycdyPWuXNhHC7cXyVRuLe51Vj/41O+p3V7MsjXGJVSWYSBUOd55Z30l6dyeHv7WGUgmhouV+Np3TFPGwq5mEshYKQz1pDaadriW8qVvvSxKXbHxQ3npRiVwi7OqUGOvQAWwVEUJkn2MrC0JYFlwuMCUaucAO/HLFq2fyVexxkiTtcnkQrEtUsDe5vQ3zEHAcP6XOOWD2+mm4QoY7XXTSnZYNJ+xcmr5/94fmcwEKJbm7/CFvfqH28Mp6624pAPnrU166hOb7q5GmDHanEOu2r0jvvfvFtVHezIHKyyF5tQSlLZjH/Lnhpl5hhIHlMfxLI1yJbpvoYaNEwM6szF6/NOl8TOj9AoJ5ZjaoIr4QC+KrLe094elKM6DCAZG8m6lc9nzGgqHGEqG09dgsedmrjcLOVg9KBA6yOeauW2L+d03rcf8HNCKdUhkQ4XsLNAhuou1ik3arjh/+Id7fbpKzKsIaQk4hI43ItEobO4zZCm8HqFcLPb4Z9/tqYe6TBSry0QosqU3UElXVOvSrmDSNYWnKWqKiFW+dM7ELa3wMumMpePJTOXyQo+zHh/ZygYFEq7i2GpPO6AzyMjNKLXgH2ZKsHLKpgZkpjlvVgsWXT2EGzJdMYEGPnIWZpCB7dBpvuo3+8yuTnl5pDDN06dZJOaJAeYoxTEEVbpDS3grYEEIn3zsgjetB1GPQHhQ/9LdpybdrYLrCZd0erF81g90l9nsSBg37Yx9Bn3r6w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(40470700004)(46966006)(36840700001)(110136005)(41300700001)(26005)(86362001)(36756003)(356005)(82740400003)(81166007)(54906003)(2906002)(478600001)(5660300002)(7696005)(316002)(2616005)(83380400001)(40480700001)(7416002)(7406005)(6666004)(8936002)(82310400005)(8676002)(4326008)(70586007)(70206006)(16526019)(40460700003)(186003)(36860700001)(336012)(426003)(47076005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:08:16.8367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e64d0fb-d092-45fe-0e63-08da5311c286
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2809
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
guest's memory. The data is encrypted with the cryptographic context
created with the KVM_SEV_SNP_LAUNCH_START.

In addition to the inserting data, it can insert a two special pages
into the guests memory: the secrets page and the CPUID page.

While terminating the guest, reclaim the guest pages added in the RMP
table. If the reclaim fails, then the page is no longer safe to be
released back to the system and leak them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  29 +++
 arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  19 ++
 3 files changed, 235 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 878711f2dca6..62abd5c1f72b 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -486,6 +486,35 @@ Returns: 0 on success, -negative on error
 
 See the SEV-SNP specification for further detail on the launch input.
 
+20. KVM_SNP_LAUNCH_UPDATE
+-------------------------
+
+The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
+calculates a measurement of the memory contents. The measurement is a signature
+of the memory contents that can be sent to the guest owner as an attestation
+that the memory was encrypted correctly by the firmware.
+
+Parameters (in): struct  kvm_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 start_gfn;        /* Guest page number to start from. */
+                __u64 uaddr;            /* userspace address need to be encrypted */
+                __u32 len;              /* length of memory region */
+                __u8 imi_page;          /* 1 if memory is part of the IMI */
+                __u8 page_type;         /* page type */
+                __u8 vmpl3_perms;       /* VMPL3 permission mask */
+                __u8 vmpl2_perms;       /* VMPL2 permission mask */
+                __u8 vmpl1_perms;       /* VMPL1 permission mask */
+        };
+
+See the SEV-SNP spec for further details on how to build the VMPL permission
+mask and page type.
+
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 41b83aa6b5f4..b5f0707d7ed6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,6 +18,7 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <linux/hugetlb.h>
+#include <linux/sev.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -233,6 +234,49 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+static inline void snp_leak_pages(u64 pfn, enum pg_level level)
+{
+	unsigned int npages = page_level_size(level) >> PAGE_SHIFT;
+
+	WARN(1, "psc failed pfn 0x%llx pages %d (leaking)\n", pfn, npages);
+
+	while (npages) {
+		memory_failure(pfn, 0);
+		dump_rmpentry(pfn);
+		npages--;
+		pfn++;
+	}
+}
+
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = snp_guest_page_reclaim(&data, &err);
+	if (rc) {
+		/*
+		 * If the reclaim failed, then page is no longer safe
+		 * to use.
+		 */
+		snp_leak_pages(pfn, PG_LEVEL_4K);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, level);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -1902,6 +1946,123 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct list_head *head = &sev->regions_list;
+	struct enc_region *i;
+
+	lockdep_assert_held(&kvm->lock);
+
+	list_for_each_entry(i, head, list) {
+		u64 start = i->uaddr;
+		u64 end = start + i->size;
+
+		if (start <= hva && end >= (hva + len))
+			return true;
+	}
+
+	return false;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {0};
+	struct kvm_sev_snp_launch_update params;
+	unsigned long npages, pfn, n = 0;
+	int *error = &argp->error;
+	struct page **inpages;
+	int ret, i, level;
+	u64 gfn;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	/* Verify that the specified address range is registered. */
+	if (!is_hva_registered(kvm, params.uaddr, params.len))
+		return -EINVAL;
+
+	/*
+	 * The userspace memory is already locked so technically we don't
+	 * need to lock it again. Later part of the function needs to know
+	 * pfn so call the sev_pin_memory() so that we can get the list of
+	 * pages to iterate through.
+	 */
+	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
+	if (!inpages)
+		return -ENOMEM;
+
+	/*
+	 * Verify that all the pages are marked shared in the RMP table before
+	 * going further. This is avoid the cases where the userspace may try
+	 * updating the same page twice.
+	 */
+	for (i = 0; i < npages; i++) {
+		if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
+			sev_unpin_memory(kvm, inpages, npages);
+			return -EFAULT;
+		}
+	}
+
+	gfn = params.start_gfn;
+	level = PG_LEVEL_4K;
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+
+	for (i = 0; i < npages; i++) {
+		pfn = page_to_pfn(inpages[i]);
+
+		ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		n++;
+		data.address = __sme_page_pa(inpages[i]);
+		data.page_size = X86_TO_RMP_PG_LEVEL(level);
+		data.page_type = params.page_type;
+		data.vmpl3_perms = params.vmpl3_perms;
+		data.vmpl2_perms = params.vmpl2_perms;
+		data.vmpl1_perms = params.vmpl1_perms;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
+		if (ret) {
+			/*
+			 * If the command failed then need to reclaim the page.
+			 */
+			snp_page_reclaim(pfn);
+			goto e_unpin;
+		}
+
+		gfn++;
+	}
+
+e_unpin:
+	/* Content of memory is updated, mark pages dirty */
+	for (i = 0; i < n; i++) {
+		set_page_dirty_lock(inpages[i]);
+		mark_page_accessed(inpages[i]);
+
+		/*
+		 * If its an error, then update RMP entry to change page ownership
+		 * to the hypervisor.
+		 */
+		if (ret)
+			host_rmp_make_shared(pfn, level, true);
+	}
+
+	/* Unlock the user pages */
+	sev_unpin_memory(kvm, inpages, npages);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1995,6 +2156,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2113,6 +2277,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
+	unsigned long i, pfn;
+	int level;
+
+	/*
+	 * The guest memory pages are assigned in the RMP table. Unassign it
+	 * before releasing the memory.
+	 */
+	if (sev_snp_guest(kvm)) {
+		for (i = 0; i < region->npages; i++) {
+			pfn = page_to_pfn(region->pages[i]);
+
+			if (!snp_lookup_rmpentry(pfn, &level))
+				continue;
+
+			cond_resched();
+
+			if (level > PG_LEVEL_4K)
+				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+			host_rmp_make_shared(pfn, level, true);
+		}
+	}
+
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0cb119d66ae5..9b36b07414ea 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1813,6 +1813,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1929,6 +1930,24 @@ struct kvm_sev_snp_launch_start {
 	__u8 pad[6];
 };
 
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 start_gfn;
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

