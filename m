Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1F483FFD
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiADKia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:38:30 -0500
Received: from mail-dm6nam08on2051.outbound.protection.outlook.com ([40.107.102.51]:32609
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230393AbiADKi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 05:38:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMiHusohWa91SRypIs1kYGmmXVSD0ByskHEi9DodhsaqwV1K0QG2wPXYylcoMzvNaACxuqLb/Wo4j5VwZ6VaidGzRXJRcaugY4mptx64q3aJI0UbEUxgfyMLksEslXnCj1kCyly2PVB+fG1ELkvsL9PmEjigaqHSe1142GbXgrAfMHBwAuw2okE3g4gV/qm+FS5qRjVRBPoteGNfXYQi4u/NDlEHTCUPkZOwRx6VZGfKw9ACi9kMOQcxZMFRqKMB2JgdTlcYwWSFjavtcWGHSSsS6Y+d+B/eGHuoohfyUD34CuLv7QcwqhZuzRNTA6Z8NQAzqp2yt1+1PwhUUzA2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93f7Le6PWrUQdzEPg0OHV9Snv8IeUukaR+YCV+k2p1E=;
 b=MAoW6wo9fE/5aE+gbcgmZgiusLivlKVR1oBRDfu0SgQ/ZbLPeYXlFTr4gbnS4mgLSh9VonX/33BWyof28k9n5EpogoW8nqJ7zq7lQbmfD6P4iE3ENYfvm/Xktn86nYGv6y/0mhvPWanF66NLK56lcT5oMn5fqTqh4ghM0cY22PJ5DJxVRjmKvCPEiql/cRp0FhMvoC0BzLsVrOJVxpJiLnWSTupRBUpzdGyjntVbZ+cr2X3PPGWl8L0plP4067M9CFVQ14/NHgiYdfNGfL3qaZ9qw6Pw1jHvwKeFxM+F+qZIrrbkbbeSc1W9TBSo1mHDDkw+xGY/NDf7Ye0x03YSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93f7Le6PWrUQdzEPg0OHV9Snv8IeUukaR+YCV+k2p1E=;
 b=fg5CKGdu44x4lmf1nXuEo1lmSkOxVlknPwDeb6oSZmk6rcF87JV9RzY0yN1xv8U4GXJLosNNabe7TQNPcGY1XilVOEDRrVs3l77piqEdDaIecj15zXkr9dsN70kbr34yRScnPOBVk2gIvWj4frYyUeJ+SjyilbLhPvQVnE6vBRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 10:38:27 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4844.015; Tue, 4 Jan 2022
 10:38:27 +0000
Message-ID: <eb3e95fc-0c05-f0f9-1801-92ec9b5f5845@amd.com>
Date:   Tue, 4 Jan 2022 16:08:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] KVM: x86: Do not create mmu_rmaps_stat for TDP MMU
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
References: <20220104092814.11553-1-nikunj@amd.com>
 <YdQYK4oRDU2Dmfwe@xz-m1.local>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YdQYK4oRDU2Dmfwe@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::19) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76ff5a3f-7279-4cb4-6bdb-08d9cf6e5768
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218D128D4458700A924E557E24A9@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v24Gl0H8zRirOV9FlKKxaDJ727Ps6DvLVUYU7e5zBSixJSlvt2bxanJgfDY93bzTHvhvhmmbO4/29a1yI4sKS5GP2py8UMpkAyjys5e1/vZmmWUiztUCGFiKAaV5S0fOT31aewApQ9eFcG242Ia9nrkpkfJOJ6tMe1IXHmswyCAqfqeTgdkogiXEZk8ppB4WVGtklWx1mEaZp+NWu7/rbBkiM51jlYQbJbdUkFjxHfCM1G4mYbDfuHI6/sX5bREc07p4+YSJFD5gm3BRMT4ulNvQEK8XxFQ4lZ9cYItK6QNawYZ5Sg50laJRGLuP5luWVc3EA1HK8iosfqY+HekSNHNQ+FKc++CH+wZ0Tqvn4VUcMJQcE160nP5wskEx6XddE6uQK9yK7/r9+PoLJgVZc7U5mNxcRKqOGHNjoG2uMi43HpoJa3LXMtTu5/GTFTjOD19gYG5fcbvm1cqe9HGKMEolSmc2hI2+k+KNHqLt2k8UgQ69vJeBJkRF6GaiGB2eBByyqEcCil5B2bw9v/sg0P32xEeKjM9ApVgefPH9b5FGRFdR35orOUFrK6g5a9VFGreq1uAdXVDiZcwtegXJv8nnGGcMneTjPe+woQofh3doRlyIs8r+eIozuJbdq5RiT3XKDsP7s3l6CdPz4h033rzemYm6qiBEPBpbqDPaapp52G3KaGp+SQ+/MjTEjJrbAMgB+leSjb1c/wlZU/01N2HiFi+00Yk/MqwE4NBIVXhX0hssKKPpafQSDtdXqJkGcY/PhHSoKwc6/SlF9uRbozgbuuIWRievSaKLblfEDLk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6666004)(6506007)(8936002)(8676002)(66476007)(53546011)(4326008)(2906002)(31686004)(66556008)(38100700002)(2616005)(66946007)(316002)(186003)(83380400001)(26005)(6916009)(6512007)(31696002)(54906003)(5660300002)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTJRR3FQQWJreE5BY2ZHbTF4bDQvOU9YOWl1VGtCM2JsRXZnNmVRQ2F3ckYy?=
 =?utf-8?B?ZGd5RU1kSHhVcEZ4Qno5WFlBZVNzWmtBZ3JlVTcyd2c0NjZVazBndkJDa3Qz?=
 =?utf-8?B?R0hvMlB1S2FrSzFqdmZwMkQ2V1hvaW1DbnNFb2ZMdWxydERWSUNCZ0dsenFm?=
 =?utf-8?B?b0g5TmZRNTdqOVZ2bjR4YjVac1lGdnlXMTh6bmY3S012ZlZlZm1Zd28zMjRx?=
 =?utf-8?B?Rm1Kdi9mQkRVcDZRa1FLWVBiWTlzREFGTTl5UG9tME85QkZRdU4ydG1JYUl5?=
 =?utf-8?B?NTAxQklMUlI1V1A4dUV6bVgyQkhqby8vSmkyMFptUlZpdXg5Y0x2QnpoV1hi?=
 =?utf-8?B?Ty84WDlNbzN6SlN1dXRuZ2ZGNDVxUHo4YTRNM0lta0lDNVlWNnRyb0R1NDN1?=
 =?utf-8?B?RjIvQ2FTVERmQmI1VDIvckwyUkdxU0pjZ3pGNnRGTVM4cDRQWGc1dHBnZi9l?=
 =?utf-8?B?OTk1TUkxaVgyQlRsQm5RSTBXUmFiekdHT291cFVkemJaanZOczhWbTlYKzRX?=
 =?utf-8?B?dzJtYzF2UWdPWVJLTDd6TlNvd29PZmFiWmhPUGZlU0VBSEMvbUNhUmUrbTNQ?=
 =?utf-8?B?ZTNWUTBYb2xsNmNRYXBuTFM4MUVlWWhMM1VzMGcvakcya3l4Q2w2S01UaVNB?=
 =?utf-8?B?R3F2TkFmVzdkcllPREpIT3Y2a283T3VpcVJ5Nm9MMGZKWG11UUlkUlErVjNs?=
 =?utf-8?B?U0VZUGtzVWNVYWF1ak1MQ3VwV3hJdEFuT3JVUGEvdjlkQmJPeVppUC9iR0xt?=
 =?utf-8?B?dnFPT1Z4aEV4cE03eXAxQzB5UzFmeTZpb3dQMDBmZmpSZ2RNN3VjWFBVckZk?=
 =?utf-8?B?SWxWZTZYWTQwTHh6MWVvaFlpRlJvQUdTd2NjbnhXaEVncXpBbml1N1RDYW5X?=
 =?utf-8?B?Skc5ZkpFZFFFYWdkZnVVZSt6V3Z5L2Z3T3ZRdk85L0JqZlVYaXI4NEtrWlF6?=
 =?utf-8?B?ZzQzVG95VHd2UFdld3RPZW5xbzNzcEVwMzNTTnhFZWlBQVJnbnJpeUQvUkZ0?=
 =?utf-8?B?MnBLVWdaVUh3ZEdwNDBLZVdGRHVHQ1pQNFltODNGY1FZWCtsOXZZSk90eUFL?=
 =?utf-8?B?RW5IZzJ2TExIU0RFeGZ0VHpXa0lrUHVzazZHemdtWEdzNVJLNXI3cTI4L2Jw?=
 =?utf-8?B?a09zeEo3NVJGeFVJOTAxN0wzRlRBNyszbkVqMFQzVWhSY0xFaWEyQ3Y1TW8w?=
 =?utf-8?B?RjhMK0krMkVaU3lHWlV2Yi85WnV4V00zNElDOXdpQ2F2RVhMdlQrTEU1NFg5?=
 =?utf-8?B?NVRHQ3E3MU16MTU3cHQwZWpoWnpvRG5sRmtQMmdIdWxrSTVoR1l0SmRPN0VP?=
 =?utf-8?B?Rkd1QkNRWHFRZlhFaDRnYThFaW5teGZDdlhLcGlKbXNiSlJVNDl4b2M5a1E5?=
 =?utf-8?B?elp5MGQrekI1N1BNc3pGcGRoemxrZ2J3bnoweHJ0ZlJhaHNaeWRuSGxpd3Nh?=
 =?utf-8?B?Y1J5a3krcDlIVm5YbUg5Q3JiS3pOUnpuUDZMT2loVTVaazI3ZzBrNHdMSlQ4?=
 =?utf-8?B?VzVuQy9MRHRWUmhhdUdPU2VBblNBVXhWV3hOVHR3K25DU3VrbGVldWRrQjl3?=
 =?utf-8?B?R2lUUkVUMHV6UVZxTkFRYVZsTFprOURsa085ZjNRdk1zK0x4WmhsUTloWm03?=
 =?utf-8?B?NUpSK2dwNDN1V1dQQUpTR1N2anNDZFgwWUpXd3lXTkdLcTlHc0FFY25Cdm1N?=
 =?utf-8?B?d2RzblJsS25Mc0NRaTRXdm1UOHBrOTE0TTZNVmRLUWVBY0E5Y01wRnhaRXJw?=
 =?utf-8?B?OW0rTWdmeWtLZUNwN0NSeGRkL09uSlhUQllSdklZUXdLb2FIQmlWZGx4dkZS?=
 =?utf-8?B?cUVTWkJxVVE3c3NqbnlRSW5GNVpSL0l6M0oxWVR1SW5SZzZ2THNVdmhzU3FC?=
 =?utf-8?B?VDNUOC9qbmtlK2ZtbnJxQXJBejh1dmN2RHQzVmhzRHJIdmNoTjV1RENucjJW?=
 =?utf-8?B?Z2tENjhUTkpHZDNYcGFEOVZEYjhQc2xQbG5oMmxzd2E5U0pLRVlLVXJyMVBv?=
 =?utf-8?B?dk96SENtb0Zpa21mWE8xZWdvZjB0dlhjSkxiMUIxb0w2K0hoOEpQWEgvTjN0?=
 =?utf-8?B?dkovWFFXdWtyRUZIdHEzL3JadXR0elRKRTRNVUVXamQwRzNqZWx6ZVl2UXJo?=
 =?utf-8?B?ZjVTVzNGOFh4MWdCTTVCQmtXam5WRzZxQ3NLL01NbTlScFNxSUpZbm5rSlhN?=
 =?utf-8?Q?B55HmFGy52bkbXFOyl84ZeU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ff5a3f-7279-4cb4-6bdb-08d9cf6e5768
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 10:38:27.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ddj+QRDyCjqLNSUNdvloIGZ+Hm6J5B/RBQMtcfRmDb+kXGjb2Q4Qt3NUUv3Ca0NRStv8EhfCg/T+EMoJwcSSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 1/4/2022 3:19 PM, Peter Xu wrote:
> Hi, Nikunj,
> 
> On Tue, Jan 04, 2022 at 02:58:14PM +0530, Nikunj A Dadhania wrote:
>> With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
>> file causes following oops:
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>> PGD 0 P4D 0
>> Oops: 0000 [#1] PREEMPT SMP NOPTI
>> CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
>> RIP: 0010:pte_list_count+0x6/0x40
>>  Call Trace:
>>   <TASK>
>>   ? kvm_mmu_rmaps_stat_show+0x15e/0x320
>>   seq_read_iter+0x126/0x4b0
>>   ? aa_file_perm+0x124/0x490
>>   seq_read+0xf5/0x140
>>   full_proxy_read+0x5c/0x80
>>   vfs_read+0x9f/0x1a0
>>   ksys_read+0x67/0xe0
>>   __x64_sys_read+0x19/0x20
>>   do_syscall_64+0x3b/0xc0
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>  RIP: 0033:0x7fca6fc13912
>>
>> Create mmu_rmaps_stat debugfs file only when rmaps are created.
>>
>> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
>> Tested-by: Vasant Hegde <vasant.hegde@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Shall we put the check into kvm_mmu_rmaps_stat_show()?  As iiuc the rmap can be
> allocated dynamically (shadow_root_allocated changing from 0->1).

Yes, that will cover the above case. And mmu_rmaps_stat file will be empty 
in case when rmaps are not allocated.

Regards
Nikunj
