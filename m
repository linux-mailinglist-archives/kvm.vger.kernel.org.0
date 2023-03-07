Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012C96AE73A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCGQuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjCGQuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:50:01 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5EAE3B4;
        Tue,  7 Mar 2023 08:46:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY+mDJ6LilTU+inQaG9FDVZX/oO17sSk5aKD8om1efCwG46F/ezX033llSiinIecQinqt70yoicIi+0JjNMHa2KA8E9Rk8vUIRJmaG2Ssp5JKmtJcSqdzi4eqERQ8dN51fQAIIc82p2JSHzFDkgpzgjuikIxaTVA/QZxITBQ208dUa915TMANWx9s0wXq4ef3n8fExxTwmfLZogG7H8GScSU1U0W7uRnWfKywsDDiyqOTmvt/3cohp+qkJuKIWcjjHPPEOilpht1H+p5JmeD1k/mYDhUdYiF1KJvVB4ObMmFFEK7DN/I5insf1IkCEQhI4U9qtW5QEukRJ8uBVHCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9m5qYrE2F/+rYdlQKWWPGoo4zZFhkoIUTwF7tO5hdgo=;
 b=JKIqxTomrE+pWxaTyZ7TgK7wwwnGWfT4RT67XSQydSjMk33v02070yOjbEXDK79yZw5lOvkmbdRors79yRRgWINasQlWygez/0OFf16LBkuJJbwtcENiG8YlWsn7EQgIgr3BDyiZugZsmgX5kqrLIMkmDfzAHMGDkltYwnv42trAdvfIFjgyC7wAZ6l67oYcnxIxT57gT1TuAS9p78pkTQsxc5QLq2Ry3E6q8D002iNS3UNWtqmodAasc0vr0bg3G/MWw2oe7f5glCYxhtedPy38/D+tCCfv2k5hteXaEioejQVNu+pmnyT/KzxNVOmGXnnrtzuhSID512qGAuAU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9m5qYrE2F/+rYdlQKWWPGoo4zZFhkoIUTwF7tO5hdgo=;
 b=HC7sP1CO1jeTargQtOoxAkQHTLWeRWJoE3Z28/IKdf3htttz9dC9K56PqTmKIl4gWS7dT63zHK1jjFwtz2DlzaYjEbY7dzZZmCKxa9SmtSgfXqZRYbQqaEQv1jmf5M3P5UFcGAvpENrhXds0smxD9qXhVwverPOFf0UudkiCPQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY5PR12MB6552.namprd12.prod.outlook.com (2603:10b6:930:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:46:03 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 16:46:02 +0000
Message-ID: <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
Date:   Tue, 7 Mar 2023 10:45:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        seanjc@google.com, pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:610:b1::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY5PR12MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: da57c603-8e0b-4cd9-6c02-08db1f2b6fff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baP7pUmuvXZ61Xs2UfpValzdOm5UfzgIrJLtpQTDUcYM0LB7aH8bxm/asXeY/5lpWqdsIegc3rSP4TWCAJlziOMlh9Py4HR5BuU13VH+++U1HSWyk/dPYs1sqHlOpsOOYSzXuNYdabBrKRp47RvGx3+P0wrInR1pbuMwdCUI+7v7333TcX987FTndTYkQkFM2nnIAj5UZkJ1xeUQ/y+XH+sH5d/jCyiiZQ+zWjvVUXYWZobuucU/Dm221i5PTCT5D7TEeFkIbncj6GaIxD4w2gi54ZuHGD+buTiqjsMFdkUOmJA6ut8DEoBnVzQX8UJuW0+b8rkNQLP6ToCzm3rGfVERp4P6GNFO/n6W5vbp4k9B5+3qg0Svqk2Y4Z6/kuuVt8Rja0CKLzzfTSAViTJLrTW1S8cg3gH9XVcv4clvf1Okjv0CkeueYVneTTGZbygF34WijP3SuX73LtRBvAA5ZUGmhzuCgk63c6ZuWdpbKqgWKxp8eQ8rNVNXf7s+8exBe7alHYgb8/BR3Kh3TSBrezHC8rORxKqPtxTKUX3t1iGsLyvo2hBAvcstk8/qxPEUGm5kobSXdTe3C8yK6IZQCXniGJlw5rOnQUxlJL3rjee0evcmAEqG5VzCQWFT5U6vL2VIP8aovtP+TvQoNyFjZcXkPUOSKGXZUL16x/UOMqqzv9lP777qpeR6iN6dkQ4vizoAGozdj9/6M0cLPs8LviD4/86wx5dYxB8BnAw2olk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199018)(6666004)(5660300002)(478600001)(86362001)(7416002)(31696002)(26005)(6512007)(36756003)(6486002)(2906002)(6506007)(2616005)(53546011)(186003)(83380400001)(31686004)(66476007)(66946007)(66556008)(4326008)(38100700002)(8676002)(8936002)(316002)(110136005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RndnWEk0R2lScWpkS2NFWk1IdS94aUdjU0oyRHdVL3V5SG8zcG9NUU5nNUFC?=
 =?utf-8?B?Rk5YMDNmN0M5NURaSVFmZzUyMFMzaW5FNnM5b3dBNjlDYTFkekRPWDRHQTJs?=
 =?utf-8?B?dGJobTZNV01sMk43ODhYRUZmYUZ5NTRuaHRnQ3grOThqd2g2dXRwMWtNcG84?=
 =?utf-8?B?b0JMRVRRR1pCb0svang2N2hoTVVReXhCYnc5ZG5IZmxqUTAxRXRTajd2aGN0?=
 =?utf-8?B?QzhnVnl6Tnd5STI5aUVlaGNqL1kvSXFRVHZKNS9sQy9BakxFSFdLZFl5Tmg3?=
 =?utf-8?B?aXJjWW1yMnJEMzFmVUNsU01BU3BJSDIvdUx6UGpkRGd3cnIvUjdHZ3N2dXYx?=
 =?utf-8?B?T0RmeGtqQlkzdVYzNXd1aktGQnBmUnRJUFhWelE5Tk43SG1tR0RMc2RCTDV4?=
 =?utf-8?B?ZXJhSmZXWGJsamZCRDgwTEtoSm5DUkRxZklTR240ajZ2L1BSdzBia0s5TWpi?=
 =?utf-8?B?RDd2a29melZHYmY0c3BkK3Y0WjYxQ3VabWFSaTBudEd5enpBWGFuWTNwejAw?=
 =?utf-8?B?WlZtanNic2hPN1BGSGw1VUJYREtSb25rMmFmZ1BwR1BodmNRVlRCMkRkV2VY?=
 =?utf-8?B?U2NXaFI1eVBZM2UyVnJBc3Q5Lzd6b0lZRDlwQ01uZldwZXJWM2xIWUtWcnNF?=
 =?utf-8?B?RjBPbDcwMTVrMFBmdHpIdXZiMFFEeEZqejlneWwwYlhPSC9XRDhqYTJQcUdS?=
 =?utf-8?B?YWtPY1hHK3RXU0JBZ1NsQlpJeS9zNWpaTk11VDI5NzFyVnBZR3dQWXpmMHU4?=
 =?utf-8?B?VWZ2S2YxMUlLZXVaaVNlMDN6bUw4WWpSVDlGaldJNHVON2hST21xTFdHZmdv?=
 =?utf-8?B?VlRvcUtvUmdxZEdneWVjMERCUEt1VjBacmY5WSttV0luL3FWdGFWUkhNS200?=
 =?utf-8?B?ZHBFT1VjY3QzaWFxaW1jWmxTL3lGeHFhTzU3VkxGKzVWYVJaUzIzQVF3KzJo?=
 =?utf-8?B?bzFtelVlZENKc0wzWEhQNGRRT2REMmZsUktUMHVqcFU5TnpPa0F4cE1wMk94?=
 =?utf-8?B?UkZGYjBuaEtSWDExR0FHQ2FuY2V0UFVLa0Y5SFgvTmlOVFUwSXBsTGdlbW40?=
 =?utf-8?B?ZWFtaW5uVkF1WmdSOStOb3NoVmZBZURRU3ZLWVZsTXB1RzlkMTVLUklPNVVm?=
 =?utf-8?B?ZjNJdHM1MDA0NzJDUmpTRTQ1TTdldzNyUzVhNTM2bzhoNkhESXVwR29HeFNS?=
 =?utf-8?B?TzZxdkNGVHhzZjBnNXdJVDl2QlZBUkhJNGNVZ3BKZnRwMEFUTTdKeWZpSnB5?=
 =?utf-8?B?WWxWcU44VkxGcUtONVAwVEFCVTdsa2w0eEZLdkRMeFZ0bTJHWnZMRGhOT2dO?=
 =?utf-8?B?Z3drZm1rTjBpaXhIamI4aEFBMS9QSFNqOFBJZHI5WUV4cFhCNnZ6S2tMTS83?=
 =?utf-8?B?SHhxRTk4YWJ1Yy9OaGhhakxDZ3hLWkJqSWc3NFNoekwvc3ZLczB6NVk4TkZU?=
 =?utf-8?B?VWF4T2RZZ09halpkbTF3ZmpYSVBnTnVZZi9RelN3S1RLbmtkL01BWnZEZ1cx?=
 =?utf-8?B?bUM2UzVEUDhScnllbXVTYTNmY3hTenlyOWswYnlCejFtMndXQXhaVlJqREVk?=
 =?utf-8?B?dnp6QXhpM2tPWitjS2FGSmhqekJZVEUvTmFtN282SnY5c0E2Ry81SFFxTnpZ?=
 =?utf-8?B?Zm9jend2Q2hxSE9uSHRENHJTb3B0dGVRcWVYTTllVEljamxtYVpYa1Q2WGM4?=
 =?utf-8?B?VXJlZWM0QVdBNzFwL05uT2VSNGhtR3JMODhiZ0N4MEcrb2lTVlR4OUE5WTRD?=
 =?utf-8?B?TE1nUjFMa09kWEYyeldKdkJIRmRQOTk4N3c2MEFJUE5aNGxSNDkvWEZDY0JY?=
 =?utf-8?B?TzRCSzJjcDJoL0wxazg2Q0RGZmNUb2k3aTRQb2lVVnFKdGJqUnJ6aDdvcGZU?=
 =?utf-8?B?NFBTNHBEa3pZQWVwTnE1cFJBM3V3a3N5Qk9aTjJ0dnNRenNYS2Jjb0QrWDZG?=
 =?utf-8?B?SE4vZ1U1WlFuaUYxSHVPTjRNUnlyajJEV0IzNGZ5OTFwekMvSi8wbFU3ZXJl?=
 =?utf-8?B?VFlqSWV0VU5iT01kSzliVXFOS05rbUtwTEdaNk14ZWcyeVRnd3lxakQwYlc2?=
 =?utf-8?B?THJwZDlvbElOaHFNcGlnK0tLTjllRkdIVXY0N1ZET0lJbVZZMFVYRjh4Skpq?=
 =?utf-8?Q?YVC6Y4yTT0bcBl3JN+MFE935f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da57c603-8e0b-4cd9-6c02-08db1f2b6fff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:46:02.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9b6W/wR7tiFnWdyZ4mdlezHtWCeo4MlCesUIR5kQ8VKEal+VQKJ4gqpZ/W6Zu9K9bDz21rGjR6U7//JPCy3obQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 08:42, David Woodhouse wrote:
> On Thu, 2023-03-02 at 11:12 +0000, Usama Arif wrote:
>> The main code change over v12 is to fix the build error when
>> CONFIG_FORCE_NR_CPUS is present.
>>
>> The commit message for removing initial stack has also been improved, typos
>> have been fixed and extra comments have been added to make code clearer.
> 
> Might something like this make it work in parallel with SEV-SNP? If so,
> I can clean it up and adjust the C code to actually invoke it...

This should be ok for both SEV-ES and SEV-SNP.

> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..f25df4bd318e 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -70,6 +70,7 @@
>   	/* GHCBData[63:12] */				\
>   	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
>   
> +#ifndef __ASSEMBLY__
>   /*
>    * SNP Page State Change Operation
>    *
> @@ -160,6 +161,8 @@ struct snp_psc_desc {
>   
>   #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>   
> +#endif /* __ASSEMBLY__ */
> +
>   /*
>    * Error codes related to GHCB input that can be communicated back to the guest
>    * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index defe76ee9e64..0c26f80f488c 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -204,6 +204,7 @@ extern unsigned int smpboot_control;
>   /* Control bits for startup_64 */
>   #define STARTUP_APICID_CPUID_0B	0x80000000
>   #define STARTUP_APICID_CPUID_01	0x40000000
> +#define STARTUP_APICID_SEV_SNP	0x20000000
>   
>   #define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
>   
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index c35f7c173832..b2571034562c 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -26,7 +26,7 @@
>   #include <asm/nospec-branch.h>
>   #include <asm/fixmap.h>
>   #include <asm/smp.h>
> -
> +#include <asm/sev-common.h>
>   /*
>    * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
>    * because we need identity-mapped pages.
> @@ -242,6 +242,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	 *
>   	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
>   	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
> +	 * Bit 29	STARTUP_APICID_SEV_SNP flag (CPUID 0x0v via GHCB MSR)
>   	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
>   	 */
>   	movl	smpboot_control(%rip), %ecx
> @@ -249,6 +250,8 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	jnz	.Luse_cpuid_0b
>   	testl	$STARTUP_APICID_CPUID_01, %ecx
>   	jnz	.Luse_cpuid_01
> +	testl	$STARTUP_APICID_SEV_SNP, %ecx
> +	jnz	.Luse_sev_cpuid_0b
>   	andl	$0x0FFFFFFF, %ecx
>   	jmp	.Lsetup_cpu
>   
> @@ -259,6 +262,18 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	shr	$24, %edx
>   	jmp	.Lsetup_AP
>   
> +.Luse_sev_cpuid_0b:
> +	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
> +	# GHCB_CPUID_REQ(0x0b, GHCB_CPUID_REQ_EDX)
> +	movq	$0xc00000040000000b, %rax
> +	xorl	%edx, %edx
> +	vmgexit

According to the GHCB spec, the GHCB MSR protocol is triggered when the 
GHCB value is non-zero in bits 11:0. For the CPUID function, bits 63:32 
hold the CPUID function, bits 31:30 hold the requested register and bits 
11:0 == 0x4. So this should be:

	/* Set the GHCB MSR to request CPUID 0xB_EDX */
	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
	movl	$0xc0000004, %eax
	movl	$0xb, %edx
	wrmsr

	/* Perform GHCB MSR protocol */
	vmgexit

	/*
	 * Get the result. After the RDMSR:
	 *   EAX should be 0xc0000005
	 *   EDX should have the CPUID register value and since EDX
	 *   is the target register, no need to move the result.
	 */
> +	rdmsr
> +	andl	$GHCB_MSR_INFO_MASK, %eax
> +	cmpl	$GHCB_MSR_CPUID_RESP, %eax
> +	jne	1f
> +	jmp	.Lsetup_AP
> +
>   .Luse_cpuid_0b:
>   	mov	$0x0B, %eax
>   	xorl	%ecx, %ecx
> 

Thanks,
Tom

> 
