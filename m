Return-Path: <kvm+bounces-53444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB9DB11C58
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494C9188DD5D
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 10:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DAA2E2F04;
	Fri, 25 Jul 2025 10:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VI+ymDUw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5701B23A58E;
	Fri, 25 Jul 2025 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439430; cv=fail; b=rTmJ90lZluBNiFAj2iap+xZrP0SCsLvIoHW9RM2H6F/CIaQwY4DuErI1iVabvWPwrLE+MELBKFIdPBVD67Drk3nmuWPy21OQGTmBKMLBEVnGN1uuEYN37ws0hi+m7wqq+PHSFt7fNXMGcUZbsOgXXN2+dOBOmitDITyy32AlIA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439430; c=relaxed/simple;
	bh=h9SU1o/XB9HDwzVdbnQ5UcuuMwLF54KRkqu6mQ6ty7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DZxybw4PdB986dqJBkroS87PniG1bz/iGxO/smz4Vt0PiR8mzPqQmjnFlgZlOGtilsTxMk+vgOPHygEQKD/J74LgISFfxlf9Q38o8sneBM/yxmf5rdpLzBpmT9G2uONknZMjDsA6yRndh1pGNyPgfvMPTouNQtTwgieRMDWNys0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VI+ymDUw; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nrz6LKXcTfXlBZZoXIEbemzntnK+mvW1X8YgMfw+9UBW0Y3PhbH5CFokc+kFkxi5cwAce3VbTcIhwp2tcWlXXZEbBMDmqw8CJgUSpzeL+wOYsrBMcl+Yq4tycwL4HW9iPtQ8lrbSfMrc3KxX0vVlVf1yPCrZe/g0In/6HCuK0SA8ZqQiyNjMtosh30dNgkw57x9HqWrw7SK7WygB0q8ChlG95rg60Dx9rVikEYHdco/k6tNaitKvn1rzh6iuu7Jglgtx0jDr4BFuho/JA4htf3E7aRaEHOcWOxjKb7EamP5MNXElhrGmGnkkrj7IcMfcTMJ27OcBrJsZS/w15jHfqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nhFfNR5zcmFKfQh+8a8SmWgpPgY+1vSOvsOG6LYD6Q=;
 b=fXlXhcqemFR6IfY1qObgqAAtCJpvqIeETkWKoFA9gXWfgsTngb/U5rPA6cK0NRf95QWKrNw5XJMBTXCFEYVSpRsX3g2Gusq9q7RgVKzadAZbOPfTC9XndwnNAiAS/2pWZDUjOjgEMMr28s88gvp8cU27CbqD1BBuJaxEkltDGt5tpAgabBOpcb858EkwG5QRG3UUBWD85uFXghhjpDhyD83brpsfjwWMre/N1TSzd8GG3HFp5rsICHyNDy35nkoXQ19AYSqhyAuZxlhdE4TlXIyBI8arkC+8iH5RIUZwbHTFVYw5PK1l36rqbrWIAvfQbEVJXtLUYaPwXoAV0I69QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nhFfNR5zcmFKfQh+8a8SmWgpPgY+1vSOvsOG6LYD6Q=;
 b=VI+ymDUwe0iFxSc+0ZO/5w3CnKWnAPYfq/eUr+pHq8XsnBE3Rh1/PvJ0tKxOpUlX44tl9TDeKxvacqsxeu2iyC0AtmBBe0d2yttkwmLoLrtv5V3mdVdzXrbMDkqAaCv2HR7T67FfWkYuNe4l0Y/YJA0uw8b2ftcrqgnb/u+Mc/U=
Received: from SJ0PR03CA0029.namprd03.prod.outlook.com (2603:10b6:a03:33a::34)
 by LV3PR12MB9438.namprd12.prod.outlook.com (2603:10b6:408:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 10:30:24 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::aa) by SJ0PR03CA0029.outlook.office365.com
 (2603:10b6:a03:33a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.22 via Frontend Transport; Fri,
 25 Jul 2025 10:30:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Fri, 25 Jul 2025 10:30:24 +0000
Received: from [10.136.41.253] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 25 Jul
 2025 05:30:19 -0500
Message-ID: <2f9252d0-17f2-4466-bffa-9da02d48f989@amd.com>
Date: Fri, 25 Jul 2025 16:00:16 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
To: Ashish Kalra <Ashish.Kalra@amd.com>, <joro@8bytes.org>,
	<suravee.suthikulpanit@amd.com>, <thomas.lendacky@amd.com>,
	<Sairaj.ArunKodilkar@amd.com>, <Vasant.Hegde@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
References: <cover.1753133022.git.ashish.kalra@amd.com>
 <f42f30fc6c2d1bf2fdfc8995be86f1005a66f4fe.1753133022.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <f42f30fc6c2d1bf2fdfc8995be86f1005a66f4fe.1753133022.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|LV3PR12MB9438:EE_
X-MS-Office365-Filtering-Correlation-Id: 227fa48c-39e8-46d1-20f2-08ddcb6643ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzJqTVVJUjQ5aUgrOFhCUXVHVmdzeWNiajZVSmRYd0hFNE1ic2hLQ09jZXEz?=
 =?utf-8?B?bkRob0pZQWoyVWxCZVIzc1hXNURONkcyOGxQTHU3c3ZGdlUrVTF0eUFEcFhR?=
 =?utf-8?B?SlgrUlYvQVdtaVZxMi96Z2ZVY2VrYVB6a1RoNmNZK1JNT01USCthRnMzT3Vp?=
 =?utf-8?B?NUJ1SEU5ejhGUXhDT2pZQ1dLSVlFeHoyeDVCa1hqMnpQSHY2TjU3MHo4RGsw?=
 =?utf-8?B?RzVhUEZxMmxYcUFqNC93Ui81anZFUUNJN0w3aHlxZUcxdTIxU0IxeUlJNmVO?=
 =?utf-8?B?ek5sWHR3U3lsNGM1TkhtUGpnUU4rdStJQjQ3elhMMlFnd2plMCtiVitoYVFi?=
 =?utf-8?B?WldHTDJ0eGUzdllpQmtCVzRyR2VCSWdFajh6NWExNVczZHdBKzB6aDJyaFFB?=
 =?utf-8?B?dnBqcC9oQ2VpL3hTeEtoUDE4dzM1NFdWVmJXRm9wUW5oOW1EN1RTMWM3eTRo?=
 =?utf-8?B?S1RGaTFiTzRyMFVxT2IxYXZ0ZCt4NldpdlRCeUhPYkhFSVlPTE1aUlBMVFN6?=
 =?utf-8?B?QVNKWnZ6azZDa1dEbDhJMlN5eGQ0Ryt3UGh5MjlKOFhwdlB0S0JVemRnZ0pR?=
 =?utf-8?B?eVVJeDJ0M1ErWWs2UzdFNVVFVmJjUzh4ZitnQkVzNjg1d3lEYXV4S09mMlN2?=
 =?utf-8?B?TGZOaXFZNTNWZVAzQ1VrYWQ0MlZwbUlFcnYxblVDdmRxc1EwVjBCZzdlUkIz?=
 =?utf-8?B?dEZnYWJTcVcvODJxNEJCV1RPY1Vjc0VrOVZQNEUvT3JLVkNsRnovcmVsK1JW?=
 =?utf-8?B?bDNNK0N0cHQxbVYxdTVMQkhLZFNVM2V6SVNQL21qRGdTVmVQeVB0UlY3OGdS?=
 =?utf-8?B?KzN3RUVRZHp1UmVrVG1EQ3Y0Yk9ndktSNXVVdERPNWMvMWNTMFg5QlhzUGJB?=
 =?utf-8?B?K2VKdlJxSzFpRmorVndZdVVmSFdnVWgvM0NnckszQXlIaXFTeFVOaDdTU1VK?=
 =?utf-8?B?QzMrVXNrQlg5VnlndEl1M0pnQ3ZCZmxnQ0k4bGlYT2hLcWtWblBnczF5RDZU?=
 =?utf-8?B?YVdsTDZDb3RVN1FxMWdxVUhWYmRqU3hjckl6b0lmVlZyd0tjWlVUQ0xYUXRQ?=
 =?utf-8?B?SnoyYWVjQWcrRFdwRWdXdW5yS2IyNzZ0UVRBTjRQVjNrWGhrWDFid1MrVnFS?=
 =?utf-8?B?MzU1WjVadjRobHJHWXFCUHAwTWo4OUIwNUxCdWhaa01WRDlJUnozK1FmVUpQ?=
 =?utf-8?B?ZWNSR2QyOXhPUkQ4UmRMcWh1UCtkSXVHek1XWk5Bb2VEVDdrY0ZYZFd2Q21W?=
 =?utf-8?B?UjJYTjRZa1ZER2tha01nZUNPWm1QQ1dEWU5PVlFnV0s4QzlBNTEwR2xhQlZk?=
 =?utf-8?B?SlY3ZWdFV21IVVliNkhWSkhGUUI5ajhBWlMrZ05ML3RNeTFYUU1qZnkrMTBw?=
 =?utf-8?B?VUl5M3Myb3FGQzJ1UHg1OFJhejlNR2t4NWkyMXJHSGlEK0RyWGhQWDJKZDRl?=
 =?utf-8?B?eXlkc0JzVW5sZWpOTFlmSkFNeEhFbEZoWFNvUXRGS3FjVUdjem5HNjd0ZlJ4?=
 =?utf-8?B?elFaS2R2dG83dGxib1A0bnF3WkdQV1FGRFRQUkFrK2hhV0sxY3E4VHJ4TEFC?=
 =?utf-8?B?UGp3RFRncEVoZC96UnZQbDNsNnFwWTlVTVM3RkhFWW0yZHRRVmE2Q2FwdEdN?=
 =?utf-8?B?bWpJc3dld3dwdGI2N1RZdDNqOVBmUkZkY211Tk5PSlRVWmlaaVhseUFWMXg4?=
 =?utf-8?B?YnMxbjJZNzYvK2hWcHVwYU5zUXJPVDRSaStsTll2TlhJYjVKUjcweFE0VUc0?=
 =?utf-8?B?M3J5VHptVFRVbElFRUY4ZGtTV1oyN2Fra0ZJMXlFTXNJQUorVE1lNHJKclpr?=
 =?utf-8?B?TlFCYnJLWFpjWHBWakYvMURtcUk3cjFPTEdMOUgza3hJYzJRaEdOZ0RZWS9Q?=
 =?utf-8?B?QjJ5ZGZQQUQxZ09INGxIZjRNUVdmU0ZnNytZSHdVRStUdUIwTExjbG90V3lW?=
 =?utf-8?B?WjR3SklsZTdBcWtDZnVOenNXYkFXOTk4NFlvcWZOd3h1dWVDU2NNTThueHhi?=
 =?utf-8?B?TERxeWxkY3c2Vk9Cenk5ZnhGWUpyU21iV2pyZU9wdUQvVjhUV0cxeUtjLzRX?=
 =?utf-8?Q?JKky8c?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 10:30:24.1654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 227fa48c-39e8-46d1-20f2-08ddcb6643ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9438



On 7/22/2025 3:23 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> If SNP is enabled and initialized in the previous kernel then SNP is
> already initialized for kdump boot and attempting SNP INIT again
> during kdump boot causes SNP INIT failure and eventually leads to
> IOMMU failures.
> 
> For SEV avoid SEV INIT failure warnings during kdump boot if SEV
> is enabled and initialized in the previous kernel.
> 
> Skip SNP and SEV INIT if doing kdump boot.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>

