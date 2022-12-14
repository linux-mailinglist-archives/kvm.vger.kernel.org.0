Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0509864D037
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiLNTrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbiLNTrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:47:11 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBF02B1BF;
        Wed, 14 Dec 2022 11:47:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFXp2ura0SniPy/1FT0hTaveLU8lPt79DfuLbx/ZmlS7LuyHVEOwY8yhtngXdPQ1B4/GEWScZHs/3PhFwoPIHm/Y8u65e0w9x+je/iitBf/ceHPhO8ymIUkwkgy8uwGCh81lCr4uydo2DjPc8KwjYcUt8+5gZvkllD5pr0gYeGTQY1CqJ3uHKa7rfIIJ1hw8jd2mcHZB6GFM9lwWF7Xc2ad/VRZJidrDzwIVjMr6Q6HJCZV2JXvM8uNIgUn8bZmTCRnfKv1iE5+dBdf9nIaohQVIWiss+HUKx2j1moGd0AnGoLurc38tj6U2uQPw0JahHtA35/PEwsOOjxaET/QYrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9w/cFCjO4bsQFA/Rhr3wtXGAVyDniVXFXOz9FKivmoQ=;
 b=ZlYWEJA6QNYL7w4maLau6oQ7gSjpSG65dbnIlAUAFMwTtOrZPBOcQF9ewOLWJgmk6kp4tlX1kEsFYTBpvN1z1bx7p249amlEmWglYDBTDmbHk8SR/ODn0jmMQaa6TnfXCaywkiofx38qZ3Kuh7eRDv3aKEPTonS2QwOnVmM1r4gVE0eeonG68h3hS8h7f404nRNApFN6fpWPowfRpjEweexK13LPsBcCz1nT1c3Oym2PUmyOk6sVkAbuAgB2VTiPpUVQw4mnDlKLDp0tlg5TzR7rXfMdIidvnMq7SPGKNTf9IoofO2AlK85gj2MTEty3r+TDK6ubTfXGVP13Qz5ZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w/cFCjO4bsQFA/Rhr3wtXGAVyDniVXFXOz9FKivmoQ=;
 b=aD4iT9z+C3JGhKVwwsdRrKuYEi9Ba2c/ktqic1JLQPOkOG2fYEP90wktUMh3WszpESkBYMtDGATTPaD8piuB+7qMtCGl+1FouuJTQCvDa997XiEv3Kg5D+RPRcCBeHzQw+hbV3MQ6V52yPZO+e2kfXEBfvIyah3Q0j3Y2KH6ahU=
Received: from BN9PR03CA0274.namprd03.prod.outlook.com (2603:10b6:408:f5::9)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:47:05 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::48) by BN9PR03CA0274.outlook.office365.com
 (2603:10b6:408:f5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:47:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:47:04 -0600
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
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH RFC v7 10/64] KVM: SEV: Populate private memory fd during LAUNCH_UPDATE_DATA
Date:   Wed, 14 Dec 2022 13:40:02 -0600
Message-ID: <20221214194056.161492-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 2431e434-eaba-4956-3d4a-08dade0bfa6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvh6NY72+zxvwfjghmxvaPw+2+acsgsBjjCDutF210E0NpjY8xiP2OgNdGpOg9o1mmNa+4q99k3X7iVDTFy7kvjvf36lCc9X9Dc9QFnxl5ncX7UjGc+BPGeO+Ics7ODFTVa/pvWQB426K4gWsaqei7UncSHN4izOurmmiZ+FvJXkUVhIVWD/nSKFHkGYT20slSLb/wI/Qj9kOlEN/3xrv+bRkqSbuUf2r65Mlehg8v6Qh7Jkmw2Tq5mET2sk01SEtVHcZhacYJrMcLxT1nlXMUqu5RUA/8a82vUiku769M56Ijldo4ljN++WC7A+YZ6c/L47Z2itdMf0K93Sh1w5JUqETYbIG3drq20E11MptHRrh8E7dKjk5BgDHKw0jZdUb+WOhjCqVg0+3vVLoX6du+90j9RDbF2CQHiU2cJX5vGW6sCne9dnecQ0J5RpsbOZid5X2N2OXZAXDTQVQCVO4wC8BRpse9DVDskVYVyuAnGOP6adFrdD0dhxEXxLMQ6/Y491Jurb+xITApKEnUZ0gA8uQomCzmeqNYlIGnwPATB4mPnpuA+V6PQ3HwDvLMZy45PamMNFv8Q4lwJ9J0feehtfptNpIB8KRHRsEgw++fbO42Fc0LQlfc1nfZ+iG8tDmX3fC5MqN5dTHrf1i+ionRVlV6H6ptkRiG2dWBUEHqcaxOw1LzCgp7+DuAKRc4W4C2C8aoPikM/p5Jw2q9aqmj/s75Lx0gD3u2N9jRzrZRc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(6916009)(82740400003)(356005)(7416002)(70586007)(70206006)(2906002)(54906003)(316002)(7406005)(81166007)(86362001)(36860700001)(40480700001)(8676002)(83380400001)(66899015)(26005)(47076005)(4326008)(2616005)(40460700003)(5660300002)(8936002)(336012)(44832011)(1076003)(82310400005)(478600001)(426003)(186003)(16526019)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:47:05.3009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2431e434-eaba-4956-3d4a-08dade0bfa6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

This change adds handling of HVA ranges to copy contents
to private memory while doing sev launch update data.

mem_attr array is updated during LAUNCH_UPDATE_DATA to ensure
that encrypted memory is marked as private.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[mdr: use gfn_to_hva_memslot_prot() for shared GFN handler to deal with
      read-only slots for ROMs]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 99 ++++++++++++++++++++++++++++++++++++----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 27 ++++++++---
 3 files changed, 111 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 69dbf17f0d6a..a7e4e3005786 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -493,23 +493,26 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
-static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
+						struct kvm_gfn_range *range,
+						struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct kvm_sev_launch_update_data params;
 	struct sev_data_launch_update_data data;
 	struct page **inpages;
 	int ret;
 
-	if (!sev_guest(kvm))
-		return -ENOTTY;
-
-	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
-		return -EFAULT;
+	vaddr = gfn_to_hva_memslot_prot(range->slot, range->start, NULL);
+	pr_debug("%s: shared GFN: %llx, slot.id: %d, slot.base_gfn: %llx, slot.userspace_addr: %lx, slot.flags: %x, vaddr: %lx\n",
+		 __func__, range->start, range->slot->id, range->slot->base_gfn,
+		 range->slot->userspace_addr, range->slot->flags, vaddr);
+	if (kvm_is_error_hva(vaddr)) {
+		pr_err("vaddr is erroneous 0x%lx\n", vaddr);
+		return -EINVAL;
+	}
 
-	vaddr = params.uaddr;
-	size = params.len;
+	size = (range->end - range->start) << PAGE_SHIFT;
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
@@ -561,6 +564,84 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
+					      struct kvm_gfn_range *range,
+					      struct kvm_sev_cmd *argp)
+{
+	struct sev_data_launch_update_data data;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	gfn_t gfn;
+	kvm_pfn_t pfn;
+	struct kvm_memory_slot *memslot = range->slot;
+	int ret = 0;
+
+	data.reserved = 0;
+	data.handle = sev->handle;
+
+	for (gfn = range->start; gfn < range->end; gfn++) {
+		int order;
+		void *kvaddr;
+
+		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
+		if (ret)
+			return ret;
+
+		kvaddr = pfn_to_kaddr(pfn);
+		if (!virt_addr_valid(kvaddr)) {
+			pr_err("Invalid kvaddr 0x%llx\n", (uint64_t)kvaddr);
+			ret = -EINVAL;
+			goto e_ret;
+		}
+
+		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
+		if (ret) {
+			pr_err("guest read failed 0x%x\n", ret);
+			goto e_ret;
+		}
+
+		if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
+			clflush_cache_range(kvaddr, PAGE_SIZE);
+
+		data.len = PAGE_SIZE;
+		data.address = __sme_set(pfn << PAGE_SHIFT);
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
+		if (ret)
+			goto e_ret;
+		kvm_release_pfn_clean(pfn);
+	}
+	kvm_vm_set_region_attr(kvm, range->start, range->end,
+		true /* priv_attr */);
+
+e_ret:
+	return ret;
+}
+
+static int sev_launch_update_gfn_handler(struct kvm *kvm, struct kvm_gfn_range *range,
+					 void *data)
+{
+	struct kvm_sev_cmd *argp = (struct kvm_sev_cmd *)data;
+
+	if (kvm_slot_can_be_private(range->slot))
+		return sev_launch_update_priv_gfn_handler(kvm, range, argp);
+
+	return sev_launch_update_shared_gfn_handler(kvm, range, argp);
+}
+
+static int sev_launch_update_data(struct kvm *kvm,
+		struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_launch_update_data params;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
+		sev_launch_update_gfn_handler, argp);
+}
+
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 21a539ab17f6..33fa0b1435d3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -973,6 +973,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end, u64 attributes);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4ff7adaf6c56..1343070657d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -747,6 +747,7 @@ int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
 
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
@@ -2595,12 +2596,28 @@ static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end,
 		kvm_flush_remote_tlbs(kvm);
 }
 
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end,
+			   u64 attributes)
+{
+	gfn_t index;
+	void *entry;
+
+	entry = attributes ? xa_mk_value(attributes) : NULL;
+
+	for (index = start; index < end; index++)
+		if (xa_err(xa_store(&kvm->mem_attr_array, index, entry,
+				    GFP_KERNEL_ACCOUNT)))
+			break;
+
+	return index;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_region_attr);
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
 	gfn_t start, end;
 	unsigned long i;
-	void *entry;
 	int idx;
 	u64 supported_attrs = kvm_supported_mem_attributes(kvm);
 
@@ -2617,8 +2634,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	start = attrs->address >> PAGE_SHIFT;
 	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
 
-	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
-
 	if (kvm_arch_has_private_mem(kvm)) {
 		KVM_MMU_LOCK(kvm);
 		kvm_mmu_invalidate_begin(kvm);
@@ -2627,10 +2642,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	}
 
 	mutex_lock(&kvm->lock);
-	for (i = start; i < end; i++)
-		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-				    GFP_KERNEL_ACCOUNT)))
-			break;
+	i = kvm_vm_set_region_attr(kvm, start, end, attrs->attributes);
 	mutex_unlock(&kvm->lock);
 
 	if (kvm_arch_has_private_mem(kvm)) {
@@ -2793,6 +2805,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 
 	return hva;
 }
+EXPORT_SYMBOL_GPL(gfn_to_hva_memslot_prot);
 
 unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable)
 {
-- 
2.25.1

