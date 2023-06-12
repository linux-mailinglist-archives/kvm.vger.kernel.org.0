Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD72472B676
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbjFLEc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbjFLEb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:31:57 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193F210EB;
        Sun, 11 Jun 2023 21:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEW2lAsy/SpMy6HClYRfLE2cqoZPjqGDJiuyY33JssL9+CxuooFyehaieyb/cNnZXL+CiTOg8MjfyCa36qdxonKdFqbFPG2VtpB6nRuSwvIPdoCwhpgdjBYFAUGBmWK7EIUCh0ALTIPU1DaYeKqfvnFkQDHXejDwrEQXTgdbu/KARLHQR53s76PlYL5k2BjIOOuj6McmL7gn/YlS/zWiLJxcAGj7kDSFmksDVaqW7ajf2AhD4IxrRWe5oiBTdw7xkONRlbdbxErhR/jLQ8+AIWbNAWCnuDwU9ihx+zldn/IyI5iSryxFsW9tkO3GOI1d8LjrBDE4wQOPj51f4uTPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xj2/U+IIWPesaqCOErKg1ZrLHLEuUpPUlqimBPs3Vo=;
 b=JC5u+MdZxXL0SB5ek0dLbNYTVMFj98SRdaMWw6glDZTHWlsi7w5sp6Akj4BjvBBGTcq+sp85JgjHN8uqKTHxByg/eOBaMuWuc4YP2bB+04ZdvZF9ovVwRBFOiIOkz4iaU9NPGCLDGmM9lLMj/+7wyvHOitRjs3NGZHYEufJqkyczMTHA8mET11ZnQkFuNjh7SaYAMM4DkVCf0EpZ1xOr7rcSOd799/+1SjaYAeYmEW4lPG+0vWZ6ii4iRzNYzfFLHbd/ds8QGt6waenozc3gdKuDGQk2MyuekHEKAsp8AC2EfuY4vIPlq5oC2pUDQFOEvIGpJ4f+Scz8oz9UKHEJVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xj2/U+IIWPesaqCOErKg1ZrLHLEuUpPUlqimBPs3Vo=;
 b=V4IjMOKt1RDBfKmtcF22eBSmW2Spcnbl7rXGOH2QzHOganmsgS8eiScXp2Owd+tW6mhbt6ON+e2InIhwdUKKcQEW/oaIh7EPjbRPstqfXnC2vcBRlrnaOezushkkIMQyJ8NQlVt/3Gmn9YXFrNk3zDDG99GLb0mi8vgnXIJYRL4=
Received: from DS7PR05CA0041.namprd05.prod.outlook.com (2603:10b6:8:2f::8) by
 CH0PR12MB5073.namprd12.prod.outlook.com (2603:10b6:610:e0::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Mon, 12 Jun 2023 04:31:24 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::bf) by DS7PR05CA0041.outlook.office365.com
 (2603:10b6:8:2f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:31:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:31:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:31:23 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: [PATCH RFC v9 17/51] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Sun, 11 Jun 2023 23:25:25 -0500
Message-ID: <20230612042559.375660-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|CH0PR12MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d9803f-3d76-49bb-09ad-08db6afde17c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUux1d9jyn/bXMRejASeMzmuK+MHo1xI208XauE+psHBZrlF3PntuUmMpKzL9q9MRJuz/yMI9MGijA0JW3cT5JAN9fdtJqjhlaOHVUnlPA9o+xQSB1ZjXGaDgQuk2W6Lpzkzg8GOJvprCCj+6DVdTehVcxxNWrAJ2QMIhUEGu/wTP3YBykBhrYLjBz//dXiVvQeewBQcI5i4bydIacOPX/k+HEuQXVBqiKxeEAN0b8jl1o2NNC07tCOuyVuf8TD7BsdYJnZAvAajwsU7k45QFpHj38dLvLyvx4voQ9z4uatT3uLCHEG/hIljCKTTaNidPA2WdmLef7Of/izenQcSb0D5FgLnpSsRo3JwO8wGKIo4xX4PB8eTjf32qTZ4GoiILXgZcDvXTO90ggAMPSfhGDmvTAviCmMhchDRJkc0fMnIe5D+hzqcrCN4YJlfexpqFNf4MJDpkDVsn0qLwQAT/Oe4EaCMuf1Ak/Z5uoYORricZuGOZUQs5+U2ByIwgPbi6H+rq5KrorKhp9D+B26iDBMXmuj8fIy2WqgQUmKcXc8trJScC5rzE6CdfGFjUbPrwEEj4nyw0su/JjEKdGbdA6subuBD9oKOkQ2BxLcYKhjScP04bZkeYaTFveYIazjZuecGF7VsbPtoesAoF330n1k0sZDR/zuGiGU9PAinDJCgiOH9KpckzDe0iRRmJ7BnLBefmjTd8GUDcr1KybBwEtLQiUbtojdJKWrCKMZJAOTj/Efp2cYruiwilCtSxRtaZbYgrnTHdDhbmXvFB/KFsQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(86362001)(82310400005)(7406005)(7416002)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(81166007)(1076003)(356005)(36860700001)(8936002)(44832011)(36756003)(336012)(4326008)(426003)(6916009)(70586007)(47076005)(70206006)(478600001)(186003)(16526019)(30864003)(2906002)(54906003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:31:24.3923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d9803f-3d76-49bb-09ad-08db6afde17c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 242 +++++++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h |   2 +
 2 files changed, 234 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ab3572286755..d3764ee073f3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -27,6 +27,7 @@
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
+#include <asm/e820/types.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -35,6 +36,10 @@
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
 
+/* Minimum firmware version required for the SEV-SNP support */
+#define SNP_MIN_API_MAJOR	1
+#define SNP_MIN_API_MINOR	51
+
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
@@ -78,6 +83,14 @@ static void *sev_es_tmr;
 #define NV_LENGTH (32 * 1024)
 static void *sev_init_ex_buffer;
 
+/*
+ * SEV_DATA_RANGE_LIST:
+ *   Array containing range of pages that firmware transitions to HV-fixed
+ *   page state.
+ */
+struct sev_data_range_list *snp_range_list;
+static int __sev_snp_init_locked(int *error);
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -462,7 +475,8 @@ static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
-	int rc = 0, psp_ret = -1;
+	int psp_ret = -1;
+	int rc;
 	int (*init_function)(int *error);
 
 	if (!psp || !psp->sev_data)
@@ -473,6 +487,26 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	rc = __sev_snp_init_locked(error);
+	if (rc && rc != -ENODEV) {
+		/*
+		 * Don't abort the probe if SNP INIT failed,
+		 * continue to initialize the legacy SEV firmware.
+		 */
+		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n", rc, *error);
+	}
+
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
 		init_function = __sev_init_ex_locked;
 		rc = sev_read_init_ex_file();
@@ -832,6 +866,191 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
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
+{
+	struct psp_device *psp = psp_master;
+	struct sev_data_snp_init_ex data;
+	struct sev_device *sev;
+	int rc = 0;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
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
+
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
+
+		/*
+		 * Before invoking SNP_INIT_EX with INIT_RMP=1, make sure that
+		 * all dirty cache lines containing the RMP are flushed.
+		 *
+		 * NOTE: that includes writes via RMPUPDATE instructions, which
+		 * are also cacheable writes.
+		 */
+		wbinvd_on_all_cpus();
+
+		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX, &data, error);
+		if (rc)
+			return rc;
+	} else {
+		/*
+		 * SNP_INIT is equivalent to SNP_INIT_EX with INIT_RMP=1, so
+		 * just as with that case, make sure all dirty cache lines
+		 * containing the RMP are flushed.
+		 */
+		wbinvd_on_all_cpus();
+
+		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
+		if (rc)
+			return rc;
+	}
+
+	/* Prepare for first SNP guest launch after INIT */
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
+retry:
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
+	/* SHUTDOWN may require DF_FLUSH */
+	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+		if (ret) {
+			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
+			return ret;
+		}
+		goto retry;
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
@@ -1279,6 +1498,8 @@ int sev_dev_init(struct psp_device *psp)
 
 static void sev_firmware_shutdown(struct sev_device *sev)
 {
+	int error;
+
 	sev_platform_shutdown(NULL);
 
 	if (sev_es_tmr) {
@@ -1295,6 +1516,13 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
@@ -1350,15 +1578,6 @@ void sev_pci_init(void)
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
 	if (!psp_init_on_probe)
 		return;
 
@@ -1368,6 +1587,9 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
 
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
+
 	return;
 
 err:
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 666c21eb81ab..34767657beb5 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+
+	bool snp_initialized;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.25.1

