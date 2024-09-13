Return-Path: <kvm+bounces-26800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A7D977E90
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED12F285BFC
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9205B1D932B;
	Fri, 13 Sep 2024 11:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X8v69SmF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6DB17BB3A;
	Fri, 13 Sep 2024 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227478; cv=fail; b=XRT5Rc6WNTCAbvj5SUTUkLZ6KRQYst3SG4hw5FwZS1ZG539lpmdwvoSiMd5boo1HpZKDtzMIY1SNFUOU7H/J2yX5fmXtql72HC4U0aZN56Yu/EdM7kXzGy0I97VNFBNjMP43InjIfp+CrGrVc8Sgu7pletnieziZj1n99KUONrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227478; c=relaxed/simple;
	bh=0xsnjvDIv/12+5zoVq/Afcccu/xPSXU9ZpnWNWi1u0A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xo/OiPXVZcLX7N6iNK1iOfk3kf7q3zSNIJQbbHuF9Ef/JobqVCm9P7MVpBqZ+Mr9rJ75lojITHwgkj8PksaSO+3WUenmxdgysd2f1tDQrxoqcI62uqeyeNwvQRVcCzLhJ2D7GsUnFf0ZWe6P3U8zCeRAdtcRwg9CE12Q09uNhh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X8v69SmF; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hopiPXYLQbD4r9Wp+FR5BejIyvdhlAO9ETFtiikczZopw8Sv6a9kwL/jbiiTp0+Zxdgtxe9KWep/TMz/XKiHhSy+/uwD72gmTSRqOG33b18OZhMCrW88iyU2xAVeNS7A2WnZF4isz1F47p0Tp1jLPGXn+m4+/lAxz5Z5LoFuzAUXNGs5s2STGdCvQSltXEuaWkHPOcEx/kOlVFEKXoY5DUWu6nwVIh7T44Kb1N7Xf7p/hysqeWjPad45b6G48fyKYRU9oU5aVLt84QmpN3Dr6aFhj1hLOwEfE0X76Ak//OyhsL9LW7eI7qjS11wT41kV3ojFfnBJ+lCX7xNf3ucuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swjGXse/Ut+mWjZc/Eh9N2QTR3ptXuYIqX+lhCvMcsA=;
 b=CP0Hc1IR5cub3D9Ut16FFpYXfu1lTD4k7wYo/c0ZKuRQVMJ7I0SATzXAfMJIGXqYJoY9ZbrAYwTIDB9jzqj3xwcI3sa3PUKcfdacNV+ptcEsI5qAKoXdw8VVfHVGD2pCpsAlZqK8HH8nTewwDDYYRaK0Zd+9NC1CoBe3sm/t9LSJDpu/l3eO6bZL4bM7Ym4tjrVgeED5E7xmPe+7/cNDPafL68h6yr263W35JRJUwBkepZsWK1GXT1LKC8EbK98XWuhwrcoNFFpXZonUUfRHs7vEdELdExmJb5oSmk9zryyBHs1qIrCFA0v/bPZxm6nL2+pKloK4c85DLpnOJwaPMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swjGXse/Ut+mWjZc/Eh9N2QTR3ptXuYIqX+lhCvMcsA=;
 b=X8v69SmFD2Wdy9XA/c8sr0HtaZCWAiYJbPM8Xb8tYuWkFESxCIe3CQ582u5sUO3/E+DFjbEjdrfgnkKVH74j6rAyreAN7NICxTS1+3pQ8AG9aVhwefrT90oOJx6n9oCbEBAp0IufPMKdeO9Z/JX1jIdzKKkFpyVSRsZpSkkrP/k=
Received: from CH0PR03CA0259.namprd03.prod.outlook.com (2603:10b6:610:e5::24)
 by CY8PR12MB8067.namprd12.prod.outlook.com (2603:10b6:930:74::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Fri, 13 Sep
 2024 11:37:54 +0000
Received: from DS3PEPF000099DD.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::aa) by CH0PR03CA0259.outlook.office365.com
 (2603:10b6:610:e5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.27 via Frontend
 Transport; Fri, 13 Sep 2024 11:37:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DD.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:37:53 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:37:48 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Date: Fri, 13 Sep 2024 17:06:53 +0530
Message-ID: <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DD:EE_|CY8PR12MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: 36960c42-c19c-410b-de6f-08dcd3e88197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?553pfb+0ywB/wDSEw6cFzP7O8UpG1jD0BFxL397CNxlN/ek1Hllm1NF+/knm?=
 =?us-ascii?Q?h3mynZgXxrtISrJOE6Tx3jJYYLGa9vNyywlZPS/40CduOAVZdYHJrpexDW/e?=
 =?us-ascii?Q?BTeAxwApNGUoHDSoSmSt6p/0x/OcVLWqPSXTqPVjkZ+Lb0uW0L4vUnsTnq01?=
 =?us-ascii?Q?f86T9kP3v9kgRp5hozEZYNkDGZ2FoRL64JH9I6V6OgKiYduvqKM92ZrJ7d8N?=
 =?us-ascii?Q?6KipXhaow9edIsdUL/w8l0d+JVSvfEfOLbfc24NQKCvjJkY9dCAiaa/23BPe?=
 =?us-ascii?Q?85RP/H8syFudcUqYhryxrWYDdUPTVKYXkBlNG4mS7BSJ5Sm+iCxewBdO5VJa?=
 =?us-ascii?Q?I8KkAzPS1sAmTS7fmYVbDUdLLDzv5zyWLPJroG1IBCuQp3VbtOSN1qIGxfja?=
 =?us-ascii?Q?f3ntfskbFHxH6osVkQpI7HM07XNSgFoPIbBI6g/kNPwMcoISG2kzMw6J9Nb0?=
 =?us-ascii?Q?oEJEhO/T/IO0Khf0q3MSvs0QueXJyozKkckm4aU87ECb1PcsusS+MuPkxj5o?=
 =?us-ascii?Q?f5M6Erasa0+iK7PZlLl4YHijQtwUMfBskK2PgsMP77ckjECJjR5Sa2r4I4Ff?=
 =?us-ascii?Q?eqrlJo6klndsJdxpBaDAE0tmUgUW6dqv+iP9oysWxb8mwlS1f7DEC3iVFI9I?=
 =?us-ascii?Q?SPy70NCmRDMhx8WRip/8I4wtyRb3ELyLs+sWM71yBkK19YLG4Cj+WouEAk5o?=
 =?us-ascii?Q?LzK/c9muFA+RVPP6RamdC36S6zH/USos8lAt7GJS+WTbdiseCHWrae4aJ6T9?=
 =?us-ascii?Q?3T52xXr3y0DtQtwV3dIbNcTljWub6XqOPPS7/zEveRkXa3Pcjx8BeX9D+Wa9?=
 =?us-ascii?Q?UeJ30PYANH8Sm7ylp1aX345GSgkNQxoJRjBVP9AT96BC1QPcUgFXseA3pHvS?=
 =?us-ascii?Q?F0xSsB0RvMs49POhM7GOPfQ0149M11Ew7nj60Atd+W3J+d0ZD853l1WTetGJ?=
 =?us-ascii?Q?f/sIGEI7gM+sPXStif0T5VzLI22RPdPA1HdgtAOZSYxCR8YzwGu/7xssTsl+?=
 =?us-ascii?Q?ldDizoGj1BIxGU90jnoNGZhODcKmNkjfe6KNBrGrwQWr+OzIjTaqWD8Vm+dK?=
 =?us-ascii?Q?afQcuWD23SoQRrwzXwjhRpYDn2WXdf6m6jtsVsSVfnvFyCeRJXuSug4Gbyfo?=
 =?us-ascii?Q?j2rnDlSK4CQfoQtVIophKCI0DRXTPtgeUZMHw7pWB/2N+aBDVLHiDl5dT1zO?=
 =?us-ascii?Q?HyeU3OSV10pMgbyaBGVdCC1Pf3oQX40/kC3ETjhn6Cra48GwsyD+W7E1mDe7?=
 =?us-ascii?Q?DERJ9n3wexdzQQFVdQgdKV0viVE13C0kr1oHCbiwfsvfUDas+bNL7igGvMeU?=
 =?us-ascii?Q?MM0iS75q9enHum9pG6Er0TQ9lVtaI0BZdaSmcnp3Sha2cQb4nSdkj67nFbgn?=
 =?us-ascii?Q?zS1QCT9EgZ8ASpyaA8Tno2N4v5y8FB0f3MUsiEetLorkQZvFYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:37:53.8604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36960c42-c19c-410b-de6f-08dcd3e88197
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8067

From: Kishon Vijay Abraham I <kvijayab@amd.com>

With Secure AVIC, the APIC backing page is owned and managed by guest.
Allocate APIC backing page for all guest CPUs. In addition, add a
setup() APIC callback. This callback is used by Secure AVIC driver to
initialize APIC backing page area for each CPU.

Allocate APIC backing page memory area in chunks of 2M, so that
backing page memory is mapped using full huge pages. Without this,
if there are private to shared page state conversions for any
non-backing-page allocation which is part of the same huge page as the
one containing a backing page, hypervisor splits the huge page into 4K
pages. Splitting of APIC backing page area into individual 4K pages can
result in performance impact, due to TLB pressure.

Secure AVIC requires that vCPU's APIC backing page's NPT entry is always
present while that vCPU is running. If APIC backing page's NPT entry is
not present, a VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
be resumed after that point. To handle this, invoke sev_notify_savic_gpa()
in Secure AVIC driver's setup() callback. This triggers SVM_VMGEXIT_SECURE_
AVIC_GPA exit for the hypervisor to note GPA of the vCPU's APIC
backing page. Hypervisor uses this information to ensure that the APIC
backing page is mapped in NPT before invoking VMRUN.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---

GHCB spec update for SVM_VMGEXIT_SECURE_AVIC_GPA NAE event is
part of the draft spec:

 https://lore.kernel.org/linux-coco/3453675d-ca29-4715-9c17-10b56b3af17e@amd.com/T/#u

 arch/x86/coco/sev/core.c            | 22 +++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  1 +
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 38 +++++++++++++++++++++++++++++
 6 files changed, 66 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index de1df0cb45da..93470538af5e 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1367,6 +1367,28 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+enum es_result sev_notify_savic_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	unsigned long flags;
+	struct ghcb *ghcb;
+	int ret = 0;
+
+	local_irq_save(flags);
+
+	ghcb = __sev_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC_GPA, gpa, 0);
+
+	__sev_put_ghcb(&state);
+
+	local_irq_restore(flags);
+	return ret;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9327eb00e96d..ca682c1e8748 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -302,6 +302,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 79bbe2be900e..e84fc7fcc32a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -399,6 +399,7 @@ u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
 void snp_update_svsm_ca(void);
+enum es_result sev_notify_savic_gpa(u64 gpa);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -435,6 +436,7 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
 static inline void snp_update_svsm_ca(void) { }
+static inline enum es_result sev_notify_savic_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 1814b413fd57..0f21cea6d21c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,7 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SECURE_AVIC_GPA		0x8000001a
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 373638691cd4..b47d1dc854c3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1499,6 +1499,8 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 97dac09a7f42..d903c35b8b64 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,12 +9,16 @@
 
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+static DEFINE_PER_CPU(void *, apic_backing_page);
+static DEFINE_PER_CPU(bool, savic_setup_done);
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -61,8 +65,30 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void x2apic_savic_setup(void)
+{
+	void *backing_page;
+	enum es_result ret;
+	unsigned long gpa;
+
+	if (this_cpu_read(savic_setup_done))
+		return;
+
+	backing_page = this_cpu_read(apic_backing_page);
+	gpa = __pa(backing_page);
+	ret = sev_notify_savic_gpa(gpa);
+	if (ret != ES_OK)
+		snp_abort();
+	this_cpu_write(savic_setup_done, true);
+}
+
 static int x2apic_savic_probe(void)
 {
+	void *backing_pages;
+	unsigned int cpu;
+	size_t sz;
+	int i;
+
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
 		return 0;
 
@@ -71,6 +97,17 @@ static int x2apic_savic_probe(void)
 		snp_abort();
 	}
 
+	sz = ALIGN(num_possible_cpus() * SZ_4K, SZ_2M);
+	backing_pages = kzalloc(sz, GFP_ATOMIC);
+	if (!backing_pages)
+		snp_abort();
+
+	i = 0;
+	for_each_possible_cpu(cpu) {
+		per_cpu(apic_backing_page, cpu) = backing_pages + i * SZ_4K;
+		i++;
+	}
+
 	pr_info("Secure AVIC Enabled\n");
 
 	return 1;
@@ -81,6 +118,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= x2apic_savic_probe,
 	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
+	.setup				= x2apic_savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


