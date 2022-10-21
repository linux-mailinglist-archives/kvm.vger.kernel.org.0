Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38AB6080FC
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJUV4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJUV4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:56:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C1E2A8A70;
        Fri, 21 Oct 2022 14:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVmI3HE7c61CTOohNHL2uzS4yhKOPymXkm1vBixa4fKG2Sz05nQNhWR32FZsEIzbvBCPBm+JyBkQLfxP3wcv5S+0QhovU4qk2LUJhzWiioWyK6d+a2RJ83g5t7hvzuOvdZus5RzE+8/m+NcT2izddAE5alBpceFUmlrrPHVJB8AKQapRWmN8qW/c/B/+m8ZKdqvO8YsKXTrmvTnCjTvGcYlg64eeb59+8dZcJlgu3LjCMQnfTrlMrxnpI5dq6XItVqU/fFfdoiqz4ooeSvOOsZCzEUq7r42XvQ53xmT9lq7l5DOORTmAyxYYHiqSoasws/vcg8HD8xKCT5H1MX1gpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIsfA97a5X7mGU7uhTZyaMX1oD9eMmk72Xik+xffUMI=;
 b=f2+l91s3LkEqNwwTHrUbedEUSygX1Tl5iGMWz78u2JrzTwmiwht/RMXGjvY1vFrljsF7lOI7zsjXHQBOF4X20D03AwWLXZW1rzyxtCF8H9X5M6xK59UEpddkT+oaPBrD9TUsJwvwxUZb1SwN37Hrgb50yup8CddtD0avKBvNLV7zyYNv4i7F+pZ0lhSVvK4IU1NtZUGJnUW8fq6VYFDkmMvg5xTdGCXzMdHF4omRW2QVBAjGlqVGuEr3FDVJKcqG3aTV7CENpeMxBMVsIjx/hj90KfsVUe2QIEsC6GjFYTcK8GeDgzNYySyRsy64A6X+/Id+IMqqrEzNXE0Wlkig/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIsfA97a5X7mGU7uhTZyaMX1oD9eMmk72Xik+xffUMI=;
 b=oXFY+mmtXJtHJysTgIYroHyZWtZ+rMpu8YYWsWDty3z5XkkA2M1IQdUZTM+p2ptdX8upGcX+5ZLhNgfZUeDz5UoQuT6JNuCebQSqmE6eg+0HR7WXQ1UCNuipJWBhW+lgx/r9vlmLpKG1ssJJoGx9AyAGaQAi73RhdkJasGvPVJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 21:56:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5746.021; Fri, 21 Oct 2022
 21:56:14 +0000
Message-ID: <5029bc0f-72f5-e391-96ed-ed0a68f45192@amd.com>
Date:   Fri, 21 Oct 2022 16:56:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
 <27a90573-53cd-846a-e09f-c22c649db60a@amd.com>
 <ad2c2d30-0b67-69ec-d4bb-3521784fda5e@amd.com>
 <98e24097-c78f-aaec-72cd-c44e962145da@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <98e24097-c78f-aaec-72cd-c44e962145da@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:610:11a::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: 5638ee2e-14a9-44bf-06ec-08dab3af12c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4DrwQlGH0v+VaMh2F0Eowri5QBkWtclECYXvtb0G4FcgBJuNuB/2hwgyntxLTmTIcB4eCCK+tT4vUTxx6irkH/c1aD1KfflxSXAe2yLGpd7l1aGeLKn3xbAmY39PjW3MpBLdLljPCJ9/FTPMCk/pjPiyEvmMEy895eTMoC5P7kQ3FdJkxczGEQO0Bv6aZ/Uel/RIvENu64uyJUDfRM/Y1pDKGT1mFrsenHxA2PsrowXKqdF+UFBql6fXMK5yqOo+urt3dzIIVRKDe5RURusUqq9ZOnCXz+A+MGNBSyMSVQ2jDwX9DM+DhIbDmf0oUKjx4PPzub7lHYMbsm2O5QC/+B0Nte6ioWneLJbD4t65coc3fOntzuKqlD2YuSmelDh/3mCwHXRtd8ZmXvT5ZmiUIXG7LZ+a9YErQksobLpyCd2YMzI5Ds4JuKpAiUj5VvpRZig8s387A4LtnmQ+n+jCxeoQVZ6q0vpn6Oydxd3P3sdMqTNrYph4amxRr4CqhnEhlCWjik4xN3UVRmli1h5mrNs7rysuyyNfBF1uPILgUlUQB5rwKrr/Asg6X9xMIzDOba9dDGIhszPILqbzLXLKwvuXt0e1JZkEoa5f0bYOK8GcaBsdRwyucgLx3VwELrl1Pjz26Ox/GqRoOycWWm4CswUlbt5lVKTFxiCGSt/6fj9PzwRpUkg/KthLY45svTViSMWIcwRqi9mz9FHz62vboIx/8e/JO6h2/A0ta4pq4VrkolGYfCxwHDQomhGPJXuSd5KbH0Hm1xCTRIIisOFWISs8H83W9GOT9qD3hy+yrE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199015)(7406005)(5660300002)(31696002)(7416002)(38100700002)(2906002)(6506007)(83380400001)(186003)(6486002)(478600001)(36756003)(26005)(2616005)(86362001)(53546011)(6666004)(6512007)(8676002)(31686004)(66476007)(4326008)(66946007)(41300700001)(66556008)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTFIdzl2aytMVVpDVjhvbHIvSHZ1dkwzZkZyZkdoUERmcmRRR05HNXBIMnA2?=
 =?utf-8?B?WTE0RGNBN2YvanZURytCUG1zZENtRTBEY3V5M0dsd3pobXVPQUwwUThOVGQ3?=
 =?utf-8?B?dDRXS0RmVEhpK01hM0ZCeWFpUnR5NkxmWlgrc0NucmUvZUNvWEdoOGhLbk0z?=
 =?utf-8?B?cnpNSkJORzlQOHRYQVVTTnNRZWRLYXJWVUdRS3ZHQk80QnpXQVV5bTdKK2dZ?=
 =?utf-8?B?MCtYSGJGRmYxY0wybTJLaCsyWUNid1QzangxSjVIaDF0VmxONUZHUVUvdDNI?=
 =?utf-8?B?N2tzSk0xNElIU2Jyc3A4K0Y4WTczQWR2OU9aYTJLeWpwZnRSdHY3MTZGZDBY?=
 =?utf-8?B?NE5WbWVsejFJTFZuWDlTdG5QOHVLTlhQSlQxUjFHUUQ5M0E5dGI3UmNuZ1Vp?=
 =?utf-8?B?OTl2R1hsQ0dsNXRqeUJ4clpJOVEvcXpqRVFGZEl6RE5nNGw4ZmFjaWhhUXVk?=
 =?utf-8?B?LzAzbWMrazNqR0dOWlFub0QxaUhObms3Nkpkd3VJRFZmakNwVDF4VDVVMmdh?=
 =?utf-8?B?YWtzNzhjbFFFQVhMS1dOZm5JaFM3bW8vdEpPUG1YL3VkRWlnSTRuQUh6NkE4?=
 =?utf-8?B?eFJoSk1Qdk9aY1c5Y3IwSVVlK1g4d2RzZ2ZvV0szajVrNCs3SXo4ck1IZllS?=
 =?utf-8?B?MHMwdGxESG9heGUzU0MrbDZYWUw4UmJ0WXV3VUVMVEJQS1NUVnhDbU9hRGVh?=
 =?utf-8?B?RE84S2xlQXRoR0NmWStYb0s5OWFGakd4MTByZ3NXdzVtNnErcFJPL2pXWDJw?=
 =?utf-8?B?b05jSCsyT2lZU3gxTjBvdVNETGJRaXFEN05DaEVaUTR4ZWlhTE5zMS9ETVVo?=
 =?utf-8?B?R2U2SS9SemNVRFZvZzh0TnkrSWpqZmtWNkZ0RnljWkhGV2ZFalVTbWJKRnp5?=
 =?utf-8?B?VGlBeUN4cHVlQU43MXU4Yy9IWGtBaHhoZHFabkhlVXFtSEJrakNKbHNoUEpp?=
 =?utf-8?B?UFpXY21DWFVXM0p6VnJoVWpFRUsrRkdWY1VVMnExL0tRNkpjUVRLbnlQMm1G?=
 =?utf-8?B?ODBVQUlJRUU1ZFp2Q2tyRUwzMHdDajZIU0Z1Z04rRnNObDZKZ1Bvd2Y3YitZ?=
 =?utf-8?B?SEJaMjJJNHk3Nzdlb2ZXay9IZE1LVlAxM1l2VEkzem40c0dPZ1ZvdTQ0N2Vv?=
 =?utf-8?B?SUpDVWhYUEJ1cW5vZ1BCMENZeWdINlFxR1VHd2s4Vy9ScmNWdFJsUW9ySjli?=
 =?utf-8?B?KzJOVURHRldKbVg1Wkx5ajlTVlhQUEJsTHd6blUzRnRHVVBSSWhOcVVCNnhT?=
 =?utf-8?B?TmVQcFd0YXNEbXZaa2ZRSWJRUFoyNEY2a3VWbFBtNklHS2hPclg3enVuM2tn?=
 =?utf-8?B?L0ladEpLZVhrU2V5Yzc1bTU3N1RMRVJIdG5KdFdwblBhMndKYnpldlB0NnBp?=
 =?utf-8?B?RGNjWGpMYkxWRnVmM3ZWNWlsYUVvZVFNd09hVmVXQWpqdkt3UzNlb0V2WHEx?=
 =?utf-8?B?eHFrNmdwdjN6UHpRU3VvcmlLRmZwdmxhRXFFRjFyZlNVYWZrVnk0M252TjNs?=
 =?utf-8?B?VmJBNEgxRUJUNENPdFZjcnYyNFFpWm9KZVV6OWU0K3diV3RTbGtnZlduS2pi?=
 =?utf-8?B?RHVrV3NXcDNEUW5LeVRzejJ1WjAxQldSSmJ6NE1mR1pQbUsyeWQzZUE1Sk41?=
 =?utf-8?B?MVI3Y0RvV1hlcWNjbzd6NjY4bkdHMWdPUXloV3pyWlFuc0Nvck9vR0lrbHlh?=
 =?utf-8?B?N3JEWENHR1grUit5VHpuU0JiczROR1Erb0xGSWpQdWdOai9rMnpZMFd3TXcv?=
 =?utf-8?B?VzRYZHZGb3AxU2JaT1BDVnd0N0VzS0lkYnJRa2dOZ2tpWTQ5TXV1L1daT0w5?=
 =?utf-8?B?aWZpNlVySXZQLzl3eTFrMFh1NTRrUmRRUC9mZHZ4eEJEeXg3dzhQS3hyRnNw?=
 =?utf-8?B?QlQ3YWcrc0xDWFdmRW9DU2VZVFVEeXhudlNtN3YvWlFCQXRkci9lcWZhYXcy?=
 =?utf-8?B?QUVaMlNiQ1VtSUN1N2diaTA4Qy80YVVEdGxoS2FoclRvNG1qMUdPMHFIZ0VZ?=
 =?utf-8?B?NDNGQk9vVmZ2dDF6M1ZpUUIyeFdCVm5PVmZxSUxvSUNENnE2a29rZWlQTkFl?=
 =?utf-8?B?VlNVRjFNZzZmTldIaFROcTVXTGE1aHVTK1ByeGdHOVN6NXo0eUhxSHBTTWRN?=
 =?utf-8?Q?SvRiHUBCB3FVS5TuFpaI04hw9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5638ee2e-14a9-44bf-06ec-08dab3af12c8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 21:56:14.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/Ya0qU2djWTFpxcOIq/+D7ziqUBhLN+sob8Uv54eU9gZeXiAWXuKa5hRtXYMRNsxzN4id54HYjTDACky6ga5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/2022 4:30 PM, Tom Lendacky wrote:
> On 10/21/22 16:12, Kalra, Ashish wrote:
>> Hello Tom,
>>
>> On 10/21/2022 2:06 PM, Tom Lendacky wrote:
>>> On 6/20/22 18:13, Ashish Kalra wrote:
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>
>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>> difference of an additional certificate blob that can be passed through
>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>>> both the report and certificate data at once.
>>>>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> ---
>>>>   arch/x86/kvm/svm/sev.c | 196 
>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>   2 files changed, 192 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 7fc0fad87054..089af21a4efe 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>
>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>> +{
>>>> +    struct sev_data_snp_guest_request req = {0};
>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +    struct kvm *kvm = vcpu->kvm;
>>>> +    unsigned long data_npages;
>>>> +    struct kvm_sev_info *sev;
>>>> +    unsigned long rc, err;
>>>> +    u64 data_gpa;
>>>> +
>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>> +
>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>> +
>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    /* Verify that requested blob will fit in certificate buffer */
>>>> +    if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
>>>
>>> Not sure this is a valid check...  Isn't it OK if the guest has 
>>> supplied more room than is required? If the guest supplies 8 pages 
>>> and the hypervisor only needs to copy 1 page of data (or the 
>>> SEV_FW_BLOB_MAX_SIZE number of pages) that shouldn't be an error. I 
>>> think this check can go, right?
>>>
>>
>> Agreed.
>>
>> The check should probably be
>>   if ((data_npages << PAGE_SHIFT) < SEV_FW_BLOB_MAX_SIZE)
> 
> No, the check should just be removed. If the number of pages required to 
> hold the cert data is only 1, then a data_npages value of 1 is just fine 
> (see below).
> 

Ok.

>>
>> and that check already exists in:
>>
>> snp_guest_ext_guest_request(...)
>> {
>> ...
>> ...
>>     /*
>>           * Check if there is enough space to copy the certificate 
>> chain. Otherwise
>>           * return ERROR code defined in the GHCB specification.
>>           */
>>          expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
>>          if (*npages < expected_npages) {
> 
> If expected_npages is 1, then an *npages value of 1 is OK. But if you 
> put the check in above that you want, you would never get here with an 
> *npages value of 1.

Yes that is correct, i incorrectly assumed that
sev->snp_certs_len == SEV_FW_BLOB_MAX_SIZE

Thanks,
Ashish

> 
> Thanks,
> Tom
> 
>>                  *npages = expected_npages;
>>                  *fw_err = SNP_GUEST_REQ_INVALID_LEN;
>>                  return -EINVAL;
>>          }
>> ...
>>
>> Thanks,
>> Ashish
>>
>>> Thanks,
>>> Tom
>>>
>>>> +        rc = SEV_RET_INVALID_PARAM;
>>>> +        goto e_fail;
>>>> +    }
>>>> +
>>>> +    mutex_lock(&sev->guest_req_lock);
>>>> +
>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>> +    if (rc)
>>>> +        goto unlock;
>>>> +
>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>> long)sev->snp_certs_data,
>>>> +                     &data_npages, &err);
>>>> +    if (rc) {
>>>> +        /*
>>>> +         * If buffer length is small then return the expected
>>>> +         * length in rbx.
>>>> +         */
>>>> +        if (err == SNP_GUEST_REQ_INVALID_LEN)
>>>> +            vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>>>> +
>>>> +        /* pass the firmware error code */
>>>> +        rc = err;
>>>> +        goto cleanup;
>>>> +    }
>>>> +
>>>> +    /* Copy the certificate blob in the guest memory */
>>>> +    if (data_npages &&
>>>> +        kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>>>> data_npages << PAGE_SHIFT))
>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>> +
>>>> +cleanup:
>>>> +    snp_cleanup_guest_buf(&req, &rc);
>>>> +
>>>> +unlock:
>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>> +
>>>> +e_fail:
>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>> +}
>>>> +
