Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2BF49E788
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiA0QaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 11:30:06 -0500
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:49281
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243733AbiA0QaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 11:30:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1TNDyew9NlE8izCxbtncz6MTAXRaq3gSarNRmh/n/0miDckyS7anQ36SiT4lOLD7i9p19nH3UkYRQfW+m5BhjbGN/2mJ1h1wGooROBvUbglnQgPQdRc+7c8Bk7bROg1ppLE4UDa8xfJoUyMV7W0fqiYVRdn0Pq4HbpMSvnSsgcQYA/Aujb0nU0Y7rM+hVdIcg00YYepKf4wTO3f1RYlkpc+7e0xkaSfDlL4zYCIoBz5uAHQr8p9yX9lidy6Jh1eo1aicik6Jmp64WgZZ3/HXwweAQz259MyqaMdjlDj85RbH5hk6l3iMeiXWLUwRSDY15eYdGzKZg+YiltufkoyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTCgOX3RikiQI+E4bhO8j8beESP4amrizJWSCE7VWng=;
 b=RjfaDocDUh9auDR7+Akusy1vnoSHS/4tDIzrbhIsogFzDTxjDPGoHrgLCuRFqZPsKOWVDCXacgGZFRHePa3SpYE4adl6M2rm4PjEHSG6z6amn6MRDHAvKgzLePYQYvTGaOjedjRUjKjQxNP1w9YiaIW00NVtotZQe4jlOTwuqmqBSaqkAgsrexXRCPwkOjxIG+ihJhi+ryQbBU4e3aFzMM9P1PgukuTIPY8GzD7fqv+ZOYrUxu0f9Fr09u/q1p5SiuuIMQeU05DQFxYpD3FBc8r7MNbZY+Y26JL4k/6Rs2FFB3PKG6IWanchrnIGLuZE3Wep0aYd6vwy6WN0ix3vBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTCgOX3RikiQI+E4bhO8j8beESP4amrizJWSCE7VWng=;
 b=YWIF42mRCev29DX8aCpbvH/kHHqycJSTG16/nsOY2FQjWB5ZBBhymVV4ALRvTEhYL38MZja4vnVvwxO6ltZvikhpqvhutMFCMywbY5dXs1ODthvf+W4jAkNTXoaZV+2A47nYk9PXH/+We+nqgTMAxy4FMihTNNNl/KJccWgc2TU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BY5PR12MB3651.namprd12.prod.outlook.com (2603:10b6:a03:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 16:29:59 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b%6]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 16:29:59 +0000
Message-ID: <efd76cc3-98af-f70a-74e6-f15f84fd927a@amd.com>
Date:   Thu, 27 Jan 2022 21:59:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
 <CAMkAt6rxeGZ3SpF9UoSW0U5XWmTNe-iSMc5jgCmOLP587J03Aw@mail.gmail.com>
 <04698792-95b8-f5b6-5b2c-375806626de6@amd.com>
 <CAMkAt6rCU3K-dk7edxa9iKrOZ0uh5442K0U5Fbux=js0q6qQ+g@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMkAt6rCU3K-dk7edxa9iKrOZ0uh5442K0U5Fbux=js0q6qQ+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::13) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52c56b82-fba7-409a-af33-08d9e1b242b1
X-MS-TrafficTypeDiagnostic: BY5PR12MB3651:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB365131C2A56DCACCC51C5F75E2219@BY5PR12MB3651.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39kHOsCLTwFiJeiGTqCXhfdE+6eVL++paTmdjAE7G1w4X9W8BfTUb47bVlRq9XyLPtb0b+ATJXKVKQeugQ7HSrKstmGHOdWOFr2wm/5tB9iC82vMBSnWhska01HpMSHuwqSTsvcXh2lUEVaVyKKOS6PMMN9PcnMcB8RPs1ePmNkgqgYb8bIn5XA7TZBNY6azcJbPtgtVk1mRnSnmsH/VQgeANiKFAiUqXM2S3TipLQxlg90sqYRRVJjzXrJrD30dXveBRDb/F/RBxSN8/XRIdMcUw6sVNiVLmnPu2T39OtBcF5m7qy0a0lwiKobcvRrfCVWNnehWAgEiCU3Dsqa4PY8gykx2GYCoGQn7J8KrKViwMeAYYKbke4kej/pT5EuYZolFaqOmozHTUsdoKuHlTe+F7rreTNKDqBmcAM11GdKgWKtGBfw+Sb3xWtDH39PUkrYzMfRLw6NNVC+npjd8/G6NOMkG07Y4KrTWMBk7qg25yqQtigS4z5WaiZRershKnZNLSaBU12SnNSHcyRphYl5whPWq0ihSVfb8oWRT+Q39VbIH8E+24hl6WbcUDchIiFM8kpMwVzNhLenr0KO241b5Kpk+qyN9DfBrqiDH3FiG+pkIlnVMBGKpehtPGhUuK6LfI6dFmBKk/i1YT9jvgFmhQIPIvHtQxb9JTbdlRxyTH1b0mSrUjcJAxsnwzizwmvjN+PvSbLefgXpu3cJd2sfyjMBmzrgqrrp0g84r0Kg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(6916009)(316002)(508600001)(6666004)(54906003)(31696002)(66556008)(38100700002)(4326008)(8936002)(66476007)(8676002)(66946007)(6486002)(2616005)(6512007)(2906002)(5660300002)(6506007)(31686004)(53546011)(83380400001)(36756003)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0N2UVFNT2ZzKzhkclc0MHFuWUlWcEhzTWVZZ0g2aGN4YUJVNEVQVWw2R1pG?=
 =?utf-8?B?Sy9KTnZ5QVRxYlVyd0VkSDAvLzFvS1hvQ3hVT2xVYUdEYVhwNTNSNjY4QWZv?=
 =?utf-8?B?ZHRHVTdhSXRMSXRiMTgyR1pBT2kzZ0hsVHJ5LzkrRWUxMDJWc1dGTEhDZmdp?=
 =?utf-8?B?cytxN0t5L21HNTRybnUwS2JTR3dMRU9UV1ZRT0wyd24xN3RjVWlqRGpOSjRH?=
 =?utf-8?B?Wm0yWWtOQ0I1K1pCM09UZHlXVVBwM2ErcUhFZlR5TVJTeDRZV2JKay9hZXVI?=
 =?utf-8?B?aFltVk9MQVJtbWVxK3ZJbzhtaUozNGtoRkx4Z1k3Mks0aW1KZEpQWkd2Y0tX?=
 =?utf-8?B?SkJRdXpBQWxXbkJsQUROUFduUzBqdnEzcnUreUlXMmg4UGlFeDFUWStqVk1L?=
 =?utf-8?B?RGk4VU9XNlRWZmNjMnREdzVvQlhXakVBK3V3Nmx5WERzNE5HQmFpbjhMc3NU?=
 =?utf-8?B?NG1QUjg4ZHpVM1QvdUx4NDhyc2NRbnFTdEwyaWQva2FvcWxiSDczNU9ZU0dF?=
 =?utf-8?B?K2pzOU9lVko4aEFZaitxZkhCeWdVS2RJOHVDSUw5Z0dGM015VHEzekR2UTBJ?=
 =?utf-8?B?eWFnZlZDdkFJRzJaSUd1UE1pK1l5WmFWaDZNc0IrcFRGK1dyT0tIR21LekJV?=
 =?utf-8?B?Z3ZNZXNjWVRGVmJuYVRPK2ZkT2VjNlZjcENoRTk5OVpQaUdEODg3SUJzcWov?=
 =?utf-8?B?Ui9rcTArZ3dxOGxyVG10NEJ4NkNRbUZNVm13eU44YStqbUZPSmpZdXRUVVdu?=
 =?utf-8?B?VkI1ZUhmTXVnQVNhZE85emtuOXpBVktiM1lUMW1XbCtYeEdycTJqMGZCL0ty?=
 =?utf-8?B?ZHdPQVRZcmUrQ2U0ZThyam14TVNwNnN3cDFLdWVWaVRHREEzcmlZL1FsdVJG?=
 =?utf-8?B?WlFUUjNsQ01yNXA1YlgyMnpDRDZQWUhaV0lFS2ZkbHhlSytlT0dPcGhkMjVz?=
 =?utf-8?B?Q0t0SFFmY2tCU1J1Y2lVdEJQdEtNOG5PQnF0aTdpR0o1bDlBQ1VBdEEwMWs1?=
 =?utf-8?B?aEJwODlVSTMwTlI0RUc2UEVzaC9QZmgxM3JXVmxhQzBJOUxHcVhUR25zbFFh?=
 =?utf-8?B?YTZYUDFMNkhZcEx6ZUtMckpzelJUbmZWS3lVbkdsS0wvR2l3aVFzSXlTUnMz?=
 =?utf-8?B?WWhBTDhwVEx3Qkt0bm9ORFk1V2gxbVBrbkl0MGxJLzJTOHgyN1V4V0FXek1t?=
 =?utf-8?B?Nk14dGZXdWxQK2Q5RUkrQjVBWk1sbkFNVjNIZTViSFpZVk5NVFhMa2NDbEVS?=
 =?utf-8?B?QXh2azc5WXpYRWV4ZVQyd3NCcm5zOTVHc3RoUGpVaEJ1ellDSmpmbXo1SDhs?=
 =?utf-8?B?WUpxem1rWVZjWC90eVNNeFIrNXRreGFySmdpMlBDRC9WaHZ4ME9Ldy9TaUFx?=
 =?utf-8?B?TVNYeHlDUzJpZkVSS01mNmlWdGZ0WTZlRWdCQlF1ckxwMTRmMTI3NGFhS3RB?=
 =?utf-8?B?NURGaURzN25lQjVoRDVyY1lJb2wyQVVUTXpid2ZNdGNKRmUwTDN0TzJITDBk?=
 =?utf-8?B?MEVKU2s4TFo0SkNwR3kzWEJ6aFA1aUJ1UldGQlBPVWVCNHFPSzZBcWZ5N3Y3?=
 =?utf-8?B?S3VBRzdJcE5sZWEyUm15ZGI3aHcxRFFKTCtURi9SU3FzbW56REs3em5YUm01?=
 =?utf-8?B?WGs3V2VTNUpXaXJqZGh6aG9pVmxLeG1aOVhjTWphcmJKQlJ1bTRySE1iZFlZ?=
 =?utf-8?B?TEdsWWp1em1mUU84M3NJNmxYUkp4YytjVloyN3ZMQmM4K2UySU1KS3podWxm?=
 =?utf-8?B?UzNvYk9FdG1Vb2p3WVc3WUZlZjJCTVVJcXFWVWIrZ25FQ2ttZlFnUWd1UE1Z?=
 =?utf-8?B?OUVPWG9zak5BRVBhZ3prRjR6dGlwZkhrNGtoK2paRjhrVy85b2ZKSWZXTlk3?=
 =?utf-8?B?czJ3UGpmdHlHUG1aUnJVRm9tR0RlQXdrMElyVzU0M2p6R1VPS1hPdCtNdE9t?=
 =?utf-8?B?WUg3NE1ya2lOdk1SSzhBVGhZVmhMa2p4YlJrc3hxUFlLQ0taRUg3YitsVmcy?=
 =?utf-8?B?cHZPcEU0WGRvTnNpcnVBRlFIOFV0ZWVsRXRBUUVnbTZGTjlRS1FQRjYzbk1y?=
 =?utf-8?B?TE91NmtVdnNwSHljamhtVE5PZFpoVVoxd0F4bWhKVTl1UDFSWFdCa3RPZVps?=
 =?utf-8?B?YWlnOEkxeDNydjJKWGVSaHBPL3FVODhwT0lvY1lXOUV3Q01xSm5rWkVUbVpL?=
 =?utf-8?Q?U/PxHJ1qaUXxDETVkJslVDg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c56b82-fba7-409a-af33-08d9e1b242b1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:29:59.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UN4gBlaL/uRrEtlsUNM5aSOP0Udlbl++bPDgQZbFrROg0nRVJLZiZl1HxBfBRmpT1BUzPhWP45cMgCIsAUFWmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3651
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/2022 11:29 PM, Peter Gonda wrote:
> On Tue, Jan 25, 2022 at 10:49 AM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>
>> Hi Peter
>>
>> On 1/25/2022 10:17 PM, Peter Gonda wrote:
>>>> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>>>         src->handle = 0;
>>>>         src->pages_locked = 0;
>>>>         src->enc_context_owner = NULL;
>>>> -
>>>> -       list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>>> I think we need to move the pinned SPTE entries into the target, and
>>> repin the pages in the target here. Otherwise the pages will be
>>> unpinned when the source is cleaned up. Have you thought about how
>>> this could be done?

Right, copying just the list doesn't look to be sufficient. 

In destination kvm context, will have to go over the source region list of 
pinned pages and pin them. Roughly something like the below:

struct list_head *head = &src->pinned_regions_list;
struct pinned_region *new, old;

if (!list_empty(head)) {
	list_for_each_safe(pos, q, head) {
		old = list_entry(pos, struct pinned_region, list);
		/* alloc new region and initialize with old */
		new = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
		new->uaddr = old->uaddr;
		new->len = old->len;
		new->npages = old->npages;
		/* pin memory */
		new->pages = sev_pin_memory(kvm, new->uaddr, new->npages);
		list_add_tail(&new->list, &dst->pinned_regions_list);
		...
	}
}

>>>
>> I am testing migration with pinned_list, I see that all the guest pages are
>> transferred/pinned on the other side during migration. I think that there is
>> assumption that all private pages needs to be moved.
>>
>> QEMU: target/i386/sev.c:bool sev_is_gfn_in_unshared_region(unsigned long gfn)
>>
>> Will dig more on this.
> 
> The code you linked appears to be for a remote migration. 

Yes, that is correct.

> This
> function is for an "intra-host" migration meaning we are just moving
> the VMs memory and state to a new userspace VMM on the same not an
> entirely new host.

Regards
Nikunj
