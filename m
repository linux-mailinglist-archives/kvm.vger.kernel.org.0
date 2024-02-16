Return-Path: <kvm+bounces-8855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BC28576E1
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 08:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 492522848F3
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 07:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775FF17BBD;
	Fri, 16 Feb 2024 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NwKdm2rN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5417991
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708069017; cv=fail; b=J+Dnrk9dZGaafzPmdwqV4KfRMgpQNZkL7686Zd5WH2LBnk+1sIhO2PbKidD3ABjDcS6O9nrdH5BnNLoDPaYT4Z9g72fkAwm0CduZmZhtZhwUkYG1ZcTQd/MI0aQPL/3CVIPUlQPOe1LwRJ+QyoQTr/GJcbryr9y3VgjmScoWId4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708069017; c=relaxed/simple;
	bh=b8Grm4yfYhCW8PIIMNJCimBxt7CY96uhv8znoJTsKdU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gk/M7YehlmZOrN2NF5k+OFh7IWG4uXV4BciAkUYLgrDtrRYMmN4MBa4MIgomn8hDRWBiLnB/Z+o70JGt6+CuUg3ukZlEaJtOsVoApZ6YI4cF0C3EHSfMsuQDlomFQ67r9dQQGoSyrdhkwNC2156rVsjHVaZW5wI2I3fgk+mAUfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NwKdm2rN; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNzFYioLgC5rF9JQt7f/g1roVo/3gJg/0Ma2zP/GeNu8bYVOWnH/VlZSRj60CafAlU3oR/mO4XvM+y9h+YZzWYA8I7gMrN3BXCFT+NNrk+toxA49ixhcJbyX7vJYjwzwcZdiSBmPvN2wkfvOZUNZPAiPA0lGuf6RPlFVqSRb5kQnWI3bdIt+4KWOezBXGW8ZFelO0IHQYwXa35CEfaA52ipqASPz31XamdoD+AYTyxg3xvwXgXJgxJI/yiGOMPP7DaqeYOQENtNlNGujXWzuGuMqHXBNlsnRFYXYKkxWHwpXQmIhDOtha70izh9eOXLANhyssUFDFSXt+zPxb8ikqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMHd2nFxlkmY1bB1J8B6jr66O+dlYKKXXW03UXM2zvs=;
 b=DWmSSTVGSdeG4RHC5fJ3EmYG5oxQG0/xz/5ovVqGMoQJW3GiEHl5WpBqaugDFfFviN/wN/Ik17o2msL/STCHPwX4RbJgfT/vIgKU9c7bmZhqU5NMGZFU2BaSDHpboVa6YmQFP9Mmaop+mq6MUVTlwbtENThLceEuXodEJvcJFyvgknxJjRkybhPLZgMEtBjQVSq3GEdmY965nWW6g+MQn9KtKaEoS4pQF9ZmO7Er1e61A8lVYYf/BVU2f08y8wCHR1Td/wG+YfT2krYV2Qo+MjPgR3Da2FQKVZ9if97gZAr+qw+KKJU4SaEJsTk17R4Ocvqz3znbdSOb7aKMM+YGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMHd2nFxlkmY1bB1J8B6jr66O+dlYKKXXW03UXM2zvs=;
 b=NwKdm2rNBfkYOtlikL3oh48QN6LaHNdTRb1DfOrW+WzZ5BVUh+XsCswZRF9qAqkUPBS6p9O1HsxZDiSTFgF7zZaSrwVCJ9VFjLJttgxcUMpM3PUz6P78eYWj8xiJXafTmkXfHVtEfdzXIc+Trf2YoogU7LcC4Ta9AYcn5IPHnJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Fri, 16 Feb
 2024 07:36:50 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::988:e3af:8d77:6582]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::988:e3af:8d77:6582%4]) with mapi id 15.20.7292.029; Fri, 16 Feb 2024
 07:36:49 +0000
Message-ID: <1f67639d-c6a2-1f36-b086-eb65fa2ab275@amd.com>
Date: Fri, 16 Feb 2024 08:36:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
Content-Language: en-US
To: Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
 oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com,
 axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
 isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
References: <20240215235405.368539-1-amoorthy@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|SA1PR12MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: b180186d-6749-4de9-8b17-08dc2ec2090c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PBboXShpkjBgEpgStbNLuL1vpQJ1UuipVOJsF7yWCnwBvJBsI1MF3/V3eyl5rGywIAsqC23yyH/fb7Jj4zVKwjX6fm2uAck8yWjtovIaoj2q/eo4qUPHFAK93PtZ66qqYtO0GyFXuM2mK/l4azKTEBCQgQIVlbbqRZASNORqI/1/CYLfu6JatMET7zV+k0sX81Z0cuRrqkauFCE94Gfk6pC3RXaY+YRGF0ojyH+Yp/uSab8p4+e+dBeNxWUwD1E+Cz8+kY5dYEAo15jztjkutVKzkuFRj13PMrTyiqe1WAzyuhzXcm9tzTPEhf7CBvRsGKTVGLBHJmVl6TVOx+DQhwnfWZFBayep5bUAqkII0OszWBRFKl156qqUC7ehkUpIRNu3CzjE2UJYKarSi3q5hdXp8rE4jeBqeZ2KLXBFVSg4y1PZBr3bqPEYc+9D80IQENuXkwGgJCt+iYsGxTWAUsPhasnS+MKgf2Gtfsf8x8uW8h4t1eq0WUxnYLJTZ64Ga2tOdUL1i4Sdl3Ee0+wSRN2As1SwN+/53mb8/VicEn4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(53546011)(4326008)(8676002)(8936002)(30864003)(2906002)(5660300002)(7416002)(2616005)(83380400001)(26005)(38100700002)(36756003)(31696002)(86362001)(66556008)(6506007)(316002)(66946007)(6666004)(66476007)(478600001)(6512007)(966005)(31686004)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEYrdHFVUXFSN3JTWTdTK3oydVE1a2tvQkEwcHVmem0zcW82bjA3cUVabmt1?=
 =?utf-8?B?L0FHd0VzUlcrQzd4ZDlKakVzWFZ6ZkxLbjRuSkwvcXZRYm9yTzh4NTRGTWR5?=
 =?utf-8?B?cEhtSWc0aXdJU2ZnS2NWa0NwUlBialBIaHFiRjNKcHVNVUtVU08wR3pTcDI0?=
 =?utf-8?B?L0x5L3JPM2ZHVS9YbERZZHV4c1V5OTd3SGE1UlZFSmFPaCtBRDkrTmVCOFRV?=
 =?utf-8?B?bkZ2b0MwMy85Wlc0VC9EVWdQdnJQUTM0bitFb0VtMUhmRHZzS1V3OWo2ZG1M?=
 =?utf-8?B?Yk5ZaFN3TEdMSzFQZ3FDYXJBd2U3N2t6ZFh0YnQyZlJFcEU3eGNKNldpS2tT?=
 =?utf-8?B?eU03bFB0MmJOdUh2d2NadXhtZzYzSmdZWU5IRlRCTTNTTGVwZ0V5UWFBV2VP?=
 =?utf-8?B?T1pKcmRsamY2ang4NWdZRG56WW1Jd21pOGtzTnFXQURXODJoSEVWdDJyeUJN?=
 =?utf-8?B?dnAxazRJaUtGVHR4Q2QzWEthVVY3SXQveGs0ak16amxQUjF4ZGRRQmdpVEJs?=
 =?utf-8?B?VzJIZHpjQ05kKytJS1Fhamo0SjlFZWZaa1RpZXZZZDNwSEp6MGcvVW1XdEZS?=
 =?utf-8?B?Y1ZFVTZNZjVTaDZqdGwybFY1a2ErTUEzaFdYc29Oc3FRR00ySHBHYzZHNmk2?=
 =?utf-8?B?N0VETjRYcXlvcUorajNibXVUOE12ZXNEbUF5QjdnMEVDV24ycGZydmVwbEZ5?=
 =?utf-8?B?SzBIZ21vWmhWUEg4ZE8vVGRUcW1vNEQvS0xvL1pwS2M5QXpwelBCSThOOE96?=
 =?utf-8?B?SkxzTEd4UUliT0ZBaUs1eFRlZlpSYmtaOE4rbkhFM09ZSElkOVp5ZGtmanF4?=
 =?utf-8?B?ZlYvWGRJa09ab3o0NXcvQ1Y1cFFLU3ZWc3FzZC8vdC9nYnFxNklDWVZ3Z2Qy?=
 =?utf-8?B?dm96N05hcGtZclJ3M0ViU1R4dHh4SDY3QnZsVk9hbndiN3ZQTVVBMzZleG9i?=
 =?utf-8?B?OHRzeEMrL1dTN3ZLTCtxdjZUV0JzQ2lqNjIzdkxhZGZ5K1Z0SFlGbkh6TVV1?=
 =?utf-8?B?U3VTOCtYaUR3T0pvZGpyRGJBMVgxV0tNOHlmeHNxYVVVcUxpWmRwVmRFRVFp?=
 =?utf-8?B?OFczUFpwODNEZllJYmpxQ0k0WEhxRkdxMTlWS0p5YnZybTJxd080RGpVOU9U?=
 =?utf-8?B?ZDZKZ0JST3ZFZjQyR1hjVGJ3RXBnV1lrYTdFYWliSHJBaXJQWnVmRjc1RUp2?=
 =?utf-8?B?S2tMY2xoRzc2RWxyQis3a0doZXFjQUJKQjYwSVRVYTVvdkp2ZGNjVVdPampp?=
 =?utf-8?B?aFdubmExM1VobE12dDROWlgyQzViK25mRi9CRWU1WG53V3NvYzIrbGJIRkRr?=
 =?utf-8?B?UklubjZiYXIxRGYwQ2FQa0MvQU82Yjl0TGJFWFFhSWFtaWdEVzZVdjNXUDhR?=
 =?utf-8?B?OEVOcDlhdUZvNjduUGdYU0xwRFpmT2dFd0dRcldVdVpydkN4b1NiOHMxVDVV?=
 =?utf-8?B?ODN0RVRLNFJMQWNQV2ZoNFZqbXBYL0FlKzliQUIyZ0ljNjBRYnZjUWdjU1Bi?=
 =?utf-8?B?a1RjdGk3UVo0eGhkMzh2eWpZVEV4L3k2VEVNV3B3dkNLRTJJek5MdnM0UktU?=
 =?utf-8?B?eHhEbHhNMktycGtYZmhMcVI5OWJicWFUS3ZlT0hWc3NFYlVmNzNXUVpoNFhT?=
 =?utf-8?B?RXRsdldOUUt3UGY2eDNDMXVMLzBTY2ZUak5uK2tlMXJYRmh3MlRWRDQ3bEdU?=
 =?utf-8?B?eitMNmswalJpSmdPelBhOXhQSVYySnVEdTB2T2NMUXVmUzZBTzVEV2RGbGRT?=
 =?utf-8?B?Y2Era21tQzRMd1JKVHhTMlBoZCtDTmxDcUxkUDFIK0l1UlBNWkZXUXVOUk5M?=
 =?utf-8?B?Mm43R2hKMTUwdVU1cVI3eCtEWjZSbTNOdnhNQ201NGF1Sk9CQUlpK29IbmFp?=
 =?utf-8?B?cHRtb3hSM1ZzZEVQcXdoblFBNVFNY1Q1Z0lsWG5WcjBEcFdIUmQzWTY0R0JB?=
 =?utf-8?B?d0VqNTFtRDZtcUdmajJwSzV3ZndDZ3BOZ0dxNjVLWXFBdTlMUVJGV2JNdlZy?=
 =?utf-8?B?bEpjQVg3QVVGNWowaTFqbEMwQUM1VnBsTXNwTDFWRmtWQjBUMkYvNFQvdkpQ?=
 =?utf-8?B?L1V6b1JQOXlPaG5RYzZjcW41TWh3WVZodFBySzY2dTREdXhUNS9maW1Wd04y?=
 =?utf-8?Q?x1U5CKf1EKyc9hw5BPZiqO8qR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b180186d-6749-4de9-8b17-08dc2ec2090c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 07:36:49.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KS6fG04+6SMWW/UtJZtCuD0Ve6VziEZkpE/7MyJHCq+iUAJo5II6cE99X+Zs6gzn7VxpI9ej3HDGMSl4WL85uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637

On 2/16/2024 12:53 AM, Anish Moorthy wrote:
> This series adds an option to cause stage-2 fault handlers to
> KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
> the userspace mappings. Doing so allows userspace to receive stage-2
> faults directly from KVM_RUN instead of through userfaultfd, which
> suffers from serious contention issues as the number of vCPUs scales.

Thanks for your work!

So, this is an alternative approach userspace like Qemu to do post copy
live migration using KVM_MEMORY_FAULT_EXIT instead of userfaultfd which
seems slower with more vCPU's.

Maybe I am missing some things here, just curious how userspace VMM e.g 
Qemu would do memory copy with this approach once the page is available 
from remote host which was done with UFFDIO_COPY earlier?

Just trying to understand how this will work for the existing interfaces.

Best regards,
Pankaj

> 
> Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
> demand_paging_test, which demonstrates the scalability improvements:
> the following data was collected using [2] on an x86 machine with 256
> cores.
> 
> vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
> 1       150     340
> 2       191     477
> 4       210     809
> 8       155     1239
> 16      130     1595
> 32      108     2299
> 64      86      3482
> 128     62      4134
> 256     36      4012
> 
> The diff since the last version is small enough that I've attached a
> range-diff in the cover letter- hopefully it's useful for review.
> 
> Links
> ~~~~~
> [1] Original RFC from James Houghton:
>      https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> 
> [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
>      A quick rundown of the new flags (also detailed in later commits)
>          -a registers all of guest memory to a single uffd.
>          -r species the number of reader threads for polling the uffd.
>          -w is what actually enables the new capabilities.
>      All data was collected after applying the entire series
> 
> ---
> 
> v7
>    - Add comment for the upgrade-to-atomic in __gfn_to_pfn_memslot()
>      [James]
>    - Expand description for KVM_MEM_GUEST_MEMFD in kvm/api.rst [James]
>      and split it off into its own commit [Anish]
>    - Update documentation to indicate that KVM_CAP_MEMORY_FAULT_INFO is
>      available on arm [James]
>    - Expand commit message for the "enable KVM_CAP_MEMORY_FAULT_INFO on
>      arm64" commit [Anish]
>    - Drop buggy "fast GUP on read faults" patch [Thanks James!]
>    - Make KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING mutually exclusive
>      [Sean, Oliver]
>    - Drop incorrect "Documentation:" from some shortlogs [Sean]
>    - Add description for the KVM_EXIT_MEMORY_FAULT RWX patch [Sean]
>    - Style issues [Sean]
> 
> v6: https://lore.kernel.org/kvm/20231109210325.3806151-1-amoorthy@google.com/
>    - Rebase onto guest_memfd series [Anish/Sean]
>    - Set write fault flag properly in user_mem_abort() [Oliver]
>    - Reformat unnecessarily multi-line comments [Sean]
>    - Drop the kvm_vcpu_read|write_guest_page() annotations [Sean]
>    - Rename *USERFAULT_ON_MISSING to *EXIT_ON_MISSING [David]
>    - Remove unnecessary rounding in user_mem_abort() annotation [David]
>    - Rewrite logs for KVM_MEM_EXIT_ON_MISSING patches and squash
>      them with the stage-2 fault annotation patches [Sean]
>    - Undo the enum parameter addition to __gfn_to_pfn_memslot(), and just
>      add another boolean parameter instead [Sean]
>    - Better shortlog for the hva_to_pfn_fast() change [Anish]
> 
> v5: https://lore.kernel.org/kvm/20230908222905.1321305-1-amoorthy@google.com/
>    - Rename APIs (again) [Sean]
>    - Initialize hardware_exit_reason along w/ exit_reason on x86 [Isaku]
>    - Reword hva_to_pfn_fast() change commit message [Sean]
>    - Correct style on terminal if statements [Sean]
>    - Switch to kconfig to signal KVM_CAP_USERFAULT_ON_MISSING [Sean]
>    - Add read fault flag for annotated faults [Sean]
>    - read/write_guest_page() changes
>        - Move the annotations into vcpu wrapper fns [Sean]
>        - Reorder parameters [Robert]
>    - Rename kvm_populate_efault_info() to
>      kvm_handle_guest_uaccess_fault() [Sean]
>    - Remove unnecessary EINVAL on trying to enable memory fault info cap [Sean]
>    - Correct description of the faults which hva_to_pfn_fast() can now
>      resolve [Sean]
>    - Eliminate unnecessary parameter added to __kvm_faultin_pfn() [Sean]
>    - Magnanimously accept Sean's rewrite of the handle_error_pfn()
>      annotation [Anish]
>    - Remove vcpu null check from kvm_handle_guest_uaccess_fault [Sean]
> 
> v4: https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google.com/T/#t
>    - Fix excessive indentation [Robert, Oliver]
>    - Calculate final stats when uffd handler fn returns an error [Robert]
>    - Remove redundant info from uffd_desc [Robert]
>    - Fix various commit message typos [Robert]
>    - Add comment about suppressed EEXISTs in selftest [Robert]
>    - Add exit_reasons_known definition for KVM_EXIT_MEMORY_FAULT [Robert]
>    - Fix some include/logic issues in self test [Robert]
>    - Rename no-slow-gup cap to KVM_CAP_NOWAIT_ON_FAULT [Oliver, Sean]
>    - Make KVM_CAP_MEMORY_FAULT_INFO informational-only [Oliver, Sean]
>    - Drop most of the annotations from v3: see
>      https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.com/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf
>    - Remove WARN on bare efaults [Sean, Oliver]
>    - Eliminate unnecessary UFFDIO_WAKE call from self test [James]
> 
> v3: https://lore.kernel.org/kvm/ZEBXi5tZZNxA+jRs@x1n/T/#t
>    - Rework the implementation to be based on two orthogonal
>      capabilities (KVM_CAP_MEMORY_FAULT_INFO and
>      KVM_CAP_NOWAIT_ON_FAULT) [Sean, Oliver]
>    - Change return code of kvm_populate_efault_info [Isaku]
>    - Use kvm_populate_efault_info from arm code [Oliver]
> 
> v2: https://lore.kernel.org/kvm/20230315021738.1151386-1-amoorthy@google.com/
> 
>      This was a bit of a misfire, as I sent my WIP series on the mailing
>      list but was just targeting Sean for some feedback. Oliver Upton and
>      Isaku Yamahata ended up discovering the series and giving me some
>      feedback anyways, so thanks to them :) In the end, there was enough
>      discussion to justify retroactively labeling it as v2, even with the
>      limited cc list.
> 
>    - Introduce KVM_CAP_X86_MEMORY_FAULT_EXIT.
>    - API changes:
>          - Gate KVM_CAP_MEMORY_FAULT_NOWAIT behind
>            KVM_CAP_x86_MEMORY_FAULT_EXIT (on x86 only: arm has no such
>            requirement).
>          - Switched to memslot flag
>    - Take Oliver's simplification to the "allow fast gup for readable
>      faults" logic.
>    - Slightly redefine the return code of user_mem_abort.
>    - Fix documentation errors brought up by Marc
>    - Reword commit messages in imperative mood
> 
> v1: https://lore.kernel.org/kvm/20230215011614.725983-1-amoorthy@google.com/
> 
> Anish Moorthy (14):
>    KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
>    KVM: Add function comments for __kvm_read/write_guest_page()
>    KVM: Documentation: Make note of the KVM_MEM_GUEST_MEMFD memslot flag
>    KVM: Simplify error handling in __gfn_to_pfn_memslot()
>    KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
>      userspace
>    KVM: Add memslot flag to let userspace force an exit on missing hva
>      mappings
>    KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
>      stage-2 fault handler
>    KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the
>      stage-2 fault handler
>    KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
>    KVM: selftests: Report per-vcpu demand paging rate from demand paging
>      test
>    KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
>      paging test
>    KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
>      signal errors via TEST_ASSERT
>    KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
>    KVM: selftests: Handle memory fault exits in demand_paging_test
> 
>   Documentation/virt/kvm/api.rst                |  39 ++-
>   arch/arm64/kvm/Kconfig                        |   1 +
>   arch/arm64/kvm/arm.c                          |   1 +
>   arch/arm64/kvm/mmu.c                          |   7 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
>   arch/x86/kvm/Kconfig                          |   1 +
>   arch/x86/kvm/mmu/mmu.c                        |   8 +-
>   include/linux/kvm_host.h                      |  21 +-
>   include/uapi/linux/kvm.h                      |   5 +
>   .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
>   .../selftests/kvm/access_tracking_perf_test.c |   2 +-
>   .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++----
>   .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
>   .../testing/selftests/kvm/include/memstress.h |   2 +-
>   .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
>   tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
>   .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
>   .../kvm/memslot_modification_stress_test.c    |   2 +-
>   .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
>   virt/kvm/Kconfig                              |   3 +
>   virt/kvm/kvm_main.c                           |  46 ++-
>   22 files changed, 453 insertions(+), 172 deletions(-)
> 
> Range-diff against v6:
>   1:  2089d8955538 !  1:  063d5d109f34 KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
>      @@ Metadata
>       Author: Anish Moorthy <amoorthy@google.com>
>       
>        ## Commit message ##
>      -    KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
>      +    KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
>       
>      -    The current docstring can be read as "atomic -> allowed to sleep," when
>      -    in fact the intended statement is "atomic -> NOT allowed to sleep." Make
>      -    that clearer in the docstring.
>      +    The current description can be read as "atomic -> allowed to sleep,"
>      +    when in fact the intended statement is "atomic -> NOT allowed to sleep."
>      +    Make that clearer in the docstring.
>       
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>       
>   2:  36963c6eee29 !  2:  e038fe64f44a KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
>      @@ Metadata
>       Author: Anish Moorthy <amoorthy@google.com>
>       
>        ## Commit message ##
>      -    KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
>      +    KVM: Add function comments for __kvm_read/write_guest_page()
>       
>           The (gfn, data, offset, len) order of parameters is a little strange
>      -    since "offset" applies to "gfn" rather than to "data". Add docstrings to
>      -    make things perfectly clear.
>      +    since "offset" applies to "gfn" rather than to "data". Add function
>      +    comments to make things perfectly clear.
>       
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>       
>   -:  ------------ >  3:  812a2208da95 KVM: Documentation: Make note of the KVM_MEM_GUEST_MEMFD memslot flag
>   3:  4994835c51f5 =  4:  44cec9bf6166 KVM: Simplify error handling in __gfn_to_pfn_memslot()
>   4:  3d51224854b1 !  5:  df09c7482fbf KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to userspace
>      @@ Metadata
>        ## Commit message ##
>           KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to userspace
>       
>      +    kvm_prepare_memory_fault_exit() already takes parameters describing the
>      +    RWX-ness of the relevant access but doesn't actually do anything with
>      +    them. Define and use the flags necessary to pass this information on to
>      +    userspace.
>      +
>           Suggested-by: Sean Christopherson <seanjc@google.com>
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>       
>   5:  6bab46398020 <  -:  ------------ KVM: Try using fast GUP to resolve read faults
>   6:  556e7079c419 !  6:  6a6993bda462 KVM: Add memslot flag to let userspace force an exit on missing hva mappings
>      @@ Commit message
>       
>           Suggested-by: James Houghton <jthoughton@google.com>
>           Suggested-by: Sean Christopherson <seanjc@google.com>
>      -    Reviewed-by: James Houghton <jthoughton@google.com>
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>       
>        ## Documentation/virt/kvm/api.rst ##
>       @@ Documentation/virt/kvm/api.rst: yet and must be cleared on entry.
>      -   /* for kvm_userspace_memory_region::flags */
>          #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>          #define KVM_MEM_READONLY	(1UL << 1)
>      -+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
>      +   #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
>       +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
>        
>        This ioctl allows the user to create, modify or delete a guest physical
>      @@ Documentation/virt/kvm/api.rst: It is recommended that the lower 21 bits of gues
>        be identical.  This allows large pages in the guest to be backed by large
>        pages in the host.
>        
>      --The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
>      --KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
>      +-The flags field supports three flags
>       +The flags field supports four flags
>      -+
>      -+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>      +
>      + 1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>        writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
>      --use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
>      -+use it.
>      -+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
>      - to make a new slot read-only.  In this case, writes to this memory will be
>      +@@ Documentation/virt/kvm/api.rst: to make a new slot read-only.  In this case, writes to this memory will be
>        posted to userspace as KVM_EXIT_MMIO exits.
>      -+3.  KVM_MEM_GUEST_MEMFD
>      + 3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
>      + incompatible with KVM_SET_USER_MEMORY_REGION.
>       +4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
>        
>        When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
>        the memory region are automatically reflected into the guest.  For example, an
>      +@@ Documentation/virt/kvm/api.rst: Instead, an abort (data abort if the cause of the page-table update
>      + was a load or a store, instruction abort if it was an instruction
>      + fetch) is injected in the guest.
>      +
>      ++Note: KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING are currently mutually
>      ++exclusive.
>      ++
>      + 4.36 KVM_SET_TSS_ADDR
>      + ---------------------
>      +
>       @@ Documentation/virt/kvm/api.rst: error/annotated fault.
>        
>        See KVM_EXIT_MEMORY_FAULT for more information.
>      @@ include/uapi/linux/kvm.h: struct kvm_userspace_memory_region2 {
>        
>        /* for KVM_IRQ_LINE */
>        struct kvm_irq_level {
>      -@@ include/uapi/linux/kvm.h: struct kvm_ppc_resize_hpt {
>      +@@ include/uapi/linux/kvm.h: struct kvm_enable_cap {
>        #define KVM_CAP_MEMORY_ATTRIBUTES 233
>        #define KVM_CAP_GUEST_MEMFD 234
>        #define KVM_CAP_VM_TYPES 235
>       +#define KVM_CAP_EXIT_ON_MISSING 236
>        
>      - #ifdef KVM_CAP_IRQ_ROUTING
>      -
>      + struct kvm_irq_routing_irqchip {
>      + 	__u32 irqchip;
>       
>        ## virt/kvm/Kconfig ##
>       @@ virt/kvm/Kconfig: config KVM_GENERIC_PRIVATE_MEM
>      @@ virt/kvm/kvm_main.c: static int check_memory_region_flags(struct kvm *kvm,
>       +
>        	if (mem->flags & ~valid_flags)
>        		return -EINVAL;
>      ++	else if ((mem->flags & KVM_MEM_READONLY) &&
>      ++		 (mem->flags & KVM_MEM_EXIT_ON_MISSING))
>      ++		return -EINVAL;
>        
>      + 	return 0;
>      + }
>       @@ virt/kvm/kvm_main.c: kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>        
>        kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>      @@ virt/kvm/kvm_main.c: kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot
>        		writable = NULL;
>        	}
>        
>      -+	if (!atomic && can_exit_on_missing
>      -+	    && kvm_is_slot_exit_on_missing(slot)) {
>      ++	/* When the slot is exit-on-missing (and when we should respect that)
>      ++	 * set atomic=true to prevent GUP from faulting in the userspace
>      ++	 * mappings.
>      ++	 */
>      ++	if (!atomic && can_exit_on_missing &&
>      ++	    kvm_is_slot_exit_on_missing(slot)) {
>       +		atomic = true;
>       +		if (async) {
>       +			*async = false;
>   7:  28b6fe1ad5b9 !  7:  70696937be14 KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from stage-2 fault handler
>      @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for more information.
>       
>        ## arch/x86/kvm/Kconfig ##
>       @@ arch/x86/kvm/Kconfig: config KVM
>      - 	select INTERVAL_TREE
>      + 	select KVM_VFIO
>        	select HAVE_KVM_PM_NOTIFIER if PM
>        	select KVM_GENERIC_HARDWARE_ENABLING
>       +        select HAVE_KVM_EXIT_ON_MISSING
>   8:  a80db5672168 <  -:  ------------ KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
>   -:  ------------ >  8:  05bbf29372ed KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the stage-2 fault handler
>   9:  70c5db4f5c9e !  9:  bb22b31c8437 KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from stage-2 fault-handler
>      @@ Metadata
>       Author: Anish Moorthy <amoorthy@google.com>
>       
>        ## Commit message ##
>      -    KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from stage-2 fault-handler
>      +    KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
>       
>           Prevent the stage-2 fault handler from faulting in pages when
>           KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
>      -    calls to check the memslot flag.
>      -
>      -    To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
>      -    when the stage-2 handler cannot resolve the pfn for a fault. With
>      -    KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
>      -    faults as vCPU exits, which userspace can attempt to resolve without
>      -    terminating the guest.
>      +    call to check the memslot flag. This effects the delivery of stage-2
>      +    faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
>      +    can attempt to resolve without terminating the guest.
>       
>           Delivering stage-2 faults to userspace in this way sidesteps the
>           significant scalabiliy issues associated with using userfaultfd for the
>      @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for more information.
>       
>        ## arch/arm64/kvm/Kconfig ##
>       @@ arch/arm64/kvm/Kconfig: menuconfig KVM
>      + 	select SCHED_INFO
>        	select GUEST_PERF_EVENTS if PERF_EVENTS
>      - 	select INTERVAL_TREE
>        	select XARRAY_MULTI
>       +        select HAVE_KVM_EXIT_ON_MISSING
>        	help
>      @@ arch/arm64/kvm/mmu.c: static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr
>        	if (pfn == KVM_PFN_ERR_HWPOISON) {
>        		kvm_send_hwpoison_signal(hva, vma_shift);
>        		return 0;
>      - 	}
>      --	if (is_error_noslot_pfn(pfn))
>      -+	if (is_error_noslot_pfn(pfn)) {
>      -+		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
>      -+					      write_fault, exec_fault, false);
>      - 		return -EFAULT;
>      -+	}
>      -
>      - 	if (kvm_is_device_pfn(pfn)) {
>      - 		/*
> 10:  ab913b9b5570 = 10:  a62ee8593b84 KVM: selftests: Report per-vcpu demand paging rate from demand paging test
> 11:  a27ff8b097d7 ! 11:  58ddb652eac1 KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
>      @@ Commit message
>           configuring the number of reader threads per UFFD as well: add the "-r"
>           flag to do so.
>       
>      -    Acked-by: James Houghton <jthoughton@google.com>
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>      +    Acked-by: James Houghton <jthoughton@google.com>
>       
>        ## tools/testing/selftests/kvm/aarch64/page_fault_test.c ##
>       @@ tools/testing/selftests/kvm/aarch64/page_fault_test.c: static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
> 12:  ee196df32964 ! 12:  b4cfe82097e2 KVM: selftests: Use EPOLL in userfaultfd_util reader threads and signal errors via TEST_ASSERT
>      @@ Commit message
>           [1] Single-vCPU performance does suffer somewhat.
>           [2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>
>       
>      -    Acked-by: James Houghton <jthoughton@google.com>
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>      +    Acked-by: James Houghton <jthoughton@google.com>
>       
>        ## tools/testing/selftests/kvm/demand_paging_test.c ##
>       @@
> 13:  9406cb2581e5 = 13:  f8095728fcef KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
> 14:  dbab5917e1f6 ! 14:  a5863f1206bb KVM: selftests: Handle memory fault exits in demand_paging_test
>      @@ Commit message
>       
>           Demonstrate a (very basic) scheme for supporting memory fault exits.
>       
>      -    >From the vCPU threads:
>      +    From the vCPU threads:
>           1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
>              with the purpose of establishing the absent mappings. Do so with
>              wake_waiters=false to avoid serializing on the userfaultfd wait queue
>      @@ Commit message
>           [A] In reality it is much likelier that the vCPU thread simply lost a
>               race to establish the mapping for the page.
>       
>      -    Acked-by: James Houghton <jthoughton@google.com>
>           Signed-off-by: Anish Moorthy <amoorthy@google.com>
>      +    Acked-by: James Houghton <jthoughton@google.com>
>       
>        ## tools/testing/selftests/kvm/demand_paging_test.c ##
>       @@
> 
> base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3


