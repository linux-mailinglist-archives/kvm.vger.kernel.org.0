Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7E69D37C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjBTS4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjBTS4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:56:38 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08FF2202F;
        Mon, 20 Feb 2023 10:56:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/YL6USh9J39sKixLOvv0qQPkIrpUsXsOId/+75hrZh2fVtwcmMycieZ55P9BT3caojB+VUwq6wczOIxkXtKGnvmZeQCByfuLu+cHF1imjPQ3r4CXCYFj6TMbqZ54/pVDvXZiV89U2/7JqCXyrD74ox3HsXoNDmak0wz+FEwAqijgspAzEXM5JmO5Hn7ozSAvQ/90IrSaaDI8counXB0Ff7GTlGEuZ8HGgjUi+LwnVml17HPtPX3GukA25DathinkomP8E3BvOuLLiCTJNHz2v4iTT2p9yFqqqbykapwu9UbNVQPJ5TqxWPHsQQSsruwNgx5MI4WGi7TfgIGSs9rpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMVr3aU9Xdh5TboWF18psQEDEvA2TIg/npTEcVgWI7E=;
 b=F+fD/6TZmwOCMN0H5YajHa8xTcM9Ayydt31usm+xRVUtLFHPAxJgrPO794NBRN1vMpF9CTn5stgFIP6C3bfst1ZTaJcGr5OE3rjPg0mgALDjdJUxp5F50Eg0lepbHX3zlwOlQkK4r/r0wqRwj6Gq6+PJ+P5BCtdYP5InOMhicSaBzCG9JSjoS0ACBONlRCKAP7mDe422N9RL7A3f+N/gV1QQ3QrzbjhFz2GrxdfpE+/t3+WFUyHXBhp/5Id4T2gcVFAjTCmpxf2U1BG9i5wvJgkF3jLwt4LVkCtFxaVMnOg7s53Eah9cd0eHpUVWGV/rAfrf9Thbr94QefZRruWb8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMVr3aU9Xdh5TboWF18psQEDEvA2TIg/npTEcVgWI7E=;
 b=kHHFPQ+iVISMOwb8ZyXG3tXGYhzuVMVOZJ01qwfYm20lyE3kYsK3DkjNzsVH1uhiBCMUZTxAz/SJxLVC1C68KprXbp5J14+nx9z6tVX+uXYsHCUvalpSfOGTDovb+8gSC9tHLh5o/axbuq0spy5bo+vuMAv+KQrwzUVySXII1Ws=
Received: from DM6PR10CA0004.namprd10.prod.outlook.com (2603:10b6:5:60::17) by
 DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.18; Mon, 20 Feb 2023 18:53:20 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::7b) by DM6PR10CA0004.outlook.office365.com
 (2603:10b6:5:60::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:53:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Mon, 20 Feb 2023 18:53:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:53:19 -0600
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 35/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Mon, 20 Feb 2023 12:38:26 -0600
Message-ID: <20230220183847.59159-36-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT046:EE_|DS0PR12MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: f4e21b02-a376-44ea-cfc7-08db1373bc55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uX02knEIaCBltUtmvBE1z4/RIHkuAKEdLA6EdC8FgBY4o1xOnsQ4iQY/r+y23+E0FlhVNkUHd99vdz8HhSjQMy5ZVJ8N1JH2s2dXUEenVG4B0B3nKy56amODoChXWL0lgDZ5w6mUbxrpl63LhvOfL+aayyV/sg0KSDfenpL2zdXwSVzm/T1e5hPnOLW3uZvCcCy15NUiqegbh6PfQBtEdF0XWbcELz4NccFDLzIqTh7SSSej5BlxLnkRYL+szdRR9qrrlCciY1xQgM05SG6Ma65nyiTd/7wlbKn0g9/BicoSYYtjdo05kVjIfZrjvf6ucXMtdt6GtRq7hRoEr1ClrvHKvHT1Y+uSeLGTkZOtDPCSUQ5EsEKbjJFSw6GGQX5AN+v0wS3PduKJzEbzxJm9hg4zrwLKjd5pDYzpzjplalbI1VbZ/iBG0QwalbZ3I1cuR77/vwreWWMCLKEbe+SB0wR3DNLSe0KfIjdo7SMugFDeGApis2lS6SudcJBcRQR7C7WbbmQ7QbiUeUFpe63enw3DdMTbWtRgb5kY/F6RCnvxWQz403E1yScBjVpNrHZB6p/gA0L25RiF0QcTu7LybmtYCveXB3qoc2HrsQJ1T8dL9Q+W5RMJuFN8oEzPrCfI4o4kCsFhVeUAqVnG/ynovC88++IiUKprt6kFWrXZAezVMZspyg4H1Vu6/TYwTSqeVFxukQNEuFkonXIjMyDB3akIlWN3RzbBaS4WVJiFQsQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(40470700004)(46966006)(36840700001)(7416002)(44832011)(5660300002)(8936002)(316002)(7406005)(2906002)(81166007)(54906003)(70586007)(82310400005)(4326008)(6916009)(8676002)(41300700001)(70206006)(86362001)(478600001)(82740400003)(16526019)(36756003)(26005)(36860700001)(186003)(1076003)(2616005)(47076005)(426003)(336012)(40480700001)(40460700003)(83380400001)(6666004)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:53:20.4183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e21b02-a376-44ea-cfc7-08db1373bc55
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6583
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 .../virt/kvm/x86/amd-memory-encryption.rst    |  29 +++
 arch/x86/kvm/svm/sev.c                        | 190 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  19 ++
 3 files changed, 238 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 58971fc02a15..c94be8e6d657 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -485,6 +485,35 @@ Returns: 0 on success, -negative on error
 
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
index 097bb2138360..03dd227f6090 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -234,6 +234,37 @@ static void sev_decommission(unsigned int handle)
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
+		snp_mark_pages_offline(pfn,
+				       page_level_size(PG_LEVEL_4K) >> PAGE_SHIFT);
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
+		snp_mark_pages_offline(pfn,
+				       page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2093,6 +2124,162 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		pr_err("SEV-SNP requires restricted memory.\n");
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
+		void *kvaddr;
+
+		ret = kvm_restrictedmem_get_pfn(memslot, gfn, &pfns[i], &order);
+		if (ret)
+			goto e_release;
+
+		n++;
+		ret = snp_lookup_rmpentry((u64)pfns[i], &level);
+		if (ret) {
+			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret: %d\n",
+			       gfn, ret);
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
+
+			goto e_release;
+		}
+	}
+
+	/*
+	 * Memory attribute updates via KVM_SET_MEMORY_ATTRIBUTES are serialized
+	 * via kvm->slots_lock, so use the same protocol for updating them here.
+	 */
+	mutex_lock(&kvm->slots_lock);
+	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	mutex_unlock(&kvm->slots_lock);
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
@@ -2186,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index cf19799ca5ce..4098bba17aa4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1920,6 +1920,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2036,6 +2037,24 @@ struct kvm_sev_snp_launch_start {
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

