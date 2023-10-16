Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3E37CA977
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjJPNb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjJPNbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:31:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234F8183;
        Mon, 16 Oct 2023 06:31:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgO9nBRJJFHhO9TAg40rBXiljAoZtciwMQfcNBNKpasldoo1gyWJj7ItmxbYJiM3GOIB/CYmI9ut4mMeu6bql+FUVsPKA+ttK6Gmwr8xrDPZMELryFWT/yW45L32QoiKZPBEt/S5iisrdEJFuUXD9YFrN9CUDyKW+ozUtcjHq+hUPq9zmF0h+f0T1yZpfG4pgITNbfUcdtEe3iyyZLZAjAbJSWsxV6pQOJJ9pCr8+kPkzDS1i42EN3uPWRX/nDO2md6gW+t7+UdpjsWrpMZYbR4kYja/S/W9uyC0/vb2Dlwk4fY7phRm4sHCWwTZVByhL1VNT5GnrTsRibIHVzyVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0HLqEo8WqgfDKO9YsYruiIitgtkLVF63U1PvkAKfnU=;
 b=c5W2VnBKPSs45irV/+5OoGJ8b0idSDJD8ZYtIkjdMMjlAEeJojbT5QJqlrEFUSgpjoKcXUkZFxk7H2jsXKuMuk+1eyOzwybaAqBf5kp1CiBwGrGDJw6ePJIFg66WOAWh8N1CTs7qsGqWdh4jT8EMMsQZ+d1GFdNcPZjfOwQUrk8+JhGvOIG5hcd5fXmVN9ILf8IFfitDpkUdiSNxYFiIPz1cE7RP+Gm3+jPrNnl5xexK+nPbHGie3hkKcsIYVXsTYM9OFEEnQOfqyOW+F2R/5dR9qBD8gshHJ/LdmMlkiVzVMuphYUcg4/cEZso5nCq/wGeW2tjwOCAu04iEBM8+pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0HLqEo8WqgfDKO9YsYruiIitgtkLVF63U1PvkAKfnU=;
 b=zN62vXPs5ubQJZDgELRD0T4bHYe6NhC19BKxAyjv7A+GWyYosmpxFEJhu4CoRUD2rFjgQCV8rxw4YnXIgELoqFJ9tgMvhsFppHUL/ZoFF+u8gsfRkV/VVkV+vhNIiSPQR1e7YoT/4W38GvIrv/apf+KzeiQgkFm2I4L4/k4K2o0=
Received: from MW2PR16CA0072.namprd16.prod.outlook.com (2603:10b6:907:1::49)
 by MN0PR12MB6368.namprd12.prod.outlook.com (2603:10b6:208:3d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:31:38 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::d7) by MW2PR16CA0072.outlook.office365.com
 (2603:10b6:907:1::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:31:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:31:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:31:33 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: [PATCH v10 14/50] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Mon, 16 Oct 2023 08:27:43 -0500
Message-ID: <20231016132819.1002933-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|MN0PR12MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: f5abca28-f05f-45fc-2385-08dbce4c396a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNdIdV5NUnP5khNyHn/uztlzqsFhodf0PubCxPYeyL7r6f6DK5ckwzSMB5GfXGoJA/ApujUvawRxpAC3nZEIGRB5mstsD3oSQgv4cwMtBxyRBrtQ7XVUB7ZlNy9LX5n8oUTxpS44cFXNMMrle96Dg9h2VXvcDPNJlTMkBFohpbJrb9kTu2X+6MFk/sXEIAzgvSRTIIwEroNg0XCdtNp1XeNfhvG+k0BWUG1JRtYhFDZ4+WqOZaFO+kg5zncvI3CLnFW1enTjaG6SbPKhWCmVjGzuLWRw39GjfWE4lVjlTS9mTG3WORoR8NED5huAPsjvEYG38wtlNOPGteTRc1GP3/f2Kp5oPRBJEkxE7Brwtoc+jeaXX+3quPZMAUdZGCuESLQ1fAfA6dTfS/hyIxb7h3nn2JWV/OTWItvC/K3Ik4EcjZxOTccsyOb/X9ZqIPLW/H8md9LDgW4B+uVMU+S4W4lUb9//mvkTOoR5K1oBv1idXp10SwL44xdiLpJ7MJPvfp7Y3//49krCWmjZS29YurkqQyO3/1kpBMqnJLIZZoTxrezbBZYQDkywIREZD+gRDyFAH7SMs84x58LBQmWNh4QGDkRd5T9GG+KmJXzNkQKSYlhx4f8UP/6iyXhpVg47433e7W1F6lKubumoxsEMeWh5NvsQsJ1v1p4t6WMdosGBwDQ4Jq6iBSt9ZTR72e9B6csdb69MyvZu5WnSjc0t2AmpGU4/QyUHdrvsWxHhyoFdbRq7IFanj6k9PT38D1MaV1lDq6KSmBtdWflpMcj3Lw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(186009)(1800799009)(82310400011)(64100799003)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(336012)(426003)(16526019)(36860700001)(1076003)(2616005)(30864003)(7406005)(83380400001)(7416002)(47076005)(54906003)(70206006)(8676002)(4326008)(316002)(8936002)(70586007)(6916009)(6666004)(41300700001)(44832011)(81166007)(5660300002)(478600001)(2906002)(82740400003)(356005)(40480700001)(86362001)(36756003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:31:37.7588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5abca28-f05f-45fc-2385-08dbce4c396a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6368
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: squash in psp_init_on_probe changes from Tom]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 272 +++++++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h |   2 +
 2 files changed, 259 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c2da92f19ccd..fae1fd45eccd 100644
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
 
@@ -80,6 +85,14 @@ static void *sev_es_tmr;
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
@@ -466,9 +479,9 @@ static inline int __sev_do_init_locked(int *psp_ret)
 		return __sev_init_locked(psp_ret);
 }
 
-static int __sev_platform_init_locked(int *error)
+static int ___sev_platform_init_locked(int *error, bool probe)
 {
-	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
+	int rc, psp_ret = SEV_RET_NO_FW_CALL;
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 
@@ -480,6 +493,34 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	/*
+	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
+	 * so perform SEV-SNP initialization at probe time.
+	 */
+	rc = __sev_snp_init_locked(error);
+	if (rc && rc != -ENODEV) {
+		/*
+		 * Don't abort the probe if SNP INIT failed,
+		 * continue to initialize the legacy SEV firmware.
+		 */
+		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n", rc, *error);
+	}
+
+	/* Delay SEV/SEV-ES support initialization */
+	if (probe && !psp_init_on_probe)
+		return 0;
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
 		rc = sev_read_init_ex_file();
 		if (rc)
@@ -522,6 +563,11 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
+static int __sev_platform_init_locked(int *error)
+{
+	return ___sev_platform_init_locked(error, false);
+}
+
 int sev_platform_init(int *error)
 {
 	int rc;
@@ -534,6 +580,17 @@ int sev_platform_init(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
 
+static int sev_platform_init_on_probe(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = ___sev_platform_init_locked(error, true);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
 static int __sev_platform_shutdown_locked(int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -838,6 +895,191 @@ static int sev_update_firmware(struct device *dev)
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
@@ -1285,6 +1527,8 @@ int sev_dev_init(struct psp_device *psp)
 
 static void sev_firmware_shutdown(struct sev_device *sev)
 {
+	int error;
+
 	sev_platform_shutdown(NULL);
 
 	if (sev_es_tmr) {
@@ -1301,6 +1545,13 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
@@ -1356,24 +1607,15 @@ void sev_pci_init(void)
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
+	rc = sev_platform_init_on_probe(&error);
 	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
 
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
+
 	return;
 
 err:
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
-- 
2.25.1

