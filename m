Return-Path: <kvm+bounces-52990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 213A6B0C608
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B30FF188C3B3
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F632DCF40;
	Mon, 21 Jul 2025 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rLq7NdK/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F62D8DCA;
	Mon, 21 Jul 2025 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107274; cv=fail; b=F7OzfQ+vI7XtYidMPhoNYRlzFIAOXAKdLLWafA5k4Xh9EiPDugoqA7Uq+rIJbVeR6oHgDxp53KO3Wz5YHXbz8kd/njmd+4zVzWxJFNGK/CkJ1a85eKmh75pHJnYv3OKYu1Sqx2rGspga/yEp1fgj5DbCeBr3An8v2bRpcXBGBIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107274; c=relaxed/simple;
	bh=kxxZ/NlhfTYakCm8T8oSLZTRkCQtPuTRGYtjSjTGNCw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTIquI99JVWnot7oeyELyuvaD21PDmqcnXovs7GVWUVNL/knvYOvRUWkUtEQQQpnq8QsY4chvZ26qjHQvpm4LRn8SvcKWvOxKcc8ctUk7rpPTItPiEvGlEfySHcuy1ozKehurINwI9mPBWDRtgyeiLQ3xEnpXdtT0jjF4THEmzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rLq7NdK/; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXt7+YSLoeQf6Khbb0pG9AZlSd5M6k6AqWVYuHHhoF++sKQLTZas70xVDulSmWioxQzfbRyTojRpdMbef59hRNp2CZ7y941CBo5NMvDQY92q7vzoLKR9RPLdwpsSb2H5FTNrHvc/qGvzYq2SEUirfDuPeoGTsgXNLXRZVNyCOutaset4oXud4qTa0p4OG58wMOFasvT6F4xNi/VmfeLzAkvjXcOafjXRMryc2e0FXsGIPqNjvsNSrl3/okrY3ysi6TYq+KSPAk799UE81M1tq1dmYKaeQyxuXGgFU1/58pUtEwV5+ngfko9DNVgNwnKnz7PdNrx72Oz+htIdnsEp5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gijzvf5zdCarxAo+ASb/Bp7TsQaLtXMmSnSy2mD/Skk=;
 b=SUolYDSPZOqJQCb05aE+PqLTqMjgZU9nc/M8gDg8rQl9jtjmaqie8LP22/z6xfFD2BkiiaPLWBUFnXoBkF8qmNAfAzSxSppaiMjjevz0Mq1kzcNw8aghxLdXlW2XlfMMcOuyRRCKXXG4oRpXkEZmWzNy503O3Qmt1y6ClUk9EsH96+pyjUPoN3Lu6hueKXLrN2nwiTB/K+kN18BDaqyBzvqe09hQjMFJi0vhWiNm5RBS1jP15iPWZovBp1GqFUc0160wZmDXZX2y6UCJV5W3zspHWCQwGsB57xGB3vl43ZUnig1oVfm6o5evi+d3Gk2PLOyx3YfiYTQAaSvqkTTOiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gijzvf5zdCarxAo+ASb/Bp7TsQaLtXMmSnSy2mD/Skk=;
 b=rLq7NdK/CFuL/v/Xtw9YMm598FfmaA6q+KG/x5iueHHR+4AG+zb7Wl5nF8Crtt/WEDtXSLHOq1pFBLdRpWxI2uGBKm4Fn8oahGJAN+iBzVFividF0AsCzbWc+EuD7GvomXiJZegnuiGnyvgxkScrk8DMaBRLDOqdOL0cUxQdoEE=
Received: from MW4PR02CA0030.namprd02.prod.outlook.com (2603:10b6:303:16d::18)
 by MN2PR12MB4208.namprd12.prod.outlook.com (2603:10b6:208:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:14:28 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:16d:cafe::a5) by MW4PR02CA0030.outlook.office365.com
 (2603:10b6:303:16d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 14:14:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:14:27 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:14:24 -0500
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
Subject: [PATCH v7 6/7] KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
Date: Mon, 21 Jul 2025 14:14:14 +0000
Message-ID: <20cb9335180cf44d02be92745ddd5a199a3a6afa.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|MN2PR12MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: adb777bf-3967-40bd-921a-08ddc860e730
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YHOZ+qFOVjlblVGfAjWhmh+6q5FdjfmJGEW9nVH9l5Cm4otM7Je+Rv8EqjvU?=
 =?us-ascii?Q?b85lcYtywOHEDo5FyAieankjZlNQ5kMSjztmmCnbRlhpRSbrsSYVIOVAn+qa?=
 =?us-ascii?Q?Oc5U2+U28Fv1EBe0SBSnZKEHnzpIk5DMUtnJ+610wjFBuNc4dA0wgsTGHcae?=
 =?us-ascii?Q?leIQD24XpdnFnkoecR6KJKgbD/aPAjPYZfaIQ48rcDc61tVoXDL+ZNr4NcZT?=
 =?us-ascii?Q?QSQXqr55dNKh9Bftkt6fXOytZ1EywWGp+Pian/+bxGuK7JNBUL2fycGI2Lr9?=
 =?us-ascii?Q?Hlb8H+FJWtF1B7GwACWoHOdAzHrhqchCQrdXtqtRdwDzUMKCBfFkPTi44ppB?=
 =?us-ascii?Q?jPiwqvwKZprYFL/MN0fsG4GadzeVrB+phX5gkr95PYqrZPeyw4fapyd42OFI?=
 =?us-ascii?Q?4HkK/nqKEwPgAj4ZVj88gUy1MJkiqAFlP6d0OfOKSMTqgj+/9mHqAgZOOrQD?=
 =?us-ascii?Q?rJ3hGETr3tn5NGfZ3a6yOog3vVghJY9lFhuIvwdl3IR7QYf1G8pMxPAVbrRb?=
 =?us-ascii?Q?oRztcCf00eCxBeK25smvgf0umnduwLUwKsbBMAzaWV77pBkw/Ll1vDHKI8Y4?=
 =?us-ascii?Q?ypiXBYCgqAGV/4CaTJSa2zAFVLgG5F9tPElBrhOY6BvgtpNh8qBs7EECs1Bb?=
 =?us-ascii?Q?eNNwR3hlAG9qEBIFwdmqMbf1oyT6w9rYbHoY85HoVqLXXRDj4xX4tq69f1CZ?=
 =?us-ascii?Q?zJLh6G1mAMs40GeP/leFWtsJT3Nd3YqiiWR6pVFdH9dVxoC30b2hb274rNOu?=
 =?us-ascii?Q?H9aI4wYYXbZHa+Vhqs/Zm8Pn4S9NVIJBjjX8etGHfPMPQf0geOvg/RE7GD07?=
 =?us-ascii?Q?g9bDcGU25VOe8+jp8eXPZ7c7c8+ndzQMbFKSkraGd7Pl8RhY/P7I7uZEX6ma?=
 =?us-ascii?Q?pOOpMYKv0gLxXIcXWoS8xvwh8ArAlc/bZZ2vH/yrqcf+k7CMZ8EWj6TtJx32?=
 =?us-ascii?Q?mcsS43PRDUEBQglIjeujcXj4h1BLCJvlr1pI7ED3GUxjlcG/Hvbv1hMnCrwP?=
 =?us-ascii?Q?YzOcLyGXOI2nzGqPd3t6e+S3jmTLzS9uN6f0+8GOEDRdMBCBIIX2qk+FX4lh?=
 =?us-ascii?Q?bPA4krW1qq89Ibsfgh8p1jmnaNGm7BhjToh0iOPYJcILx9XHlIgkKYrep+Hz?=
 =?us-ascii?Q?L01d8AjIuQhtCQk/T0tXW5LLwtysQ6+sjgF/LhaJFnszUuOEiBU20fQs3V+X?=
 =?us-ascii?Q?8ScqX9aWjGHrJWDRjN364x4xt10Xl1rQ5QUDcZdfqkMd91xfo6mfztMcRW+T?=
 =?us-ascii?Q?KLhUqOP+lTC10oU1CMvk+OXOgdoDa10x4NjBrPq0X+ukMKvZXBFi7QArOtBF?=
 =?us-ascii?Q?2+PhZmjLJ6OMyXFJH0BzBcFqCqNr9h2TD405BZrwiDoQT78J++uRtOcUtA5p?=
 =?us-ascii?Q?GZI7KEuLNr1bde+/7BVABK6UVlJzgKJcJTgb5dFfP09HEI8MMxSJkrD/zGpC?=
 =?us-ascii?Q?O/3CiskknPYZvUgkpUhq7QEiUz453BJrz/NzJzFWW3Q1sTS4LBdiiLGEKM5g?=
 =?us-ascii?Q?KgL9Ug5WNs/s3S9XhFdgl+uHeMdVtn4hElqcwnZKuzxu5GLR9jjs6AGvBA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:14:27.6264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adb777bf-3967-40bd-921a-08ddc860e730
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4208

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce new min, max sev_es_asid and sev_snp_asid variables.

The new {min,max}_{sev_es,snp}_asid variables along with existing
{min,max}_sev_asid variable simplifies partitioning of the
SEV and SEV-ES+ ASID space.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..b5f4e69ff579 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned int max_sev_es_asid;
+static unsigned int min_sev_es_asid;
+static unsigned int max_snp_asid;
+static unsigned int min_snp_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
@@ -173,20 +177,31 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 * Note: min ASID can end up larger than the max if basic SEV support is
-	 * effectively disabled by disallowing use of ASIDs for SEV guests.
 	 */
-	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
-	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
-	unsigned int asid;
+	unsigned int min_asid, max_asid, asid;
 	bool retry = true;
 	int ret;
 
+	if (vm_type == KVM_X86_SNP_VM) {
+		min_asid = min_snp_asid;
+		max_asid = max_snp_asid;
+	} else if (sev->es_active) {
+		min_asid = min_sev_es_asid;
+		max_asid = max_sev_es_asid;
+	} else {
+		min_asid = min_sev_asid;
+		max_asid = max_sev_asid;
+	}
+
+	/*
+	 * The min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
 
@@ -440,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3042,6 +3057,9 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
+	min_sev_es_asid = min_snp_asid = 1;
+	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3065,11 +3083,11 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_es_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			str_enabled_disabled(sev_snp_supported),
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_snp_asid, max_snp_asid);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
-- 
2.34.1


