Return-Path: <kvm+bounces-5348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5670A820734
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C43F11F21D46
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A19BA2B;
	Sat, 30 Dec 2023 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tzt2Kqnt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AF71172D;
	Sat, 30 Dec 2023 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGlllydQN/7KDI1gwY1Vn4g618A8aOtUSeLyheXF58FoMx5G1+ckbZPE7papek7cVQkwE2E49y8cCxPLhGtD1NbRtL97yK+uTzxPNM2rjDPU43nXlPSSyxsSpKfC01ptP3Zy/T5xMouCJJYix/X+u8VJlDDE+AR8sQArcHgJiJndMQXhxA8E+J37WABs9GxJZo+sMbbbWwitLBmwardB8kLnc0A/3s2Ry1tpO7Xs5BgD8mjqiW8c7vc1S6UDIAhdSyj/Q+JSq1ULYpNOcI+4IA1dAYgudR+IPIcts5S0k5ys8V1BNNuXWrphs2JPFiBjmQNdua3zM4SbuBV+lgaI5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHY1+CjoWWGNfMvbFhJyCUFx492Lv4VkJxi2KrKaOu8=;
 b=SQKcsdctyB6oRbS9YSpIJP9+hno9CxgEJ0jKWbwdvfzZv9PvzIRhd3crm3nwZ+GF7JrI1AlnYh2ALCk8h2cmJbrnbvKXILhInz1eaVW6qzo+QJqcCyKG6AR7h0P1RE9CP+7HBUPJX8RPc6OYWZwpwhu92UiYJcyxYtsEl1rEc9EhNB4gFGEagDRW6ySDUPQymhX0RtOhl7E6Fg6YtiYUW+DcwpLHnlm2df4Q8arfmSwKdC+DJpGziyhElKSdbzMlHSTlbxpDSW4hy3JRpfy5wIssPnO2VOyei29WEtJ/df3axdJHdMHhzlCTmHH9kICzK54vUiKA5VYtoxrGIuZknw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHY1+CjoWWGNfMvbFhJyCUFx492Lv4VkJxi2KrKaOu8=;
 b=tzt2Kqntf2XWubz3UfUt8jP9OycPJpcXBI5R0f0Y/fSKBR69OH/mtwidx/wqtPe6b9NjOEKPjV6IMv9vzgx/Sva/mAvzi04twrv3eLuLEbybm5TfYJZbezJWPtvtVPkZBzVEx7oWtvBdZQXx7v1QOX1n7lQJYfUKucN+gIZD+z0=
Received: from DM6PR03CA0099.namprd03.prod.outlook.com (2603:10b6:5:333::32)
 by IA1PR12MB6041.namprd12.prod.outlook.com (2603:10b6:208:3d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:23:10 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::89) by DM6PR03CA0099.outlook.office365.com
 (2603:10b6:5:333::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:23:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:23:09 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
Subject: [PATCH v1 13/26] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date: Sat, 30 Dec 2023 10:19:41 -0600
Message-ID: <20231230161954.569267-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|IA1PR12MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: 6119b6a3-fc82-405a-bf42-08dc09539ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bTbJPPjzb2duqmfzpRdr4I4uFGcVRmLHYIFMGt5JKRfDv45XeUoVCF3e1I9rnC1+obnWFil1uXPcb5VdTZeoQMtwym/TlsxTNGZ1qK84keF4fzQnZavM7H9zWcX7ChJirbEolLtRJrRKQ25gy5vSZGTH889EJrkcwuouZLO/I4kQfY62cvngVcMBwQsc9ciLEBJ2iu4e9B2GXVOh+wsifvW3g+A4wNNLRWi0Qe0fvb5UsmE/wtstKIzXNC+CZ6jVklOJu76gRPjt5mIAfQi+CfYtarwPE2N6O5Ue8KkBCOpUGcIf8hO+YBVHCn5nFHIhgwLBNvM4AfQM9ej95e+YOqI+gTAX7q0s+9L+suov6Kqn929GnhDJxzIawstwtXEX09R0km0HBHcNLZOXayXuhGbX52fqe7M1VSTafoNfGScRon9CpD7ZquxD1P+RuNIMhX7xkcXt0/y5tIHGpA+KouwMucp6B5IGZcTJoVoutWD/m2oFsfJf2mjocT+bi8QhtxzjaH/0yapRZfJMKT5Nht3FOW1hV/ouuxxn/94erU5diAnDlPz7s7vrAjj6QFzNJZl7ban2BF8dPfOr9HRwI/pAffzbT82+KHAyYaCA736jtQCxPS/7fb8045rx6/k0CyYYnAHjXAErNC0wZJ+JPC/LDaqZkB6D4dNRyYvGAF2cRBGM0MqG2Ou3X9Bue2C7cQAJyPYZWuEqJHJBjv5xreOBcxKab7VLxJ+synI+tenEmwGcwwQNdmpPb1KVQYiKd9QWYJjhkcoL2nDj24ewRGPtBLJHzXPhApFys/egxjRYfgBTQ18V/0wYX0MuQI9BhePKRQsyXkwOC5gG7s1+6Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(230173577357003)(230273577357003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(81166007)(356005)(82740400003)(36756003)(40460700003)(40480700001)(86362001)(336012)(26005)(16526019)(426003)(1076003)(2616005)(6666004)(47076005)(54906003)(4326008)(478600001)(8676002)(316002)(8936002)(36860700001)(6916009)(70586007)(70206006)(83380400001)(41300700001)(5660300002)(7406005)(30864003)(44832011)(7416002)(2906002)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:23:09.7962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6119b6a3-fc82-405a-bf42-08dc09539ce1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6041

From: Brijesh Singh <brijesh.singh@amd.com>

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH
command to prepare for the first SNP guest launch after INIT.

During the execution of SNP_INIT command, the firmware configures
and enables SNP security policy enforcement in many system components.
Some system components write to regions of memory reserved by early
x86 firmware (e.g. UEFI). Other system components write to regions
provided by the operation system, hypervisor, or x86 firmware.
Such system components can only write to HV-fixed pages or Default
pages. They will error when attempting to write to other page states
after SNP_INIT enables their SNP enforcement.

Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
system physical address ranges to convert into the HV-fixed page states
during the RMP initialization. If INIT_RMP is 1, hypervisors should
provide all system physical address ranges that the hypervisor will
never assign to a guest until the next RMP re-initialization.
For instance, the memory that UEFI reserves should be included in the
range list. This allows system components that occasionally write to
memory (e.g. logging to UEFI reserved regions) to not fail due to
RMP initialization and SNP enablement.

Note that SNP_INIT(_EX) must not be executed while non-SEV guests are
executing, otherwise it is possible that the system could reset or hang.
The psp_init_on_probe module parameter was added for SEV/SEV-ES support
and the init_ex_path module parameter to allow for time for the
necessary file system to be mounted/available. SNP_INIT(_EX) does not
use the file associated with init_ex_path. So, to avoid running into
issues where SNP_INIT(_EX) is called while there are other running
guests, issue it during module probe regardless of the psp_init_on_probe
setting, but maintain the previous deferrable handling for SEV/SEV-ES
initialization.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: squash in psp_init_on_probe changes from Tom, reduce
 proliferation of 'probe' function parameter where possible]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c       |   5 +-
 drivers/crypto/ccp/sev-dev.c | 282 ++++++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  17 ++-
 4 files changed, 283 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0c580607f00..58e19d023d70 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -246,6 +246,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_platform_init_args init_args = {0};
 	int asid, ret;
 
 	if (kvm->created_vcpus)
@@ -262,7 +263,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_no_asid;
 	sev->asid = asid;
 
-	ret = sev_platform_init(&argp->error);
+	init_args.probe = false;
+	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
 
@@ -274,6 +276,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return 0;
 
 e_free:
+	argp->error = init_args.error;
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b2672234f386..85634d4f8cfe 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -29,6 +29,7 @@
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
+#include <asm/e820/types.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -37,6 +38,10 @@
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
 
+/* Minimum firmware version required for the SEV-SNP support */
+#define SNP_MIN_API_MAJOR	1
+#define SNP_MIN_API_MINOR	51
+
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
@@ -80,6 +85,13 @@ static void *sev_es_tmr;
 #define NV_LENGTH (32 * 1024)
 static void *sev_init_ex_buffer;
 
+/*
+ * SEV_DATA_RANGE_LIST:
+ *   Array containing range of pages that firmware transitions to HV-fixed
+ *   page state.
+ */
+struct sev_data_range_list *snp_range_list;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -480,20 +492,165 @@ static inline int __sev_do_init_locked(int *psp_ret)
 		return __sev_init_locked(psp_ret);
 }
 
-static int __sev_platform_init_locked(int *error)
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+}
+
+static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
+{
+	struct sev_data_range_list *range_list = arg;
+	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
+	size_t size;
+
+	/*
+	 * Ensure the list of HV_FIXED pages that will be passed to firmware
+	 * do not exceed the page-sized argument buffer.
+	 */
+	if ((range_list->num_elements * sizeof(struct sev_data_range) +
+	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
+		return -E2BIG;
+
+	switch (rs->desc) {
+	case E820_TYPE_RESERVED:
+	case E820_TYPE_PMEM:
+	case E820_TYPE_ACPI:
+		range->base = rs->start & PAGE_MASK;
+		size = (rs->end + 1) - rs->start;
+		range->page_count = size >> PAGE_SHIFT;
+		range_list->num_elements++;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int __sev_snp_init_locked(int *error)
 {
-	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
 	struct psp_device *psp = psp_master;
+	struct sev_data_snp_init_ex data;
 	struct sev_device *sev;
+	void *arg = &data;
+	int cmd, rc = 0;
 
-	if (!psp || !psp->sev_data)
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENODEV;
 
 	sev = psp->sev_data;
 
+	if (sev->snp_initialized)
+		return 0;
+
+	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		return 0;
+	}
+
+	/*
+	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
+	 * across all cores.
+	 */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
+
+	/*
+	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
+	 * system physical address ranges to convert into the HV-fixed page states
+	 * during the RMP initialization.  For instance, the memory that UEFI
+	 * reserves should be included in the range list. This allows system
+	 * components that occasionally write to memory (e.g. logging to UEFI
+	 * reserved regions) to not fail due to RMP initialization and SNP enablement.
+	 */
+	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
+		/*
+		 * Firmware checks that the pages containing the ranges enumerated
+		 * in the RANGES structure are either in the Default page state or in the
+		 * firmware page state.
+		 */
+		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!snp_range_list) {
+			dev_err(sev->dev,
+				"SEV: SNP_INIT_EX range list memory allocation failed\n");
+			return -ENOMEM;
+		}
+
+		/*
+		 * Retrieve all reserved memory regions setup by UEFI from the e820 memory map
+		 * to be setup as HV-fixed pages.
+		 */
+		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
+					 snp_range_list, snp_filter_reserved_mem_regions);
+		if (rc) {
+			dev_err(sev->dev,
+				"SEV: SNP_INIT_EX walk_iomem_res_desc failed rc = %d\n", rc);
+			return rc;
+		}
+
+		memset(&data, 0, sizeof(data));
+		data.init_rmp = 1;
+		data.list_paddr_en = 1;
+		data.list_paddr = __psp_pa(snp_range_list);
+		cmd = SEV_CMD_SNP_INIT_EX;
+	} else {
+		cmd = SEV_CMD_SNP_INIT;
+		arg = NULL;
+	}
+
+	/*
+	 * The following sequence must be issued before launching the
+	 * first SNP guest to ensure all dirty cache lines are flushed,
+	 * including from updates to the RMP table itself via RMPUPDATE
+	 * instructions:
+	 *
+	 * - WBINDV on all running CPUs
+	 * - SEV_CMD_SNP_INIT[_EX] firmware command
+	 * - WBINDV on all running CPUs
+	 * - SEV_CMD_SNP_DF_FLUSH firmware command
+	 */
+	wbinvd_on_all_cpus();
+
+	rc = __sev_do_cmd_locked(cmd, arg, error);
+	if (rc)
+		return rc;
+
+	/* Prepare for first SNP guest launch after INIT. */
+	wbinvd_on_all_cpus();
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+	if (rc)
+		return rc;
+
+	sev->snp_initialized = true;
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+
+	return rc;
+}
+
+static int __sev_platform_init_locked(int *error)
+{
+	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+	struct sev_device *sev;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	if (!sev_es_tmr) {
+		/* Obtain the TMR memory area for SEV-ES use */
+		sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
+		if (sev_es_tmr)
+			/* Must flush the cache before giving it to the firmware */
+			clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
+		else
+			dev_warn(sev->dev,
+				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
+		}
+
 	if (sev_init_ex_buffer) {
 		rc = sev_read_init_ex_file();
 		if (rc)
@@ -536,12 +693,46 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
-int sev_platform_init(int *error)
+static int _sev_platform_init_locked(struct sev_platform_init_args *args)
+{
+	struct sev_device *sev;
+	int rc;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (sev->state == SEV_STATE_INIT)
+		return 0;
+
+	/*
+	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
+	 * so perform SEV-SNP initialization at probe time.
+	 */
+	rc = __sev_snp_init_locked(&args->error);
+	if (rc && rc != -ENODEV) {
+		/*
+		 * Don't abort the probe if SNP INIT failed,
+		 * continue to initialize the legacy SEV firmware.
+		 */
+		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
+			rc, args->error);
+	}
+
+	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
+	if (args->probe && !psp_init_on_probe)
+		return 0;
+
+	return __sev_platform_init_locked(&args->error);
+}
+
+int sev_platform_init(struct sev_platform_init_args *args)
 {
 	int rc;
 
 	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_platform_init_locked(error);
+	rc = _sev_platform_init_locked(args);
 	mutex_unlock(&sev_cmd_mutex);
 
 	return rc;
@@ -852,6 +1043,55 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static int __sev_snp_shutdown_locked(int *error)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_shutdown_ex data;
+	int ret;
+
+	if (!sev->snp_initialized)
+		return 0;
+
+	memset(&data, 0, sizeof(data));
+	data.length = sizeof(data);
+	data.iommu_snp_shutdown = 1;
+
+	wbinvd_on_all_cpus();
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
+	/* SHUTDOWN may require DF_FLUSH */
+	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+		if (ret) {
+			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
+			return ret;
+		}
+		/* reissue the shutdown command */
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data,
+					  error);
+	}
+	if (ret) {
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		return ret;
+	}
+
+	sev->snp_initialized = false;
+	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
+
+	return ret;
+}
+
+static int sev_snp_shutdown(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_shutdown_locked(error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1299,6 +1539,8 @@ int sev_dev_init(struct psp_device *psp)
 
 static void sev_firmware_shutdown(struct sev_device *sev)
 {
+	int error;
+
 	sev_platform_shutdown(NULL);
 
 	if (sev_es_tmr) {
@@ -1315,6 +1557,13 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 			   get_order(NV_LENGTH));
 		sev_init_ex_buffer = NULL;
 	}
+
+	if (snp_range_list) {
+		kfree(snp_range_list);
+		snp_range_list = NULL;
+	}
+
+	sev_snp_shutdown(&error);
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -1345,7 +1594,8 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int error, rc;
+	struct sev_platform_init_args args = {0};
+	int rc;
 
 	if (!sev)
 		return;
@@ -1370,23 +1620,15 @@ void sev_pci_init(void)
 		}
 	}
 
-	/* Obtain the TMR memory area for SEV-ES use */
-	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
-	if (sev_es_tmr)
-		/* Must flush the cache before giving it to the firmware */
-		clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
-	else
-		dev_warn(sev->dev,
-			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-
-	if (!psp_init_on_probe)
-		return;
-
 	/* Initialize the platform */
-	rc = sev_platform_init(&error);
+	args.probe = true;
+	rc = sev_platform_init(&args);
 	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			error, rc);
+			args.error, rc);
+
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 778c95155e74..85506325051a 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+
+	bool snp_initialized;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 983d314b5ff5..a39a9e5b5bc4 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -789,10 +789,23 @@ struct sev_data_snp_shutdown_ex {
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
+/**
+ * struct sev_platform_init_args
+ *
+ * @error: SEV firmware error code
+ * @probe: True if this is being called as part of CCP module probe, which
+ *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
+ *  unless psp_init_on_probe module param is set
+ */
+struct sev_platform_init_args {
+	int error;
+	bool probe;
+};
+
 /**
  * sev_platform_init - perform SEV INIT command
  *
- * @error: SEV command return code
+ * @args: struct sev_platform_init_args to pass in arguments
  *
  * Returns:
  * 0 if the SEV successfully processed the command
@@ -801,7 +814,7 @@ struct sev_data_snp_shutdown_ex {
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
  */
-int sev_platform_init(int *error);
+int sev_platform_init(struct sev_platform_init_args *args);
 
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
-- 
2.25.1


