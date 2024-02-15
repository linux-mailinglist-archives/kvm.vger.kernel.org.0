Return-Path: <kvm+bounces-8752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9276E8561B6
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95332B270ED
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DE212B159;
	Thu, 15 Feb 2024 11:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kxhWV8gx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DAE12DDAB;
	Thu, 15 Feb 2024 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996746; cv=fail; b=Etre4YsVW/Vj3qRDe1eJaPbtqTAt/yVwpqtZSEaL2b3g0zPn9UYeSqzQyVpXHj6dUUNY7vzFZ4HwCWnjrPh7dgVhhr2Q6hNT7WBb5FWtSOolh0HlvHimx5ZaDpmVmnHKwlVPKAiNKhLpbMg7V/EvbdPRjNU6Iy20L1c0QDKsngc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996746; c=relaxed/simple;
	bh=9TkQCBDkNK83XOuebq63+JaBojMlgpYIBSGvkNWz9KU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMsEAN5X3Txvay1QYOfishx4UGF6UtUNQeyzMogtA7/qgsPDcYlmapuai5FyJwCID378InJ02N13l8sPnnWzDFuyncZNFcDvIexBLQVyp/DmIFW3LF2+8LiNpNO71+skbyj7wOuJ8tI/g3Y2UC9RNmhMgr+3Gnj3YoMtZCt9XMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kxhWV8gx; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWo5d1+J/KD6Q3ttgYGndjSiJ+m52E0UCkwBJue0U39Jcssxp1kgI+scw7PrHT0Jkp2AzU8MbCZU7oA6NSpjkvgBvl809sSlL0t8jNFWuIvu38V8fOf5Mc94qfMvJwKpS5eUbpD27sH0EUiJ0MpeEjumQiv0iYXqNoBzJzhTnV0//kp6vK3j33d4N3HvOU70EM0fn/Uby/N0sr179XXaNZwltYSw0l8xio92NtSa0u7yxbOOu1c6Qf5WWaJp+ml+10cuXgPgblqhfu3STkrLDNg4+Sgla8FcbsoFqKg2zWiCND7c2zUxKRDBGrhF7QNsD289bcZEpt/WeJdxLN6gFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+Si1erJUxCT4GWdO8+eY55AigpceAs6nB4BTa6rpf8=;
 b=Zv4WXR3DEdZZ0o6oA8Y5MKhh8lRTwMD8Rp9vkVG9JA7+3jLOjcw7BTMukWxU2aPeN7d7ccXKlQFlrHrJuBjt1ht/8aDY8yZczJqBxxzqD+43CLnL/JGK3NjR1GEcVS/8UDDWqXXj0xw+1UoXzlDXENuftSWbKkiyhh16EHjeTgcDP+Avx2jcMoiF9Qai1g+lPDzv9msSJ3kvUkfnVghli9wJq0bRXNWghRyjF2xuY2oDw2xw9c89TuBkdZtcHJlkIGNkhAm3KFVcCJnvrItCl9L31CR0+selOrGSV8WWh66/oRDNvLOSqg1zLyvx4Qqef2z4sg8mGegL+ardYXNLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+Si1erJUxCT4GWdO8+eY55AigpceAs6nB4BTa6rpf8=;
 b=kxhWV8gxNn+D1IJ4HuCACxw18Nq86DobpZVchaY03JchGGElGx4KeDP4yNsj1+Znv1njRwDFWJksQe5XMebPDjW+qk+TPODICgxpVbQ7TjdNcJnVmWa8gml/ON3tuzwhhRtMBGrsVLpQ/eLLpySDoPhKA44WMr8OGdPfSG4oIhw=
Received: from BL0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:207:3d::36)
 by DS0PR12MB8564.namprd12.prod.outlook.com (2603:10b6:8:167::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Thu, 15 Feb
 2024 11:32:20 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:207:3d:cafe::e6) by BL0PR02CA0059.outlook.office365.com
 (2603:10b6:207:3d::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:20 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:16 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
Date: Thu, 15 Feb 2024 17:01:18 +0530
Message-ID: <20240215113128.275608-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|DS0PR12MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: 00469cd7-18f1-447a-821f-08dc2e19c587
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m+ZYm15yp/Bc5M652hHkjhbwvL5OTUvZ1Ebr5PuwzJkC23rChpBXkxU1pXZC5LAlZxVb3zANvoqZEMUfyNpKmL49/d+otR3ke1jyuY0/bIIfYoBRt0SMGjveDMoPehDQ/PFum9KJAqQ9+95tAwRkB7OtX8z/S6JccHhNPGRlqJbgWXFNm407CpADT/PPS1QUrnAzqenNWpf7tpjLhjbbuaTalUXda384VdatWm4xYpUG+krUlZsdz1xSqOJAwGHyi63+uS18Ipx/kxvBdjwG2ELTf/MZRMefj7k24PAjqAEhIRJKQtFOOZoXby15nWf4LzGQEd1Tejxv0UOLjEqhvRCqyMjGENDB2k/KL/gi9X4Uo12k88zwRwQV5krpZvY7ErvfNA8xFc2pLnjINE7eWFdxQgGhmArBn1g+xl7w5PpYQKVU+XTxvuFaon4k9Tr7f5IEvyWMf5wNQvGpD+jRwh0sARbT3TvcALUmp1vJjsA1AWi6AuufieBUZAoqUPuPXWXEjlpW7IdcoJ32/J6tT7d2+F9rWwi0YNXj2ZcpE1Mj4SHBx1BaiEjT7uyAZklwWVl564lfpvfnnDYxeL6c8HqiRmLUDZoJ2P7w4WECxr+zdhV1U+t0qvH3KcaRgZfXna4DnudiaF5Az7iLD+1CPYBBflgMd+uZhtz76Mi2/sQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(36860700004)(46966006)(40470700004)(478600001)(41300700001)(4326008)(2906002)(5660300002)(8936002)(8676002)(7416002)(70206006)(7696005)(54906003)(316002)(82740400003)(2616005)(110136005)(83380400001)(70586007)(336012)(426003)(356005)(81166007)(26005)(16526019)(36756003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:20.2351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00469cd7-18f1-447a-821f-08dc2e19c587
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8564

SNP command mutex is used to serialize the shared buffer access, command
handling and message sequence number races. Move the SNP guest command
mutex out of the sev guest driver and provide accessors to sev-guest
driver. Remove multiple lockdep check in sev-guest driver, next patch adds
a single lockdep check in snp_send_guest_request().

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  4 ++++
 arch/x86/kernel/sev.c                   | 15 +++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c | 23 +++++++----------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e4f52a606487..8578b33d8fc4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -295,6 +295,8 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void kdump_sev_callback(void);
+void snp_guest_cmd_lock(void);
+void snp_guest_cmd_unlock(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -325,6 +327,8 @@ static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void kdump_sev_callback(void) { }
+static inline void snp_guest_cmd_lock(void) { }
+static inline void snp_guest_cmd_unlock(void) { }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index eda43c35a9f2..bc4a705d989c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -940,6 +940,21 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 		free_page((unsigned long)vmsa);
 }
 
+/*  SNP Guest command mutex to serialize the shared buffer access and command handling. */
+static DEFINE_MUTEX(snp_guest_cmd_mutex);
+
+void snp_guest_cmd_lock(void)
+{
+	mutex_lock(&snp_guest_cmd_mutex);
+}
+EXPORT_SYMBOL_GPL(snp_guest_cmd_lock);
+
+void snp_guest_cmd_unlock(void)
+{
+	mutex_unlock(&snp_guest_cmd_mutex);
+}
+EXPORT_SYMBOL_GPL(snp_guest_cmd_unlock);
+
 static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 {
 	struct sev_es_save_area *cur_vmsa, *vmsa;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 646eb215f3c7..ba9ffaee647c 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -62,9 +62,6 @@ static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-/* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
-
 static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
 {
 	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
@@ -114,8 +111,6 @@ static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	/* Read the current message sequence counter from secrets pages */
 	count = *os_area_msg_seqno;
 
@@ -408,8 +403,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -456,8 +449,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -508,8 +499,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	sockptr_t certs_address;
 	int ret, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -605,12 +594,12 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (!input.msg_version)
 		return -EINVAL;
 
-	mutex_lock(&snp_cmd_mutex);
+	snp_guest_cmd_lock();
 
 	/* Check if the VMPCK is not empty */
 	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		mutex_unlock(&snp_cmd_mutex);
+		snp_guest_cmd_unlock();
 		return -ENOTTY;
 	}
 
@@ -635,7 +624,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
+	snp_guest_cmd_unlock();
 
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
@@ -725,14 +714,14 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	/* Check if the VMPCK is not empty */
 	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
 
+	snp_guest_cmd_lock();
+
 	cert_table = buf + report_size;
 	struct snp_ext_report_req ext_req = {
 		.data = { .vmpl = desc->privlevel },
@@ -753,6 +742,8 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	};
 
 	ret = get_ext_report(snp_dev, &input, &io);
+	snp_guest_cmd_unlock();
+
 	if (ret)
 		return ret;
 
-- 
2.34.1


