Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199C2379893
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhEJUwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:52:09 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:8161
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231672AbhEJUwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 16:52:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0B8+sTBKHvYOJw8wr3Hqa2+nOXnQtYrUaKBoe6P0T+ROuEgdXCcQrAoc8uNUVSjsUYFv/n4PNdRS/v7ZxyGhNKTY6EHP9kRWf5ECzkkFUxfkQFtR+AwApXuJFGrFla7acDwlmJyd2XzFY2kLpZgI50S26gF2/eGGK0EcNfGqrKYonL91aHDGyl4E/yrgDkEpu5LR45KxTojFYy65Spvu03M3W3HC3lyq6RJNn4BMFHPLenvvJph5/doKZP2lKF2n4AXn1Ekn/68dodi4xiPrCDaofl9M8ngGfa/xs0AZ6jSKFsT2A1Qh1fBZX0tWJBJJ4VNKxwjoHFcqT/e/0QDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFQwYHtHo9pUVqlCAPAjJ6lqxH50wlXOU8KyobRKWts=;
 b=jFX4F4a5FA55W+xBIDXJK4je4GI7et1q2TNRBMUi+eWYYJxo5Xkypw9gWDA/V4HTsnVXcQlMwLJxLRvyIfHlG+2wiXd4P45i3UHfG/JLCls1QKU6w/yArfiQM//U1hmonM5y+ud75tvjkoLQUGwcO9qFyB4ySiTI3RDwrxQa8Eronkb62SffJnaq/DZTfj7fxaACF7ZnDIyVboWmtgp+LnjO+P8d/s2ep9d2b7QQFPvQukGRV2WQ3Pfz1QP7Z3yMQni6mWpav5a9+eDeQxLZyHk5rYOHNeR8obDi3GHzEyxflFaZrG17Y5z3ED5l5NEVET2agfUCt80kxZA1v4z85Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFQwYHtHo9pUVqlCAPAjJ6lqxH50wlXOU8KyobRKWts=;
 b=1P0WzXFLxl1aH4Y60gVPAyHN69+7HiWc4ZxYfa/l+xZqiVEbF6mKLrXGY1mEIQWMS6726JAa8Blx4yPALVrBPdNz9snc1E+/2KXntZfwMON/ekBRaNGcUPFSUh8+VdnJueE9z79K4NzwuQSd+hmkWhlNXvL/eh5qh/QeDu/4bGo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Mon, 10 May
 2021 20:51:00 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 20:51:00 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 32/37] KVM: SVM: Add support to handle MSR
 based Page State Change VMGEXIT
To:     Peter Gonda <pgonda@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-33-brijesh.singh@amd.com>
 <CAMkAt6oYhRmqsKzDev3V5yMMePAR7ZzpEDRLadKhhCrb9Fq2=g@mail.gmail.com>
 <84f52e0e-b034-ebcf-e787-7ef9e3baae2f@amd.com>
 <CAMkAt6rfnjqPZHUqJM1r6GjnBMy-Gbw8VtGv4gd-G0Rjq+ALnQ@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c8aaede1-1eff-03ad-605b-ac5ce0355712@amd.com>
Date:   Mon, 10 May 2021 15:50:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAMkAt6rfnjqPZHUqJM1r6GjnBMy-Gbw8VtGv4gd-G0Rjq+ALnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:806:d2::30) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0085.namprd11.prod.outlook.com (2603:10b6:806:d2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Mon, 10 May 2021 20:50:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 966900de-8a55-482e-7dd6-08d913f5510e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2718DBAE5063C97762B61217E5549@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfljSjsx/vLdVORk9jOAnsUTi+pvKX/8Ya6cYLnXPtXxSYZQO/iowEiPEYBt1Su8LZfvN7baVebUSC96LnKHED1pOueGCNTkP76rbhlDyEmMr3EHfvt2hiPXW52CAUCjfsv0vI2sSTlNc89uYtUk6tLzwSBKUGCuAADt1jiWjuvjijQIO+DFWKDM3VJfCRVLiM61SMJVVFKFcVgFyx2/NWGdXn6L7ORqQoP34PLQ9d+eNx+y1i3mVzVvCRKT9EKTR0WIm38LkPfZrcvqrvxF40VeGl7OJ/0Ajk5zvRfJoW54dxCyHZqnVB7U+S3Y7JXIANmtrd0u9wJvd0eljcps1Y2gIrE7XnEwPCvzrCSIl0tEFUl/bYuGWoxr93H5WBbBDhgxfl3wycBIOa9a+lunYDvlQMJ3t99H0UemLXatg6bOV+pGANJnxOj/2NGVsJWYEPYv6Vpj7r9lyhT1Mp+7XqAHUc6NZN9COBgVZp3sqYebsnmJP53TfQNMUWH4fKyuk2IVzmUL843C9xuPahdXlzbbqKrNSyImWNcPyS1xQqD1kLdBFkKtY54gaNxbaKf7YYYhexmb+ePRtRlGWLPycm/EiXsrjEwmjuQdotUkRhj7j5Aydi9pmi5J/HOV5pDaDXDX4qx34Poh0qivbi8CT+RblEQoDonkIzawD9Zxaendbrbxb5hSX2BknE7e3Op2wvHzCyROiFEVjslXWJx/ZqAoicWr8MvEBc2gqL/SN9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(6512007)(66946007)(478600001)(36756003)(6486002)(8676002)(66556008)(26005)(66476007)(38100700002)(186003)(8936002)(7416002)(86362001)(31686004)(2906002)(956004)(316002)(53546011)(6916009)(6506007)(4326008)(54906003)(31696002)(52116002)(2616005)(16526019)(5660300002)(44832011)(38350700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGFBTnpNNmd3cjBCYkNtSUN5M2ZEYjQ0a3ZSY1I5QnJQekNMSHc5UmlwLzhF?=
 =?utf-8?B?cHVlTjNBaWVkbXo4REljUU5iRFFDSDJhMktod3ZMdk8zYmZ4eWt1NVhMNHJE?=
 =?utf-8?B?cTNob2k0TlJkd3NvdEh2c3dsaUlFR1J4MHU3MmhpWmZiSjExUzVoUnRJZEZr?=
 =?utf-8?B?VlArdm5LY3pjTjk0L2JmQ0JUNTlYcnF2WEM5UVA2QlpTQ3hJcitSSWpXVkFG?=
 =?utf-8?B?OGs0OU52RFZTVTdqT01lQjl1aEI0ajJWRGlhMG91ZXo4N1JmTXliTjNXSXkr?=
 =?utf-8?B?T2RLeXRpM3F4S1ZTSk04a2VCMjFRRHVEUlEwUmlVb3FadlJSZzdUUHBBK2NU?=
 =?utf-8?B?N1Q3dUlua2dCR3RBRGNLaHJqVVlwT1NGYkY1UnZ4MmZYc0JaWEE5ZlU2Rjlo?=
 =?utf-8?B?M1BvQ3RILzBBQW9PalcrMUE3ZGh1dDR2Y3RTZ3l5WFNLVnFJUU1RQllzUnVE?=
 =?utf-8?B?QmFHQWw1MVRpMXRRbG1mN0RTQ3JLZDJHRTFWOFBuWjZHdWQzbmxZay9vSXNp?=
 =?utf-8?B?Y1NnaHlkY04vbnozbWVsMm1BaGJvSlZBWk5ub3NCSTlZbTd4cmNPMGhCZElw?=
 =?utf-8?B?UjZMeStNNmYxNzB1Z2lod1Z1ZUcrdWRCTlRNZVl6TGRrSm9MTmJaTncxbHdF?=
 =?utf-8?B?UFlOTWhyNGkwdnNyRmN3cnpSYm15ditjUk4vMTZCcytxcG5WQ2hDM1Q3SE9J?=
 =?utf-8?B?dDRLZU5iUTIzWHFZMVZRR1pwbEIxK1BQd1Boc25ma21valJZMWJJSWcvM3Iw?=
 =?utf-8?B?Y21IQ0R4ZVdDNXlQM1UxbjVnYThBTzJWS1YybndRVmJScWRjN2E1YjR2QUNk?=
 =?utf-8?B?MFNIOVErNVlUaERmeElDY2pXTnROUko3eHYwb1QyZTViTFJBNGpEU3FKUGJv?=
 =?utf-8?B?eW1WY1R2M2x3WjU0ZjZqcVk3T1YvempWUXJ4WmZ4WW1FYUlhMW5tL2VPUDBo?=
 =?utf-8?B?MWJkNjFkZ3FWeG90MTd0QXE4YW9PdHM4eDlIbnNpTTBDaVEvemQvVDh2eXg0?=
 =?utf-8?B?MnZDU2laQURUMkFmNS9uazlTOXNSMnc1RldwNDRUREt0VkdMZERPYXR6aFZK?=
 =?utf-8?B?Tk5jOUxzSWE3UnNrRXVHVldHYUFkeWVldEpoczh5NXBaQUhCb3M1aTUxc0ZQ?=
 =?utf-8?B?SWNmTjdHblRyK1pyK1BudzNHc0p1YXhEWWxHZFluT0VJQ0IxMkVLTk8yYWdu?=
 =?utf-8?B?OGk2bXp5QlptSFo4dGgyQS9VeTJVOExyazNHOVhKMEV3RnNaWExIV3U1dG1y?=
 =?utf-8?B?b3FXUk1QeDZwQ0tsUDdzYWZkcEk1RnlwUWNSa05HcTgzd1Y2b0gxS3VFalFC?=
 =?utf-8?B?OTgzQmNyTzNxU3pZdzd3Q0Ntb2hZbzZPbUh4clpPZkhLVkR5L0RWUGtpbFhz?=
 =?utf-8?B?N2JYQTVCRm1ZcnRlbk1RVm9XRmF3YUI0Nlhtc3NNazRKbjRRQlZwRHRRZ1Ax?=
 =?utf-8?B?MGcxYUEyUjNyRkZCcm5rRFNMNENkaGNZSnBNdCtzYTByYU9SZXJ0eFRiVFBQ?=
 =?utf-8?B?SWo3OVBkWmNXWmEwWTdJREtRWHBhYllqNTBUa09kTU40V0Q2U3RoNE15Yitk?=
 =?utf-8?B?clVDQ1FGcmlOZmhtVjV2Y1JvVklLVldsdGdIUVFxTmNkWUJXdlliTkc4RTNp?=
 =?utf-8?B?dVV2TDIrR3VRZlVKV3ZIZTJnVUh5U0oxZHUzVGpMelVnUGJPc1JNT201Uzlo?=
 =?utf-8?B?Z0JjSjVuN0x4bGY1SXdOSnF6bFZJSlpnQmMyMVJSdHh1U1NtMVFGenFITDhK?=
 =?utf-8?Q?oCp3yxTY7oD6tcvQcoT+2cCVDdq0xzViM8pdPiK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 966900de-8a55-482e-7dd6-08d913f5510e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 20:50:59.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPyvEFKcwvX0+o3OqBXcMx553RAiJ/l/9vDX607TBdYwrCtAa/DbIEnToLKFl1ye3R3RupGhY+EQpP59zPwB7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/21 2:59 PM, Peter Gonda wrote:
> On Mon, May 10, 2021 at 11:51 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> Hi Peter,
>>
>> On 5/10/21 12:30 PM, Peter Gonda wrote:
>>>> +static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
>>>> +{
>>>> +       struct rmpupdate val;
>>>> +       int rc, rmp_level;
>>>> +       struct rmpentry *e;
>>>> +
>>>> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
>>>> +       if (!e)
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (!rmpentry_assigned(e))
>>>> +               return 0;
>>>> +
>>>> +       /* Log if the entry is validated */
>>>> +       if (rmpentry_validated(e))
>>>> +               pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
>>>> +
>>>> +       /*
>>>> +        * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple
>>>> +        * of 4K-page before making the memory shared.
>>>> +        */
>>>> +       if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
>>>> +               rc = snp_rmptable_psmash(vcpu, pfn);
>>>> +               if (rc)
>>>> +                       return rc;
>>>> +       }
>>>> +
>>>> +       memset(&val, 0, sizeof(val));
>>>> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);
>>> This is slightly different from Rev 2.00 of the GHCB spec. This
>>> defaults to 2MB page sizes, when the spec says the only valid settings
>>> for level are 0 -> 4k pages or 1 -> 2MB pages. Should this enforce the
>>> same strictness as the spec?
>>
>> The caller of the snp_make_page_shared() must pass the x86 page level.
>> We should reach here after all the guest provide value have passed
>> through checks.
>>
>> The call sequence in this case should be:
>>
>> snp_handle_vmgexit_msr_protocol()
>>
>>  __snp_handle_page_state_change(vcpu, gfn_to_gpa(gfn), PG_LEVEL_4K)
>>
>>   snp_make_page_shared(..., level)
>>
>> Am I missing something  ?
> Thanks Brijesh. I think my comment was misplaced. Looking at 33/37
>
> +static unsigned long snp_handle_page_state_change(struct vcpu_svm
> *svm, struct ghcb *ghcb)
> +{
> ...
> + while (info->header.cur_entry <= info->header.end_entry) {
> + entry = &info->entry[info->header.cur_entry];
> + gpa = gfn_to_gpa(entry->gfn);
> + level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
> + op = entry->operation;
>
> This call to RMP_TO_X86_PG_LEVEL is not as strict as the spec. Is that OK?

I am not able to follow which part of the spec we are missing here. Can
you please elaborate it a bit more - thanks

The entry->pagesize is boolean, so, the level returned by the macro is
either a 4K or 2MB.

