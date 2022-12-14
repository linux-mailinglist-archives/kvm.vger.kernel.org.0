Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947E264D09E
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLNUEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLNUD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:03:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF612ED68;
        Wed, 14 Dec 2022 11:58:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnzufEQkG7tStmHliW3OTf5PwDc2K+Pvi9gqW4CGHNitcW5FbgzTS30Th/a/8WnbqosD6pjP5J5QiE2LHWCBpuKaufHkoo2butcmXqSUdgTK3HOvE71beEvGgC0O41lnTYlUcKmzmnf+UV1TlpY4cZWXCnClmzdLoj102v0uq6c7bQ3e0IK57N46OvHmbkpIfbZz/gD+gcp3r7F4MulPPKWRKdoiyP0X7AIQv7uY8AqgbPJ4sx9NvwdOfqBTc5IKC9azoIXF5RwNZFYh8XG11R0hoOv1VMj5kxWTye/NoAIjIy/mGdS8ysjs6ci2gNaX7teBJdFhhGP4HpO257Wypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4FSUS3/B0Rm9xArYguEyqZKPzjYjRY9XqH/r8iRhzM=;
 b=ilL+0ajOjofVEvnXY5PdoXJrSHsB5bn9zn0/5xoPKEZADzOFHJLlqylPac25hfczjjV/SZddhfZ2NvOB4kYnhQyRyJHWmyaJIriNNpvDzmafraZZp+UZH+iydiePz2Ukny5URktQ+YMc1vtWTvR930i8hCp2QcDMqUeg/5FXqlizh+3JIhtVcxOdG0X3kul9SJX102MAfn833JStcbsOvgveBY79Euo76N4cHoPfkBxx5t8GuaHx4ktHldHUuMinn7nomFgioN+fGkrTZg4H1CROykuJsgIlr4J8hmXBbouv3mvWG6IxsHSzlsb+zUM17zb4670yXodu5o8byteWeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4FSUS3/B0Rm9xArYguEyqZKPzjYjRY9XqH/r8iRhzM=;
 b=kged6BGC3qmgZ81K51GjJmxdAIOhf00z9pWj12w1OLgqf1U4zcFrMqKS0IDjsyiS/qb1waL4MtasWW5fBawmDIMfiLKsY6dRajO+ZAGozkXF8bacCBJvVwaw1BCCrlmQ0L/UPL0e2k5wYb3NVz935xW/oQgACVKa5szsrk97M0I=
Received: from MW4PR04CA0253.namprd04.prod.outlook.com (2603:10b6:303:88::18)
 by IA1PR12MB8309.namprd12.prod.outlook.com (2603:10b6:208:3fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:58:18 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::dd) by MW4PR04CA0253.outlook.office365.com
 (2603:10b6:303:88::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:58:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:58:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:58:16 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 39/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Wed, 14 Dec 2022 13:40:31 -0600
Message-ID: <20221214194056.161492-40-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|IA1PR12MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd8080d-ef9e-4911-4f20-08dade0d8b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXfYqhqjbZb3s1cNUl7Kc59vIqSca64MEvhg8hhow6b/3xKRFysoksYi/N0KsS5WfeBrKS+uzDv6s40xapckkyoxvLZRkq23urvo6pik6WdtUU9/jwJF55wS4StNEkHHf9N14S3tnmyCxF1f5R3UZP/jVQ3dN1q0+V1Ar7sWXyh/pAkH2gGTU3HsiGeLcPcouMVqpD+buItCvB1+Kw7JROucpnHk2LV0HOluJ03mOL4JD3q8hl0ZwvnbN5jjSRCt6ATpAHII88V/PpvggBJEWAttyIO4UZLm864/y9NtylakyBbcIoPwr8yBI0OOieQ/0O7Axee0JIILW4JBurCn9O8d2kTHRYUH4QyFaX6r49+YJduxpANNL1i54lUdTfqtHB0NzPY/hmohdhkaBxwFB8nfWO31T09NNndaBotb4DxMyKeaupc1dpqtjM+ZC7MGGMJJGQrZ3vkWnr3u+n+QeD02cdYXNdKc2FVg/Gl20AzlwNOKBJM9lrCortRxZqCOshaPnPVfva1RUGTxQAbN8p/ORBiQIAfDDI31Pmfi/hcxoC3Tix+l15yyFgllrF41N0D01F+RVC03C+dqOH9AdZbuQemwWF59b7yjmWgj79mblnn3qnScDVo+QAVmBVLuZG3FZ0fWgV1PJn5eassmM4MuxrNGZnObcy9ZXPAHq0bKnCngTBmJuKmeiwNm5heSZr7LQbStTpg7XKXL0VjTcVUlM4MHT0GQMrrZu5HHhxw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(81166007)(8936002)(40460700003)(82310400005)(40480700001)(82740400003)(356005)(36860700001)(6666004)(478600001)(86362001)(26005)(16526019)(44832011)(5660300002)(336012)(1076003)(7416002)(41300700001)(4326008)(2616005)(54906003)(426003)(6916009)(70586007)(186003)(8676002)(70206006)(7406005)(316002)(47076005)(83380400001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:58:17.8243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd8080d-ef9e-4911-4f20-08dade0d8b51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../virt/kvm/x86/amd-memory-encryption.rst    |  29 ++++
 arch/x86/kvm/svm/sev.c                        | 161 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  19 +++
 3 files changed, 209 insertions(+)

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
index 6d1d0e424f76..379e61a9226a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -238,6 +238,37 @@ static void sev_decommission(unsigned int handle)
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
@@ -2085,6 +2116,133 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfns[i], &order);
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
+			goto e_release;
+		}
+	}
+
+	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
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
@@ -2178,6 +2336,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index b2311e0abeef..9b6c95cc62a8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1941,6 +1941,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2057,6 +2058,24 @@ struct kvm_sev_snp_launch_start {
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

