Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9DB494668
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 05:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358414AbiATEZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 23:25:06 -0500
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:36712
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234353AbiATEZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 23:25:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AouAUY3FPCLWRb01BTOKMAQr3Ezv1jnj5iOJAotaxpLlV3Q+H/7bidfUqABuSHDTeMPk3WaR9b+Yo4LJpG3zYyfAMyw7o3wjlSMyWPSlBvI3ehiRcw873uQIoaUEkU2pdFp+hz1PdCxa0aOsleKQyNdXtoAkT0EcYeJdkXCBu9umUxkkb8TRUzKMb4D0nHK4ZaR4TqL+TfPx8HY4+YtXrFJ6M+8ZaT9efI1uP1tTlkpAMbXEe8n+tYJEtWnYNeBWol0GHdDfLRM2GyuKCnjkEv15+HqGpWBfz3gG/iYyA9bKTebt/Z6FEhDbGTXAcyeVWpNp+g8ksJVVpikeOp2ztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0KP0R2meIsXuf19q67U8KPfPCaFzzYnIZSVs5MaAk8=;
 b=aifIMUuC6+2Kro3GKAd9r9NR/QmyvzjCyh12wfluNY3ULKZAhtjctnj7T/F0e6mOINfi/jVnbkd5HcTfi5bRJe1trpN70/XPG1q8A3E6RLqWTC4RGjKKLZ+WSggw5Rb89fe76ESZaYoNwgYQ/luWFHn2E2+fq2RLm5cM+nvdPcFv3vLutsWnhbpIuysY0AmqBe8bzo9xZlUjMRXKVthpkTnVdyMQgAF/5CMJ4SDJHXiAuktXYVpe5a8uOD2uZsG4Vol3KiLeZnh8duo564CFWIfXCse0V2y/i6ioj3xuttNXQ6FB3LnuqBSnqM6DbAsVTzT6SOKkkGQL9CRPlSoLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0KP0R2meIsXuf19q67U8KPfPCaFzzYnIZSVs5MaAk8=;
 b=G8y8lwJHqW8TPAwt6huAD7Kcw4UwOOBDGMAGR6wHkEC7rCzu55zg1OsZpOwfQLuoHZekcHCzHwoMLczlHfhU3qGqm05ZYY8i3a8oW6JeH1aVYbTYtE6thrb4xxX5wPxzMsKp3munOrXdTYmP0+GJjy+RS04/LbjToKLNAsl37v8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Thu, 20 Jan 2022 04:25:03 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 04:25:03 +0000
Message-ID: <4fb3d589-5a24-efa0-a273-7848e694d02a@amd.com>
Date:   Thu, 20 Jan 2022 09:54:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
 <0e523405-f52c-b152-1dd3-aa65a9caee3c@amd.com>
 <416d8fde-9fbc-afaa-1abe-0a35fa2085c4@maciej.szmigiero.name>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <416d8fde-9fbc-afaa-1abe-0a35fa2085c4@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0083.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::23) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9fc01a8-32bf-4a7d-1ccc-08d9dbccd441
X-MS-TrafficTypeDiagnostic: DM4PR12MB5133:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5133E14D62E19B349627FE39E25A9@DM4PR12MB5133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3IGQbonDKEHtnld5fLzUtqZyJV72lfxHGykh9sRlLLLkJ4NSrYEkes1w1e6oTKlJyCSP7ilWDqTB2/zgrP9wp+EKU8VQ6QN5J4A8qJIZFxNnJLOIUUw/hYmLuCKcOPyxM7P04+2tzvI+M18IOKLqBpPZwmWTeVRRefu3MtMuwcbCa7q3LJsZ8w/pmV7Z6XNGGgZEjIf9e1HsKgKl7Pqptv7XE9QNlwnAAGlMWs9vX1PhftWyRzqyZrLYOz8cWY3CJqxgKMfWIC0eD2xOQOCzdxBe1OqQsi8T7OO7mSJhMLZsHzWwdgFh0Rz7WgkrT2dVHiYwVQhcFnTFFl6v0cPslc7trPow3RIUVZr9mcRrwWjXMBE3dwc8Q4rMkRt9s7RBgKom2IitIeVnZJ2BYmbjuytnpOJfj3FEixy/Ypd2r0IAjK+z+jA4IIm1OqBeUATBtGJu/xuvGZrqqm13mGZdr6Lr0kZnmfnijSZZ8Pk4dmr7Ro8sTRLNCUjEBj322QVl/28Y5hGGtjYTe0i5inj3R9dL+PSkaJZ6FhvjhW6nJ3HOSnhaSOZaVuGuvUYhyGeVYrXEbU2UtNjTMcQH4y4wyBPq0ara53aDKM7uMn704DILJaGTrTXC4lSbmKjPdERnZHuDmrpeSPzkcP0WYaozXt1tQky++rUXu7DMrtV+j2VzIhgI0Lw1z/8u2W8cImBxJiTiOrm4IfYdtpnKJZW/7jOw/fGHcvX3hk6gAnXdn5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(66556008)(2616005)(53546011)(2906002)(83380400001)(66476007)(4326008)(7416002)(54906003)(6486002)(6506007)(8936002)(8676002)(66946007)(6512007)(36756003)(6666004)(186003)(5660300002)(31686004)(31696002)(6916009)(26005)(316002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U29qcXJ1azVKcjZrUUp2NHl6N0RUNGtVUXdCZzUwV2o5OHhhRWx6TlhBVGll?=
 =?utf-8?B?RXJCRjBsd04zTEZiT2U5UGF6ZEsvUEF2WlB1Um9Kb3k1SjNYRXQ3Yys2c0VR?=
 =?utf-8?B?UmpuVzJJaEdpazJMS0RtaENTMVJRSHJGa3pUS1IvRGtJTVBtc1l0U2F5UWRW?=
 =?utf-8?B?N0FHcEthNjJMMkZGZzhHc25mcS9VcjNpRVBSVUFjRERQOHg4bDVOcDdwSlVO?=
 =?utf-8?B?V05tTXVENzBtVVhRSjhtaHhGc2pXcmFqREUwbzVLSkNKVFpFZ0t1TDVDWXNK?=
 =?utf-8?B?cU5hdmJQN3hKYi9aRmNtUzRzVnFsSEVnVmZ2RFZvQXhaZWR6dmdtdjlBTko4?=
 =?utf-8?B?TnBubWphNWtlbmhBdWNtRy9WN2xobkpobTEzS0pVZWhESWNDczJORFlYMXlO?=
 =?utf-8?B?d0xPS1VoVnFWeUJZUlV2T1E5eWhsaTVUbTgyZDBFOUpDbytlVEk2Nlg4L3FZ?=
 =?utf-8?B?Y0lBYTRiQVFveWFlRGF2V1RUYnV4Mm0yNVg4RDl4M0w3MVQyT0puWDZySGVN?=
 =?utf-8?B?TjluTlNhUGhmQVJqRkRjWHdQN1N2akhmcEFMckpxWWFpN0NNYU9iTmlucm0y?=
 =?utf-8?B?elFpak9tQlRoZENRUGN4cm0yZVA1WE1xcjlWUVJYWFI0NllqVGRETHpjUXVp?=
 =?utf-8?B?WlJkQXpkSFg5WW5RdTI0b1ZWZ2FzRVdpUC9URDlZMW1aSGpYQkJPUGRRZmdj?=
 =?utf-8?B?WW95aEdMY3pIV05FSU9rMkQ4MFlZS2R1YWhpVGNveHgyRWd4Qmo2VEdWTWcr?=
 =?utf-8?B?N0NHVXc5UysyczJYR3Frdmc5eUVUeCtRcU1CME5Gb29xSlo3RndTVDNUOHhr?=
 =?utf-8?B?emhaWkk1UEJYbTAzdldDVENWbmMvVWY0WDlaeGdpazJodlhOMjFZbWRhUFNR?=
 =?utf-8?B?VTdMWmhMRm5TL1c3V3ZpbXJyYmRTRzdWeHhyTm94UTNtUXBuc0RsME5GL3JS?=
 =?utf-8?B?a2d6Mm9uMWhuZU5lSzJ0NkFzMVIxcDlObDAyWFVpVHdLUVJ0OFNJaTJKVVRO?=
 =?utf-8?B?eW5RdW1LOTE3TW1XRTFIckk5MGc5WU5iUDk2a1VheE9CeVJEaE1ncGJ3cVcx?=
 =?utf-8?B?bGlzeGZSS3FqMElyRTREMmZiMUZJNE4xZG5GMXBSazRWenVITExoOVBwUDJ3?=
 =?utf-8?B?R29NcXhPdFhJVlhBWWNlZy9wVHFZaDF0ODFiWERUMStFVFhwQ0d4MmE0TUNK?=
 =?utf-8?B?ZzY4T2NvaHlrOElHaHZtaDF2N3kwVHFWWVJOSVdCcTBES2Q2RzhHcWlJZldK?=
 =?utf-8?B?ODJJOE9Idmc4ZnlJWk1nR01IVHIvQUFhMCtlKzlKcy90SlRhUUtYVFM0Uk8v?=
 =?utf-8?B?WmUyUlZadjNYRWR2S0pFVml5ek9SRUhsT1NINGs3UUFaZjRQem8rVmxDYk40?=
 =?utf-8?B?V0FRZEd2WUZUSjZmQlIwY0xRVjdzdVpGeDBYa2RRdHg5VnBuWlRHK2dyTzM5?=
 =?utf-8?B?WjREUjlFaHRRWUFOVTJPVDZuZXEweW5PMW9WMDJTckNiL1BBN1FxNVVMUGx4?=
 =?utf-8?B?MVArQ2xFZmsvY2tjZy9rb2FSYWwxbFJmczMyWituNi8rdU5hNXdjRXRFNk04?=
 =?utf-8?B?eHNXZ2VJTDBWM1VBcHJ4dzZ3VHVxdytBUXpKekwzZkhFUTQvbFVCbWljNTZl?=
 =?utf-8?B?cThTTmxNU1QxVmZwV29tSDFuait2QnpxSFFtZlVYR3hsWnBqUHFmeXRpMHht?=
 =?utf-8?B?WHFVRFVDSGlFREExeXRKVElNSUxxb0Nwd3hlTXNQUnVuTy9RYU0wR3FMeDI1?=
 =?utf-8?B?MzhybjdoL09QbWU4VW81Z3B1aGZMMmNiSkVtN0hkU0xzcnlCNzJtYVFrR2Nl?=
 =?utf-8?B?RHdsTDEzY1JIbVhKeTZIa1QwSm1kU3ZxbnBUMEU5QzlQUkVQSkozdkZ6NEx6?=
 =?utf-8?B?TmFVLzdDa0x2MXZueFRPeHVJN3FzbmtUY3ZVRmRrM0wzVUhQSW5SNXluWDh2?=
 =?utf-8?B?cGQwSGNTU2ZjbDhHMlNubk1HVTNDMThFdWJrQ0RpcXJHVWR5UGc0RS9XelN5?=
 =?utf-8?B?QnJ1MVFmeTY2bDBtczFmNzZJeGZKSmFaaDRjYjNLNmRvRDZYdXkvUzJMS2RL?=
 =?utf-8?B?WjZ0R0lYa0RFT1Z5Y3dXY1pFRnk0eWRINTgvTWpONWtTRjloS2E4OXAxbWFW?=
 =?utf-8?B?M0VhVG83a21VWU1xdmtUdHRFclR3dEo4RGVjNm1wakZkUmJ5SmUxUlN5UVVx?=
 =?utf-8?Q?pKd6H0wJ3L1IQhxq5QMbhc8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fc01a8-32bf-4a7d-1ccc-08d9dbccd441
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 04:25:03.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhMeff4kcBtAZHCFECREwkKZ+flLuODMaDKj8NAtbqE8dWGnhIEfw8zleJcW/iioRL0OZBxgScYXitMFPTTWWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2022 12:22 AM, Maciej S. Szmigiero wrote:
> On 19.01.2022 07:33, Nikunj A. Dadhania wrote:
>> On 1/18/2022 8:30 PM, Maciej S. Szmigiero wrote:
>>> On 18.01.2022 12:06, Nikunj A Dadhania wrote:

>>>> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
>>>> +                       unsigned long size,
>>>> +                       unsigned long *npages)
>>>> +{
>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +    struct kvm_vcpu *vcpu;
>>>> +    struct page **pages;
>>>> +    unsigned long i;
>>>> +    u32 error_code;
>>>> +    kvm_pfn_t pfn;
>>>> +    int idx, ret = 0;
>>>> +    gpa_t gpa;
>>>> +    bool ro;
>>>> +
>>>> +    pages = sev_alloc_pages(sev, addr, size, npages);
>>>> +    if (IS_ERR(pages))
>>>> +        return pages;
>>>> +
>>>> +    vcpu = kvm_get_vcpu(kvm, 0);
>>>> +    if (mutex_lock_killable(&vcpu->mutex)) {
>>>> +        kvfree(pages);
>>>> +        return ERR_PTR(-EINTR);
>>>> +    }
>>>> +
>>>> +    vcpu_load(vcpu);
>>>> +    idx = srcu_read_lock(&kvm->srcu);
>>>> +
>>>> +    kvm_mmu_load(vcpu);
>>>> +
>>>> +    for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
>>>> +        if (signal_pending(current)) {
>>>> +            ret = -ERESTARTSYS;
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        if (need_resched())
>>>> +            cond_resched();
>>>> +
>>>> +        gpa = hva_to_gpa(kvm, addr, &ro);
>>>> +        if (gpa == UNMAPPED_GVA) {
>>>> +            ret = -EFAULT;
>>>> +            break;
>>>> +        }
>>>
>>> This function is going to have worst case O(n²) complexity if called with
>>> the whole VM memory (or O(n * log(n)) when hva_to_memslot() is modified
>>> to use kvm_for_each_memslot_in_hva_range()).
>>
>> I understand your concern and will address it. BTW, this is called for a small
>> fragment of VM memory( <10MB), that needs to be pinned before the guest execution
>> starts.
> 
> I understand it is a relatively small memory area now, but a rewrite of
> this patch that makes use of kvm_for_each_memslot_in_hva_range() while
> taking care of other considerations (like overlapping hva) will also
> solve the performance issue.> 
>>> That's really bad for something that can be done in O(n) time - look how
>>> kvm_for_each_memslot_in_gfn_range() does it over gfns.
>>>
>>
>> I saw one use of kvm_for_each_memslot_in_gfn_range() in __kvm_zap_rmaps(), and
>> that too calls slot_handle_level_range() which has a for_each_slot_rmap_range().
>> How would that be O(n) ?
>>
>> kvm_for_each_memslot_in_gfn_range() {
>>     ...
>>     slot_handle_level_range()
>>     ...
>> }
>>
>> slot_handle_level_range() {
>>     ...
>>     for_each_slot_rmap_range() {
>>         ...
>>     }
>>     ...
>> }
> 
> kvm_for_each_memslot_in_gfn_range() iterates over gfns, which are unique,
> so at most one memslot is returned per gfn (and if a memslot covers
> multiple gfns in the requested range it will be returned just once).
> 
> for_each_slot_rmap_range() then iterates over rmaps covering that
> *single* memslot: look at slot_rmap_walk_next() - the memslot under
> iteration is not advanced.
> 
> So each memslot returned by kvm_for_each_memslot_in_gfn_range() is
> iterated over just once by the aforementioned macro.
> 
>>> Besides performance considerations I can't see the code here taking into
>>> account the fact that a hva can map to multiple memslots (they an overlap
>>> in the host address space).
>>
>> You are right I was returning at the first match, looks like if I switch to using kvm_for_each_memslot_in_hva_range() it should take care of overlapping hva, is this understanding correct ?
> 
> Let's say that the requested range of hva for sev_pin_memory_in_mmu() to
> handle is 0x1000 - 0x2000.
> 
> If there are three memslots:
> 1: hva 0x1000 - 0x2000 -> gpa 0x1000 - 0x2000
> 2: hva 0x1000 - 0x2000 -> gpa 0x2000 - 0x3000
> 3: hva 0x2000 - 0x3000 -> gpa 0x3000 - 0x4000
> 
> then kvm_for_each_memslot_in_hva_range() will return the first two,
> essentially covering the hva range of 0x1000 - 0x2000 twice.
> 
> If such hva aliases are permitted the code has to be ready for this case
> and handle it sensibly:
> If you need to return just a single struct page per a hva AND / OR pin
> operations aren't idempotent then it has to keep track which hva were
> already processed.
> 
> Another, and probably the easiest option would be to simply disallow
> such overlapping memslots in the requested range and make
> KVM_SEV_LAUNCH_UPDATE_DATA ioctl return something like EINVAL in this
> case - if that would be acceptable semantics for this ioctl.
> 
> In any case, the main loop in sev_pin_memory_in_mmu() will probably
> need to be build around a kvm_for_each_memslot_in_hva_range() call,
> which will then solve the performance issue, too.

Sure, I already tried out and have the walk implemented using 
kvm_for_each_memslot_in_hva_range() call.

Regards
Nikunj






