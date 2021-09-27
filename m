Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5B419874
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhI0QFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:05:48 -0400
Received: from mail-sn1anam02on2089.outbound.protection.outlook.com ([40.107.96.89]:4967
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235261AbhI0QFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:05:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCcxoaXkDNa3CEGiIrLk8NCdTO7BM1OGbCqOksIUm50aINoNAd6DfxLfBVrWzdxqQ1AkCwINDrYVuANbJ/XSr13B0L67cusqNMf+hDMdxczE3AEAbNIVrPt3fL0REYEaN/t/xo0yOog2ze/g2hlQDMQgd64x0KrWa8Dzqnvy8lRmt0wkTNlXbuB2MgP0ZtUpkPKg4p6egxR97S38qcivtHr/bUtOokQsZMNE0jaqLGZCR5/C5/LVTslgRA2GRWevYh6OBG9vyEJ6rutwB3PvyxCWXTHbPhH+06WOTN9/7V+yg5Tyb4E+5n/TY8gUrxLEgBZNbn+EzN8WFdhxlPGZPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jfk53FNlp4UnIE/yEHdVmB3rVpYQ6cn9NpDbB/zmzF4=;
 b=QiUvbJBEuzfn8gWTkWPn56HGgLQKuxiIvSP4DwDch4s4SF6FY6ebyB+4fTEVDPNUJt7sBC3bythojW0iGhZSlp1UssL/qDNy8R/60ALTbIKbuII0aKr2kI8KYFbj92kmjGxpq2TOID5dcuSIgM3Nwgqve9kqCqor00l5b6i1OxG2EH3jkGH3rMQG85MWat0rybz52nDhd0uULw802B3WRLFFLwZ5607YciRuUHLVJUumrGMJtj3fZf9J0nHatxP/do3olgkRFgUtM/HhzkxpjEdgWdoT/nvrnBQhHR4SuIP45rDp4N8R87B5462aqcmTZOVwTv34mgvJVkHhjKwgmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfk53FNlp4UnIE/yEHdVmB3rVpYQ6cn9NpDbB/zmzF4=;
 b=JiUQLhlO4kpwuuYZQgzgu4xqZrHzc3Et2zct0obUz+YSK67ZOzzPB9wz+Wv5tx3HcG1xKddgWqMhcaCK+w3vxOloH3+N7NkCV2GrEo3yNqnIg3DQmfdOT4iM6fdSOWp7LboCJsu2b0VHH+QcCVvwg1ANPYkoOAtxtMhQ0h4uTqI=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 16:04:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:04:06 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
To:     Borislav Petkov <bp@alien8.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-5-brijesh.singh@amd.com> <YU2fQMgw+PIBzSE4@zn.tnic>
 <a5be6103-f643-fed2-b01a-d0310f447d7a@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <2041d0d2-a0f8-d063-13c0-79b5bbcc8b83@amd.com>
Date:   Mon, 27 Sep 2021 11:04:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <a5be6103-f643-fed2-b01a-d0310f447d7a@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Mon, 27 Sep 2021 16:04:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ccd6905-d686-4949-8edf-08d981d06ed2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44951AAAA135D4A6A8E1986DE5A79@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMYqHFWuKSKbico8RC/LRZqzdDG3DekM9C2QQxe29hX4JYATKUZ4vfbMIUejuCNeAuXKWp9Chm7nm+9RPSug+pVIjdhzb/OqezUf9GBFktnP7+HQMKv06Kvy6/9+/2ukJpzRJZ7wTv/i50nlZifZtinoa8/szUHsfB2tvlVPtjQZceQ8GR40HdUMF74d1eYGhglMu3cDgMyGFvYXOU0B/+xWnIq8wPXboJr/FWDLUKk/FbZ0xBYHEJy68OUKyiE70JjwEDoJ/jDh5R/yvP9eveIWV3Y28Bjnqfe070Loa8zbnEiyMH7jrV2ngvtIQBZ5fK0AvV1+koWFPu8qfHftcTiu8bMVIOENtM4sTtLMb0ADnRJ5GflBjZgjGnACeaOVfgkmloo7ABY/P8Iwh9+izCs/I4Ut+u/+dYdTeE4vInXs4oesjRfW7jMAQVNn2px6S3NVOgiilgfc3tkoeSGofiXlKn7aLJJ9wDzLuJnLdS2TFnZ18jT7XycX+KuW71tRdAxsPqCFn7BaGD8dDhYAanGBKdxV7QOF2rknX7qQRnCV0JnfqIy49HF4KiIoWtc09MgeHbFS9I95IIba4Mj24hBaSqJ4KJAiBQlVweN05BGkw0LUGOZV/tOv43/HVRrliezPKWChCmzOSBtaTfSQdrU8c2ySOD0+ncHvrvMn71r5KQ1vfdlR4+6eSnNM9bKyE7ol4nWA9DClpfyrjdOUvM7A1u55pp3IgbO8sy3biSh7H5WbO91ErjyXQKRjLQlokSXqiF31yeH2ptDSRU4gHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(558084003)(6486002)(7406005)(31696002)(38350700002)(7416002)(53546011)(38100700002)(2616005)(66556008)(2906002)(66476007)(956004)(86362001)(52116002)(54906003)(36756003)(5660300002)(508600001)(31686004)(8676002)(66946007)(316002)(6916009)(186003)(8936002)(26005)(4326008)(44832011)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2drVDZwSGpnYTNacnpmMXltN1FMbDRqWTBxNlR6TVhHKzFTcEsxZFZWYjdo?=
 =?utf-8?B?RUx1K0dtSGo0K053RHg0ZXFZaktzcFhKcjRaNlFHb2FseGF0MnhtYW1ub2NM?=
 =?utf-8?B?dlErZ0VUSi8rcWJoRjRYb0hkTVZHMER0aVdrM2Z1cmM0WmRoc1FzaDh5OFhG?=
 =?utf-8?B?N0p4VmtjWU9Lb0FranJONkc2SHQ2bWdxeG0rOUsyeldZdlhCeXN3WkRqaHJN?=
 =?utf-8?B?K2VMcGZyOWxGNTNSWUcyZUpSRVQ1WkIvL1hEZUp5c0pHR25NaWpFZHZ2dXM0?=
 =?utf-8?B?a2k4VU91azVkK2pQRS8wL1hscXZWVzYyMDAyZGJ6K0VkNENCbzBOc2tDbTY5?=
 =?utf-8?B?VFZGZEQ4WDI2ZjNENVM5U09NR1gxVXNwTENnV0NhR1o1NW5ENjZoSXBYU1Rt?=
 =?utf-8?B?RUhwTWo3MWxwcU5RMVVSOWVlRkU0S1VkcVk3QjU5cjdRWi81YVFBTVVESXJj?=
 =?utf-8?B?ZFBwcmlvRjhkQ2hFYW5TeFYzblcxaU5pdnJDajdRTWNBNk0yckNCbkxxZXJI?=
 =?utf-8?B?UFBvd2d4N0ZJejIxQlpLd2NDNkdIcjZpUFJlRitvOXpzY2RmemVhVmM5Nnhz?=
 =?utf-8?B?V3lLc051VDJ4L1E1VkxWOEpuaWpoQ2ZCQ2t2YWNUVDErVElqaE9RTVN0eTJs?=
 =?utf-8?B?ZHRZNDN5NUxXYXE5ZXdxQlU0YUlYUWxHRzVmcXdXYWZpeHhQeEhKZDZIbmFS?=
 =?utf-8?B?U09UaGlrZXRubTNIRUVTdjUwM3BjOWJGbld3bHo5UkdmK3dwRmtsaTVDLzI5?=
 =?utf-8?B?S3NTdXZIc0haRk4yaEtBNFZDYllsa2FXUzdHeElVK0pHMGtCeU5LNmZRNUtL?=
 =?utf-8?B?M2lpeVNZa0E3L0hwb2MwWEFFODJneVRqZnhSNTVvOVQ1VmlUaHlnOXo0QVNZ?=
 =?utf-8?B?S2s1WW16a2lCdysvK2lldUNrKy9qYlY4ZFhIS1U3bGU5SHNBeWUzWXJNMHI0?=
 =?utf-8?B?ZU1pd3lEWXozc3dBSDVsY1ZreEtnenNxL3dLcm9YUTVSeFVuakl4bVpVYUFl?=
 =?utf-8?B?YkJ6MDNhVTRTVTdWRDNMMTVla3RKbjNRaU9VVVF2cHlqeGtGd01vZVZpN0or?=
 =?utf-8?B?eVowWHJEeElZUWFrY2dxSDZEOHdGcmkrWUtpLzNLaldDSXRYOFZac3hwZDRz?=
 =?utf-8?B?ZVQvbnBBVHlFZjZpdG9ZcnBHYXlMWjBJU2h5U1hIUGltQjgwbVNoSkd4cTcy?=
 =?utf-8?B?a25UL1JnSGE5UVZuMG5QVk52MjEwclo1ZDdOS1g4TVd5TU44cDlIRUxpTVlo?=
 =?utf-8?B?UG5jUTRyWXkrWFRDenY1c3ZJemhFZ21IaDR0VkRHdGdKMzFHZnJ3NVZwOXZH?=
 =?utf-8?B?OUREN3V0bFdlWTVxMGIyYzBaNzZrTkE1R3ZoSVd3YUpDSkkvb0xUdzQ0bW1t?=
 =?utf-8?B?ZnlXcW5teThIZlluc0tIcVFZL1FKSXRRMTVML2pYQUE0WVcyVmIvS0tFMjk3?=
 =?utf-8?B?ZS9veVJ0UjJhQWk5MWhqVm1PQ2tvVkRScDlERW93cm1palBZZzUrWFhjaDFP?=
 =?utf-8?B?dlV3Y21vUDE4UUVYbUF4NDFLMm1PTTlmZWVENkY4ZHh0VDFISFQ5UTMyWUdK?=
 =?utf-8?B?MzNoUzE3ZDNCM1NxQVR0YVZiRHQ3dFZFd2doeGRla1NMK2lYbHliZ3hOL0x6?=
 =?utf-8?B?QnZmY0RQMjBMRU9LbmlEdm9LaUsyTklzTjBkMW50dGI5eXc4WUROWFllVGZp?=
 =?utf-8?B?OUYvb3hjdktIYnJDT0ZqVHR6UnJzWXhRWE1YT0dkQVJhUndBYmtLK1lsL2hR?=
 =?utf-8?Q?U06KG1ZBMogIVWlgOgKrmyRdVcinO1cTJrAN+oc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccd6905-d686-4949-8edf-08d981d06ed2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:04:06.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vA5MWlW5NE881bVVFeNTeqduIwvI1iebIKYbkzAgug3AdgRvYziFTN8k7aIJxgYbbFo7zaJZdwjAEHApriV9nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/21 11:01 AM, Brijesh Singh wrote:

>>> -- 
>>
>> What is going to use this linux/ namespace header?
>>
> 
> The kvm and ccp drivers.

Currently, we have only x86 drivers using it, are you thinking to move 
this to arch/x86/include/asm/ ?

thanks
