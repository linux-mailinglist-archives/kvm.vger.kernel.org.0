Return-Path: <kvm+bounces-5380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14568207C1
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDB6CB21769
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DDFECA49;
	Sat, 30 Dec 2023 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lAbCw9Nv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4426A14A8A;
	Sat, 30 Dec 2023 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhewxPBEQVK415DbccB4A5Or8enbqrzf1i1z8uHgPsOe/ohA/MaokJOO1A+QVAso1xWrvz2uWA8OD/1Cs+T34asIoARmXsqrQbS+681+b0lIkn4LGmnMZKzo71uDHHBWv5K62UUZtkpGuGh5YD4cl316j7isPzYYa2sGYke1XUt8PjgBgOGsHbJ9FXxRnBp+3h1ukmK+EQMDEaqOmJZEztaeVFroALzoNuSpFE1dF0O3HKjpnAY37DpZoCUg/w1TOVxd8Zc3fWNA/mMwt08TL6xKb0Nb5luNijPCoDm4qDto1pZUChr475LaX4p4fgWBjpzTt+z+krFQKJsZ0u7M3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va8/MfX/3OwDhg853qTItMcGTCYBTDQLJr28X5oLMqs=;
 b=AxuHqt7dTwMWm8eNhuZJFwMsB2lmneuzDZdvv1cqU+4MaoZuoVZz6gf5CIDplIZbXe50f3Pja8f6k/CwyVBMKolHpPnQHzX0USYLoZrzH8wPCql8Kihtc3Ew35vrUQS/iDZg7MUyaHNVPpKlJCcjldcDfUnW6Scpl4SdmG38dn4WHSX5ehQxBn2uF2NguZBC29YaiantQRTpdzaUnwewPAfesEOqZZxAH5GfcISwdsNELDE0evLlg+Xp04v1PFhBihzUd02A+P9umxzsDxEd8qcTR9qGxf1B0NMcUo2VxVg7u7fnKIeLOU2yphbiTG5TIpKC2uawty3rHVSbuXkyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=va8/MfX/3OwDhg853qTItMcGTCYBTDQLJr28X5oLMqs=;
 b=lAbCw9Nviz0qoVu8fFn4v4QoywFDxWKcoDPGUJ2RErsHQRyg+SBLy814qzP8xxfc86e1f+St3hzEICcAI7pNztQ807ZUbBDXZDW0+6/PNt0jqbMhxfeqtxx5ezPq8wg7VmMV+lG7Gy1Ez4mHYt28in56wVOta+378CmWJKxk+AM=
Received: from BLAPR03CA0172.namprd03.prod.outlook.com (2603:10b6:208:32f::12)
 by SA3PR12MB7976.namprd12.prod.outlook.com (2603:10b6:806:312::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21; Sat, 30 Dec
 2023 17:27:50 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::1c) by BLAPR03CA0172.outlook.office365.com
 (2603:10b6:208:32f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 17:27:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:27:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:27:49 -0600
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
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Sat, 30 Dec 2023 11:23:34 -0600
Message-ID: <20231230172351.574091-19-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|SA3PR12MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 556dffed-7cc7-4a34-8e12-08dc095ca572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NDhigO3+dXYUVY5k+yXweDDw7cKVJkgSiuEpsxn5Opaa402Yu9eDggh+LWiLhv1NFZrebTDQqXXRm8u7UteqwiHslhGY99kVo+PkK+9ABmqkxbwW4goDTKOh8a04HpUmaZrp8Cvbx9ryMMKBYa+kjhz8hF8eS691AVb6z11KvjHOiA/nUXm3ldKArDSgO2KWJ5LVYL9G1ZihBcBMQzRE/u3ohzmLCNFp2Avn0RIpmCzr/vgyLSnhA+cRC3PTIwfAuoTwi3qRFl7sHgYOuTzB4xTbqoVw9BvUrOjFymiwR8TTNEsz0pTYVAJjrTtlhJDF4CC1vaWEmgIg192rS/vYUaiTE9zkiDgkVvQsB3WTw7B8C3POSa/AE2F2bFfuwSRq+JYqBO9YgyFv8HlTTCYwuMQSFNUkhfMKjlRvwZVdOZBXBjiChqsI4hA+NqKOiJEN7REXm4Gwaqrd6Rqu22+ogUSWEXjMpEU2/ipBcY2SlDrLEawbJwkJpwuDCQeLUlOWZkzCATtsPwX7pdErcJeO2a4I4tr8B3nfXEQb7wIDTJ+pyjRdlha8zYmuSV8H0zv2d1AFMWyEnLBXvKHXpd5XxrL+ZkF+NNgvnmdcHU3QSMchSimdP04WXMVUdr2zbPn4P4JdggHilhSMHrKWE/eycRvDuK6ub7P1sBF69tGy0eRq5GT4kTDkWyzpxwiHd5r2ouxR/myqS/ia5rTAQOoW0wWz+o24t4TzQ3wxuSVWQ9VVnL9C+dC+AfZP4xCtxmdy9vryS/V6KFS6L06jGvVRVg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(64100799003)(186009)(1800799012)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(8936002)(70586007)(478600001)(82740400003)(81166007)(6666004)(356005)(36756003)(86362001)(54906003)(7416002)(41300700001)(316002)(70206006)(16526019)(7406005)(5660300002)(6916009)(83380400001)(426003)(4326008)(336012)(2616005)(26005)(44832011)(47076005)(8676002)(36860700001)(1076003)(2906002)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:27:49.6688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 556dffed-7cc7-4a34-8e12-08dc095ca572
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7976

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into
the guest's memory. The data is encrypted with the cryptographic context
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
index e2f4d4bc125c..d60209e6e68b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -245,6 +245,36 @@ static void sev_decommission(unsigned int handle)
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
@@ -1990,6 +2020,154 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		data.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
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
@@ -2083,6 +2261,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index 9fe36408d55b..6e6e3a478022 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1872,6 +1872,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1988,6 +1989,24 @@ struct kvm_sev_snp_launch_start {
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


