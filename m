Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2ED68CBE9
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 02:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBGBZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 20:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjBGBZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 20:25:26 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BE1E2B6;
        Mon,  6 Feb 2023 17:25:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd0FEB6L74/zbopKRED5rG+mvhW781WBXxy70xRmwq20YQ/q71rXWFJFho6/T60j8MS1v8aCRMOSdhtPmQL+fiYJjSYg+soU6IR3VlqI9tvsxT2qzu3pNZvb12NgE5pwHSt//5PfPhCxNp36Ld4WB04W0HjkPywZzwJ0+GrXhB8JcjNQsmgySrFaft7/cycgB32TK4Rxwobhem7XvMaZdytOoL7S+Ygx2di3L5C/yUInjH/A2grdu7EUGJaDgWu4ULsy8i9o5hOJd5nO/L1md0CR0mEi3VEtPOMaqqnz+T6CRZfUa22g1TNifGOfoZotKQah/Fa0r+BJZydNLZdlWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NKiN8wpaal3mITUzBxXMbDvGIwU7GQ538GrKUB7gdI=;
 b=ntoLrxRmEZhyWMBTWRV1EllYL2Jd6qVFUlARLvIaxh8J4E7bTzpOVXA0GPYgq2Q/jICm8Zx6VyeSvk18LezBc1kSf3f+4E86Yzly00akkpbGvx6lxepWWLNLKOET2IWuTnFm/EPBdl6kUeoVn24IsDQC1M7+6EOLMzI1NkoZgMde/QZZWiJtknC/EMBLZpCHo28MYenlg2RJSDsrLgozuN63BPkP6SyoJl2cFlAU3J6DCtxynfTWubWID4Abb0uVhosBI/RL3haTOB9X/vZWkDRJFXYFBuUa+fYMlivg2r/yG2pSaQbFTCD7q5bA+H3y4333KxuQdZxzt9z5Jji1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NKiN8wpaal3mITUzBxXMbDvGIwU7GQ538GrKUB7gdI=;
 b=YNatIzf1gdmvc7DKvFmqtSwWYqa3DP+32+WqyeCKrjvWLQ+ZQK/qW9Qd5g3zOT/N8hzp+WvcSiIHhFIu+4MuFFsN3pTsuIAFwAS2mNPcEHLjYhpb5FT6yO0/NEYeBI1W+W5bJcMojxrfpEhNqZr8e6bZSgkinQWdWNxZctqqQEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 01:24:58 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%2]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 01:24:58 +0000
Message-ID: <ff0ffddf-9a4b-e1cd-7c34-73412c89ded6@amd.com>
Date:   Tue, 7 Feb 2023 12:24:43 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel] KVM: SVM: Fix SVM_VMGEXIT_EXT_GUEST_REQUEST to
 follow the rest of API
To:     "Kalra, Ashish" <ashish.kalra@amd.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        John Allen <john.allen@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dionna Glaze <dionnaglaze@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>
References: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
 <20230206031343.1646916-1-aik@amd.com>
 <f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0076.ausprd01.prod.outlook.com
 (2603:10c6:10:110::9) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: a8cbf12f-5867-43f8-1485-08db08aa2015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwaIvzj7pKeSGgaAqCvO/A2VOxhWrky6yVVhEz991Q1AT1Kyl8NMJ3mzGogjzFCn7XxQbtSXFX7sMWgj7A3FmwlVVffYhSFg4Te48NWLGVdvunbZecG4+Y0cnYWs1Voccv/xhRSxk9YTZWow7JWEWUBNh7KGQLZO1z4a6xmUuI0UjSb4yZVu9sqnD+j8XJjiazFFzmUvomISmU5NgeOHo8XKZ9sSLjjL1OTetBbJPZjT2QZn8EKresbIJHEXLvilCIwdRZGjOp6chxdq9jnKO95ctGWS2ZwEVndhWSWyJiWN0uF9rNL36PZpB8hAjLi46VnkXtYxi+4YJ2LlC/xKZXf4iECUO/uFMJPzvMCfluHRixTeN+/QYLFe57v9fMvu+qPwBwQovbfNPhG++bHmXzpgVbLKbkz9N6Qk7oOz308LVMlbd2ON6DJu9clrdHXge4qWT1rzTy2QnCXNviaiR9Svwcq/nTfI2Ike+Xq9oYSCzeph3TJVbDkTnafQ1mdRr4e1yT8bRLFeF+lv4YxSoA1DTn9WhkDY8FRidRREITDwKdVgUolDS3q36mNiaheykodJO4GTKQ19M6VPPaz5sd9f8AlZNwT5frDNoyYHAWlw3EqvbgtZ3tIlcuB24LAbAh/6EOReTpDO+YmBP/1JTcP1hQM0+/5FBWqi/87eRM67Lkjdzq6yV/YMV1CmC6OozUw5IAR4jGJfdCbvu3qvIOdmrfOwbv7BlRrQpGvdOjHxuyLnHJvEMUeo7iab6lNFig+4Zd3qFGv/lA2IFtJhExTJCjq2p4zShazIraJf3Rg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199018)(83380400001)(966005)(6666004)(478600001)(6486002)(2616005)(53546011)(6512007)(6506007)(186003)(26005)(31696002)(36756003)(38100700002)(8936002)(5660300002)(66946007)(66476007)(66556008)(41300700001)(31686004)(2906002)(30864003)(7416002)(316002)(54906003)(8676002)(4326008)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTQ4SVVGRlQyY1k3dXRlNU5KdUFjOUpna3VKRTJENTltRjhoaERMRHppbnJY?=
 =?utf-8?B?c0dRQi80VytPUG5sMFV5WkFOc3VML0lMYkMzOGxONktYeCtORkg1NzZETGpk?=
 =?utf-8?B?d0Z0ZTJWc3JoNjd4NEpiTWRrM1NUOUhSN1FUckNKUStsdEh1Mm5ydnpNQzRW?=
 =?utf-8?B?VW1DNm1mUEZkSE9jZjYyMzIvd0xPY3krYTVzNjk0bFZGUlNsdUNUN2lVeVA0?=
 =?utf-8?B?aC9yOXVLWFdkL3p4elB3SitSazYrNHpadnZEQ2pNY2lXNzhwOUpNeVdRU2V3?=
 =?utf-8?B?Nkg4M2pPUkNRYnZwZ2JxM2ZteVdmTHJ3UWVab2I3SVN2K1lldGh1VmtDNkVT?=
 =?utf-8?B?bnFVQlMwK0YvWnR4aDR0TVl3dU84T2dZZ1RvYXdkOFlXN1RmaFBuSW5lRkR6?=
 =?utf-8?B?WmFkT1pEUEFheDcwV1pKQmxMWU5vOUpRbEs5MVdZa0toalZvNDFnLzV2d0Z5?=
 =?utf-8?B?R0lqZEMrczAwMFBCZjVoV3BmTElua3EwV3BhRXc0c1RPcDNNa3YvQ1kwYjho?=
 =?utf-8?B?bk5wL3lwZExvWHJGSHpDaFJoMXJNZnoySEtoaC9mTHB0a1dsd0hBNHRVbUVF?=
 =?utf-8?B?L05udWVaQkhOYUpqdVZ3dTk3S3YxRVMrYUlseW5UNHY0SUNneUdnUTFnUDJZ?=
 =?utf-8?B?MWVBc3hxaVJ5VXF1S2VVdnRVUG5xY2Z5akF1ZUIweDF2R0hvdnorODg1eUMy?=
 =?utf-8?B?Y1VTaTY1TDVaRVZianBoMUZiZnBUbllMb3V2aER6QlIvL1pvV2NJUVBnU3lr?=
 =?utf-8?B?c3FVWFhOcy9kNWhDRTVyMmtBQWJvSlVHUjI5b0ZSaEZpWGlDQXF6aTNPZ0NW?=
 =?utf-8?B?UjFESVBEMTJWVzVlRzJiNnRXMDMxaDY2aUs4eEhMRDVZRjZDS1FqSkpBZnph?=
 =?utf-8?B?UzZxNkFoYkdOaEtOTlZ4VjBXbm9SdkExck5hZDJiQVFEVlFqdGpFNmgrdGhY?=
 =?utf-8?B?WThmeGtYY3dHOFl6OEx0ZUwzSi93T3NUNk52S3Z4elZNL2c5T0hWaWtHK1Bz?=
 =?utf-8?B?ZFZHRUViVkd4Vy9xck5XVzNPL05ZNjhJTUhBRm9kUjNyaVZhaFJIYWg0VDFR?=
 =?utf-8?B?R1UyV0llRHNGNW1aV1IvUVlOTHhBNXBuN0ZJYTkwelZ4QzEvaWthbytMcTRw?=
 =?utf-8?B?YmlUOUZDbWpDMnZvRitwbWxTeks5cm42L0dtaWkxaXViQlNjS3Z6bFJDekhW?=
 =?utf-8?B?MVNxNWNsdFZuS05Nc2dkMVBrT21uTGZpVGFTNU16U2RFRjBvbUlURCtNTFNO?=
 =?utf-8?B?Q0FhQk1OOE8ybHJucUpZY3I0eFYveGVKOVRyaEhodUZIV1M0VVBnRmhaTy9S?=
 =?utf-8?B?YTkvc2UwTllxWFZxTGNaQVhaNlFGMHd5dFFYUlV5a2NQT0owZW5QSGZRaStH?=
 =?utf-8?B?YVAxMWVXYS9tY3hSaGhqcnhxMTh1MnR0TmNQdlkvbVVhR1VGTis0Wk1iSEZY?=
 =?utf-8?B?OGdBbTNKSW1LM0NwUFJreXhXbk13dHRaZ1Vkc0ZiaFVSSEJmbFk2SmVyb2tG?=
 =?utf-8?B?Z1dhcnhWaWZVWnBPR3VWaWtWTlhhaGI0VWpoY0F2TDVxYWxGT0owVTNpODcr?=
 =?utf-8?B?ZWpKb2xoN2hkSjZoQ3VzaUhoQUxMcW1sYVZlTmlQMWVGbkZnMjVlM3Q3Skpa?=
 =?utf-8?B?UW1odStyNGp0b29uWUJIUUE1WG5qZElqYmt3UWpsUjE3cWRjREFwQ0dPU3Ax?=
 =?utf-8?B?OWQrODU1eU1KOXl5cEZPWU1uV2I3TVFVSU5jYUhVMHB4bDNoeHpZcGxRWUMy?=
 =?utf-8?B?aHJUQzU4T2haUkVSbXhaNUd4ZFU5eW15d3lVeXZtTnIwck9FTzkzT1BRNG8z?=
 =?utf-8?B?cjdYQi9oc2ZMMU5DOHloRmdvOWt1UlFuMWNxOWlQL3c1UkVNcDVsTy9VanJt?=
 =?utf-8?B?eWpaVDMyOThUZGgyS2VKSFJDRjE1bk1XcGhOMUhKTkRrdVZOZTh4VTdDS3NN?=
 =?utf-8?B?RWNWeHFnb0hjeWZCRUhZdVRlUU96TWljeXlXcmtNTzFSVWRWek82NXc5Lzd4?=
 =?utf-8?B?Z1FZZzV0RXR0QWYzMlpEWlpGVXUvSEtpNVE0MUdicDNmd2pwbzlsNlJvQm1l?=
 =?utf-8?B?d2ZiSjJsUTcyV3ZsaFhuWGw4aFR4Mjg1V1VrTkNJVmtBc0VzcE50ZTlTSUwy?=
 =?utf-8?Q?Z8lAlE+XKXWfNuEBNPyNpq4/b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8cbf12f-5867-43f8-1485-08db08aa2015
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 01:24:58.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtp8oey/k0LaSNcLpHMQtx/IFLtYb6UFG/AO/mUJUhTIQFUl7c4Si6XzJP4NC2zv88qup++2I9GBfwNUzXbQvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/02/2023 08:57, Kalra, Ashish wrote:
> On 2/5/2023 9:13 PM, Alexey Kardashevskiy wrote:
>> When SVM VM is up, KVM uses sev_issue_cmd_external_user() with an open
>> /dev/sev fd which ensures that the SVM initialization was done correctly.
>> The only helper not following the scheme is snp_guest_ext_guest_request()
>> which bypasses the fd check.
>>
>> Change the SEV API to require passing a file.
>>
>> Handle errors with care in the SNP Extended Guest Request handler
>> (snp_handle_ext_guest_request()) as there are actually 3 types of errors:
>> - @rc: return code SEV device's sev_issue_cmd() which is int==int32;
>> - @err: a psp return code in sev_issue_cmd(), also int==int32 (probably
>> a mistake but kvm_sev_cmd::error uses __u32 for some time now);
>> - (added by this) @exitcode: GHCB's exit code sw_exit_info_2, uint64.
>>
>> Use the right types, remove cast to int* and return ENOSPC from SEV
>> device for converting it to the GHCB's exit code
>> SNP_GUEST_REQ_INVALID_LEN==BIT(32).
>>
>> Fixes: 17f1d0c995ac ("KVM: SVM: Provide support for SNP_GUEST_REQUEST 
>> NAE event")
>> While at this, preserve the original error in snp_cleanup_guest_buf().
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>
>> This can easily be squashed into what it fixes.
>>
>> The patch is made for
>> https://github.com/AMDESE/linux/commits/upmv10-host-snp-v7-rfc
>> ---
>>   include/linux/psp-sev.h      | 62 +++++++++++---------
>>   arch/x86/kvm/svm/sev.c       | 50 +++++++++++-----
>>   drivers/crypto/ccp/sev-dev.c | 11 ++--
>>   3 files changed, 73 insertions(+), 50 deletions(-)
>>
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 970a9de0ed20..466b1a6e7d7b 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -848,6 +848,36 @@ int sev_platform_status(struct 
>> sev_user_data_status *status, int *error);
>>   int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
>>                   void *data, int *error);
>> +/**
>> + * sev_issue_cmd_external_user_cert - issue SEV command by other 
>> driver with a file
>> + * handle and return certificates set onto SEV device via 
>> SNP_SET_EXT_CONFIG;
>> + * intended for use by the SNP extended guest request command defined
>> + * in the GHCB specification.
>> + *
>> + * @filep - SEV device file pointer
>> + * @cmd - command to issue
>> + * @data - command buffer
>> + * @vaddr: address where the certificate blob need to be copied.
>> + * @npages: number of pages for the certificate blob.
>> + *    If the specified page count is less than the certificate blob 
>> size, then the
>> + *    required page count is returned with ENOSPC error code.
>> + *    If the specified page count is more than the certificate blob 
>> size, then
>> + *    page count is updated to reflect the amount of valid data 
>> copied in the
>> + *    vaddr.
>> + *
>> + * @error: SEV command return code
>> + *
>> + * Returns:
>> + * 0 if the sev successfully processed the command
>> + * -%ENODEV    if the sev device is not available
>> + * -%ENOTSUPP  if the sev does not support SEV
>> + * -%ETIMEDOUT if the sev command timed out
>> + * -%EIO       if the sev returned a non-zero return code
>> + * -%ENOSPC    if the specified page count is too small
>> + */
>> +int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int 
>> cmd, void *data,
>> +                     unsigned long vaddr, unsigned long *npages, int 
>> *error);
>> +
>>   /**
>>    * sev_guest_deactivate - perform SEV DEACTIVATE command
>>    *
>> @@ -945,32 +975,6 @@ void snp_free_firmware_page(void *addr);
>>    */
>>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
>> -/**
>> - * snp_guest_ext_guest_request - perform the SNP extended guest 
>> request command
>> - *  defined in the GHCB specification.
>> - *
>> - * @data: the input guest request structure
>> - * @vaddr: address where the certificate blob need to be copied.
>> - * @npages: number of pages for the certificate blob.
>> - *    If the specified page count is less than the certificate blob 
>> size, then the
>> - *    required page count is returned with error code defined in the 
>> GHCB spec.
>> - *    If the specified page count is more than the certificate blob 
>> size, then
>> - *    page count is updated to reflect the amount of valid data 
>> copied in the
>> - *    vaddr.
>> - *
>> - * @sev_ret: sev command return code
>> - *
>> - * Returns:
>> - * 0 if the sev successfully processed the command
>> - * -%ENODEV    if the sev device is not available
>> - * -%ENOTSUPP  if the sev does not support SEV
>> - * -%ETIMEDOUT if the sev command timed out
>> - * -%EIO       if the sev returned a non-zero return code
>> - */
>> -int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> -                unsigned long vaddr, unsigned long *npages,
>> -                unsigned long *error);
>> -
>>   #else    /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>   static inline int
>> @@ -1013,9 +1017,9 @@ static inline void 
>> *snp_alloc_firmware_page(gfp_t mask)
>>   static inline void snp_free_firmware_page(void *addr) { }
>> -static inline int snp_guest_ext_guest_request(struct 
>> sev_data_snp_guest_request *data,
>> -                          unsigned long vaddr, unsigned long *n,
>> -                          unsigned long *error)
>> +static inline int sev_issue_cmd_external_user_cert(struct file 
>> *filep, unsigned int cmd,
>> +                           void *data, unsigned long vaddr,
>> +                           unsigned long *npages, int *error)
>>   {
>>       return -ENODEV;
>>   }
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index d0e58cffd1ed..b268c35efab4 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -394,6 +394,23 @@ static int sev_issue_cmd(struct kvm *kvm, int id, 
>> void *data, int *error)
>>       return __sev_issue_cmd(sev->fd, id, data, error);
>>   }
>> +static int sev_issue_cmd_cert(struct kvm *kvm, int id, void *data,
>> +                  unsigned long vaddr, unsigned long *npages, int 
>> *error)
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct fd f;
>> +    int ret;
>> +
>> +    f = fdget(sev->fd);
>> +    if (!f.file)
>> +        return -EBADF;
>> +
>> +    ret = sev_issue_cmd_external_user_cert(f.file, id, data, vaddr, 
>> npages, error);
>> +
>> +    fdput(f);
>> +    return ret;
>> +}
>> +
>>   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   {
>>       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -3587,11 +3604,11 @@ static void snp_cleanup_guest_buf(struct 
>> sev_data_snp_guest_request *data, unsig
>>       int ret;
>>       ret = snp_page_reclaim(pfn);
>> -    if (ret)
>> +    if (ret && (*rc == SEV_RET_SUCCESS))
>>           *rc = SEV_RET_INVALID_ADDRESS;
>>       ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>> -    if (ret)
>> +    if (ret && (*rc == SEV_RET_SUCCESS))
>>           *rc = SEV_RET_INVALID_ADDRESS;
>>   }
> 
> I believe we need to fix this as per the GHCB specifications.
> 
> As per GHCB 2.0 specifications:
> 
> SW_EXITINFO2
> ...
> State from Hypervisor: Upper
> 32-bits (63:32) will contain the
> return code from the hypervisor.
> Lower 32-bits (31:0) will contain
> the return code from the firmware
> call (0 = success)
> 
> So i believe the FW error code (which is the FW error code from 
> SNP_GUEST_REQUEST or *rc here) should be contained in the lower 32-bits 
> and the error code being returned back due to response buffer pages 
> reclaim failure and/or failure to transisition these pages back to 
> shared state is basically hypervisor (error) return code and that should 
> be returned in the upper 32-bit of the exitinfo.
> 
> There is work in progress to check conformance of SNP v7 patches to GHCB 
> 2.0 specifications, so probably this fix can be included as part of 
> those patches.

Yes, please :)


> 
>> @@ -3638,8 +3655,9 @@ static void snp_handle_ext_guest_request(struct 
>> vcpu_svm *svm, gpa_t req_gpa, gp
>>       struct kvm *kvm = vcpu->kvm;
>>       unsigned long data_npages;
>>       struct kvm_sev_info *sev;
>> -    unsigned long rc, err;
> 
> This needs to be looked at more carefully. The SEV firmware status code 
> is defined as 32-bit, but is being handled as unsigned long in the 
> KVM/SNP code and as int in the CCP driver. So this needs to be fixed 
> consistently across,

Ultimately it should be explicit u32 in SEV and u64 in GHCB because PSP 
and GHCB are binary interfaces and the sizes should be explicit. Error 
codes between KVM and CCP can be anything (unsigned long, u64) as it is 
the same binary.

 > snp_setup_guest_buf() return value will need to be
> fixed accordingly.
> 
>> +    unsigned long exitcode;
>>       u64 data_gpa;
>> +    int err, rc;
>>       if (!sev_snp_guest(vcpu->kvm)) {
>>           rc = SEV_RET_INVALID_GUEST;
>> @@ -3669,17 +3687,16 @@ static void 
>> snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>>        */
>>       if (sev->snp_certs_len) {
>>           if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
>> -            rc = -EINVAL;
>> -            err = SNP_GUEST_REQ_INVALID_LEN;
>> +            rc = -ENOSPC;
> 
> Why do we need to introduce ENOSPC error code?

To distinguish it from other errors and return SNP_GUEST_REQ_INVALID_LEN 
when needed (the commit log mentions this).


> If we continue to use SNP_GUEST_REQ_INVALID_LEN we don't need to map 
> ENOSPC to SNP_GUEST_REQ_INVALID_LEN below.
> And the CCP driver can return SNP_GUEST_REQ_INVALID_LEN as earlier via 
> the fw_err parameter.

imho this is a bad idea.

SNP_GUEST_REQ_INVALID_LEN is defined in the GHCB spec and GHCB is 
between KVM and VM, /dev/sev is neither GHCB nor KVM. err here is for 
the firmware errors but SNP_GUEST_REQ_INVALID_LEN is not from the 
firmware and for not-from-the-firmware-errors we already have "return 
rc" so lets just use that. Also err is 32bit across the place, in things 
like sev_issue_cmd() and then there is this ugly cast to int*. Thanks,


> 
> Thanks,
> Ashish
> 
>>               goto datalen;
>>           }
>> -        rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
>> -                   (int *)&err);
>> +        rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req, &err);
>>       } else {
>> -        rc = snp_guest_ext_guest_request(&req,
>> -                         (unsigned long)sev->snp_certs_data,
>> -                         &data_npages, &err);
>> +        rc = sev_issue_cmd_cert(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
>> +                    (unsigned long)sev->snp_certs_data,
>> +                    &data_npages, &err);
>>       }
>> +
>>   datalen:
>>       if (sev->snp_certs_len)
>>           data_npages = sev->snp_certs_len >> PAGE_SHIFT;
>> @@ -3689,27 +3706,30 @@ static void 
>> snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>>            * If buffer length is small then return the expected
>>            * length in rbx.
>>            */
>> -        if (err == SNP_GUEST_REQ_INVALID_LEN)
>> +        if (rc == -ENOSPC) {
>>               vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
>> +            exitcode = SNP_GUEST_REQ_INVALID_LEN;
>> +            goto cleanup;
>> +        }
>>           /* pass the firmware error code */
>> -        rc = err;
>> +        exitcode = err;
>>           goto cleanup;
>>       }
>>       /* Copy the certificate blob in the guest memory */
>>       if (data_npages &&
>>           kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, 
>> data_npages << PAGE_SHIFT))
>> -        rc = SEV_RET_INVALID_ADDRESS;
>> +        exitcode = SEV_RET_INVALID_ADDRESS;
>>   cleanup:
>> -    snp_cleanup_guest_buf(&req, &rc);
>> +    snp_cleanup_guest_buf(&req, &exitcode);
>>   unlock:
>>       mutex_unlock(&sev->guest_req_lock);
>>   e_fail:
>> -    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>> +    svm_set_ghcb_sw_exit_info_2(vcpu, exitcode);
>>   }
>>   static kvm_pfn_t gfn_to_pfn_restricted(struct kvm *kvm, gfn_t gfn)
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 6c4fdcaed72b..73f56c20255c 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -2070,8 +2070,8 @@ int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 
>> src_pfn, u64 dst_pfn, int *erro
>>   }
>>   EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
>> -int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> -                unsigned long vaddr, unsigned long *npages, unsigned 
>> long *fw_err)
>> +int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int 
>> cmd, void *data,
>> +                     unsigned long vaddr, unsigned long *npages, int 
>> *error)
>>   {
>>       unsigned long expected_npages;
>>       struct sev_device *sev;
>> @@ -2093,12 +2093,11 @@ int snp_guest_ext_guest_request(struct 
>> sev_data_snp_guest_request *data,
>>       expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
>>       if (*npages < expected_npages) {
>>           *npages = expected_npages;
>> -        *fw_err = SNP_GUEST_REQ_INVALID_LEN;
>>           mutex_unlock(&sev->snp_certs_lock);
>> -        return -EINVAL;
>> +        return -ENOSPC;
>>       }
>> -    rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
>> +    rc = sev_issue_cmd_external_user(filep, cmd, data, error);
>>       if (rc) {
>>           mutex_unlock(&sev->snp_certs_lock);
>>           return rc;
>> @@ -2115,7 +2114,7 @@ int snp_guest_ext_guest_request(struct 
>> sev_data_snp_guest_request *data,
>>       mutex_unlock(&sev->snp_certs_lock);
>>       return rc;
>>   }
>> -EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
>> +EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user_cert);
>>   static void sev_exit(struct kref *ref)
>>   {
>>

-- 
Alexey
