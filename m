Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367B23B3914
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhFXWK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:10:26 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:14721
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229848AbhFXWKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 18:10:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfKZ36xp1FADBbmyeuZDSDTP6bQObX8RQTRAwe3AvmvegABRVdPz2xVJxwmOCpcEKYrmGydHgn0GF+/zO60Ae7WCbK6pzIzsfXRPNkb63yk2Vp8CYhw1KRYC7vI3rhiPgZcXasLMubgNlBbV1Rkjmw6D/mSkFkM5JCSIWUOO6Ajk/RXZmaghxNuNgwDsqkTYrBTz4itecrVO4NiBpTRkh5WJqdZ5FftS5sEl1fIhkTEKfz5fpNcnyqgZWp7fpdKEKQB+9zwU10Xj79hQh0rZhiTE4o87jm7owYYdhVfZ/u8zLCHVUxqmmo2yZdTz/q1pAffHgVOpGb13JEytHsPqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4pb0026e1CkxdaQZCDUaVnCxReRUswYVyTG0wl6ixI=;
 b=Wtf4p2ub9fXbqaRMnQSbChXCOuh8bMlWN84GUQqrUNAEJYOrqNvGyZ9V7uoIfqdREoBZkj+O7glvjwQ55UAQiNlwJsd2ko7EDlUj1idJaD05QGm7fz73xkVQ53Fn+VCT4icF8FXvm07zK/NJnNT20b8XOcqWF7J+luuMCHJPPvu+nzcTK/PCBfV3G+kM8OV4FtZnMHMKRRoBZ47PD+7Ki061GP/NkCXMVgj2iAOVsYHCx97tTsx2bTHMTt5yKw6wJA4r8STXO7n7PTiEeF/dUVve3mvwC71Dix6DTRWEtxSOI7vni7Jytf45uFUzs7BloQv7ShPa3UGKTaz/+4T03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4pb0026e1CkxdaQZCDUaVnCxReRUswYVyTG0wl6ixI=;
 b=Xm9zxVuYNJudsKdSaKMy3HrFU9GnfV3idsSuRRJS4iBgXByIdEh7RL5Ee9yDs06KLu2i6fXT9yUDu4iaekn1S6hF5rDE74Fj4xRdjfaPqzeSWhHXj/gDeAYHzmG+5UGUgixkJaoagmysFF3WzyyDEqJcNtgMHor+/VQdFOFGYlU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3468.namprd12.prod.outlook.com (2603:10b6:5:38::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Thu, 24 Jun 2021 22:08:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 22:08:00 +0000
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
 <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com> <YNTBdvWxwyx3T+Cs@google.com>
 <2b79e962-b7de-4617-000d-f85890b7ea2c@amd.com>
Message-ID: <7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com>
Date:   Thu, 24 Jun 2021 17:07:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <2b79e962-b7de-4617-000d-f85890b7ea2c@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:805:66::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN6PR08CA0017.namprd08.prod.outlook.com (2603:10b6:805:66::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 22:07:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32807357-bb0d-48d5-e80e-08d9375c87a8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3468F5A5B4D77B257B55A06DEC079@DM6PR12MB3468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8HOCXEHwDUvNugNf3U13i3yZLjeOhPVzRzUWXOBsSR1gnxSclvPVfSW5y9XfVC1rJkVJMrIIW9LPfAKQTyXdsvMmrpoapOou3w7j0AsS+3g/jytAqV4I1OAF23MNaXGZvs7gnZmi50W1lMNESYWK6YXIKUIFSxhAm4iWBcXaWCAUMQSLDBotlIFSmbNAIJf09z88P0+OPDsRlHNFUBn9y+be440uI3PtWDTG958uolYSVsylyNihUyae8ff7oQXA4ksTl2ILRdU7fab7UwY8hQfRHmnm9CrT9YrCDMAZZRsBGtpDqHXDwtpZBJIpWY/p37HTT5VTXb+wr4H6Yp8QWRoE0y/eeDXZIvu/z5cLRVUWPGb1NzIST9ZcOfYIMJWw/nJWzwLpIoxLQrq+u+yJkvyeXrhC/vYsAUxvAt3/Nb57qmI9ddnAZo2bz36dN9Rky7Lfc3/4xHptDZ8DOF+EkuNSbr1lKkm3STlCsR5hBsqMw6jKSGUhYWQpxcXNsN2nGWU6fjk2tv9ckQeUpUK+96ANeJUUdo+0EagYRhWIYDIsUKvXtraAUWoPyYijbPoHKBVmioV6kpYH/duvq0NpdR4fp5lECk+nRyL7+BspJ0gYzUY06TYmuvNUKOXf3tyMxFc0L2d23Q7feptc2eHRA5/RkqwYA4Gj0Zl39Q0526y3+ONpgGy8TN7HAHTFjYPxvilbL1PpCOqe5fyAw3y2xueWjKrQ1KEX0xrhauvgkQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(31686004)(478600001)(6916009)(86362001)(36756003)(31696002)(53546011)(6486002)(6506007)(83380400001)(6512007)(26005)(2906002)(4326008)(16526019)(38100700002)(8936002)(2616005)(956004)(8676002)(66946007)(66556008)(5660300002)(54906003)(186003)(316002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzJXTG5aV1BNcFY5bnNHNDd5enpoMTVEMUxTTzRqUnloK1NOY2d3c2tsRXNV?=
 =?utf-8?B?ckxSeVI0Y04wcFRVWjh2REJURmNKZUdTNUJ5U1gzdWpxQVErUVk3YmN3OWRN?=
 =?utf-8?B?ZFgzc3hlRjdqWmloU0QvTS9OeUhLT2ZNNEsrdVdlbUsrdThoOHVCVW9GNlZh?=
 =?utf-8?B?UkxST2hPMUl3a3AxWktMd05ENFJGeHVUT3l4TEZxQUNQbzN5OVBnbE9SR2pB?=
 =?utf-8?B?NFV5a2Q4VzdJUTA1Y3ppKytCTUd3SzN4S1o5YTZhZm0wVGZjYkJrNVVsN3Vl?=
 =?utf-8?B?d294OTJnUFVSaFkzRm15cHZMb0tHUmR6eUFoeGV0ZWNKZy8zV2RrZXI3eVF1?=
 =?utf-8?B?V3h4dVpnenRSTFpTSzhEbzRxbVhEOXNuMWxoSGN5TjJIYk5MSUNZbFhTVkNV?=
 =?utf-8?B?a0RpZm5VeUd4YXBTbkN4UW9UTThSZkR5K0VyZ3ZFaGhnU0xRWE1aM09FWUpY?=
 =?utf-8?B?N0g5RGNjeVdDYjNzRk9sTHRzVzlYN3dsVTl1cG4vdDFSdzFnREUyS1FSa3Fp?=
 =?utf-8?B?YlN6YithK2RxNnlTREc3QlZZcGRmVG1mV1g2QVBEUWRpUERicC9uVDNBbHNC?=
 =?utf-8?B?aHc0ZkdFTXdRYlo3bk1QQWFjYWZ4d3N4WDROWnU3L3NDSWR2VFV0WjFtTWZB?=
 =?utf-8?B?blp3YjFucDZ1eE9ER2IrVFk1eXJkQ3F6TW5iRzUydGxrYzZ2MHRva1B4ZERB?=
 =?utf-8?B?ZGZZVThCTDlxNUNqQVhpRmRMcm1MZ0JJL3VaYkJpRmdUNVJPNnRVUExlcUE2?=
 =?utf-8?B?RjVqVk5hcWcyQ1hhMEc4eWtHT2hLcFhNanZobG11Z2d1Yk1Pb2tNRS9hVHVN?=
 =?utf-8?B?UDBhSWkrMTBla0t5SlR1QnAvWEZnQVM1UCtXNkF4MUxZWVFvbnRXNjQ1ZzRo?=
 =?utf-8?B?emE4N2pqcDQ4OEkxcHJTMldXeElzTTEzWG1kbWFha1lQNkJYWWJjUE1CbWtH?=
 =?utf-8?B?cmFKZGZURW9NZ1BBNHFaYjI2b24yQy8rNUJHNUFPZTQxNWVlcmFsZHcvSTZI?=
 =?utf-8?B?MnhkdE1RYkNpK3ZqYjNpWW5jWHdtV1Y0QjJQcE9BMTN4OVNBT3R5d09BaWla?=
 =?utf-8?B?bVBBZjIrc01NMlVJRWIvaWxoTUdBOWtXbnJxSzZkZnRLL3pEdU4vM3hrMVZ1?=
 =?utf-8?B?NGpJTUkwNkQ4aGxKOGFneGdvdXROdTJYdGpWano4MEhiMW9sS1k3ZmE5TWpC?=
 =?utf-8?B?OVBhMmZUMk1JNWxVWnhhZnpRQ3NhNDRQbGlUcWdCclJHbjV6MDF3U1JJUkcx?=
 =?utf-8?B?WGtGVFBDOXdTK0Q5WlZsQzlxa29uclVEckpsbWY0UHB2Mzc3ZkFlMDByaU95?=
 =?utf-8?B?QUNBQ2YrQ2xMOUdRdGp6QW1LcEJZbGFxWVY3UUFURnliaGJSdlFSeFVTR0lp?=
 =?utf-8?B?Tm1MdlVUYVdmUjFZeEZyQSt3b0FFRHF3aWJBT1NrVVRhOENPclhnQjhuYnJ5?=
 =?utf-8?B?Nk8zZmNESWJnNVhUVklRbWdnQXAvS1N2WXZUK3lVUmhiWmp0SENaUlpESmQx?=
 =?utf-8?B?c2JKV2JBcytmMlJZSlhXMWdCMnF6T1lMbXNVL2ZlcStVUTJQNVhTaCs5LzBu?=
 =?utf-8?B?eFFZTjNidndyb29FR2NQMDJTQW5DODBpQ3duYk5MUUpFZUlsKzB5Vnh0M0U1?=
 =?utf-8?B?RTBtYlVNVFRUSER4aEFIdGo4SjJOL1dsbTVlMndWa3lUTUxCYWg1NmVUWW5C?=
 =?utf-8?B?UjhJcjZ4YkhuNnlJcFRlOXl3SG9FNGp1WTZndGc2ZnU4ZERTbCtHTGNtM0xh?=
 =?utf-8?Q?OWRKFif4kte96zcR15j6PJufThNlB64zZSdd4o8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32807357-bb0d-48d5-e80e-08d9375c87a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 22:08:00.3957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +s+IBJr9ukiCHdZEYh38k7Lln4xk1JLPX5rV99z3vvFBt2nrRsNFn9CJ7cgrLv0vktuylJlf/M+1mIMN8ggnhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3468
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 12:39 PM, Tom Lendacky wrote:
> 
> 
> On 6/24/21 12:31 PM, Sean Christopherson wrote:
>> On Thu, Jun 24, 2021, Tom Lendacky wrote:
>>>>
>>>> Here's an explanation of the physical address reduction for bare-metal and
>>>> guest.
>>>>
>>>> With MSR 0xC001_0010[SMEE] = 0:
>>>>   No reduction in host or guest max physical address.
>>>>
>>>> With MSR 0xC001_0010[SMEE] = 1:
>>>> - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
>>>>   regardless of whether SME is enabled in the host or not. So, for example
>>>>   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
>>>> - There is no reduction in physical address in a legacy guest (non-SEV
>>>>   guest), so the guest can use a 48-bit physical address
>>
>> So the behavior I'm seeing is either a CPU bug or user error.  Can you verify
>> the unexpected #PF behavior to make sure I'm not doing something stupid?
> 
> Yeah, I saw that in patch #3. Let me see what I can find out. I could just
> be wrong on that myself - it wouldn't be the first time.

From patch #3:
  SVM: KVM: CPU #PF @ rip = 0x409ca4, cr2 = 0xc0000000, pfec = 0xb
  KVM: guest PTE = 0x181023 @ GPA = 0x180000, level = 4
  KVM: guest PTE = 0x186023 @ GPA = 0x181000, level = 3
  KVM: guest PTE = 0x187023 @ GPA = 0x186000, level = 2
  KVM: guest PTE = 0xffffbffff003 @ GPA = 0x187000, level = 1
  SVM: KVM: GPA = 0x7fffbffff000

I think you may be hitting a special HT region that is at the top 12GB of
the 48-bit memory range and is reserved, even for GPAs. Can you somehow
get the test to use an address below 0xfffd_0000_0000? That would show
that bit 47 is valid for the legacy guest while staying out of the HT region.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Thanks!
>>
>>>> - There is a reduction of only the encryption bit in an SEV guest, so
>>>>   the guest can use up to a 47-bit physical address. This is why the
>>>>   Qemu command line sev-guest option uses a value of 1 for the
>>>>   "reduced-phys-bits" parameter.
>>>>
>>>
>>> The guest statements all assume that NPT is enabled.
>>>
>>> Thanks,
>>> Tom
