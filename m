Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AB07A77D6
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 11:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjITJow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 05:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbjITJot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 05:44:49 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211BECE;
        Wed, 20 Sep 2023 02:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVvKZIsC0e3cKTuIVD1pCshC/K6pE82ujA8i/GBe28wm1DKRqrXi7kJfpMZ1PjTI2/mCUno1E/vz+bO4k/5j9iSECCU4zKZo+jj4p5xHTARSX+yKqEvxItfQjbX66A9CYgCzlCHcMP95EoTP5J4waE8o64Z8B+YSOIHIA4oJJvaj5X5GRyrTAAaw6N+AGnwX4SthZZ2G7MB1xSA+RKYd+5at3OpEj9hxpAIMfPoXUW/kB66bGUOpfKewRHdDuCS6JKxeVtXbL4rWFaVB9eZ7Vata6gb+bJUm4gXvS82rnlpPDR7Oa9eorGuHHydyLRriYmDbnFryeUrx20N6wu/l7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UtxivITkJkOtaPuJj7c32JRnWGOu72fRn859bMMgK8=;
 b=noMzkIeB77uM0h9ZYPMDXxRoTqbk+lxO4xDeJuzVVVO/G0mE93sR+eGki1VoxLcZFMT17FUYr6CS7yESPofRO/cspJuBKr7C+Fo20+rTsJ2tJm64fS9mgGcDUPW05UlOPgV7m7biLDdQuyvhxzH/yOpvDr0QGGKOlgwwci2BGOKjGO4ln4SLJGTYRHjG8Tbj9hHHA5yM8WoQzNQ59w5GRx3BGRwMI20v8ZNVW9jJt+ar0Qh9NKHjxbYRyK/YglquYUUzL1fv9QqJ27mn66+Ev2W9lUpHXjt0NmZJfik2blwOXPx7kcZbS+281/IPpTEdgFm3Ytsf3fuerx9qTli6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UtxivITkJkOtaPuJj7c32JRnWGOu72fRn859bMMgK8=;
 b=OEc6dkzJUEFYROlXBQI2n9DW+N+xZmMREPNfVS2hBlHdmz5WWBRM+r2uMGGpvD2thyXhUkkVIXhZxg0P5IqM8GJpEY0wCEZ/2G+bKQEa9v39SnruAITJNz6uS+GTK/GG6MOrpsNayhylG4Cmz9djBumdj1SzozYQyh/gTKpKaKWAFf9c/9NCAhctbjSIuzd6vxLoVu++uciLvpdSZg4i8BhMmOVOGVKne5c90wHwOnLDCFYhMjPV3a1iaZ9Xlq/8tVGKiA/X30d0NozoufV2Kj0jtpmZRzABL5ET0On1HwAeX9d2mknu+KTxfdHG1hFr35LoNt/LspIMdS8EqBRDXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15)
 by AM9PR04MB8132.eurprd04.prod.outlook.com (2603:10a6:20b:3eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 09:44:38 +0000
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31]) by DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 09:44:38 +0000
Message-ID: <b28b68ec-b86d-6641-e303-41747b9b5c10@suse.com>
Date:   Wed, 20 Sep 2023 12:44:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 06/38] Documentation/x86/64: Add a documentation for
 FRED
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
 <20230914044805.301390-7-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20230914044805.301390-7-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0032.eurprd03.prod.outlook.com
 (2603:10a6:803:118::21) To DBBPR04MB7788.eurprd04.prod.outlook.com
 (2603:10a6:10:1e4::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB7788:EE_|AM9PR04MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 007d6d41-c1c3-459f-c13f-08dbb9be3484
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /820x9R7hkhc/SawfUZtrBxb7wgHZN0RAYHKWqZZpr3GDoEmZ+WpPPtv531UHqsK2eTX/AP2eiV3xBJbSbtj56cQgX74KxWZKUkJVIaW+4AeF+3JIR8pSdaEh+w9aS+wiAOsrdqwdUaSunkL89OYjt4orPFiVWbikQ9X7NP8oA3GO1H0w26RVjLI63d8fbgRVeghV1fiODxi161Wu8ErXgmhNDrn2BO5GbnYMzixtgzgUZ/9xCE08BI5Cdp0lbaUtoNz7YjLGX/0oceeFHNsW8pAVBCOmZWL4UlslB9mUW2qHKW7x7uylnwo08uyba+WsrjpZP5MqXeutioW3QWJuEO73gS3A+aN4CdMaQ+Ej7JNt3eHqmsBeVQYHkpR3e0eZx/O9ZtMdwpBYBMOOSQs4ijUOa8H3k44soZy3K1B0vLfJfmU/9mmPw2Th3lx0IDTNpGXilcr91VG9IVvOYbsrUzl+o/xTZ6i5a5nfKt5NimS+BZfuV/ckV8HWKGNtC1OLKgSvyfR/YS2ZBSlKEEs9aD6pHN8Cnn+wxBp1EpgHhhmGK2hNZp8u7+lOfleaM0zWH6pPnNBClUhbMTt6q8Q9TpmeyCqLYH5YfJfKc1YuQq6OrCieTmnwuusHLCJXhpIzIhqA1NQLDtea1luj6Rk0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7788.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(136003)(346002)(186009)(1800799009)(451199024)(8676002)(6486002)(83380400001)(6512007)(26005)(7416002)(316002)(41300700001)(2616005)(66556008)(66476007)(8936002)(5660300002)(66946007)(4326008)(6666004)(6506007)(2906002)(478600001)(31696002)(86362001)(38100700002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm9nSldNZzNqcVdJcWd1YURUcThiNXdxb0MwaFZ3a1FqUXgxOVV4OTdvUEtX?=
 =?utf-8?B?S0ZxcW9TMEpTMlk1Tk04SlExT2Rqbm1pOWR3YUNabDVwRXJFWmhTUzlTNVF5?=
 =?utf-8?B?Sm9kNUtWb2ZZMU9QanFHRk5WT1gxbzBKRTh0S3dMdkV6amNodmZ6OWR0cnJR?=
 =?utf-8?B?WDFzMFZ0dEhwV1RTdzlqOUdwc1hsZUNQcU15a0RTL2dqbWE0S0VkV2NZT005?=
 =?utf-8?B?QnpSZW83S2ZaTWdtUWc0MmNOWDJjeGJ1UWhFdktkYzZoMWFacTVyWlk3cEtu?=
 =?utf-8?B?cUxQeUhkcjd0bURSVWgzMkMvaGZwL0FaQzFQdnY1cTd3ZHBkaW1Pd00wS3Vq?=
 =?utf-8?B?ZkpQMlZ5VlIxYVVReWlad3padjQzOWFIbE03aVJRa042T3pxVmtWNzQ3WThI?=
 =?utf-8?B?VjFHTHBmV0h3aGQ3dzJPZEN0ZWpkZ2pCaW9kRUVKZm92RHduUHY5NFRmMXFR?=
 =?utf-8?B?aFhRZ1h1MmV3UXJZU0VPcEUvYVZvZWFSaEJFRGxXbzcwMkQrcVNXYUdsWHAz?=
 =?utf-8?B?YnBqSXprazB6YnYvL3FIRXI0RnUyVUJoS2x0NXR5ZkcwU3Vud1VjRXlMaUly?=
 =?utf-8?B?YTFleUZkdnhOQjJCTTAwMW1sS0tQWFNjdFV6clA1ZGxrM3REV1FwVE1xd1Jj?=
 =?utf-8?B?VVBQRkNNWTloRmFyZFBCYmxhbUJkd2RZZ2xBSTlQSWpoL29CNHZxQUFFTU44?=
 =?utf-8?B?OXNWeStmL0I4Ui9ZaStNbzQxTkVsMHB6YWVJeERQMHJOSkplam50UW5VN1BW?=
 =?utf-8?B?WlZhTkVxcGZNYzRLY2tORURKYkdyZFJJbDdHTEtTaldSazRRcTdWcUZNRkEv?=
 =?utf-8?B?TE9ucHlzTy9ma2dDVjEvRUNoam1VTnRqTDZ3ZnE0NTkrVGlCeDVXZHFYWVd6?=
 =?utf-8?B?aXF6WTBOQ3huYzdKeng1MEZ5ZFF0azZ5VkxEdis4TTZxREVROFBSK3Q1R3k0?=
 =?utf-8?B?L2RYOUlDTXVsTmNmOTU2TVZaUXpKNlhzd2NpU0dTMzZPZEEzN0RmL1RjcFVB?=
 =?utf-8?B?OVVBK0xGRVpuMEJSVHVoNjNNbEZTTlN2TmFIcEczZ2QwZWYrcUpmN3pEZEhK?=
 =?utf-8?B?SDNZcjFJSGZ4VGptSmhjM3ZsSDhsamw0L1B4bXJBS0RvYytqd2xuL3BkK1RJ?=
 =?utf-8?B?ZE5kRDBvaFdoanhKeStnckhVVmdlekxxSmI3bm5KUk40Z3ZrRHdQTWtlYmpK?=
 =?utf-8?B?MjhnYTUvNXVScXdSV0pxWm9NeWVuSVJCSEZLRGQwNUZ3UlJBb0tPaFVIbGxN?=
 =?utf-8?B?aERMK0JHMkk2RHd5WUhtSU1NT24vbTM2aTBNcUcwRDBzd1NVMXJQR1hRSGI4?=
 =?utf-8?B?VEVibkRMZzI0SjAxOVpCWXdlV0Y1VHlnUW9uKzJHQTA3SWJhcS9TdDRhS3FW?=
 =?utf-8?B?c1lZSFZaVDRRU2lYajBHOFRWS3ppUGUrbklyU0MzbWpjQ0NiM2tEOHVkVnpu?=
 =?utf-8?B?NVJOVmlyT0RINk1LTzFWUXB4ZE14MmNIQmEyL0JlRjJCVWZvMjRwUzVDZnNT?=
 =?utf-8?B?NG4rYWtCSHpENy9mYXdqTVVLaVpGZklMaWhodzlQdlIrSVlJTllQZVlsbjlk?=
 =?utf-8?B?QllLc3Z5SlVvRldpc3UyRlpjV0FIbU8xZm9mRnUzMUg3SjdHalhpYlZzVGJy?=
 =?utf-8?B?Z0Uya0NZSnp1TVBMWkQrOUxFRDJIL01hVlBhWlB0d05DamdBWFJLb3Nsdm5I?=
 =?utf-8?B?ZnB1VU5UUTFEb3h6bmdwSTJtSHhZdFVkMmpLU3RjVEVFQytma3A2V25DWTNl?=
 =?utf-8?B?Rmp0ZDBnMzVCS1NmeEF0RVE4QS9jR0hoVWdPRXJ5T0N4VC9nRlp5L1B4VWVM?=
 =?utf-8?B?OGwyalBTOVNCemxVOWpCS3h2QlNPOFFpZ3FvWXQzbnN0TDF4U3J0U2xraTli?=
 =?utf-8?B?VE9ObFhJc3BPcTZFdGtFNnlqOHhFZXQ2OTc3Nm1WWGoxTnVzWDV6c2dtcDhZ?=
 =?utf-8?B?a3NSd0xxTFEwTzg4K1dVWklJZ1pCR2Y1dlplbEFreDZEbzJpYXJiQ1RCWFVX?=
 =?utf-8?B?VGNHZU1nUGJQUVhkcFZkaWVxWEdnT2dPK3NSOUYvaTByOUdTeENsV3BzdnJq?=
 =?utf-8?B?MVA2UEhnTndVQ1dkY0NuNklGeG96d3k3QW8rL1JkbzBaT2dmVDFPSXM1ZThQ?=
 =?utf-8?Q?9bQg/GoKF8dfNw8GdV5kbP/Sm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007d6d41-c1c3-459f-c13f-08dbb9be3484
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7788.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 09:44:38.2383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XMekrE4+SoCTkFVNs/qagiRU44pYDYVD0SoV2WR4VN+qkAjWlrAIfM73A6wOPqieUCnZEX4x8Y7lY6xQbbLQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8132
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:47 ч., Xin Li wrote:
> Briefly introduce FRED, and its advantages compared to IDT.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>   Documentation/arch/x86/x86_64/fred.rst  | 98 +++++++++++++++++++++++++
>   Documentation/arch/x86/x86_64/index.rst |  1 +
>   2 files changed, 99 insertions(+)
>   create mode 100644 Documentation/arch/x86/x86_64/fred.rst
> 
> diff --git a/Documentation/arch/x86/x86_64/fred.rst b/Documentation/arch/x86/x86_64/fred.rst
> new file mode 100644
> index 000000000000..a4ebb95f92c8
> --- /dev/null
> +++ b/Documentation/arch/x86/x86_64/fred.rst
> @@ -0,0 +1,98 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================================
> +Flexible Return and Event Delivery (FRED)
> +=========================================
> +
> +Overview
> +========
> +
> +The FRED architecture defines simple new transitions that change
> +privilege level (ring transitions). The FRED architecture was
> +designed with the following goals:
> +
> +1) Improve overall performance and response time by replacing event
> +   delivery through the interrupt descriptor table (IDT event
> +   delivery) and event return by the IRET instruction with lower
> +   latency transitions.
> +
> +2) Improve software robustness by ensuring that event delivery
> +   establishes the full supervisor context and that event return
> +   establishes the full user context.
> +
> +The new transitions defined by the FRED architecture are FRED event
> +delivery and, for returning from events, two FRED return instructions.
> +FRED event delivery can effect a transition from ring 3 to ring 0, but
> +it is used also to deliver events incident to ring 0. One FRED
> +instruction (ERETU) effects a return from ring 0 to ring 3, while the
> +other (ERETS) returns while remaining in ring 0. Collectively, FRED
> +event delivery and the FRED return instructions are FRED transitions.
> +
> +In addition to these transitions, the FRED architecture defines a new
> +instruction (LKGS) for managing the state of the GS segment register.
> +The LKGS instruction can be used by 64-bit operating systems that do
> +not use the new FRED transitions.
> +
> +Furthermore, the FRED architecture is easy to extend for future CPU
> +architectures.
> +
> +Software based event dispatching
> +================================
> +
> +FRED operates differently from IDT in terms of event handling. Instead
> +of directly dispatching an event to its handler based on the event
> +vector, FRED requires the software to dispatch an event to its handler
> +based on both the event's type and vector. Therefore, an event dispatch
> +framework must be implemented to facilitate the event-to-handler
> +dispatch process. The FRED event dispatch framework takes control
> +once an event is delivered, and employs a two-level dispatch.
> +
> +The first level dispatching is event type based, and the second level
> +dispatching is event vector based.
> +
> +Full supervisor/user context
> +============================
> +
> +FRED event delivery atomically save and restore full supervisor/user
> +context upon event delivery and return. Thus it avoids the problem of
> +transient states due to %cr2 and/or %dr6, and it is no longer needed
> +to handle all the ugly corner cases caused by half baked entry states.
> +
> +FRED allows explicit unblock of NMI with new event return instructions
> +ERETS/ERETU, avoiding the mess caused by IRET which unconditionally
> +unblocks NMI, e.g., when an exception happens during NMI handling.
> +
> +FRED always restores the full value of %rsp, thus ESPFIX is no longer
> +needed when FRED is enabled.
> +
> +LKGS
> +====
> +
> +LKGS behaves like the MOV to GS instruction except that it loads the
> +base address into the IA32_KERNEL_GS_BASE MSR instead of the GS
> +segment’s descriptor cache. With LKGS, it ends up with avoiding
> +mucking with kernel GS, i.e., an operating system can always operate
> +with its own GS base address.
> +
> +Because FRED event delivery from ring 3 swaps the value of the GS base
> +address and that of the IA32_KERNEL_GS_BASE MSR, and ERETU swaps the
> +value of the GS base address and that of the IA32_KERNEL_GS_BASE MSR,
> +plus the introduction of LKGS instruction, the SWAPGS instruction is
> +no longer needed when FRED is enabled, thus is disallowed (#UD).

nit: This will be more clear if rewritten: "Because FRED event delivery 
from ring 3 and ERETU both swap the value of the GS base, plus the..." .

The idea is to remove the duplicate statement that IA32_KERNEL_GS_BASE 
and the GS registers are swapped as it makes the sentence somewhat hard 
to read.


<snip>
