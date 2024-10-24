Return-Path: <kvm+bounces-29606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 691009ADF64
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA7661F22260
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A981B0F28;
	Thu, 24 Oct 2024 08:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qkKfaNjR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D51AC42B;
	Thu, 24 Oct 2024 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729759454; cv=fail; b=nOQgrRLDiGusMJaQxMBdtjzfmxizxdLoVLmfosneiqq4Kt/xrQrKhoCTfs+93C056WXI2Hy/4zYHd0oN55o31Csdkq6T2ZQql/+E0KrpGohcXcBQAO6YQjpop2wmBPtjUTUPTdDWEfrTLAPH3huANuvnYfRO4yBP1VS55QzQ480=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729759454; c=relaxed/simple;
	bh=VBfaquTRqXRB7oxPpu/OTTV9nfsm2haNUI7/KwRXUKI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BCosyX5i82+XCaimG/bf/7FbzAdnyaOjHKLUlbVmooO4o7ynBMkT9ncD5SKey/3B/asYU/Zc3jscAIe66OguRze7tdeSdToAbN+HgHj9CcWcLaDgJ/A1ac9Vtsh60IICTE8Jc6wGWeuYIGEsljjzvcAfYQbPYLcQoMBCJAPHOUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qkKfaNjR; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kKSyRxpt1WpeYKs/BwDpd56V2GGm/DEod3Cs6QHJrwidFugYHGtREhIqs4XCJWURo7qr2PYAihZW5Qz5vbbSzyM8y/DiQaaFQq3JS+LMo3tlpxK0K5FSw37TOnG/x/XDOrBYU4DR/wcv3V2LgaWa7hCnGcUNgpvO0PwObxFRSAwl0DNyInlcDlneKWTvt7WfTQg4uEJWRJv/eOVTNCBGDlfJHy3kBnYE+t3iRpctcGzsD6FXrXKdH4u7n8kBzg80vsQD31YxvYY6qbMsmEM97cqAu64PdrMjLu7RdBs4kffIr8WY9P/EJtDvxfunuxI/DMVq3tpNbnDZ0eIsIquXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVwfAgnC+42kbL4YQA/zPmd5LXUHj3K7WEufod9+jIY=;
 b=ROeIknsX2dGcpFi8YcRB3D1hJ9bS6ttbbj0u+empsHK/DvBDpWYD2n4pWR6wl6NVAUSWB/KD0ygVZhT6Jn+fcdr/j+025WZlSK3W5m8/T9/4mUU5hfrOKQVyujfOV4Z3SPw9MXkDEE7KPstzLfEBb5t1DERbt/xYPYhKNcZg7nlznU+KAGOP8k8ZGI2u8NxexXpkWi0RLqwpBYGxyzU3hZshVYGV9PrT4uL1OfKdbiHF57QEgS4sW9WEAq0lAKIndvt6sQ6++Du2zRkfUVOVoy66mJFJsgei/GQ56Xx+PA7vigH2V/cf0RanOIcyvxPALWOgWnF7i08JkKP/aumsAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVwfAgnC+42kbL4YQA/zPmd5LXUHj3K7WEufod9+jIY=;
 b=qkKfaNjR7ZkJuAhdvvISRMN35UTvqe9O86vhl+qxv3IAZFbmlHDkVznlN1caQHT2jyT0rd2gOXtOyv1cbeWZV/A0x0eZc1IZea2UgbqQrdxzZe5YkHK7HOVVnGToktr9NnHNM4jCIC4S+6UcR063lUu2dnskwVXms8ScDqHrYco=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8863.namprd12.prod.outlook.com (2603:10b6:208:488::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.38; Thu, 24 Oct
 2024 08:44:09 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 08:44:09 +0000
Message-ID: <de0b0551-003d-0cc8-9015-9124c25f5d43@amd.com>
Date: Thu, 24 Oct 2024 14:14:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-6-nikunj@amd.com>
 <aff9bf82-e11e-43d9-8661-aefa328242ad@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aff9bf82-e11e-43d9-8661-aefa328242ad@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0137.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8863:EE_
X-MS-Office365-Filtering-Correlation-Id: a33cb5aa-a841-4946-acb7-08dcf4080701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWdncHVMQlNIT2JYMHdVdENtL0F2T3hSSEpqcFovMlp6ZkhrczB2ckFBS1ZD?=
 =?utf-8?B?eTBZTDRiZHlSaFdTbFUxSGVCVXNMUHoybnNFWWRReWJYbzZSdXN2TGNwRktX?=
 =?utf-8?B?RGhYc0dNbGlySVJvN3VMQmJmSGh1dzBiMGdjQ1JzNkM3MGo0K0tvOEF3cGRU?=
 =?utf-8?B?OXlieVVvYXBIZ0lVUFI5bG92clFudmhzelpxaHJ3ZldTZTNrckJxNzZNQkdU?=
 =?utf-8?B?Z0x1WU1yWlVTUEk4WnJVZTZ6SUh0U01ob0ZWOU4rb1pqNk9MbWxHMUwvamhs?=
 =?utf-8?B?Nm5PQS8wVzZwSGFXajYxaDdmelFGK2Q1RTZ6cG4zWTR6UGhnQ0txOHFiS1lO?=
 =?utf-8?B?dkRUOGdFcGwwNG9pcUQwd3JlVEVCMXlYMnpTbGNlRUJONFQ2TVpFMlNXeldi?=
 =?utf-8?B?TTBZSHZzZlBzaHpIdG5WdCs4am04RUllNXBBL1lwc05IVXpxc1QzSkZFTGoy?=
 =?utf-8?B?Z0x4UkpoQWlMTmVVTzVRdmk5bWlhNXBVOGRIdFRvZmxpVVBTTmIwZWdSUFZ0?=
 =?utf-8?B?RHV2VDVJMFdSemFlNzlRcFN6OGtHbmNoS2VuTEt6cVR6b1VqZEVkZk1WM0Fa?=
 =?utf-8?B?U055YWE2czRZVHJvZmdCazQ4VXRHN0V2ODZMUkZSMGtpcjFwV25wZjlsd3pD?=
 =?utf-8?B?bGRzcEZxM0FhdjhEdUViY3ZrSUNhT1JLcExsckVOK285cmVzVEgra3NXdnB6?=
 =?utf-8?B?SXduR2FqOWM5ZVE2WVV6N0xNSXl0K2ZSS0l6NTdmbVpZcjdKaURBc1hLZTJM?=
 =?utf-8?B?Wlh5aStVemNocDV3cWhUR1pmRHdGeTRHcngvcmlDNStDNWIyWWlLd2FBYVFh?=
 =?utf-8?B?VlAraTBNY3Y2LzlrTzRqSFZKNHNaZjhOZ0gvOXkyOThKYnRyZDVUc1NOR2dQ?=
 =?utf-8?B?S2pkVWFsc0M5T0xvVUkxNk9QVzczdkJtd3ZTR1Z2L2VIWVlKdXhwdGw2K0dQ?=
 =?utf-8?B?MnlTNDNsbHZWVS9WYXJJcnNVQ1FtdTdXUDNOK043c25WN2RFdUhIMnA5SU9D?=
 =?utf-8?B?MmRvT205MDFWZlRWMWpNQWdtc01XcGFxRlNMMnFBSjdPamJBblI0aWM5TjR2?=
 =?utf-8?B?VDFISFgyTGZndjI3NnNMSXoyWHR0NGl4blRnMzlMKzRqSmNES1owdXhGVjA5?=
 =?utf-8?B?Zk1KWVhKWUYzZ2xhUUdzUGVUTVhMV204RHRQbU1vb1N0OGhENkk2cFJWTFBX?=
 =?utf-8?B?bStZN0RRYU5Da21SajhKWW5xcVFwQXFIUWxvaWFRMEw0KzEzL1pHNmd4TGtT?=
 =?utf-8?B?eE1LOUVsY2VnVWZzN05KanBNS1o2VmxJcTgwVTJWdnJaMG9sS0hjeWtueVZo?=
 =?utf-8?B?cndWYlZaWjZJSDYwdEZGQkdVYS9oUDBWQmE0L1lTSGU2RVRRbDVubHorcHJ0?=
 =?utf-8?B?SjBub0N2UnVpTXo4cnNRakM2aC9EcmlrY29sRnk5UVJ1amdKMnVSeStsRjBM?=
 =?utf-8?B?QXMxRHppVjhjWWVjMGp0MkFKNlhwbmdXbndWdkMwYnBmeFI1ZzdyYjVOWG9o?=
 =?utf-8?B?Z1ptcUF0ck1aU0ttVXhFclc1SDhkRzJJODJWejhNbHdTTWw3OC80TUs0NU4r?=
 =?utf-8?B?U21ySWdlL1ZHSWkrME1WamhaTWxJS2hsK2Y4QmM3am1QdEJ1NVI5azdlRVA5?=
 =?utf-8?B?R09hR1BzQ3ZZT0gySm1oN3dPWjJuNFIweSt2VkRmUGRaemU5NFlkUXBLN1E0?=
 =?utf-8?B?Y2Fsb2hnZkxjMkhmOHZXOURzcW02ajRKSmxIbXVCTTEyc3VSQ2lsSFBhVGo4?=
 =?utf-8?Q?ilhvzLid4jaY6uN87LsMLx0M23SpGQCiuJpWxhA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0ZxRjcyOStOM2RIckhUM29zTUF3U29zejkxNFEzVTlEWXRldUJ2MmJBWmsx?=
 =?utf-8?B?aTBLVWQrdGJiSzc2ZjJMNXJNT0R5UUpBU20rcE5OVG81U2sxWFVkYjdWYVJL?=
 =?utf-8?B?bGFTV3N3OHFKeTZJdklZNjF1OEh1ZzJsdndwVHA4cFZRbk1BaW1WQW1ZN1lD?=
 =?utf-8?B?NTBrcmM5NEJLQklUR0o0a1J3dVJVbmxIVUxZeXdna1cwS2t2bWJsMzcxTGFO?=
 =?utf-8?B?UTJTYVFrV0xYRnA5bHd5SHRUM3dpcE1XUDdsRGp2N0RTSTlKSUVod1pzVlVo?=
 =?utf-8?B?ejZ3dDN3SjhFT3BFeDhXTHd0UC9rYUFqdno3eisrUW82NmxUWEtsYlBNU2U4?=
 =?utf-8?B?NzYrendnT3ZMWHEvWVRPZzhVSGxlMkxHUnVQZk9YSXJjQW8wWE4wdjIyRGFL?=
 =?utf-8?B?WmVzTGdObmdtckdBZGZ4eXgrU21rY3E5dUpOdjl5d0o4ZTloUmlmMXpPMjlF?=
 =?utf-8?B?bmtLVFY1MWt1MkFRY3dUTmlpZDF0aTMzanhnN1MvUDlSbUZjQStSQWNnVXds?=
 =?utf-8?B?T2s3SjlDTnlNcmxvUHRTN2o4bzZnaHpYZ1Z5cW0zdVgvTjY0ZFduRDVYL0xK?=
 =?utf-8?B?NjZmTzZCUFVYM2tRUk16RXhEWnRqanBCUDFZNjZFUlA4dFBCMTI4MkpCT0M0?=
 =?utf-8?B?Wnh6ZVRjbmRpd3hJUHNOYWJPQ3JSNGM0R0dnSnRYZEJwYk92MTJRK2c3UUt4?=
 =?utf-8?B?UVhBYzBKTkFoR3VaU3ZvZmhobkoyRGx6RDB6czBQalgzLzJpU3BueEJxS0xX?=
 =?utf-8?B?eG1UZ3hPcTRzTVREK25qdmtpSG52dk4wR3ZKQk1CcEoyTHR1QTkrdTBMOHZE?=
 =?utf-8?B?SXl3VEpFY05qSWF1N2cremFUaUwvNTluRFltYVhKS1FudzBUVExzZHBzK3Zm?=
 =?utf-8?B?SW9lWStRMDJmcE1MS0x0ZWl4dEZHQVhVV25HeXdhSkJCUVFYUFdoemdiYnVD?=
 =?utf-8?B?cHFPQm1oaklLeXFEQUJvUFJKTjU1RUVwdkNaRFJ1V0xKbkxQN3RGRzg5S09X?=
 =?utf-8?B?SktsZzN2VEdTSFB1L0JrWno5bTNIV2htSkJQaFFBcEgwVWpOMWFIYjgzL0Iv?=
 =?utf-8?B?amhnM3R2N0h5cnF6WnhRdnY2emtFOVI3OUtqVmQyMldyQ1RBeXoxY09IOHBh?=
 =?utf-8?B?N0htekJrZkd4Qms4NUF5VTA3MmM3U3ZBK1ZTVmRML3VteTAxUXBnZmNCVDdV?=
 =?utf-8?B?RTE2ckVjdG1wS0UvOGhYb1ZoaUlpQnpTRERpQlNTY3kwYTJ4TlpMdWFjenFi?=
 =?utf-8?B?MEIzL3BaZ29yamV2MS9VSlM5a1l3eTFRRFVucFpYaUFrRHpaSWdNMCtaSGVw?=
 =?utf-8?B?WmYweUQ0ZUozMGhwZFMvWDYzSHNoM3dxMWkrWmNDWFkyR3dDM2svRkVJZnpK?=
 =?utf-8?B?dUhWRVZFSFczaUVxNFI1Q2VhVTdKVHJVaFd3NEdyYnZDb2FGTkdzODRld3Qx?=
 =?utf-8?B?dU9ndkFCeDZqVHRLdkdSUVZ3VGl0a0tFbjRnRWRaYytzNHg2K0RYWjlKZHFi?=
 =?utf-8?B?cFMzTGY1cnBQSzBaNjI2QXBRMUt3bUphUDUyK1lYRnRNbVZTYnl2MU5MTG1P?=
 =?utf-8?B?eXFjT0ZramlDUGJHa3FPbkU4S1p2a0x4Z1l5RmIzR0cyK1ExTUJ0NWFxYjlH?=
 =?utf-8?B?RXdBZFBJR0tjYnEzTlo0bnlMRllpZjR4MXFsZldXVkV3MUMwVXBkOURLS2ti?=
 =?utf-8?B?TWJydHlKYTRKWlhOdWlnQXExRjM0YXVmSHEyd2l5UzBmaTcrVkZQME5QMStN?=
 =?utf-8?B?K0s2Qlc1RUxNQ3VHVjYvS3NUUTBDRU1yeUtxUzRUSmsvUlk4S3d2K1VwTXNG?=
 =?utf-8?B?N2FmVmo0amd1RVQvV1h2ZnA5MXhFRXhwRkJDUVBMQStGZDRoYTdPQWR4akta?=
 =?utf-8?B?TndUcnNVZjdvOTFxRjFMLzRQQmFVdVA0d1loYm9MK01wVVlqQ0k2aEc1b2hj?=
 =?utf-8?B?ekdFYWV4Ykt3dzlzc1FEcnlWMFhyWTNCaEtwbDBaREhreWp0UG1Jd21aQ3Ry?=
 =?utf-8?B?d1BKajU5blB1RWJHTzd2MkxaV3ZTNk0vcWppWE1IK3Y1OENkTnR6NHRRcHZ5?=
 =?utf-8?B?ZDBzWEhBT3JkWXh0bEdtVUFhYnpNTEovYXVwTmdPSTBLNnBCOENacWJoRVow?=
 =?utf-8?Q?7+Mw9NtOQH4nD7mNr+ZgrBXPW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33cb5aa-a841-4946-acb7-08dcf4080701
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 08:44:09.7727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kyPruvIGS/1fj3PWathmH2Za+SptV/IRQH5wrHLmE4zvSY+NQdMSNRRO8wEOPnnAna/8ouH4IUcXh06uZ5dkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8863



On 10/24/2024 1:26 PM, Xiaoyao Li wrote:
> On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
>> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
>> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
>> are being intercepted. If this should occur and Secure TSC is enabled,
>> terminate guest execution.
> 
> There is another option to ignore the interception and just return back to
> guest execution. 

That is not correct, RDTSC/RDTSCP should return the timestamp counter value
computed using the GUEST_TSC_SCALE and GUEST_TSC_OFFSET part of VMSA.
 
> I think it better to add some justification on why make it> fatal and terminate the guest is better than ignoring the interception.

How about the below updated commit message:

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
terminate guest execution as the guest cannot rely on the TSC value provided 
by the hypervisor.

Regards
Nikunj

