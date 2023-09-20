Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B857A79BD
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 12:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbjITKvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbjITKvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 06:51:11 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2041.outbound.protection.outlook.com [40.107.247.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5952E4;
        Wed, 20 Sep 2023 03:51:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRwNMxBxr5L2Gy6QsNvOdh+bMiuQPG0dfXJXa1q5XnPBYHvvkZ++inBkDdnaaenmRY4wc1qhs41VsQD7XO77iIkd5fhTVJ9NmmIg8dawiLr29DVeIsN+kI6bykRdohZx4109euTkLwf0grTvy80ZJXq3PW9Gms6B2LFpvy6TMb+OXarQp8gkHdSZ73IW2cqWI76wE1AW4+QFlQG90lrpmxCXE9qg6B/XVNoI/CRHoT6qxwPHovGc9f4wtFyomT7j6ppOFVY7nDTF67S2DXNym1BA9XmZxnlFIT5YNTP9fqTXmCIqebtHKTGiB0afmhgxCt34R5puTKJclF6DsqkTqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mn48O79cCJUHPDmHf5UU3FL2KFU9vaaPc5Rcjmf5v4=;
 b=awFkq182LhHFar7MkwgPIksVv6nUSnHBj/kWomi/14S08SZSq9Fc3/mqqnqurEztfdhd+xvHqo9RH8yQ0ezy+b7THAldpIZV8VBulog4N54tPL09pwezHUMVgEdPjcMI9jVuLuq+gG24wkYeC5lQxkcqK7EVZG39Y1zaEWsWOWLbSMH301RYZnoW+15yIzE2m/RUl/IoL4Py245BZoidHDsNJEqeYszXLQCPAt0dAnauo5GJcNvWtm/WZkMO4PayZLdzzkmKafziONJH5u2QznpDWrsmuuQIRXHmOX1iL/825DSAQqfoyz1hWtKSS8jH3CHOEp5HjWlQXuxrX9gkbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mn48O79cCJUHPDmHf5UU3FL2KFU9vaaPc5Rcjmf5v4=;
 b=xvCSw0qU3Wncbc9h17hm9HBWqhMBFabuQ5pAMKU7p4/+tZGQzcA2h/jYAVlZG9oxlAkLS8GNaT9ZAtsQ+DAP6zRgGnVh/UK9ACvGDZGpXFHAu43zxW0znd6BW1oyeBTNDH3jlMFC2c8KFp7RJhXWdJp23eGOwahod1p5thrR58ctEzZmwOZ70E1QsYwMDkB+AAnIYGQYFwaQiceMhKzFXTkaeY5CMntJMRDawP+N828//RBpORLPGaQHNX6aeZYx8C80mB949Lcd0lpOWagwOHUrFiJP+nw3Wue0cMNMcvaI3BCKsEVvS6BVXQx3Gu5P2fGv8CimesgjNL6DyeQ07Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15)
 by AS1PR04MB9697.eurprd04.prod.outlook.com (2603:10a6:20b:480::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 10:50:57 +0000
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31]) by DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 10:50:57 +0000
Message-ID: <085176da-924e-8d6d-1c56-8bfc9d457b0b@suse.com>
Date:   Wed, 20 Sep 2023 13:50:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-14-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v10 13/38] x86/cpu: Add X86_CR4_FRED macro
In-Reply-To: <20230914044805.301390-14-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0113.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::42) To DBBPR04MB7788.eurprd04.prod.outlook.com
 (2603:10a6:10:1e4::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB7788:EE_|AS1PR04MB9697:EE_
X-MS-Office365-Filtering-Correlation-Id: 315d7862-073f-4fde-51e0-08dbb9c77872
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHYxRv9+gqf7o8sRdcd6/eZzkDX1Beo0yXUyTzHw0+uHfyARhX+uEd8BWiN+benYIxURj1+YboOrusNvBezSBVe3LYbquziWpqeSt35TDYZFe8OEn80WiNSAsnvUCe5YFhCCdm1WYiPcWNhnH1cgu9BtjcUlIwo2sYHteOtTvSasfuQyPMOG7KXyEkvYWylx7mUXTWUv1tvJdH2gyfcxv2FAFBbaN0GYbO+AUpDgO9WTx8h9CfXpCUmRqjcWQnLDl+9AzXW2s1Lvhwik5TolotcOJEm6Nm+ON9uW73nEoehGGo2l9iWp8eYo3K8EGldxDYLfvsPzoh1r4Iuw+IQz28wkf6Rgt7c2kWPWyZcO9Omgq1mhmVz0g9Hh5nerbYt8XbhEnXzcuc8QLP+sGKF8OQI2/Ca9oOTpoUn6nJzUPY4ouEkljFGhjKHENVMSzj7zcfLfFyp7/lQaVD/fwx3E0niwGXqXovBZqGOV3KjhwP4AR04kYPZDCEn2l0sjkcQFH4IilMJzIdysbQ/YYiqtOV/lK2/2Wra/q+/xnvupOSelMftxGf2fwG/NSoqgVIC/DQmxB4S8SEfTseK/Q+hSHwphNmbPAmQI58Wxrv0UDM3uVWh0FOv4nVwoyyOce42pJ5iHge8ACLWGlc4QZ6jqPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7788.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(366004)(396003)(346002)(1800799009)(186009)(451199024)(6506007)(2616005)(31686004)(26005)(5660300002)(8936002)(8676002)(4326008)(6486002)(6512007)(83380400001)(478600001)(6666004)(316002)(66946007)(41300700001)(66476007)(66556008)(86362001)(31696002)(36756003)(7416002)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzJMV0h1cnZSSWswWGJQbk8vcGFOUS9NK0FRbEFqcnhzSnVPYVZHV0pzSFZX?=
 =?utf-8?B?ajhKTXhEaS8vOUZpdi9oV2hBbnVJN1AzRUUrSllrbDNGbVpmYys0Y29mM3lQ?=
 =?utf-8?B?VTczZ3g2VzVETlRaYTFRSHNjK2ZPZktZWURxbzFtcitWbUhtMWwxM2QvaXRW?=
 =?utf-8?B?WTVjc2pJb3NJaGxENTZmTzY1cFhqVGUxMHQyaVBvek5tRjJwaUd0RUVoQzdh?=
 =?utf-8?B?czIzZkpmOXlSWnJQd3pnUWFHNllJMlYzRWEzUlV3MEZXdTZDVEFWWm13MnAv?=
 =?utf-8?B?OGtSbVYwemJSMWxQZVIzQTF2VHVaWDdnYWRyOWZmNlllQnlEdU5iSmpvamlt?=
 =?utf-8?B?dk5DTkcrbzEwWmJxdGZtNXNZbS9EdFdXaFhOb3RGWFdNLy9NUHVqNG1Ock1M?=
 =?utf-8?B?VjB4Y3BMMWRObjlmUGdFYXN3WlQxT1JDdmRlRXQ0L2V6WWF4UjN2RWNlbjRB?=
 =?utf-8?B?MS9UY29hOVlESWVMTFVwM2F0Vk1La1U3TFJnVzBXdHdqRUZiYURyR0NpOU45?=
 =?utf-8?B?cjhYUlBPR3BMNStqa2t3Z1FzZ2lRRDMxRWxXQTBsTjlDaklZVEZVN2MzMmtt?=
 =?utf-8?B?V0FEMzZJQU93YzNWSEdrMUsxWnFyRXdCc1ppaGhPTmI2dmRXV1Z3c2FWa09P?=
 =?utf-8?B?SmwzYnBUdWdPUi9WZjM2bWlsU1E0VWhKdDBWd1BvVzN2UzBwWERSU1hpUVVY?=
 =?utf-8?B?S2NmRWxLQkhMbjZOakZtK2liWUZ0QTBFeDhyZGxFUWJvdUdLeEJuenNBL25O?=
 =?utf-8?B?UnlUVlF3dWF5czhIcFdheVlRSkIxUEJYbVVOWEdGM1dSWlNGSVpMQ0QzSVM1?=
 =?utf-8?B?Wmd1cjdIMUtnL2E3bzkvWkJ4U0FWM0sremhOTFFFT2lJYTVsN0ZvT1JvYmR2?=
 =?utf-8?B?dXJSSURyQkx1eTZJazcxZnh6Q0JQYmtQeFYrWlluQ1pNemFYS09kQlJRQTB4?=
 =?utf-8?B?bUVybWZGN2F5QUdqWFZMRC9ScmpQWTR6Y0QzZHd2QmtKaC8xb2U4eldqRnpr?=
 =?utf-8?B?cHo0N3ZnSFRURitlTDFrRnhqTlU5d2NlQXJySXhwSVl6bmVpbXNXSHk1dktT?=
 =?utf-8?B?Y3dIOXJ6K1piUGpHU0Y2Vm94dUMyNnlUdFVRRlBjM1RnZEVNK0JkVXFLOGxK?=
 =?utf-8?B?Zk1uRFJvYTJYcVBSaW9lVjh2MEJtcDU3ZjR0V3Y1YUxGcGMxWm9qN1hkdldi?=
 =?utf-8?B?SVVaV1ZlOVpFN0g4ZG0vVFhzOTdMZStpQ1pCaGp2NDRVb3F3bFVJdUlzUC90?=
 =?utf-8?B?bC9ZTEVlMHQ2YVZYZ1Nab2dEUHRLUU91U1N4UU0wUHU3QWFBTDRwcEQrZ1dS?=
 =?utf-8?B?Qzc2MzZwS3ZvZlEvTmwrbkFjaVJWVVZFK1ZMdnkwa29BZk9UYm5YUUcyMFRR?=
 =?utf-8?B?Q1FoQjYzcEJkUkdiOEdjTmFsd2VkeHJPSmNMb1FOTXd1eXkyZ0txMWdKeml6?=
 =?utf-8?B?bUx1WmRrODZjcm9rSnQzWDZsblhnSFVKNHV0cG55dmUrWG5zcjFmbDBJRjNp?=
 =?utf-8?B?Q3pHNVRmRURWVDYzdXNKczFMR0UyUDNtaVNFa0hFNVpXUk11ZklSZ3BrejNs?=
 =?utf-8?B?SXFJdmsrbTQ1eUNGNzd2c3ZXYW9tdXBOVkVjMVdkeDE1b1FGZlJUTUtLWWk1?=
 =?utf-8?B?eDNFdWZOWEtYMVI1aFF0WmkyZ1duNzQya1VzUDkzS3VGZDh3TEY3eFlzK0Fx?=
 =?utf-8?B?cU9nYWhyWENYRng0OVZva3ZzaGNFd2RuSkUyY0cxRlppY2tKdXFHWjBJakhI?=
 =?utf-8?B?MXcwQUNQb2hIcUk4dHNPNWZxTVY1NzJUU1Y2Qi9iQmZPdGhrenZZN0tkSXp1?=
 =?utf-8?B?empWQWhHWVRnYkFTUjdEN1psQzVneGRPZzBvK2hQWFJMblhkOEZjdzFyUWlv?=
 =?utf-8?B?VTlKN0xUczMyTHhnTTFmYk8yclE3eGVWdm16bUR0UW9FMUdOWEREZk5qRk1m?=
 =?utf-8?B?SlZac2swRkdKQjhHTnpvTmdZYXo0bG0wenVuV05ISThDbFphd1EwYXk0RmVE?=
 =?utf-8?B?TUZpU1Q4TU0rWVdtWVpVdEcydWZrZmc1U0xvZDA1RVcwaE44V3FGVVRZSXVD?=
 =?utf-8?B?QWt0dUc2NzVyV0Q1UHNrc3liNVlpSzg3Y1RoeE5VWGZJS0hkdVUwd0JnYjJt?=
 =?utf-8?Q?HLy8YoQUSgE+KJTM2BFuapYYY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315d7862-073f-4fde-51e0-08dbb9c77872
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7788.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 10:50:57.5825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qwkcv/VyZxNurR2292Q8b5NzmCjdzC5pRDe7q64nr4B31dfPUo90H1Zgp3AYkuNC0gyfr0R3b9Z0t1dNBYSw4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9697
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:47 ч., Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit must not be
> changed after initialization, so add it to the pinned CR4 bits.
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v9:
> * Avoid a type cast by defining X86_CR4_FRED as 0 on 32-bit (Thomas
>    Gleixner).
> ---
>   arch/x86/include/uapi/asm/processor-flags.h | 7 +++++++
>   arch/x86/kernel/cpu/common.c                | 5 ++---
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
> index d898432947ff..f1a4adc78272 100644
> --- a/arch/x86/include/uapi/asm/processor-flags.h
> +++ b/arch/x86/include/uapi/asm/processor-flags.h
> @@ -139,6 +139,13 @@
>   #define X86_CR4_LAM_SUP_BIT	28 /* LAM for supervisor pointers */
>   #define X86_CR4_LAM_SUP		_BITUL(X86_CR4_LAM_SUP_BIT)
>   
> +#ifdef __x86_64__
> +#define X86_CR4_FRED_BIT	32 /* enable FRED kernel entry */
> +#define X86_CR4_FRED		_BITUL(X86_CR4_FRED_BIT)

nit: s/BITUL/BITULL I guess if __x86_64__ is defined then we are 
guaranteed that unsigned long will be a 64 bit, but for the sake of 
clarity I'd rather have this spelled out explicitly by using BITULL


> +#else
> +#define X86_CR4_FRED		(0)
> +#endif
> +
>   /*
>    * x86-64 Task Priority Register, CR8
>    */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 317b4877e9c7..42511209469b 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -400,9 +400,8 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
>   }
>   
>   /* These bits should not change their value after CPU init is finished. */
> -static const unsigned long cr4_pinned_mask =
> -	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
> -	X86_CR4_FSGSBASE | X86_CR4_CET;
> +static const unsigned long cr4_pinned_mask = X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
> +					     X86_CR4_FSGSBASE | X86_CR4_CET | X86_CR4_FRED;
>   static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
>   static unsigned long cr4_pinned_bits __ro_after_init;
>   
