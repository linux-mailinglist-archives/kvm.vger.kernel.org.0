Return-Path: <kvm+bounces-51853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFD8AFDE4D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EFF517783B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD410219E8F;
	Wed,  9 Jul 2025 03:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t0TIXqUO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C391F4E57;
	Wed,  9 Jul 2025 03:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032338; cv=fail; b=C3fEw5u0R8OMwKBXd5gaJm4E20SZcEDIJZQcjw/wmLUr5tU4VGJKxqcVpxNCNPTQvg0ZQiMnDd/omqoLuMFR6eut9k2+E/AnGnSyM0PlGnXqKlE1hauY0XaiEEjj0iq136bYZMBki6l+VERUmRPUWt/NUBcqXAojOorbm2JXtYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032338; c=relaxed/simple;
	bh=ll7ueoHpSHeQghqlYlhjQ3EUhy/ID3J/dkl5VmVKRg8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKVMR95b99SIWFiMe9aNAB94HeuP85ugoqtl1DYRDfence6ygW3F+Au9A4h86usCnM40mUhx97+bTFinE+aKIRVYZy3N2AeOkNtAlJhWiLj09V3rwHAOWlaTbAVD54sP59Sck3rzDj8B4VJhEAhW1wRA7+d5d7JTjFf3Y7pwQ7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t0TIXqUO; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AsH7lkFUA65AHotttLfelJa+ZuDVW4NOrtBFfaGJhXnEvH7eOvP1FrIGKSCi77ZCSqdkTzYTLvxljMVGLzxcmNDdSGxyVmlUee+VexHIcJIt/gjrMDvymtB0acfSjn7p2JA45M6ODtvUzhYwi2Rfo9fqbz4v/ZNABUmCb2aIvDyQbnt7G8k4b1PvpxxPHG94VHDf0yqfZltMFbd/A11AAIfupmUcxop0Nz9I2mRmrzhb3xyI0pcVVtDLCdYaE3nkc54iLY0cNlBzTypMLgW42N1NY9xnk+HE4zD7Bw+epMmUh+Jse7sZN/rEBXeGhlGHAd7eAFqp58JI34Gwuozqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsRRaw59V9ukJxvt2PbBoVNLK1kBAbjxg5yZ5yt0evs=;
 b=p0d6deRTjlF3u4/eaEELukjz4HeOMGen5dYLg/4GPbIPe+Po6dajcXoIxkMZkVVh9rz4oEcRUrlkigY1016ZTzdDUst6IVo5Owfv6DxQEMRC9TjHRvU3mAmFFqlCSUJK0DEsQucMABWX6B8pq/XGBpgPUbjEf//ZbbjHxwJHDgQN5vLBxrNF/JUi3ywqLo4+nK6TLI2Seup5W50hmihhxFD+Px2T74jpVikGdysxVPZWYXuS0plJmuKLAzhqlyH4lGqFPgyxdL0rYBXPUJsW9IMxPL5cQ4dR56vL248d0Hrgd+CeGdpnEHd+ZuStkW25Q8Xpb3SlxZyNAgiiXzz5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsRRaw59V9ukJxvt2PbBoVNLK1kBAbjxg5yZ5yt0evs=;
 b=t0TIXqUOtpzIMOHGzaXxPDtTSAnhjZrNCNKIrhjd4lYr6qiHmpeZ883INl79nBtfFAaYD2/ME/P49+DDKQdorWW8S9vmBob7PNZBf5ESeJB6AupNfW86k1N66ofJZOJTnnF3d3qPtjcS9YNE87fI7ZJFfN2OHa7vuWxjPJHg20Y=
Received: from BN1PR10CA0024.namprd10.prod.outlook.com (2603:10b6:408:e0::29)
 by DS7PR12MB8347.namprd12.prod.outlook.com (2603:10b6:8:e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 03:38:52 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:408:e0:cafe::3a) by BN1PR10CA0024.outlook.office365.com
 (2603:10b6:408:e0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:38:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:38:51 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:38:45 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 19/35] x86/apic: Initialize Secure AVIC APIC backing page
Date: Wed, 9 Jul 2025 09:02:26 +0530
Message-ID: <20250709033242.267892-20-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|DS7PR12MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: d118bdff-a878-40d8-1a97-08ddbe9a1f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LyfQQxEbZN1B/sAAa9wxWQyUxs9fPTpjD/SJcFnoBJ2T60wsmFm9EvKp3iYA?=
 =?us-ascii?Q?iHnj09vKAPAljQ8D5l8D2BjJGyQuIE7E6MY81XcHnRfQmSnc5vSCVoJrITZX?=
 =?us-ascii?Q?ORh1lCoYwyuHNw/PhcfanL2+iU6iHrcgToDyuKcwZwKG/yKN3WZslFW3t3HW?=
 =?us-ascii?Q?KTCs9RvFHkRdq7FnJ5cLJECkcT9av7ivyEf7sPH7ldvIj+67iWm1elnWyJy3?=
 =?us-ascii?Q?7vDKcUT9N2MiH5vwTHbd1nq3xG38LEwUuSsWIv8pvpSGohWzsZRtUqS9y1SO?=
 =?us-ascii?Q?svF3b2uUNp3srFzd+x7mcADO8UPtoqrPFD32msiPPvoPe237NAfqx9Sbe9gk?=
 =?us-ascii?Q?Ypn5tij0Sd8I675yQ4+MGs7sc2ZBpkNRRF3qnRFoQEUCmGocsFrJorgVQ16v?=
 =?us-ascii?Q?Ss4iiRUq2sVn/T24iUufX2bsh6lQbjFTNwKxIA+hyKf6qlEhkFvOnt09fsYY?=
 =?us-ascii?Q?LxXd4D/QFQwHpXs0mSzNwammg394LFQH06JmwxoLVRTpjyh0e7CpdUykJHhJ?=
 =?us-ascii?Q?KF7fu2wTfk9MN4rTcUXggnjXh9R7IB+HM1t00Y/eBzME77GuTyO4zZNS3vhv?=
 =?us-ascii?Q?+MLsOXqpJMQvAehHU8JgoM02InLdNSAYMXWl+5+BOf7YvrtPczz6VGsybsaR?=
 =?us-ascii?Q?PIKEDakkZRTaLfx6mbPu1Cok6F+tjwon0huukFk+T+Shi6pugmLWiUCNpTpl?=
 =?us-ascii?Q?cC0MlHljEFbyyA1Yc5EDT7klTeDfy6G+lqyKdjiGwG4z5ThyYg8qx2107xZq?=
 =?us-ascii?Q?DQkWofewu+yFkvAzjdrVT2izUJVCjYwsfzh1jB5K3LAKsJybZsShm2wr4s/j?=
 =?us-ascii?Q?hVRIsltd4pZ56s37qV6DbgbW9TleyB1XwVhor21hfHQhU4+MUH8xBe+dgqPn?=
 =?us-ascii?Q?bxompDbPqgXizgD5TLYhKb3+mNRifuXKXvgcjJiOl0+W237Ig0j27QptPJEN?=
 =?us-ascii?Q?IcHC8po4/1iSOsNUr9KfJPM7TSQV4JNkU+mJ28dlVE8GUxcd8Q2s4zBd+0On?=
 =?us-ascii?Q?RPVQXWC+Ulquot/SYBPH+HBNms4vwt2tATTmjTlLEAloxVtMoDqGSWxjTXyF?=
 =?us-ascii?Q?UHnlAVwFhTArSW7QuLyC4M3NGvyNxnRGUjnw4Ym8jwF2qXqDIBhhSPEujSPX?=
 =?us-ascii?Q?o7XbgnhBjv1yTmjMLTIlOCFiGg1mfXN/c6Xe3DmbZsumOCmNAg6RB7yvso+h?=
 =?us-ascii?Q?/3jBYq/Xl8E2bZDHaK3SkF6VSS8MU62NXx+MesSpTekUjtxvuZaENfe1h5JH?=
 =?us-ascii?Q?N9+6gVbETu1vKD9LK3BCvtBa6l3REpCVuiOAkBJCyTknKc99xnjrYhQY+/Y3?=
 =?us-ascii?Q?lnNztXPl0CF3ZdSu4nK3jknpQLB0zeAm3HY7ooKLzbiG4sTEoZfi5T3ewlOR?=
 =?us-ascii?Q?BkDo7xARmnBDF/cq6N4ijM5sjghmMygY6rX/J9tRSZnIUD4z4rZdR3fTT5VW?=
 =?us-ascii?Q?iimo0IFynpDw+A9qj12ty6MMigvzlME07vzj2WX0KbFYrRUZcB4ziVFoef8A?=
 =?us-ascii?Q?9H+1lgj1Ybe7MYqNx8VzHGgQs5vg1GSGrlnn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:38:51.8908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d118bdff-a878-40d8-1a97-08ddbe9a1f82
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8347

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
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/core.c            | 22 ++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 ++++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 32 +++++++++++++++++++++++++++++
 6 files changed, 64 insertions(+)

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
index f91d23757375..184cae6e786b 100644
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
index bea844f28192..a2747ab9200a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,44 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+static struct apic_page __percpu *apic_page __ro_after_init;
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static void savic_setup(void)
+{
+	void *backing_page;
+	enum es_result res;
+	unsigned long gpa;
+
+	backing_page = this_cpu_ptr(apic_page);
+	gpa = __pa(backing_page);
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
@@ -30,6 +57,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	apic_page = alloc_percpu(struct apic_page);
+	if (!apic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +69,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


