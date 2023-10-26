Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55DD7D86AA
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjJZQZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjJZQZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 12:25:35 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2065.outbound.protection.outlook.com [40.107.249.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B7718A;
        Thu, 26 Oct 2023 09:25:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8L0cJcXRqUfx0BycvWeuE8Z6j7j/hxZ2+ait8e4SRj2wfoX2n4FeAKRcIPeBQsmm2jkR/i8P6kKsiQKqus3Iw714vOpZbrPvn6M6qKqu0Fdij4pksCHyRX7/aQNf18wcIuU9VbpEyX9gXiFKzwhvgJg2R1V+xQI96EAR8fivFJM6HwEK93LNrPs5d3S2gwlEUWBplsROC4GPXXxs+Q1QH66vb6OnkdxY2/BtVCy4XdKa+HpILVPAuaWMo36il+S5MLY3MQEzWS3qNfEwVp8WO1/rMVaWhVCg0FFm2zDKg523vqAL34yQThltnjk+05g69GcEcuxufMWYeRXs/PJYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXauDMJ+7h+cHYKMv+JnkAIQ3SQ2CkUMp8oXsxhIWV8=;
 b=kChiN0MIg9S+Y+whYDPaBUEa2/uKGnRB0rQKpXKxaGPOerrgUsmhRBLpcHant4A4YVi9Qudv1R3P4h7zv7/ajKiJYQC+UgLvVPOPJBhuMkqm2BjRf76gIsIv8ZwZ1lTyRxoEuKOMpC1MTBV6uskQPdnCZ+Lqs1g+AOvoTga3IiXDhgThGbfxEpWjvYnx0Zd/uJBsn0xP3nh2KMVD/biKer/+MZzzRnFd83LCAGlzzWv0BUV/QtMxKfbTW1IlJT6y5803g79zRbx3jftbwIoS9P1G7HHM7f2g7lFsQB6+1HkEouGDiwCDekoQou8O0aZkeMCXjp775t9+KJOqBkjEbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXauDMJ+7h+cHYKMv+JnkAIQ3SQ2CkUMp8oXsxhIWV8=;
 b=fx79ALw+V15fD0IYBbDxIJuFIwys1g8sd5guG++GHbObpXBQJ27MXN8Wt7uCLA8lzzLTmjBIhDJw10KosjIpw/FWzGrGC7mhA0pBMYeauQ2N2x6KFgmzJMb4TON8HnXLHYPQTuETjnCNHLKDaid11F/FShdLHl3fzMGsctF+ZgEj+dTG/tu+bjN3KXXS3GRtRSpzZ1En30nx0UBGyEFdxVtbHogfYoHD0MPDL8qEd5/wgIuO1zwwyPLdClW4+qBNCtR17eqP+qJY4/FUWKXaCw05dH07SZDt/lmUhRP5IowGM7LuI1Qv/JGXiB4Lda5Xf2JtCH4a3onxSjaZg3QzRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB8428.eurprd04.prod.outlook.com (2603:10a6:102:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.18; Thu, 26 Oct
 2023 16:25:30 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 16:25:30 +0000
Message-ID: <2cda7e85-aa75-4257-864d-0092b3339e0e@suse.com>
Date:   Thu, 26 Oct 2023 19:25:27 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] x86/entry_64: Add VERW just before userspace
 transition
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Dave Hansen <dave.hansen@intel.com>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-2-52663677ee35@linux.intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231025-delay-verw-v3-2-52663677ee35@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 0af81134-f537-476d-bf09-08dbd6402bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BE3dV/iRIi28TR89HhR0K6zPMYpjZ/+VS088oryVCc9JIkz2pU3gP8nEbpUVkPNpHfJqeSRxnh/768uSrrwCqwi9Nz5ODm70DFgreAVRIs9cEX0w3PjRIITa8H5ds8VDznr+gzboss+1YD6ZCUrRqGERmtWF1GbDn+CSsXvJQqinj7pojvY2NwuNOaQeW+cRDfHFiEQVYez+XeG97Pi91fsRRoEnmNKETU0RgGrY96vR1Y3CqoKtlvZuFu2tk/CraxmFrosQxKy0QhH9NtaGAq0SCZBQ89Jsusn/gjaOJTdNU2ZdCQMtulwXQ8aEAA5g1fM9vbaDQFdpuGlDmwmEtmRLWNNTT/zY+xnS2KMCXliaNcLFn6eIcVdJeghyngWAtqCxzRcn89/5YxMqjQbXhCSyArylqzrQyi5388oHuH0WXfpfUtAVgfM53ZIs4+0FLRaXwIlVa3N6SNQHCfKa8qY4ouP6Cqy6hu4LUCJLRvv+FkB5AVqpUMFfmhMf7uO0qG54n71FYX/0QmjYQHLkPT+Kr0IElrPXRjo8sO5gxRtPIjeHQb4t7rTBUQolcyzBC/s3adaX+DRC2se5c7B4zAmrulR5HY0W4fOZqoqcmMgJOvV7pyjDe6TY7tgZx1HHWsiU6oR72cPZt3aOdN7Tos1TStnsboPhIRU5m/1f1/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(366004)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(110136005)(478600001)(6512007)(316002)(6506007)(86362001)(66946007)(38100700002)(66556008)(66476007)(54906003)(36756003)(6666004)(921008)(2616005)(7416002)(6486002)(4744005)(2906002)(4326008)(8676002)(8936002)(31686004)(5660300002)(41300700001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmk0YUFnZGl1Q29zMFR1KzVrUWtuQlBpUE52cGZyL3Q2YStjM0lXak1zdnM2?=
 =?utf-8?B?WkxHZmpkWFNqNFczZFZudWtPWUFPSXZXb3lWY2JzbElIb2hsVGxmcXFubE14?=
 =?utf-8?B?S1B4VDA2T1J1K2QrMlZzVWdLRi9zUW9xNEVpbDlsOGxTNWtiRkxDVENGbzBu?=
 =?utf-8?B?aG9acEgxS2F5b3NUMUtKTTlKWW02dG5FcThXTGY3QTZEcEFydkFScU0yUE1u?=
 =?utf-8?B?QzJORGNUZEpSd0tQVDA4WmhmOXlERDZGQkdqR2tZeEdhY29kN2psdjJDbnov?=
 =?utf-8?B?dlptYVRWY01OMkZQWTdZdGdaNmhSbGY5UGVHZWgvRXlIWjl4dUxkK2ptN2hE?=
 =?utf-8?B?YmI1Z2syN0xmOEN1NFBQcEdwUUtkRkJkQy8vR2NoRDJhUG0zVHlFOUVLQTBM?=
 =?utf-8?B?WHI1bHdLUDVRTkZiVGhHWTd4MlpxcytReHdpNTR4VFROSG10cFpFMjhEb1hq?=
 =?utf-8?B?bk5ld3FmQkZLVW1kTG1rR0RBOWs2OXhaKzg4b2tWcGlCZnpFcHhVK05VVURj?=
 =?utf-8?B?aDRBb1JkOHJaRHd1cWVwSjJrTTdQb1BIZlp4VmM2UTU4OTRXWkg2d0JiZGJF?=
 =?utf-8?B?MEdxT0M2V21DTjZmU3RDVHhGVFV6WTFvQk5tckdoTnVMaXR4YjBad1JnYXhE?=
 =?utf-8?B?ZU9FQm5hdWtHa3FIVnJid1N3YnhLSjlrUUpySUozT1c4TTBEVWxpdm0xdTdM?=
 =?utf-8?B?NHc1WGpoQjJtcWxIRHo1QTJTNnczekdoYWZhK3BiWG1adW5ZTnlMRXdydFNR?=
 =?utf-8?B?VWpwdTVVelVyOEVFc0lDakFueWFBbDVsQk51Q3p6YWpYeWNkdnhWMGw3WjdW?=
 =?utf-8?B?TGRsZzB0THl4ZHU0c3h2eHh6SjZMeVdRS3JZSkZzK3ZjYkxzN3ExWUZXYkdq?=
 =?utf-8?B?bTQrOVFNZk04Qnl3WWpWSCtHVWlVRm5JcXVOMi9ocWtrZ0JhWnQ1ZnEzRDZ3?=
 =?utf-8?B?dGxMWVQrUXQ0bFppdTdjb1htS1JhMnByRGFQL2NrNkI0UlF1TkpzZ1ZaenpQ?=
 =?utf-8?B?Z3FsNGRXRmRXNm1TUVd3NzlUbUVMUU5SRWJKNmZ6S2l3Zk5RQjNrcEZWN1JR?=
 =?utf-8?B?NkpEcUhxeTh4cVdaUWMzaTA3bmNSYzM2NHAvbDVUN21weUVqVytjaDhYdE5s?=
 =?utf-8?B?bmN6MThlUTRuMmE0cG9tdFVwOGhWenVvNnJhM2lwY0gwaHhsYjhNaGxtQnhs?=
 =?utf-8?B?TWZxK0cxQThCWmlveWxWaGZ5U0Zrc095RTJ6Nlplb3RJb0t3cURUL0wwd1h0?=
 =?utf-8?B?clNuRE83d2x5Y0ZsR2JjSk1JZzZzTm9ncFp1RzBpTElsU1VpNVJjOXY0MVZz?=
 =?utf-8?B?RVV0a0greWVrTEpaUzhJSFRyMFo2T0FEeTd3Znozd0k2OHJHUVRDNHF3bXo0?=
 =?utf-8?B?SzQ0dU9QOVhIYTlJdDhOWXI5RXo4S0djUWFjakNBdHZEYnRmNjFETDdQSEp3?=
 =?utf-8?B?SUVjVm9hb0pKT3ZJV0pMQnIvcFFnaFV4MkRNNStUVjdMMFcxelAva0czSGRn?=
 =?utf-8?B?RWdKSG5vT2Z1Qkg1dWdId1dReFFGSjN6YURYRmlTN29SaU43SGxzSjJGOFlv?=
 =?utf-8?B?YzVsdk9Zd2JvYjJSVkxiM2txK0VpR3FDNElkcThMcFcyUGtiQTdLaGJZV3g0?=
 =?utf-8?B?YUt3VzgxdTB2TGQ1ekYxV0FLQkZ1SWk0TTlBZXdGNzVMSkh2a0NLaWpWYTN5?=
 =?utf-8?B?S0JKeWR1dzB1b21rOEFXbG5Gbjl0dmFPY2NrbmEzbFhuNHVZaXpraWc1Qy9s?=
 =?utf-8?B?UkpiZ3VnejFrMFJwbWFnUDBqckxrM0o3N2ZoMEpDQTFwTUhpWmxmQWFhbjJh?=
 =?utf-8?B?NEpBQ21walRCaEhIZ044RFdPYWNFQWNXNDVWVWVKRzRPdlhnUEJTdXh1MW81?=
 =?utf-8?B?ZlRQdUNCK0hXU3RqbjFqUzlUREtvMFEvTXVGWWJ0UWUxQ0ltM1B5b2JmSktK?=
 =?utf-8?B?Y1ZMVmNtWHY0Z28zd1F1QnI0S1BjWmVBU0t0TWdOVWRwS3VQSm1lSnBRYjZS?=
 =?utf-8?B?YnNvWk9BZkxRbDN1TWhFemV1VGxSNzlmT3FNdS9NdW9YbFRGVVZ3NmZlbkJh?=
 =?utf-8?B?QTFEY2Y2RksvbGZPS0xjQ0xvQlptZnF6WFhiL05ZSzZ2MGJ2NXlZNEtQUDc3?=
 =?utf-8?B?aW1JRDlPUkNrLzFYcGpYMWxTeFpNejA2S0dFeXU1NWZ4SjVRdkEyTENLMDcv?=
 =?utf-8?Q?soX7HJZium7n6paSZ300F3msCV6YN1f+WldmI2TdZKtw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af81134-f537-476d-bf09-08dbd6402bdd
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 16:25:30.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XszEUjJtAX5M3bFE29PxRCUOj03IIX50CElScxNktyhTrVa37wK6HaQ7LY/m7f2A+jW3cSK9SM83rjfhBNHCkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8428
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.10.23 г. 23:52 ч., Pawan Gupta wrote:

<snip>

> @@ -1520,6 +1530,7 @@ SYM_CODE_START(ignore_sysret)
>   	UNWIND_HINT_END_OF_STACK
>   	ENDBR
>   	mov	$-ENOSYS, %eax
> +	CLEAR_CPU_BUFFERS

nit: Just out of curiosity is it really needed in this case or it's 
doesn for the sake of uniformity so that all ring3 transitions are 
indeed covered??

>   	sysretl
>   SYM_CODE_END(ignore_sysret)
>   #endif
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index 70150298f8bd..245697eb8485 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -271,6 +271,7 @@ SYM_INNER_LABEL(entry_SYSRETL_compat_unsafe_stack, SYM_L_GLOBAL)
>   	xorl	%r9d, %r9d
>   	xorl	%r10d, %r10d
>   	swapgs
> +	CLEAR_CPU_BUFFERS
>   	sysretl
>   SYM_INNER_LABEL(entry_SYSRETL_compat_end, SYM_L_GLOBAL)
>   	ANNOTATE_NOENDBR
> 
