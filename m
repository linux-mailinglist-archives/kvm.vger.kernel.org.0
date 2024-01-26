Return-Path: <kvm+bounces-7063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC1483D3A2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28AECB24509
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12BC10A35;
	Fri, 26 Jan 2024 04:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JDR7d7tf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2612F134B5;
	Fri, 26 Jan 2024 04:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244285; cv=fail; b=Pndh525IlrLrYSlWv10/WTyewTWfXv0n/3k/A6n3Zptro1eDCiF7BZreAZqss57yV/q0ZsT3Xbf669Bjb7Ugx2oOQcKtxD4ElZp4t4s4XOGDYUu/tEIOQ0K9rVGK/0x9GzXESVPRRGqf/pRP5NDJ8KVGmqsEP9kRedPJ/Kh1OrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244285; c=relaxed/simple;
	bh=DNaPTWPXOLR6CYzR6MhHZPYTeW764AWSsqFWVyJJHgQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2SZzmaIvvsLnJKWou1MAjncNny0RIajgeP+ma+b4RIvgr1m/3fyUt8iFSHsukUtCXNRTMqb0Gy73y5LseOg1xQVkB3v8QpNFFsybRV9jto0zcpal1utj1ejJGCJPZrU00QGHWyrjaa38yYvMLniQbVcxWcQOqFoutEajkisg1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JDR7d7tf; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNuLO09Y2Icd6tQwSLgqg2yFGdKF7CJMhHrKbvt5AgX6G1IzxKO0TiY9plBWBpgv1tmnD6Y++fFy+PjRt4TTE2EbbIfVG/EeQbVxcSIZvwKi1zHBVYKIJvod+rq+ssXJTCV8wp/wYYiRLOM4132Dg6Ryif5hX/LyNBGh1+q6KB34xK2Lxl2prPbCxIPVBtxzqrH86WRYaBFCTsX4Q6ASWZ4tl2pioHHzbthFNsYusbq5eEYm982mUvhgSAO2ALPXzAuAGO7UUZyGq2rK1s0nMDjjD88MfHlizgvRoofgfNsDTasD12fUrABlGfKCUha75ukK51775Nva/GoRoqwGdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0OvJ4iyrN4T9ToYeFsQcclgTHr6U+nK7L/b28IQX5s=;
 b=mJ9GgXBkyxLc4KN5Pv3qcNEfzTxk9oVM3N8PrDoED4bClgy9/PCOvNMCXbwu56Lw8wpLZ1G6SLgVjhFNAUZkHdIb8917TZRNbCgyHWn5Obdu0GMtahZu3+7wlnu4vL70j/AmJpo1jZ7rYDZ0B6FDg7J2slMtBPUzKYCYQmGkoPAhTV/nIH7BtdOOxeFNYbFJRPuiQMYUsnkVyMCafbx7042vUAUVnqdxO5WYWjEk06t9aJYRtzp09DFeAum8PCnctgvcZzEf4e1CvnkAUhgsqTHq9l+x9XQwnzoQs8ZVK9o5sWSYTqeAsyYY32GpBrvBhEAdJo87dgKGAQR8nOMuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0OvJ4iyrN4T9ToYeFsQcclgTHr6U+nK7L/b28IQX5s=;
 b=JDR7d7tf58xjzq7Adjtt5YxfCwGHfT3k5/oQpvPbrHeCL67VLXUD4NfsXcZXbiOW9VSLAGqY649IBS29AeN5IFjtyUJ8dEeE6O1CRC2BBV7BaCAThN+9pSRUk/Li7ZRYGxF7myWzJ9OyxIxc1FNtJHIenYeakTonvRw+OyOuzKs=
Received: from MW4PR04CA0221.namprd04.prod.outlook.com (2603:10b6:303:87::16)
 by DS0PR12MB7533.namprd12.prod.outlook.com (2603:10b6:8:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:44:39 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:303:87:cafe::bb) by MW4PR04CA0221.outlook.office365.com
 (2603:10b6:303:87::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:44:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:44:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:44:38 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 20/25] crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump
Date: Thu, 25 Jan 2024 22:11:20 -0600
Message-ID: <20240126041126.1927228-21-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|DS0PR12MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: 57beac15-2d24-4074-f700-08dc1e298188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dll6qedUGuxpLhR2GpHWFEKBugV8wZtIQxRVVEXp/qatYdgTkkJBnLnXMARvEmvAaj2X0ehLQHBrGOuggTMgd+5iHkd9k1vIGPDDOMsjp+p6nPhm2hAQjg9WRVYCz9X2Wqe7k76j2iVObM6B9JKFjMZR/73ljfcbzvtQ4omXHF17+Ujcu0ddDUknmaTHBkUACJEs2FysbpE4XC8+oRVqY6XyhwYeJLnLLIrZ/kp1VSefudV4BNyblArsTBKwJAoSGrW7J7rQNRqc4xKW08HOrNB9WhJFvYqln5Rwv8zEh1lusdq6TCs/d5v1gekbqsfKXF9LOsdDSa/4rWWMcu2nFUggSkqjtMMl4TC+QOscYUfI0XZMvWXpRTFwOHHfAOGuVK+Gcs4mKzb3HjccWSnGQyBgPrPWSJSBkYFee8mKJJTvtj2fHhXVJLdd4cRMtZf89nK1HqZWfeXqzSnFmYTQtNQuyqrJQTDsSS3dJmuhTn/qM8bZqIFwc6c0bM5qMMYrRL2JSGZco4wPvaht72/8yIByD2B+JepIooNLATq18CxAXwNDgxcK8MtJFq6HQgsY55Og1pRy38/FoUiDKjHOG5D5bR52l810R7llMV60nNqm7YcZRrKeEG3QnOIzMc2K3lnBcbEG5k0rdyjEiQf1KApAHzePafLSZqD1SZJKb47HU1SalqfNmIc3+V+hHpzPu0+y3crTZkJQ0HRp24VbGs1D6byoLqFl9iI7rH31/F4Ybgp1A7fyOVDlsYAvaNiVubpHWPh/s1S8i43p8bRBnnGsc+D1FG06BWZsp0RRIVXWcsInQv+Z20g7ZjA+bYR1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(346002)(396003)(230273577357003)(230922051799003)(230173577357003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(47076005)(36756003)(2906002)(86362001)(41300700001)(356005)(82740400003)(81166007)(6916009)(54906003)(316002)(70586007)(70206006)(478600001)(6666004)(336012)(426003)(5660300002)(4326008)(44832011)(2616005)(8676002)(7416002)(16526019)(1076003)(26005)(8936002)(7406005)(83380400001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:44:39.3778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57beac15-2d24-4074-f700-08dc1e298188
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7533

From: Ashish Kalra <ashish.kalra@amd.com>

Add a kdump safe version of sev_firmware_shutdown() and register it as a
crash_kexec_post_notifier so it will be invoked during panic/crash to do
SEV/SNP shutdown. This is required for transitioning all IOMMU pages to
reclaim/hypervisor state, otherwise re-init of IOMMU pages during
crashdump kernel boot fails and panics the crashdump kernel.

This panic notifier runs in atomic context, hence it ensures not to
acquire any locks/mutexes and polls for PSP command completion instead
of depending on PSP command completion interrupt.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: remove use of "we" in comments]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h   |   2 +
 arch/x86/kernel/crash.c      |   3 +
 arch/x86/kernel/sev.c        |  10 ++++
 arch/x86/virt/svm/sev.c      |   6 ++
 drivers/crypto/ccp/sev-dev.c | 111 +++++++++++++++++++++++++----------
 5 files changed, 102 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 435ba9bc4510..b3ba32c6fc9f 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -227,6 +227,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
+void kdump_sev_callback(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -255,6 +256,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
+static inline void kdump_sev_callback(void) { }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index b6b044356f1b..d184c29398db 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -40,6 +40,7 @@
 #include <asm/intel_pt.h>
 #include <asm/crash.h>
 #include <asm/cmdline.h>
+#include <asm/sev.h>
 
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
@@ -59,6 +60,8 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_emergency_stop_pt();
 
+	kdump_sev_callback();
+
 	disable_local_APIC();
 }
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1ec753331524..002af6c30601 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2265,3 +2265,13 @@ static int __init snp_init_platform_device(void)
 	return 0;
 }
 device_initcall(snp_init_platform_device);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		wbinvd();
+}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 649ac1bb6b0e..3d33b75b4606 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -216,6 +216,12 @@ static int __init snp_rmptable_init(void)
 
 	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
 
+	/*
+	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
+	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
+	 */
+	crash_kexec_post_notifiers = true;
+
 	return 0;
 
 nosnp:
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d26bff55ec93..9a395f0f9b10 100644
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
@@ -143,6 +144,25 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
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
+		return -ETIMEDOUT;
+	}
+
 	ret = wait_event_timeout(sev->int_queue,
 			sev->int_rcvd, timeout * HZ);
 	if (!ret)
@@ -1316,17 +1336,6 @@ static int __sev_platform_shutdown_locked(int *error)
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
@@ -1602,7 +1611,7 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
-static int __sev_snp_shutdown_locked(int *error)
+static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_shutdown_ex data;
@@ -1615,7 +1624,16 @@ static int __sev_snp_shutdown_locked(int *error)
 	data.len = sizeof(data);
 	data.iommu_snp_shutdown = 1;
 
-	wbinvd_on_all_cpus();
+	/*
+	 * If invoked during panic handling, local interrupts are disabled
+	 * and all CPUs are stopped, so wbinvd_on_all_cpus() can't be called.
+	 * In that case, a wbinvd() is done on remote CPUs via the NMI
+	 * callback, so only a local wbinvd() is needed here.
+	 */
+	if (!panic)
+		wbinvd_on_all_cpus();
+	else
+		wbinvd();
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
@@ -1659,17 +1677,6 @@ static int __sev_snp_shutdown_locked(int *error)
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
@@ -2117,19 +2124,28 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
-static void sev_firmware_shutdown(struct sev_device *sev)
+static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
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
+		 * via the NMI callback, and done for this CPU later during
+		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
+		 */
+		if (!panic)
+			wbinvd_on_all_cpus();
 
 		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
 					  get_order(sev_es_tmr_size),
-					  false);
+					  true);
 		sev_es_tmr = NULL;
 	}
 
@@ -2145,7 +2161,14 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		snp_range_list = NULL;
 	}
 
-	sev_snp_shutdown(&error);
+	__sev_snp_shutdown_locked(&error, panic);
+}
+
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	mutex_lock(&sev_cmd_mutex);
+	__sev_firmware_shutdown(sev, false);
+	mutex_unlock(&sev_cmd_mutex);
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -2163,6 +2186,29 @@ void sev_dev_destroy(struct psp_device *psp)
 	psp_clear_sev_irq_handler(psp);
 }
 
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg)
+{
+	struct sev_device *sev = psp_master->sev_data;
+
+	/*
+	 * If sev_cmd_mutex is already acquired, then it's likely
+	 * another PSP command is in flight and issuing a shutdown
+	 * would fail in unexpected ways. Rather than create even
+	 * more confusion during a panic, just bail out here.
+	 */
+	if (mutex_is_locked(&sev_cmd_mutex))
+		return NOTIFY_DONE;
+
+	__sev_firmware_shutdown(sev, true);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
+};
+
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2200,6 +2246,8 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2214,4 +2262,7 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
+
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
 }
-- 
2.25.1


