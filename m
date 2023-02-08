Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6639168F9E5
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 22:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjBHVvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 16:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjBHVvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 16:51:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54E2227AC;
        Wed,  8 Feb 2023 13:50:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahlbF7S+o+yJqZcaWog2lc2LR5gnej/FeEuDukK212z+VN9Y45Z+ipo6m0NJF2iMjJXHEePgnxp8cj50tyN38hLxETwLkadwx+OpjDo+DCi+v+KJN6QGEQOilQA9wFkZlLkrndvJEcjkf1wAA7BHlMn0UerFW3mNesGK6B+wrUdRaxt5g2cxvOjImY6hUFTBPWhF+5hh7olDY4ov6nefevcPF+SaERPHrLKfAG7g+C+jV/H73P0zCuWFpqRuCC7zaQ2d1DTrqrwcLqdrJZsO4KjmtOR1Ie7vXEOMLUFG0qiBq6rNBG9PZmxZD9CZNGVs+a9EgF2Pl9qzHmWJpbzIrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yu2BFEtnhnzOd8SwQqbNAnbEj1qZUp4SOXIYOSy4faY=;
 b=am6to1a2AEGAZ+1jzeNgWDxOyYGra4cYbmfVsC51vbqUqMgvDAhee5xQMccSsQdWmkTi0AEPDSyF8Jn6twoJio4f9316DgQi++1jKhFe1LCSs5A4cucUF5nX7rUIodyosAqZWHfmPdFSt8KAwnR6YJFTX9REsnZNZj1+i0EhW5f6y7uouPkAuSquW9A1tSC5jRC6Sru/VWJx+m5AGIESLpIc12dQq4tVcUlzb22ew/LN058tSoUtz1jyFyQGNVA5SzaQXY1h+K38baDrg98D261AmTFsAq5vr4xDG4C0WJW9r5+vMII6YXGAgcKXYR5NuFxo4+wO3DvjeYXI1wh89g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yu2BFEtnhnzOd8SwQqbNAnbEj1qZUp4SOXIYOSy4faY=;
 b=J8EsLO7h938M5mwuxhv76VfGF9riFj5CNNztDBpq+TRp+Pt528Q/jKM1UhRDxHhZ2NbdB18IsgxYTdIH/OepaPkryt3x5P7rbyY7IStBM+YgRj6bNQ/lKJ37JTHRSmQeg/2H+TBVVzY7Bmf3dEJjQiqFi56gPQkHPRxxxkMi8P4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by IA0PR12MB8208.namprd12.prod.outlook.com (2603:10b6:208:409::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Wed, 8 Feb
 2023 21:50:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6064.029; Wed, 8 Feb 2023
 21:50:57 +0000
Message-ID: <8ad433cf-36bc-63e8-4f8c-13e2a283c61c@amd.com>
Date:   Wed, 8 Feb 2023 15:50:53 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH kernel] KVM: SVM: Fix SVM_VMGEXIT_EXT_GUEST_REQUEST to
 follow the rest of API
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
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
 <ff0ffddf-9a4b-e1cd-7c34-73412c89ded6@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ff0ffddf-9a4b-e1cd-7c34-73412c89ded6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:610:e5::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|IA0PR12MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a7d5cf-1e82-45dc-c13b-08db0a1e8ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QA/otS2rTdGb5q2r/sBvLrt9LyuT1TNlGGxh9SkbfJ+MSGdZWdE+U4IyPERjDIS5bxQitRwLhm03W5IFJZo+JJUR+GHcw5Ryz9/PdBZdC8HzQRPiQbL926+HwZkV6N5vrJ7HCbs2cywoavilNBw2pmA1o7UaibpyKHSRCHyXTwW+Bcp/kMCJCn16mvi3vaWyfGpc1fAOpbctW+koDfz2m4j19RADy9b7s2Jmt1QQgMkhVyVPpPC+HpMhn8NNkuCduWpgJ7gAWzEHy6YsRuvA0Ykhg5JEIjutxo463XzFH1PhHT3HppSvfWHdT4+oGBF1u3+T9UXH2hHXmF2oe64CSra2OZ0xQiPpCKZH4q/xhNlTxY1zdP3wI2EHq7NWKKFHUD/F/M1+kW07Ju/QqW+v36McW7FS2qhZ95rl77KHWr+ixkzvntYbYP55gd/l0OsaXnI1RiQCROWF65mifBCGZrKlYkuhsa1TZg7UfHuoE1Ah06A7vPtXxgSGNUFQo3aFhXpds5YjipnG71O75wiYR/OrsH2NtMtmwEaQH5rZ44Y9fT+lwggXLvVS9YndyQRl6mIQYtkowsNLjJhFxG8Gj/T27yMexyZb57S8f0+MWHW+VoACbR2j81R8kQVXEcY9TSV9wPdOl+Ff0RV+nUQDIi2E1ZAFtEgVmUtxPAXvUNBto0DK7bIZ352+q6RzjWyQZ+gsPFXuLnQG9yIY09kaGSprmv/T16dsbCI+b9+whs4DuipDwCvwq8b95DzwLg/cUJeJxdhxW5qFpxkD8PgKJUXbt3kPsQj9AC6YHIMZe6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199018)(966005)(83380400001)(38100700002)(478600001)(316002)(54906003)(31696002)(6506007)(7416002)(53546011)(4326008)(36756003)(30864003)(2616005)(26005)(6512007)(86362001)(2906002)(186003)(8676002)(5660300002)(8936002)(6666004)(66556008)(66476007)(6486002)(31686004)(41300700001)(66946007)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXhBbWVEVWMwMUZjWU14UlNNdzVVNk55ZkV3c1VuTVo0aE9ZZ3k2L2w0ZTZq?=
 =?utf-8?B?UUx6ZlhubmNJQ1BoQTZqNGcySlJEVmdqSUtGRVN6QjVrTCtmZUV6Y1ZsNFpS?=
 =?utf-8?B?N1lPUEt4VkdHVnFrTUlpRlZQMEs5REZWaU5xU3NOSHh1eElzMThlZGhCYVRk?=
 =?utf-8?B?eHorQ2ZGb0JHYXl1YWRCdlFFdE9ST1kvaGV1eVJnTG1WVVVpWEMwT3c5eFRn?=
 =?utf-8?B?TGhLUmtaUnEveXloWmZHSElwSStCTmVNRi9NK29ybGpsRVZJeWJtQnFoVUNv?=
 =?utf-8?B?WWR1c0lhSmRVcmZZQjZLcnU4L21wTDVlK0lOZTE4MXl3ZDVHNS9rVCtZam5B?=
 =?utf-8?B?aDk3c1NtQWc4WE8rbVdtQWlMTzdOODlMdmxVaTNDY1BTWit0aW9jZGFhZ3Ni?=
 =?utf-8?B?eThFS0g2SjZCTk9tSHVOWGZ3akZJTFhOem5NQmY2YXNCdHlGeXppVy90cEdW?=
 =?utf-8?B?WFIwNzZ4ZlpESHBrZXpaWnBzU1ZOMlVhMDM2akE3Q2FRVnN1Z3N0V09hZDJv?=
 =?utf-8?B?bGMwOHJxWEZVcEMrYURvSGp1Wm5TcGU5d2JkaitiazkwUHYranlHc3hybUFP?=
 =?utf-8?B?WjdURUN3b3NhaVM2N2Y3cEcwM2FDNFFVMTJVMmpSYm42S0g0eTN6YzhZNkg5?=
 =?utf-8?B?K3h5TVJWUGoyVkh1QXQvaVZpRlBHUW9YV0NubW1sNW1waFNQejhqV0VCYWls?=
 =?utf-8?B?V00yVkNGRmFkU0xHVXBNNCtCTFovNEYvbnZXR0ZBYldxNHFYM2pUT1pCYmJZ?=
 =?utf-8?B?TmVxR0wrWUxKMWRyMXN1QXBSOWl4eXRTbVB0SStDOEtYZFFnTXBpcXdEUVFu?=
 =?utf-8?B?eHZMWUk2Y2tzMlNtZUNFdThYNEdMNUZoWkxjN21hWjJXSmIvczNGT1hLblRv?=
 =?utf-8?B?YkluQXgwRkZzNFRiY2s3R0JVK3NDc1NtbmpoUGRvMjZ3elpDd2l6S0RXbmdw?=
 =?utf-8?B?UW9FZzVpL3ZFSnZpVnJnSm1CeEdkWnBtOHdBck1iUkpzZWtDSzIveHZwWE9x?=
 =?utf-8?B?MGJ2R1ZOMFRKUkx3TTlTRkFESnU1ZXl4TEtnVnFxK09rSlR6dXU1cE0vZTZF?=
 =?utf-8?B?TGNxalJyeTBIRisyRU1MOXpPWmprOGN2cDVlUjZIZzU1Y1lObW44bWlsc2JC?=
 =?utf-8?B?dFZrZWpQZHUydm42UkJlSGpHZkxHTnRkc0I2enovZld3REdRM3RYdXowamNa?=
 =?utf-8?B?bFJKbUlxMVdpMnBZV2NPOGtQL3lxSitXakduUUJ5TmNtemk3WmdQVTdPMSsw?=
 =?utf-8?B?TTBRbUNsbmR2azRVekI1TnBDMlB2ekV6TDJXcDlFTkFiWUVQRGpHTHpKS0M3?=
 =?utf-8?B?TmRRdkVhZTNXdzJqY1JQaEZDalNzRk5JT2xKZ1VBakZNQU9WRXFwa2tpdFVm?=
 =?utf-8?B?Sjl6TGdDTEMyMlNGdlF0dkdkbUIrdlIrV3pVbmwwNkE3M2pFODJvZDBaUUc4?=
 =?utf-8?B?SEN1TDJHWkJLd2VEcjk2NG9lYW54R2phWU44Q1luVlFVbk10TWY1a1JITXIx?=
 =?utf-8?B?Z2VjMW1ZbFBGdjh3YjBqVlhtKzMvRG9MKzk2bERRdVk1c2J5TEQ5Y1huOEo3?=
 =?utf-8?B?bzQweGtvT21mS2M1bFZBaWpJUk9kdnBSSHdjZ08wSmN0NjJJNi9jQURxZkl6?=
 =?utf-8?B?ZjZUTW1URFZPNnZ3cHJLZWdZZkJzMGlCa3ludG1udUpCMENMTmtRekVOWkFJ?=
 =?utf-8?B?QWlBeFRTSnQ2NEFKUDZraUFqVE9zb09qcmx2R05UbmdiVitWWUZSUFNKYkU4?=
 =?utf-8?B?MmZWS1lBUkt4MnhXaGhQR1pEUU16L0Zja3UxMG1JYzAvbmRzWXpjQ2crbHA2?=
 =?utf-8?B?bkppZFhiNlc0Z0g0ZHpFY1gzWFl1R1dUSmNzbEVIVFhLczNmNWxwR2NzRWZh?=
 =?utf-8?B?TnFJM3lXdjQxWkNkMWZ6Zi80TzZCckZSY3BoSUdBcVdhb00wV2IvNXV3Rlla?=
 =?utf-8?B?NmNHdmlEa3FOclE5Q01QVW9wanpPaThPc09iMkNvMi9Zc0R3cElUWk52N0Vl?=
 =?utf-8?B?czB4YmdEbE5FYTBIaXpyN0hWZ2RaNlh3TUE4a3V5SlZaaWJrZmxTcVlERHNo?=
 =?utf-8?B?b1ZPUlZlNzNtNWtJN2ROTWF2b3lkd054R0ZiV1gxWVBzL3UwQzQ4UnhGaXZJ?=
 =?utf-8?Q?2VLadK0rAqNVigrLMFg57yp/+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a7d5cf-1e82-45dc-c13b-08db0a1e8ef5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 21:50:56.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSDey+NRkLUU1FoHYzRIaSEnmlPJcQ3DTdjJksaro7cB5V/y7nO/GcG+SrUo/8INoRoWBk2WfO8duHrV6hs3Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8208
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alexey,

On 2/6/2023 7:24 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 07/02/2023 08:57, Kalra, Ashish wrote:
>> On 2/5/2023 9:13 PM, Alexey Kardashevskiy wrote:
>>> When SVM VM is up, KVM uses sev_issue_cmd_external_user() with an open
>>> /dev/sev fd which ensures that the SVM initialization was done 
>>> correctly.
>>> The only helper not following the scheme is 
>>> snp_guest_ext_guest_request()
>>> which bypasses the fd check.
>>>
>>> Change the SEV API to require passing a file.
>>>
>>> Handle errors with care in the SNP Extended Guest Request handler
>>> (snp_handle_ext_guest_request()) as there are actually 3 types of 
>>> errors:
>>> - @rc: return code SEV device's sev_issue_cmd() which is int==int32;
>>> - @err: a psp return code in sev_issue_cmd(), also int==int32 (probably
>>> a mistake but kvm_sev_cmd::error uses __u32 for some time now);
>>> - (added by this) @exitcode: GHCB's exit code sw_exit_info_2, uint64.
>>>
>>> Use the right types, remove cast to int* and return ENOSPC from SEV
>>> device for converting it to the GHCB's exit code
>>> SNP_GUEST_REQ_INVALID_LEN==BIT(32).
>>>
>>> Fixes: 17f1d0c995ac ("KVM: SVM: Provide support for SNP_GUEST_REQUEST 
>>> NAE event")
>>> While at this, preserve the original error in snp_cleanup_guest_buf().
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>> ---
>>>
>>> This can easily be squashed into what it fixes.
>>>
>>> The patch is made for
>>> https://github.com/AMDESE/linux/commits/upmv10-host-snp-v7-rfc
>>> ---
>>>   include/linux/psp-sev.h      | 62 +++++++++++---------
>>>   arch/x86/kvm/svm/sev.c       | 50 +++++++++++-----
>>>   drivers/crypto/ccp/sev-dev.c | 11 ++--
>>>   3 files changed, 73 insertions(+), 50 deletions(-)
>>>
>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>> index 970a9de0ed20..466b1a6e7d7b 100644
>>> --- a/include/linux/psp-sev.h
>>> +++ b/include/linux/psp-sev.h
>>> @@ -848,6 +848,36 @@ int sev_platform_status(struct 
>>> sev_user_data_status *status, int *error);
>>>   int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
>>>                   void *data, int *error);
>>> +/**
>>> + * sev_issue_cmd_external_user_cert - issue SEV command by other 
>>> driver with a file
>>> + * handle and return certificates set onto SEV device via 
>>> SNP_SET_EXT_CONFIG;
>>> + * intended for use by the SNP extended guest request command defined
>>> + * in the GHCB specification.
>>> + *
>>> + * @filep - SEV device file pointer
>>> + * @cmd - command to issue
>>> + * @data - command buffer
>>> + * @vaddr: address where the certificate blob need to be copied.
>>> + * @npages: number of pages for the certificate blob.
>>> + *    If the specified page count is less than the certificate blob 
>>> size, then the
>>> + *    required page count is returned with ENOSPC error code.
>>> + *    If the specified page count is more than the certificate blob 
>>> size, then
>>> + *    page count is updated to reflect the amount of valid data 
>>> copied in the
>>> + *    vaddr.
>>> + *
>>> + * @error: SEV command return code
>>> + *
>>> + * Returns:
>>> + * 0 if the sev successfully processed the command
>>> + * -%ENODEV    if the sev device is not available
>>> + * -%ENOTSUPP  if the sev does not support SEV
>>> + * -%ETIMEDOUT if the sev command timed out
>>> + * -%EIO       if the sev returned a non-zero return code
>>> + * -%ENOSPC    if the specified page count is too small
>>> + */
>>> +int sev_issue_cmd_external_user_cert(struct file *filep, unsigned 
>>> int cmd, void *data,
>>> +                     unsigned long vaddr, unsigned long *npages, int 
>>> *error);
>>> +
>>>   /**
>>>    * sev_guest_deactivate - perform SEV DEACTIVATE command
>>>    *
>>> @@ -945,32 +975,6 @@ void snp_free_firmware_page(void *addr);
>>>    */
>>>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
>>> -/**
>>> - * snp_guest_ext_guest_request - perform the SNP extended guest 
>>> request command
>>> - *  defined in the GHCB specification.
>>> - *
>>> - * @data: the input guest request structure
>>> - * @vaddr: address where the certificate blob need to be copied.
>>> - * @npages: number of pages for the certificate blob.
>>> - *    If the specified page count is less than the certificate blob 
>>> size, then the
>>> - *    required page count is returned with error code defined in the 
>>> GHCB spec.
>>> - *    If the specified page count is more than the certificate blob 
>>> size, then
>>> - *    page count is updated to reflect the amount of valid data 
>>> copied in the
>>> - *    vaddr.
>>> - *
>>> - * @sev_ret: sev command return code
>>> - *
>>> - * Returns:
>>> - * 0 if the sev successfully processed the command
>>> - * -%ENODEV    if the sev device is not available
>>> - * -%ENOTSUPP  if the sev does not support SEV
>>> - * -%ETIMEDOUT if the sev command timed out
>>> - * -%EIO       if the sev returned a non-zero return code
>>> - */
>>> -int snp_guest_ext_guest_request(struct sev_data_snp_guest_request 
>>> *data,
>>> -                unsigned long vaddr, unsigned long *npages,
>>> -                unsigned long *error);
>>> -
>>>   #else    /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>>   static inline int
>>> @@ -1013,9 +1017,9 @@ static inline void 
>>> *snp_alloc_firmware_page(gfp_t mask)
>>>   static inline void snp_free_firmware_page(void *addr) { }
>>> -static inline int snp_guest_ext_guest_request(struct 
>>> sev_data_snp_guest_request *data,
>>> -                          unsigned long vaddr, unsigned long *n,
>>> -                          unsigned long *error)
>>> +static inline int sev_issue_cmd_external_user_cert(struct file 
>>> *filep, unsigned int cmd,
>>> +                           void *data, unsigned long vaddr,
>>> +                           unsigned long *npages, int *error)
>>>   {
>>>       return -ENODEV;
>>>   }
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index d0e58cffd1ed..b268c35efab4 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -394,6 +394,23 @@ static int sev_issue_cmd(struct kvm *kvm, int 
>>> id, void *data, int *error)
>>>       return __sev_issue_cmd(sev->fd, id, data, error);
>>>   }
>>> +static int sev_issue_cmd_cert(struct kvm *kvm, int id, void *data,
>>> +                  unsigned long vaddr, unsigned long *npages, int 
>>> *error)
>>> +{
>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +    struct fd f;
>>> +    int ret;
>>> +
>>> +    f = fdget(sev->fd);
>>> +    if (!f.file)
>>> +        return -EBADF;
>>> +
>>> +    ret = sev_issue_cmd_external_user_cert(f.file, id, data, vaddr, 
>>> npages, error);
>>> +
>>> +    fdput(f);
>>> +    return ret;
>>> +}
>>> +
>>>   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>   {
>>>       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> @@ -3587,11 +3604,11 @@ static void snp_cleanup_guest_buf(struct 
>>> sev_data_snp_guest_request *data, unsig
>>>       int ret;
>>>       ret = snp_page_reclaim(pfn);
>>> -    if (ret)
>>> +    if (ret && (*rc == SEV_RET_SUCCESS))
>>>           *rc = SEV_RET_INVALID_ADDRESS;
>>>       ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>> -    if (ret)
>>> +    if (ret && (*rc == SEV_RET_SUCCESS))
>>>           *rc = SEV_RET_INVALID_ADDRESS;
>>>   }
>>
>> I believe we need to fix this as per the GHCB specifications.
>>
>> As per GHCB 2.0 specifications:
>>
>> SW_EXITINFO2
>> ...
>> State from Hypervisor: Upper
>> 32-bits (63:32) will contain the
>> return code from the hypervisor.
>> Lower 32-bits (31:0) will contain
>> the return code from the firmware
>> call (0 = success)
>>
>> So i believe the FW error code (which is the FW error code from 
>> SNP_GUEST_REQUEST or *rc here) should be contained in the lower 
>> 32-bits and the error code being returned back due to response buffer 
>> pages reclaim failure and/or failure to transisition these pages back 
>> to shared state is basically hypervisor (error) return code and that 
>> should be returned in the upper 32-bit of the exitinfo.
>>
>> There is work in progress to check conformance of SNP v7 patches to 
>> GHCB 2.0 specifications, so probably this fix can be included as part 
>> of those patches.
> 
> Yes, please :)
> 

Yes, will address this in the GHCB specs conformance patch-set for SNP 
as per the following revisions of the GHCB specs:

The SNP Guest Request and SNP Extended Guest Request have been updated 
to expand on the use of the SW_EXITINFO2 return value to better allow 
for the hypervisor to return error codes.

> 
>>
>>> @@ -3638,8 +3655,9 @@ static void snp_handle_ext_guest_request(struct 
>>> vcpu_svm *svm, gpa_t req_gpa, gp
>>>       struct kvm *kvm = vcpu->kvm;
>>>       unsigned long data_npages;
>>>       struct kvm_sev_info *sev;
>>> -    unsigned long rc, err;
>>
>> This needs to be looked at more carefully. The SEV firmware status 
>> code is defined as 32-bit, but is being handled as unsigned long in 
>> the KVM/SNP code and as int in the CCP driver. So this needs to be 
>> fixed consistently across,
> 
> Ultimately it should be explicit u32 in SEV and u64 in GHCB because PSP 
> and GHCB are binary interfaces and the sizes should be explicit. Error 
> codes between KVM and CCP can be anything (unsigned long, u64) as it is 
> the same binary.
> 

Again, as lower 32-bits (31:0) of SW_EXITINFO2 is supposed to be set
to the return code from the firmware, so this should also be u32 in GHCB 
and same in KVM/SNP code.

>  > snp_setup_guest_buf() return value will need to be
>> fixed accordingly.
>>
>>> +    unsigned long exitcode;
>>>       u64 data_gpa;
>>> +    int err, rc;
>>>       if (!sev_snp_guest(vcpu->kvm)) {
>>>           rc = SEV_RET_INVALID_GUEST;
>>> @@ -3669,17 +3687,16 @@ static void 
>>> snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>>>        */
>>>       if (sev->snp_certs_len) {
>>>           if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
>>> -            rc = -EINVAL;
>>> -            err = SNP_GUEST_REQ_INVALID_LEN;
>>> +            rc = -ENOSPC;
>>
>> Why do we need to introduce ENOSPC error code?
> 
> To distinguish it from other errors and return SNP_GUEST_REQ_INVALID_LEN 
> when needed (the commit log mentions this).
> 
> 
>> If we continue to use SNP_GUEST_REQ_INVALID_LEN we don't need to map 
>> ENOSPC to SNP_GUEST_REQ_INVALID_LEN below.
>> And the CCP driver can return SNP_GUEST_REQ_INVALID_LEN as earlier via 
>> the fw_err parameter.
> 
> imho this is a bad idea.
> 
> SNP_GUEST_REQ_INVALID_LEN is defined in the GHCB spec and GHCB is 
> between KVM and VM, /dev/sev is neither GHCB nor KVM. err here is for 
> the firmware errors but SNP_GUEST_REQ_INVALID_LEN is not from the 
> firmware and for not-from-the-firmware-errors we already have "return 
> rc" so lets just use that. Also err is 32bit across the place, in things 
> like sev_issue_cmd() and then there is this ugly cast to int*. Thanks,
> 

Ok, that does make sense.

Thanks,
Ashish
