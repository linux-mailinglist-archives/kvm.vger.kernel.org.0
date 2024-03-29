Return-Path: <kvm+bounces-13098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A61989211A
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 17:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AABEB2B866
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595AF14A4CD;
	Fri, 29 Mar 2024 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p1YZGCxV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2105.outbound.protection.outlook.com [40.107.223.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BC14287;
	Fri, 29 Mar 2024 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711723612; cv=fail; b=bGeDh0xxveirsWjNrjqJzpm8OEg4gNImK1/u3/ElrjTyZwi9uBeGZxyGMggMed1DXIYF9wFO90UtchdCqN+jfOtbDFbDDTckGtyJtIQLBcaIlTjXi64kxqAQASIonMVoi9bv/22eNcXkRinIrrVTtZFoz0XRWICX90DLFJlIubc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711723612; c=relaxed/simple;
	bh=oj11SLw3B4LIgevLJVAARGDjhGA4wBTXt14yPFf3xHs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rZcFoWeNSsZlmeSOann+dhoEBZPbd+oL/kxshKeNCUJIvxyI4LEeKgvVDVbsNLfp+vIc31E114j4xS0jk8Ngbknbn+IxiRTPsrTKS/jJB9tN7TwSRI4ixm3kouAck30mg/Nl9RTYuJk1kKCt0Dt7xMijlCN018rOW5YqDsItZ4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p1YZGCxV; arc=fail smtp.client-ip=40.107.223.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndvioJhqHx9W4tjbLVZ0PCIgSCc8nfMvCzE42eMgBE1QCJKXChhrBSDMct+QSwmirL8E6/p+eEZnDztP3SrZ/pybqaqvNB+Nj+5v59KLJ7Z9qmF7LohJHmhzJNvPOpAm9CpGErGBqw4bnVsxtVugjsRVYTFDCuX0bpdiACGZjkrbEYX1vM+SEan/ScNnL3rk22ikehq6GCsRsFoD9BEit0jajSML5ynjYQXnJOkKwjDbo4340fEYruHBVWBORitatu6PIaHNLRZJmhYkBW9iDjP99yysrCj0sKVbupW5vCRlZSK2o5FE397TAyMINyNodDmGvNyoUcW61pgnqNTWyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnbrFp13lSVa9OvaVkW1HJ2rewQM3fsvj4vQ/XacME4=;
 b=kPF613Qp+GmigaVT6F0S8hEbdRg0hfl06G5DmiP3yWHUckeSbAMQ8uNcoobdJMwhEcCM/5yxkTjHvucoNZpXLfB/cpAWCJPS/hv8025eshP18uuV60raWYFeKVfeMTy08ShbY5lMDtVX6oX1k1lSkN9cFCEniRwuNJgZbf2vlrSbYoZgGLUJgO86w8SX3mcmpaAtqiXwUwJk7kaagTvlz7q0Fc+Yh1zuekp6up2KYw35GZ6wtNgxm2BpxfuRYHPC6odczFnh8YrIec24gLCugNesbEV2X4mh3WFzqM2yyg7LroSWE9e7Gkk32DD35bqJh+F2vHMk5DZvbC9aVvKggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnbrFp13lSVa9OvaVkW1HJ2rewQM3fsvj4vQ/XacME4=;
 b=p1YZGCxVocRDMLqbPs6tJ8dlacZvh2AYccWXGqAnlUqXJcQuL87kYi5OQUnQQ4xIn8xiKkRUD96kTZ+4l1Du+x2/6sJ/ThjM1EdJUtMt5/oTkNPDsgztP0vJYJMHNXRQ1G1M/LohQcpfUWCgxRIwIfrNg8euMGsrDUE5Y0pVzPc=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA3PR12MB8047.namprd12.prod.outlook.com (2603:10b6:806:31b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 14:46:48 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 14:46:48 +0000
Message-ID: <cd45feb9-20c0-5efa-5844-39a2a4b31678@amd.com>
Date: Fri, 29 Mar 2024 09:46:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4/5] x86/cc: Add cc_platform_set/_clear() helpers
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-5-bp@alien8.de>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240327154317.29909-5-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:806:23::35) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA3PR12MB8047:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S+ykUA6p68Oo641VwaRQNdtw/lO7HqbndEbc7PaKTz7LNhcdbksC7ue7/scdexzXOzpOFuEEVdoWTkLmhrhs3F+GK9WEZgA7y6JhtFSj6gDdZvxOrrzfXjrBN7ps5mgkPDlQJpEymtNXVEbv+sVLrzO612qUS1KMhoJ1MCNAoCre/Y0OGMrhpqB7/Bp1MXEqn3pmyOaAZ211Tnc1/ZAOtZxzt+sIpnTEatiL52KdJy3iduHr4xtyaeYxKly8n9B1XLOsmkblU9AYcut7PuNJSDBe2VoJaAo7HqKKJFI6Up8U5AxJk+uRaLUfkhFpk13roQlenDbov/ockXsSBgCbVLRJqPlLUZUEcOrkwN+Im5Xp6QTA8rGT7XUsqurDgVvXTQM1PV6CFsNUg9uMaLjajgpISIq1Ajm1rAxGi4uvuZlNBltUPjETVXlR527djTdaILcg+I1CIgzH8BDU6L36RWHEK45/CfCWl0fy3odd/6LiBrg0nk87KFoBSRIcvWoC8S9/VDKc+U2fGQcRSVm0JYMVyrRDY4T72U2rvUjUwnNzqQro0LYHULs9HARY2zJSI7PRqb3FWv6gNvy7T+BkrXWYoABrQybA3VqdLpItfBL/vW42Z8Fp67npTQg+xIx0lizU+9HwUmAOVjsNGZ7Ca744f3AF8WOfvD6GoVshd1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVE4cFRNbkNkbU8xbXVlMWMzdVVBK2FTRCtjL3VzaFJIVHpNcjJCbkJHUDhu?=
 =?utf-8?B?ejE5NncyYndvN2k4aUpuSGlqTm5SdnlNWjIrYVhJUWg3UlFHUTR2amZ3ZG9Z?=
 =?utf-8?B?eCs2R01KblBuWkxyU0tmTEplbnQxcDB3d3ZYWDNtWU9FREdENng5RXA5aVFF?=
 =?utf-8?B?TUYzQ3FQQlVEK2FrZGtiRG9qckVoUmdlMzhyaTd6dUxzcm5LQzNyRDFRbWo3?=
 =?utf-8?B?MmRyR0QrdFZoRWUyZXEweFo2bythRG52Ny9EbDZpN1BXTWhxVG5wVXhlTkxa?=
 =?utf-8?B?VndlTlExQ1NSK1RjK0lGRGJlbGNsT2NZMDU0T1dYZEE4L0h5NGphZ0YvRk40?=
 =?utf-8?B?dWQxdzZobGg2cXMvelIvVjgrTnRsQ0pMRTlBaFh6UTZHSlk4YzE2cVFnMDNh?=
 =?utf-8?B?cmhvYVRENGZxTHhTbU1TM0paNjJLdVlVTlZTeDNCSzZ1aHo1VG9Rek9TaEdv?=
 =?utf-8?B?RzlkbGRSbCtZN0VPd3l4YU5NUFFtbFkvWUpXR3FicUFPLzFRYS9vQ0tsM3dC?=
 =?utf-8?B?MVVUelc3WXl1U3k1ZjZBMmJ3MmI5bFNGZHU3RzJ1TEhzeUEwQmN2eDJVR0Ru?=
 =?utf-8?B?bFpMc1pOWnUwZEFCL3hjdnNlUEFoNElNNW9UWk5wSVJGTDg5QWNmV1N3bkhW?=
 =?utf-8?B?enVLMHFEUDJQYWYwMzBDRFErS3pKdUxwRDB5bldSUVo5SXRMbEtuek9vbjV4?=
 =?utf-8?B?Q3NoTS9ObVRPMUZzdVpSVW5QUnlFK0kyeUoxZEVJbXZ2YlpMTUtFSkR6NURL?=
 =?utf-8?B?Tk9EcXRreE5hNHZ3cUdueWJHSUgwU2ZNTVoyMkFnWFB0aC9CVzFhUndGdU1x?=
 =?utf-8?B?S0E2cXZvRkNrKzRsRXJKVlBPVWxubkNPb2lEdU40L3B4dnU3dHJSdnM0Y1lN?=
 =?utf-8?B?NFlwbU1YRU12TTlNWnhhdFNRTnljUUFOUjVBeW1xZ0dWNDRWN21nVzM4bjND?=
 =?utf-8?B?WFJjbmI3ZWVTRS9UYmhadkN6WUlha2ZkNXlZMHNwWkd6ZEU1elZOallHRFQ1?=
 =?utf-8?B?RmRmclRoanZ0cXJHdTVvcE9KKzRtaDNhZ3N5Q0tuSWhZWUpBQlNHczljSi9V?=
 =?utf-8?B?bVRKS3RVdFArdHVlSmwwQzgwVFB3SzljeG5sS3JPbTIveXRJUDRCaVRqVVVm?=
 =?utf-8?B?RW53Umt4bjBzSnZ5YnhHbGdDTU1OZW1RUEVrL3VuM1dWTGc2L0dpa2M5T0l5?=
 =?utf-8?B?TzJQWWxBLytIWDdwcUZlaUJIaDM5b290bmljcnd6c21qaDlTSzJqeHZ0YmlI?=
 =?utf-8?B?b2xxMjB0SGdsRUlNTkFORjJReGY2Z2tCc2czdzdwcmRLNnZ5OVVFNXQySEVE?=
 =?utf-8?B?bmRYT0x1aTBiQUNMTjNZY250RmZ5eC9SdFlhS2I3NG1Makh2TkZOSkpCRkpV?=
 =?utf-8?B?a3V2ckN3dVhMNWlpYlZBT0hSajVoT3lyRjkrUFFsOWRVZ2djcXpaU2FJUEZu?=
 =?utf-8?B?aC8xQysrUXdTaTUwR2ZJdmVwL3VGRXo4Y21VYXZWM2RYUWxFZlZCeGIzZGhr?=
 =?utf-8?B?OTBkNXJCS2xUc0MvTmJCZ1dRMnl0WXFNeDU0SERVd3l4MEtyeDN5ajdGcGFE?=
 =?utf-8?B?TnN0cVEzQ1gxSEdZREd5MEhlOHlRRkI2MEU5WVRwWTE0TWErSUgwbXNJeldq?=
 =?utf-8?B?Mm95MEEvakdzam1ENWtNVzNQL0JXcFlvcTlSSlJsRFZzZHJpNFBBRE9XVTBk?=
 =?utf-8?B?RUphQVBiZTdJd1BOemRtYWQzbU5nY01WVGpMYlR4aWVWQTRRMDE5UVpCYUly?=
 =?utf-8?B?SDhtbEMxbEI0eXlWNVUzUU8zdVIyRFRKNTlseklwak44blg5R1VaUFZWcFRo?=
 =?utf-8?B?UjZHWTN6WWtJRldLTkg2dEZQMDRoMXpPK3kzck5oc1lTOXo3M25EYU15MnQ4?=
 =?utf-8?B?ejJIQXhES1JIMy9KMDhBdjFUUFNpOGMyQ0R2bHcrbEFEMjdVRG5JSFNQN1Bw?=
 =?utf-8?B?ZU5XUW1vSzErM2NCQklOaG5PUW9OdUhhZHB3SzE4NnNoWThWdkdaR3VUMUtW?=
 =?utf-8?B?OXdmOU5DZ0NpMnA0Ukx6VStTSVA2L0hZZW9YK296V05menF2UjdlSmZQaksw?=
 =?utf-8?B?b0hqMmp5aGV6ejNxckxQS0RyMWpycEgzeit2Uy9zeUVoYytWSzVDN1piZmVR?=
 =?utf-8?Q?26yle1yLzQYTcxWfI/moFAWuC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78727ced-d7fb-41b2-e846-08dc4fff1012
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 14:46:48.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvzoNZ2GZSIJMzJNf7ppn9P4Def7M6nh2o8ybxv0Xx+A4KESuIpM5Q7jRrWyJNjH8isjQjVhb1HFMz+NCUIbJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8047

On 3/27/24 10:43, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> Add functionality to set and/or clear different attributes of the
> machine as a confidential computing platform. Add the first one too:
> whether the machine is running as a host for SEV-SNP guests.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
>   include/linux/cc_platform.h | 12 +++++++++
>   2 files changed, 64 insertions(+)
> 

