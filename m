Return-Path: <kvm+bounces-37641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C585AA2D182
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 00:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D33683AA783
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 23:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476721D90A5;
	Fri,  7 Feb 2025 23:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oUY4v2pv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9838479
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 23:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738971270; cv=fail; b=aLbVZxdM/mqNi7UkUGnm82LdDrLapoRnak+iI21tDWz6icKgQxU0dMdWLxcToq0Dt3hxKr6kB7hILkfATnSG6DoRqh+1JhvRdLqcxduapX9sXJQ3d0HQzS0+AFWR8Tvm6lF6puIYqjJIegfKC0CXNq4MxMUcNJeuWeBgf2Epmik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738971270; c=relaxed/simple;
	bh=taOu67CcdrntDvMtSSjkXxsgZBX7THHmohnmtXFKGvw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ql9C4EfYQhXrn8utUKw2B5XUBT3qsynFYqI7ejfzJ72ROpEjuIAw6dBdBPW9vA2vDjJi2k6YWu+6Gj52uYJ3MUvJU96GR2cw7dFx8Ld4kftSD9kBvPOQMdRhVzXiN+0FjsLkysbCp4kFPHuiZTFDK9NHnv8d4ctqeeQSGm9SqHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oUY4v2pv; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdZ/0GmGXoJnlRPw//MGaWV91rUexKPcsbp33SvMRZXMArruo5rnFvnoECp4N7cAFD8qzdeJNaovnp/StcndWuFMcd1BgcUVKPJjgejb7+0uygUjjkW34l84MCvsXawW7sijOcxTlPfYT/RY72IAqC8NbpAwhKZG5kDNB8kkmVr5SaSIYN/rZpr1lo8bYKS8MFoXDQp62ghbBb4OE3/L/pGbqsuv7z9+x1Sgsppzy2+lHer9Kz1RkMcGt4jw+3t36nV2/TSoI0HKpFax3gFs/vLzwQpSxR5Fx8TnoZuO8ZzwFJhzr+j9Yx2k9czoFdU/Nh7dOcJbQxxeUuTG0GZ/OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+arzDnwRej9X5ePVXfzk3+joL0qY0PRSScZa7pb8QY=;
 b=ItD14X7vthevCUcwTUQd/XkbUumN7VhLbJX7bbQc1VgANbc21KneEc22P2NvM5zLBimnt9ieuq5n73Hjzhd1G7p8iCw0QZ4WJNBDApfCU8Zs8n5G09ubKa3MEPuzLJU36527IrnkDfdBqr/nFoiW0qV/W9hP4Ik4Lz8Jm2hoWUROUdZM5173BXUYakv5gFtUlUXZavfrTWd3Pl8U9qZ9TQ9EU83N57/68ZeyRw5s1fZRvOIwXsF7TkhixK+r7l+vXkXuzmpHQAzlE97FhpzfHdhq9A6POVR7G6LVOV6vS8l7qWuMMhMoDZqE81GdhzEDga+G+ez6c53XNAaqJrKV9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+arzDnwRej9X5ePVXfzk3+joL0qY0PRSScZa7pb8QY=;
 b=oUY4v2pvrw5v/LZzaY8NZnVYPx7/F9AIK3P+TGUOUD2LRtBismsra1WAYbmzGzEQlp8/cneTrkPW1Vd68I8MyMX1HwmFmjyjgwleJFTb/y+GbN44iWw/YGeDvFBREHoxoz56UfNutfqmudGsUv8ah/wY6RoFUo2MqfnKD2k2k/M=
Received: from BN9PR03CA0659.namprd03.prod.outlook.com (2603:10b6:408:13b::34)
 by DM4PR12MB8560.namprd12.prod.outlook.com (2603:10b6:8:189::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 23:34:23 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:408:13b:cafe::52) by BN9PR03CA0659.outlook.office365.com
 (2603:10b6:408:13b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.30 via Frontend Transport; Fri,
 7 Feb 2025 23:34:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 7 Feb 2025 23:34:22 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 7 Feb
 2025 17:34:21 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH v3 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
Date: Fri, 7 Feb 2025 17:34:07 -0600
Message-ID: <20250207233410.130813-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|DM4PR12MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e876069-1d57-428f-1693-08dd47cff3a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s4CctL0YXf7Nrpvm8tTene9Yq4FJTLAcP8MM8gZx6M/RRDX81TMIc+IqK0AC?=
 =?us-ascii?Q?CDiKqApaGIXQo8NIejoxUYIefvJ2pBJj4Vfu7fmQWWWlW2ZcSUeODWzVole2?=
 =?us-ascii?Q?0B5MKJZxK4U9noiz4zt5f6K0r0A8y1ZxN+JXqJor5RkRx6y3TyGuzDdLjoaZ?=
 =?us-ascii?Q?GFr8dfl2A8ZFdsu38F4xUpmZSAaibFQTWyjBeH4HRQsEvFxHo4fGdp/wcSKS?=
 =?us-ascii?Q?ihSIsBOlOkS1SR2wurWUi5RoIjObvEE0cu2Z0a3gNrnC16VpwG+5USOC0K13?=
 =?us-ascii?Q?zj4KsBwZD1ieObvYTGhgEw31Jpj6BoXwKgkuhXGSqiQW0SF6LjTSb+ZVEahU?=
 =?us-ascii?Q?X4bxwGxRpiPLy6vncv8RK+C5PWTEcetH6FnAxVhvLCdGxzhwK9PndQeiRpwB?=
 =?us-ascii?Q?gxAbd9I8mZhDxu08LM1BDxTZjZk5UEgwOlQtZjH2UObq5KQTdEdWLkLvIA05?=
 =?us-ascii?Q?3d+rbhwGR2k1RqC+VTViaOYDGWnSeFqn32X756WRTPgRUKwzqu0eL2D+XtGU?=
 =?us-ascii?Q?wVnm++qT3gkN+Oic0xDxtZwL8dr1aTcmz+AscvYf94Lcek4ZXwqTgX7iNtZi?=
 =?us-ascii?Q?ZCF2P5/hdZzf3pRptV9IyPhgafzFmMd0DjwMmh/SFdQWAyWFpu5Hfpdd1At6?=
 =?us-ascii?Q?zvb3R9fewXZ6YL9g6MJN6USb/4kvVOuGMXlttGuOVNZzFIJ1Fh7xq2sHAAp4?=
 =?us-ascii?Q?LnpYCqE7r0UdXquHM0J3jPgJj990iXy5lUl5fOBHwfqpts7kCxBUm/3fqpwR?=
 =?us-ascii?Q?X8zkRGhwHSLBulQRROjxBY4+1WwAQ69/0OcJcl+KOPgPMt7pfhVw+h0/GdHn?=
 =?us-ascii?Q?Khh7NzrNiXFWOKVLC+3y8UCEM7QszInTZuKxFOkZsYidr5efw0wiaV8q5jf8?=
 =?us-ascii?Q?GdnpoKLsVLedFZEcI5jQVITVo7sp3KgUCSVJNWY6H/7I4ljdbjeVAa2smHpW?=
 =?us-ascii?Q?BA9n5Ky6q8QRj80ACQDzG1/E+05sLO4BQzVX2WLUEDguGlvXic+Qk3gPkspl?=
 =?us-ascii?Q?mXOsz/iVPB3YU5/mWDgpKOUlvPuSRp3Y1tYJ5oklZTu3I27YsT5yTxHhBJe/?=
 =?us-ascii?Q?SMPtzul4X549ehB9M5RW62zxo20c4KpPWdjzvUsPeGfRfVlwxHuhQL4sKJd5?=
 =?us-ascii?Q?beQc5maairwSZGyhAEQms8gYeiIEZgAIxUPCXkil1NfSgX3z9oFfteMq4t9g?=
 =?us-ascii?Q?02m9LqQoUkfJIJuLDFss6LcUswac9FsP7YXCk2BVcafiRSZqnzApS6I2uB2i?=
 =?us-ascii?Q?z5udoMpRb1DBnEEzLUZuTRH4JKpAFy2ypZzlqIbwcTT+GDPEyTMVJE2BCyjq?=
 =?us-ascii?Q?JGp+XoWRFXT0fy4Ra+uCgy/ju4gVRArEvVlyi8ivGH5Z4/8wEi14FIDabnxv?=
 =?us-ascii?Q?xhA1IweQ3849UR7Brk1bopUuW37nkga8qCy1OEqHjlz3ny/4L3FdmxbhzYpR?=
 =?us-ascii?Q?5wlbrKJn90mGq2rfFb5EwLeVUh/8I6VD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 23:34:22.6854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e876069-1d57-428f-1693-08dd47cff3a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8560

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Patch 1/2 adds support to detect the feature.

Patch 2/2 configures the ALLOWED_SEV_FEATURES field in the VMCB
according to the features the hypervisor supports.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

Based on 6.14-rc1.

v3:
 - Assign allowed_sev_features based on user-provided vmsa_features mask (Sean)
 - Users now have to explicitly opt-in with a qemu "allowed-sev-features=on" switch.
 - Rebased on top of 6.14-rc1 and reworked authorship chain (tglx)

v2: https://lore.kernel.org/lkml/20240822221938.2192109-1-kim.phillips@amd.com/
 - Added some SEV_FEATURES require to be explicitly allowed by
   ALLOWED_SEV_FEATURES wording (Sean).
 - Added Nikunj's Reviewed-by.

v1: https://lore.kernel.org/lkml/20240802015732.3192877-3-kim.phillips@amd.com/

Kim Phillips (1):
  KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

Kishon Vijay Abraham I (1):
  x86/cpufeatures: Add "Allowed SEV Features" Feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  5 ++++-
 arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.43.0


