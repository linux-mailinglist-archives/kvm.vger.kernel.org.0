Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3657CD58F
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjJRHk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbjJRHkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:40:25 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2067.outbound.protection.outlook.com [40.107.249.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A98118;
        Wed, 18 Oct 2023 00:40:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT3DsigtCQXwT3iNF+WJ4d+o3WQ2o7zIGrKyN45gCnvUM4AwhjLYdOHepI/azTuQHMxBBjh5y/XYbv7DgYuEpT0UzSsKKYFpYeZJ8ybZhUNV9SzbYUm30lDqppwQcFOSpJY1yjYBT8QHUACBIsANFU2UgqX06R+XKc0vFGO+0P32EkkYfaIGqHs0o7Cl/xmXF6dwCY+uiNa8bbH0b8VUWsLgKM97EROcFIRkuQateoWYEEYyNaXgfDM/ivbgRxZ9xAFUfWU+4Lg0oGYfg8YnUEqCgXjGpiiM9MnzkobENU5sgHctdr/POY8lNugidN7Dc4otCLRAtKpXoH2JsgGPbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDRnncul1oMKFpL3ZCNS1VcMBdf42KI80vDLKNw4EZk=;
 b=kR2RjMvUWe5EYfWOmmRa0cnPttPgdJv+yA2vobTSl6YgPBgH0KN9Lh0ughtw5radyceV2XxuaMAjraGPFtOk+uV5x+zDEZUpMflH2jy+JwtizUxy8d8nS62QQVCAed5LjbT4ViUCu7G3NC7xI9NrWGAruwOcMoWLNCnO69YLQTV7cWs7FaeVJowE1knGh6TUl4ftX/JFRpR9sg1NuGZZChtQcKmDqmS5gpT3HW00srkhkVmFsySaBb0E+AvQNdCjrl++BGPlCdmGbH3d2ya8Ud470mkLEk4PK0OLbTzbjERK8X4BBT+C1P1ROlvU+0tbxRztRfTjleVSdQ5+q8uE4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDRnncul1oMKFpL3ZCNS1VcMBdf42KI80vDLKNw4EZk=;
 b=uECFKdEIsLn3YO7SSYJiriKfrg0JLJfDlbe4PfXFJBBGTgY/zs7PL+VyWlaEs8QeSndpORCk+hd8r07T3K8qTBB4jdxIVCvInwdkv0Itxvh31KziY+g2AQEpg2eFoH9JZfB4OaMUuyqI3VOUr5FLTy4hO55kZ/M8D9RdVHEmiC7SxWTnCUxuJzcixIasRlpWfLJDDutwg2qkuTMPiokzXGpwYqGdxdULNvCt7p+AwS1OxeYaBqWeIlCXlfoFSLHk5PYtgOEotpi9pATp80B/P5wx2SXgzCVKEIvM/zqAu36je30C4oAarHLgt8NwV+PYCiFSom0Sdl/xdgVVcPLdng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB8573.eurprd04.prod.outlook.com (2603:10a6:102:214::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 07:40:16 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 07:40:16 +0000
Message-ID: <7ed3e212-caf0-4148-9d5e-27c14facaa05@suse.com>
Date:   Wed, 18 Oct 2023 10:40:10 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0095.eurprd04.prod.outlook.com
 (2603:10a6:803:64::30) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c314209-4fee-4ec4-723c-08dbcfad7836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Du3PaVvbTTC9oocnEKc2Mgcu8ChcqIXgy3gygDpvyMgPi/hRRseDwJhhTtzhlxdmbM2sNMw+pWII90WVf3PlOlu20QYiW+pySjVZ4HhAPQeSS4Ydc/or3BTOM7Ecu7QFRy99y+c8PT9V8muZ9hQwrztGWwI4HXoAy/UUrmv8F7XEDnJn8zKfKZg+FfIvBY4v8VMn4A5sUGi19niM0H1YeMm/EV62ff/9hRPVk3j+ayu1TJyxDVCyM8rzsPZszW5KwLc5gcurhYN17R+1Yba3mu3yrUMqhBa/F01slhmOddn/rkkz2V4pj6XqTKv7armXTzPqbebJoWjfSpFqtgN3UlDN2ik9/bkqia5cbiEZiK+W+6X5Zmf1+57/Qf8/ejulT5bNsSN7yekG1g+GA5CD/wtYNX0Ewq1ElVTf5UcALnwAwHlGOcq4s1CWaQ0jWKq4KHmfER+4YH0OzUvK6klquhsyuuCIaB2laPqzfVNUQLxG6TbvVk/fOC3pP5yvYrOUK6UKkOhfJ3wW0l35ZHHxhtNqm9WGtpbMvUfcN5VMDgt00P4mfaE51nDIw8itIc5T37XXmjMPBpPfQArMmqHndk0Uyza+dQkL/Ix8X1t9GlOgSqM63sKXwr8LBT6HqyuMdybFQNxzKtJPUJnTjTGiNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(366004)(136003)(396003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(7416002)(4326008)(8936002)(8676002)(5660300002)(2906002)(31696002)(86362001)(36756003)(38100700002)(31686004)(6666004)(83380400001)(6506007)(6512007)(6486002)(478600001)(316002)(41300700001)(2616005)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJmNk10M204S3U5R2oxNXBDeWdwSjdjcjUwcXAvUGZpaDBjanBBU1loa01N?=
 =?utf-8?B?QWNtNWVDcEVybEdXekFnT01yc1RQL1FadThLTEFLcllLSWlJeG5IcEpkM0g4?=
 =?utf-8?B?Z1R5VnkrSysyVjBaUEdUQU8yZzZUYi9kMWl4d0N0amNxcG1WSlhBblVCTGow?=
 =?utf-8?B?U2VEdXJVeFFnOUFVVTUrMUN5WWZmZS8zSzRhUTFBRlNOUEs2RDVWRVZ0aVFO?=
 =?utf-8?B?cUhNblkwUEoxNmg4cXBweWlvcFhXaUJZRWFLclhhclYzenQ5Q2N5TG1oSmRH?=
 =?utf-8?B?ZTQzakt4NnE2Qkd0M1lDejdsVVY5K2UxbmxRQ1lsYkhudlJDY04vcWV0aWg4?=
 =?utf-8?B?K09OdFdMU01VdVZkQmR6dklCTWhSSDJYbis4bVFnYXhWL0FUWkVkR2NKNk9k?=
 =?utf-8?B?cXpiUEpiNVpxR3haTDFiVUdlaHIyUG1WaXFCUGhNQkRkbkVubG5TRGVOYXN6?=
 =?utf-8?B?U2ZpWklyakdmZFN6WXR6VjhXelQwUEx6TWRkd3NEK2VaazQ2bnR1dE1sa3Vz?=
 =?utf-8?B?ZEIxZ281OGN6R3IyUWw3MHkxdXZSSU5Fc2ZPZldMaUhpZGxOYmJTTGYrRmVZ?=
 =?utf-8?B?Ukl6cWtMc2p2amQ3QjdZOUZUUWt1Z2FMN0dtTHNDQkVNVXpUcDRZdFcxQ2Fi?=
 =?utf-8?B?L09Ud3lReGxOUjlZLyswNTE2WFlmY2hOT3pDdDAydWNZamovbnNlL3BLUE5Q?=
 =?utf-8?B?YVNoajlqVFhzM1VLZEIxb0tPcTZuWWJwL0Z6bGJ4TGFSWWdtQmc3dyt1YlFo?=
 =?utf-8?B?VkNvMjRWN1VCdm4xck90L3UwQk1SRzlYNm5VcjZ6MFdmYW5xcWhHcStwSGdN?=
 =?utf-8?B?RGxFU2ZWTDhJMzQrOFFpb1U2MXlicEdqUWFDV3BmU3ZURS9IQUc5Y2hBTldz?=
 =?utf-8?B?bFlNL1EyblFDNm1objBHRFJLUHJUMVF1Q09aa2J0MkJVWElEU0RESitibkFi?=
 =?utf-8?B?eWljZkxBODBJMzZQZHA0eFVHR3ZZOWhDa0tEbTkwck8za2hzb0pKYWRVWWU5?=
 =?utf-8?B?SmpIc2JoUGJsN0h0aHc5ak50dDdldDl6eFI0Wi9KNFhNY2k4dU44NUQydm1h?=
 =?utf-8?B?L3EvNzZjUWtVbytJeXdnaEEyR2U3S2Z4U0Fjd1hXOFMvay9Sc2lETDZuSDJa?=
 =?utf-8?B?S2ZpYXZZT1phYVBGY1luMmhja2FTdUd6STA1Z0ZSMWlZN3pjaEtLanpnVmxy?=
 =?utf-8?B?bmtyeFZHaW5JUWFvc2FWNnZuZVloQTNIODFheWR6V21EWk9TQkh2ZEgvalJi?=
 =?utf-8?B?U2JHNk9Denl2N3VIMmptalJ4QWRqUDBIeE85NUR3czdHMFozd1UzTGo4bXJx?=
 =?utf-8?B?WUh5ZVdiSWg1NmU3WG1wcWtUUjBhSmg3dHh2aDJVa2FYQy8wby83OXJ2d1Jr?=
 =?utf-8?B?cFp3QURFTFFHUkc4YThwMWdaZ3R5RDhMSFUxNnBWakUwd0NPcVRva1lWaWRi?=
 =?utf-8?B?ZnpkVEZXVUk0bVpVVEoyRTBiUUNJdEl3RFNVYVVDYzhNVmNxUWNMd2J0bUdO?=
 =?utf-8?B?eHJheG1qUENESEY0VitBN3lEdUtCOGt1VCtnNzlCVWQ5U2xCQlV3Y1VkSk1w?=
 =?utf-8?B?a0pjSjk0Tm10K1dxZGYwbnk0UDA5UWQzQkRmMFlFU2ZZOW94a1grY01kaXc4?=
 =?utf-8?B?ZzRMR2ZONDE4cG95b2w0RGw5M0JQck02SnhHWGxHTjBnYnJVbDNUcHFKUnpl?=
 =?utf-8?B?RnVKOStVUjViei9OVytjREtvRWR2RVFEc2tVOS9kMUVnWlVoMUZ3bmpab2Fy?=
 =?utf-8?B?S1lIa1RFSkoxQTkxL1BDdzkrOFp4bnZrMFEvaFk1YUFRQ1FRcGhFamhIYUVv?=
 =?utf-8?B?SWd1blhtb2FXbnhrUGl2U1NMMFUxblc3eHB1OEpmOHNWSEtEOVlaL3A4YTdK?=
 =?utf-8?B?S0Rpa0xqL1k2TlFxY0lzVkJhcjhwSTc0MzhZcnM5Z1l5bzlvRjNRbEVqblp1?=
 =?utf-8?B?bE9UVkc1QWIyV2R4S3pYdkdLWk96Y285aENwMFVibzh0TXFvSzB4bS9vbk1t?=
 =?utf-8?B?ZEJsLy80L2FhZkMycWVFVGxkSFhiZUs5K2w4dUtEVEs5YmZQbWV1VHZ6UFBJ?=
 =?utf-8?B?UnRWNGFwQ0dKOEZod05IRCtzRmFteFNncHZwaERWQUxYVmdaNmM4UXp5dEVL?=
 =?utf-8?B?ZzJSN2JvZWVPVy9CYWpNVi9XK0pNY0Q1UDJhbkYrWTczTVdaUzdrb3lHbW93?=
 =?utf-8?Q?H5J5hUcXvgu1+E8vzB7B3sXHv9LCmkuruZHWECCYv1vt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c314209-4fee-4ec4-723c-08dbcfad7836
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 07:40:16.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7z3kB0GKkN7NSw+ZiGWWjRGsjV25SrMqLYDnkpsEKDhjirGR38yZ3n24S60cq8Bey8bXa/KkBJGwPm81MNQA4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8573
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.10.23 г. 13:14 ч., Kai Huang wrote:
> The SEAMCALLs involved during the TDX module initialization are not
> expected to fail.  In fact, they are not expected to return any non-zero
> code (except the "running out of entropy error", which can be handled
> internally already).
> 
> Add yet another set of SEAMCALL wrappers, which treats all non-zero
> return code as error, to support printing SEAMCALL error upon failure
> for module initialization.  Note the TDX module initialization doesn't
> use the _saved_ret() variant thus no wrapper is added for it.
> 
> SEAMCALL assembly can also return kernel-defined error codes for three
> special cases: 1) TDX isn't enabled by the BIOS; 2) TDX module isn't
> loaded; 3) CPU isn't in VMX operation.  Whether they can legally happen
> depends on the caller, so leave to the caller to print error message
> when desired.
> 
> Also convert the SEAMCALL error codes to the kernel error codes in the
> new wrappers so that each SEAMCALL caller doesn't have to repeat the
> conversion.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
> 
> v13 -> v14:
>   - Use real functions to replace macros. (Dave)
>   - Moved printing error message for special error code to the caller
>     (internal)
>   - Added Kirill's tag
> 
> v12 -> v13:
>   - New implementation due to TDCALL assembly series.
> 
> ---
>   arch/x86/include/asm/tdx.h  |  1 +
>   arch/x86/virt/vmx/tdx/tdx.c | 52 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 53 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index d624aa25aab0..984efd3114ed 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -27,6 +27,7 @@
>   /*
>    * TDX module SEAMCALL leaf function error codes
>    */
> +#define TDX_SUCCESS		0ULL
>   #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
>   
>   #ifndef __ASSEMBLY__
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 13d22ea2e2d9..52fb14e0195f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -20,6 +20,58 @@ static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;
>   
> +typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
> +
> +static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
> +{
> +	pr_err("SEAMCALL (0x%llx) failed: 0x%llx\n", fn, err);
> +}
> +
> +static inline void seamcall_err_ret(u64 fn, u64 err,
> +				    struct tdx_module_args *args)
> +{
> +	seamcall_err(fn, err, args);
> +	pr_err("RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n",
> +			args->rcx, args->rdx, args->r8, args->r9,
> +			args->r10, args->r11);
> +}
> +
> +static inline void seamcall_err_saved_ret(u64 fn, u64 err,
> +					  struct tdx_module_args *args)

This function remains unused throughout the whole series, remove it and 
add it later when it's actually going to be useful.

<snip>
