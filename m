Return-Path: <kvm+bounces-4941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDE981A209
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E96AB24F36
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7644747787;
	Wed, 20 Dec 2023 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Od9ycJ4M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4F446520;
	Wed, 20 Dec 2023 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpIQ2gIfNtyp+pdQeRAf3xD0kl9cwV6QKX8y34bc/kBtFoX0LScGsLkX6/FFGAGeVaKQw8R0CauBDO24esQayFkyadON1G4l2KlJN+gJDwIKa8+KX7QOy3SvC4kGiODVaypTtCscgGAnZ09tDF20Kl7W8UWGbKaeoa747GsaMx9hih0paaxwksojrjo9zDqRRlXj+/bjpBaylH3yUSsUb/F9q4UDhuL0o8Qms3jJt26RsOy4jmDl6LAJw6NkfeIC4GUE60sNsQtFNXfiKUurGAfeIWF7Do30HgG4ygNmL7QH65ej+KGDDv6wqSyv8RFF8anb9UPf/yM4EOQdUlgT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=848RNghYksLMKRh3dwEDUAx4Hr9s6mg6sZ+J6WL/VmQ=;
 b=QYNj9sWYgxno7rm7LASLTPuXQOym6DoYVVHY91SYHfrm5KJRjgVrrCj9/KXmz5e4oW9x6v0ZI+cOOJHmuXxTLW6a6SwXcUr/ErKCExHqLJyzyeAmOl/Mq+SAoaC1yohCV3Zy+5Elmp6FxtmcxKG+Bv6q6IATS6ebBD5UAPQggIy6EuxWtOHJzkqALJXqvBCzpQ/s0NvrWhYEZHqzPdn2eTenbGCvhw2flfcBEyLp7qe9H8tZo/7CGeTViRyv0smNdrTHD+40tDePdJdVjapUU2IcUCkdKBO8DG3fJ0Vc3PF8sea0IPkO6OOUICkbo1NO4Jy6aFVh5MCCpZB7E2JDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=848RNghYksLMKRh3dwEDUAx4Hr9s6mg6sZ+J6WL/VmQ=;
 b=Od9ycJ4MKTjRkWhhUEigjeo6Xj0nbA9TnJ3ZIxy2o1YFaWVlAdtalKF57R5IKDEYkf3IFWo20On8PB9KW55+ertJXD0kxoS1IzLWBCT1Ykz9E8KaUECykGmEAmSXGdYGbmmTxHq/64O2fYWaSGpp+Wrbo+skRp8mCcHHG9IodNM=
Received: from DS7PR03CA0228.namprd03.prod.outlook.com (2603:10b6:5:3ba::23)
 by DM4PR12MB6448.namprd12.prod.outlook.com (2603:10b6:8:8a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.18; Wed, 20 Dec 2023 15:15:09 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::3b) by DS7PR03CA0228.outlook.office365.com
 (2603:10b6:5:3ba::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:09 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:05 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 06/16] virt: sev-guest: Move SNP Guest command mutex
Date: Wed, 20 Dec 2023 20:43:48 +0530
Message-ID: <20231220151358.2147066-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|DM4PR12MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 532fef54-2fdc-4d49-dcd5-08dc016e74ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k8hwRBUDADlGvYf1KZ1bJWBJFQNHWTmWubq0/XGdQqOeMB+WgwoXtzIET6OkPHVSXl0H9tAam9o6A2Xiye2PfdOIiuavZtlvhYXpwGseAmgFSxaSPrXTi1dN/GOkN/xMTVUly1dQ25rIqojOU7RA0P/ZBArY8AaqzqMPYQnpJVSmM6ZlOmBLHrQbCsu7+DKtQrCf3zufN+HYp6sDpOgbSHOADUvujRNfnNXLvrVEKDqZTFYVwkE/bGof5yokAnM8yjezhXPjRi70X/Ql2yjyP0YsCywSIgSm1Uj5/vLKOq2BHAB+uma1hPTvmDhjEf1uZp8TcRUO+TXLkjjOT9N7xnvab5+uo1/GZuKSBzizMWfl6ux8e0tonBhTtkaB+6cy3LA0NePlQWr1YzhNjZ9InM5LCQCON9FfOEPKxhfbXSwQbeK1gt7NbpDoA34jjFKanwUHiP/qnAdwH9Lp7VGAx+rQInefe9NoFm7yroK4rxmhZc0t4U8AYm9BNrL5W6Frf7h0Fw6ugPdyYRWhtgaw7D9mjL1mws5COIuHUQ0nJc872zb55cry2mjvRiWn3sBz045WflgCchCKgJ22Al31O5LkQo4dDbbqeCUeQbqlNfyH/Akp82BA/25zYLTyUnned4oJZdUnZ2JIr8ashIEz/1G1rIwS2MvhODD3xc074EicLDYEGzD9CQGQTWv46C0q52wMRzlNMZOXUM4Lge+Bh3ZBgk1sGADLgvRFCvZoUxRhZQbvX4KUEztpGJVtG8VQFmJHhZbXiOLGjXpI7RXiQA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(39860400002)(396003)(230922051799003)(186009)(82310400011)(64100799003)(1800799012)(451199024)(40470700004)(46966006)(36840700001)(2616005)(40460700003)(1076003)(7696005)(6666004)(478600001)(426003)(336012)(16526019)(26005)(316002)(54906003)(70586007)(70206006)(110136005)(83380400001)(47076005)(36860700001)(356005)(81166007)(82740400003)(36756003)(5660300002)(2906002)(7416002)(8936002)(8676002)(4326008)(41300700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:09.8696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 532fef54-2fdc-4d49-dcd5-08dc016e74ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6448

SNP command mutex is used to serialize the shared buffer access, command
handling and message sequence number races. Move the SNP guest command
mutex out of the sev guest driver and provide accessors to sev-guest
driver. Remove multiple lockdep check in sev-guest driver, next patch adds
a single lockdep check in snp_send_guest_request().

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev-guest.h        |  3 +++
 arch/x86/kernel/sev.c                   | 21 +++++++++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c | 23 +++++++----------------
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
index 27cc15ad6131..2f3cceb88396 100644
--- a/arch/x86/include/asm/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -81,4 +81,7 @@ struct snp_guest_req {
 
 int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
 			    struct snp_guest_request_ioctl *rio);
+void snp_guest_cmd_lock(void);
+void snp_guest_cmd_unlock(void);
+
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 6aa0bdf8a7a0..191193924b22 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -941,6 +941,21 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 		free_page((unsigned long)vmsa);
 }
 
+/*  SNP Guest command mutex to serialize the shared buffer access and command handling. */
+static struct mutex snp_guest_cmd_mutex;
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
@@ -2240,6 +2255,12 @@ static int __init snp_init_platform_device(void)
 		return -ENODEV;
 	}
 
+	/*
+	 * Initialize snp command mutex that is used to serialize the shared
+	 * buffer access and use of the vmpck and message sequence number
+	 */
+	mutex_init(&snp_guest_cmd_mutex);
+
 	data.secrets_gpa = secrets_pa;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 9c0ff69a16da..bd30a9ff82c1 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -63,9 +63,6 @@ static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-/* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
-
 static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
 {
 	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
@@ -115,8 +112,6 @@ static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	/* Read the current message sequence counter from secrets pages */
 	count = *os_area_msg_seqno;
 
@@ -409,8 +404,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -457,8 +450,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -507,8 +498,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	sockptr_t certs_address;
 	int ret, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -604,12 +593,12 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
@@ -634,7 +623,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
+	snp_guest_cmd_unlock();
 
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
@@ -724,14 +713,14 @@ static int sev_report_new(struct tsm_report *report, void *data)
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
@@ -752,6 +741,8 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	};
 
 	ret = get_ext_report(snp_dev, &input, &io);
+	snp_guest_cmd_unlock();
+
 	if (ret)
 		return ret;
 
-- 
2.34.1


