Return-Path: <kvm+bounces-33230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CAD9E7B97
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62E78188721A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 22:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D7A215062;
	Fri,  6 Dec 2024 22:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mJ9tLKBI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD4C204592;
	Fri,  6 Dec 2024 22:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523196; cv=fail; b=id6uGUNVrzzTf5gf1oRDFQjhfvXLhwRbs5Ndl2kuCuHwO5lw2PZTWjCz8ONHhJtfjFmqH0VgR0MwtgEAhymwlzfiWFguwh0+boEVLwRjZs8uzpYc264GFGJoWNfF4WmVkysfx/4+BRmuL9Qn1Wf2p9fLaJFd1h8u/Cfh4kLzNfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523196; c=relaxed/simple;
	bh=Ky6PSSloJbOW6luwi+bF0UFtGDObXjWkQjJt0XD1mLU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DrWyj/KGwDEGhnXcwrl8AJmAzRdAdEJC0VXDZLciisq094HxFfmRCqfcSpNfWNRuWWXx1d0o/0mpwuihdzb75E9i5rd4sX3GHQglcEG2JUpMEDiyIc0pZTZ2D1tC78VXBl4Kk3OxG3uMOwEwsWLYUUGsuhzgynDax2cKxKJ4MVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mJ9tLKBI; arc=fail smtp.client-ip=40.107.102.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgLN4/LbhRDukzFeNY5ibXFI0CX00Qzj8LLLlN++QQDTU6Kp7l1p1+4HlAAzOnN38Mcdp30vP/UNOVduLIym04bmPwjpsQVp3vnxCmhCEQmNtMrR0ZjGFL7B/A1H8YSs0jN27vgtjWWT3t7/JkcoSMcsqHExIzVyBRyqAsalm+ihDaAGbrFgadJUcu2Qqh2J0WyJH1zI/vEHZJkJO3O17d9ZlFSelxcesOEk8mDB155El2hFP5e6DQ0cf0eTRAyop4p80B77lhyd35gfTEnaSQiRazNUcANieEUa0QCiqv0OKV6VETISDaG21g4WelHy0T5IYU8fJSmUPtU6EfoGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWrhsbcxg1ysqMEKLKeMyTQXl2xeDpZk0C+EZb5jcQE=;
 b=qY6omXLfX0+3SAiR2uPN1/WW1XBd+On6GAVvj2JLaznadKouTGgZ/unO2pk8mi2UcdtbBnTTeAOtTSbhxa3pMxDsqSEkCNH0gR5hDPTZD2AsNh1xvwpE5/Vi15ZlpRkXeUmDnffGdWeFay3XnRRBHSIhb4brDkq98bpy7LuunxrMxCSkQElLE0fNNGUrfxKwwIdqAkI44WDsb7SgiqSnUGlpKDQ3K9zuwk1eLxFRQebTnbfF7msts0aPd9UXHIBLi4BnTuntsEQYHTUslWXF8Qij7qv0hhAhOyteqJYWKL/ga3tCD/xATRhCmkJCSLg5HX5v2lSisHMuBpzaGZewDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWrhsbcxg1ysqMEKLKeMyTQXl2xeDpZk0C+EZb5jcQE=;
 b=mJ9tLKBIJGyo4czNTBxT1Qzwz659kVF7GB+8fmExBe9yT+Gqxi0l9/h51RWqd/69RBnLEwto1odG1k7q/tVBtiBC7j9mWNVHEI2E3HpjnkM/FKAAudGxturh9pxVePhb1UKEqIKlkmrfqfsw49AHnIHvhHBIOhPuMUGmnlHu69k=
Received: from BN9PR03CA0965.namprd03.prod.outlook.com (2603:10b6:408:109::10)
 by DM4PR12MB7552.namprd12.prod.outlook.com (2603:10b6:8:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Fri, 6 Dec
 2024 22:13:11 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:109:cafe::6d) by BN9PR03CA0965.outlook.office365.com
 (2603:10b6:408:109::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.10 via Frontend Transport; Fri,
 6 Dec 2024 22:13:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Fri, 6 Dec 2024 22:13:11 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 6 Dec
 2024 16:13:10 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more readable
Date: Fri, 6 Dec 2024 22:12:55 +0000
Message-ID: <20241206221257.7167-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|DM4PR12MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f3b0195-4142-48ab-ddd4-08dd16432bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/hU4VHhjfrTlFpbDl3xEEgodIVzeWf+xjKsFB7OosZI7tf8LvMzDZg3Xt75f?=
 =?us-ascii?Q?tR6NRkD+e1MrbkDllEDoLemAu869c1tINjYUi5hzGvHuBazbxDE7xtvYbLxg?=
 =?us-ascii?Q?UehrRpPMydIR7gZ1mxqB+DUcJ8CRvJPc63I+jY79yzg1vi1MU+RuFq3BN2rK?=
 =?us-ascii?Q?59YW6npA364Suzst09wv/6inIzB75ZKo2PAxtFArUi3aSBe0xY5UZci/LHln?=
 =?us-ascii?Q?uvRfOQEV132SLkE5ZIY4aR/f2fKZ2qKKmLzTsFUEVpJILqIdgaGwCnKcqbOL?=
 =?us-ascii?Q?HuBMdkrCc3OLexmrx8zi0A7kvZ0x6uQd4QuNMHqKbfUlEjXBsK1Gyy1UkslS?=
 =?us-ascii?Q?KKQVit+orOqT025VKYgHM2LPCesYmYp1eB5nvTMEOETU7naepMwTjARqcCR2?=
 =?us-ascii?Q?ZFtvdNMYDTlZpNM5MHnsNCQhESEBdaziy67lPblmHyBBJQsxB6ljkm2A2vt6?=
 =?us-ascii?Q?yEQi/m2K7HKeUQ+JrmF7TUKzqpSdqmBIbcre/oheqME1m/om5jNztHT6VR8s?=
 =?us-ascii?Q?nhuy3aRgWuwPWJb7iWvlk1gkYtFcroi+mRARRIfhv/xaRy8AUJVSKUVzRzVs?=
 =?us-ascii?Q?97yOAnzWXxvtZgtF2+Ku2mqmYZwN2xR8NO87E1XPyLAq0jKwZXj7w+nuAAGs?=
 =?us-ascii?Q?6ASIPQvqQ2L1sjtMM37etSgQPW1GzB2MW4u7d1I4EquAwpfwgACMrOn9vwLY?=
 =?us-ascii?Q?+JAPevjs/kt3VGdD7xwI39oUcBGXNAAkkploZ3ObEr2dyhoOfS3Ct/+padxm?=
 =?us-ascii?Q?5WPW8DDUbXcdw12qi0jeu+l2lEVrWrQmfFv6TgrCmSeFktgB+Xe+0O+PI28R?=
 =?us-ascii?Q?rN3AkVkaxqlfVtghe23LRG5rPGa1Hk4L3Az4MzZBvmJ/AhzzP7BqocBP/Osw?=
 =?us-ascii?Q?qNdB9q/9cFBzsjNnFMWsXy/1OZ9fX3GUm9qeulbjMsENtSWxyQoFnBuFfDQc?=
 =?us-ascii?Q?Z+JemkiUyXKsmkdbLpvrcUKZchAvjY/Wy4c3dWbWgU0I397apcscNpfUEr1r?=
 =?us-ascii?Q?7sDfQlB8AMrAiwBcDPYTdnZWExSp4/t5kg/W5c/tMV6D5/VxdC6mgyxmNU6I?=
 =?us-ascii?Q?+UEUNRho62VUjj8MdF0k8LB7zcrSvmp8y5AoYAR3XxxeRBkYhu3NykuVhWAx?=
 =?us-ascii?Q?XHZ7w/y0ZTPvgxUX9+B24+OH/mlVNzvcQvcq4LOT3/dGwdokctXpY9O0tdBu?=
 =?us-ascii?Q?BswjrfBnEulWCjdOZnqsiCw1WbLiYN7E53QeQ1KbJSVDNSmuKIbtOn4llwbK?=
 =?us-ascii?Q?swrOHQvpvzH0m8yCOu+j6u5f3OPcgDIceeU6V+0HnkkiXlkT+K2G6Y/YWAj3?=
 =?us-ascii?Q?dxFPhbu3p8lBXR1UHQ0WylOhOdn2Q052uc9677IWumA41y4o0XmbnXCHDiI2?=
 =?us-ascii?Q?QukNzuqKtbOQoVU/jF0+Wy7VYSm+UFdCj9zvnEz52cCB2iCoJowC4SlvmFTf?=
 =?us-ascii?Q?GaND7JmP84HQOsv2w8KvVrTFY1vsxW9g?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 22:13:11.2072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3b0195-4142-48ab-ddd4-08dd16432bf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7552

Hi all,

Here are two patches to make VMGEXIT GHCB exit codes more readable. All
feedback is appreciated.

Thanks,
Melody

Melody Wang (2):
  KVM: SVM: Convert plain error code numbers to defines
  KVM: SVM: Provide helpers to set the error code

 arch/x86/include/asm/sev-common.h |  8 +++++++
 arch/x86/kvm/svm/sev.c            | 39 +++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c            |  6 +----
 arch/x86/kvm/svm/svm.h            | 24 +++++++++++++++++++
 4 files changed, 54 insertions(+), 23 deletions(-)

-- 
2.34.1


