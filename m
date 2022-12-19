Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49C2651179
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 19:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiLSSEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 13:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiLSSEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 13:04:34 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813B511A24;
        Mon, 19 Dec 2022 10:04:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0v/btOyPWrWnnnwLpsJjdz3geMTeIkgDdQVC3quDBrYa8FU2v7zURtN4AnklHJeXDpT4zeyqA4E9WAZ3Y8I1cJGUlQo1z/0Bjei7lzOWK5bTu06gHSHQ5Fev+3V0lQHZ0s7hRtlIhEEWz5c3bNRukiz01PFMawQDlFx8+gWm5juSpSO1XaYk+znxs7tTZjSbiR2qtpUK1PlcNh9VaGZtN22hXfq2tnSbV/0WSGGyW6JsDowf0+qhAP6r2xZGL2TYY4MFnkXe7tTEEEjD52s0+OM5yOIdzLDCTdOm/MyKaT4/LOIzhFJDfn9zdfRb7el3hxbEzSDHiOEhHpUYwpKKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeEp9q1UdtiEJrvOA3jttnyPXytKh42nJ/ysvYzNyFg=;
 b=TT8Xq5uK/NsQLztNIN0bHo7UcoKZ6+JlWZsgxNuxzryAkYSR5DJ99bXk+sJ8AwlGhcDuu+oB90k3Zfqteh2SPiJObJcEf5YD75sF2YXXlQ+8g9CjuLx5T9w2oVHk8k+FmVtE2V8sC9ZnEjyKdHfd/J0TIpQpn8kXqi6ySwvNdqi71861b4+xwmNT3K4p2nOxG9mABm7NwycYdy4IjN+90SyGH4BTooy3knkkOj8StbDSKjTJ3/+KCw9yljykYG/VJc843wmLSd/3RtMMpaFxr9z1K9l7/jAntdhokAIgcT6DGginMpUUiWbn4KtanQuPc1kRkc7PZMpwP7FQ1ZmdlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeEp9q1UdtiEJrvOA3jttnyPXytKh42nJ/ysvYzNyFg=;
 b=oLZsprk3QZrwyD8NeqBCgzE8YJmM0b2x12wKIeodE4TWwpk1BcXJsuMoLiI2s465ac/KMrTUbnB0P5hwk1bc+vaNXxTTYpiNZOHq0Nutl4XRYL5B9TaqROA6VGWTVBiZ7yF5T3C/QeyLYU0xE81PnbvSxwQj8jW7u9t2oxQJ+74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB5942.namprd12.prod.outlook.com (2603:10b6:408:171::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:04:30 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:04:30 +0000
Message-ID: <272cf383-f97f-805c-fd70-1ec14e756523@amd.com>
Date:   Mon, 19 Dec 2022 12:04:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 40/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-41-michael.roth@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221214194056.161492-41-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:806:27::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e4cdfc-34aa-43f8-b787-08dae1eb798f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JaIcNqcwY8zQWvK4ay7tkAZ1ajJWXjLQ1IqHS1zrepwq3y+YNHB9+I07J5ZGkFFV368Fxg+6yrrRIQj08zWEV56Dpp/wYL+EmOVQQi9RdBoImBi3//QTk2tDe4v5pCtHL8PCnxSK2R1gNXE6JYzGdOt4sXJjsgs7E6NJCxs6SZJv3Ceuexp6vvvPeQSkHYb3ijt5bpydyaivAbmZZG/a1L1e5s99t7Z2ubXulYFnQpsd+usuzPgi3dA9mjUIqrGqpzDnukus8t1vtr9I+pQOebtDF9nf9NRTIEFQvjY4V8es5ciN4IwHmfsxiMr6yBzWztBekt2qVTLzCQ2uK3MT1LpurMiIy/HBV/Wpqnc1luSVj4CwVb+KWhENK5o0AaJR34yr0rd7+8Qh0o6JKEu9dJFLTs0KgQzZ1zw6txcDxZSHBlBwRaJ+F5JDUhJFb2d1kmq9B9Klth195lr1hPlRpYB89wDE3ytnKECgn4zi4Nf1tBpTg4ucmKCaQIrcjRq+aMowSRpYckewlGNZcZJWxC0Y0ZrM3ggRmnU28vya6zIkyY7gzv8VFwaAXH4oEyt26pSJ4I0B0KiP/zfu5WlgM+r5qWvyT7Q4hIFgv4ReVWfP5n83cw251pexzu2gFoyRT2jS5nOX+2iBjcL8PmMAtktLyMbjvmCnBkGgoHJN4yweqyGWp9q5WLDPHhKsfS5Gvjkyg+EzcmlpKgPKd74Dr3rWlsmod14DA9cPBY0veyQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(8936002)(38100700002)(7416002)(7406005)(5660300002)(53546011)(186003)(6486002)(8676002)(66946007)(4326008)(6512007)(41300700001)(26005)(36756003)(66476007)(66556008)(83380400001)(86362001)(2616005)(31686004)(2906002)(316002)(478600001)(6666004)(6506007)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXVmRjRQWngwSkJQb0gvRFhoZUcxZDVjRWhwWnlzcU45bUx1WFplRWxLT1Bm?=
 =?utf-8?B?TS9QUVlMNlpndlVLUWdmNStRUmp6bTRtVEZuYXM2bW5Zc1d4d0RQZWVYeXVw?=
 =?utf-8?B?MldTTjZCM1piZHlJOTBHeW1Pa2dMOCtHNERGMmRxQmhCV3E1bUU0QlozbWJN?=
 =?utf-8?B?Z2xYNXJpQjRHaGNibmVDTmRVdUFYYm1CSy9wVG9DRlEwWHY2b1BBT0hGL1Ur?=
 =?utf-8?B?NExqY01WcTc4Q0RBamVPd1RVTDVSVjNGcE5Da0U4a3hiYjlmOHZpY1BSekN1?=
 =?utf-8?B?Z0k0ZHNLZG44REtVSSt1Z2prQmoyUnJlc2xidEhWNkNZNGhZVS9TMUh2bVNu?=
 =?utf-8?B?V1dZWTB1LzdrWjc1OVhGTGNhMnlOZ3FVb2NxUjNpdC9RdTl5T0tUdDc2OCtJ?=
 =?utf-8?B?YmpibThPSlBMb3hQbFAyUnJoYXZsM3V2SXRkWXIrOUFtSHcyUW1EVTdBaktE?=
 =?utf-8?B?YVBGZkFrSzhTTUFKSng2YXY4b0praHV5NUNQTk5Ibk40Nmd2S0VSbzJsNkF3?=
 =?utf-8?B?Z3dTM08wQnJSbm9iaGxwdEYwSFVxc01Rb0F3SGxZVWZmWlc5YTFmRzFlS2h0?=
 =?utf-8?B?aHNZV3ROQWl2MTQwNEFGaXF0cXVMeGp5dDdoNWlwQ0UxTURUc2hJWDVGZmly?=
 =?utf-8?B?UG5WTlJZQnJ1VFlzSkQ1N252OHVSRVh1ekg4UHM2WlN2dk0waE4yOVBsNnli?=
 =?utf-8?B?TmszdVJzNXZhK3haNDEwV29yQ0UwbS9XU1RnL3REbEFEZ2RRblB4NXJzVXZr?=
 =?utf-8?B?MkZJWUF0K3pXKzhRTWVZMVQxalBFbEdOdHFrTHp3Qnl0ZHZQNWorRkJ1WlVL?=
 =?utf-8?B?SkhCUVVsSHFMVERIYUdMSjF6UUpOVXhFWW1POHdEWDd4Rm9ESVRLUXR0MGRK?=
 =?utf-8?B?QkhQNitvTTR6SFc3VUZkU09IQWVuN1MvRjNtT3ZZRmswS0lGQ2twVW9hcGdM?=
 =?utf-8?B?QkJHZzVOTTl2Q1ovcW9tYk9td2hPWEhKNTdjcDNQcW1LeUpJQUkzRmZJOHdF?=
 =?utf-8?B?aUlrdmhBR0ordWlobC9KY3BGWkR4VTVGZ0pScGtEalhmeElUbXdiMk5YZWs0?=
 =?utf-8?B?SWdTMnRLMzk0SWFwMjRqVTV0bUhNdnV3SzlhTlI2eFNKNW1xa3dBOTJqcDJs?=
 =?utf-8?B?QWZrSDNmWWFaZWE1SmpjR3dzc2liVjZweTFSbXp6MzVEcFU2R0pJZnFzU0xs?=
 =?utf-8?B?UFh3U0wveUhKc25ZejlaYWkrUXJqR3Y0YnJ2aUNzVEhJNGlzS0NxdENFaGQx?=
 =?utf-8?B?THNNY0JUMGczZStoU2xRTGF4eW83ZTlMb3oranZicGQxM3NiNXpKdkVhelB2?=
 =?utf-8?B?Wk91aTM2WEZUMkVzalptZWwrc1hZVWhVd3ozb08wV3dRMjZCRkdBbXR2SkMz?=
 =?utf-8?B?OWROQmMwMUFaMTFnWk9XWTFYb3NtbTJ5bHJudGVjZUVYR2xnbjZ2NmoyQUlQ?=
 =?utf-8?B?V0FvSVZwdjQ3akI5SnlmdXhGcDFaNG9SVHdPaDRPOVZKTEczUXA0K2FCMVk2?=
 =?utf-8?B?NmlkeW1WaXU1RWRKWXJ6NUxuRGRWNnprYnlZdUxRTkdwRVJER1I2bG1rOGVY?=
 =?utf-8?B?eCtOYWY0L2ljZjR4aWp3THpBMWVxRkRiaElSdXFOZjgyUHNjUHZ1YlJvemRE?=
 =?utf-8?B?ckVwR3BzWjVlSjRDd3UzNnZsVTA2YTVOd3AraDRrc0hPNTdlOEdDYUloQ0xa?=
 =?utf-8?B?UjdjSkU3VXlUekhmS3FOVTh3NmlzZXBQL2NBVUNEMWdmOEFCQzRiTHlwbWFm?=
 =?utf-8?B?V05yQU1qeitJczlKL05zQ2pZLzBQQXNPaUVDWVdIOVRhSGpNWW9BZi9LbXg3?=
 =?utf-8?B?Z2p5WTNxQ254VVkxNlZaRzFpQitMMThlSkx2d0ozamd3TzFIREY1bHQzNDVn?=
 =?utf-8?B?c0lHcVAwMVFYNE5YVGhtQ0dhRXpUVEo1dzZ5OVlpcXlZTWQ3OXdBdC9aK3lZ?=
 =?utf-8?B?NHBUSGp1WkFOK1p3T3lDc2JWd0hiUFJVZ2dPTEIwalkvQW1FQlM1bjYvS0Vx?=
 =?utf-8?B?NGJxTW1MQkFUcC9aRW9QTjVHSStkQ0xjc2VNUGkwQ2JjeEFURjVtZHRuM3kw?=
 =?utf-8?B?Tk0wQlFXOStGWXp3RWlkUDQ0Ui8rZW4zUDJLemg1OFo2NlQzdlhkTE9odTlz?=
 =?utf-8?Q?5a/wdrK/JGdF6K/C5l0VkrDjc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e4cdfc-34aa-43f8-b787-08dae1eb798f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:04:30.0778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBT1MVh1IpXRF88XalVGUt+jKl6Fr4yap0MKlcRROuXKSoumXSEMmTK4x4dQ/Rjsds8Vt9WLGXXzECGtKGLMxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5942
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/22 13:40, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
> it as the measurement of the guest at launch.
> 
> While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
> to encrypt the VMSA pages.
> 
> If its an SNP guest, then VMSA was added in the RMP entry as
> a guest owned page and also removed from the kernel direct map
> so flush it later after it is transitioned back to hypervisor
> state and restored in the direct map.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Harald Hoyer <harald@profian.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   .../virt/kvm/x86/amd-memory-encryption.rst    |  22 ++++
>   arch/x86/kvm/svm/sev.c                        | 119 ++++++++++++++++++
>   include/uapi/linux/kvm.h                      |  14 +++
>   3 files changed, 155 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index c94be8e6d657..e4b42aaab1de 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -513,6 +513,28 @@ Returns: 0 on success, -negative on error
>   See the SEV-SNP spec for further details on how to build the VMPL permission
>   mask and page type.
>   
> +21. KVM_SNP_LAUNCH_FINISH
> +-------------------------
> +
> +After completion of the SNP guest launch flow, the KVM_SNP_LAUNCH_FINISH command can be
> +issued to make the guest ready for the execution.
> +
> +Parameters (in): struct kvm_sev_snp_launch_finish
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_finish {
> +                __u64 id_block_uaddr;
> +                __u64 id_auth_uaddr;
> +                __u8 id_block_en;
> +                __u8 auth_key_en;
> +                __u8 host_data[32];

This is missing the 6 bytes of padding at the end of the struct.

> +        };
> +
> +
> +See SEV-SNP specification for further details on launch finish input parameters.
>   
>   References
>   ==========
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 379e61a9226a..6f901545bed9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2243,6 +2243,106 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   				      snp_launch_update_gfn_handler, argp);
>   }
>   
> +static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_update data = {};
> +	int i, ret;
> +
> +	data.gctx_paddr = __psp_pa(sev->snp_context);
> +	data.page_type = SNP_PAGE_TYPE_VMSA;
> +
> +	for (i = 0; i < kvm->created_vcpus; i++) {
> +		struct vcpu_svm *svm = to_svm(xa_load(&kvm->vcpu_array, i));
> +		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +		/* Perform some pre-encryption checks against the VMSA */
> +		ret = sev_es_sync_vmsa(svm);
> +		if (ret)
> +			return ret;
> +
> +		/* Transition the VMSA page to a firmware state. */
> +		ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);
> +		if (ret)
> +			return ret;
> +
> +		/* Issue the SNP command to encrypt the VMSA */
> +		data.address = __sme_pa(svm->sev_es.vmsa);
> +		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +				      &data, &argp->error);
> +		if (ret) {
> +			snp_page_reclaim(pfn);
> +			return ret;
> +		}
> +
> +		svm->vcpu.arch.guest_state_protected = true;
> +	}
> +
> +	return 0;
> +}
> +
> +static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_snp_launch_finish params;
> +	struct sev_data_snp_launch_finish *data;
> +	void *id_block = NULL, *id_auth = NULL;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flow. */
> +	ret = snp_launch_update_vmsa(kvm, argp);
> +	if (ret)
> +		return ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (params.id_block_en) {
> +		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
> +		if (IS_ERR(id_block)) {
> +			ret = PTR_ERR(id_block);
> +			goto e_free;
> +		}
> +
> +		data->id_block_en = 1;
> +		data->id_block_paddr = __sme_pa(id_block);
> +
> +		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
> +		if (IS_ERR(id_auth)) {
> +			ret = PTR_ERR(id_auth);
> +			goto e_free_id_block;
> +		}
> +
> +		data->id_auth_paddr = __sme_pa(id_auth);
> +
> +		if (params.auth_key_en)
> +			data->auth_key_en = 1;
> +	}
> +
> +	data->gctx_paddr = __psp_pa(sev->snp_context);

This is missing the copying of the params.host_data field into the 
data->host_data field. This is needed so that the host_data shows up in 
the attestation report.

Thanks,
Tom

> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
> +
> +	kfree(id_auth);
> +
> +e_free_id_block:
> +	kfree(id_block);
> +
> +e_free:
> +	kfree(data);
> +
> +	return ret;
> +}
> +
>   int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -2339,6 +2439,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_SNP_LAUNCH_UPDATE:
>   		r = snp_launch_update(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SNP_LAUNCH_FINISH:
> +		r = snp_launch_finish(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> @@ -2794,11 +2897,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>   
>   	svm = to_svm(vcpu);
>   
> +	/*
> +	 * If its an SNP guest, then VMSA was added in the RMP entry as
> +	 * a guest owned page. Transition the page to hypervisor state
> +	 * before releasing it back to the system.
> +	 * Also the page is removed from the kernel direct map, so flush it
> +	 * later after it is transitioned back to hypervisor state and
> +	 * restored in the direct map.
> +	 */
> +	if (sev_snp_guest(vcpu->kvm)) {
> +		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
> +			goto skip_vmsa_free;
> +	}
> +
>   	if (vcpu->arch.guest_state_protected)
>   		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
>   
>   	__free_page(virt_to_page(svm->sev_es.vmsa));
>   
> +skip_vmsa_free:
>   	if (svm->sev_es.ghcb_sa_free)
>   		kvfree(svm->sev_es.ghcb_sa);
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9b6c95cc62a8..c468adc1f147 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1942,6 +1942,7 @@ enum sev_cmd_id {
>   	KVM_SEV_SNP_INIT,
>   	KVM_SEV_SNP_LAUNCH_START,
>   	KVM_SEV_SNP_LAUNCH_UPDATE,
> +	KVM_SEV_SNP_LAUNCH_FINISH,
>   
>   	KVM_SEV_NR_MAX,
>   };
> @@ -2076,6 +2077,19 @@ struct kvm_sev_snp_launch_update {
>   	__u8 vmpl1_perms;
>   };
>   
> +#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
> +#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
> +#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
> +
> +struct kvm_sev_snp_launch_finish {
> +	__u64 id_block_uaddr;
> +	__u64 id_auth_uaddr;
> +	__u8 id_block_en;
> +	__u8 auth_key_en;
> +	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
> +	__u8 pad[6];
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
