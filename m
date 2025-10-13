Return-Path: <kvm+bounces-59866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 593D7BD1798
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0AC64E8EA1
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0992DC772;
	Mon, 13 Oct 2025 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dD2xtYaX"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC7296BDC;
	Mon, 13 Oct 2025 05:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333910; cv=fail; b=BO+Q1mfF8Ctk3zBE++fpLcvUKZhymw8gFMkoPiWFs32/I/gPDR2ySycID+X6az+omwbuSX+k+j1GUu7+e37Y2sHaNln3wqRBH7aRyHeIFoNs1BSXQTZV7wQsLOQZQr6nAr5JePwXepA4mkdtFiIOvzcoXUE7p8WqOJmOyF0lv4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333910; c=relaxed/simple;
	bh=DZFWXLFQMnWS4uEApFooIU8ivFnZNDXufLHa0WCHdC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=A0pgN8Y/DZ7TjbsF3Tv8SutyEXbWBZkUHDDj+6VRxHOTgQxrxRxO2h2sMfJqmDzvn4VPXLutwCuZPG1txjDZrln3eGQNgt8xyT82lMVXwVkfHlujKB3nucC2qlGVhlClmbfS0SQtIaF+3fScevOn7qmS4YFlKwtuw545TWer0jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dD2xtYaX; arc=fail smtp.client-ip=52.101.193.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaAn3IfKYJMTsSS30PNTCzH0Vb9bckKzpgGZmmQg5cnGLq9Yhhg3JNbzY9DrP0Vxk81ekOevcp0tEtAdLXEZ3OUNUhTHQPq7QD1fJQfzDTIOVIeSqjE6fGAQ2YRWYGcr1wmTJOyAEpum68vIbMLqcTKziiPFrqZwpREqotxIGhyG1V23psv4+gGqESHaY4rME060y7bSSjw7ChLbCq6Yimr8k8eL00olo8eqzkYWxvTp5b93h+NqIJ4acEVltkhlbPrXHEloQhoQSAe4q4Y3Y4M7my7vfJNPJF/i7II6j/Sr4SgQg9BSuGVLog9wNRF+8vXd+NF2c2Ronrh7mIXGoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0c0dLb7YWXS0Skstgq6HruQeTYZIJ4lP3FfUNOOOXI8=;
 b=qQX8OyVMoizw2ZJt8jPiDflUjzoCegIOR5KoY0QG7A+mvYE1DymBA8BXWewFBERVi+AXItHfCRMpPSZnU3FK93GYi3XU5fOVUPUJMnzbpAhj53wLopyS1v+J3rVUfmG7EkyOSzSTqtvgupS2U1TOJB/r+BIj2MrgzHMu/4CojwSQa1yFIpn6nZXWX2U7+adbrVY8xbmi6syCmn0x9Q/PpTNDSVbu87NzTt5U9SGVR4Sjce0NYcTyBklhwx0ez1SaiDd/aNI3YbciX4CBr0NGb3v9epGTA+NB7RFl9vjpxGdHGmt8MU1yHh6SH2RurysjPzkm6PVDesmW7BdZdExRig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0c0dLb7YWXS0Skstgq6HruQeTYZIJ4lP3FfUNOOOXI8=;
 b=dD2xtYaXMomDVlumICD8m85EM3leZdivboI6MejWUCnrl+t0BEBt6NVIWrFuIsLZcAmzeCONX96HdjwKcprLrAwyAcJlCTi7j7UxS0IxObsyBneNV7QxFSCHJCL38Wztb5PoTBtJogdm6uL25LPIHr4VaZkBS8CSdECgk6459Xs=
Received: from DS7PR03CA0143.namprd03.prod.outlook.com (2603:10b6:5:3b4::28)
 by DS0PR12MB7993.namprd12.prod.outlook.com (2603:10b6:8:14b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 13 Oct
 2025 05:38:25 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:3b4:cafe::1f) by DS7PR03CA0143.outlook.office365.com
 (2603:10b6:5:3b4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.11 via Frontend Transport; Mon,
 13 Oct 2025 05:38:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 05:38:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 12 Oct
 2025 22:38:24 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 13 Oct
 2025 00:38:23 -0500
Received: from [10.252.198.192] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Oct 2025 22:38:20 -0700
Message-ID: <218d98ef-01e6-41c3-b16c-05e06fd9ff87@amd.com>
Date: Mon, 13 Oct 2025 11:08:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] KVM: x86: Add emulation support for Extented LVT
 registers
To: Naveen N Rao <naveen@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, <bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052238.209184-1-manali.shukla@amd.com>
 <xnwr5tch7yeme3feo6m4irp46ju5lu6gr4kurn6oxlgoutvabt@3k3xh2pbdbje>
 <9f2b02e2-f3b2-40aa-8e31-e940f4c2b90b@amd.com>
 <lh5f34wsxn7ntis4j6niirbe6uncz6ucvoljq3qzbxcmekowed@sm4kpwlxvnmh>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <lh5f34wsxn7ntis4j6niirbe6uncz6ucvoljq3qzbxcmekowed@sm4kpwlxvnmh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|DS0PR12MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: e82e8c0e-810b-4c07-c355-08de0a1abafe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1I3N3dScFl6ZmRaL2NQQUdobk5VdUFNRWRzdTl2WUhDbGZlZ3BhaG56ZWN0?=
 =?utf-8?B?UnQ2UFpzajJndURsRG9keU9Ca3lEUWlqcTVyZFhQZlJiQmZFTGlmbyt2Q0Z1?=
 =?utf-8?B?d3EvSjhrUGViZ0Z0ODJtK0pFbW5qV0ZuQ1NBS3FUVi9HcHloMFhIMmJXZGx3?=
 =?utf-8?B?c0U2ekExNXB2NHpQdmNta3FlZHhWVCsxRWQ3VEw4bTVRamhBVloxQ1pCZXUw?=
 =?utf-8?B?VU5IN3F5R2pDR1dpV29NVmlyK1FiaTNoWkRUanQxRVMzNndYKzVPamV1MnZD?=
 =?utf-8?B?QXlVdnprdUIvU08zUnhhWEpGUVpkdmMxc2gxRjZ0KzZON3R6YU84clBCNldX?=
 =?utf-8?B?aVdjUytvS3F2aUx3Wk1FYktDQXRBcWU4QXFLWU9jdXM2Z20xd1Vrem1Ub3h5?=
 =?utf-8?B?bXVDbFZoOENYMG5OMlhMRit6dWxjM1VBOVdJQk1FZ0EydWxWWDRZb0xZb00y?=
 =?utf-8?B?NzJHTHh3TktxSnN3YWd0NUlTMWlGZTJNYW9KbnRTMzFxdGtoSGpLWGF5SUp2?=
 =?utf-8?B?ODlSOW9qUHJVVnFSZDVnVHpoNnZuNjFGRUtiVEFCbi9DWlA3c0o1Qmtsc21R?=
 =?utf-8?B?K013dkh4bWx4RmtZRUo1aXVJa2hOSXRxZkpBVlJmZXFDOXp2Nm9LdkRVcUVH?=
 =?utf-8?B?cUtVenJ3US9qSUlWa2NPdFlBMHZjcXFqUEJPcENmY2ZxajF2YmV5SUduWTZo?=
 =?utf-8?B?SzJRdnpRNXhGd1BrbUhKOE9aWmNCeFZCNXBNU1VkTEVucGEyQS81OW01MDNV?=
 =?utf-8?B?TTRQdWlnYnpxRVpjZXRkS21sd2xnNXBWRlhvQVdCQ0JpNjhKVy9mVHFqaDFj?=
 =?utf-8?B?aFFnY0kzdDBRQjJwSFBQSUpReHN3ZWRsVjFMK3djc0RNZEgwaUVxMGJBTzdF?=
 =?utf-8?B?OUxTbXYzUG9CRkZDMjJIbnJwcm5IdE1nc0ZFeEdnUnVVc2d5b2IvT29TajFL?=
 =?utf-8?B?a2VUdlpBQUdwRE8wUGZDbjdoRFdWQWl3YVVrQlc1MDNmQXBSMlkzTlZWRGRW?=
 =?utf-8?B?Wld6VlJPQmpmTm80YUdrK0RBUU0zUWM1WjlueXRxT3U1YjJpNkwrNjV0SlRQ?=
 =?utf-8?B?NHRvYnlETFhCenVmS0daRlp3ZE9RRVpaL0t1MlhwdURKYmFTbExpWERwZnpY?=
 =?utf-8?B?T0JQRmpxM2J6OFI1SnJXQy9VZlpYRVozbTZuTDNkVGhTYnZMdVZIRVp3RGlF?=
 =?utf-8?B?M2s1N2RrWFpwZCszREpQbHVRaHZoNVZhRjJmSitPem1XQWlQbGd1aUhQSlB3?=
 =?utf-8?B?MmxQZDZkUzUwRG5DemFTYSsxWHMwcUk0S2l5b1M1a2ZiWDNIRldxYTkyUmQx?=
 =?utf-8?B?Q0xXK2M3ZnZYK0lmTm04MFhrWjVjRzJCdEszWCtITVI5elNxK2J1QTNPNkpp?=
 =?utf-8?B?NEl2V3A1ellEZ3ZvY3RTSFNkci9PWFQrclp0bFlWYW1HQ1VIbkZ6Wjhjb0NN?=
 =?utf-8?B?SkRYa0lqQ3pnNGpXZTRVYko0ZWQrWXQ4UEZvNXdXTURvZUM3cXBycEN1dGpF?=
 =?utf-8?B?RmJ0cTEwMEdHb2tZYXQ2TFJoVE5zQVRRSVJhQmdEZkNUbnFRdDZkaFpIUFNU?=
 =?utf-8?B?OCtuNFdCK1dEN1phTk1QY1lxUUE5RHFLaGlGTEt2MERjVGNNTTBodG4zUlha?=
 =?utf-8?B?RVlDWnJLWVlaTlZGVlFlRHBEdlBReTI4L3dZWndmTHd1RVBHOTZpVkRuU2I1?=
 =?utf-8?B?djI4TlRHQjFvVUJvRzhmR2hFK0I0Z3ltQXpxc0ZnR05EUTRxNkFMdkxWVHNV?=
 =?utf-8?B?RGNCRStYYWhNeDZKUU4rZFlVVjdOQ0JjKzhjQWo3eWdVOFBzVnc1RUJNdDkv?=
 =?utf-8?B?blRMSGNRbjd4T0VhUWNET3BCVUtHa3RIYmI4YTFCbUJUTDJ1a0d2WW9RcUZ3?=
 =?utf-8?B?V1d2M2wxcUU3THk4UnFmMkRDdUhEeHQ3UnIrc05VdkZMQ2lrcUJyVUtFVzlu?=
 =?utf-8?B?NnpVUGxrTjBucE5SWGhUWlByN0VISU50UFhtRk5IRlUxQURFU2lvTDl3SHRi?=
 =?utf-8?B?QUhIQysvcGY2ZnJLUG5EcFdHMUxpa2FyT3dDblJNa0p2dWJmalNFcS80U3Vm?=
 =?utf-8?B?NDh0Mk0vTEF1M0tERkRsSnpsNEhwYU14d00vSjNKUm04VllKUHdvWlI4S1lu?=
 =?utf-8?Q?rqTw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 05:38:25.5067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e82e8c0e-810b-4c07-c355-08de0a1abafe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7993

On 10/8/2025 12:30 PM, Naveen N Rao wrote:
> On Wed, Sep 17, 2025 at 06:27:02PM +0530, Manali Shukla wrote:
>> On 9/8/2025 7:11 PM, Naveen N Rao wrote:
>>> On Mon, Sep 01, 2025 at 10:52:38AM +0530, Manali Shukla wrote:
>>>> From: Santosh Shukla <santosh.shukla@amd.com>
>>>>
>>> I also forgot to add for the previous patch: the feature name needs 
>>> to be changed to reflect the true nature of the feature bit.
>>
>> Ack, I agree the feature bit name should reflect its true nature.
>> Happy to rename it. Any specific suggestion for the name?
> 
> How about X86_FEATURE_AVIC_EXTLVT? That should be sufficient to indicate 
> that this is an AVIC-specific change for the extended LVT registers.
> 
> - Naveen
> 
Sure. Will change it in V3.

-Manali

