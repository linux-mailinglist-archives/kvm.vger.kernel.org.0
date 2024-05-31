Return-Path: <kvm+bounces-18496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FCC8D599C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 957AD1F2626C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47847E10B;
	Fri, 31 May 2024 04:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kkiMjMeB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB8978269;
	Fri, 31 May 2024 04:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130846; cv=fail; b=TT/14HwWfTMc3nvB5Hnk/dkTXJrwp8ptpSICCbuJmb1X1Iupq/5BFZmUf4P8K6oce4no1BPU6Nwm8nT+GYKgDYHdF9unRhPS5qBZPPOriJFHqt3RPWydbdOwCifeXE9G7itBJHVLPjUtyazc+e12upOr3JPUsvAE5NruWZ35++Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130846; c=relaxed/simple;
	bh=sjjopn8ueZ5cEfxWga3ymagc+AYibx5QQXOFedXlcrY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C8KLxBiRS4zdvlcRCfZF2GCewHdHZAi0MsQs058RyN7XUUUQ7BUeRRGyrEXItsDBaW8Uas+UlGRLdhZHT2rLCLmGSTICluusUEBAoVCiRqXtizwcwZZaqMZjFgb+jyhgWwWewPjf4mKbOZ+ESm7KfZQhZMlJpvpWXPM65aEn2HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kkiMjMeB; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmmS3a097ogMuE+GAVKSlzmqFNf3To+vo+5gEokP7uxqfFmVynOqM8S5/cYwI417rqpVBiqoT+KCkbf0seIWCBhjk1JG6540tM5DGnchP+0xRpNbhJywHOAnNcuoOLI+BZvN92yQgZVYMJP7Qzj+3Jyw0MH7IX4wV4vx8Qojw5TmywHkBBYTt8rwlLqIT3AcMrQbONdYsH8w/nt8gi0/y5OzcrgcDGMt+DtmQ0WLy/tM0Mq1rMUIf6xsYEzU2webIt9bLLhZ+QztPnbyftVV03xMCdbnfgRJ+NmekIn2MAqsROY1eZiLuhRBlIsDFbLx0TfXXlk0DML0gFwermzazA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roOgh31Mf3lUG20UmibSQmHXleoZ0FqX60hvIN+hAeU=;
 b=JNiZQRDhCR/q9SsF6vqHpbPlxNsM8p9+12a9jKJDphfpkOxYuf+V+WVrP5Lk54rFobVHEhZEzRUn6/4kiqZypxrFl936YeH2SgwlVffPqJr3l70naQwoyFF23LXZS1bw4HDe3tCoWkHRRB5QAJoNLZx+pMmogaMIybVpK+qOuLrRfoc0TEu/wHHrez332L678916Z8sF8mRHT+Cuy6tsVl72Edz11jYhWqlsM27zKQqjHH6zLbDVrHdbnBD6e+O2dCp7Ei+SaREKvg0ggMsk5YGeOkC0AX5cl1BWSbXsusu3o1UkEH4/Q7hF22Cxq6MfhLDyEZxd1vKRS+HGDwg7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roOgh31Mf3lUG20UmibSQmHXleoZ0FqX60hvIN+hAeU=;
 b=kkiMjMeBayuLkGD70S82km8Ae++tQ8nDSHO/7zAL1iInuMcDLtMSD/j2M5zbQ2GFBHYMwYSwk6V5Knz7BSELwYUE8XjQ5yJp+UKUgMZG/nfFYhrGJyJOck9tgK6zbtYkNenOjGVyRdZAKWacsxSwiIiQxLlZas3bVAiLtqUOf3s=
Received: from DM6PR11CA0055.namprd11.prod.outlook.com (2603:10b6:5:14c::32)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31; Fri, 31 May
 2024 04:47:17 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:5:14c:cafe::15) by DM6PR11CA0055.outlook.office365.com
 (2603:10b6:5:14c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:47:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:47:16 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:47:11 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v4 2/3] KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
Date: Fri, 31 May 2024 04:46:43 +0000
Message-ID: <20240531044644.768-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531044644.768-1-ravi.bangoria@amd.com>
References: <20240531044644.768-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: b360a9b4-f8d5-4921-c767-08dc812cbf5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|7416005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6uK3gG08kNr+z24Z2QNksL6ilDlvRtJ+YsCl6usf86WYa+N3gzDYWgxLmStC?=
 =?us-ascii?Q?9K7HY2x9C6rAgpqGsB0epa7dzZpSqSZAYhaj3tnO/rgJKxzhviSLvtgpHPJx?=
 =?us-ascii?Q?6bhPn8MzHsnHmcKFbxOKKkLLv7AFAwYH/GSGdF03zPiSYrhKkaRX5Bkww13G?=
 =?us-ascii?Q?AL99Dk2we12snjDsjGJcpIxXIpbW2qIotVG405mxN8caGz014wMmra8wfOff?=
 =?us-ascii?Q?n+4Kn8JJGB/P7EkwzjlKtqdxICkU0WXR8aT6z+Zy0ymMHDhGHg4Gdq9h9R5+?=
 =?us-ascii?Q?gXx3olC9OqIfG7IClflgyTliWxVAe+280JxexHJ75af4X3oUPcnABy+/L2Rh?=
 =?us-ascii?Q?p4IpxdqJrbrAOdxryPxQF4LLNJ/XWAu4yOv/dwjWfk5WGhopWoJZOw9o+6Tt?=
 =?us-ascii?Q?O8SEm0MOOtb6HiohqlOznpHscoJ1qPzeCTh0P39UxcPBFYPS0Hhp24YfrBWR?=
 =?us-ascii?Q?hx0wm+b4o1uMiZEyCskncPDT3CbDGfGXHVy1pgLK4QuDPSKKeigHxZXEOYm/?=
 =?us-ascii?Q?kjU3cZC0FMswyp8aYiyyI6TldpAY5mL7lufWuog4r1eUDCJcTYShE1NC6yv6?=
 =?us-ascii?Q?16voGPIREzWAzS49814oOEaOTg7vi9n+ng93aFcRRY+qt+ljMg7SQCrk5dEF?=
 =?us-ascii?Q?sk4l6qS6pSI1I674660y0NonvRxw+wLVvQpCquia8jXw3cqQW1m/7yzHRfFz?=
 =?us-ascii?Q?tBm2IoLLBsQJU2dahrhRBu8xGqZnTNHjrK1OppIbVnvEvCYscu7ErZCA5pE8?=
 =?us-ascii?Q?2KURviuzbLr1M3hbhjAMQnM/wQ9OjQxI1D7JD7JZx5XckCO92E6R29AS1pQR?=
 =?us-ascii?Q?SBmE2tug2dTyiJ3wUm8WHNQmMlxjp4/RIatQZ85FRlO//MetAxlJjBmXI74Z?=
 =?us-ascii?Q?nCWodaKuFWktVFN20TFAcTehH6P0yabzSxSA+nQ7WJuz32f/f0z1qeyfoVX4?=
 =?us-ascii?Q?W21fXNP+dJUaZoGPCu51LB/isA45ffS9nGODE7wlmPls8G22QoeotyB08q5U?=
 =?us-ascii?Q?vO68Z9phuieVqYQhTqIetm/R72WUJKWgi29bsljs5hoj81zSb6X7bFMui5lI?=
 =?us-ascii?Q?Cd5Xo/hhclA3Gc8HH0dm0UR5+AvCHFYIvlY3eL0ogDHX7w6Vx7BQvpGTWGyg?=
 =?us-ascii?Q?KUfbskLizJtjnm0Tg1Y5RlHVb6MNdXwQFwE6jyRoqnHAOtT13C6KstoO/gk9?=
 =?us-ascii?Q?o7wR0DN/hFKk41aheTjMHKc4zsoKjMLuaYAzA9sQR/kcqMnLJM0ze2OhwTgr?=
 =?us-ascii?Q?DBiCsyBu7H51JAY2noDMYlmXNpniWH0H1JPLP5W3FwMuBlrjTL4q8wOzwB+S?=
 =?us-ascii?Q?nbs81oUg1G0yvL+RLXHwSh8X?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:47:16.8034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b360a9b4-f8d5-4921-c767-08dc812cbf5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595

As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
guests. So, prevent SEV-ES guests when LBRV support is missing.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/sev.c |  6 ++++++
 arch/x86/kvm/svm/svm.c | 16 +++++++---------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 176ba117413a..8345a5098ab7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2933,6 +2933,12 @@ void __init sev_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
 
+	if (!lbrv) {
+		WARN_ONCE(!boot_cpu_has(X86_FEATURE_LBRV),
+			  "LBRV must be present for SEV-ES support");
+		goto out;
+	}
+
 	/* Has the system been allocated ASIDs for SEV-ES? */
 	if (min_sev_asid == 1)
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a01293f6909..cadf3085f183 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -215,7 +215,7 @@ int vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
-static int lbrv = true;
+int lbrv = true;
 module_param(lbrv, int, 0444);
 
 static int tsc_scaling = true;
@@ -5308,6 +5308,12 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	if (lbrv) {
+		if (!boot_cpu_has(X86_FEATURE_LBRV))
+			lbrv = false;
+		else
+			pr_info("LBR virtualization supported\n");
+	}
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
@@ -5361,14 +5367,6 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
 
-
-	if (lbrv) {
-		if (!boot_cpu_has(X86_FEATURE_LBRV))
-			lbrv = false;
-		else
-			pr_info("LBR virtualization supported\n");
-	}
-
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 555c55f50298..2d6c19c55b1a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -39,6 +39,7 @@ extern int vgif;
 extern bool intercept_smi;
 extern bool x2avic_enabled;
 extern bool vnmi;
+extern int lbrv;
 
 /*
  * Clean bits in VMCB.
-- 
2.45.1


