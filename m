Return-Path: <kvm+bounces-58981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B960BA8E6C
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AC2D1C2535
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1212FBDEB;
	Mon, 29 Sep 2025 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1toDWbJw"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AF2C3261
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759142134; cv=fail; b=L/Ee9gbllJ4aU74imucvRdeQDlcvKEUMsSjKd+dcZAMDV8OMN0QGlONek3meROQ9OJYPYlJR0ONMyfJAykv9agPaOS7XsiRco9IOKznVptx/ThLo88oc9FzgWIOhAa6Yb+KPrE+ea4PlzUUdqu3Y8LJBmGYVw8epnHdskSmPNpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759142134; c=relaxed/simple;
	bh=cIGNpvTGyeZru6mpD/iI0iXc+QWODXOL9cyDqHFGT0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MSALxzDHVW+wOhVb438kbewAEzjZRZD7KDQwSwL0A8tm8P/hFYH+m/KjclawxuHAmn8AMN2mgIhGhuh0rGjjVdqyRkOpy11SZqAoDEiLzhbAV10bZfWkmVSlviq09VlQfos3wEbn6wumQLRR4GnpU4pHo3qXGwvftQ7ec58TmhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1toDWbJw; arc=fail smtp.client-ip=52.101.62.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qy74SknVx67sLujRbTUVBikB9tY3iaPFkuyYf13TD57lmDNBjwr0bRlzjZ/l5w0yguvjjjfQwVVjYBhgOTFhduNFwJjAqCk7pnfea4Lg+3utJGDNV2bmt7HDDowU3uI58YZZyPKRU/aw8cF2/ewC3fzfSwJvi5Lbeumy8qzadtRmhsmmhtYmJXf3obg891pwyseruMIp502/GzRIQzOCl5JNLDvIclYxQ6rSgH8EAyISpgfsos7k8OobPoVoCRbnrY5b7UIsMgx9yZlxZsJAgq2VpR5bKIvg532lezkmkICcmBwPvUDIY+YMWixg/VCr8Xi3jOFAWm1ZJZpj27UGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdl3HVo4keyNPXnsJ9nhZwb65jSm2+npoddcAC46Guw=;
 b=dHayMzm+HHA+lntLgHj+3rTEHeTqgFCiy7vbJZI5J85rfjzrMhWHL5bM95vYTotBj+Gij3vM8dJZjEtHcOd3NX2YqMqc2qWVOGhlrRCcJuN47tZCQV225TwTC204tIVZJdUbRInFugBZKkYScocL2o8EB3bC8CzRsC8rvO9KHUyAlEhpeS8kQywK1R0371/7/KK7Nhsz9Mi63KFLNiFoRUqGY/I4tDQYv6ZUYwTV8kCL6RGv4tAquaA6nAHeNuQWn3kNYllxRxQj4rzTFkQp7W2lUu7NMWafvcRJE7jFMXy+nXSVQpvQwrV/5OJRHQsdjcCk1K35wfxB5GMspJfF0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdl3HVo4keyNPXnsJ9nhZwb65jSm2+npoddcAC46Guw=;
 b=1toDWbJw3Zy98mq/MF9Ym4jhS5AKqq0hf4zC8NT0ntEdpzz8YR00Tm80jp/uFvwOJHayj+nxv2IDQl7XUFR/hIjEmq5sy1F/3qz/aCmSz1/gff4TCezDWwK7gmx1jRTtL0sJY6dw7d/d3Gpmec6KBLSmFYZaRJ0+OdmerP3ICBU=
Received: from DS7PR03CA0225.namprd03.prod.outlook.com (2603:10b6:5:3ba::20)
 by SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 10:35:29 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:5:3ba:cafe::b9) by DS7PR03CA0225.outlook.office365.com
 (2603:10b6:5:3ba::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.15 via Frontend Transport; Mon,
 29 Sep 2025 10:35:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Mon, 29 Sep 2025 10:35:29 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 29 Sep
 2025 03:35:28 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 29 Sep
 2025 05:35:28 -0500
Received: from [10.252.207.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 29 Sep 2025 03:35:25 -0700
Message-ID: <d3d1a8ae-3cc7-4a91-99b0-1fda70a79542@amd.com>
Date: Mon, 29 Sep 2025 16:05:24 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250925101052.1868431-1-nikunj@amd.com>
 <20250925101052.1868431-6-nikunj@amd.com>
 <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
 <2b2ebc13-e4cd-4a05-98bf-8ca3959fb138@amd.com>
 <0d1baaecc56de2b77f82ab3af9c75a12be91d6b2.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <0d1baaecc56de2b77f82ab3af9c75a12be91d6b2.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: 6504b6f3-bc68-4970-09a9-08ddff43e8dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmtUTjdKcHFVUDcwNW9xOHBGNHBJV0xTVStHc1NqREYxemFLTDRtdjV6SUFG?=
 =?utf-8?B?dFBvRHVKWGZRSithQXZDMTByOUZlSnVOZ0NKRFluWDZ2TzNpK05jZlpKZHBF?=
 =?utf-8?B?ZVBtTG1tN000cFRDU2pBL2svUXRVOFh4bGp3YVVRRlM0NHl2YkdTUmtDQzdr?=
 =?utf-8?B?OU9DaHlqUE1jL1NKOUY2clVVZkJBNDhMazBmWk1pRlB6SVNablVXd1ZTTXlu?=
 =?utf-8?B?K2V1T0pTSjg0YUtMQnBVR0pmQzhCKzNoL3BpUWVLam9IZWFHa0w3VHNkR1BV?=
 =?utf-8?B?Tnh0OHRpWSs3YklMZFZWa3JMWms2VHdiQXNGZGxmMjgxcVhXMjdTQ2lMVXJp?=
 =?utf-8?B?UUVSOUhFcUV5THBuQWhyYlRYWTRIU3RBdkJmWDhOU0V4Y1k4dDVQdzlRa2ky?=
 =?utf-8?B?TEhhckxIUThhd1RRVld3OVFJWXFaaTFvZEpPcDZ0YklMbDZIdXRmcktLL21Z?=
 =?utf-8?B?SmxDSGhBeENkb09YbEJ3U3RiK2k2aGhuZlNlS2N6OGt5NWR3QmJadlg0anAv?=
 =?utf-8?B?ZEhaeUpzem5UYXMwRjZKQUI2MGZnc1czQmtDSWU1ZEdmaXBmSHM5RTlKYjRu?=
 =?utf-8?B?THZrSi93eDN5TFJOdmpGTlVGVlBiRjN0bGcxOTlSK3I4Yzdjck5RSVVKYmM5?=
 =?utf-8?B?WFVKSFFsMjNOTW5HNmRKL3lNRVlnRW9KQk5mcGlmOTNydDNIYW5kUE9Bd2JB?=
 =?utf-8?B?SmNEa01pbklzbEk2cFVDQldIY05uei92OWRlYkEvVG1qSUpEdGVtT00raFZK?=
 =?utf-8?B?aTF0UkEvR1E0dXllSkxRZTFlQ1RWZndrZ2hXbUhOeDhiUEpxSTl1eWR6czdR?=
 =?utf-8?B?eUpPZVFRK3hCVVVzSGR3SUlJemF6RHltTS84a2xwZ3FiOFZROHpvQjVlN1BN?=
 =?utf-8?B?NFNNbEF5aXdKV3JTdHAxd0xHZUFvRklKdEt5NThUUy8rajNLZDcxM09DNzVa?=
 =?utf-8?B?T1lqeFZmNDNhSW1yNUE4ZWhPQlgvQzhBTnFHMGFyeDQ2UWgxaUxnSkcvbWxU?=
 =?utf-8?B?MTEreEd4M0ZaRFBkK1YyYWNVYXFGMTZBNFJxV2gxV0hXelB3MGpvdUk5d1RV?=
 =?utf-8?B?TjF4TEpMMjJ6Vjl5eWttZnpXaVR1enZFN0NKcXBEbEdaQkpHRW0wN1hHNkRw?=
 =?utf-8?B?Tk9NNTQ3TTVOT1JhOERQcEVIdmhSVDBCMlN6eFZWaG8zRUlvTTM0K24wSGh2?=
 =?utf-8?B?SDczWFJCMkZ5d1VUYmpENUZYaFp5SkxacDJZSVQzR3RxOGJsalBkSGpMZTkx?=
 =?utf-8?B?Ny9zMko0SXZSVnVxQzRqbmJrbWpFcCtOM0NtSzRUeW8xWXNkdmpVRVNNV1Nl?=
 =?utf-8?B?Z3o3R1pYK0lGZVNWV3NLYWUyQTZjc09PQ1gzY3hkSzNnanUwSC9iMTBFR0Nh?=
 =?utf-8?B?bk1iSUFZZkdiQmNqMWYwZUp5OHlENWNlMTZYNndCNklnVXFJOFBWYnZBTEor?=
 =?utf-8?B?ZDIwS0VMVnh2MGZxUEJaRmtQbWFNMmtXVm9vNUdxM0FTSlAvRllNMGcyZ2p1?=
 =?utf-8?B?V1lhN2JMaGRPTHF1ZjkweFo2SnlTOWwzU3Y0NW43SWYraUI1NmhaVUUrZDcx?=
 =?utf-8?B?a2I0RDBhb1hDYTI4MEcyUElpa2QxTGZMRHhhYldWaklwbVRqMEdjVEkrVW8z?=
 =?utf-8?B?ODlUZkdMVFRobkFJSU90VmVUeE9UcnM0UmQrRWNwWHZEMXZRblFqMGFrRThN?=
 =?utf-8?B?d0g1Tk9xdy9FVVVCd2NLZHE5WVIvVlVlczBadUtIY3ZJd3hwdEwvWk9yanVl?=
 =?utf-8?B?K0hFY0J5UTVMOVV2dDRRcGNhaVVOMnZjQWFHMTFqUWNrVHNleTg4M1RBQysv?=
 =?utf-8?B?a0JRekQ4S3lBVnpXdm9SRUE1ckprLzJ5V0FBelhVTTlRekpXNzltdFFXTW4z?=
 =?utf-8?B?VGtBVG8vOTgwNUlva0poNDdYc044amlsSzdnMGRjVkxXYms5MnFMeW9ka1lk?=
 =?utf-8?B?dnRJOUo4Qk15dFY5b3pqZ25zMld6Wnh4TlhFZU0xQUZ3TTVkV1Z5MlgvUXo1?=
 =?utf-8?B?U1BpMVJJWDd6U2RqV09OTjl6cjVtTkJMM1IxaUg2RDBVcXJJSk9vM3JIMTZS?=
 =?utf-8?B?NUZ3WWVabG5ZNmJCcUg3Ny8wRURWMHR4WWNkcmFISGpIWGR0b1M1cFprQStS?=
 =?utf-8?Q?Kbj4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 10:35:29.0356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6504b6f3-bc68-4970-09a9-08ddff43e8dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139



On 9/29/2025 4:00 PM, Huang, Kai wrote:
>>
>> I tested the above patch and it needed few SVM and x86 changes, here is a
>> diff on top of your patch that works on SVM:
> 
> Ah thanks!  I did build test but not sure why I missed some changes.
> 
> [...]
> 
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -51,6 +51,7 @@ extern bool intercept_smi;
>>  extern bool x2avic_enabled;
>>  extern bool vnmi;
>>  extern int lbrv;
>> +extern bool __read_mostly enable_pml;
> 
> I think this could be in <asm/kvm_host.h>, similar to enable_apicv?
> 
> VMX code needs it too.

Sure, will move it there.

Regards
Nikunj


