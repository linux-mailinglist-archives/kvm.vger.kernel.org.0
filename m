Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C427A7906
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbjITKUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 06:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjITKUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 06:20:10 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2048.outbound.protection.outlook.com [40.107.247.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C5AC;
        Wed, 20 Sep 2023 03:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5HQwT670UVX8mnI0ax+FZj9EsuY4esnkzbGJCLSr3sgHEbv+A0PtTLSObG5YKXPWqmENTjruN0bIPsmLSaZ7Xdgi4lD2Y0EvL7wf1ZFGOHk958e2ZNomWAC0aTkT3fwjCEJpB92qw3diCmSzea+Si8AwyhXJ3LFbgg9CAATA6UrImQajy33h/WZYLst+Z/K+58SNHKO4NdvvGvygugCOSF4ZSjd4bmMcsgJeVq8YSqHer8Q27SYBuYaLZihmlX9lzB8payeJ2SpJYwBGcYoyQJLRrjkc3arM3eksbvAYB8+G30T/7N+Lr39dwxTOBHdH6YkGJRk0hhPtvU5v2mdPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAINhEdYTcENyXk8OY5ai9zN5pJCicyvFXeYrjOYSPk=;
 b=Tk055o/G+0dcH5nVVPu9VlH1hxH7IhX5z7RJXT5M0BCw21Lw9/E3Hi41eI6rEfUGOZGGybO9QWdVrY0HKfa2us17bC4/kndQh24Xv6G/AZ2QdnUv4P7F5ijRCr6NSbc7xVcchYjzS3+Pi52ePlvQw5il0i7xBmDoNO9KQd63Hl3f5JwN+18eCHkGvV7OWbrHMRsuzO5RPVnTfx6dmdqVGeW8CVboANe2qZP7tGhl3U3ofPMZDNInd7q+OWy17yYMlSwrCoSSMerTK4LmrU3YLX+3pucK1sonCwvPp3qne8ycMKWXWDCGWW2GpJxlxoaMDZwEy/WsU/f8ErwbVkT6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAINhEdYTcENyXk8OY5ai9zN5pJCicyvFXeYrjOYSPk=;
 b=4dMO9RPLB8esifBXGX+b69aSKwYBMKuuu9SbliM2w+93wU3sv8Wh0ypn6QH1p5e2pLrGGsGlX5zBguqFOfjixxMG6DNB/LhVhz9ujtqLtoow8uZliP2SgPIs9SUAImRtiHdt7K82+QRBgNyEBhSQHbl2H18jtGyoffTOd49SNCHhFmIqnv51HMK4cpDXI0B9+zhDzbcsfZRYLPTq6Q5t+o5vKOsEZVOWieQtE7F9ovHr+BAEd2L2dO92Lb+6M3vdXY7OswSe9uFRZ2ER4YhpDzXBz91uKTRKFkmdaQV+MvypNYOVKX087sx6eZ6L7BRHgwbPnUpYBXMkFhQktqlnNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15)
 by DB9PR04MB9703.eurprd04.prod.outlook.com (2603:10a6:10:302::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 10:20:00 +0000
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31]) by DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 10:20:00 +0000
Message-ID: <aaed79d5-d683-d1bc-7ba1-b33c8d6db618@suse.com>
Date:   Wed, 20 Sep 2023 13:19:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 09/38] x86/fred: Disable FRED support if
 CONFIG_X86_FRED is disabled
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
 <20230914044805.301390-10-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20230914044805.301390-10-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::15) To DBBPR04MB7788.eurprd04.prod.outlook.com
 (2603:10a6:10:1e4::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB7788:EE_|DB9PR04MB9703:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e38e81a-8c4e-4991-7042-08dbb9c32549
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbyrK9C+nN2sIcAa9U8A4mG00Z/bAaHO+AuovHU6defTCjOQsINvYY6lphvwL0TupGeSiieGz/Jg3WyX2rp8veexmyXx4Tz8KgWFzTm0rYAbgWmwivrGvLMgn0jPuYS7q5IklfIhkYrUYtUleH8ejqAZNpj2k0gtYK7pmuP3Ds+3277tuBgv6anaALRNczHIlJU6kJY0NTVzCPxyGetMn5mMFIBoZIOTaFsGR8UySX7rg1LjpHw0zOa3YXs6MriIb/8fltt5zHFk97Xdz+eoVwlq7BkTMCDp+5LWWRRl70HmwyYqy/+9t5f3u8yQHN/uP17w2SLDjAooROBR8SwrdOtiOQV5HIVQyIRxW/zucBlLwAt9dhWIKRsmvT4Cq2E8AHusYguWNs6el1oMkHBRntcxelM0k1fnffndSLb2Aif1XQFTESChf3rGxkqPewgS3uA0I4ogsns/n3nkaoIlp9Uy5VQKwLidtK3538JzuupBYfFw3hvmJRd3ihWuAKRiOGMS8tylKQnUJAuwrQ1W9FWAeIdTwca7ouCh/r0q3Gi7WeFxxuIokus/XoikFSUpaxLk7/aJYPDv0CNfZonsPkqEZ+65qSM3KPaB97V2Xvzs1a9jv6pmMzE/vByQ9Ndh0KrqQhM/q1wG/56fXMTipg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7788.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(39860400002)(136003)(1800799009)(186009)(451199024)(26005)(2616005)(8676002)(8936002)(4326008)(7416002)(83380400001)(2906002)(31696002)(36756003)(86362001)(6506007)(6486002)(31686004)(5660300002)(6666004)(316002)(6512007)(478600001)(66946007)(66556008)(41300700001)(38100700002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGUzUzVlT09tVWt4cTltMXQ3cEZnME5OUmJqUFJnUXgzRlBBa3dGbmdMVDVV?=
 =?utf-8?B?ZFZhZWhLdU9ZWFlKQ2FiUFVnNXZhN2QyK2I3clBxN2dsWDV2clZ3aWRsKzEr?=
 =?utf-8?B?dzd6WUhlSC9ick1uSG9teFR2eGVwb0cxK1lNVTRVY1pTaDNQdzRjaDh4NkJl?=
 =?utf-8?B?VDF5d3BHank3dnFKUGtCQmgzVk5uTmhJR01MMHVDZ3pjNm9QczZqQU9TeHJn?=
 =?utf-8?B?K1owVitaaVU3bUNuYWwvdGlhZDFxell4UEtHVmtvejgyV3VTYlhUSk9kRkht?=
 =?utf-8?B?ejl1Q1FrYlVPeFlubTBDTFhzMHhqNi9EVjJVOWRNNnMwdzVIR0hFbU8vSExm?=
 =?utf-8?B?dWZ5U2V3WWhDRy9wZVU3Sk13T25XSTdjWVh1V3dZeThsbE5TRTJ3WFArUXdR?=
 =?utf-8?B?QVNXRlFFb3R3TDg0Z1ZXUlU4ZUgvU1QyQmdJS05BTEhlL1BPeUtEQWU5WDFP?=
 =?utf-8?B?QmVzb3VKSTJLcVlSSnVpWDNIZjBEZ0I5eVVGOHVPUjZXSGRseWo3TXhDMDN4?=
 =?utf-8?B?MElteE9mTFhoNkdrZmJSM3FVcm9pTzBnelFNaHhEbVF2cVFRZW5KK1pqQith?=
 =?utf-8?B?QU1wZ0dqdW9CQ2o3ZExaOGQzbGE2RHFpRFVRd21JOGhYTHBOTzRSd0QvYkZJ?=
 =?utf-8?B?MkZ0dEdpYmswd3BDSFc4ZVZ1bnE0SS9QanZZbTVORm9sSVVSQkE5empUdHpz?=
 =?utf-8?B?dlFVa0pyTlY1WUZZb01JblRoSDRhU09nMjZQUXNMZ3diK1NiRFovK2FKenhC?=
 =?utf-8?B?V2lyeklWUGUxampJdXNvZTFxRXBGVExJOEpRV3NQZWhseHZNZ0ZyTkMzNE5C?=
 =?utf-8?B?cVFRcXlSTGlPcitERWRENmF0bDY1WUZPeVFqQ3YxclVzZGVMUjVReTFiMThO?=
 =?utf-8?B?bGdqenJNZXNIV05RSC9IaWwrY01jVHpFTmp0bDJuYUl2NG1CakRUWVI1OEtX?=
 =?utf-8?B?T3N2UFFXY2lDUFU4NVNWODJVOEdlYUxOUDdRcXcra2lKd3IyTnVuUTRRRWIv?=
 =?utf-8?B?cTRvUjRoOHVMdkpPUkZzUGlDK2p1MlhDRFMwbldoaTAraE0zQklIcWhlQmp1?=
 =?utf-8?B?OWZjdUx6M0d0NmtDQmhhVlVjNUxmakcxbnl5UzBJUmJmM0tKVXZ4cGQ4bUQv?=
 =?utf-8?B?clJwZ0U0Z1dqN24vbFFLY2orZDFpMEtncENMdkMrdDZxa0lXYzc0Q1dzUkp0?=
 =?utf-8?B?STlCdlIwVUVUTG50TWU2UUJhRllVTENPWlQzNi8vVnNYTWNQeWdveHB6blpl?=
 =?utf-8?B?OUNWemkxbnpHd05JK3dnNUttSVJzazNGNUtjWjh2VGJWa2RjVENpV2xYTmFT?=
 =?utf-8?B?SU9FV3J5QlNGMDF6UnVWUTlyU2J1bkpRcWVLbFNVYzRhWXJsbmRpZGRpd2s0?=
 =?utf-8?B?U0Z2NExTSWFIclNoZzBtL1dud3dxQ2RGOTZ3NE8rc0Z6UGR1YmVrRjMyRHFT?=
 =?utf-8?B?Q29JNk5CdjR4K2kyUUZGZEt1eHJ3QTBDTXJzQ0FSSVArT0hLR24zYkg1cVR4?=
 =?utf-8?B?M3B5VWVJUmJCT2FCbVBEbWxXWk1pNUl6ZXY5blowYkg2ekpscVNIaFcrQkts?=
 =?utf-8?B?N1RYcXJ3T2dEZ0ZLYnhHN2FZODI0V05idjdvL1NxTFZPN1RoQnhPSDJidy94?=
 =?utf-8?B?ZTdwYnVEajIwd0dFRzdjNjZMYUNBbzRhSnJNU1BCNmVZZjdkc3ZFanZnMUZU?=
 =?utf-8?B?RmoxOWtIYks5anJVdlRQQkh1N0kxTnRUTk9Vd0IxTkJXaTk4MGVuM2xuQ3NB?=
 =?utf-8?B?T1hLcm9oMnNQWlN6RVlYQ3lUNnFqQVlreVVzNGlrNVJ2TzhFd2k2cEYvVlJQ?=
 =?utf-8?B?QXg2d2REWGRjcUpRMzNDc3RVUVMvNExPbHBpTXA1SHRsbnByZW02ajQ5azNG?=
 =?utf-8?B?TUNTaC80L3E3cjZQUW10dlI2Ni9pbDNyUmJYZVhmYzdsNmlsSkN0em5rV1BS?=
 =?utf-8?B?Q2xPTDdGQ1pPZXdpNmhkb3lwTUdDTWtwVDhIT1BUSXV4Yjh3L3FmWXBlUXpU?=
 =?utf-8?B?YWJIMDdVM2ZKbFlab3YwUzZWU3Q2VXlEa3FiMlNNN1FFeTgwNVlpM3I3Tmw5?=
 =?utf-8?B?Zit2VWhlTWU5MWlHRkdRRjIybHNJY2p4NUFNM3JuU3hZeVFaRnpWZVJ6aTRL?=
 =?utf-8?Q?gkjQgbXLoUdX8YFCFNLsh28bJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e38e81a-8c4e-4991-7042-08dbb9c32549
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7788.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 10:20:00.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw/P3fDnlhKg24u3Qd13vdZu029a/Zv4oqik/MLVWTKMPaHSo3OcXBRu7GKof8FbiJ6sBXov8DVqEYMP+/5FNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9703
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
> Add CONFIG_X86_FRED to <asm/disabled-features.h> to make
> cpu_feature_enabled() work correctly with FRED.
> 
> Originally-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>   arch/x86/include/asm/disabled-features.h       | 8 +++++++-
>   tools/arch/x86/include/asm/disabled-features.h | 8 +++++++-
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 702d93fdd10e..3cde57cb5093 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -117,6 +117,12 @@
>   #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
>   #endif
>   
> +#ifdef CONFIG_X86_FRED
> +# define DISABLE_FRED	0
> +#else
> +# define DISABLE_FRED	(1 << (X86_FEATURE_FRED & 31))
> +#endif
> +
>   /*
>    * Make sure to add features to the correct mask
>    */
> @@ -134,7 +140,7 @@
>   #define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET| \
>   			 DISABLE_CALL_DEPTH_TRACKING|DISABLE_USER_SHSTK)
>   #define DISABLED_MASK12	(DISABLE_LAM)
> -#define DISABLED_MASK13	0
> +#define DISABLED_MASK13	(DISABLE_FRED)
>   #define DISABLED_MASK14	0
>   #define DISABLED_MASK15	0
>   #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
> diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
> index fafe9be7a6f4..d540ecdd8812 100644
> --- a/tools/arch/x86/include/asm/disabled-features.h
> +++ b/tools/arch/x86/include/asm/disabled-features.h
> @@ -105,6 +105,12 @@
>   # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
>   #endif
>   
> +#ifdef CONFIG_X86_FRED
> +# define DISABLE_FRED	0
> +#else
> +# define DISABLE_FRED	(1 << (X86_FEATURE_FRED & 31))
> +#endif
> +
>   /*
>    * Make sure to add features to the correct mask
>    */
> @@ -122,7 +128,7 @@
>   #define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET| \
>   			 DISABLE_CALL_DEPTH_TRACKING)
>   #define DISABLED_MASK12	(DISABLE_LAM)
> -#define DISABLED_MASK13	0
> +#define DISABLED_MASK13	(DISABLE_FRED)

FRED feature is defined in cpuid word 12, not 13

>   #define DISABLED_MASK14	0
>   #define DISABLED_MASK15	0
>   #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
