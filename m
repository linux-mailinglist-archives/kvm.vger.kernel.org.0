Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC77CA9C4
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbjJPNiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbjJPNhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:37:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F912B;
        Mon, 16 Oct 2023 06:37:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aawbUnU/tAghCQgF6mx2SxJjWDsb5orIA6wPqcsliszVCSYwB9yNQoXwpgspE0zeOUesrTHr60eWUBq/m74josTzKPrLcUbPX+jkju0oP2dB6vecAlgp/bCqpEoMU4ZcdGKGsemBOZIqH6Gwthkcch56GtyDzGAEMyA6MPBtvbeuUFMCz3CZTsBZBNeNHeilCoJKfCyIWaiqzUaatP3jrBd3dy9GTqscnBhdIIWYsK7GcUcMxrJpUaA3AFQTbYrs+ePTsuL5SHG3trvlzkDPDjVO6HzGxaIOBBtDD6RH15yLHt3vOOst7cuDfFRUADG3ukegaehK7meZ2r5/Ei1NyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd/rJi/JYGrqeBoWHN7tLgjtCMkUtoUlp7tOldubjJI=;
 b=QkVgj91srrSDnOyYUawBUCS302IdYfO4S/IsPjxoRyxs9podIHS2OZIF8O0muwLS3zBSekbYQH+cGChUNUmk5Psvr9ndkKT/QsEBSx5dd5QXGs3HFF6Jy+vrYBUF10miZG0/DR1bt2DOucbjE7vdlvdJHoIx2g6gjuCJi0wz0LyXf3H/O30vdL4SgJwjylCpugr0kmKgdyS8n/Rci6afas6xn4Z2kM763k8rYPVTmpKTjTCx/oHjgTbiAtvyVi0D3UiTUKED0vN1MApDt2114ZHxYyer7+NqOe4aVE2jNq6AOvFneIhxFwPo9onJEt5sYJjvp5BHE/qgPwUP9VVuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd/rJi/JYGrqeBoWHN7tLgjtCMkUtoUlp7tOldubjJI=;
 b=GU2qztOscUO2zDuXFolAN3GakEcuD+AS5EBR+j9n7sUG6G0sK3GFDI6BTTts6RKLg3Rf6Iz5HOdFSjP5huqnMUHgetOxgZDBidGEkSZVSYYNeuRj8U5ir2SWwgBHD7wwJzwX7j4cxEcDmG/CjMnyQ0IgMKa4OBAsME7zHS+7+ns=
Received: from BL1PR13CA0381.namprd13.prod.outlook.com (2603:10b6:208:2c0::26)
 by MN0PR12MB6127.namprd12.prod.outlook.com (2603:10b6:208:3c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:37:44 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:2c0:cafe::43) by BL1PR13CA0381.outlook.office365.com
 (2603:10b6:208:2c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:37:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:37:43 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 28/50] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Mon, 16 Oct 2023 08:27:57 -0500
Message-ID: <20231016132819.1002933-29-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|MN0PR12MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b405b2-fb92-4f7b-c57b-08dbce4d13ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ofqVyda5Mr4SX0KjVoQxxjDCbYkinPn48NwbxEsDQ8vESn+ykEzivDJtyZ1xhTptcGDk9kIl9gto1ibiUYrtiE55nvphfAedcVSGI+Zecur+bbFvu6tIr7va7nyjC+o7waDlq3PiZVxPuGOp16Chua2EWIp98dmi+YmaFRtNXDuna6rUmNGx1mG+qgyxXIZhda8gEZ61PCvr8pFZM9+gZOwR3+Ka4mrNgN8oV40xn8gvkuMhl5t1M+QDrDt3nj8PS+zcdWhO7xDIWxMAnWEhohLKXekT9hVArB4xiXmKiSR0I2sVz7SpeP8Fns56vPnjthw4xrSmwUeTGRsIqDaWfwS7WOYuxo79Xk4Flgs3HPck9fkYg5tdBlZJvFx8MrL+arh8IllhPkKmMzLQ5KFL4pdGARyJ30WoVvtPxMPv3Xv8j+kuNIfc2SzbEHdslleNsBAlJ92bcYqtkM48KHus3Gi2xOGYxXhRFpyzIzdtxDJReZKS8AXARrJrIjKSdrwhUdwSHJbNjN9yY1IQBjmKHD+jC/HirLKrvu8BwEquIYykUu1a4Nkmk0bIE5YSe70n8jTql9GxKVncMdof+oYxUhgqk3jqOod5jnuJC++Fbx2k3/UXqwEuwbl5HVHDOeOL0bqN8DDqaWSZF1F4gKJM1B6e0HQSOY2M4OIg+4eHgoQ0uaHZO4OjhAXWfAQh/pEfodUzKfuxZ3ekQzwc0HRJY/SfFPDyhHgVH0lOrL5LAP8W6JsmnkCfxwMh5pJtXRqM20CO/e54SyX26fNAdia6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(82310400011)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(54906003)(70206006)(70586007)(478600001)(316002)(6916009)(336012)(426003)(1076003)(2616005)(16526019)(26005)(5660300002)(8676002)(8936002)(4326008)(6666004)(7406005)(7416002)(44832011)(2906002)(41300700001)(86362001)(81166007)(356005)(36756003)(82740400003)(36860700001)(47076005)(83380400001)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:37:44.0234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b405b2-fb92-4f7b-c57b-08dbce4d13ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  28 +++
 arch/x86/kvm/svm/sev.c                        | 181 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  19 ++
 3 files changed, 228 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index b1beb2fe8766..d4325b26724c 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -485,6 +485,34 @@ Returns: 0 on success, -negative on error
 
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
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a4efd1858a9c..c505e4620456 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -246,6 +246,36 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (rc) {
+		/*
+		 * If the reclaim failed, then page is no longer safe
+		 * to use.
+		 */
+		snp_leak_pages(pfn, 1);
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
+		snp_leak_pages(pfn,
+			       page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -1988,6 +2018,154 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int snp_launch_update_gfn_handler(struct kvm *kvm,
+					 struct kvm_gfn_range *range,
+					 void *opaque)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_memory_slot *memslot = range->slot;
+	struct sev_data_snp_launch_update data = {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_sev_cmd *argp = opaque;
+	int *error = &argp->error;
+	int i, n = 0, ret = 0;
+	unsigned long npages;
+	kvm_pfn_t *pfns;
+	gfn_t gfn;
+
+	if (!kvm_slot_can_be_private(memslot)) {
+		pr_err("SEV-SNP requires private memory support via guest_memfd.\n");
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params))) {
+		pr_err("Failed to copy user parameters for SEV-SNP launch.\n");
+		return -EFAULT;
+	}
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+
+	npages = range->end - range->start;
+	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL_ACCOUNT);
+	if (!pfns)
+		return -ENOMEM;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx, type %d\n", __func__,
+		 range->start, range->end, params.page_type);
+
+	for (gfn = range->start, i = 0; gfn < range->end; gfn++, i++) {
+		int order, level;
+		bool assigned;
+		void *kvaddr;
+
+		ret = __kvm_gmem_get_pfn(kvm, memslot, gfn, &pfns[i], &order, false);
+		if (ret)
+			goto e_release;
+
+		n++;
+		ret = snp_lookup_rmpentry((u64)pfns[i], &assigned, &level);
+		if (ret || assigned) {
+			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret: %d, assigned: %d\n",
+			       gfn, ret, assigned);
+			return -EFAULT;
+		}
+
+		kvaddr = pfn_to_kaddr(pfns[i]);
+		if (!virt_addr_valid(kvaddr)) {
+			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn);
+			ret = -EINVAL;
+			goto e_release;
+		}
+
+		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
+		if (ret) {
+			pr_err("Guest read failed, ret: 0x%x\n", ret);
+			goto e_release;
+		}
+
+		ret = rmp_make_private(pfns[i], gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_release;
+		}
+
+		data.address = __sme_set(pfns[i] << PAGE_SHIFT);
+		data.page_size = X86_TO_RMP_PG_LEVEL(PG_LEVEL_4K);
+		data.page_type = params.page_type;
+		data.vmpl3_perms = params.vmpl3_perms;
+		data.vmpl2_perms = params.vmpl2_perms;
+		data.vmpl1_perms = params.vmpl1_perms;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, error);
+		if (ret) {
+			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
+			       ret, *error);
+			snp_page_reclaim(pfns[i]);
+
+			/*
+			 * When invalid CPUID function entries are detected, the firmware
+			 * corrects these entries for debugging purpose and leaves the
+			 * page unencrypted so it can be provided users for debugging
+			 * and error-reporting.
+			 *
+			 * Copy the corrected CPUID page back to shared memory so
+			 * userpsace can retrieve this information.
+			 */
+			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
+			    *error == SEV_RET_INVALID_PARAM) {
+				int ret;
+
+				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
+
+				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
+				if (ret)
+					pr_err("Failed to write CPUID page back to userspace, ret: 0x%x\n",
+					       ret);
+			}
+
+			goto e_release;
+		}
+	}
+
+e_release:
+	/* Content of memory is updated, mark pages dirty */
+	for (i = 0; i < n; i++) {
+		set_page_dirty(pfn_to_page(pfns[i]));
+		mark_page_accessed(pfn_to_page(pfns[i]));
+
+		/*
+		 * If its an error, then update RMP entry to change page ownership
+		 * to the hypervisor.
+		 */
+		if (ret)
+			host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
+
+		put_page(pfn_to_page(pfns[i]));
+	}
+
+	kvfree(pfns);
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_update params;
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
+	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
+				      snp_launch_update_gfn_handler, argp);
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2081,6 +2259,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e92da3d4f569..264e6acb7947 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1965,6 +1965,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2081,6 +2082,24 @@ struct kvm_sev_snp_launch_start {
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

