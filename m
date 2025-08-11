Return-Path: <kvm+bounces-54390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CE1B20433
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA38A167763
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DDB223DFF;
	Mon, 11 Aug 2025 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MAW+wAEt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA083B29E;
	Mon, 11 Aug 2025 09:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905552; cv=fail; b=ocDleV+DoRrJvQc1TijBKuf1hQ3yLGZya+IZlGpBrIqRdJ1xqNbD1ERtNrf2y/+MWZskJuv97Gx8l7Hjb157bkFLsiuVcRG3ruCcSJcgnqT4O4dIJ6/3oD0DesrlPsthk8ZDiTPOAHj2UjJMXH1D/gN51y6GIYd0ByEU0EfcAow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905552; c=relaxed/simple;
	bh=kImRWVR7YOxCMHz8U1aTtD2eXDWMLQs6cgZSMI1x10U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rH1tOwADt4Ifg6YqwmI2BQhQJwwD7q7ITcNqtH6kwMiaP/B2YmtWx3VW8FPmx7UilFyPs5k41yxw5rVQ356QHAVINxeApDohf/VQfEYqEJGRwRnsiMwEiLmW6tJfvNsVPT+fmYK7hIP/IDYMM6VgaVoyKlJHw/IUTYCQeE56yXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MAW+wAEt; arc=fail smtp.client-ip=40.107.212.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CrkJHC2fGIGdFYoIufaAqC5cM0zwzUAU2RIbHZP6jQ74t0F1+vL3OBm/q/0m9HqaltSV2gKANXpqqNScR0zT1w1H/7u7zVwDlX2H5ukXKKmeEblfW+0N2aUpyqWEsIglS3yJOPJv2EeWyLPnfMxGJ88/0vZhCSBwfrqMqiQ0c4Gu/IlQ1BkIijNBvbY2n80BTTUYqWR6CqkbWEXKD06H7XyR0Iym9RWlgcO5aPCQpB7NF5eh6r/wR8fxBeKXfGoHHB3rFUZUFRq/aXjzTrwtKQ4C/gg4F9aEOEGbohucZh4HXOyA8/wo61xPn2F8h9V9bK2HFm2+HvdFL31a3HUe4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I84hFrpn+BJ8AMVREtxCvptVWCe+nj3NkH8LIQriHeE=;
 b=cReyAP9sV3wOFIlWDSiXaUeFV9GkI7Ne4YQ4kiIU2Y+/ZECFzAl7CKBQfapcZHqAFBkqx+jSiioUE5U6WR+6RPiKjnq7VoMUhuJoo2+OXqeuhEo26PMzs0g/AX3WHRp2Up0hd9aKbNqmx4G+P8t7brCOl11fLsjIaGYW3tzHcNaB2pYbsL1crZ7Zy64ZCoU4eKl7EzntB6g5dLz/O/f4FJ7CA8HEOHSPuULtFum5E1IjKUGnPjVxthI5LiDw6CmC91+G6SDEGpCL7k3nJrmCZaNc6UhHzsCKkqdXSuv+6iSgc8d+h7kb6/hpEGQuuQR7fz8k/GP05hbnPdPnafqXrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I84hFrpn+BJ8AMVREtxCvptVWCe+nj3NkH8LIQriHeE=;
 b=MAW+wAEtDnOhzNqjwWVxprKJn+csauqCF5XJaB3/IyG3CTDjitAe8nSA12nKZyoxvHh+te+AqrdMYTJFM6FctAu23CCv8QuxqiGyrobZpNF7uIzL3bnpEgsyydB9LPngv66ah2Q/h8kPXKr/eXoWLFjzUsQYAYGHgALgsUsqHAA=
Received: from CH5P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::29)
 by CH2PR12MB4294.namprd12.prod.outlook.com (2603:10b6:610:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 09:45:44 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::dc) by CH5P222CA0018.outlook.office365.com
 (2603:10b6:610:1ee::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:45:44 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:45:37 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 02/18] x86/apic: Initialize Secure AVIC APIC backing page
Date: Mon, 11 Aug 2025 15:14:28 +0530
Message-ID: <20250811094444.203161-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|CH2PR12MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e7c8b8a-cd85-49e3-7e7d-08ddd8bbd7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cROMAcOC408pRcTxAi2xTai07FwuWSzdOs+uP0b3z86rQTV3bX3J7rKMWinr?=
 =?us-ascii?Q?RMITtU2uV5gqypz7YB122RY6PjIwCR0/eLIIpOXsNXfEDTr29OhmfUW4dyhI?=
 =?us-ascii?Q?RZklJTtu237sO1j1LzHKXkOt9C0CcF+ij4EBsW3EAfcgvhIM495GeW0Ts/5D?=
 =?us-ascii?Q?HaCfZNjtYB6rVpwct7Dn86rXpl0opdZdI0iU40PxMoyaWdX0OnSOr5vt/XRk?=
 =?us-ascii?Q?V9UJGfnLUZ/Huh/sQNDbo0lm0eZiLeTAVCiMeLgo6Y+kxAvCAAwOJvfo3TM4?=
 =?us-ascii?Q?hi+515/oGgv36blic4+LgSmNCczsp93yorQDv4PLqj+9Py3ObJBqKrB1JqmC?=
 =?us-ascii?Q?3LQkLS/ZXaCo66pCGJ6P+oR5LXU59JFCWHBxUFn97BYJfw+gEUBE7pf4Mg/r?=
 =?us-ascii?Q?yCYXOYne1BientaJgDjnZtUgpIkXRt7TJRXVnuufy9vihSiA+HQ7i4+OLDW1?=
 =?us-ascii?Q?Mi0o44w8RCC+rvWGoaUfIewymgENCupzQc5D+AmrsneS0K7Of4qBFk1SDZI+?=
 =?us-ascii?Q?1ZLhg1j75BssE23sarhe40kq4iebLvdesBGHg3Pza4h/qRzfKaKHwsajvWPN?=
 =?us-ascii?Q?0zdfx0iH0U5Zk3UxNcTU74kaULmdtfZV+lTzz6HdUWXQn82LnljmWR/QWD+3?=
 =?us-ascii?Q?FwVqaUb1HTzogRiz5emKO2uVc6LngrAPm/fk7sAEs0mP9FcOQMFTC1T+hQR+?=
 =?us-ascii?Q?sA0+XAfSK0BquLD8/gfxqJD7CMrp+VZ2RFj7bX8WmDI2VonFfNt9Vn3fK61P?=
 =?us-ascii?Q?oyr8+dZc6uCY7ly2G70vUWq+CZ18uHvcqbr3P1tqy2MRrDOwHvUL7QUMsn+w?=
 =?us-ascii?Q?5qINqcARJpPg2dEUU168vNgQ5WipYBe3EUY7b5NhbzpBSyat+eVvMQx0sfSP?=
 =?us-ascii?Q?UAKHye6dYlgP9vTWDIVhPg7BFS+VgHxVpKmwyo7ct8Sb65TiffA2oht05aQV?=
 =?us-ascii?Q?7T9vH7B3svV0vM2MWU84OMYro4ql9eV3KxjafO8DsRC4nd56KauNo5xGlrOg?=
 =?us-ascii?Q?VzLBC/46nfyECyKKPV6kddW4G/NC00iCnrL315cz9zhAYGgDra/I+lO3KmcZ?=
 =?us-ascii?Q?te5fZoLLyH8KfcWktTWoZlhVc8oP1RylE3qwWNHhZ+WPcweOFlyL1xsWMP2c?=
 =?us-ascii?Q?VGBs5qAROvNYPs6vr692CCj0/dbOocVCy0XE2h1E5QYSZeKF/4eLm+Lj4yzF?=
 =?us-ascii?Q?C0SecextBE63KO6iSYEZBLrzdsLjpDf4oEgH5JL3a3NJKOlCcxI6ShfT2mTl?=
 =?us-ascii?Q?lO0QmNV+sEoMIFKwUbKycLO4/Ycywovs2N+bvNunbaIYGSK80JSDLDAye+R9?=
 =?us-ascii?Q?dFg/AHM+eRoT9xZa4Tk2s39JF86tLUtyn/baV+tH4eVu8PjoV+qDM0+xCkJZ?=
 =?us-ascii?Q?Sr/0gTGV7YLMoe/nsTPUilEnewbKwOeEaIwkbDUaOw07QpnWtE4AtS2tQLuk?=
 =?us-ascii?Q?7nkQX0SAH3KjiSi5C+3A50un25Y3zQ1D5xKbqkd7Z+ejUgD3U7qOPK0LCJsY?=
 =?us-ascii?Q?AWGpagKo37Jp5rYL9zjUTcJ+qGWZ4ThcX/zX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:45:44.7505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7c8b8a-cd85-49e3-7e7d-08ddd8bbd7d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4294

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present
when the vCPU is running, in order for Secure AVIC to function. A
VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
the NPT entry for the APIC backing page is not present. To handle this,
notify GPA of the vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
the hypervisor makes use of this information to make sure the APIC backing
page is mapped in NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:

 - Added Tianyu's Reviewed-by.
 - Use "struct secure_avic_page" instead of defining a common
   "struct apic_page".

 arch/x86/coco/sev/core.c            | 22 ++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 ++++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index a19691436ea6..0c59ea82fa99 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,28 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
 	return 0;
 }
 
+enum es_result savic_register_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	ghcb_set_rbx(ghcb, gpa);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 07ba4935e873..44b4080721a6 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 89075ff19afa..8e5083b46607 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -533,6 +533,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -605,6 +606,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc,
 static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..650e3256ea7d 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -118,6 +118,10 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SAVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
+#define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..36f1326fea2e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1503,6 +1503,9 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
+
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bea844f28192..1c70b7c111f0 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,47 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+struct secure_avic_page {
+	u8 regs[PAGE_SIZE];
+} __aligned(PAGE_SIZE);
+
+static struct secure_avic_page __percpu *secure_avic_page __ro_after_init;
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static void savic_setup(void)
+{
+	void *ap = this_cpu_ptr(secure_avic_page);
+	enum es_result res;
+	unsigned long gpa;
+
+	gpa = __pa(ap);
+
+	/*
+	 * The NPT entry for a vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	res = savic_register_gpa(gpa);
+	if (res != ES_OK)
+		snp_abort();
+}
+
 static int savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -30,6 +60,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	secure_avic_page = alloc_percpu(struct secure_avic_page);
+	if (!secure_avic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +72,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


