Return-Path: <kvm+bounces-20301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC39912CF6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 20:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E128F1C23B77
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B97179204;
	Fri, 21 Jun 2024 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g534TUui"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE954FB5;
	Fri, 21 Jun 2024 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718993235; cv=fail; b=N9rec7fUyVSWDj+dElk3UgMazrHidNVhf3NEPTePj1RpPDmsoUZziCKZr/OgsryQSrPy0mjQbVARQppJQVKy5q2RFvwtlFLzJ1omOatSe/MBe9do4qYX/CyVhBp1zXuBLYTaUtQ+cU7SuLjGmtyolNbP8V+z0jyYFUQr81L3fU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718993235; c=relaxed/simple;
	bh=ANzGlqWQYa4U6VYaaUxfpCB+4AJ3bnxO1SYhGYwbq0w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cZKqYb+uasX3G0PsZwJuxwd2zMEe37Xe46mwhQqVsGrCC366qp+KuWXLWB309aF5s9P/+X8o0tTeutjj1MU0NQQHdKV5po17gAKW6mezf+be0oUlUqbyljSo2BCvmDv9qTBnMR+AjyvgiRnH0Yfcv3B/5UdM20/UCWfnGgrgt3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g534TUui; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fG73+VGX3yTMyoNtdB1jUB4A/v/OJgYCBoXXz4WgP5fRpONC0XdGPZEXfawEnqOjBa99y6NFrF9mHfDp7IWlwY1MgCfoS/0lqVtMtTZOb/MPp2iGk6ICyptHaxo0lG0ir8Y+/+3fzKzggB579DnsnSchsiD0x3C4ZbNVVjA9VLDKsRn5qNV7g7W9ssconRC1xGqcNqeNB8AQIPz5DZ8kOczDU/1pjUxtu5eBEl43/+qGmhzC4QENoXqQ95pzZrK8bakA2gstqATLRlOjbSSkiF5cR5K4IgJtKvCRZUhasiHhjAIEopzjHZwk7eItPk3QrcA5ZpI2C6B96oi5y9FOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bcWIzqx9hx0zee9ozenJULif9KZN+aRUoxFLPk8izE=;
 b=UV3VJPBpjNQ8PVz/DL9Wk5/KwRjJ66W/1ZPE1Cm3c3mnx6KKgq4jfMMAnnTQIo9zrYVkCPUJktW0HTAEinpFmPgb9FeIkx6A+obWiIhEOBib2HmxrRuio2UOvXyiknIvN+Yt1TkTLBCG9Cs4B8fQzVTkw04w7zFz5VjeVzGQ83be9jvfEXGJO+J6PzzINbItSqHaYEMdtPZsQAl9gK8onolWGN17zlltT2cOL+80MxwDiAXHU/stYwhCuFlH2U6769m0ZpC0R635Yhy3nYQhWoJKe7HFluZs2dNpAd2UJTP+yfJhw34jOgy+I/ZwrLCCk0Grl9mJzB0MwCeVP9yRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bcWIzqx9hx0zee9ozenJULif9KZN+aRUoxFLPk8izE=;
 b=g534TUuiLZuKgYORLptEiW+14GAA3lvNMLhE2Uk6gdETE+B70bLcC2LvOmfeRj1MmTk0Dzs0vJT6SiRNAnP4c05daJG24u6PLvkPKlkdqvGdAKapRLA+5lyFuo4tgxEHHLBVe1wFtYwrivlS0aa0Auv6+trtrjhPg8BRZ2pFctg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.22; Fri, 21 Jun
 2024 18:07:10 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 18:07:10 +0000
Message-ID: <935fd457-74d3-cbf4-d532-718fc17f78ed@amd.com>
Date: Fri, 21 Jun 2024 13:07:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 2/5] x86/sev: Move sev_guest.h into common SEV header
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 nikunj.dadhania@amd.com
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de, pgonda@google.com,
 ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-3-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240621134041.3170480-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0058.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::9) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: 056fa72d-57ca-40b9-8667-08dc921cf824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmZpbGdWakNXall3b0hrYU53L1o4VnZVMzgyZVdKUkFhbXVsYjVUVzZIZEo5?=
 =?utf-8?B?RTJ3WlZoTzZBeTVRWnRjTEUrQUZQTWo0V2ZRS3dtT1RoenRnYlVMQ2tMYW9S?=
 =?utf-8?B?WUQrUUlVcURUOGZ5bm5aTFc5SE9qOHJ4YWFOYm1uNFFkSTcxdERHT1orRHVY?=
 =?utf-8?B?c2VCMXJrUkZ5OW13QW4xOXk1MHo3WmlqRTV3KzRqSHFObkJWZVUxSkx4T1dS?=
 =?utf-8?B?b0t0L0lhZHdtM2puOVBTTkMydU9lZUdoeXZjellDc0REV3lDNTRVdDdGWjg4?=
 =?utf-8?B?SitBNi80SkdsNWE1YW5HS0sxeXd5dEd2cnorbGJoOHRWN3pLeXNOcU4zNWVC?=
 =?utf-8?B?bG5mTVk1SHhPdVhTMDg1WldEazhTUloybjhVQzIyOGJlZGRXdDBkaEpENzAv?=
 =?utf-8?B?bEJ4dEVMdmZOTXB6eDg5YXJiZERFK1ZVbUFTbDVsRnhyQnNOTDVJNVRFeDBw?=
 =?utf-8?B?R1dZVUkybTNDdmIxbjJzZFpRamRiR1EwZFE5Z0NwYWpadHkwbVN5eFNGTWh4?=
 =?utf-8?B?ZHcreDJBUkR3WU9hZGNaQjRhRVRsOWpncnpDRHJGZ2QydThRc0lPajN4eDZs?=
 =?utf-8?B?a3IzdTBXbm5DMC8wTENHVzZkT3lqWmI3a1I3Z1J2U2IxNVFYTzlHWWcvbFR4?=
 =?utf-8?B?MmNqNllvaXR1RHZvWDAyU3VZdVl0eVRqVGVCTit4algrb3ZWQ1VmYUVlb3Mv?=
 =?utf-8?B?T0ZVU2tSWW9rUWxFM1lCN0hPMk1xMnFpK3FpSGhNa0hKOVJPVDQ5SEFrZWp0?=
 =?utf-8?B?MXRIZ3VCR3J0ZVBGWEIwYUd4Lzd4aTRVTzhWR01LbFBDcksvMzZnOENKYWFx?=
 =?utf-8?B?UUw3enc1ekowR2RQNEp2dzlEZzRjbGhReVVSMVlBcUJRVFh0Q24vY3hCR3F2?=
 =?utf-8?B?M3ZBemhtN1JWQXZFOHVTTXVKOWxKTFBjdXlJakUyWVhVc1R1Ykc5RnlESGNW?=
 =?utf-8?B?ZkJNbTJTYmlvVmJNbXpvS1ZDcit0NEZadU8vMnEzMnMvYWR0R2E2OWtUMWhT?=
 =?utf-8?B?aTh4aytYR0Q2ZGxlUEtUbDNkU3JqOG9mamt2S0tZeUhCNHg4OVgrMWhvZ3VE?=
 =?utf-8?B?bTlxOVA2K3pZb2VGbHQ0M045Ujg3TkRvcGJJYlBLdG1NYi9od0piVEVaNkZs?=
 =?utf-8?B?b1pUUDNlZTYvRFV0MlhRd3ZMNlRNY0Zya1NBN0FjVWM2MFJZRGdjaG5GUVVi?=
 =?utf-8?B?aHBJR3E1ZWdoTytjQ1VZdndsV1FtaVVqeHYrWnlRTGFJSllmNDFLK0txZTFT?=
 =?utf-8?B?U0JPUnJqcVRINzA5cTVxRGJyZGFicURHSDNKZFZaUDhKY1NkRks5M3MxZGFG?=
 =?utf-8?B?WFI2TkhidWR5UWFCNWxhNUlST0R6SWVHQTNKZVQwaUQxRTdDM1M0UFdsU3lO?=
 =?utf-8?B?RnZkYy81MFJWSGZYSFJFTzhGN1RJb1BmdTlJODNnS2RCTUJoU0ZwVTQ0UHRk?=
 =?utf-8?B?RVVZZ3BSVlBaeGZxUE94WFRVb1hyVlVaRWs4cjlSQ2hxWlhUeXlaNzJQQWEz?=
 =?utf-8?B?SFNUQ0VaUXQ4clRCcFo5dVJsYnBpRHBqMmswSjh6SVZPYzBRY0t6UFozc0JL?=
 =?utf-8?B?TzFCQVRTbEh6aDdFcWlFdDZpSTdyVUR0bjh4b2l0SUJtL1RCTlZDR1lTNWFh?=
 =?utf-8?B?d0VxSzhqSkw2K1N6WGVCdzdlWkhFZitad0RsMkliSlRQYlh2b3FmNWQ4bit5?=
 =?utf-8?Q?FL5C142U9+eQGXE3aZDo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGdLaWpwMzFvOXpteTdoUWpyNFF0N3hPQm5RRTgwQXQyN1RHY2hlV3hXbDRm?=
 =?utf-8?B?eWZhQjh6WVBKMU9vZCtadG9zL3NyazRraVNtbU1KOFZQK3lqOVIwUTJOSm5W?=
 =?utf-8?B?THZoTmU1bkpiMmFPQnJJTHBibjZNQWtTNDh0Y0JFUXEzZXBwQXdHekRHQXVS?=
 =?utf-8?B?a2ZPdW50WTU5NGxiNUo1Y3FldzE4SUx2OHFUTXQxWG1lVGUyRGoySDBvU09N?=
 =?utf-8?B?c2dmKy8vams5Y1Nxb1hUUjVkbW5UUDFGWFc4czBORVFuUVJWL1pjdzFFSXBi?=
 =?utf-8?B?VzlEd1drU2RMaDdLcVpTSHJsSUpUblhidG14cEM4RXBpVnhNMUlsdldTWGgx?=
 =?utf-8?B?Vzh6NnRSV2NlN244YnVCUHlIYkNKV0c1cHF5MHgxaTN4RDEzZUR5ZE04alNE?=
 =?utf-8?B?ODZkSE00MWJVbWNQRUF5YisvK3dXNVJYa2VHMU01Rko5UERlN3BDOExUSmRp?=
 =?utf-8?B?SE1zMmdjKzFaNEVGdDcyMzRCTml4endpQlMwdzgyanl0QUt3T1hqREhPaEU1?=
 =?utf-8?B?M28vK256LzUrZFBZTXJXL0pJRjVOVHNIeGxhalBzcWRBcTlRR0pKSGF3amds?=
 =?utf-8?B?aGFOcnV1OXhyYjdLRmlENzl1dWN2N3dXdnpLWE1QTTI4NG9RQUcvNWRWK1lU?=
 =?utf-8?B?RTF0WDVHU3hUVlluZFdCVFlnck5TWmJBWUlQZzJscEJEdjNtMjhNd2ZGYmlk?=
 =?utf-8?B?ZElnbXZkQTdTaXI1SEV1K0FRZTdvSVJmRDlNK1VxaVpaeGxCNjZLUFJyNWVu?=
 =?utf-8?B?cHpxanR6Y0VsTjM5VGo5MEN6cFZ4MmErcmg5K2c2ajJkSFl2cWlIN1hIb1NQ?=
 =?utf-8?B?QzZoZTluelBVR0FQVHptM1BMelhyOXNYOElMYjNmeGJDR1VoSERwWjRYWVZT?=
 =?utf-8?B?eW42K3RJS2lRY09uQlVDVlhNV1hUZitqMjA5VERGaytvMFgvUkxLRTI0U1B2?=
 =?utf-8?B?S25iUEx4Y25oZ1NCQWxwVFRGRkpvVmdUaWNoKzh2MDVCZm5ZelBOUmsvK2hD?=
 =?utf-8?B?TDQvaHRTYlZ2d0t3MVlISVlkNjJMeGw4ampyblU1c3Y2SkdlbXA3QW1QZUpD?=
 =?utf-8?B?RnVXU2RKTHhYcytQaCtMRVd5alR5cW4xUWVzdmV4R2RFRGphOC9lSFlhTnJM?=
 =?utf-8?B?ME83bmNFMUlhZ3NTSXF6eEN4UnJKRjdrMm05Qm8zdUlBUHVQRWw1QUl4SXFY?=
 =?utf-8?B?a3hlTDRSUGlsRGRTS2J0U2pQa1JsSFRjMjZOdTdBMlBWNlVEZmxtdzVhbE5i?=
 =?utf-8?B?TXNXNVlJdk50ZGdmZzIwL3NRVFROMXgvdTRndjNSVGIrZXpTS2c3U2w5bTJr?=
 =?utf-8?B?Qm8vWXVXZzkzaFZRQzFBb2J2dS9VSDlHdVVhRlpGNkliQVlOZlYzWmphOVRx?=
 =?utf-8?B?UTBzOElEVlVSYk9NNUJWcVlKWTJXZ1NjRmJJNmVhQ0lWY1g5eG9oZlduc3hB?=
 =?utf-8?B?MmhPRUtaYm1na3BQdEswMzdhZUpWQ0pTOEkwVnJ2MUpnUlB0QlRDaVhaU1pE?=
 =?utf-8?B?ck95aDlPUm4xVXIwRGp2NWxDS2YxR0JSRkR2K1R6dWtyL2RTejBHbFlNNjNP?=
 =?utf-8?B?V25tMzRlVzh6bCtvOS9JYTk2SlB2L0t6UU9iNWtsc2E4cWdiWGpzZFo0d3FF?=
 =?utf-8?B?YnJkK0thTTFIVEJWRWhJNmlKMzlmK3JwOVh5d0xIY044YUI4VktIWHBEQnlq?=
 =?utf-8?B?VHROTHdXa2dTNm5UL3hjbnVXRm9xSkxSU0NvNGYrVUQ0UXE5c1NQWVU2VGha?=
 =?utf-8?B?cmdtOFJ4SklYY2NsWGtJdzVzSGYxZVU1K25QY09UMVgvQVhYL3N0QjNiRGhl?=
 =?utf-8?B?dWFvMkZnSkh0M1BGRU9odFJFMHdUT2JyK04vcWJ4NzZmWkp4S1JZQXhiOHM3?=
 =?utf-8?B?cVJTZFYrUlRiOU1ObXRCbWRPcjhiS0V5REQvV3lWMm54UDhINFNuYXJXSHcw?=
 =?utf-8?B?WkREOWpkLzVyS1F6UWhIZXRLUjk1YWtoUDNPdlFENzBCT0hKUldXVXBFZG9W?=
 =?utf-8?B?R0FZbHdVaDloZkowRjM4ckJtUmFZTkxQNXVmWWhIRE1xSDdRdnpSTHg0Skho?=
 =?utf-8?B?Y3lNZEJGQzg1ajMxcTVRRk9XcWphWVplUUlXVVZZYXZDa2ZYbldQY1BVcWZQ?=
 =?utf-8?Q?lHiOZN9lBha5CjGAEF1YRgYI6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056fa72d-57ca-40b9-8667-08dc921cf824
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 18:07:10.1108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Os28+9esxsqT4IjPDGG8KXO6WKDg70CySLAovKGNeSLG0y2V2qtyIcCmzk30btv3wRQJ+Dc4/kgSHHY/2/JYFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292



On 6/21/24 08:40, Michael Roth wrote:
> sev_guest.h currently contains various definitions relating to the
> format of SNP_GUEST_REQUEST commands to SNP firmware. Currently only the
> sev-guest driver makes use of them, but when the KVM side of this is
> implemented there's a need to parse the SNP_GUEST_REQUEST header to
> determine whether additional information needs to be provided to the
> guest. Prepare for this by moving those definitions to a common header
> that's shared by host/guest code so that KVM can also make use of them.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Nikunj does something similar in his Secure TSC patches. So depending on
which series goes in first...

Thanks,
Tom

> ---
>  arch/x86/include/asm/sev.h              | 48 +++++++++++++++++++
>  drivers/virt/coco/sev-guest/sev-guest.c |  2 -
>  drivers/virt/coco/sev-guest/sev-guest.h | 63 -------------------------
>  3 files changed, 48 insertions(+), 65 deletions(-)
>  delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 1936f37e3371..72f9ba3a2fee 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -119,6 +119,54 @@ struct snp_req_data {
>  	unsigned int data_npages;
>  };
>  
> +#define MAX_AUTHTAG_LEN		32
> +
> +/* See SNP spec SNP_GUEST_REQUEST section for the structure */
> +enum msg_type {
> +	SNP_MSG_TYPE_INVALID = 0,
> +	SNP_MSG_CPUID_REQ,
> +	SNP_MSG_CPUID_RSP,
> +	SNP_MSG_KEY_REQ,
> +	SNP_MSG_KEY_RSP,
> +	SNP_MSG_REPORT_REQ,
> +	SNP_MSG_REPORT_RSP,
> +	SNP_MSG_EXPORT_REQ,
> +	SNP_MSG_EXPORT_RSP,
> +	SNP_MSG_IMPORT_REQ,
> +	SNP_MSG_IMPORT_RSP,
> +	SNP_MSG_ABSORB_REQ,
> +	SNP_MSG_ABSORB_RSP,
> +	SNP_MSG_VMRK_REQ,
> +	SNP_MSG_VMRK_RSP,
> +
> +	SNP_MSG_TYPE_MAX
> +};
> +
> +enum aead_algo {
> +	SNP_AEAD_INVALID,
> +	SNP_AEAD_AES_256_GCM,
> +};
> +
> +struct snp_guest_msg_hdr {
> +	u8 authtag[MAX_AUTHTAG_LEN];
> +	u64 msg_seqno;
> +	u8 rsvd1[8];
> +	u8 algo;
> +	u8 hdr_version;
> +	u16 hdr_sz;
> +	u8 msg_type;
> +	u8 msg_version;
> +	u16 msg_sz;
> +	u32 rsvd2;
> +	u8 msg_vmpck;
> +	u8 rsvd3[35];
> +} __packed;
> +
> +struct snp_guest_msg {
> +	struct snp_guest_msg_hdr hdr;
> +	u8 payload[4000];
> +} __packed;
> +
>  struct sev_guest_platform_data {
>  	u64 secrets_gpa;
>  };
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 654290a8e1ba..f0ea26f18cbf 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -29,8 +29,6 @@
>  #include <asm/svm.h>
>  #include <asm/sev.h>
>  
> -#include "sev-guest.h"
> -
>  #define DEVICE_NAME	"sev-guest"
>  #define AAD_LEN		48
>  #define MSG_HDR_VER	1
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
> deleted file mode 100644
> index 21bda26fdb95..000000000000
> --- a/drivers/virt/coco/sev-guest/sev-guest.h
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * Copyright (C) 2021 Advanced Micro Devices, Inc.
> - *
> - * Author: Brijesh Singh <brijesh.singh@amd.com>
> - *
> - * SEV-SNP API spec is available at https://developer.amd.com/sev
> - */
> -
> -#ifndef __VIRT_SEVGUEST_H__
> -#define __VIRT_SEVGUEST_H__
> -
> -#include <linux/types.h>
> -
> -#define MAX_AUTHTAG_LEN		32
> -
> -/* See SNP spec SNP_GUEST_REQUEST section for the structure */
> -enum msg_type {
> -	SNP_MSG_TYPE_INVALID = 0,
> -	SNP_MSG_CPUID_REQ,
> -	SNP_MSG_CPUID_RSP,
> -	SNP_MSG_KEY_REQ,
> -	SNP_MSG_KEY_RSP,
> -	SNP_MSG_REPORT_REQ,
> -	SNP_MSG_REPORT_RSP,
> -	SNP_MSG_EXPORT_REQ,
> -	SNP_MSG_EXPORT_RSP,
> -	SNP_MSG_IMPORT_REQ,
> -	SNP_MSG_IMPORT_RSP,
> -	SNP_MSG_ABSORB_REQ,
> -	SNP_MSG_ABSORB_RSP,
> -	SNP_MSG_VMRK_REQ,
> -	SNP_MSG_VMRK_RSP,
> -
> -	SNP_MSG_TYPE_MAX
> -};
> -
> -enum aead_algo {
> -	SNP_AEAD_INVALID,
> -	SNP_AEAD_AES_256_GCM,
> -};
> -
> -struct snp_guest_msg_hdr {
> -	u8 authtag[MAX_AUTHTAG_LEN];
> -	u64 msg_seqno;
> -	u8 rsvd1[8];
> -	u8 algo;
> -	u8 hdr_version;
> -	u16 hdr_sz;
> -	u8 msg_type;
> -	u8 msg_version;
> -	u16 msg_sz;
> -	u32 rsvd2;
> -	u8 msg_vmpck;
> -	u8 rsvd3[35];
> -} __packed;
> -
> -struct snp_guest_msg {
> -	struct snp_guest_msg_hdr hdr;
> -	u8 payload[4000];
> -} __packed;
> -
> -#endif /* __VIRT_SEVGUEST_H__ */

