Return-Path: <kvm+bounces-23881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3551894F794
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6CBE281D03
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB4219306C;
	Mon, 12 Aug 2024 19:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bSoE5pG1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1441922CF;
	Mon, 12 Aug 2024 19:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723491715; cv=fail; b=sZc3iZfH/wcsZ6YmNxSFik7T5DChkU8jXE/plEWZuvNXbLRv+T3thtT/rzETZtQOnrQCDpqcwru44HXlq5NlMGzhV187653+09VHqJ+0LWMnYsZD1pECRGXWjREwg0eOAI0+640kgE2BhZfVCI3pTNpRePmHUNcBTkdcfmns2Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723491715; c=relaxed/simple;
	bh=UFj9eHPcLkk7oXvPmmaPyhR3mU5qhO5CNDtJhug1HbI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eBJM4swwh0dYkf1l6t9Nlr4Jwx/ya1oLv2bXqAjfVB3Gu64Rw1ziOR2GeBGNK8ES/KqrebSDUwnev4nxJIiaL20kupxO976Q6w6rOmAxx00YWcMhuuYEnILh27gz6ncesLR15AwChXK1eAE2gAi+HNA/KQBa2xlRy7KJw0d8jt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bSoE5pG1; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2D/nUuWTYcrAviKkaYJl4AMK6ZA6EVsaE4go9E5t+qqrvOgh4+/RYzF/7DkdrRYpZLCDLg0/4H1tGtlogxNmSxMrQ3neFZSp9GxftRhQGDYjK6GNKcQ/dQjGaeBDud6CWRsQCdn0cc2yQnXB0zcZ4W3BL0dxbxcq56JAeszCXPLztLP1J8bY9MaAqOoOqkb39Q6XRCRW9f95mWQzyx7dSQarvFNGTVEZmXNgydlLZiCU/PBtuht+noaRYECu+4aWNX/9Pmfd2gL+Jm5lOSZZrhJWOGqIcL5WcnQoGexzdXZ4dInORDYUzceGRVzWsEVPLFdLVko4VklhMMGXjobmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXdepIP/YD0ikGZUttiEVBERKNajKvq2pkszGK2DhZc=;
 b=NIkTOXocsxzThsXcD9fEe1tIZspc9j/83NyfL8ct8j7hRFOuxo8E8gFOVTWX8ybo1ILClZfx5UnfccunBPt/fUvlHIoYb+b6K/amwITG95YTx1dwpTK9SplPAr1uf0QMaAzTuEYjA3vtDn6aAHqGmDbPi+D5LBPjUWoEd8cyjFl2U+58KnzV3zYIpvOutkkYxANj5GX30wiiapH09KELbbCox+MOe2q+jUEOP3smrz+0XujMciJvFC6z3LahGmXAbmTkhtrvC5bv3Btl4lG51B95rwc6lgiA9CTkjlr0Uus+StDmq0sKDp3HkxrzPd9FtRwXETpgYXpExpdWJQ0eyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXdepIP/YD0ikGZUttiEVBERKNajKvq2pkszGK2DhZc=;
 b=bSoE5pG16uTfq/l8FU7IJDSjise8KmcS1KzPzlFMP3az0XGj0d7hkeHW0Y9YEn9n9WJishTLFPNb2KVmVNnUHbDYUw3+VbdkVZ5ve2XTByEchgX8P4DufBs3fgA+Va6bS4BPAxayhyLzzlqvlUIc3jCGGN+cvvZQmAy+hFzT/Z0=
Received: from BL1PR13CA0391.namprd13.prod.outlook.com (2603:10b6:208:2c2::6)
 by PH7PR12MB9223.namprd12.prod.outlook.com (2603:10b6:510:2f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 12 Aug
 2024 19:41:51 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:2c2:cafe::8f) by BL1PR13CA0391.outlook.office365.com
 (2603:10b6:208:2c2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20 via Frontend
 Transport; Mon, 12 Aug 2024 19:41:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 12 Aug 2024 19:41:50 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 12 Aug
 2024 14:41:49 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 0/3] Add SEV-SNP CipherTextHiding feature support
Date: Mon, 12 Aug 2024 19:41:39 +0000
Message-ID: <cover.1723490152.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|PH7PR12MB9223:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0c12fa-9326-47f3-12f1-08dcbb06cfa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rPqNNtsjN3lEsGoYxY4dKQW3csaZ7GdjW1GEiul8A02+kwYQza+Gy2ok2OeT?=
 =?us-ascii?Q?Diarm7wKuuyQEeF17+MNgms/Ti4LX7gV5arZKEJaaDc+BCvCLxIowcR/J/ia?=
 =?us-ascii?Q?EM/fZS5ma6PXg/9iiAdpB/DraCvpcquwKXVKrwV1fmwH/lroy2gCNBZP63Ur?=
 =?us-ascii?Q?smWha/SP+w877yhe8BiFd5E527WJjN0TBPLpY3LnZjRKqJKyZqkXHP2EN1BW?=
 =?us-ascii?Q?gUuIKNEXF2yKN3KXwKEP+0M1iAGWIbxMuQcmR67O259b9VogRFMVSa7O9i02?=
 =?us-ascii?Q?BmWIsfDZptICEIpPIwFTL/2TFr58du4Arfa4Y1eSFDi10wUOY+IzlAG0IirE?=
 =?us-ascii?Q?mRosCMdfW7YXcHgK6243YuGQlFEA5PkanhyHSx5CQk+C4JXADCY0YZmFo1zX?=
 =?us-ascii?Q?JqiyqOd1x8njYMipRZKqT4f7+hM/heOKZ8gKG+fZ89K7syYRAxxwRSlHt+Kn?=
 =?us-ascii?Q?z0YEbJLkIiJ6yBtOyl4goVAG4T47ohQdRL9Ws089miUaPg3ieQxEyv+enWbk?=
 =?us-ascii?Q?J/nrwKkJJHhvPupRBdQfOR4tzgXy8b/O50iw968/pwz6IgGi0MoHWlW1stz3?=
 =?us-ascii?Q?VnR2UO/X+KvxF9MsYX6xKjI70vp4BJUzMM5Q3SPbo2Uju41qfiAOaoujVru0?=
 =?us-ascii?Q?eNc5HNbai46maAII1zq4klbUGAu3ZasCq4vCsgnlaZLDKR4C1ekvVKrkEqw1?=
 =?us-ascii?Q?La5DfxyaGaSj6qtpuUb3S6JnF8ZeTiVTFBj7rIjbSKb5wNYXTwsVZFpJwDj4?=
 =?us-ascii?Q?SCyBCLNS3exNbaxTsyg0g+lf8GHlfNWy9UnhLypaF1byPRuNcYZiOJlJWBzg?=
 =?us-ascii?Q?/JUUrRBlhi9fTg47v0RmLHo9R4tDMuJ1kH/aLcaXzZZvgqfG4lnHjdEWqUhr?=
 =?us-ascii?Q?anyzrS8SWELG1jNNoql8lXxllbENCNjk9C5pxOzt0pYno8RZOCMxv7ieITTh?=
 =?us-ascii?Q?NAIYJgsPnSFfDexsZeYblQu8/NHJ3g4EY5wpb5P508Jm50tEApjESRarDm4h?=
 =?us-ascii?Q?iXkne1LK2Y0cplMo+uJjthOsJG3b2gJwejQ/y4ExxOpovGosJTz7Ak8rnYrS?=
 =?us-ascii?Q?Yq3Xk8olGdRejTdOAAZetT7kZF4lOnv7AsosxYjmaupu8L8tEn6aZqWEfO9s?=
 =?us-ascii?Q?CE0U85BLXV4rhPb3X3bR7QvNjgx/zZSPTl/v0cj+W8rap0BttAt/0aZZ6jum?=
 =?us-ascii?Q?XBJgusbaftG1ceY7Affo3Hl2FqKVqW8S33Ona7lvUcL+7WDNESbQyeK/6Oyd?=
 =?us-ascii?Q?1YXS7AXIte+FfWsPVtjqCzcvzyaQJSpPFplSSnDoggZ6plBZDTwkculyPfiG?=
 =?us-ascii?Q?FjrQttpaEXLpbQuBgLndq1X2Jz519ISFrAbMni0gTV4OL9n2+NhrryuUjJeh?=
 =?us-ascii?Q?HBSGuj6pCE7B9REo9UX0Bb7MGBYWR98VXJoyUni7z/mI/TMoVupv8httAdNK?=
 =?us-ascii?Q?1QCAVvAnCSw7xcUqAIrikFvUtGSsGSK+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 19:41:50.7239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0c12fa-9326-47f3-12f1-08dcbb06cfa8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9223

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext
of SNP guest private memory. Instead of reading ciphertext, the host
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and 
host ASIDs. All SNP active guests must have an ASID less than or
equal to MAX_SNP_ASID provided to the SNP_INIT_EX command.
All SEV-legacy guests must be greater than MAX_SNP_ASID.

This patch-set adds a new module parameter to the CCP driver defined
as psp_max_snp_asid which is a user configurable MAX_SNP_ASID to
define the system-wide maximum SNP ASID value. If this value is
not set, then the ASID space is equally divided between SEV-SNP
and SEV-ES guests.

Ashish Kalra (3):
  crypto: ccp: Extend SNP_PLATFORM_STATUS command
  crypto: ccp: Add support for SNP_FEATURE_INFO command
  x86/sev: Add SEV-SNP CipherTextHiding support

 arch/x86/kvm/svm/sev.c       | 24 ++++++++--
 drivers/crypto/ccp/sev-dev.c | 90 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  3 ++
 include/linux/psp-sev.h      | 41 +++++++++++++++-
 include/uapi/linux/psp-sev.h | 10 +++-
 5 files changed, 162 insertions(+), 6 deletions(-)

-- 
2.34.1


