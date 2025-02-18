Return-Path: <kvm+bounces-38398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4739FA3943A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428643A9E6F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 07:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021E5204F97;
	Tue, 18 Feb 2025 07:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C3mRCmBg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007C1FECD3
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 07:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739865442; cv=fail; b=Kp1IbrMUrWsZG65wZrWrdPem+B5YnDm7EQKjdZJIw5MSJ+HOMgDe2e+EvOkfsEiZWBPt2RIye8oeqY9VGdg9JQSyChknoDBaUHFqMopT+8MlVhj88cyRNGwPripSbMkgBJYa0qOrDt14cYpWqwc811GgkvTDXW6xJclEZVCyAYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739865442; c=relaxed/simple;
	bh=EPPrhlkyXg4y8XypGHN9BdQbRFyWblmDNJpZT+q/vT0=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FFvrqSuO9YglHqdew1QCoc6ULMMjUlGQqrCpuIBQQbrrZ8Y4kDhTy6Q9zO7vds+bOymsH6FgfSdm5rO4NvbtZNzkKwoiPlZz708vQmaI6vw3n7A/BadmvUkzZY3W8meavf/gDeGJNAMynNgmRGsomBZt50/MjVHnapy76PMJ7yM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C3mRCmBg; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjTlZ0TYrZEexZtKbUWDmMSpFVhPSOOFjmfq+ukEOD/TvC//9ETR1MoatiTTMKuzMnlrvHIXlrKF0k3sVnbY0a1Fg7SRUdz8FuKxJvzRISI+hqpdmZFk/AoXGyOECxhGU1YwIUHX11P3xfqZad21RBAgdiIdB3drFNokg37FcNOjffeqZejSnnx6J0fu472V5kNQcx1KXDijMsTWlpmV8xLA2PHd6dmRFZVhpqZLSfHbvoGHLsaLEr7D+z7DJjMnSx8THhhx6c3ralbMBBNeXcJenbtPdkgTYDohJlDydBy0wpaQemhqjtMo+Naq6Bk3cjEi3bokUlR6zcMOMqwrGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLhq7ZPhL9cB8cPRo8Tnj4Vm25bd/PL0V/rqzrHLogY=;
 b=xdLRgj8FR5Fe2anV7jewo4X9ilHnm/z+Eek4xuw2NC8zY5wBgXOPDlUiC+LOyZCmKw+G4dNiamk5wB34NZI4Zve0CvXJkiGWseA4Pbz2mV2/41J2Ljz7PqxGG2qnRPvgDTyXgQqkJ19D76PWuu068XZzfPumyciLuJuCcEzKOavXLE6Ar2Gr3HVZm8SlqlKauQ8PtmgVsXcgN2I8hpQnk0XNhKOwLO+6lmwLROD71zefQIMxCMj2gy3CvMrsovw3OSEWwTEmZbL/ot1p8Nfs8q7jCbcJ4k2Mpp+yEMddkiEiWY/Z4ZNlvYPjU2ge/0WtUXO+QPjc69e3P+x6Dod+TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLhq7ZPhL9cB8cPRo8Tnj4Vm25bd/PL0V/rqzrHLogY=;
 b=C3mRCmBgiVR60EDn1FgUTpwgxiczcmDKkNo3O1kym5EbssWi71E6CbCXAc8vgVMyImSp9brp+RAT4YPp8glzt96uofE5tve9yxtmjE0E5RsDv8R0rwvsE2/a6vv/fK2tGmx08iBMAeI33gQG9OPVwPyHvQjutpG3FT/HrWYmYrg=
Received: from BYAPR06CA0071.namprd06.prod.outlook.com (2603:10b6:a03:14b::48)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 07:57:17 +0000
Received: from CY4PEPF0000E9D5.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::95) by BYAPR06CA0071.outlook.office365.com
 (2603:10b6:a03:14b::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Tue,
 18 Feb 2025 07:57:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D5.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Tue, 18 Feb 2025 07:57:17 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Feb
 2025 01:57:14 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 2/5] crypto: ccp: Add missing member in
 SNP_LAUNCH_START command structure
In-Reply-To: <886f7424-9f33-7a0f-73d5-886ae4609ae9@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-3-nikunj@amd.com>
 <886f7424-9f33-7a0f-73d5-886ae4609ae9@amd.com>
Date: Tue, 18 Feb 2025 07:57:11 +0000
Message-ID: <85jz9nit2g.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D5:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 91cc36e8-89d2-4818-753e-08dd4ff1dd42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pEHbPGNUJzHwsU/jYbyxUxMABqU+pf8uoBB6w7WgF73L4P/hG2/hexv/7TXG?=
 =?us-ascii?Q?6M913rpikX2tmxCZ+GathFRR3ecMlSOnfQRUuDkIqTw7UDybGsMovHl1mxnt?=
 =?us-ascii?Q?Zg09UQOYGL/ZUHfoxjovuYqPTe5bMCUomtD72fXRFHJvIhATU1eamLZ9b+nm?=
 =?us-ascii?Q?0u4Zdq05jvX7g1DXOpGKboJe1rI8vZPzaPmUEqiEmxRvHbQHJXeAoWOvu3CP?=
 =?us-ascii?Q?6YHWj5VLT1klgLW/feg5ZfjV+EFmishm1ulwLaL7BzPgo6ujtW3JHlPZaNkO?=
 =?us-ascii?Q?FsVFG2UOOzOQwBiCRjT873xfYn3+lqhWw8K37FA+7x55DzfLybPpZFp4Dwal?=
 =?us-ascii?Q?Gpr375tI1UlG6i2he+QOAbmcUKQuzdhfTD4MenHi+ki3pVEHj0c4oQdSiH9M?=
 =?us-ascii?Q?TxbOCAeObfxeUUw0fJZNXpBlTSp8N0pa0a0uVk6hSXHtB/M0IBWM6eigdpYo?=
 =?us-ascii?Q?KSQm1lilxFrzv4blVNT5/l7IAD7QF/ZcZ1MZOAIHM/zN47IQriFlv16oPvse?=
 =?us-ascii?Q?JPfsyMYSmcWATuEK53/Z371s4Vkoh6hHqJvslmyaGutjdw0rgMtunYJb+axQ?=
 =?us-ascii?Q?XsjcttX8tA9WulNzAC/3Wslf//SEe53QDd6TYM+i9w4g4Y6A6IDpfOqy1aO4?=
 =?us-ascii?Q?dcqVFlJMDaFw+xfDAv2JGrNZofnEApK55L98h4mhi9NJKGxxfj8Un8zJAqOh?=
 =?us-ascii?Q?SPXYftOeP97+W34BTmJGBwBbAu9BH2EZrEEj1VHiTu+rRM3JtR0Pl1xZPK5y?=
 =?us-ascii?Q?Fp3xGXSMG1Y93xv/1wUAYB78G6GHZGdK7jAz1KVqCMRJ+GGXSiUPeTdWvaq+?=
 =?us-ascii?Q?Dyk1SRyUIkDoMzcrqSIr8ADIqFaaO7NoxexuM5g+d/4NCs5LftJMcPowhEjL?=
 =?us-ascii?Q?WjBHohMisRjfdeh1OrWvnv5TmHe05/iy/+Ct90M9ic8JJ6cXabhsK2u/aCUK?=
 =?us-ascii?Q?YTFCDyRzSvNH/3oEY0s7pV8HE17UE3PV0YYzhw1P1Tb3+DtRzCEYi3n0dlzb?=
 =?us-ascii?Q?6Rw6iVbhopbBAI6uQmyf5nd4XZWI2pZTZmTqsImHTzgZDW8ASh9SL1nPGBKL?=
 =?us-ascii?Q?JgMaDb0Xf+kyv+KdxuT64XtSEF0hOqtaiXGb4PcGjcxPMJZDCtfSqJSRoHJZ?=
 =?us-ascii?Q?OuNBkrf0rP7b7qTR9rtl99EJNGLPymmhE/xjDfZy9I6gFwvlERS1l0q/Hd7o?=
 =?us-ascii?Q?6zf4grC3KPG9DCBTxQffWgM+TAeDSxfgpwYbDzhJmmecgafAn2v2FvttKNk1?=
 =?us-ascii?Q?t+RWeFa2SkVV//KiG7Wkb5IIPFHD6OTtckSw8BbAXAo3fApT3aksHfVVw/5l?=
 =?us-ascii?Q?O1g/yR4rscw2x8BW+CZSQ5+QzARZDbBrNh2QiMuRDkDx5JYXTDWPo5FtaEq3?=
 =?us-ascii?Q?qktcPf8InybkAnLeowuf6ippGt0ZGv3guPU/mgytKqJnIetrklOf1UY1Ji5h?=
 =?us-ascii?Q?n5r3QNy9kcuCTNfXpTaD1+pfrPfg1cc4gWmYXliEoneJrfchFzIqarFdu9N2?=
 =?us-ascii?Q?/ZGax7lMU4HbU70=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 07:57:17.2592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cc36e8-89d2-4818-753e-08dd4ff1dd42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/17/25 04:22, Nikunj A Dadhania wrote:
>> The sev_data_snp_launch_start structure should include a 4-byte
>> desired_tsc_khz field before the gosvw field, which was missed in the
>> initial implementation. As a result, the structure is 4 bytes shorter than
>> expected by the firmware, causing the gosvw field to start 4 bytes early.
>> Fix this by adding the missing 4-byte member for the desired TSC frequency.
>> 
>> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>
> Even though you're using the "crypto: ccp:" tag (which should actually
> be "crypto: ccp -"), this can probably go through the KVM tree. Not sure
> if it makes sense to tag it as "KVM: SVM:" instead.

Thanks, I will update the subject.

Regards
Nikunj

