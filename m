Return-Path: <kvm+bounces-23598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D705294B6C3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC75AB23E23
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9126A187869;
	Thu,  8 Aug 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MzMYBlvJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E936187856;
	Thu,  8 Aug 2024 06:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098684; cv=fail; b=U6smyo/VBh92It65QfRGpC0NpO3BiwLeE707Tts4qTuJwN3amlRLbQWVXKCTORnJX84W/vwybEr6ByoiioeQqVn3uwyyUg7fIkHb/ucr6kiw1Xh73c4wb99xNBCiVrZJLtY6Kh66adKe/Cjh+GbU7CkdtPuUQ9uFQng4/AwLuI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098684; c=relaxed/simple;
	bh=Ogmxi5g5anKwOGIqIDotel9U9SR7utOELpTVBxZgcDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbanOssZw22G0WCmjlDTZWhj4oF748BdNlMe/WwjFs4aF9QJlTRE3aWiQNTa2lZ2kkkXMVgD4Kc/KU1kWUiy1VXuvWhG7rmByLDMHM8e9UohNH2T4i9RKNjd1PK08pu0YsLu2bO7PkYHAV6EX0gMGfqzzffyB3QcVYu6Yz6FkYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MzMYBlvJ; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I2lOC1slQO/qOnU9D7skX7QcqrUifrWwCPK0+yATi9zplWKuHpVc7I2h47aN3atKGyzk08E4gqYDn5ovT7IwENsoRCqids025XiPSagvIEmih3nK/3W1hGBuZPnT/HbEEG17PnnCBc/h3GIgR5XmAovndIfxJQ+fPEXV2jOYeDI8qET8Ao1F9IbOl1b3lbHgO2uTyp/W2VXSXnGJcuOv4S1TUnxfXNc713Ck7afiP4H5O8j4BKutYKLGKG8yeu/RyILckgpMswLEtv8abJpv83Y56I03baSIeh2aFGojHM6o7t52uafM0urMj0a8CCUtBprFaB3nk0Tl5gaYjs6nUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDJMMEI+mWun6BZ2XcxL8y5gYRmVwcdbVagt2DLFMro=;
 b=fF5IQLI2hoqPqLhAQyH5mOcc0unSQ+2wUFAYRJHHCHJoDJPP0NHCvUoAN6J9OO9r1qSN5m1ZxHk/UKyLa/pyp0y4ONeKTeZbkvJn6J8FUBC/Rr+nPbuhkY1iZp/hMjztWv38XL2Sx1DRWrGc0zyasZeoIZKlvDE7WZtM0mc4Fq4sQD8ybKewj9LDA1Gqd6j9N3//+c4XWxGUkxNE9gBFTk1w7v4pITg80LacDt2UDLTBKhbibpRna73H/XL8Cdn2rmG6AeavNNSiVfUelCI6Sw5EU5bxYxNAEAy/idl3Ne0+tD/fo1xYc7a9BZJox63MMDP7pua/Cw98HBYJkFvEjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDJMMEI+mWun6BZ2XcxL8y5gYRmVwcdbVagt2DLFMro=;
 b=MzMYBlvJCg4xZQ6JfftgXRNv6eWwx41y/o/S2HYZqB9hxzwJJDW+AcimmDReK4JxaS8wsewxEhYDWpkr7584kdT+y9CodbwJTQDvFoFaV0jnt0d9eGGBQW4TZXOUe4SyzepwmBvcf6hL/uxVkgKBPAmtHlbgs0Jqn7n0XENMPTM=
Received: from BN9PR03CA0327.namprd03.prod.outlook.com (2603:10b6:408:112::32)
 by PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Thu, 8 Aug
 2024 06:31:19 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::6c) by BN9PR03CA0327.outlook.office365.com
 (2603:10b6:408:112::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30 via Frontend
 Transport; Thu, 8 Aug 2024 06:31:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 8 Aug 2024 06:31:19 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 01:31:10 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>
Subject: [PATCH v4 3/4] KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing
Date: Thu, 8 Aug 2024 06:29:36 +0000
Message-ID: <20240808062937.1149-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808062937.1149-1-ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|PH8PR12MB6964:EE_
X-MS-Office365-Filtering-Correlation-Id: 6792c51b-a24a-4513-aa7d-08dcb773b685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LrbkqD/7op45nd9iN3wqmkmKiLjv5iVCj4hT7jg8DqTndsWpAvAY3IsTS/do?=
 =?us-ascii?Q?FVRe8cQ+WFMaATeA3Dnm8aKJRs+rMWo2dYxjY8SSyWtglwQrcrv61o+j4ZSX?=
 =?us-ascii?Q?Co6cOeLxRvd36rhhRJOZtpgoNtOFhpeIgqVkQu73VuGYiCWunzraqwSHfwNi?=
 =?us-ascii?Q?on8BVagh8Ik8pmq7ls95YthSkqPu1xyvkEukFmw9jJ192F+ru4gO/H+C+WjB?=
 =?us-ascii?Q?Rq2aszgzBWC4KBiSdsuvODmfm5DCjDpR8ycN+PlFeKBA8tpuqAIMmDrrfARg?=
 =?us-ascii?Q?7IexIWupFUF4PK4AACiuBsl1B/HYvCstBIXJ30YBqHQ9CCZ6C+yqPo4etAmC?=
 =?us-ascii?Q?KUtG4pr/g8H0g6m2fOEtzjLFhO4j+Fkn0zBKhvEzZ/d5sXK4vw5xTbXtkqFR?=
 =?us-ascii?Q?dgHCHBLemasEUIyTf2kNY0MRKaz7g3JyhTnwL2pC57f2Wc6xZVbCRf96CrSz?=
 =?us-ascii?Q?SFW4nJWCL6nBC7cWHcFzU+NYR1J8ZTybh3cp07tctpmP//BTdS4omi2prJhw?=
 =?us-ascii?Q?uI6WSZx/HlOxMXcgiEmeGnuzy2VdrvDdJ9AfiF+3R7lPHPV+3pirPQWwXovq?=
 =?us-ascii?Q?ptgYKQFJjMQhhLx2ruqwhxOPYVa7pz6OJc5nQoHbD25e8tT8ctHY4AnZ5XFl?=
 =?us-ascii?Q?MiZS46Kif8prQN8Wgb++T+S3n27A8fl5quOsRFL1zJ2h3L9wqWW/YXI9dEoR?=
 =?us-ascii?Q?XsXloTfs9KGbc+qfEXlIeAy64JdDmh3yPk8jL273f2YULxmeOipOvIyExjEn?=
 =?us-ascii?Q?aIUN/wnf9lFtwNpxG9Q+UOGyq05osYVvOARGwkH3qbqyhEtQYyKZIYUMj6xS?=
 =?us-ascii?Q?b77xV9l8vKMD1Xm/MCIB2jULHhanmE77ZU6Xo4G//hanEhH3jJL+/6/zHWdm?=
 =?us-ascii?Q?gZri69jLe8QFqE36xnBrngs0CZ2OTq6nMHRDKlEIPaU94U+amJapD7tKDe59?=
 =?us-ascii?Q?1iZuJIZBFJjtlyEVHnUA+GLd3ZC56hMQ7QSXV/XGU5ATTF/65FbTFVU0FSTU?=
 =?us-ascii?Q?N5eURs2xD0TSzubvVZh4T8g2Av6SiiD9u3qeUGFUQdswvVE8dsxkohI8JmML?=
 =?us-ascii?Q?AMJnzniaIiXBhj/mp9kIBVkwmbveWwmjK1U8WDQhSSYtBQ8F8wFR0osuAtWG?=
 =?us-ascii?Q?0PlnSq2z15ZK5NUKSiAZFlRt6BDE6BfVqHqHsOUBm+4iJQhWwo+1tDASNvyx?=
 =?us-ascii?Q?TAJ6aqRBG9lcLvxl+8CedkNaPrXTRjReNS3ByeOMBavL4mgIcIHhgZVtf3pc?=
 =?us-ascii?Q?8vWT+wAbAQW1V/kAK1KPdgtNq62D99S3BEx30HfwnqFmoVPJj5W16/gIMYPK?=
 =?us-ascii?Q?1MHoMTgH2eUrN/0q69I0sF92A3974cM32zY2iVRcfIzk9aZadT5jZ8k5fKAD?=
 =?us-ascii?Q?eR8tU8DOZmwBFkmXqlL56D8IdD9vazrdbcDtv5u3+Aqhoowa9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:31:19.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6792c51b-a24a-4513-aa7d-08dcb773b685
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964

If host supports Bus Lock Detect, KVM advertises it to guests even if
SVM support is absent. Additionally, guest wouldn't be able to use it
despite guest CPUID bit being set. Fix it by unconditionally clearing
the feature bit in KVM cpu capability.

Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..e1b6a16e97c0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5224,6 +5224,9 @@ static __init void svm_set_cpu_caps(void)
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.34.1


