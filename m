Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693003C912B
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 22:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240445AbhGNT6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 15:58:37 -0400
Received: from mail-sn1anam02on2047.outbound.protection.outlook.com ([40.107.96.47]:29886
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240580AbhGNTxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 15:53:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr+bMUzjSm3sRdQUS54rLXoq8Gr/eubtbiX3Mn3n1su3G2rE1TM8hXCyLV4lgPM4cWQdv388uLNSJPMXYn3hSS0cIwJNCAcVuk5oUAen3zYKIKdUE/TcXfDeoJP+iWKk0HyT/JbwGMODVp8CuLakqQFAOJRvftkwe1Xchgi3sVFV/YFb279o/Fk+dMhqTT2nAKjZ4KLyBaSr0aPvd7CqUOBK4hA9tJoIqb4B++e+ziniIflmrK2cl4fEc7/LDl7iRtkIi2wqJGxSBFkVkS0HK6OpJKCfVAsDpTu5nEWfDjapJlJShQK5TYFYKuRkM1xSGADilm/Y1ai0ktLjCCJT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZXM5A26M5hioeJZvubsynGOXtDJBQzgJ8xG7ZIPPjI=;
 b=hc5AoU+DZgCQeeCzOohBGYylmSILwgmBeZFp7VMsB08P+XxUGbdqCX8Mgcs2o67Drc1ZryaOM6cKqwzVwDRQEkCRZybOSJQDE6NY58VVJykG2JY8JDsZgZM2V3hWLG/LbTQY0ZRvMpS5AI7E9hv1I8C95gMnnkG/pBe9RqfnVSoW650DSqsJF8YBuAF0oWWSA5VGH8rUKLxxU2QTWnmwd7CyKFToll+AEd4+WWoxHTBU7noTBek/EicZrTCr6OlH8ZgFlieNvnL+lne9m7GKtBZeMBO8w9EtFN8+O1IraJdjR2u9kzTERYDhyRUzpalA2Yw+eaoJXgZeL+OpSz9EEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZXM5A26M5hioeJZvubsynGOXtDJBQzgJ8xG7ZIPPjI=;
 b=WX5o5VGVGKdkIHIZI0fqf+wDX5RGc0EisjPhUUSMEHeHMaWphKnLpIgVuSUmOFamSQQnqhZ653fj+6EJM6N4G+EnnLZDnTF2xNwGdnAZCEK+fZyrhRU/aPpUkHatIP/cfLl9hFEZ860dD8j+0OuzacebTdwOMg3aoWWyv2lDgnw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:50:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 19:50:44 +0000
Cc:     brijesh.singh@amd.com, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 V2] KVM, SEV: Add support for SEV-ES intra host
 migration
To:     Peter Gonda <pgonda@google.com>
References: <20210714160143.2116583-1-pgonda@google.com>
 <20210714160143.2116583-4-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4ebdf788-8296-67bc-9841-d4753edbe7f1@amd.com>
Date:   Wed, 14 Jul 2021 14:50:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210714160143.2116583-4-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0052.namprd05.prod.outlook.com
 (2603:10b6:803:41::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0501CA0052.namprd05.prod.outlook.com (2603:10b6:803:41::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Wed, 14 Jul 2021 19:50:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d20c24b8-9b92-4272-196c-08d94700aa9d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574421FFC3AA5CC570FA1EEE5139@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4B9s1beFptYrVKLl4NflXxaCCC880ryhidWGCTG6sCcL4LME45UhKFPqoXz2LVm4JclPLjx7BlsTJpTBi4fIWevjFUwjrp5Hj7ebTFqOLn4zXP2lx3Ob5xjGqbPwjFEJornIFDjgIA8/xFVLwWAyFJSPIZcqXvVHssrzAzwKqxbRUxi2f7J7/Z38j2Q2BggoeZ+pGddtFH76UudIKCOSq7yOU0HDYdn5GPenQv096gqvk/ipq4VOLXQzsKq5n8j4LgRKt50qgavasNMHYUo24Xprk3NNmb2h+4nPg+v24n3mLwWMBa6geCpg9rNUggp4XXMEZpdT57LZON0f+ePyzuvG+Sd26uhf+LiPgVnmfHB/TL6AYqdZbsPp1EydFkmWBs5EXfEzsxCU6npqMjsdIe2F7f7omVIvHQ3lfwUD7OAitZOLpP8cNeKcq6O/Yc9PsilS2P0yRdTIVlchzeAAguRMneBPzro6OX1R3R3LZBVC4DRe2Zo6PBiuWEM4G4CB/HC4FKeqL0al4idfefuAiBltiEz8nACZacl8pLj8CqUgFlc162VTDTa2P3G5gryVTVTyV5Dga88AGhLI3rGbBoNYi919U+rrDoOVKK2VS16n6SkpDN8JKXAKKcwPQlinRkKeRwyAAlQn9FVn5CVO5Praz7eztdGx4J6RYf+0XtfKPlwdwqMQG+R1BTS3Ng4zaaSpfM7kNDq8B986TpreM44yts5RmHqSFcQjGRavacafjidKQhyQGXf2vCcf2nRYFzPEaLCshXFJCoKQ3oxtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(6916009)(5660300002)(2906002)(4326008)(83380400001)(316002)(31686004)(44832011)(2616005)(38100700002)(956004)(38350700002)(8936002)(16576012)(8676002)(53546011)(6486002)(7416002)(26005)(66946007)(66476007)(478600001)(54906003)(86362001)(31696002)(66556008)(36756003)(52116002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1ZGRTdkSkhlWmpoWUVKVVUrR1pvSWJTNlk2dzdnSElYZGV5RXBaZ0JCTFpv?=
 =?utf-8?B?OUVtR2FzbGpSWUpBSGVqalNMc3VUVndrS3hQM2tJbG5kcW9jaERGYjJ6bm9Z?=
 =?utf-8?B?NFg2ZW92VE9HaWYyYkFPZXVUVGsyZGQ5NVRRZDBsYVRadVUzR2F2SDg0QW80?=
 =?utf-8?B?dUlmNHVkTXpRKzNGVUxJckYydzIwNmZRODBWT0tFb3RIUUgvOXVHOUJ1RFlr?=
 =?utf-8?B?blZLbU02bEVYSUp6cnlRakkxc0QrMzZPL3VvMWxMalRxbFMzZ3lFZFZTcjha?=
 =?utf-8?B?NEJoZGd1eVd5N3RoMG9NWVhCb0JobDNBS045NmUrRUVob05uSFJsd1JlRVN1?=
 =?utf-8?B?UUpDYTV2YWJXUi9Ub2N6WVM4Wk5PYTZLZWZWVTkwaDNuYzZXUm5ibHlkR2dh?=
 =?utf-8?B?YjdkNDJVZnhHQ0JvUTI4alUvT2pxaGhHMmUyR1lkb1JZZS9LbHV1bVZVMG4r?=
 =?utf-8?B?Z085d2hsOEk5dm1uRStTVnVZTnZKTWRQd0V5QkFJbzl2bldNNEpYMlkzMGlu?=
 =?utf-8?B?VmozZlUzOXZwTkdOelY5b1BPdk1QSllDb29ldVpEOGlWeU5TTTg2dEhGR01B?=
 =?utf-8?B?RVhCbXRKbms2alBmUGdzbDBuR1dEb3U4Q1piWVhOWS9KajlOR0F1azA2SXZG?=
 =?utf-8?B?YVd0M1FlY3pDb0FyVnJoZjZPdjhaeEJ0VjIwOXZ0VnZuNXpaNnVBeE9WOWhX?=
 =?utf-8?B?QWpobEh3MS9BVk5SaFl3TEhnVk5qNTNBVGdpdzNGRUVPQU5FOEtCZmljaDNF?=
 =?utf-8?B?Sm1vaHNCalRHZmdBRndCQWtJSHN3bDM1bjZnN3hrYUlmWjh4MUJSV0lRcjVs?=
 =?utf-8?B?bDJaWG9oM0RtOG9Jd2xFUHFFUUN3NU5Qd0NPQlpiclpsRDZPbGlmSUcvTkVK?=
 =?utf-8?B?MWNud2tUS3NYYVA4QmZuOEhUY0hCdnp2NDRxbUl6TS9GN0RZZ2pvOXJoYjdv?=
 =?utf-8?B?Nk05NDAxNDdBZmZkUUR3cGIyYWhYYkdDR2xQT1RseldJV05DVXRCN0N5WjBY?=
 =?utf-8?B?T293TkIxTTFFOHFXQmhhUnFueHQvL3NFY2JsSzNmS0xieExIVzVRUFZZcGRh?=
 =?utf-8?B?OWxqcHBoWVlkZ3lhWTh4c2FoMVl6cnIwUEFGM2tQMVAyZVdMaW1hcEhlcnAw?=
 =?utf-8?B?WHoxdk5lUHNya1pyaHFrMklnRGJqRjdjU0RYMXVtTmdvL05uRmhSQ1FORHMx?=
 =?utf-8?B?SVNiMVhJeU0zMHVTWVBnY2pWVFJEbitYSC9RWTBNaDhjWTBubFJvakUwMlFO?=
 =?utf-8?B?UkVXcmZ0SGMyWGdVdHVZSW5uR2ViaXZzQkVwMDYrYkdNRWptK3Rlc05ScWx4?=
 =?utf-8?B?N2dkanZsdDJ2cklCb0ttb3E1Y24wVXU2UGdKSDI4ejBpMUo0dkRmY1NpaElp?=
 =?utf-8?B?NXdTdVQwU055dGtlYnV2akFmekhMai9MUjlBRlhyTy9IL2dzV0ZBblhpVjNq?=
 =?utf-8?B?NWREdEM0VVlFdDY3elZlbCtPNHlqeW1qVTF3WTY5b2pwNEhXOHB2N2Z6eFhh?=
 =?utf-8?B?ZlVJSS9yMlRJQjhvWlFnbWdhNG5mOUlOc0FSMVhrd0dNM0VMOUtIK0ZSSmda?=
 =?utf-8?B?ZTlTY29uTHdWVGRWTzdVVTRxUGdIRlMrUVlNSWhwSEw5WGtyNFozeXFZMFlK?=
 =?utf-8?B?SkVSSUkyQjBDWTlBQkpRdm8rSFpCdHE0VTg5TmhXTFZNV2hlOVZHOVp5Tklr?=
 =?utf-8?B?QVBTbmc0K0JlaUVCeHJIS2paZ2dHTks4RFVXSHB4YXVMcG9maWV5QkI3Smx5?=
 =?utf-8?Q?3Ewrol+1hqH5JfBzbjr5HwRw+nyvW9bAhSQXtBl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20c24b8-9b92-4272-196c-08d94700aa9d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:50:43.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrdWvZjXeHrVYj9IUHSpYYHFy0+lWMDlou+VubZz+zQNO/WQcWB2ChOe6HwqWLLi/jgc2/ZJae0eX67MgnBYkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/21 11:01 AM, Peter Gonda wrote:
> For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
> and other SEV-ES info needs to be preserved along with the guest's
> memory.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/x86/kvm/svm/sev.c | 142 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 132 insertions(+), 10 deletions(-)
> 

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks
