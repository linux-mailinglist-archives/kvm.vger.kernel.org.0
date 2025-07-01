Return-Path: <kvm+bounces-51222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B38AFAF048E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF85F4A8309
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7185265296;
	Tue,  1 Jul 2025 20:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="376NTFN0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CAD26059B;
	Tue,  1 Jul 2025 20:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751401006; cv=fail; b=Cal1dme/3aa2Nyx6tASrq0z5kHkNQcftnGEAfGdkSN/JpUDrY5a7m2o6CBlHabY595nbLWYJFisTUcNom9jLX9mFua24kdZ/nJaWq7nQFI+612q+qRRlklJKZHzahwD90z5Em5BwKtlYsQz++pspGRCXi/Tg4YQUiVnNWkwEB5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751401006; c=relaxed/simple;
	bh=UYojFtEOtmxQwBz7WlAr7/bT8rtwE65JPveIawE7+c0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLez5g/ztcUYrVciHOGjDZ+ms+HXqmN2tWmujhDwoyRTV6svenzJ6FwLO7HoFfatAfw6yIggGVcPkj9Od4Z2cXtAjR29osyPz4dbTffYB5hCBeIzE8mPMjvODuCwAwrUD7td2KTcHOBxUtEixYBFpmbP1pP8HEeWcMzuoQAE26E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=376NTFN0; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWRyhXqf3jAQ8m5gMRn4XQ5yT+4XgGKnG6ecLgnFUlrh7tqMukEIKm9GxDZMZv/VieOZDVasZbOD4+TrBP6K0Rc6/3c30/nT83NnEdJswU7WCrxUYh6TbeautGkoXZNvnLBxMTlFHPdmpoFsj+ESOiOiNnKmIATe5qm77eu00MUvlcaHLOOMYG1cCLu+auw3kYSXFR1KGC7AxC7V9DJaLC+1U9DxfsEPNdSakfsYcYKhlzn3kgzMKlQ4ulsDIGpQnX2ElNpkrOvVROfAmY7QkvfVvlm1m0Jg5cK58gx13dhPIA85ilX1zKz3vJKTJuZc1ekUffj1HSEK0mnn+EKgCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uofeaD9TnHqR0DtB5TqX01ogOiAswFC9S+oBe+UOC3I=;
 b=HHaGuYq1lH1uOf79/gPMINV70fZg0inInL2Q94Qpw/p3+crBg2UoZrqEVYWtgteN5DeihsIT8+OYJHpLQ6cFXWV9irUnHLL4XjqgF8SBDV1h03ESEjjsK+lSUKTdwNdDecUHgufbq9WXkwolcEydHxZU1xWoyWRTYetCKZqH8uAmMgGuXtqt/DRa518BRhS6GDVgrYSQmgq80SGd7mIGXk6hHtyMmesD0ftBSKst/nUuVVXTeM5ELL02uWScKjDqx24vLNNSc1NolRq8uLus0UjWz4SF2PU8OOcs1IWeJpBsfvC8odRza5VLurk7uV/+cO+NcN7nTF4dlGVj2PtyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uofeaD9TnHqR0DtB5TqX01ogOiAswFC9S+oBe+UOC3I=;
 b=376NTFN0vN2gEDQoq6GN0jqu6yezmAlGioU8oSan5thXyYHs+cDhygZy4Ro882h8/oGzdHCbFHFAIycyESA0c0KlgFx3PI+UgZCneVFnuG/8FkHivHR27SffgRFVCrBPKA8fN+NWplQoUvJmTeuNDN5x63tI5xMNm8UkxmDz7Ac=
Received: from DM6PR05CA0054.namprd05.prod.outlook.com (2603:10b6:5:335::23)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Tue, 1 Jul
 2025 20:16:41 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:335:cafe::cb) by DM6PR05CA0054.outlook.office365.com
 (2603:10b6:5:335::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.19 via Frontend Transport; Tue,
 1 Jul 2025 20:16:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:16:40 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:16:37 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Tue, 1 Jul 2025 20:16:28 +0000
Message-ID: <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1751397223.git.ashish.kalra@amd.com>
References: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5e715e-13e7-4998-1ec2-08ddb8dc30eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dMLPVmJodqqgfkoZM0LewKXT/pBuwIuRk6tHfpAI6mw5oU3qbtnsD/7O6Kdj?=
 =?us-ascii?Q?L3r4SaqxBnYtVbTiAeTrs5NLa8iyA99yNZJzoFbrlT9oiGR2RwyBnzqO9yXq?=
 =?us-ascii?Q?ix36f5ayYXqla5YQVrxEdJy5qC1ZlWjkHGtRjwHHwKsK35nkK7pYjyZB9r9H?=
 =?us-ascii?Q?rb+vCAYxRnWEog4MAubiOOyAv+cgpFQTQ9lr2qY1OGDD/JJk8skjTSuwzSc/?=
 =?us-ascii?Q?U6WrcWQX2qIqovUxsD9I9t81VJGivO0OmgoXRtbPaBe/b7KnVTL7vp3nU1NS?=
 =?us-ascii?Q?ITmAzGM1jmrq7BHPGAT15gw7LIY63Lu6AETH505XbwSKsLMmUx41ZRbWB3Z3?=
 =?us-ascii?Q?B/nUsmCS/jkrgStIYII22Asvz00O7JNBe0KOLDToGZcVfmp8MVN5qgH2K5q8?=
 =?us-ascii?Q?qnDWRUqZoyMFPZzTeco1STK++lcLAva2kfZFp2By5NB9ex00iSia0WAB63bV?=
 =?us-ascii?Q?IJ9yE9ib23NXQeh+Q/KF/rJsCR/82Yb17Jdf7DcJ2C/NDo5BVP/KZwIN4nNW?=
 =?us-ascii?Q?d06AGLMrEP0JiL6pzKQPqfeN1nVOIh2ARk6kuhceRrNNtJSJmKxvqeYzaeAB?=
 =?us-ascii?Q?w76j3JrG+Qd6DF8iS5ejs1sFKzf7/bW+tb2qbRLo6WRxpftlgt2jGzMaS6Dz?=
 =?us-ascii?Q?NKsw+J7iZKVEm8xHst44J378ccEK54XQ88VLl0XCvHCHhuxT12op4L0VLOaC?=
 =?us-ascii?Q?o0aOe3KsS+WgfXlDY1mfHJ2v7I05hFnbMmE97ImWP7ZBX5/hKPXg9gnDi1H1?=
 =?us-ascii?Q?1pDkBFeSTtvRv7vveVR1XCuU1kRmP9Amef+pR5rPOTwWJJF7YdpVCFoL0J4I?=
 =?us-ascii?Q?dDNn0+WDoFL/2QgImy6wZc4xMN28sKOgMfX/B0FHu6b06fcgyUOEowmLawDe?=
 =?us-ascii?Q?AXl5Y9NlsaQd/j2mDKCASlircEiou9sUzEYEyguoRze/WX9+qHeqhdKkI3xY?=
 =?us-ascii?Q?fW2ELxA3tiPMxsvtwDuRHXqc8czjPxbW04VmhlnobXP5caq1U95eZ/8vBz8T?=
 =?us-ascii?Q?5i5H0/7ErMdkoUWJ5JpAs0iiY+gk7HDUTFKOQE7ne7XKvsop+McqKGs3Huve?=
 =?us-ascii?Q?x40A3+M8aFmDawGcRpevru6+9fU9lI/csBn7BTz1a3nzdAyNoXJCpXs3hFdh?=
 =?us-ascii?Q?P0P+M4525n+eoFwX5Q7gB8V20Duc9p6tATlOIEB/GcGVE2FBQEkg94qoMoVS?=
 =?us-ascii?Q?Wphi6vjgpb1PutPtzgs2tijirNQef6dw7YHns12x7jAMeJ9rj4YT1fYNS0lY?=
 =?us-ascii?Q?d9dej8V8YoSC0aEC7lfhlXyE1Q9TkMsM11iMYl6uLWjY3Z5vwSMJYFAx96//?=
 =?us-ascii?Q?gVjrSZD6iMY1I/ykWYpA38Jywdto8AlygtpE4157x3CF1a8FSTkWZ9PeegRo?=
 =?us-ascii?Q?becVjxLopmsDjkNU9Ko2/ZRYmx5vIsfKnxCbH2+fSGH9j/AHm+hvfW7xHVcn?=
 =?us-ascii?Q?GstXMtYOnkZNfDt0J4jtPHAKbvc1ze6GtBtEV+FCAzgcdlcOgK8LxB2Lxv+S?=
 =?us-ascii?Q?Fza0BUCd5sqhQ01ZM0bc+JcqLlovJavxFin5oRSbQfDG5Ofi8/9i9fHhmw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:16:40.8713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5e715e-13e7-4998-1ec2-08ddb8dc30eb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is basically split into legacy SEV and SEV-ES+.
Ciphertext hiding further partitions the SEV-ES+ ASID space into SEV-ES
and SEV-SNP.

Add new module parameter to the KVM module to enable Ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is "max" then the complete SEV-ES+ ASID
space is allocated to SEV-SNP guests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 19 ++++++
 arch/x86/kvm/svm/sev.c                        | 58 ++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ee0735c6b8e2..05e50c37969e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2942,6 +2942,25 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_asids=
+			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
+			the ciphertext of SNP guest private memory. Instead of reading
+			ciphertext, the host will see constant default values (0xff).
+			The SEV ASID space is split into legacy SEV and joint
+			SEV-ES and SEV-SNP ASID space. Ciphertext hiding further
+			partitions the joint SEV-ES/SEV-SNP ASID space into separate
+			SEV-ES and SEV-SNP ASID ranges with the SEV-SNP ASID range
+			starting at 1. For SEV-ES/SEV-SNP guests the maximum ASID
+			available is MIN_SEV_ASID - 1 and MIN_SEV_ASID value is
+			discovered by CPUID Fn8000_001F[EDX].
+
+			Format: { <unsigned int> | "max" }
+			A non-zero value enables SEV-SNP CipherTextHiding feature and sets
+			how many ASIDs are available for SEV-SNP guests.
+			A Value of "max" assigns all ASIDs available in the joint SEV-ES
+			and SEV-SNP ASID range to SNP guests and also effectively disables
+			SEV-ES.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 89ce9e298201..16723b8e0e37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,11 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static char ciphertext_hiding_asids[16];
+module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
+		    sizeof(ciphertext_hiding_asids), 0444);
+MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and set the number of ASIDs to use ('max' to use all available SEV-SNP ASIDs");
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -200,6 +205,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
@@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
 	return initialized;
 }
 
+static bool check_and_enable_sev_snp_ciphertext_hiding(void)
+{
+	unsigned int ciphertext_hiding_asid_nr = 0;
+
+	if (!sev_is_snp_ciphertext_hiding_supported()) {
+		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");
+		return false;
+	}
+
+	if (isdigit(ciphertext_hiding_asids[0])) {
+		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
+			pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
+				ciphertext_hiding_asids);
+			return false;
+		}
+		/* Do sanity checks on user-defined ciphertext_hiding_asids */
+		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
+			pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",
+				ciphertext_hiding_asid_nr, min_sev_asid);
+			return false;
+		}
+	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
+		ciphertext_hiding_asid_nr = min_sev_asid - 1;
+	} else {
+		pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
+			ciphertext_hiding_asids);
+		return false;
+	}
+
+	max_snp_asid = ciphertext_hiding_asid_nr;
+	min_sev_es_asid = max_snp_asid + 1;
+	pr_info("SEV-SNP ciphertext hiding enabled\n");
+	return true;
+}
+
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	struct sev_platform_init_args init_args = {0};
+	bool snp_ciphertext_hiding_enabled = false;
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3014,6 +3058,14 @@ void __init sev_hardware_setup(void)
 	min_sev_es_asid = min_snp_asid = 1;
 	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
 
+	/*
+	 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
+	 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
+	 * the SEV-SNP ASID starting at 1.
+	 */
+	if (ciphertext_hiding_asids[0])
+		snp_ciphertext_hiding_enabled = check_and_enable_sev_snp_ciphertext_hiding();
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3022,6 +3074,8 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+		if (snp_ciphertext_hiding_enabled)
+			init_args.max_snp_asid = max_snp_asid;
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
@@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			str_enabled_disabled(sev_es_supported),
+			sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
+									    "unusable" :
+									    "disabled",
 			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
-- 
2.34.1


