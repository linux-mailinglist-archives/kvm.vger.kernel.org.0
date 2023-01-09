Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9343A66289F
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjAIOdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbjAIOdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:33:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DB01E3D7;
        Mon,  9 Jan 2023 06:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FipkSkUVHoFzqgrKO4U+mc+Q3pRFSKJifzMqUshmz2kKs088XaQWau50MTExTTCsHJqQY2VLCnz1o4/irgpAe9/Y7wWdjB4u8gWD8ujCTWoys+KIlg2eE+cjvRr693Uvp3q40TWM2GknXz4imYp/1PUZ4SfjCDq6gqdUp+8oVdsnC1DGACwqpqFhXp59ZtVti/EzzQE/V5FUHiUpO4tJo4L+9QZuLohYup4D8HaFVa0wThFRWXUzAl8XP66ZVldPQp/7St0OIDs4E5/4FYw53EwmF13KNDAeGDC7exaBt4MJJt46Ghk2nW+eGRr9btSYWBYa5YhkKWK0erATJDassA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh8lQCyfqvWjn2B44QX5mKa1OH1r/phK4BUiRlEEn0A=;
 b=BRWC3RDbCKfSNzmzOCEGaOlqMvCp4uHvkwx/HUe9cBmK0022gWHlQq3K+O4b6QGSEoMMSeWeUsAggQZ48pkcYrdT4J5ySel47dQHimHJNkzyb6ScMV3FM+hq4ihQJ5yI0N/t86gDikCngPj1ItriTOfY+SsfX4VnZNVGwTP0ThenA/LskpxRv9Ol8QphoB2E7sFeRbL1JVoJQ/fiNL4x7dWxIcVHT6e5cCj4mlrqYKwkD4NQxiSINNFtN6nxF2V5TgUsBrEx2ij7895bTtXUVe14C71w3BeUHX0oixCwCH85aWnfnSHRKNQKXGhWqpIKmsIC4DP4Se2WMLKaO1z6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh8lQCyfqvWjn2B44QX5mKa1OH1r/phK4BUiRlEEn0A=;
 b=Zfui+USk5LgWeH7yaXFY7rJ852eDAAOn79ylzrhlhAUhQ+WHmSBqiSxD3O+eFSTo2ijh2pS9lAWK9l1KQ8lDArq/mVLFxPVjwu9w6j8o9oxM+vHECz5L8WjAKuX5YuR4cWWG1kZecvHrI3RFzPtDsFuDmWRggaSNhW7K7yUbBfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by IA1PR12MB7544.namprd12.prod.outlook.com (2603:10b6:208:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 14:33:13 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 14:33:13 +0000
Message-ID: <8bf6f179-eee7-fd86-7892-cdcd76e0762a@amd.com>
Date:   Mon, 9 Jan 2023 08:33:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] crypto: ccp: Sanitize sev_platform_init() error
 messages
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>
References: <20230108202407.104963-1-jarkko@profian.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230108202407.104963-1-jarkko@profian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0060.prod.exchangelabs.com
 (2603:10b6:208:25::37) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|IA1PR12MB7544:EE_
X-MS-Office365-Filtering-Correlation-Id: 79fcb4c7-e61a-433e-d535-08daf24e7064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dnFJsA0D9/MFbKRazQSZ6/QOwpyb4K0t9mdhtGUVVP+fkYGiYMpKLryfJY7JqXXx3jCdlUjFL+h+FtJoxMx1EJIRxr5UOw5/Pll0i4+Ue5jXZV4GNsvnUcw+uufOdW7JTTJCAzC8qMYDROS+yr0iA4F2X60lAObu3AGhMIg+iqf9oHm9KgOSnHJzxBSpEYJ1sT5wYezcu/sOb65pn6iwHNHO5X1iwAS/eBEE0QAj0Ro0BlHuWRyxwFG3hydUpR8tWmCPcmgSPryQPgfn2mqxJTs3zo8yUPf8OCW/e/j/Mp5PrmFxP1yAphknBBmePt9Q117RJjDlq2tgQpKgZ73++r9n9DeE1XK03DSYJn0q3MwM7hFSG+oThdKlbiFtXDqexSOuVCadRFKioVdDc0hLy+xg2m/zbnERWmHIJ0XWUE0H0pFKqFtN3zej4YFFk79IvHPluyS9Cg6SVf7PxPueQ/61+pCUhK3waEXg4yMgIawuQERLTCDrMuWyRIZtKi3CTXdPYDsn3+iSAjkOuP5u+1yo6Z+DZLMU5omDvSAqC67pALGow3xt51y8dCMwLJArUI8kU4hsusy7CQZT24Sc03LvVJbN5ZUCbGGhvvrRXR23fUfWXmAJ1fuwbV+XDiru8XGEKw/AcbvLQq2oWaqVvvJDJU4LfrUzj7lfNwTmjUHHm4W+peMLBABWTiP4xCJ2nVZIP/SDM52j5qhcyO/WKmOR65XI2S0IQHcvdBCbNmi92q6ODxtf/PqhIc+gHzDdkamKmpEEybwwsCL+1Y9Yz5Kwn+NC2mL+XgKEcjFJ7gBxRJ/LfU2DEZwc4gw4JxBF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(6486002)(53546011)(6506007)(966005)(186003)(478600001)(36756003)(6666004)(31696002)(38100700002)(921005)(6512007)(83380400001)(2616005)(110136005)(26005)(86362001)(8676002)(8936002)(5660300002)(7416002)(31686004)(66946007)(4326008)(66476007)(66556008)(2906002)(41300700001)(54906003)(316002)(15650500001)(45980500001)(43740500002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVVWaDhURjFWOE9PN1hjYjVBL0RvUUFhbHN6TmtXQUlaUGxFRnhDOU03dkor?=
 =?utf-8?B?alYyeWxSS3paL1RVak5DemFYeGdITzFWUlQ1bFJNelRvUEIzNFFsRnUyTnh1?=
 =?utf-8?B?ZithVTJWbnBPRWVEcmtoY1dYbFBZK1J2OUJ4Q3JveCs2UWZsb0N0WjNBWWdn?=
 =?utf-8?B?bzRPdVE0Rno0aGNDN3dFcHpjc0lJMUhLaVlQUnROemJrTGliMVpFWW5ScWdW?=
 =?utf-8?B?N2pEVEVxWnJjYTd5b3o0Q3ZaWFY4b3o0M01KVGxkZHVQWEExMjJ1R0JSSXJ6?=
 =?utf-8?B?NTBXNEYwaTFwM1ZMckI2YVlBL3dZT3lVb3RRUllGVFp5TmxYRmJlV2Frb1RV?=
 =?utf-8?B?T2VTWXlZYmF0a1JINk1xK2VONCtLZG1KTVN3QlNMY3NLODVBRUZjRmFaUnVT?=
 =?utf-8?B?dlRjMld3c2JScnhuSE83cGhySWJIRjIycllIT2NPaXcvTEphem5hT0dWN2Jy?=
 =?utf-8?B?TEZFM2RsQ2ZCOWFiM1ZZUHdqUXE3dlFPUUxPZ2RNOFFIN3AyVXJxM3hDZUxH?=
 =?utf-8?B?djBEQWZFZ3lpcG54TEsyUVFsZ1Q2cDNnVFVOOEVlczQwcUxkQTlNcUV5QTIr?=
 =?utf-8?B?WWxxbkgvWHhIVTgrYUtEcDFFcEYzVmlwR0g1VFpQZlFHVkdyaXNkY1AvYU5t?=
 =?utf-8?B?aEVkdEYxMGFQeENRSWV1RExlc1dUamp3TkpJMXhuQ3ZhU2lIUU9KcXk1dTlr?=
 =?utf-8?B?cWtuNGRkQ3hmTWw1d2JrR2lJN3hpWGZLOVlxb3IzOENCTlUxQ3Z3WHZJb3dD?=
 =?utf-8?B?clFmQ0Vha1htR0IwcENlRDdaMndHMm0zT3JPbmVMUUZjc0xBcTdCNWRtYWFW?=
 =?utf-8?B?WHBUdE8zbml6cHJlb0R4Sk80K3JYTDF1bjhQSGkxN0hQVnJxVnJCSGtvdDE4?=
 =?utf-8?B?dzNFck9aay9NL0o3cG5iVHJTTEVVeXZ1OFJ4a2VrT1JiR0ZvbXNlWm1xbW9t?=
 =?utf-8?B?cExQZDYrakZWS2VYTG1PdVpEVnh5S1NWMGYvWFZuYjl2T3ZadmFxbUpFTGtC?=
 =?utf-8?B?dWRsT0xDbkd0bTBDSkZ4cDVBU3hRZ1dDbjhjdTBOOXV5RDZxN2lEc2ZTeDNR?=
 =?utf-8?B?bGNGcTM2TldDQmY2RzlXV2p2SzdFR3dQZ0dDSm5wWWRkUUN3MGthTUJUcXpT?=
 =?utf-8?B?SEpPenBBY0VMbklrYm5IOEJDUm9paGFvN1RpUFhOUE1XdWFrelEyK1U5TzZT?=
 =?utf-8?B?OGFUVzhyT0NBYUluQzBVQUF5bFUwZW41L3VNb0tkNnozV2hKRitwckFyS3pL?=
 =?utf-8?B?S3pnT2FnUFRJS2w2QVU4dzgzOUFwb1d1ZWFGS2NUZllMeFpBK1JmUjFEQlVh?=
 =?utf-8?B?THl3dzhzaWtTUDhHVVk1Zm9ScXpXY2R4S1BycDJRcGVmTVlXNUVOUXJpY1Ev?=
 =?utf-8?B?MWRWcDF0NlNBVmVNYm5iK2RaV2FKbkg4MTY1emlUOWdleitPVk10eVRGclFZ?=
 =?utf-8?B?d0JVTDM2NWhUTks0cVgyR3BpRk54YXdIU0VQMUNzTjlBSG9ONmdZQ1NPYzJn?=
 =?utf-8?B?a05lRUljUTVhKzFKeWdWZTNybHFSK1AxRVZoQ25ROVV5czM0bUFkSVlHZXdN?=
 =?utf-8?B?UHhlVlQ3ZUpBK2tRcE5nNEpXaHNtNDdLTzg4NDdPWmhlTUVDZEdUb2JtSE0x?=
 =?utf-8?B?dkk2eVQ4aVhXZmF2SXliV0s3Q002bU9TN01Eb0ZaS0hjalc2bzZzMElsSVgx?=
 =?utf-8?B?Skp5ajhPU08rT2ppdFdRdU4vK3k3WldjSFZxS2FlRG1xanVEUHNQYTJjcmsx?=
 =?utf-8?B?TnUrdWp1aXhKSmw1V0g4TThnUkh2Z1g0NkFmY0ZCd0huVGRFOE5zMDhkVEZx?=
 =?utf-8?B?a0F6UHBGeFI2a2lUK04ydXlUd2dsRnBxWEl3UkhsQ0hlKzV3T1NnTEJKd0lD?=
 =?utf-8?B?bVdtS2JoNDVLcThBUW1UR2VsOTA0a0JXWTc2ODF5eU5Fb1ovVXE4ZVFLdDl2?=
 =?utf-8?B?cm16dXdtMGMxT0tHL1BIWHorNlZ3REErOHJwbld1eUdGOFFVQldaZDNxbnZS?=
 =?utf-8?B?cVM2QmIrU1hqQXpVRlBEYS9ESnFuRm9UQk12N3ZUNklGOTV6RTY5ZEltUDk0?=
 =?utf-8?B?ZjVpRCtPeER0M2NKb2ZPdElmTzMxM3I5R1NVMk9hOVg3R1duL0FMbU53WTVm?=
 =?utf-8?Q?uw1IsaHOKdo6cT9etDK/RjZ4+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fcb4c7-e61a-433e-d535-08daf24e7064
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 14:33:13.4949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHaEQmEn+HgxwAUfpYHTZUxyMZNeL1xmzFKxIu7KpOkiw9fxkchOBBKL+PKDSshD78wU26uNfUgBMQ18ZH004g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7544
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/23 14:24, Jarkko Sakkinen wrote:
> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> However, only sev_pci_init() prints out the failed command error code, and
> even there the error message does not specify, SEV which command failed.

event there, the error message does not specify which SEV command failed.

> 
> Address this by printing out the SEV command errors inside
> __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> INIT_EX commands.  As a side-effect, @error can be removed from the
> parameter list.
> 
> This extra information is particularly useful if firmware loading and/or
> initialization is going to be made more robust, e.g. by allowing firmware
> loading to be postponed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> ---
> v2:
> * Address David Rientjes's feedback:
>    https://lore.kernel.org/all/6a16bbe4-4281-fb28-78c4-4ec44c8aa679@google.com/
> * Remove @error.
> * Remove "SEV_" prefix: it is obvious from context so no need to make klog
>    line longer.
> ---
>   arch/x86/kvm/svm/sev.c       |  2 +-
>   drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>   include/linux/psp-sev.h      |  4 +---
>   3 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index efaaef2b7ae1..42e6bd637896 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -254,7 +254,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		goto e_no_asid;
>   	sev->asid = asid;
>   
> -	ret = sev_platform_init(&argp->error);
> +	ret = sev_platform_init();
>   	if (ret)
>   		goto e_free;
>   
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 06fc7156c04f..3b66cb1495d4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -440,7 +440,7 @@ static int __sev_init_ex_locked(int *error)
>   	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
>   }
>   
> -static int __sev_platform_init_locked(int *error)
> +static int __sev_platform_init_locked(void)

Why is this being removed. Userspace may still want to see this. Some of 
the error pointers are from the ioctl() arguments...

>   {
>   	struct psp_device *psp = psp_master;
>   	struct sev_device *sev;
> @@ -476,19 +476,21 @@ static int __sev_platform_init_locked(int *error)
>   		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
>   		rc = init_function(&psp_ret);
>   	}
> -	if (error)
> -		*error = psp_ret;
> -
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: %s failed error %#x",
> +			sev_init_ex_buffer ? "CMD_INIT_EX" : "CMD_INIT", psp_ret);
>   		return rc;
> +	}
>   
>   	sev->state = SEV_STATE_INIT;
>   
>   	/* Prepare for first SEV guest launch after INIT */
>   	wbinvd_on_all_cpus();
> -	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> -	if (rc)
> +	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: CMD_DF_FLUSH failed error %#x", psp_ret);
>   		return rc;
> +	}
>   
>   	dev_dbg(sev->dev, "SEV firmware initialized\n");
>   
> @@ -498,12 +500,12 @@ static int __sev_platform_init_locked(int *error)
>   	return 0;
>   }
>   
> -int sev_platform_init(int *error)
> +int sev_platform_init(void)
>   {
>   	int rc;
>   
>   	mutex_lock(&sev_cmd_mutex);
> -	rc = __sev_platform_init_locked(error);
> +	rc = __sev_platform_init_locked();
>   	mutex_unlock(&sev_cmd_mutex);
>   
>   	return rc;
> @@ -610,7 +612,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>   		return -EPERM;
>   
>   	if (sev->state == SEV_STATE_UNINIT) {
> -		rc = __sev_platform_init_locked(&argp->error);
> +		rc = __sev_platform_init_locked();

... like here. So I don't think that should be removed.

Thanks,
Tom

>   		if (rc)
>   			return rc;
>   	}
> @@ -653,7 +655,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   
>   cmd:
>   	if (sev->state == SEV_STATE_UNINIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> +		ret = __sev_platform_init_locked();
>   		if (ret)
>   			goto e_free_blob;
>   	}
> @@ -849,7 +851,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   
>   	/* If platform is not in INIT state then transition it to INIT */
>   	if (sev->state != SEV_STATE_INIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> +		ret = __sev_platform_init_locked();
>   		if (ret)
>   			goto e_free_oca;
>   	}
> @@ -973,7 +975,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   		if (!writable)
>   			return -EPERM;
>   
> -		ret = __sev_platform_init_locked(&argp->error);
> +		ret = __sev_platform_init_locked();
>   		if (ret)
>   			return ret;
>   	}
> @@ -1335,10 +1337,9 @@ void sev_pci_init(void)
>   		return;
>   
>   	/* Initialize the platform */
> -	rc = sev_platform_init(&error);
> +	rc = sev_platform_init();
>   	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			error, rc);
> +		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
>   
>   	return;
>   
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 1595088c428b..2f8681b753d0 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -536,8 +536,6 @@ struct sev_data_attestation_report {
>   /**
>    * sev_platform_init - perform SEV INIT command
>    *
> - * @error: SEV command return code
> - *
>    * Returns:
>    * 0 if the SEV successfully processed the command
>    * -%ENODEV    if the SEV device is not available
> @@ -545,7 +543,7 @@ struct sev_data_attestation_report {
>    * -%ETIMEDOUT if the SEV command timed out
>    * -%EIO       if the SEV returned a non-zero return code
>    */
> -int sev_platform_init(int *error);
> +int sev_platform_init(void);
>   
>   /**
>    * sev_platform_status - perform SEV PLATFORM_STATUS command
