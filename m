Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA455FDCC6
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJMPBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJMPBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:01:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D197C112AA8;
        Thu, 13 Oct 2022 08:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+Y2W15TkUNywiHr9XIWAST37KvSVytwQaHw6rMDIJs+K3rEDx1zNr3TIFENHJFjXNMVbkAUgDdC4aGvgd3fOZkaNesRDu4xRtJvJa0qwTFiTMDFOTAs91OLybJGqu9xj5XTl9ddv2oa9/EpPEKUyiH5WYQ39Z7WLbdlxMhjDvptRidrTVRySD6sHHQM7XxHfdoCrTYzmXyhzH5r0obIx4ZcQ1137GnOtqzpSC4nxDW+hCdUCcw2YyLazPVnlpvW0LJqBqRcSuch0l/GHjebnZTdlzKYIstQKvUL40dFlTyNm1KWSrWdCWg3r1JeCdDzkKbI8IMrgRU1H1XcpNub1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHwS9YLdqFBBh+1b3GNUkIYE40pPi50wbowpa8OGkMk=;
 b=P4f+YJBZlfBeCnfd3LT23gdcsQ8erEZUhbzY9YeFbaIK5DfruqCsci8QciURrdINCTZN3hzxkGHTnuOfqftuYqq5fsS1ZWjfJs+YUmvpVlmaEcLN8U2i07pwa3aMH0Ssz16dsO/d+ZDgSw+mb3oGu4gj+UhiHpZ1kwmh59myYlp8uVPUliynCItzxMmFjF8BWMjgNLA2iU8bmPBKe+zzZ3tuUX0Ta+qPp+ZwypRe0gkNFDUSv4aRRs7atCHmGSKPhdBF6tqtSFA/jEf78YqM4cRrdcRjF9nxXG7ZzhWCntE3r/Z0OUoFK0ptcfoeL0s/Rtjrm9KrDF/1YIShcVLaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHwS9YLdqFBBh+1b3GNUkIYE40pPi50wbowpa8OGkMk=;
 b=OxbAC1MyiyOl89GDvASqgbGita1CuXRe2h19gGorTLVx3OI0EbJ90XRlImQi4RucnbB9zUlTd52UoCMtt6/B+L93Sns0MQpPtCsbVt+cSuCzJx69njlypcQfIgwt7cGhY+PgWwObKWjK574pf2l4igYCdTUfxZEgusKDQ0iO9Js=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Thu, 13 Oct
 2022 15:00:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5723.026; Thu, 13 Oct 2022
 15:00:56 +0000
Message-ID: <087931d7-4639-afde-fce3-bf916201ec3e@amd.com>
Date:   Thu, 13 Oct 2022 10:00:49 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
 <CABpDEukNp9eH8jXpv6+Dun+e943AbEMA6G68uQu=TrOLSvh_oA@mail.gmail.com>
 <318682c1-34a5-44e3-a15e-ef71067d4fd7@amd.com>
 <CABpDEun0KTeWXqRS0Xj5mDTajix_xGt5DTpqtK_wfGcSH3Cu1Q@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CABpDEun0KTeWXqRS0Xj5mDTajix_xGt5DTpqtK_wfGcSH3Cu1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:610:54::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 960c526d-2362-4805-284d-08daad2bbb58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1G9NkIFTJ/jxAKfCyiETleGpLCLiUkGqNveKCmAVOO3CbR/TuejS3NXafTaycbeNdiDy2efiREFl8gkcz6+WA+jC+sdwhexBwLaGgqM2SU0V5Cb8h7bMkQi/hEaDEYrOVr8BgHTTCslsItYxutySwHhV+GjIz9d7xJt0T4VsO9cRMCPLZCjQm4BUSCokkJa8WMXP/nyMblf6t6CnO8nlJ5YVIfy3ixUiG4upkuzQltDj/ukIIncld349rf3j69qRRtIMsW4hy0AfU3QsR1IMtjt+D7vBegRr+u/t5jI2yiOs7a8Shl5HI12c/19dYupnCYUiwuJRI2xs6IFEmSaroUOUpYn25UaE4yLsA2NuOBb4YmJAPfies6i64iCViriIxv7/ujnMgeMsJ0/fvT7xS/RRyL7inlUWUggj/mj4Gk9L69w/lhwVBVH8NVPhPwoyKp+/itLoxDZpC9xEkW4feHJzLFsZ76tOndaU96nNhc/kDptctP1TUJmu6VPaxhesTwwrkjVtZ1Zdt5LD0viIZfzSAmOd0iJorcS/DIqVYTkd8Zy9s1Pp7zI1/4g7XTookvr9WlUaoyr3pCUiIILg+hXrdsMnDH3EByUXFa4kKpwy2TzCe0bqjdYXxaKwGNi877HxTtzLUeEBkwLts2HFPmxf9P2scdffyewqB6KzO2nFI58TqRvPOCU7fpPrPr+1jJAL1JQlNp9+zXK7bPmhFblZc0DlbEtfZ7KMzrzedOAiEVsuB8aNMTPt5BPsO0XyeX9sMHeZajBwZejDQK2dkbT8PlXKglEOcl2uzYu/Xw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199015)(6486002)(31686004)(6916009)(316002)(31696002)(478600001)(38100700002)(86362001)(186003)(36756003)(26005)(6666004)(6512007)(2616005)(8936002)(7406005)(4326008)(83380400001)(2906002)(7416002)(8676002)(6506007)(53546011)(66476007)(66556008)(5660300002)(66946007)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjBCZ2Nua0NPU29QcnhtUjZ5V3lHazRBQjZ6bWd3YkE5UG5MTDl1YzYvUXhF?=
 =?utf-8?B?TnJTa01hRlVQYWprSVk4MlZEbldNREZOOWc5RkVWKzRzdzhneW9XT3FtZTNn?=
 =?utf-8?B?S2ZnbjJwNmdiU2VrVUI1am5EOGEvQXVGdThyUEdIREdEbllTcjRiY0Rab2xI?=
 =?utf-8?B?ZGxmczNmU3phdXlzNENzaGdNRzVKRUNMbFp0U3RkRGhnS3d3Y3hJaWRVSGZk?=
 =?utf-8?B?S3EzU1RHYVVURGNCWCt1V0lwbHJtUDlNdjFVeWJpNXpCYy91NkhEdWFwd0FH?=
 =?utf-8?B?dmo3d2pXNzh6RlhPS0pkWEtsek1pNCtITlBWbUNneGJOMXUyd3BRWnNmN3Ru?=
 =?utf-8?B?ZlFnTXVFcXd6RTlHQVNMMWdpNkErSXpURlM1YW1aTnkxTDdPYlNuVEZGUEhW?=
 =?utf-8?B?Q0R6VVcxbjN5R1FJajVjd3VCTHljVWdhQTNjcTREL3FkQVhpemYyZHpubTIv?=
 =?utf-8?B?bHBMWi9CZ0RHL0tOM0dTMEZZbFVkVWtaSUJYMEM0d2oxdG0vMDgzWTBLaGNx?=
 =?utf-8?B?c3NhSDR5RWVpU1diZHhxWGwxVU9TbS96dHh3V1VoUWFyMVBVZTl0ckxKRG95?=
 =?utf-8?B?YmxmV1ZWem5nR3NWOVgxdXRLNEtXY1JRWG9uL1hMT2FGNzlNOU90WUpHcS94?=
 =?utf-8?B?STZ0WVVvMHdieHlLUUp4TXFjS3l5ek9vUE5yVCtOMEtjUVZjb2h4OENDb2Mr?=
 =?utf-8?B?c0lBVG9iSkhibW9ydXZWT3dOajBodXpwSElOME1vejdQbTc3V20zVWZGT3Uv?=
 =?utf-8?B?T0R4M2lYYTJ0MzhOdmg1cHZEUlYzcEpESXhtSzV3V1B0N2pTelk2Vi9uTU9D?=
 =?utf-8?B?R1FsNkNtanovTTZUdXpTd2YvM0p3alZPT1l0b2VKSUJGSjNQVTR0ckdFaGFa?=
 =?utf-8?B?OUlUREI5TS9xdFRjbmhPRUMvTE8wb3MyaS9xYnZQdjJWU2p5UXhJRzd3MG5Y?=
 =?utf-8?B?aENuMjBpT3JDSWhaVjVoaVNhL0RKSlo3ZWMycXh0c2txczB4TU5qamdYTnEv?=
 =?utf-8?B?UFlNcFpzOTd3RjFoY3hFWndsNmx0YW5OV3N1K2x5c2hYL2F6ZWpyQisxd3Bs?=
 =?utf-8?B?T083c3AzeDkwSTU3OG5TaUtSWVNLM1dOenZkbjZMdkNLenZBSi9adFV4dnFE?=
 =?utf-8?B?ekxXQmt5Y1Y4WDM5RytGNS9PZDVqZUVzR0J6TzE0MjJpUVdaR0g4Yy9FbWRa?=
 =?utf-8?B?Q2U3WjNNSUR3dkdhU3dIU2x1N2xYRVIwV1dzNlZwSFRnV1c2NEcvdHdoWDdI?=
 =?utf-8?B?cUgyMTBaS2gwWGR3WGhTckxFNWh6RjU2V283QWtrYzE1dXQzZml3U1VSSW5u?=
 =?utf-8?B?dnIvOE5icTB5RVpmZHRPYXBPSmVsbjZqUGhURThFd2JPZFFnQjlpZEhUdmVU?=
 =?utf-8?B?MjFPMHdIWDQ5WmNXVGlwQWpDbmtxQTZQOS9Nb1FILy9HSzJXQTJXNTA3NEIy?=
 =?utf-8?B?a3NZNFB6cE5NUHN1SUs4UDdxNUJOVm1USWRGc1NqZVBQcFp0dnZicVlNR2FS?=
 =?utf-8?B?OUtIelhCckFYSDdEVDBNbEJlWTlPTGhJUHNQbDdYZGxUcjlFNU9xeVlLVHVV?=
 =?utf-8?B?enJQZSs5K0RtTVNqUzhqVTJIRlB5alJMQkdHSWFuaTVGOFIrRnhVZFlmdUs1?=
 =?utf-8?B?ajZaVUNQNnhzTGFscm9ZQWRrRWhBK0Y2YW1wS2lPNHRvMU0xUXJjdW85b2FO?=
 =?utf-8?B?eEhEMDZ5ZUNzMUtia0Rqc1dYUFlpY3l5UlNscld2dnZnUnR3ckluRjhKUVFo?=
 =?utf-8?B?dk5iTjcxczV1c2k1ZjZRZ3kxc0hxekpVYTFEaGtIN1VlNFE2bzB4Rno4d2NJ?=
 =?utf-8?B?YVVIMlI2bm1QZzdaYUZrSngzK1lZNjZicGwvRFNkcXMwTnNQSkFTQkhMYjhj?=
 =?utf-8?B?WXNIczBCWDcvcG5FTDU3RE9jQTZMc0h3N2NuTnZwRmpHUFR5MWZWK0ZmWGY1?=
 =?utf-8?B?UnA4UHBPNHJibXBjVERuSjk2UjNpOEJOaVNjakZkQzFrS29CK0MxTyt1ZjJx?=
 =?utf-8?B?K0VBenJTc1hhRnZQamYxcm1HUlRCN3hab0Erc002RHZLcjVIOFFRcEJ3TGdZ?=
 =?utf-8?B?Nk53dlB2czFtTjZVZEhuNVdkbGRqTG9yLzRoZWlERlBBVFlFWVJueTRWOE00?=
 =?utf-8?Q?wURBnu8nnQF98FGXCHkVzvdY9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960c526d-2362-4805-284d-08daad2bbb58
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 15:00:56.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adg5HvlSdDo8CFrmPrRVs2fDZKr7NqrNSM2DCQHQCe5jhAyosnFD6Jrxp2wEsnOA2wkHK85coULIeaQM13qD1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2022 5:53 PM, Alper Gun wrote:
> On Mon, Oct 10, 2022 at 7:32 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>>
>> Hello Alper,
>>
>> On 10/10/2022 5:03 PM, Alper Gun wrote:
>>> On Mon, Jun 20, 2022 at 4:13 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> When SEV-SNP is enabled in the guest, the hardware places restrictions on
>>>> all memory accesses based on the contents of the RMP table. When hardware
>>>> encounters RMP check failure caused by the guest memory access it raises
>>>> the #NPF. The error code contains additional information on the access
>>>> type. See the APM volume 2 for additional information.
>>>>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> ---
>>>>    arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
>>>>    arch/x86/kvm/svm/svm.c | 14 +++++---
>>>>    2 files changed, 86 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 4ed90331bca0..7fc0fad87054 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>>>
>>>>           spin_unlock(&sev->psc_lock);
>>>>    }
>>>> +
>>>> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>>> +{
>>>> +       int rmp_level, npt_level, rc, assigned;
>>>> +       struct kvm *kvm = vcpu->kvm;
>>>> +       gfn_t gfn = gpa_to_gfn(gpa);
>>>> +       bool need_psc = false;
>>>> +       enum psc_op psc_op;
>>>> +       kvm_pfn_t pfn;
>>>> +       bool private;
>>>> +
>>>> +       write_lock(&kvm->mmu_lock);
>>>> +
>>>> +       if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
>>>> +               goto unlock;
>>>> +
>>>> +       assigned = snp_lookup_rmpentry(pfn, &rmp_level);
>>>> +       if (unlikely(assigned < 0))
>>>> +               goto unlock;
>>>> +
>>>> +       private = !!(error_code & PFERR_GUEST_ENC_MASK);
>>>> +
>>>> +       /*
>>>> +        * If the fault was due to size mismatch, or NPT and RMP page level's
>>>> +        * are not in sync, then use PSMASH to split the RMP entry into 4K.
>>>> +        */
>>>> +       if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
>>>> +           (npt_level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M && private)) {
>>>> +               rc = snp_rmptable_psmash(kvm, pfn);
>>>
>>>
>>> Regarding this case:
>>> RMP level is 4K
>>> Page table level is 2M
>>>
>>> Does this also cause a page fault with size mismatch? If so, we
>>> shouldn't try psmash because the rmp entry is already 4K.
>>>
>>> I see these errors in our tests and I think it may be happening
>>> because rmp size is already 4K.
>>>
>>> [ 1848.752952] psmash failed, gpa 0x191560000 pfn 0x536cd60 rc 7
>>> [ 2922.879635] psmash failed, gpa 0x102830000 pfn 0x37c8230 rc 7
>>> [ 3010.983090] psmash failed, gpa 0x104220000 pfn 0x6cf1e20 rc 7
>>> [ 3170.792050] psmash failed, gpa 0x108a80000 pfn 0x20e0080 rc 7
>>> [ 3345.955147] psmash failed, gpa 0x11b480000 pfn 0x1545e480 rc 7
>>>
>>> Shouldn't we use AND instead of OR in the if statement?
>>>
>>
>> I believe this we can't do, looking at the typical usage case below :
>>
>> [   37.243969] #VMEXIT (NPF) - SIZEM, err 0xc80000005 npt_level 2,
>> rmp_level 2, private 1
>> [   37.243973] trying psmash gpa 0x7f790000 pfn 0x1f5d90
>>
>> This is typically the case with #VMEXIT(NPF) with SIZEM error code, when
>> the guest tries to do PVALIDATE on 4K GHCB pages, in this case both the
>> RMP table and NPT will be optimally setup to 2M hugepage as can be seen.
>>
>> Is it possible to investigate in more depth, when is the this case being
>> observed:
> 
> Yes, I added more logs and I can see that these errors happen when RMP
> level is 4K and NPT level is 2M.
> psmash fails as expected. I think it is just a log, there is no real
> issue but the best is not trying psmash if rmp level is 4K.
> 

Now, the SIZEM bit is only set when PVALIDATE or RMPADJUST fails due to
guest attempting to validate a 4K page that is backed by a 2MB RMP 
entry, which is not the case here as RMP level is 4K.

Also, this does not fall into the second case for the same reason.

#NPF will happen during Guest page table walk if RMP checks fail
for 2M nested page and RMP.SubPage_Count !=0 OR
RMP.PageSize != Nested table page size, but then that shouldn't have
the SIZEM fault bit set.

This raises concern about some existing race condition, it probably
can race with
snp_handle_page_state_change()->snp_make_page_shared()->snp_rmptable_psmash(),
but that code path seems to be protected from this nested RMP #PF 
handler as they both acquire the kvm->mmu_lock.

So, this still needs more investigation.

Can you share what kind of tests are you running to reproduce this
issue ?

Thanks,
Ashish

>> RMP level is 4K
>> Page table level is 2M
>> We shouldn't try psmash because the rmp entry is already 4K.
>>
>> Thanks,
>> Ashish
>>
>>> if ((error_code & PFERR_GUEST_SIZEM_MASK) && ...
>>>
