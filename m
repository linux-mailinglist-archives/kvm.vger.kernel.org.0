Return-Path: <kvm+bounces-5357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 861DA82074F
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0552EB211FC
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8189A11735;
	Sat, 30 Dec 2023 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rZzgJrB7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43973156C9;
	Sat, 30 Dec 2023 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXPz55PaMefmlw+11yhUypRd6Z5pRDpWeeHFjG0PkCff4sVq8iXohTXWlF5JM6xFr14AclcCLaLCWpu6qkI2pYfD3kZZN8LAMEuPWihVt6rLDKkILzz0uONOM6SDQpP4X7Mqj4CRn7gLSGkmjGZAVUYwm7IZ1sN3IMNtoNzju3gml3vE+65fPpTJ0slWQE4qx3u3M/onU//0gpMCwZ6/Ndnn/RW4XstL8H9ajSpKdE8XUEAxvtxC98oZXiWIm/D/apta2u/ISIGi6rr3h9w/uh+/MgF8NDdpWOXqnwKGyDvPbLt6uOw3HUHEd5OUrHzmbOtJjNu5pZvr0AQ9VIbZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfU1VrFxGMklLv6RK2V7NB20S6aT09Wsj0ScgZX/u9w=;
 b=JV80SMzLHIGWz3w7tjVrArcMNLPd6rPcPiAyZXBFRAhtdiWTI9NzCNZvwWgAnYtvsEtTvhSnJf0HW33hLkUMXpUBgn+KCypy9/S5YJ8icpsutMYcPLQwpblKfQc9DFqUpnWtavzmRuLMSX9cozQ+ZtSzWKLmcxmL50Hph0AFToqZu/VJlhQJb/l6OvFotAdbRq4Ky8TKXNKAlgudHCG/dgJES7QimxFmaCTmvXRhhmmipr53olKqAKMnsxOS4sWgdQnkak1emRgq7c9MBBVv2n0d2NI2c4l1EwYT5rEpzlcTXAhrQqvNr67J1RpOhewFwIg9Hn0MyoeAQffPrqfWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfU1VrFxGMklLv6RK2V7NB20S6aT09Wsj0ScgZX/u9w=;
 b=rZzgJrB7aEqObyyAZWHmWa+tyXIWTgGti5I5Ip2UkQAmw8hG6NiPxXTg/mUsv6TasrXhwv0nq9PScEUteslxDUlOvWgKnshVHko0+/EWY+lO7uDAEq4fVotsG/x9SXJFYgdLlsCmLPD7h7rz8q4HOzVNaitCSu0veCz2SO66lwY=
Received: from DS7PR05CA0008.namprd05.prod.outlook.com (2603:10b6:5:3b9::13)
 by SN7PR12MB6741.namprd12.prod.outlook.com (2603:10b6:806:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:26:17 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::25) by DS7PR05CA0008.outlook.office365.com
 (2603:10b6:5:3b9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 16:26:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:26:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:26:16 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 21/26] crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump
Date: Sat, 30 Dec 2023 10:19:49 -0600
Message-ID: <20231230161954.569267-22-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|SN7PR12MB6741:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b965103-d486-49b9-1063-08dc09540c8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Zg7j763kJKv34juQm0NDjU21jbccHMc6J6yve9nqo5TTvMJsIPero6RkTtXcAWciv7h1dLz54VJOgX1DKKytHQqe/95/lfXRKBzTbpOUQXqpvLBgFM3+PpLr28sF1CYsGhnJ8LCz2xaJeC6qWF/YiiACDOQXYWGI+yrfbVRnIeZJ7NUJQzLh/iXhRXwcoI1YuaY/walB34uCkpyp+/6ZBhcxH0kbYli8hAiOhXMw9i/Duqx6VJ75czYc1s19vHIY0tSHZ3yZMU/tXHXiDCLD4nAIAc4MDH9lWBmHNqeZTXP64PTY9uMBbolkYv61KzxF+B5df3NMl9IDEw5n6SXJtDTS32PPnJ5I9ljBLf4421UI/FJ5h+CiBJxXFkPka/QT2WSnediAwgO9Vw2O3aU/9DMUi4RRhsfQl9RFRgUIi9XW/wEeQa0cI0/+C+F+7PqCOn02pOYAojeWD3dfmQ9quinZ4p5Pl7xyc3Ox1M/X55GBxz+SID9zECx4Yp0uMAp1PFvtfpLsV3PxKr2aqM+jIFvu4SckERqPKM9avc5SeEFsfk7/li7lZwGfsdRUCefCPk/c0+8z+rIUQsF1GrRJyD1B2Vq5xHsr1N6N/fTR54pMjPyHHvBCf2r1O3zcWKF0sDPT8CDpFfsGz06QAAb0DRdzdF39bIheoG9bwOIljQs3YgjIpn8bynXjzzTuYcB4KLoaRAUw4iB3ftDWAVIHgf8fBXz43L/fTKlKmAKfIXztGlrIXLX19LBh5McXHZ0NtTvOoVg1XvF172GedPl+InUFTrPjYQU5RdL3dzlkIIz1yfmJrLeHkg8e6CzLJ90r
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230173577357003)(230273577357003)(230922051799003)(451199024)(1800799012)(64100799003)(82310400011)(186009)(46966006)(36840700001)(40470700004)(40480700001)(426003)(83380400001)(16526019)(1076003)(26005)(2616005)(40460700003)(336012)(478600001)(47076005)(6666004)(41300700001)(316002)(54906003)(70206006)(70586007)(6916009)(36756003)(44832011)(4326008)(8936002)(8676002)(36860700001)(356005)(81166007)(86362001)(82740400003)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:26:17.1264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b965103-d486-49b9-1063-08dc09540c8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6741

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
index cbffb27f6468..b8c44c492d43 100644
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
index 9792c7af3005..598878e760bc 100644
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
@@ -144,6 +145,26 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
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
@@ -1358,17 +1379,6 @@ static int __sev_platform_shutdown_locked(int *error)
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
@@ -1644,7 +1654,7 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
-static int __sev_snp_shutdown_locked(int *error)
+static int __sev_snp_shutdown_locked(int *error, bool in_panic)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_shutdown_ex data;
@@ -1657,7 +1667,16 @@ static int __sev_snp_shutdown_locked(int *error)
 	data.length = sizeof(data);
 	data.iommu_snp_shutdown = 1;
 
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
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
@@ -1701,17 +1720,6 @@ static int __sev_snp_shutdown_locked(int *error)
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
@@ -2191,19 +2199,29 @@ int sev_dev_init(struct psp_device *psp)
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
 
@@ -2219,7 +2237,14 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		snp_range_list = NULL;
 	}
 
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
@@ -2237,6 +2262,28 @@ void sev_dev_destroy(struct psp_device *psp)
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
@@ -2274,6 +2321,8 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &sev_snp_panic_notifier);
 	return;
 
 err:
@@ -2288,4 +2337,7 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
+
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &sev_snp_panic_notifier);
 }
-- 
2.25.1


