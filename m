Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30581608098
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJUVM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJUVMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:12:25 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6F42A1DBB;
        Fri, 21 Oct 2022 14:12:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbgc8OpG9GrClXFehTpkXu1J68EZZyAC3e1iPRqkYssbopCBjZcyiQdT/g59HRIox0fd/NnMT8iN1HcIs7PgAXBThAqhe+5QzDU1W8ZTD9sOohDTYcXfcwGFA3laAsLKFis5XPpYemY+OiGMvEK1wYjva2LBmcoEabzx/0e5krFPlYAKxJtIK5D/86s9bsmXI5cLSLDl8qxZ52bpKlNjNNS8fCeRpjBggwwHm7IaseyaazZM/xphaHkw6H7Lcsj2cPGiJ5AqLZcH4ZUVzagAmK0N3np+kpQkwDJusw3oKnF6YJ4Rp72HWGAUaOmpM5YvH/FQ1+V9oXh7HQz7ZuH3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7YWTleAsiNYP3mx6fF77rDMngNwpN+17HWDF8BCZH0=;
 b=Y6zc2T4N7Nj9mEh9EoxcIbUkE5dMS1tVJ2/+IyDFyCWh4gnejhdPDdA48WcKZGyyGo+KHs/1swn4Ut4iVhZ7gL8x9W+qncPvhFkxXdBgckzFUQpIC4/6i3ZVKVG3o09PpN5WcAuVf01uooNqL6HXUOe/asVF7CpHmyQByxnvGFEJ+CutUjdd5Q/w2dw5HJr4fldcLKqqwd2sNpcLqOdOO05Cg0KnP+9cil+y5yk8wWsmdSq7B8WLnQ0fjzm+cNjNz7PoJysirg6daQCHBAM5By0o0UZQ7JkIR6URvr5r+wx08GichNYnwJUlF+i0bgfo+BpoKDQstvgHLJOhlkRxAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7YWTleAsiNYP3mx6fF77rDMngNwpN+17HWDF8BCZH0=;
 b=QYj927kfDCmp0Pek5CoKdjQMIRPDBTVuEwZr9ULHw0BWlUy1Dn0GTXbgXooIgkq1SKLb/VRnXQx0vcpyGXXefrV8nz+wQIo/iRaasPaWkzibxxkvfAu+lsVkIA6ZDbtW7+NVDGcooVgk0BkdEAayVeRaut1nipZBYVDV6raARJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Fri, 21 Oct
 2022 21:12:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5746.021; Fri, 21 Oct 2022
 21:12:21 +0000
Message-ID: <ad2c2d30-0b67-69ec-d4bb-3521784fda5e@amd.com>
Date:   Fri, 21 Oct 2022 16:12:15 -0500
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
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <27a90573-53cd-846a-e09f-c22c649db60a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:610:33::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa6b196-3bfe-4f4d-1ea7-08dab3a8f138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Otj4xkyVfWEVgh0NgVUVZINpGfemK9welGyo/3NhZTbSI+2V1qZoCzCN04Hr/cV5H0SKJN2goX+bbbjxI8L5a9vtikTVTOj9YeJMHdtPE7+jb/Kto6kOmO5xU8gA8+vHddkdbXvA+/pgbHgh+TaU9PZJXm3Q+Rt5N7GO1X6GaEK3/Af2vw1ArA9K8eNdbUpW0Aty6qd/bU6E3b5GnbUxbseKcb+i3lu4DolaxV0m/NLEO1FYQ1r7L4pKMV9dZnkUAQP4agGidklEs23mk0rLuiXGUqYHJisu6GFEdIbEBIhRKsAIHteYdldxYE2Wh9ggA8JEG5bJVir6D+M03nFBupL8ElI856oK0UYofXpIpk3llOdnHi1LsSmYwl3joWBRSkID78LqgBHcXMbcrx0Jc9VLBmRmo2qLhayqcSEtghgsQxQK5PagQ4SFkAtEHkFts5zekjwNIDmN2Gjs4uzPQUoNC8MH71P3CgvgvT6DF6E03LuAaB+fgiR/CmmzBGD9a7tmDZhsdwvJnHdD+zWu5i6vGtXJuC8p/UZqFdRAeZ5XZ2acYfE6ZyDqWvCYH7sDfH8/eaLNQZXxaSaXxusCEmuWhsEenPUKVZDerag7Z+9hLZJjetHuPgWOzH+U5lyb1+Ls1xZABOsk2gd2MJb9w/1ydzK07vtU1JipTFFWIHDI1E3hTtKLN1T0mnkOe0f9DDbaxZT9kxfB9hc/EGOxVMpgqVNn5RJA69ZpqGMN7U9O64j/spDwpcMJI5U8Ct6YpH8WdQ/PF/U2rcDqpW8hwR/I5iYaZLzVByufoXlUcgQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(4326008)(36756003)(26005)(6666004)(2616005)(66476007)(8936002)(6486002)(8676002)(66946007)(316002)(31696002)(7406005)(86362001)(478600001)(38100700002)(53546011)(31686004)(5660300002)(6506007)(186003)(7416002)(66556008)(83380400001)(41300700001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVBEano5V0VXTHorRGxIRGF5MnNRQ1p0WE1iZVFMblRqQ1BwRnMxQ2JNMzFD?=
 =?utf-8?B?RHlwdjVwK3RhaHBpa1YxbUozSTQ3SlBDUzdjb2Z0N0hoTTZrcWt5RnFjdzBj?=
 =?utf-8?B?OFhGb0E4TUtKa0hjQ3VRK2lCMlUvTExxNGw1N2U5WElGbmk3cmI0TWg4ZzZR?=
 =?utf-8?B?S3N5V25xZjRzbTBwczlNYitIM1J5QXNlTEtMUEM0MmFXZXp0c3BiZnlQS2k5?=
 =?utf-8?B?d1MzeTRTVm01Vk95M2dlTGtzNEV3bXBlNTBzUzV3MnJDRktWWkVLU1dqQnNk?=
 =?utf-8?B?emxkTWxBbWpjakVMckZBSGNjbWY5ckVlczVLSXlHUnZsSnoxTGZOQTNKV3FO?=
 =?utf-8?B?YmkzVUF3TENhT29Za3Nxd2FHRzIwRU44MmxUZXdPSFN4V25vTUxkejVPOEZ3?=
 =?utf-8?B?dEpOdjRrNGJuSkRhdFVnUFhYc2toQjY3ZUZQRFg2TnBBcExDaDVUMkVLR3ZV?=
 =?utf-8?B?R0FoWXFYczJUR2RhTi80RyszQXNEQUowb2xhS0FVNlFidzN0angwTTlqM2lX?=
 =?utf-8?B?alprSnozdk4xV3lRZ2pOaU1ZbHpBTzdGd3o1NDlQcENmN1VVRytRc3JobWxy?=
 =?utf-8?B?eEhUT0F2TjhkNFlYT3QyWEZmOWdvWE4wTzhUekVidzJvSHNvSlFuWitjZUN1?=
 =?utf-8?B?SExwUm1aRFg5TkxJL2cvQUNWQWxwV2w4cGZ2UXhWU1BUREJyY2h0MTQ1Y0Zw?=
 =?utf-8?B?NFNPbWhaZm4wSmJ4dnFtR0RyWkNNTXUrZVRmdUdyVHlJU1BlK0NqUmVSVis4?=
 =?utf-8?B?VEdOU1NPakp1enJ1Mm1PbFI1QnNvTjJRdXkxZjJmTEtaZ1dQR0dTRDBYSEZZ?=
 =?utf-8?B?WTYrZWRiaU5wSVpNYk1iR1hvNldHQ0hoU2tXYlhjRU83ZHNrcEwrcjF0amFG?=
 =?utf-8?B?MTFEbUN0WUE0NS9FSjltaitsdkRxTTZVV1J0cmFJM0x2NGFkV1BHNmRkMUdl?=
 =?utf-8?B?ZDVyY1Y4UW1SRUdDMFZ4MjhqMjRoRTYzRUNmNFF0UE5IK1hvbEphSi9KR3hV?=
 =?utf-8?B?QkRYZHdsS2RiYjU1MThlOU9uSWhZM1M0TS9FaGd1Mzl1SkthRFRUZ0Q2NkZm?=
 =?utf-8?B?NDRoRUdkdDlzakFyckNRMGVlRUZOMG0xSnMxUzl4cTByVGZ2NDEvZ2lBME1w?=
 =?utf-8?B?MzZ4UmhTQkJYNE8vemNNa25JTGhuS3AxYXA3VWYwQkdIb0pqbisyMDhFcmRF?=
 =?utf-8?B?eisvSG5EZStCQWs2MDNXT2RhNEtYYk1xVjBKK2ZIL05SYWdBdzh5ci9JTGhL?=
 =?utf-8?B?WUtOMEdKbGFWdlIwUjJQZU9GdUlBcUFVMXdWbnlpQktSUW1kQmgwNzNEK0Uw?=
 =?utf-8?B?UFZHTlVnVUh0cGVYRVJrNW9IdGxZSmMyUllBVlVpMmdsaEl6eWdHQ2p3bkVJ?=
 =?utf-8?B?U1lGTklhbGhrWWc4Ni9OdnZ6M01STC90MVJyUS9mVVQwZjZ5SkljdWM5VXdU?=
 =?utf-8?B?VGMzNFd5MEMwcUVTVEc2NmNBaTV0bnFYWCtRaGludisyTzFkWUFvWG40VjdO?=
 =?utf-8?B?QXViYVd6Zy9oM3ZhTUZDQlNBWVRReGRaV2tiU0VwQ1hFVFVyQ1l0S0l1eHVV?=
 =?utf-8?B?Z0o1NDBSY1ppSzhFTmcwYWw0K3dKbEVMT3RyUEZrb25YQ1FLQ0xFcytBNU43?=
 =?utf-8?B?UTVZSmNXY1FaVkNFZ0gzd2dOd2diWC9icTFoTk1mNWJJVFJlMmhweU5kSnY5?=
 =?utf-8?B?SWFWRXBtOGRyMGVEbkY1M0hvM3FpeTYvaDVqQjdGK1Q3bkZIbFZYRUMrMVBD?=
 =?utf-8?B?YmlzVnBWMEgxU0VMYUhOc043TGVtMVNIVVp1T3FGOW5EQnRuNlB6NG1JeS9h?=
 =?utf-8?B?d092WTR1MTZCMk56WWJ6ZU9iYk5xNDE4ZVdvTUZqWFpyU1NQczVQbUdtWG5B?=
 =?utf-8?B?WjZrOGpIbHQrcWFNQjhBZlE2SVNqZkVENEg4ZDI1ZWFGSURnYnNuNzZ5YXVz?=
 =?utf-8?B?eVN5ZjdGWUg2Y1RLRVNZYW5nY3VrQ0FYaG5rNU8zQndEVjVhT2NGWXBYL2xr?=
 =?utf-8?B?NllabkJBblcwQlNkc1ZoM0c4WmtZNi9URWtnbnJyQ1h5dmhPRjdzUzNRN2Fo?=
 =?utf-8?B?eHRIT3hwczBoMExkdmZtUG5Vb1JZdXE2WnJCc3dmMjB6a3locVdDM2tRdDFa?=
 =?utf-8?Q?Ww/YbR7mZk+xCQzWgEO7ZJfJ+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa6b196-3bfe-4f4d-1ea7-08dab3a8f138
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 21:12:21.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNkypu7/hQ6pQfZp/fkZ2/y3/iYMSjadZJCB0GIDcQ7S7TB9PVbjdDtye/by3Koy1jbfPCF2LMkMhbw3Krl/fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Tom,

On 10/21/2022 2:06 PM, Tom Lendacky wrote:
> On 6/20/22 18:13, Ashish Kalra wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Version 2 of GHCB specification added the support for two SNP Guest
>> Request Message NAE events. The events allows for an SEV-SNP guest to
>> make request to the SEV-SNP firmware through hypervisor using the
>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>
>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>> difference of an additional certificate blob that can be passed through
>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>> both the report and certificate data at once.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/svm/svm.h |   2 +
>>   2 files changed, 192 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7fc0fad87054..089af21a4efe 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
> 
>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t 
>> req_gpa, gpa_t resp_gpa)
>> +{
>> +    struct sev_data_snp_guest_request req = {0};
>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    unsigned long data_npages;
>> +    struct kvm_sev_info *sev;
>> +    unsigned long rc, err;
>> +    u64 data_gpa;
>> +
>> +    if (!sev_snp_guest(vcpu->kvm)) {
>> +        rc = SEV_RET_INVALID_GUEST;
>> +        goto e_fail;
>> +    }
>> +
>> +    sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>> +
>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>> +        rc = SEV_RET_INVALID_ADDRESS;
>> +        goto e_fail;
>> +    }
>> +
>> +    /* Verify that requested blob will fit in certificate buffer */
>> +    if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
> 
> Not sure this is a valid check...  Isn't it OK if the guest has supplied 
> more room than is required? If the guest supplies 8 pages and the 
> hypervisor only needs to copy 1 page of data (or the 
> SEV_FW_BLOB_MAX_SIZE number of pages) that shouldn't be an error. I 
> think this check can go, right?
> 

Agreed.

The check should probably be
  if ((data_npages << PAGE_SHIFT) < SEV_FW_BLOB_MAX_SIZE)

and that check already exists in:

snp_guest_ext_guest_request(...)
{
...
...
    /*
          * Check if there is enough space to copy the certificate 
chain. Otherwise
          * return ERROR code defined in the GHCB specification.
          */
         expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
         if (*npages < expected_npages) {
                 *npages = expected_npages;
                 *fw_err = SNP_GUEST_REQ_INVALID_LEN;
                 return -EINVAL;
         }
...

Thanks,
Ashish

> Thanks,
> Tom
> 
>> +        rc = SEV_RET_INVALID_PARAM;
>> +        goto e_fail;
>> +    }
>> +
>> +    mutex_lock(&sev->guest_req_lock);
>> +
>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>> +    if (rc)
>> +        goto unlock;
>> +
>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>> long)sev->snp_certs_data,
>> +                     &data_npages, &err);
>> +    if (rc) {
>> +        /*
>> +         * If buffer length is small then return the expected
>> +         * length in rbx.
>> +         */
>> +        if (err == SNP_GUEST_REQ_INVALID_LEN)
>> +            vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>> +
>> +        /* pass the firmware error code */
>> +        rc = err;
>> +        goto cleanup;
>> +    }
>> +
>> +    /* Copy the certificate blob in the guest memory */
>> +    if (data_npages &&
>> +        kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>> data_npages << PAGE_SHIFT))
>> +        rc = SEV_RET_INVALID_ADDRESS;
>> +
>> +cleanup:
>> +    snp_cleanup_guest_buf(&req, &rc);
>> +
>> +unlock:
>> +    mutex_unlock(&sev->guest_req_lock);
>> +
>> +e_fail:
>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>> +}
>> +
