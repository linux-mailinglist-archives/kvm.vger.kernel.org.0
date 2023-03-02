Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427716A843D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 15:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCBOeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 09:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCBOeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 09:34:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D6F113F0;
        Thu,  2 Mar 2023 06:33:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXeykdkIJGEouaZijTDIxlOCaWi02jO3+vOprGrKFWgHwmTmgWJzQI1eVCPScY9vRJdbf/JX+NSPozRIAqt0iM/MuxhnZWJCxlAOoV8Et5+4rthxfKofvOK/uSFYcw/HUndPeDUTeEyq9fiB/wEL0oc+yPIAdo6J7dc2A0075mY8qEgeKIrxDgIWjqrNri7ODe4Z5uJo8Ol/6BhM+mun0ANf8UTDDGTXHkQTNZUIwo9SHDUwGSjuDe/jDxNC2zIcsV6L6t+V/bcKwd9NLtN6ZaKPTbBjpmMiXsAResuGJhq2jA0hpvP95zzTxDfsidTK5me2i5rKRyp3WTq2ZUqMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhxYtfk898Bw3+aVUXTCf2OdlDb6gKnOXAQznqyznsA=;
 b=XDJUB4teSFUtX+JRN/gJ713TWQxNqxeZtF4drDQfuM+WmJak1MHK8MJMDZsX4qI1NrTZJxdukIyG5+jAPvwauslw/dUgr732Q3G3hGKtEqClzBMxvs15czGjlKrRXTa8e+7XKfVlhRHlBPQiirFETAITbpgH6ZAwFkN4DghiU2lq3VdnYhkkfB0h6MHB+lsCZ/w6ayzB3QRK1Glzf9tjuWrhGxEWrQFxGX00NxRdXZRmTStzDe6sJxpE+pFaU4f6v/NAkx/0mcoibI65vLx0aToRQ6YejZSN+ic5YnNsR+DgjIom2HJVYqKC1SdwYl9IdTTkklgF9fTvGRQl9Y3s6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhxYtfk898Bw3+aVUXTCf2OdlDb6gKnOXAQznqyznsA=;
 b=N11GL9dwK0b+DoAXbgXmbJE61dJM9EtuwvjmFZYVwidKMkj3d1mtG8J6lJXIeS8sZPRmrwnMTMhWwHZniPtVg8MXKBm/qAm5M/VJI6iuYXbwqwey/OPbkQgiOJgAODsROZlf6PXvvPl507fR5/S4Cpa9lfHOGWqS1ULoVmpV+iQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 14:33:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%6]) with mapi id 15.20.6156.019; Thu, 2 Mar 2023
 14:33:50 +0000
Message-ID: <36734887-6474-b43e-51ae-34f37e6670a5@amd.com>
Date:   Thu, 2 Mar 2023 08:33:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 52/56] ccp: Add support to decrypt the page
To:     Dov Murik <dovmurik@linux.ibm.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-53-michael.roth@amd.com>
 <20230301232045.0000502e@intel.com>
 <e63ba525-644d-1a8c-afe7-2ced4a8fbb93@linux.ibm.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <e63ba525-644d-1a8c-afe7-2ced4a8fbb93@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:806:27::25) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7b8e88-1850-4096-458a-08db1b2b2374
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uA+/72okoEL5qucqdx4hP6AZAk4HYe9V8UOJnNN6I8oxN931qsXWtzrTsTRxQkFgyMRQ0po7AtEay2ne9gbb7LPxyDljRtXRd+MuV+Br4jkmx3Al9HakKxjnZKPyOp9X03YXZZO4mXTTYnYZU0FtuizrAY7cvmzD8v4sKFkZ8raWTKIKQaZ5ERqVI+hHNJjyLqO+69Q+6pTVtju2DX/ZCGh1djq1l6/Drvq2GPT33E98wZD/4v0jkXOfSE42M/c9yVp8kPJ1OtbfIJ40xpcXOIJq+23x8j0uG8YeNZeoyCtO0KtLWLHgpjSRqVP8wlR13xmQ+A1DwiOG3sJXLP+ytHxc/mvxnOHWAgnx6d8cjxYlFPXYMCPQDC1jQkDvD95X5XJYZLuJY34YpH4KR7aY/OuBdvpgivwZFM3VPW7arYvkmykrqQYAOx/8yRao7n47D8Co7fCRyjjXkG3KD81D/HKR4E3wRTApYf84IeDeR3lEvAE4Sj0Up/8P/G2vdGTmrpogXhR7B0WbhGoh+c1N9CMsEBaMVj78LS1yK4zYlih1x8h8sc4p8giv+O0Bx8MiS0uirz69qDi0HB+3vzkomAR0ZQr+dSS+edpM9tTySHkjPfzFwGDrls8iMMgaNeIJii0SehfbpgagrcFSkXlzqKI27fow7xiL7hz6S0XxOgSI9bGzDYgCS72FsiLD/aFAH3hCp0fp4HgGK7372qUW6ILOBdcIloAkLDTox8jE4u04+EJU72OYPpVLWZO0B7C4U1r5GbqMmcs699xXypD87A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199018)(31686004)(36756003)(478600001)(83380400001)(110136005)(6636002)(316002)(4326008)(38100700002)(8676002)(66476007)(7406005)(41300700001)(2616005)(186003)(6506007)(5660300002)(53546011)(6666004)(26005)(6486002)(6512007)(31696002)(8936002)(66556008)(66946007)(7416002)(86362001)(2906002)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFdNR2JzSWRZZVZwUUVBQWVXY3dqbXRNS1FlWjR2eEh2bzlaRWxXNXlPdlpo?=
 =?utf-8?B?WWdOT3BZVm4zYjRsdHRHWk8yQXM1RGpheGVnZ0VGME1sZ3MzNHpPWENTTFVm?=
 =?utf-8?B?Ry9KdzFJdDY2RG8zODhHV3MxMnhlbUxTS3NhdGkxeGNOc2RjVkJEUEYxcnpL?=
 =?utf-8?B?RXdyb0lGYVVFanRuSE9ISWcrNXRmVUhRc2ZSQ2lUb01IbTZQakhORVBCWkdS?=
 =?utf-8?B?SU1nc3RLZklJQ1NjSmtWZUNGclBMd2NUdjU0SXBFdURZSVdhRTJCN1lsSHNZ?=
 =?utf-8?B?QmtxVWhhcmVqbFFFbXBzNlNPQnhxdnU2LzNQQTExVTh3ZVo4ZkZYTC9kK1Fi?=
 =?utf-8?B?R1JFazg1QlY4WW8wNGd5bVFCRmkwdExjV0h5SE9xaXNpZzNydkxUZ1NqMHpB?=
 =?utf-8?B?RGxCclB3dlMwbmZDZ3hCa3NpTVZuOVFZNVdpK1ZUd1VPVEgwNE4zRlZCTzVu?=
 =?utf-8?B?bVJwWDd1TVdab3B6THR3bk5YSWZUSFc2MVJKd1ZnU2tCeEIrTUoxeWlram41?=
 =?utf-8?B?REpueS9xK1I4RWhHeWlXN0JwaGtVc2FJMnZDbkdTRERXVFY5Q0ljQnFtUGkx?=
 =?utf-8?B?Wm9MOFNpd0tRSmFLTmpmK05VVVVrYTlpUGdhL1o2NVBEenhiWG5sZGNmQzlt?=
 =?utf-8?B?cWhIY3VXNXVLMExhVXJJclRkVUJCODFmcVNTUkxDTzJ6c3BPdVAvdzNWWEJn?=
 =?utf-8?B?aCswb2FyaG1ORThBV0s3YklOSXYyOVJDOEVPRC9pRVQyTVR5c0tYcEVmWVE0?=
 =?utf-8?B?ZVQ4VXdZRTRxVGVqVzJ4NmtqOHY2c2w0NG1JbE1VdCtDaEVNS3BFKzlVUTJr?=
 =?utf-8?B?enR4TmVseFVlRC8vQmRpQ2FGNWhORi9paUFFaVBHSmw2N25rUzNuQUF3WHJ0?=
 =?utf-8?B?MDI3ZFlvb2xCSHRTZlNHVTdxdTJXSVpXeDJPaVBxZEVMa0NFT0EzSk03NFRr?=
 =?utf-8?B?SjZzYmRsSERzN0dpUTBnM0hMTHFPdHFhdU4wVFZGWGp6OHpBRjRweWpLMVJo?=
 =?utf-8?B?empCMmtkRERTK05BcnFCaVNzZEhxVEhCU1ozVzZkQUczNkdOSVFUYWRZWmdi?=
 =?utf-8?B?OThnanFoV0EycFE1N1hDQWM4Z1M3cEI1SFVjUnFmeGh6Q1dvSXI1dVI3ZTQ1?=
 =?utf-8?B?NnFVeDlhM3JkRHJZYjhMb1hXUEVHaTdGQ0FPN01uRzNRcy9oOUIwaE5hNzJh?=
 =?utf-8?B?MUUwTy8wZWdDalJMMTZNaGNmRFZ3UU1DTDdUM2V4Y3JNV3N2RmVVY3Byck5w?=
 =?utf-8?B?Yjk2TTRYN3N0MkI1TFBKTzJqbzhvc3BENkIycEZ5T1hLMmZrT0NVcFZNYUtJ?=
 =?utf-8?B?QUM1TnF2UFJGV1c2TUZxMTJMY1lqdTZZK3dOc2tNTWhlQXJIaXhqb3oySDVX?=
 =?utf-8?B?U21yS2lHM2R4TDBzQThOaDc1TXUrNEZVMzBjNmZRaDNhWVM1RGc3MWRtQUdB?=
 =?utf-8?B?cUhETXlDSnFpdktOZW1IWmJsQ3lUbmFPcWptTmI0K0tTdStxeWRwVGE4Nm8r?=
 =?utf-8?B?SUxwRG14L29rQnRhS0NWZ2Vsa2d6VVBhd3doeEd2U1FWV1hCaVFvcStZZUpm?=
 =?utf-8?B?SzJCaUVhZ1pyU0IzTUNEemlBVEszZlJ3ODBYRkZpcE5iZzExWk42UTlvNmpI?=
 =?utf-8?B?ZDJvU2d5NFZTU3dMa1BOcWkyVzloSC9Oc2lZWnFlcG9GVGY0Y1Iyc0pJODg5?=
 =?utf-8?B?NGtzVWNmck1MOUxzR3JRbmdBdTVONUpZcFpwWXFOZE53NHp6c0RkVE1FNmp3?=
 =?utf-8?B?ODRDam1yK3lVZDcvMmFSMStjNGVmQjF6aUZCM1B5NldQMm5KZG5jd3o2WkRp?=
 =?utf-8?B?bHlGT2tDQ0g3aFNkVy8ycm9zVVp1ZXdXTHdsc0M0ZllCcUpoZ3J1a2Z6Uy8v?=
 =?utf-8?B?ZHZJY1NjRTlQb0hqYUlvbWRHVlN5VyszckE2ejhBM2Z5blRrZGZtNnROWWdE?=
 =?utf-8?B?azVTSVM1eTZ3NXFYaFBWZTU4NjlVNVE2U1IrK3JzOGVUbDVKcDNFckx0SWJ6?=
 =?utf-8?B?ZDgwYVVibkxJYmlWMzZPZGkvNmpZTmFmVEhYZHRBVURBaGVlSTJteCtZZysx?=
 =?utf-8?B?bXVobFdoSFBxaE93Wjg1MTRzbGNLSFlpYklwWGp5NU52SW01cU91aHVuL3p1?=
 =?utf-8?Q?iLW14x/NlvXH0FAMEvUWOSdTc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7b8e88-1850-4096-458a-08db1b2b2374
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 14:33:49.9030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nocqHLz3Y1ivMdgnqmFuJqOpbbpAd+ERVINXx0n5mY/qzK7VhpIwqlP2knap6OjIPlJITq8UQuaHfdSakmOSuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/23 23:59, Dov Murik wrote:
> Hi Mike, Zhi,
> 
> On 01/03/2023 23:20, Zhi Wang wrote:
>> On Mon, 20 Feb 2023 12:38:43 -0600
>> Michael Roth <michael.roth@amd.com> wrote:
>>
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> Add support to decrypt guest encrypted memory. These API interfaces can
>>> be used for example to dump VMCBs on SNP guest exit.
>>>
>>
>> What kinds of check will be applied from firmware when VMM decrypts this
>> page? I suppose there has to be kinda mechanism to prevent VMM to decrypt
>> any page in the guest. It would be nice to have some introduction about
>> it in the comments.
>>
> 
> The SNP ABI spec says (section 8.27.2 SNP_DBG_DECRYPT):
> 
>    The firmware checks that the guest's policy allows debugging. If not,
>    the firmware returns POLICY_FAILURE.
> 
> and in the Guest Policy (section 4.3):
> 
>    Bit 19 - DEBUG
>    0: Debugging is disallowed.
>    1: Debugging is allowed.
> 
> In the kernel, that firmware error code is defined as
> SEV_RET_POLICY_FAILURE.
> 
> 
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> [mdr: minor commit fixups]
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>>   drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
>>>   include/linux/psp-sev.h      | 22 ++++++++++++++++++++--
>>>   2 files changed, 52 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index e65563bc8298..bf5167b2acfc 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -2017,6 +2017,38 @@ int sev_guest_df_flush(int *error)
>>>   }
>>>   EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>>>   
>>> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
>>> +{
>>> +	struct sev_data_snp_dbg data = {0};
>>> +	struct sev_device *sev;
>>> +	int ret;
>>> +
>>> +	if (!psp_master || !psp_master->sev_data)
>>> +		return -ENODEV;
>>> +
>>> +	sev = psp_master->sev_data;
>>> +
>>> +	if (!sev->snp_initialized)
>>> +		return -EINVAL;
>>> +
>>> +	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
>>> +	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
>>> +	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);
> 
> I guess this works, but I wonder why we need to turn on sme_me_mask on
> teh dst_addr.  I thought that the firmware decrypts the guest page
> (src_addr) to a plaintext page.  Couldn't find this requirement in the
> SNP spec.

This sme_me_mask tells the firmware how to access the host memory (similar 
to how DMA uses sme_me_mask when supplying addresses to devices under 
SME). This needs to match the pagetable mapping being used by the host, 
otherwise the contents will appears as ciphertext to the host if they are 
not in sync. Since the default pagetable mapping is encrypted, the 
sme_me_mask bit must be provided on the destination address. So it is not 
a spec requirement, but an SME implementation requirement.

Thanks,
Tom

> 
> 
>>> +
>>> +	/* The destination page must be in the firmware state. */
>>> +	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
>>> +		return -EIO;
>>> +
>>> +	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
>>> +
>>> +	/* Restore the page state */
>>> +	if (snp_reclaim_pages(data.dst_addr, 1, false))
>>> +		ret = -EIO;
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
>>> +
>>>   int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>>>   				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
>>>   {
>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>> index 81bafc049eca..92116e2b74fd 100644
>>> --- a/include/linux/psp-sev.h
>>> +++ b/include/linux/psp-sev.h
>>> @@ -710,7 +710,6 @@ struct sev_data_snp_dbg {
>>>   	u64 gctx_paddr;				/* In */
>>>   	u64 src_addr;				/* In */
>>>   	u64 dst_addr;				/* In */
>>> -	u32 len;				/* In */
>>>   } __packed;
> 
> The comment above this ^^^ struct still lists the 'len' field, and also
> calls the first field 'handle' instead of 'gctx_paddr'.
> 
> Also - why is this change happening in this patch? Why was the incorrect
> 'len' field added in the first place in "[PATCH RFC v8 20/56]
> crypto:ccp: Define the SEV-SNP commands" ? (the comment fixes should
> probably go there too).
> 
> 
> 
>>>   
>>>   /**
>>> @@ -913,13 +912,27 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>>>    * @error: SEV command return code
>>>    *
>>>    * Returns:
>>> + * 0 if the sev successfully processed the command
>>> + * -%ENODEV    if the sev device is not available
>>> + * -%ENOTSUPP  if the sev does not support SEV
>>> + * -%ETIMEDOUT if the sev command timed out
>>> + * -%EIO       if the sev returned a non-zero return code
>>> + */
> 
> I think that if the word 'sev' would be 'SEV' in this comment, the diff
> will be a bit less misleading (basically this patch should not introduce
> changes to sev_do_cmd).
> 
> -Dov
> 
>>> +int sev_do_cmd(int cmd, void *data, int *psp_ret);
>>> +
>>> +/**
>>> + * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
>>> + *
>>> + * @sev_ret: sev command return code
>>> + *
>>> + * Returns:
>>>    * 0 if the SEV successfully processed the command
>>>    * -%ENODEV    if the SEV device is not available
>>>    * -%ENOTSUPP  if the SEV does not support SEV
>>>    * -%ETIMEDOUT if the SEV command timed out
>>>    * -%EIO       if the SEV returned a non-zero return code
>>>    */
>>> -int sev_do_cmd(int cmd, void *data, int *psp_ret);
>>> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
>>>   
>>>   void *psp_copy_user_blob(u64 uaddr, u32 len);
>>>   void *snp_alloc_firmware_page(gfp_t mask);
>>> @@ -987,6 +1000,11 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
>>>   
>>>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
>>>   
>>> +static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
>>> +{
>>> +	return -ENODEV;
>>> +}
>>> +
>>>   static inline void *snp_alloc_firmware_page(gfp_t mask)
>>>   {
>>>   	return NULL;
>>
