Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345807D83CA
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbjJZNpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 09:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjJZNpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 09:45:11 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2065.outbound.protection.outlook.com [40.107.20.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC131B8;
        Thu, 26 Oct 2023 06:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERN/pDpSWU2LIAFTPXGU+XrnjGlLsMYjDPAo/2IFfLtAqs4uvuEr4gvdbU0hESY4/KuxMIfF+iSgLjCdXV0pjCSFhaHm8qR8PpyOjtiG5nZci9a76gYSxqIC/bI/LvP4ev6TqDJS6mdnYzpb93iXlhOqJgNo/OPCi9tn/Vh4Wq6RtVH7YIy07mgaz1aGcAxtJKN7AFMBBk5jVyYfBhR7RIfBXK+R01RK25wGErwqGs55JLm5KpJS7Z/xmmkGnMLLHCQoKMsCnvzmExhWrGLuGm5KcvDCIiHZymvQC5TDS1nQW5Ep5xWnE0GJPKMiR6EFRy8FAyKMMScGN5Mx73DVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrWAB56p1RNkWF1XsDNdX90lqFX72DD9ZJK93DaEbuM=;
 b=lX+EWnvSFdb1lOCkeAXKP2OGoYBkkdrm13Pqo9P9PQgFeTfs5r5oV+2INcZJZ0yL6iDh2ioVH0F7wOihhZ+15mumChu2evZZKH3ZOoLjvGn5un6ZcMqqRvr3dPBxRi+mq7mlCP/l+C6vcXGyY9wpHY/Gm6ZYiSF9Bp5yjJJPc/5CzCSR77fkmr14wx27sUgXBmxEZVfMSxfLrY4OiWrQfVbISslhGtK8Q1DAa2nv+fVoqYJKq0GIUDwrjqnitN9Y8W6GS9V0OZ2qGWqUCoPHHqrcLAi9ILCDlf9HjXtGWLwBTaBOlyiAj8B21ChBuinE1UlsalDxow1SNrkFOXOMVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrWAB56p1RNkWF1XsDNdX90lqFX72DD9ZJK93DaEbuM=;
 b=5A89hLFHr8egXDhuu6IRpJBXFnBC0SnbLDoJUATxBtFLrKBJjywbu+oIm1BsZqbMZOGhRrY3/OyTr9FrkCe5NbHMF9cLbDSdBmslv/PaZu3nPliujqTEMdsln3uPgcX3JAb6Fy4Xfjpb3Ps3Mz3xie0mIFYXVR9libcmRj5yJv2mSsT6lKvvOb1d2WsGf090vmdPS9Q5i+nDoQ/aOCqwJb01LmAlJYbS4QgE46O7q5yKPkcq2ayu+rXi8Bj4xzBpPYNMIrISOiN6c8twEusBBhsUdD0iBe/SAdhpytjcVIGLrkjpdKlgeA9RZFxE6fMxMQ2b7sfiaNp5HwuC5NlfZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by VI1PR04MB7022.eurprd04.prod.outlook.com (2603:10a6:800:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.16; Thu, 26 Oct
 2023 13:45:04 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 13:45:03 +0000
Message-ID: <1f756579-8f33-40ca-ae50-4db78c615f60@suse.com>
Date:   Thu, 26 Oct 2023 16:44:58 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] x86/bugs: Add asm helpers for executing VERW
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
        Alyssa Milburn <alyssa.milburn@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-1-52663677ee35@linux.intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231025-delay-verw-v3-1-52663677ee35@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0030.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::43) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|VI1PR04MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f91803-852f-42ae-6ed8-08dbd629c1b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Whdi/DoDhKqGviHIQCkd47EWcCJMIbgHkvELiDMAjWk0sHKqgDchcH25oExE4+mX9DZcMV4EZY4Ss8SiVetlPeewH66EbqnYU2PrP9NDMggyqdMU9uq+aU+1LhFXjC8CbKNNvKMy07k+OuSWCDpx1xQFj2mylCZ9apwFXYUK7fJfzPZSdEsjb41yDAUmNad/FoTouJ2u3OhsSXF6AaBkjzic46AxsHnHlUd+CH86RXG04ruKl3mWw6b3gmY3KcGngC/JjI8NoramxrGUCBuWT0SV2xlKs3DcZ09aCbHsG/KV+bhVxbvM2Olbg7YTiLVXfhY2SpwM7BzWrKNqZUXFWRhRGAjcm86gj7LthuFpprmpW9GQjjQ+OCv5QxTzRY5ncBbVLpXqO9r4FfPG8j5BXm6t4lZW2gF774gfOWqzyZO59tEgtHeYNrDKBz/fIfFjQnvV78NAJp5nm8+IzwQSQDLPgZQ8Is22q5z/9S9DQQNY/4txfjPWEFGpMu4iYxvIs2i6O5lvopjkS8FkauAphk64QGa4RMnUfWBkI0/POEB1LUM9GW7bXgLy4UUVfyhIuCsplrxghFiW33hI9b1Fy9p52w+ttplMCDtSTHBekA+DxqDqGkeVz2pDf0mYVR/aX/zFp9OomKfsdnnZoQAwRdt5DkvGWmlcnRpCMbY0PdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(83380400001)(38100700002)(36756003)(31696002)(86362001)(316002)(8676002)(4326008)(8936002)(7416002)(66946007)(66556008)(66476007)(54906003)(110136005)(921008)(2906002)(5660300002)(41300700001)(31686004)(6666004)(2616005)(6506007)(6512007)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWFxMnJSejVXSks4UXVNb051OTNaTHBtSXN4SHV1Zm1DZjhpcllNc3dRUjFj?=
 =?utf-8?B?Y1RUWW00ZFJOUy9xdUhwelp4Y1RZTUhmTzB0RnRIbG95V1ZOMUI2VUg4bkQ4?=
 =?utf-8?B?anVlaFQ5aVROQVIvdFB1OUpEdjBBaWFIWjE5aGc0SDYrTHhhbk1wTEZyMFJy?=
 =?utf-8?B?RjF4MEJtWXdTQ2RiL3NqNVFKMENJejJnYjk1Zm9CaVhQTzlNdStHRWxuYlhM?=
 =?utf-8?B?WGd4UFYvTjdJaXZRZ2UxOXBkR3oydmROdk80Rk5ZdkYwWXl3cXJ1Q3FBUHlw?=
 =?utf-8?B?ZGdXcW0yY2EwUkpFdEROQzEydnIxaXJsQlZ3K0JYd3FwU0x0RE10MmZqcU1r?=
 =?utf-8?B?NWx3YnlXT1d1OFdHS3hzN3V3VmN3d3QxUURWSGM2dWE1MEhWTlJ5c2Q0dml2?=
 =?utf-8?B?d2tMMkhYYUY2WUVwaHhkSjVXdDhjQWpaaVdXb0JHOVo4bXZSQndPVXB5c2sx?=
 =?utf-8?B?V0tXMmQyYlBxMTFYRGZqaGVYazkxa3Vyakt0cmZTZnRYR1Rxa3lLbXF3Y2Zy?=
 =?utf-8?B?V21iVnU3TVhoMVJURisrd1cyZTdkRWZWeEx5Q1BwNldRVk9xMHlXRTRnQ3Fr?=
 =?utf-8?B?amo2T2o5NFN5ZHVxZWR1eHRTK2FLK0FmcTVVU1Q3alVWT2FDYmZsYUNnQXNV?=
 =?utf-8?B?a3JGdlhDa3pmY0FvZW1talN0bWVoeXJCRlZKSVVQbVdSMUdlci9mTVlkL2pV?=
 =?utf-8?B?STBFeTdBSFB4SU5zcHlxNGNBR0Jwb251bnQ5a2h2dm5iVlFlZTJwekFWdEpS?=
 =?utf-8?B?Q01TelMwMytjWlhnWG1maWtJWDBxUlE4ZFp5Z2xEbUt0WnJHdGRPUFliT2kr?=
 =?utf-8?B?dFhKaHVLRVN2MTJOMG92MktqYjkrQ2h0UzlNVFV0NGs3VXNFTjdoYUhTMHMr?=
 =?utf-8?B?dkgrbnV0MzZLRnNIcWw3TlQ0VDg4KzljZWIwdGd5S3gxeVRFMSsyV2JEQ3dv?=
 =?utf-8?B?d3dRQzArb2hXcXZkUEIrRDFVc2xvNkdmSzJLanlRRy9KWDdrcXoya2V5ZjQ4?=
 =?utf-8?B?Q0IwU3ozY0RLbU1nRFc0L29QYnZFSUtGaXJtWGdzUVZnOERJWUlXREhrUUNj?=
 =?utf-8?B?bmVXMmg3ck5WWGhlZ25jWVFlSSticldMRHh1eFExdHBreXlMNWFnSmpZdU9Q?=
 =?utf-8?B?TGJZYnZCVHBVbFZ6Smp5MUlKQjJwZEpoWmNoQ0wyaE50cVJNemtiTjJTc010?=
 =?utf-8?B?OGl0WUFjUVpwSlVSOWc5aGJ6by8yQ1lZMWhTb3c5bE5tOUp0QTVCNmljVGUz?=
 =?utf-8?B?Z1prTnQ5dmNWMEp2NHdsRzFzamlRQnVYMldENG8vUFZrdUJ5bTVDUXZSc1F6?=
 =?utf-8?B?b1BzaW1DT3A3SG9ib2ZhMGYzVS8zYlJwL29VNjlXWXVJdFZVcS9nbkFmNVp1?=
 =?utf-8?B?eCtDckVvZzl3blI4UWtBcUpEbHQ4ODFvOHp0SHpaU0hCcUxURGlRV0FaMFR5?=
 =?utf-8?B?VHl3VjRoZWdpYWszU1FGQlQ2QnZNQ2hRdkR2a2toeWx2NkZNNjdmQWFMTnFN?=
 =?utf-8?B?Wllua2VHMXBZQWJzdkVNRjJRRDZwNWtQenFOaVZLUzNGQkI0VTFlRHRkN3JN?=
 =?utf-8?B?UnZDTy9ITDVZSTB4dnB3Rk1yQko1aDAvQ0JzamJld1hldWxISGVYN2dxanpP?=
 =?utf-8?B?Q0xKSUlIcEVGRWdQV1NLZDB1MEtNVEdBT3ZKaDlpUGFUTHExVElnQkhkUjUv?=
 =?utf-8?B?TnlWRHhra2VwWTVvVHp4bVFuNTZvKzBrL0toalFxazR4aXpZNm9OUTY2emdv?=
 =?utf-8?B?blNxYVRUcHRYczJTQitEWm5BV2FkN3FqWjJDLzFkdXhHcTM2Ymp2dFhTb2hO?=
 =?utf-8?B?UUlQbHBCOTkwcldRRUIxaWtMdW4reWdWNVNFbjJIanJYZVV0bCtpNkhqb2dS?=
 =?utf-8?B?akxoOERDQkxlQ1U4a0dUUzRyMHNwUHJIcjRoS01iZ25WUlpQNUl5aHh6cUh5?=
 =?utf-8?B?NnhqdVI1T0pWUGU4L3VpT0FMWlJmdW9nVzV5a0NxZDJLWVloRFF5cXZpL0x2?=
 =?utf-8?B?UmNJQVZjT2FYdnV6dklrNzFqUUQrSlRnbmFqeFA1emQ3TStIS21DUlRTblRX?=
 =?utf-8?B?aXJ2T1A5d2duY3BiTzBjS01HU050UkNxTTBqSkd6eHE3VE9hL3ZKQVdsWGpV?=
 =?utf-8?B?NDAzaWgyK2p3bE1TU1RlWEl4blFPaHJyNTRmUUpMbC9FTVBEZHYxeFY4ZDh1?=
 =?utf-8?Q?VfIw8QkV5Vv12GsdD0jmJW8BTjeteHcrG40Jt2bZyuRd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f91803-852f-42ae-6ed8-08dbd629c1b0
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 13:45:03.5909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwSQj39Td4OdYzXmuyUXwyEBeszWPKp/+tQHF1eoCjR+xnL3XmkhqdBLaHMzua0PURf1NTngIS5/uj8yp8rY0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



<snip>
> +
> +.pushsection .entry.text, "ax"
> +
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> +	UNWIND_HINT_UNDEFINED
> +	ANNOTATE_NOENDBR
> +	.word __KERNEL_DS
> +SYM_CODE_END(mds_verw_sel);
> +/* For KVM */
> +EXPORT_SYMBOL_GPL(mds_verw_sel);
> +
> +.popsection

<snip>

> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index c55cc243592e..005e69f93115 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -329,6 +329,21 @@
>   #endif
>   .endm
>   
> +/*
> + * Macros to execute VERW instruction that mitigate transient data sampling
> + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> + * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
> + *
> + * Note: Only the memory operand variant of VERW clears the CPU buffers.
> + */
> +.macro EXEC_VERW
> +	verw _ASM_RIP(mds_verw_sel)
> +.endm
> +
> +.macro CLEAR_CPU_BUFFERS
> +	ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
> +.endm


What happened with the first 5 bytes of a 7 byte nop being complemented 
by __KERNEL_DS in order to handle VERW being executed after user 
registers are restored and having its memory operand ?

> +
>   #else /* __ASSEMBLY__ */
>   
>   #define ANNOTATE_RETPOLINE_SAFE					\
> 
