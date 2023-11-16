Return-Path: <kvm+bounces-1887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1297EE54A
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 17:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04471C20A91
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09173EA91;
	Thu, 16 Nov 2023 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="VleW4NZr"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2123.outbound.protection.outlook.com [40.107.21.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B0189;
	Thu, 16 Nov 2023 08:37:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkFyMlt8Q7s/CX22FHR/NuygD9qmPtor0gmWmHkFYzK5ylr7K2ypkvxP9lCzyyR/1a8Da7CsQeA7r4qeK1Qy9p8DDAiuvbl3nWccoarN9/bOym6OAur+ghlP/OnSakq0+VZZQTshNqBzU3j283xcJwvXrnPUwRgFS/mtsm7B0xRZ+T72BzPttuTTbCUhv8hd8hLdZeTZZlnRY6iZdcOXZ7qDS8xtsA6OM8Cvv4KXwYJjmK2JbgaFa0AmMGkCAEXpbbNRSAi66c8QZK7lUJkilx2ndnUelEZJtESwPH0HJhDCktt5Bod6nIbqe7XkwPZNEnO2GQIC8GtvMzx2hqtm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYlxoc5sjwTw/qpNqUe3KFFnEMekPKC/VGFLIhaaF9w=;
 b=NW/4NL+y+hYRLRNmZ8JKyvdUq5cMjnIkUYpToBnQ9lNyOeXNS4vZ3c2oytsr/qjFGerBxXfHAEumw9ulEL1bozyGFFu7NPN+l77UUeYVlUywUJB4GkS1o7zgjsBfBiBu6l37sdDLJvBIgpHiRXV2++d62yxtpnkXBv717wuGXg/Yp1w//1wCe0dQcWDkvjnB3HCv11saTfqehTjlObxX2YnZV7DiTPjpcJdgnraCtBKFP8AYud9PzAU/m7/0lSanZN/rB9LiPahGR55744UTYT/g288HNF45qVIw/CIzsr2OpThZ4+qVfgqlC3ldNg1orU0EWzH99xvo1tunhCDNCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYlxoc5sjwTw/qpNqUe3KFFnEMekPKC/VGFLIhaaF9w=;
 b=VleW4NZrvsepLZKc/jLfiuHG877xFGDtuEXf1llCjpo8excO5vs1DonXUA0jWLV5EyP8bKTSZkXjoGTaeD3IEB+G6C+nor9j71ngFEMPoPrH9B+skLu9XdtbJI7+28Ino1BvTDNty7EWac+0gjgAsC25/toQnesoJi1T9m0UlEWEO1I2mjjLDe0y8LKFKqx8tEXbTxn/nHESJwr/RH6sLJhhquLYcyQ6rKuKNeuXLqO01Sc5GB1H37Wu3yqX/vANcvwerT+Vx+wVMIrxdYF3JogHHmwH4RblvGsNJ4colki1GyYhy+51ztImXNx73GCIMNQ52qloj7QiWP2TRXmkrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12)
 by DU5PR08MB10465.eurprd08.prod.outlook.com (2603:10a6:10:518::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 16:37:14 +0000
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::d736:69e1:b7da:62e6]) by DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::d736:69e1:b7da:62e6%5]) with mapi id 15.20.7002.018; Thu, 16 Nov 2023
 16:37:14 +0000
Message-ID: <c10bd6c4-9701-4888-8277-851c5ac76beb@virtuozzo.com>
Date: Thu, 16 Nov 2023 17:37:11 +0100
User-Agent: Mozilla Thunderbird
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: [PATCH 00/10] KVM: x86/pmu: Optimize triggering of emulated
 events
To: Sean Christopherson <seanjc@google.com>,
 Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20231110022857.1273836-1-seanjc@google.com>
 <6e101707-f652-73f8-5052-b4c6c351e308@oracle.com>
 <ZU5Euc29B_UjiUot@google.com>
Content-Language: en-US
In-Reply-To: <ZU5Euc29B_UjiUot@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::20) To DBAPR08MB5830.eurprd08.prod.outlook.com
 (2603:10a6:10:1a7::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBAPR08MB5830:EE_|DU5PR08MB10465:EE_
X-MS-Office365-Filtering-Correlation-Id: bb53cbe2-59c3-4cc1-0a0a-08dbe6c249ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7qdi29K4dxuGcfgFYls0BGa7VerE1Q8dBIqNjpg6pBzmLv8yP9hj2fvtj3sHdukbVk+PQ0PDt1BUMPEJk+ZfyqVz7PabLgpHaaZNl/+ciAYC6ZveIRwecw4EtAbayYcnH9zVjDkN1Zp3QIn+U+gjPc+O+bErsnKVvQKmNNMXFd56oQnjTLCNYwiKqQKhZxf7c+xWJbmYwepzQ8dRtegB2TwqvT5Ud5p7cmSeaoJb8A+rooGIOgaNpPFt6Rav2KagXchzN8QXToO3x7e1af9wfWnWnvEow8ECWsNYXSWqnXxfumc0c+tr0ST3A5XB3drHyRfDmPtDJywHwYidwWwhi4IEetrf6bmMu/Vll80L9wgDJicYFhcWmy5l3PRDg2hNx4hhGTzXetajy29EutoRKLHiKFRRN4UmeWorQ6V5ei4osH4DXEcbk3BrNQnHVo8y1dH4PureYoVC8Q5QXvqWTj4ns93676AJ9RNBR3ZapIwHpsXD9aCQSRey/xqcE5vvexoe3++sX3lbh+62+PUs6cfIJQ/cD+GmfNN+LCrRF+pX/7k+lLECf7x8hcKljpC8YuPyCnd4+Bvhnkv5WudZSq+DLKiVyhMSHCFaMLzZeGc2IS/8/5W14IqH+YGJEJXX/VG/ltFJwTJIOFawSvv0WwRDwpoHx3cUBKDWe7mpq7Gae95eZ689VJBQAgKRtP4u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5830.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39850400004)(396003)(366004)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(66946007)(66476007)(110136005)(66556008)(41300700001)(54906003)(316002)(86362001)(5660300002)(31696002)(2906002)(8676002)(4326008)(8936002)(83380400001)(38100700002)(31686004)(6666004)(6486002)(966005)(478600001)(36756003)(26005)(2616005)(6506007)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzJSalJtajU1bDZFQXEyYWh2VFd4SWFldnZSeE5pNGI0UU1US0trVlVJS21W?=
 =?utf-8?B?U3Y0OGp1ZlplTDNTWTBCTVhIQmg3cmFVM0tTdXdaYzByeXZWUENDNFNsMm85?=
 =?utf-8?B?cGY2NDlPdlBUSTJmWFFRWDhwZEE1NTZybk1oMEM2cjZNb21CY2xYUjUyZ1VD?=
 =?utf-8?B?WUlCOUowbEhzcisvdkhXVG55aG9rNnJGN1B2RXZVQ2xSYjNTZFNPc3hEVDZl?=
 =?utf-8?B?RlkwcnBZOG95U3h1UFg4VG1CSEpnTlNkYkZORmczRmdhTmtxd0ozWU80WmxH?=
 =?utf-8?B?S3ROQlRIQ1J3S1pSU0piV3dxakxDUlBLMVh5dExnbS9qR1lRdWFoeXFZdlJC?=
 =?utf-8?B?NnZmYm16dGlveEpRSjU5Y0lDd0htRU05RjB2UlBlRmNQaWZZRTgrSjJJRmE1?=
 =?utf-8?B?cDI2VGRZWTV0cHQxeDEzY3J3bko5UmJoelBmb1krbXVWUzJhWUFSYTBWc1JF?=
 =?utf-8?B?QW4vYzk2MDd0WWQ3ckdQQ2pRUnRvNlRZenVFVlhQQkt0cjVCdTU3bExKUUd1?=
 =?utf-8?B?SjlwYlVUYm81LzYrL1l5ZmVrUGd4NnVNMG1aOXpsYzFENmh4VE9XMjBhZDJY?=
 =?utf-8?B?WlZZNlJ3eUt0UTNUMVZoQVdJVFUzVkZ6d1VaVGVuQk9YRVlUVjl6MWVtTS9H?=
 =?utf-8?B?aWViaW9XSW10d2J2UkVEb0IvMGE5QWdMYTJ6TXZaeEozL2puZ2VBMmhlVVQv?=
 =?utf-8?B?Y29Xd0VhdG95Z2I4T2JVWjZkYkxpbVBxM3hBYXNyQUlpWlNqMnhzSCtrV2NK?=
 =?utf-8?B?OW1rYXduTmF4VFF3Tlh4c1BCZkczWWpUZ20yVFpqNk5iYnNMYnZjeHV4RUVX?=
 =?utf-8?B?WUJwTDB0OVZZKzlxVUcyZFM0SGxUNW9SR3ZFbGozSWwzSVIySElieWRtM2RQ?=
 =?utf-8?B?QXpyTlFYelVYYlRMd0hkM2VKb0g4MTlSbFN1WnVEVGEyM2lJeUtqN3FaalZN?=
 =?utf-8?B?UzlUM3ZQL3c2YWtZRjlzY1Y3Nnl3RGRsZEg4NFFIUUZOM1pURWNDZ0Npcy9D?=
 =?utf-8?B?WGtlZGs3d0ozbzI1MUNtaHROYU1VS2NZdHFvVGJwdjVLbUl0TnNwczFrRUJU?=
 =?utf-8?B?aVkxQ2pzL05HOVNwcGhYRDRodElacHArcW5MdHFPWHBFelJhcTREeVFoRlRS?=
 =?utf-8?B?U3RDSnFDOEh4TmVYQThJT1VkbFVvYUZ6RERrNklLWGJwWEx0QlNVenU1NGht?=
 =?utf-8?B?RU53d0cwWmFTZ0tzZmFuUGxGTEtGNkcwQUp2VEg3aDFVWlVVUTB3SGNMd0M4?=
 =?utf-8?B?cTkxVUZXQ0hXUng5bE5QRXNjQ0JaN1hFTTB0VWhLWmlySlUranBBdTdnU0tv?=
 =?utf-8?B?cjJFS244Qm1wS3M0eWtBQkFnclFiVDhsbWdEWW1XeWNlQVRKS1VQQ04zRUVu?=
 =?utf-8?B?aG40dXBocTRCR3AvN2pSLytWWVBYRkxjRlkyUUd0OGRrL0oyYWpBeFdkYmJO?=
 =?utf-8?B?cFR6eFpvTTdsclFZNXduUHBYWFN4Ny9DdlZ0VktLV2NsM3dNNUdVMy8vaVZj?=
 =?utf-8?B?ay80MWpLR3RxaFNQd2czQUE0d201UHJzdVBjSjVtVHY5dVNEZS9UdFo1Mk9s?=
 =?utf-8?B?TnR6am8xN3NxYnVtOWl1bG9rN2tCZ1N1bkVLWm9uelBBbXVzN0dsZFVEcGtW?=
 =?utf-8?B?NkhTMzE3eUk4ZWxZRnY2Nm1razZSaW1nandvdzVDL01WSkxiQ3ljN2pwZEdY?=
 =?utf-8?B?NTBvYW13UkY1eVVyRXRPTmNDblRNa3NTdFlsSDluWVJzTDBocXNWU2V1Qkl5?=
 =?utf-8?B?ZjRMMk95VGp4dXNBMVhvZmNjQ09iQWNlcjVIYlB4NzU1VkRUVGtGQktNUnJ0?=
 =?utf-8?B?aWlwRFNvbTZMWWh3NVZwNnFCT2w4SDJrOVlUVTVzUDdtOHlQYzNVVGtQbElN?=
 =?utf-8?B?eGhSQXdlZTk3RUVFZFJvMFhHZTQ1OXJxZDVYN0FwVUR1NHFMbExjREttdXh3?=
 =?utf-8?B?cnlVMDBLcWtYVkhtV21MdC9OampOWXAzODVvMlR2Q3Z2MnBZKzBLUEJWWGZ3?=
 =?utf-8?B?VU81UENyOFlydTRNQTVOYVlDcmYxalVRSFdlSGdMckdzelVyNjh0eDJMWUhz?=
 =?utf-8?B?NkVXeTFBdmtaMXRkQUJuelNuWWh0RHhmY0FtcDZrcy9xemxTZVFiVExXeGE2?=
 =?utf-8?B?aGR3M3JyRnFtWHAvU2RtMlF3Zisxano3czg1NzIyZnM4bkt1OE8zWmwxbnhs?=
 =?utf-8?B?ekE9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb53cbe2-59c3-4cc1-0a0a-08dbe6c249ec
X-MS-Exchange-CrossTenant-AuthSource: DBAPR08MB5830.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 16:37:14.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tmTDGT873eLJ4CFAYm56AoLq1/Xx6TJEqkqh6l3L3F/NGn6YDIO+ft9ugoMoLMg0zlarleZ7OS1o2v8gK0fEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10465

On 10.11.2023 15:56, Sean Christopherson wrote:
> On Thu, Nov 09, 2023, Dongli Zhang wrote:
>> Hi Sean,
>>
>> On 11/9/23 18:28, Sean Christopherson wrote:
>>> base-commit: ef1883475d4a24d8eaebb84175ed46206a688103
>> May I have a silly question?
>>
>> May I have the tree that the commit is the base? I do not find it in kvm-x86.
>>
>> https://github.com/kvm-x86/linux/commit/ef1883475d4a24d8eaebb84175ed46206a688103
> It's kvm-x86/next (which I failed to explicitly call out), plus two PMU series
> as mentioned in the cover letter.
>
>    https://lore.kernel.org/all/20231103230541.352265-1-seanjc@google.com
>    https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com

Hi Sean,

i have tested my testcase on your patchset, results look impressive, thank you for your work!
Note, for AMD node PMU totally disabled case gave a bit worse results on kvm-next kernel vs stock 
latest mainstream.

The difference is tiny though.

*AMD node*: CPU: AMD Zen 3 (three!): AMD EPYC 7443P 24-Core Processor
-----------------------------------------------------------------------------------------
| Kernel							| CPUID rate		|
-----------------------------------------------------------------------------------------
| stock ms 6.6.0+ (commit 305230142ae0) 			| 1360250		|
| stock ms 6.6.0+ + kvm.enable_pmu=0				| 1542894 (+13.4%)	|
| kvm-next ms 6.6.0+ + patches from Sean + kvm.enable_pmu=1	| 1498864		|
| kvm-next ms 6.6.0+ + patches from Sean + kvm.enable_pmu=0	| 1526396 (+1.84%)	|
-----------------------------------------------------------------------------------------


*Intel node*: CPU: Intel(R) Xeon(R) E-2136 CPU @ 3.30GHz
-----------------------------------------------------------------------------------------
| Kernel							| CPUID rate		|
-----------------------------------------------------------------------------------------
| stock ms 6.6.0+						| 1431608		|
| stock ms 6.6.0+ + kvm.enable_pmu=0				| 1553839 (+8.5%)	|
| kvm-next ms 6.6.0+ + patches from Sean + kvm.enable_pmu=1	| 1559365		|
| kvm-next ms 6.6.0+ + patches from Sean + kvm.enable_pmu=0	| 1582281 (+1.5%)	|
-----------------------------------------------------------------------------------------


Note: in order to disable PMU completely i used "kvm" module "enable_pmu=0" option
(not used KVM_PMU_CAP_DISABLEthis time).

Hope that helps.

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team


