Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D72408A4C
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhIMLeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 07:34:01 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:48032
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239484AbhIMLeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 07:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBYZNeuJQFqQGimodmVbkRz/Y5RjNGA9H0La86E4wNUSjs3FuElWV7jDPI+FixLfXBYJY7bacsIECjD6n3l/GGIu+KpcVxLRJgAz2A0T8qXEFIohgcFITwmfzjelmIwtGJCA9IDJ2MoMLg6UnQ7Tfm2ZcboXoAVaVJlXmjDqmGcs/0IxhpM3rBEBn95NuRt74+nZunQN+uGL9naTOMqqxJ7p84fD+mm3OhCEDElsAnO0CGPPUg7TF9/KKLyku+1R4QLf7lFkTx5qpI2fFoaThkNbf18iZotpIaqhQw8vwoZDqujPw6ldoI4TI1RGMSeUNHwWis8qobBVY1VKO/b10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2GOBlgE87vM41XOQOq+dLwHhkL/Q+jOKiEFyjI9yYCE=;
 b=j2kcXKMJehOgW5POTtVCIUAUgG4nTbj4xo4XUhk8GmcDofkWaAJeAhoSA01zLOGDuvOISY+Mizj6jtrePVj8lJa87SuCBA22XXpgppCKoLMcQ2GMWJUtWCjWooSDoExEI810qUIcQl3m16kQnE8CbZ0DY7P2DViB+axUpj1uwqrYjwmA1Q425UL0+R+cVtlmbJ7W7QHzB6dIv4kxq7EvmooGfMqu2q9zd6EAucjIHpv9joVFNQ0VSFdts18xEhmtoBvUlw9d/p+zQK1q4doTLnj0FORm93d/CLfGNSP429e197KPfpFOdBFBqovpg51/+KEUUxmotvKZ4gL8usY0LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GOBlgE87vM41XOQOq+dLwHhkL/Q+jOKiEFyjI9yYCE=;
 b=eYC/eWNw44/cwNIcoPamJo08Pf+ymD8iOyi/zdKE+USOp2dksR0CzJ4IFvZZ8Dzw6CvV/Bt4HWodGaJBNiVgor2WuFWBClKgwJZ0THSK89GUsjDWSPoHefnktRWex2fFM1WjVsf8ZpYWgCqlzJvU8th9/k3oAqUcmNtgBw+MJOo=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2365.namprd12.prod.outlook.com (2603:10b6:802:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 11:32:41 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 11:32:41 +0000
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Marc Orr <marcorr@google.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <CAA03e5GaROVunr9JkBeULx2KN5kkE8TU_sjBANtAj7E-V6sN_w@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8a74e454-3485-1e95-a1ea-0f79889abcb9@amd.com>
Date:   Mon, 13 Sep 2021 06:32:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <CAA03e5GaROVunr9JkBeULx2KN5kkE8TU_sjBANtAj7E-V6sN_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:806:6f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR12CA0012.namprd12.prod.outlook.com (2603:10b6:806:6f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Mon, 13 Sep 2021 11:32:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b2612ca-95c6-4c79-63ac-08d976aa3221
X-MS-TrafficTypeDiagnostic: SN1PR12MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2365609ABC7AEE5FE5F24CA5E5D99@SN1PR12MB2365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sFnOcpBkLKHmT8aWNVwdufzQfjodTLO7eQGNK2WfIhpIjxUgseGA1gLKFiI8TbXwVdsxJ9h9bLWnO+bijGgCFE1BSYCOXcJUvblcUWtffV/IJ0b1Ks1iXZF6htdvJ2SSL0Lz/rqssG2AozqO8lTgSKcrrkxApzE+FKtmKfkr6/4zhbwvACwRu4alOQIxLin8rxghISxlxZujMpPBJuGRKjqaCXNf1t+Okqx+pY6q4jitpJSSivcIuYM+vTvODKcJR8FpvIeTJn0hpY+NIm5gRmaa5S7Z0DHU23a9bvoUSUkVeJdUgo8D58oyUYwYBpQYxxdvUxDhJB3095sX1be3LzWaYEzeyCHKbZtDLCvKioAIi8WdB1yiVjR+F3lxd2C82VRxhikfCbO4nV4CZ7CiGsRtM2a+XfrwTL1kAF9RmxIUZaNNLUwzun7f26N/wxh5EcmfZ5+tJOPxCT7q784Lek9OAx8sgR7D9r8AiKI1aAZJAyalnHAADzIOyMplrpxZe9T6I4K4Dszlh8iwWALahNjdHr5qYnHcONVBuEay2c8rswn6DrA9cAjA9rPEQU7YUzaKJe0GpZS3GFOKrFAKEyjcH+8mXz0hVMYYSwrYeLFSIK6MaMyW2WWeLtrVsyuf0ToG8n8GhGbelb8BfKsIlRatEuBmnZE/Pmlse4iLhis591WBDExYZehRhz4nQtOnjiB+EuvT362M/6PdkoxpdTwqQ8l+jNj/Pl77mOrGNzDeHmNfAGNy9sqXUZF3BHDJXf3ues/ePpB0RjW+7qLB9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(66556008)(6486002)(8676002)(2616005)(54906003)(7406005)(83380400001)(66946007)(44832011)(956004)(52116002)(5660300002)(31686004)(26005)(6916009)(2906002)(31696002)(4326008)(38350700002)(36756003)(38100700002)(6512007)(186003)(316002)(53546011)(6506007)(66476007)(8936002)(478600001)(7416002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXNxVFpXQkU2RGNpWFF0L3VxcEtTWCs2dXhtSXluaHUweGo5VEY5M2MvV0Qv?=
 =?utf-8?B?MDkzNmFRTEYwdnpzVVJ2emh0WHV2YlNzSGNZMkdDVUFKVG5zTTZPb0NPMEgw?=
 =?utf-8?B?N1E2c2pQTlhmVkwyYTJNODQ1TjJTSWVlZjA5VlRFV0NZcHNZZmthZGRFTHRk?=
 =?utf-8?B?akEyZTJHZFAzN3JqeHhQWHhXTWlBQ3FmVS9lMWJ3QkNWOVpKMHBFRTY1M0lD?=
 =?utf-8?B?OFMrQVpDWnMybkg1anh3THVVa0c5dk4rRHhzRWtYUkZYdFBHWnBhbmw5TGh2?=
 =?utf-8?B?M0JwZS9vdW9ucjVJdUVXRHBaRVRqdFFHRUVWeUNGQ3pkcS94ZFMyeGt3d2c0?=
 =?utf-8?B?eWVWeVpkNEtoM1Zpd0svdUV6RldCTEJyTUp0L1h6UUJKU1VuL0pmQjB3RGxR?=
 =?utf-8?B?R0dvS1BDY25SdjlGR0FMTzdMRnRHNHh3K1BrRmp1RHU3bjdGNkt2NGtMcm5a?=
 =?utf-8?B?RmdJTisyUEI2Y0hDbzlqOXNoTmNuWVNPWUxJNExGKzQ1N0pHUVBQaGs4eWpC?=
 =?utf-8?B?b0dSYnhFd1ZBRTNPTHB6UVVieGZXS1Y3cEhyeFdMVGdTVVBZcXlFL2pMOG95?=
 =?utf-8?B?MFBpQnZDUC9zbzRxZkN4ZFJ3SlpLQ0gyNXR6R2o5Q0RxK0h0VVF3ZEM4ZGxy?=
 =?utf-8?B?NEdja0lEVEl4K1RRaGVtZGZEV2srdFYyYXlFQXdTbEpjS0JpcGhtTi9XZG1Z?=
 =?utf-8?B?b3lVTWNhMlhxVWJFeUgvUitVMjhheEdSdXpHVDhDUUlEYnZlN0lJV2hMc2oz?=
 =?utf-8?B?RUxhd0xQcjhiNkc1OE9sNmxJUWtHTzNSODdJdGN2MHBMVWR6VWlTMUNzYzNl?=
 =?utf-8?B?dEYwdWdKdEVlU2JVU3N3WGdUaDZReHdGdEZ2d1MyLzdIOFRKU2pZdzNDTHFm?=
 =?utf-8?B?VTVLcVE2bW5LbUszQVBiTllNai9ZTzNXbkRaVVZ2WC9sSDV0amxyazdNdzdI?=
 =?utf-8?B?R0NiYkZmZWNkSHdscDdoTE5zK0s4Q3k3UTJkeU9UY3hXbjlyYy9vY2Q1OEdh?=
 =?utf-8?B?Z0FvWlRHVmEwMWRUUXFucU5FWDZMd3NmVmMxdHk3UGNzUkRCSEg3dWdUNXZi?=
 =?utf-8?B?NHdINmloTEVEaFQrZUFRL1lJV1pPbkRjYWNzUDR1cDdrME5TZWlYY3hVNG9m?=
 =?utf-8?B?MlFlK1pRcC9yK3hFOWRqOFFCSHJVL2w3VmZGSzNHeEo2cWNIWWtueTFWZHVB?=
 =?utf-8?B?aGljNllONjExdXJxcGlxZ3Z1YzFPWDkxSS9Eazl3RnFxOHMvZU1ZRVpmVGlU?=
 =?utf-8?B?akwyTHovZmJSdUZ5SEVZSVBMazc1U3MwUXpPNGU0NnY1cTZOVStmekIxdXNY?=
 =?utf-8?B?a1BaVldyTDZLWTl6M2JMTXhEVm1OcTNvbUtuN1FGejlWckJXdHYwbURXb1h5?=
 =?utf-8?B?dldkMFdnSjQ4a25lVVk2WVVuaStVYkNTTE1HZUIyNGxpTzErQ1VRcmN6WHRM?=
 =?utf-8?B?R1NkbkhQSTlFcDRzbzVEUi9zZ1pVWHhDY2VSTk1PN0dKT2R0enNFNENNc3BW?=
 =?utf-8?B?N1huUHl1cDlxOFB1eHNWenp0YlBMalNIQnlBNHZVeEVyczRhREhOZjdLWDlz?=
 =?utf-8?B?Y3FEaVJnMkZNT1Fyc3RwQk5TQnpOaGFQNGhNK3V3eklqdGpicU12WXhqTFBt?=
 =?utf-8?B?aktGOGYyT2J1M3NrQTBGQXZ5Z2FldXFwbENaOHNvQ0YrWi9UU0NRY1llTE9N?=
 =?utf-8?B?UHNOSnpYVXVyNVB2Z3g5VTA5dFl6dzY1T3NrNVlFWUx1VlNNdCtDaDZBU08y?=
 =?utf-8?Q?C6UpqsrPO0c/NRPBk2cXxKix8/fAKgCYvpkSvuo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2612ca-95c6-4c79-63ac-08d976aa3221
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 11:32:41.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqSLV8j4Callt1Qq0zsMWkmxIRc8+KUl2cYknFL/k1/NOIKnic7DTiQJwu9v1EFri9sWK/DBsx33YKe95oKu9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/21 10:32 PM, Marc Orr wrote:
> On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> The KVM_SNP_INIT command is used by the hypervisor to initialize the
>> SEV-SNP platform context. In a typical workflow, this command should be the
>> first command issued. When creating SEV-SNP guest, the VMM must use this
>> command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
>>
>> The flags value must be zero, it will be extended in future SNP support to
>> communicate the optional features (such as restricted INT injection etc).
>>
>> Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
>> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  .../virt/kvm/amd-memory-encryption.rst        | 27 ++++++++++++
>>  arch/x86/include/asm/svm.h                    |  2 +
>>  arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
>>  arch/x86/kvm/svm/svm.h                        |  4 ++
>>  include/uapi/linux/kvm.h                      | 13 ++++++
>>  5 files changed, 88 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
>> index 5c081c8c7164..7b1d32fb99a8 100644
>> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
>> @@ -427,6 +427,33 @@ issued by the hypervisor to make the guest ready for execution.
>>
>>  Returns: 0 on success, -negative on error
>>
>> +18. KVM_SNP_INIT
>> +----------------
>> +
>> +The KVM_SNP_INIT command can be used by the hypervisor to initialize SEV-SNP
>> +context. In a typical workflow, this command should be the first command issued.
>> +
>> +Parameters (in/out): struct kvm_snp_init
>> +
>> +Returns: 0 on success, -negative on error
>> +
>> +::
>> +
>> +        struct kvm_snp_init {
>> +                __u64 flags;
>> +        };
>> +
>> +The flags bitmap is defined as::
>> +
>> +   /* enable the restricted injection */
>> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
>> +
>> +   /* enable the restricted injection timer */
>> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)
>> +
>> +If the specified flags is not supported then return -EOPNOTSUPP, and the supported
>> +flags are returned.
>> +
>>  References
>>  ==========
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 44a3f920f886..a39e31845a33 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -218,6 +218,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>>  #define SVM_NESTED_CTL_SEV_ENABLE      BIT(1)
>>  #define SVM_NESTED_CTL_SEV_ES_ENABLE   BIT(2)
>>
>> +#define SVM_SEV_FEAT_SNP_ACTIVE                BIT(0)
>> +
>>  struct vmcb_seg {
>>         u16 selector;
>>         u16 attrib;
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 50fddbe56981..93da463545ef 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -235,10 +235,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>>         sev_decommission(handle);
>>  }
>>
>> +static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +       struct kvm_snp_init params;
>> +       int ret = 0;
>> +
>> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
>> +               return -EFAULT;
>> +
>> +       if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
>> +               ret = -EOPNOTSUPP;
>> +
>> +       params.flags = SEV_SNP_SUPPORTED_FLAGS;
>> +
>> +       if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
>> +               ret = -EFAULT;
>> +
>> +       return ret;
>> +}
>> +
>>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  {
>> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
>> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>>         int asid, ret;
>>
>>         if (kvm->created_vcpus)
>> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>                 return ret;
>>
>>         sev->es_active = es_active;
>> +       sev->snp_active = snp_active;
>>         asid = sev_asid_new(sev);
>>         if (asid < 0)
>>                 goto e_no_asid;
>>         sev->asid = asid;
>>
>> -       ret = sev_platform_init(&argp->error);
>> +       if (snp_active) {
>> +               ret = verify_snp_init_flags(kvm, argp);
>> +               if (ret)
>> +                       goto e_free;
>> +
>> +               ret = sev_snp_init(&argp->error);
>> +       } else {
>> +               ret = sev_platform_init(&argp->error);
>> +       }
>> +
>>         if (ret)
>>                 goto e_free;
>>
>> @@ -600,6 +630,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>         save->pkru = svm->vcpu.arch.pkru;
>>         save->xss  = svm->vcpu.arch.ia32_xss;
>>
>> +       /* Enable the SEV-SNP feature */
>> +       if (sev_snp_guest(svm->vcpu.kvm))
>> +               save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>> +
>>         return 0;
>>  }
>>
>> @@ -1532,6 +1566,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>         }
>>
>>         switch (sev_cmd.id) {
>> +       case KVM_SEV_SNP_INIT:
>> +               if (!sev_snp_enabled) {
>> +                       r = -ENOTTY;
>> +                       goto out;
>> +               }
>> +               fallthrough;
>>         case KVM_SEV_ES_INIT:
>>                 if (!sev_es_enabled) {
>>                         r = -ENOTTY;
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 01953522097d..57c3c404b0b3 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -69,6 +69,9 @@ enum {
>>  /* TPR and CR2 are always written before VMRUN */
>>  #define VMCB_ALWAYS_DIRTY_MASK ((1U << VMCB_INTR) | (1U << VMCB_CR2))
>>
>> +/* Supported init feature flags */
>> +#define SEV_SNP_SUPPORTED_FLAGS                0x0
>> +
>>  struct kvm_sev_info {
>>         bool active;            /* SEV enabled guest */
>>         bool es_active;         /* SEV-ES enabled guest */
>> @@ -81,6 +84,7 @@ struct kvm_sev_info {
>>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
>>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
>> +       u64 snp_init_flags;
> This field never gets set anywhere. Should it get set in
> `verify_snp_init_flags()`?

Actually the supported flag value is zero, so didn't update it. But to
make code cleaner I will set the flag after the negotiation.


>
>>  };
>>
>>  struct kvm_svm {
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index d9e4aabcb31a..944e2bf601fe 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1712,6 +1712,9 @@ enum sev_cmd_id {
>>         /* Guest Migration Extension */
>>         KVM_SEV_SEND_CANCEL,
>>
>> +       /* SNP specific commands */
>> +       KVM_SEV_SNP_INIT,
>> +
>>         KVM_SEV_NR_MAX,
>>  };
>>
>> @@ -1808,6 +1811,16 @@ struct kvm_sev_receive_update_data {
>>         __u32 trans_len;
>>  };
>>
>> +/* enable the restricted injection */
>> +#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
>> +
>> +/* enable the restricted injection timer */
>> +#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
>> +
>> +struct kvm_snp_init {
>> +       __u64 flags;
>> +};
>> +
>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
>> --
>> 2.17.1
>>
>>
