Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EA15F4573
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJDO2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 10:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJDO2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 10:28:32 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1334A61128;
        Tue,  4 Oct 2022 07:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAm9ZBAwFFfC3DisnztmXUFHi2y2mlAq7/rr0cfGnqRzh8iakjHtuhiAMBqEsP3YD660MO4i+kl/7QuTJc1ULN9oilk4lIxbc61ieU6PEmF601W21pzUkPbGopPuM8gqn/kFAvo2a/sZJdCN4KzqPEBFJxWcHVVwrw2NXe2mmjo98YoI3kY+zfXcR+D/6DMu+HcqLELB+i51Tb0It6B/qCWjG0figsqN5gHJiGLslpbGpXP8sMJVi34ER+swqTltcRMUsKvnSOR08clNk+lrUuFSMEM4pxYzMXgNGEJ4l7qgbodLtMXyJuqJLfdnAh2zxcJ7O8dUN2zNdkMCKFHx3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL2XPOLD6tWkE8O2FHo5kiDs2xk64koXtzklcO5oNNA=;
 b=gUb+net4YHDAE3Lm8vVrzZF/oM47RZ8yLzntW6Qi0Z5A+AwppsJDYg+aqkTLgFiuoyjiXtqsG3UFcWt7FgtGahrTokY2J4M5XYTwlguU6dBE9xpMoEbqMFtBNqxtTyECESDO47/MyCFHo2BPC4/5F7EmSMCVFT1wFba/+kimRsaX7EmJwJFkoXpPIPqIsf1QIqoxjpt4ZSpbDSAUiBF5YojJabMcuWvUPNNNlbaZ80OkcfjuX3zHn5nqxEc8jROOONNZDgVJG4eyZOTKGEZO35WhOPi7pBV+oCcHuRhlTy0qXKRL0CGXcM/YVjW89Zy28LVBhXCfnDnjnrFqPZit7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL2XPOLD6tWkE8O2FHo5kiDs2xk64koXtzklcO5oNNA=;
 b=TB13bNhe7k3GRdMkEcmcqsvXXwzvvzZs0qsc6yd1GeW4m8E+79eaGNFbfNzqaJJFrcwcC8m5UQxJvdCzwgsVvJk+LvYcbja4XDdwfCOjpventFbPKhEkc3WrllFYB6aa/Y4hop594WF1TwBatG+GWDzAzrN2KMruGFjyEoYph6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by BL0PR12MB4900.namprd12.prod.outlook.com (2603:10b6:208:1c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 14:28:26 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649%6]) with mapi id 15.20.5676.019; Tue, 4 Oct 2022
 14:28:26 +0000
Message-ID: <dd357565-d428-499f-fa0e-e35aa043449f@amd.com>
Date:   Tue, 4 Oct 2022 09:28:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Language: en-US
From:   Carlos Bilbao <carlos.bilbao@amd.com>
To:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
In-Reply-To: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:610:57::32) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|BL0PR12MB4900:EE_
X-MS-Office365-Filtering-Correlation-Id: a334fa4c-5ae1-4b29-5110-08daa614b321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPhSylewVBNYoCQ+Qax7H3IHR1a1OJXAfMQmyJKRH0IEn/Qyg8IjDMDZbanK6uh2mzghszToD3jt0rV7R996BAkqNYdXlwprmCgonjoFr/jUA316NQyKpVjAfZ9I2KCa8mBYNFmstAxbPvuoOqKTH4esQxPIShN2y1KZJXAM/aLheQvQ9hLofGxz8MFlRKEAnk5pKeGwt+VYf7rcUyqaQlckRTU7/Pmb8bGJ4gpxaM0XlUmp50tvmGx5/dbxeMA+xzFwbfwptIWGj6aY7TS7N48T6ToE0sAr3FWfo18l770qYo27GCdsKiAa/i8LtF0gLGSaxumXlNEMzu9dXoa04VxNK6PdIbaxZyoFJjsB0y52Mmo4v4SROjugHzzm0ajhIJRDG/gEgF+d4su0xS4KwluUD+hbZv7Obn1KoJyJqjIrZa/ueFr7QOLMsgaEVS8rOpGhK1/Q9ps/QFSPYElX0fXfCA61CTjotZOW77+olcnmtops5lpL7K8OSbGYoUHj2Cuz1lednmk05M5cSZxNRWcXNUwAPJJC5KAI/E2mUQNAtmvygkcWfpNRupHmscU3TOCEee6D6EdL2QfJ5tLd6YeJIriwGU1AdBheqEbZxFbIfe06c0dWNvqTMOidlnfGt7/xmV9uARPAc9fIOe0SPn8glMb7lfS5KHJy63yibpeGolCKZZ2qEjLGMw5zVR4VRtvtmmJ1HJMVB7lCeejtKj6PCowTgvBr5PKTBOZTAOgkoCux8NA2RIuNf1j5sK3UDEmDbeTsAN/xfg1P/uu5J/cHpxPM4GM5lQG+s6eqF6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199015)(31686004)(478600001)(36756003)(316002)(2616005)(186003)(8936002)(2906002)(5660300002)(8676002)(4326008)(66476007)(66946007)(6506007)(6512007)(53546011)(26005)(66556008)(6486002)(7416002)(44832011)(86362001)(83380400001)(38100700002)(41300700001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmNVZTBQblhJMDlkcXBMMzJCTUQxdDk0dTg2QTc4b0RidHMydkdNUWJMUWF0?=
 =?utf-8?B?ZGtYMFBBMmpHNVYyUWlObjdPem0xSW9HUW9mcDlSaTRiSlRjcDhFMjFMN1py?=
 =?utf-8?B?SjlTd2tPMGkrZW8zS0g5ako2K2k3WGRQam1yUlQ0a3lmQ3hmQVhSN2pzSWxK?=
 =?utf-8?B?K0lKS05lYTkxbFYyVkVnSHBuRW5Heno3N3hsOTNpU012NDBsQlpMQk1EZ1JQ?=
 =?utf-8?B?M2MxUGRScktlZDcxVmZTT09pY21ydmhFUmJvc0pzNUdnSmZ1Nm51TU4yWk5I?=
 =?utf-8?B?LytTVFd0V0ErNmdNN3QyTVRuaDlZSjIyTFgyamx3Q0ZsVXpNTjJaN1hseDR2?=
 =?utf-8?B?RUlBdUtyVHNsbjF2UHlIVytkUitldmNsR2lFNTM1WlpacDNmQnRHcnlCK2p4?=
 =?utf-8?B?Z3RiYkZENURnUjZGZjF2a0VMeVZZWkFyUnZuWVZiajl6RER3cEhZU0VNaTVO?=
 =?utf-8?B?YWFiRjRzeGYwYklhbEd5Rnc2Qk1xNEY3VUlka1dmeTBIblFDRStJRnNYNWxS?=
 =?utf-8?B?Qnp4ZnVoLzN4aWtnajA4ZlNPaEFqSzZ6TkRweisvWmZLWXE2NDlGaldQWUkx?=
 =?utf-8?B?NlRuaTZjSVZ0dUJWY3JteVVVSEdVcjlqK3NrNUhzMllGdU9lR3Rsa2dwTm13?=
 =?utf-8?B?VUsyM1lPSU9hbEpLSGZwdWdBWkVyRVhCNTZxbHpFYmRoejNybWcrZmo5d1lX?=
 =?utf-8?B?UkNCUXg3V0xkOTAxcklQV3R0ODFlV3piQ3dSQVF4V3ZLaHBpSDdVOXZlaUxF?=
 =?utf-8?B?SkEwVUl0YWpmMCsvdzB0a1BxMnVlS3JiSFhYT1I4RnlpM2hRRTRjd29ZV1VV?=
 =?utf-8?B?VUQ1MDB3cWh2dSt3UENwcDJMem5QOG9Ec1pSbWh3U2Z1L05ET1RLcko3MzhH?=
 =?utf-8?B?Z0RVRE9wK1lLeUdVQXJ4TGdmSWExY2YyWCtYbEFnYys3VFU5UW5DdWJlL3Rv?=
 =?utf-8?B?NE1YZmFjdERySUVMemRNdmRWaE8waFZOcVJtcUZHMVZ4WVN3RlJZYlNQbXVD?=
 =?utf-8?B?OVljLzVHZ05DQUE0V0NkUmJ6d0UzbUZSVjM4a3Q4Q25vcUR1SW1lREVucUdG?=
 =?utf-8?B?Qm9JcndYaVpWdXZqa1pGNDdXTnh1UzlHclRjTEhPOVpoUThNMDBqejJkRVpX?=
 =?utf-8?B?Y1pFRC8xWnVhcTMyTzNlWXBhaWlBZ25kdmR5RWczcFFOUVZFcGZSMjZiM1RC?=
 =?utf-8?B?eWVDd1dJcWRiVGRVYTFGTWFkV0hhekhnWDdVMCtCNGUveTMwblhxRmdhZCtY?=
 =?utf-8?B?VnB6eWhJb0ZHdm9OeHNXYmRGdmt3enR6emQzWk0vVC94dTREOFNZc0gyN0NJ?=
 =?utf-8?B?OUZVMnF0V2RFNzNZR0pBZ0FzVEM2WkNYb1dpOVM1VlAzcGtZNnVVaGhkZVFi?=
 =?utf-8?B?bGc2VEZuMVFJM0J1WHVuejNyeEgvN2lnaDJCS243MUdEWlJqRW1IMVRPS0Jn?=
 =?utf-8?B?RnJYV0RJQnBTREgvcDJhSjZYenJidGU2MTRFbUF1aTdERE9mdWE4M2RENVd5?=
 =?utf-8?B?ZGpiZ3FlYTY5dytRVVBLUHQ5V0s3eHUwQ0pMTXIzSzZBbGpTbWxLTXl5K0RR?=
 =?utf-8?B?bDJ6eFhGamRZRnJ2dHlQQjIxUVdiZWphU3N5eUFlU2NHU0w2SkcybGEvaTZY?=
 =?utf-8?B?TkllcjY3TzBVeVhVaWdqaGJjYXFLcFhISmx4eEhIbkJ1K1lFRTV6VTcwbmoy?=
 =?utf-8?B?YTZ2MVdXQW9wTGpLd0xlZEVLMFFSaHZQdW5BbmxBYlFNMlV4NjMvZThiNzB2?=
 =?utf-8?B?ekUySUN4b25zaU9aMmZtYUNRaDlGN1g3aWxCNUFFZUxOYXh5YXk3R3dKNGhr?=
 =?utf-8?B?NnI4TG9tR1FHdFZCR1lsMkFsemk2SmJpdit5RG4zY1dmS04zQ2k2MTJCdFls?=
 =?utf-8?B?N1NPOGwxRHVDNnhCNmZaZUxpUWNSNU1nMDk5ZVQ5WVV0aWtpckdibmdWa1pS?=
 =?utf-8?B?QlJyM1g5MS9NOTJ3TTRvNmw3ZEhhL1h3eElkS01qSGlSK01YTExUTllwTkRT?=
 =?utf-8?B?QkhnbjZ0R0xDa0Y1bFZzV3lZK2NmNlBJNExRK2xwZGJKNnRxemNiTDZSblpt?=
 =?utf-8?B?ZHNjN29VdFBBRWhIWEhrOFg3aFdrU3pka1RnRjNrWnY5Z2s4ZVFxM09JSWdY?=
 =?utf-8?Q?1LtF2AMxlfxGfU5SZ6c4dT1Y5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a334fa4c-5ae1-4b29-5110-08daa614b321
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 14:28:26.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 106j6wRtoT2RANGj8vIHLecijJvU73DI0N0jAIHNJEXgwFJQU1w6s2Kvw4K9yqaWUp8glv4w+gLGFZFMIohwMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4900
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/22 09:05, Carlos Bilbao wrote:

> Reserved fields of struct sev_es_save_area are named by their order of
> appearance, but right now they jump from reserved_5 to reserved_7. Rename
> them with the correct order.
>
> Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")
Actually, there is no bug, so this Fix tag could go. Thanks!!
>
> Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 0361626841bc..6ab45a0389dc 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -393,14 +393,14 @@ struct sev_es_save_area {
>      u64 br_to;
>      u64 last_excp_from;
>      u64 last_excp_to;
> -    u8 reserved_7[80];
> +    u8 reserved_6[80];
>      u32 pkru;
> -    u8 reserved_8[20];
> -    u64 reserved_9;        /* rax already available at 0x01f8 */
> +    u8 reserved_7[20];
> +    u64 reserved_8;        /* rax already available at 0x01f8 */
>      u64 rcx;
>      u64 rdx;
>      u64 rbx;
> -    u64 reserved_10;    /* rsp already available at 0x01d8 */
> +    u64 reserved_9;    /* rsp already available at 0x01d8 */
>      u64 rbp;
>      u64 rsi;
>      u64 rdi;
> @@ -412,7 +412,7 @@ struct sev_es_save_area {
>      u64 r13;
>      u64 r14;
>      u64 r15;
> -    u8 reserved_11[16];
> +    u8 reserved_10[16];
>      u64 guest_exit_info_1;
>      u64 guest_exit_info_2;
>      u64 guest_exit_int_info;
> @@ -425,7 +425,7 @@ struct sev_es_save_area {
>      u64 pcpu_id;
>      u64 event_inj;
>      u64 xcr0;
> -    u8 reserved_12[16];
> +    u8 reserved_11[16];
>
>      /* Floating point area */
>      u64 x87_dp;
