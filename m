Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3F7CAA56
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjJPNsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjJPNsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:48:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5412818D;
        Mon, 16 Oct 2023 06:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+MDk5kANRm5BcbrbzMMn/36Hu+UQkfmPfsFepObH6AQFj/HMYVyIkOrBOPisB/kIAQvgUNiyvtqo8+GEx0T6ZH0YuO9rM8aTMpKkHdv20rim0LeIMx6B7/DmaDAWZIqoegUlyzHwTIW3wbx0ksMrN1puEJI+teGajCkAiXXRVT3F+RWtFvTSRZqg3mZ78Utgsj7yK5QFo3eynk5uYtQ+82AwNZ7CKLwsu+OS6SbdtA+H1Bc9VEJioUG/4QzCNBsvXY2kLoVwyFNjo2if+J31YnHn3UVmUAzzWp7ywNYRnu/Oxy3BFvWvGmuB0P5OJDeCw0nzxU6IxQBvKZRIu9UCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMnIdpbbXAEMf8v7Yolso74R3jaU1XgNaVsBHhZ7nH0=;
 b=GZhVmzEvStigfgFo0Xodhmn0G8Q5F1MUAtIeABYRjHvj56+F0EtMGCULtTLWNTF3YHLYAYNMxSJVEMXop0vpsuE6GYgKwLNyVPZzWwG+QHoB/LRCJD4HVbCDITDhdFg6Ie1JK7p4L+S5yM0lNu+iFZkWuwD7o/8cAWQ/yWQAIxV3jUi56qwlb71qTchnjRkX3c1F6ezAXjroyzdEu3StuaDYjHFkixCHP9m8cRHf0zIAQxYTYM27bHgSGGQlDndxMVMBCJrOzRpcGzQaUKEfSBQzgjWkikh/1Ak+AcQauGqRESoL44IfgocdIJIY0FITGRUPe5momS7Wh6LpKE89gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMnIdpbbXAEMf8v7Yolso74R3jaU1XgNaVsBHhZ7nH0=;
 b=oNlV4MPSIc2b2r3ySzijBfGuox9Lq+PAK/6ORzxyvlkrWTBe2kqAqgg0fLescXjay/LRpLsVKvzld+PMWhzAkhHgproxI4wPKdqkgLHfiB8u1RnmzWWoxyPj5qcdnqe5tWQZgGbZeZ/xZ9kexO2pqRNI4rxV9V3tVfvsROQ6e90=
Received: from BLAPR03CA0165.namprd03.prod.outlook.com (2603:10b6:208:32f::9)
 by SN7PR12MB7203.namprd12.prod.outlook.com (2603:10b6:806:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 13:47:44 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:32f:cafe::83) by BLAPR03CA0165.outlook.office365.com
 (2603:10b6:208:32f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:47:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:47:43 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 50/50] crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump
Date:   Mon, 16 Oct 2023 08:28:19 -0500
Message-ID: <20231016132819.1002933-51-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|SN7PR12MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: b956ddde-c7b8-4f37-67e8-08dbce4e79a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D+s0eWj7c5flkjjUS34wyurrQAGkgTQ8ThgMerXQeWUfN9CMgH8HcV1fSpGUKzi9Ro1Jy8L7OrpMUaPtCRQyEnLXYkQmex9O6+W+LeimOy6xnzEltIhc3Wpq0eUjZNJQhuTytqnvkU2FHa70355dcNFLWaNeBbSmV3Fzy7GLIjjrzZ6awDrb8DJ4ycmjyynC5quai44bSh6KrinH5C6hLLBHuaI+Ga41rR3xsI9gIfj3s1Fn9SvzAGN4Y8MJbjZ3BcQnl3H0jBLIRyFU/aJWF/i+zGTvEfifo0B0rgBda61xDkGmS5KbZT8NnU3YHHyqhoHLY0PPtnnwZlqP/k+KqLm4x2LuC8toQrb+Rke26RhquMgnIS+7NCKBaQ3iJYC3RHyow15v0t2og0jnT/E6WEPzm136rmJTfjU6VCow4jBMGAIi6wf6rxd7O8eFqOCmWGJfcjxN99VeXMWGM7jC1KLx5J9HvYHZns23vrBN0UGH+bMMuCi8xEark9hIQvw4VqgVgixzFQv7W6sgQVmfB+MXQLBXlGLxL+mKdtwj4/scyIr7MvmT56xdLocdAumCKX0FFhKlIUV3XA6Iy0VaPjzVi3Otb9VUjfiJs9qWaS1BWTYvdaBIuqmvvIWb2289d/esNhOgVrOqoGErBlLg3XccSPJ2Xs5laLyb42BhyNJEb9zNXbIpeLa32I5vjLETYpAc/KKnkvQrPQKvMBT1HQdCVGpnN6UhM1F97Thawybb/yIBsr2L591f5B/XU6YLtChugnVNHOZ7bAKZ3+oPeg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(64100799003)(82310400011)(186009)(1800799009)(451199024)(36840700001)(40470700004)(46966006)(47076005)(82740400003)(16526019)(26005)(426003)(336012)(44832011)(36756003)(70586007)(40480700001)(70206006)(83380400001)(316002)(54906003)(6916009)(86362001)(81166007)(2616005)(1076003)(356005)(36860700001)(2906002)(40460700003)(478600001)(6666004)(7406005)(7416002)(8936002)(8676002)(5660300002)(4326008)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:47:44.5798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b956ddde-c7b8-4f37-67e8-08dbce4e79a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7203
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add a kdump safe version of sev_firmware_shutdown() registered as a
crash_kexec_post_notifier, which is invoked during panic/crash to do
SEV/SNP shutdown. This is required for transitioning all IOMMU pages
to reclaim/hypervisor state, otherwise re-init of IOMMU pages during
crashdump kernel boot fails and panics the crashdump kernel. This
panic notifier runs in atomic context, hence it ensures not to
acquire any locks/mutexes and polls for PSP command completion
instead of depending on PSP command completion interrupt.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: remove use of "we" in comments]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/crash.c      |   7 +++
 drivers/crypto/ccp/sev-dev.c | 112 +++++++++++++++++++++++++----------
 2 files changed, 89 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index c92d88680dbf..23ede774d31b 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -59,6 +59,13 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_emergency_stop_pt();
 
+	/*
+	 * for SNP do wbinvd() on remote CPUs to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		wbinvd();
+
 	disable_local_APIC();
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 26218df1371e..21a3064f30c9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -21,6 +21,7 @@
 #include <linux/hw_random.h>
 #include <linux/ccp.h>
 #include <linux/firmware.h>
+#include <linux/panic_notifier.h>
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
 #include <linux/fs.h>
@@ -137,6 +138,26 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
 {
 	int ret;
 
+	/*
+	 * If invoked during panic handling, local interrupts are disabled,
+	 * so the PSP command completion interrupt can't be used. Poll for
+	 * PSP command completion instead.
+	 */
+	if (irqs_disabled()) {
+		unsigned long timeout_usecs = (timeout * USEC_PER_SEC) / 10;
+
+		/* Poll for SEV command completion: */
+		while (timeout_usecs--) {
+			*reg = ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
+			if (*reg & PSP_CMDRESP_RESP)
+				return 0;
+
+			udelay(10);
+		}
+
+		return -ETIMEDOUT;
+	}
+
 	ret = wait_event_timeout(sev->int_queue,
 			sev->int_rcvd, timeout * HZ);
 	if (!ret)
@@ -1058,17 +1079,6 @@ static int __sev_platform_shutdown_locked(int *error)
 	return ret;
 }
 
-static int sev_platform_shutdown(int *error)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_platform_shutdown_locked(NULL);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-
 static int sev_get_platform_state(int *state, int *error)
 {
 	struct sev_user_data_status data;
@@ -1483,7 +1493,7 @@ static int __sev_snp_init_locked(int *error)
 	return rc;
 }
 
-static int __sev_snp_shutdown_locked(int *error)
+static int __sev_snp_shutdown_locked(int *error, bool in_panic)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_shutdown_ex data;
@@ -1500,7 +1510,16 @@ static int __sev_snp_shutdown_locked(int *error)
 	sev_snp_certs_put(sev->snp_certs);
 	sev->snp_certs = NULL;
 
-	wbinvd_on_all_cpus();
+	/*
+	 * If invoked during panic handling, local interrupts are disabled
+	 * and all CPUs are stopped, so wbinvd_on_all_cpus() can't be called.
+	 * In that case, a wbinvd() is done on remote CPUs via the NMI
+	 * callback, so only a local wbinvd() is needed here.
+	 */
+	if (!in_panic)
+		wbinvd_on_all_cpus();
+	else
+		wbinvd();
 
 retry:
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
@@ -1543,17 +1562,6 @@ static int __sev_snp_shutdown_locked(int *error)
 	return ret;
 }
 
-static int sev_snp_shutdown(int *error)
-{
-	int rc;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_snp_shutdown_locked(error);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -2262,19 +2270,29 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
-static void sev_firmware_shutdown(struct sev_device *sev)
+static void __sev_firmware_shutdown(struct sev_device *sev, bool in_panic)
 {
 	int error;
 
-	sev_platform_shutdown(NULL);
+	__sev_platform_shutdown_locked(NULL);
 
 	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+		/*
+		 * The TMR area was encrypted, flush it from the cache
+		 *
+		 * If invoked during panic handling, local interrupts are
+		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
+		 * can't be used. In that case, wbinvd() is done on remote CPUs
+		 * via the NMI callback, so a local wbinvd() is sufficient here.
+		 */
+		if (!in_panic)
+			wbinvd_on_all_cpus();
+		else
+			wbinvd();
 
 		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
 					  get_order(sev_es_tmr_size),
-					  false);
+					  true);
 		sev_es_tmr = NULL;
 	}
 
@@ -2295,7 +2313,14 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	 */
 	free_snp_host_map(sev);
 
-	sev_snp_shutdown(&error);
+	__sev_snp_shutdown_locked(&error, in_panic);
+}
+
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	mutex_lock(&sev_cmd_mutex);
+	__sev_firmware_shutdown(sev, false);
+	mutex_unlock(&sev_cmd_mutex);
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -2313,6 +2338,28 @@ void sev_dev_destroy(struct psp_device *psp)
 	psp_clear_sev_irq_handler(psp);
 }
 
+static int sev_snp_shutdown_on_panic(struct notifier_block *nb,
+				     unsigned long reason, void *arg)
+{
+	struct sev_device *sev = psp_master->sev_data;
+
+	/*
+	 * Panic callbacks are executed with all other CPUs stopped,
+	 * so don't wait for sev_cmd_mutex to be released since it
+	 * would block here forever.
+	 */
+	if (mutex_is_locked(&sev_cmd_mutex))
+		return NOTIFY_DONE;
+
+	__sev_firmware_shutdown(sev, true);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block sev_snp_panic_notifier = {
+	.notifier_call = sev_snp_shutdown_on_panic,
+};
+
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2360,6 +2407,8 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &sev_snp_panic_notifier);
 	return;
 
 err:
@@ -2375,4 +2424,7 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
+
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &sev_snp_panic_notifier);
 }
-- 
2.25.1

