Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3BA62E70B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 22:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiKQVgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiKQVgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 16:36:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B43F4;
        Thu, 17 Nov 2022 13:36:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWmHyyX9AX8IIlFcyvBv9XF7Xp4a76J7U5Y6kidT0MGayK6pWNhpALBqmPL6N2cS/d6u06soVjObZnDEBBRbes+tJWFuWOBtTNDJHmwTn5GbbsG3KvbX6M4TZH/cTaRdbGnq/Ri6GzoO2w0whBLMlNGmjS78pTXXoSFN2d+MnD1nuZirumUgqMl0oaiw+iibxs3iGpSt4zLTePo5wzv139sBu2hwHjjvMXHWeXiEERzMxZyQWdG2won1EWw0YcB/T/k8RdrELmKdX1rDYNacJ3kdxHPqEGYyONR1wVYHmaf13jwoGoD0BXRJlq/vIM3erK1EOIPyYptKAjQCQNWTiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0aOgCvPsuqfDzJ5+FmmA7f5qvsKVWAt2/MZcu5CvcM=;
 b=crx0WbuO4lRkfjgti+/s1zx45u90c2sARqfOFiuTsSC33LfEuow1QkIrdkbP1tATp1C4kbFe8WEVYxPOLoo6pAQledvTbx/HT0IaG8Sm+VVmSLS9d7ABM7THgZis4QvGpiF/OztVtBBwoyuyhbnIcFvhoLQy9ridVeXcdw7Aj1buaPdnF39KSDdhDOapjpmtxipODYEcx9Xeb1eEqo2U+FV0KPb1mZI/Lnm+DfEjx4MztbBmI6x9zB72uolYAq5Iw8WhjwzIN8/MvcyYTBptYmksUwBJxwxg3v9ZsNU0ucKkkEH5PQr9+fOVAp0Pjan4W87itJUB2GTJkj+xWA5ZAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0aOgCvPsuqfDzJ5+FmmA7f5qvsKVWAt2/MZcu5CvcM=;
 b=MFSqkqkyEuxhbWXj89W3W9zhOnw2P+JXiAYemH14dkIPDTOpibrtH/SXEz4aJxu306AgNe8Tmj2XtQG6vIFk4H6Fsc60eJ97egU4GTXRi8EovvvH4YsEb4LO0MbXSFekVfA4BFo2Pn7PCslhdfc5P00P8OhPpUvlsDGdtPR8vO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 21:36:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 21:36:15 +0000
Message-ID: <8d93df43-f45f-4934-550d-845aa9493e4b@amd.com>
Date:   Thu, 17 Nov 2022 15:36:09 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 39/49] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, Alper Gun <alpergun@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <34246866043db7bab34a92fe22f359667ab155a0.1655761627.git.ashish.kalra@amd.com>
 <CABpDEukAEGwb9w12enO=fhSbHbchypsOdO2dkR4Jei3wDW6NWg@mail.gmail.com>
 <CAMkAt6oOB5xG7OnKn58Z-oLNBd091yAajZhrWDtXyu3UCiJNfA@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAMkAt6oOB5xG7OnKn58Z-oLNBd091yAajZhrWDtXyu3UCiJNfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0210.namprd03.prod.outlook.com
 (2603:10b6:610:e4::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ce9e7d-b755-4493-e4af-08dac8e3c150
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RidmtcVjM8eFRuCDQ2cU0QTYFU9XGZwVqva4unu8S8m5yDpgeSubuspR9AwsZlyk9l1LcAYFizG6+C8xCUVd3DCxAWUt3uekLR1EZrAlX6waWf8KS4iahaegfiKA1QNMNmkTZwcACAfvdCjQdbuFbyfSgM3JNAhmk6SsXs7osyvJpeTLTPyVlXr6Vyyz0R1fcZ6Ef7KiGRErumf37ZqY0anpdy58jQqu4VExikF2kr6vzYNVYvquN7p2aMDYBCulskTMkgTzDmF61RCtXkvbD0Gk+ITt2foNrQbcdlGkDbLTmbCtVNm4XcQElxwObVPNcNtXyfeVqMfHcfa3sJSX1k3rLQxTnbzNe7rEBuC2C9UK00HaMhJKa0sDoYcWP2o0hPPgx5KcdN/r8WezqA372AM2vAam15XfIGo+ZB5s3vLzSUpP+6Eio7mjMVbLhPavxHx4JqONsa+oYYd0X9+68R3MhgIBQa2R1q2kLa1eJL9tVwKMvfujwy0W0eCcOYyWzfYs0Ilcx3PCY9BXImYP7CVrOpY2HIkYVYNDLS9WB9r+6C2pNuGmNUBHAuHyeaKQSd//BGjrxq0Ag8JLLo73+gq6nrWhKidHiKwkCFBPlGJ63gqxgDR3Vu2427aTx3w6xgb+R3Q02FbXHF1crLjM34+uL8UgZ2Q+PByJ0aKG7ewvXylHznu3WKgRrJsthUH9Wo1bS1VqjC6edrUFraPNFMdC/ltzBph4kAvYBtsTSjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(31696002)(8676002)(83380400001)(86362001)(66476007)(66946007)(66556008)(4326008)(5660300002)(7416002)(7406005)(41300700001)(8936002)(38100700002)(6512007)(26005)(2616005)(6486002)(6506007)(186003)(478600001)(53546011)(316002)(6666004)(110136005)(36756003)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHdVc0gvazRZNDdjblNVRDBQTHNqaHhWRVh5RDh2TUdoZnhPcDRRS1luTnkx?=
 =?utf-8?B?YSszV3NDam8rdDBxYXlJZUpyWituYkZvRllTd0N3YTkrTEpVbHV3THRYRFZv?=
 =?utf-8?B?WStEdzFJWm1rNDNYMXRSMzJCSkVjNVczaW1aUHRMbHFRTXR6MlFxaWMzM0JS?=
 =?utf-8?B?c0dzL3YrWW5sQi9iUjJaZHdXdy92dXVEVi9LMFFSZmNBb2tTeC9BUVFOazds?=
 =?utf-8?B?Wmw0Yk0wQzdEVTFCT1VZSTg1OXkvMXRwbjhTT2xJVkhQZFFwYW10U2s5WDlF?=
 =?utf-8?B?djN4a3l5anpTeTlwbVZPZTN4Vy9leUdQUWxRd1BYb3pjdVcxSEpVVTc1MUlP?=
 =?utf-8?B?aXBHeXh0QVpKTEhUWi9ocWhhY2s2RkkyS1lBME9YWXdCekVzcEJMUi9Sbkl6?=
 =?utf-8?B?dVdFYys5dFh0UWJjNEIySDlxTE1yNmQzMnFrSzBLL1ZsOEZsM1NJb24ydFpD?=
 =?utf-8?B?alVMbXJuYTBZcDRUWGVJTVpTSGw3ZkhMcjN2Y0ZoNEVJREoyQnVZVzQxYlM0?=
 =?utf-8?B?SnNmSXp2UTJTTWJGZnNmSm4rNTE4VVZ6U0tQSTJ1VFNGZm5WVlcvaFp1T0l3?=
 =?utf-8?B?eGpBYkk4SUpyNW52SzUybFAzUnM0S2EyM0M0blZRSy9EVDF2T1MzbEhVN2hR?=
 =?utf-8?B?NDg1czBFL1FLa2xjNGV1MUJkdHo4VzRZVFZJUzdyNStwaFk3K1ZhaDJBUUNm?=
 =?utf-8?B?R3k0RTBNSC9JL3VGNWczOFhVMzlvRmJEVERHWUJlbjNtT1VNekx3ckxpTW9R?=
 =?utf-8?B?Nk43R1pFWkFidkd4TEpuNk5PMnhibVhoVWR4eHhRMW9QL21QeVVER1czczR5?=
 =?utf-8?B?Rzhtclp0Nzl1SHdqVWJwV3hkMWttNnFseTlJTDhhWUF6TFZkczE0NGVQQ2tl?=
 =?utf-8?B?SVFNWVgya2x1aGNkWGphTnFMdnBzdFE5S2hEVWZvL1Z2amV2ZmpzTnNnMFNH?=
 =?utf-8?B?a2Z3R21jY1d0eGRIMWlCdW1kUVp2YjQ4bXF6bGtna3ZxN2VEaFdBMUpUNXpw?=
 =?utf-8?B?cVl1VWhwSHpmM2EzY0xId1BWay95YWxtcWNTa05ncFYySFlsbThUUVJQNDlL?=
 =?utf-8?B?czYzTGlHMXJNS0NzTkdRNHRkQnJWRGF6QU1XZ1ZyLzJCZzUrYjYvajJuMUVQ?=
 =?utf-8?B?YW51QjJNbXBFejhTOVBBeUg2MTRpRkMzSENzRlRtalZqc3BneHUvbk1URyty?=
 =?utf-8?B?L1Q5WE92ei93RGJZaGxESXJpYjZYQUFNRjFGeFJuK0xjMWNLTi8yQ2UwVzNO?=
 =?utf-8?B?TnJxSnlZUVRjVXJObGNpS205M01xQit3TmdtMnNzVHZnMU02UUpueWtVbVhQ?=
 =?utf-8?B?R00wanAxZHVzOTg2U0ptQ0U2RHpuMDljaHMyb3ErSE45MU5SOUgyQlZwREIw?=
 =?utf-8?B?MWRtY2swOEsrOW9SL3pUMFN1RkFKa2VORTJmWGMyWlR5Zkk4ci9QRkx2bEhM?=
 =?utf-8?B?RUNwdzZrZm1MV003RnB3Y1l6Y2hONHJEVjh4by9NZXpKMmsyTElSNzcwbHhU?=
 =?utf-8?B?azVUOFlmWVBsb21VaHpJMHp4R0hxN09GRlhCaC8xbVpQbThNUllzOWUrSFUw?=
 =?utf-8?B?MTBhS3hjaFdsa0thL1FDcnU2S2pSOFhGOHBncDkvTlBCcElLc05NNnRDZjBw?=
 =?utf-8?B?aWE3MkdJY2JFWXYvaGgyYU5udWdLY3RJQnRDeVRhdmg1V0ozK2NTeGlRTEtM?=
 =?utf-8?B?ZXhnSkFIRXNwS1BDMDZ0T3MyTTJLSFh2VHdTV1hvVHJKb2ZoZGRNUXlqb3N6?=
 =?utf-8?B?UnRKOWRteVV6U2M1M2hWZ3dDcGpHaVYwMmRJT1Y5TWtDY1VwNVV6RDhTdFlk?=
 =?utf-8?B?RzY0SHIwZW1lNGJKZnNNdS9nMTh4SFpPemt1V3l5aDZxd3JWb1p3QWxOa21i?=
 =?utf-8?B?UGhMVEExK3ExdHFOUUtuRXorSml0dFhEdmlPcVhYV2pqWnVWWE1va1RPMTlB?=
 =?utf-8?B?ejFBb3pLMDI4UmRDK3JFQWo0WFhUNWRENHlISW8zVzFPT0ZoWU9TKytIUGR1?=
 =?utf-8?B?WU9VS05oS2FZaE9yS284dVUzaE0ydlN0WHlCSDZlNXRyZHgyekVhS0thdEUx?=
 =?utf-8?B?NlVEMm50alFWcWZXbHV3TjZuSDRqQnBXci9UeVpOUXA3UlRVamNHTkg4dU1z?=
 =?utf-8?Q?IkUrnCvkU0GajNSzZsncxN8Nw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ce9e7d-b755-4493-e4af-08dac8e3c150
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 21:36:15.5125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJWIuThQ9PdcTCW0dLB1ojJPjicc6vGYxTDejqpELjhM8uI+5Wq5iiB+1usGkO8dlMVPhn/w6aK6/tzguywqxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/2022 2:18 PM, Peter Gonda wrote:
> On Wed, Aug 17, 2022 at 9:47 PM Alper Gun <alpergun@google.com> wrote:
>>
>> On Mon, Jun 20, 2022 at 4:12 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
>>> either be a private or shared. A write from the hypervisor goes through
>>> the RMP checks. If hardware sees that hypervisor is attempting to write
>>> to a guest private page, then it triggers an RMP violation #PF.
>>>
>>> To avoid the RMP violation with GHCB pages, added new post_{map,unmap}_gfn
>>> functions to verify if its safe to map GHCB pages.  Uses a spinlock to
>>> protect against the page state change for existing mapped pages.
>>>
>>> Need to add generic post_{map,unmap}_gfn() ops that can be used to verify
>>> that its safe to map a given guest page in the hypervisor.
>>>
>>> This patch will need to be revisited later after consensus is reached on
>>> how to manage guest private memory as probably UPM private memslots will
>>> be able to handle this page state change more gracefully.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>>   arch/x86/include/asm/kvm_host.h    |  3 ++
>>>   arch/x86/kvm/svm/sev.c             | 48 ++++++++++++++++++++++++++++--
>>>   arch/x86/kvm/svm/svm.c             |  3 ++
>>>   arch/x86/kvm/svm/svm.h             | 11 +++++++
>>>   5 files changed, 64 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>>> index e0068e702692..2dd2bc0cf4c3 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -130,6 +130,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>>>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>>>   KVM_X86_OP(alloc_apic_backing_page)
>>>   KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
>>> +KVM_X86_OP(update_protected_guest_state)
>>>
>>>   #undef KVM_X86_OP
>>>   #undef KVM_X86_OP_OPTIONAL
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 49b217dc8d7e..8abc0e724f5c 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1522,7 +1522,10 @@ struct kvm_x86_ops {
>>>          unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>>>
>>>          void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>>> +
>>>          void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
>>> +
>>> +       int (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
>>>   };
>>>
>>>   struct kvm_x86_nested_ops {
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index cb2d1bbb862b..4ed90331bca0 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -341,6 +341,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>                  if (ret)
>>>                          goto e_free;
>>>
>>> +               spin_lock_init(&sev->psc_lock);
>>>                  ret = sev_snp_init(&argp->error);
>>>          } else {
>>>                  ret = sev_platform_init(&argp->error);
>>> @@ -2828,19 +2829,28 @@ static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
>>>   {
>>>          struct vmcb_control_area *control = &svm->vmcb->control;
>>>          u64 gfn = gpa_to_gfn(control->ghcb_gpa);
>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>>
>>> -       if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
>>> +       if (kvm_vcpu_map(vcpu, gfn, map)) {
>>>                  /* Unable to map GHCB from guest */
>>>                  pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
>>>                  return -EFAULT;
>>>          }
>>>
>>> +       if (sev_post_map_gfn(vcpu->kvm, map->gfn, map->pfn)) {
>>> +               kvm_vcpu_unmap(vcpu, map, false);
>>> +               return -EBUSY;
>>> +       }
>>> +
>>>          return 0;
>>>   }
>>>
>>>   static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
>>>   {
>>> -       kvm_vcpu_unmap(&svm->vcpu, map, true);
>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +
>>> +       kvm_vcpu_unmap(vcpu, map, true);
>>> +       sev_post_unmap_gfn(vcpu->kvm, map->gfn, map->pfn);
>>>   }
>>>
>>>   static void dump_ghcb(struct vcpu_svm *svm)
>>> @@ -3383,6 +3393,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>>                                  return PSC_UNDEF_ERR;
>>>                  }
>>>
>>> +               spin_lock(&sev->psc_lock);
>>> +
>>>                  write_lock(&kvm->mmu_lock);
>>>
>>>                  rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
>>> @@ -3417,6 +3429,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
>>>
>>>                  write_unlock(&kvm->mmu_lock);
>>>
>>> +               spin_unlock(&sev->psc_lock);
>>
>> There is a corner case where the psc_lock is not released. If
>> kvm_mmu_get_tdp_walk fails, the lock will be kept and will cause soft
>> lockup.
>>

This is also already fixed for v7.

Thanks,
Ashish
