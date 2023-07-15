Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2DB75481E
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjGOKF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 06:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjGOKF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 06:05:57 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2059.outbound.protection.outlook.com [40.107.15.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E875535BB;
        Sat, 15 Jul 2023 03:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBcD45oN5Xamx65FvTu8d1tY2hklDKtw4V6xHQ2ZpxHWhJvY6B4pxU4wo/mivVfDcTmpci5p5Td5wQ8l7BECFr0gmqntLL+KWHro6xPHFKekih3Fxe0TfbHYoTFvGHD1Vy+45ClbzNBFEp0bEcoe2QFrZ0mv6UGeI8IXbcC6+Lu58bxvRn2e274AKy91PSB40X6bxkNMitJifKrzZKM7tyLTYXVTythrCyS9vavKZM8MzdppsMx/8/I57A2jAe6qGLQFPYcxQaPl5HwVGAjZi5+0Gl9vPLARklhimaMhhNPML+RRmeI/RMwiR2/UWRWOQ+gCs6q7XMinibb77vGwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMQELH2IBpvPF+Gl+IwE63Rcm/inD1InxClaHByNRMM=;
 b=KlUuzXU6YliqdOlaSP/Ml36lQmNqw19Cts11oIlrGFvwlHbV5eMH7SeSanWouvXMxAN59YFtf2TBNcTN16iksLMz1ni05tzrPKso9pnV5cT8S6KeGOl3EQ82aY+nB1gDvp/Qhbqh4Ke6G2a1LocQnSPNiRQx8qY2zLiTTxhjRKeEwrc2avTBij19+40p6VoOpYtOzsxr7twGKaEPQM+NZWD9pzEMmSuPNTf7nb/AC4nMcWct05lY016+BwYX5GD52orteAQw8ax6aUAzrz/yJGKMIZlmC4bpYWRMYgZnXrFCf9t8s7BQOemW8MkXcf3ouzQVZ0RSliFVHMjCh9591A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMQELH2IBpvPF+Gl+IwE63Rcm/inD1InxClaHByNRMM=;
 b=ADAaPy66KRbLlVpO6H8XNfi10Na+gAwn27RQpL1abvkOxWGoibFizJU2u94iMpEpIafFLQ3Kjhgd9tC0iypS9BjNvU/735OsC16h5+JOpXf/QYsW4ZtyhtjbxExFuo9MSZyDIzDxgUii3PN8POf27W6GLNngCe9rIy44AbjmGaXcZxbsQo+J9eXT5jk4XKb8O9uP7kgE6/fT9DUrYCPtyn41IkYUrYCfbs8aKfwPQpGkWS1jm/A2VCCrqwnT56rR/HZ2fWfhwqUvnF7rrJEqY2xhMrydclcJVr/JqTTux1olpD4rgohUz01frGQ5gprStcm+Y34AQznJ+dXPnbCkCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DB9PR04MB9818.eurprd04.prod.outlook.com (2603:10a6:10:4ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Sat, 15 Jul
 2023 10:05:51 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 10:05:51 +0000
Message-ID: <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
Date:   Sat, 15 Jul 2023 13:05:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
In-Reply-To: <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR06CA0163.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::20) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DB9PR04MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c675ef-6a21-4052-dc31-08db851b11db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgJLUDwD4ecockFuAkvJgtfShDAMDqOgi+OCb1hu1if8ykvKxHmOM+jCkAxWAoq6+HA+OCigDT9Zo9LOmb5vFm15Ua6PUEEf2Dho71KB+vKpGo5lvhf9HCSkJPdj1dtkx3XpVVD59EINzNWFcAQSdhL95uhjZJ1s+KfpNHP9NL57fRi8GO4dMrU3L7FS3MLAJKkO3VkYwCsJQJZUqoNTvPN8l0rb9vLqEsp1qptyV0+a4wdreLrtaqtwYOYLbfYNn+k9ySurzoYg4hLWQ58sKcQTbuNK/PVbQgl9nZFBGHpBcHZxsPnQ7dYfam8cRN+HlwwIuw5sj3K4niUOmdbSr27iHzq8fWnhXrQrxf2sc/x9mKXZZVCG61OvnMehBpz+IIZrgN1oDyde3nR5no8fwFFW0UGQIFOzpkzqijWXX/jEPVDr6KKSXUkMdqUgM6dxp6D8YNnbgv7+u5yKOuiaQMCj0JLi2fMAXOmcffhrwLkZ18ku7UcDR/7wqNP/jWLBaLxcC4J4TgTSv+Ncr1INLvntuQsmBka5bIysSMNys50gNjGAEjO6iASffwTPGRJmiw/6TaPwXoxI9XSUqz4RX6epuYe8sQHUOLz6+H3LUiVTcaiK3IjUF97CnqiyHroinbFrGjrUc4HBE9tDWrN+9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(31686004)(66899021)(6506007)(38100700002)(478600001)(31696002)(7416002)(5660300002)(8676002)(4326008)(66946007)(66556008)(66476007)(8936002)(6512007)(316002)(86362001)(41300700001)(6486002)(6666004)(2616005)(186003)(36756003)(2906002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d09ZTFlGYjBKcWhkU3czVU1ZMFR3ck5wRDU3Q2RtTnR6eUVlOW92bDl2WFFx?=
 =?utf-8?B?R3RtVzZ0Ukl6SmlrbE9HWnVmdUQ2MkZPdmJuWTBkOWkvL3orREZ0b2xGek8y?=
 =?utf-8?B?ZWRDZVE0NEtxL2F4N3FNM0xpWXo3TUtsVUVXbzQ3UVBpMWJJdDlsVE5hZVF5?=
 =?utf-8?B?cmpoNXQ3bGlZTWlCbU5xN0sxTjBkYmtQZmppZ2tKcXNxZzltV0JWdllPVGJH?=
 =?utf-8?B?VTdiM2h3bG9JTndlSTkwb3h0Z09uSm1UdXNnSFNMVnJWRXVaZGJXM1dlS0J1?=
 =?utf-8?B?SnY5RHZJSWJGUmpQRGxLclJaaVozd1FMeFNaM0Q4ajlMaEVrSXgwdWltdkVl?=
 =?utf-8?B?eE5ibmlUdmx4SGl5SEpqTHRJc2gvaWNpUDkvd1Z2T2loSTBqL3RqR3J6bjBq?=
 =?utf-8?B?Qk90UmFkYWp4V3RVNzd2V09FbkhmcFduWjJSNk5CcHBlNFpqeTBXZEVHUE1S?=
 =?utf-8?B?eUlIQUpHMTQ4RE9HMkhubkRPWXpHQk5JVEZQRVBKaWNiRmVNZTJHNVAwOUNK?=
 =?utf-8?B?aDFjMlBPbEthUGl3MnBqNnhBbTBCMElybk9iTTJpQ2lVWktFOFRQcUtlYUFj?=
 =?utf-8?B?c2NNYVlLQmRHcFlRbnVHelZMTDM2N3ZoMnpUelAzVFhBSTJiK1NIbnF3RW9D?=
 =?utf-8?B?bXB5UXlmRWZmYUJPOUpyU25qblBXbzhXZ0lkQjg3b1FCaVNNYmpLVHUzenh2?=
 =?utf-8?B?MjhFY2VYWXJXT1N3NUMraUd0eTZqMU5DZERFMzJQckV0TEVRSlFEV2FZbS9Q?=
 =?utf-8?B?Wnl4ZHJmTVRVQ1VmWlhkMThpSWZoRmdUV3Z4NVc1UEV4dG45YUE5bDBGNlIw?=
 =?utf-8?B?ZDhUd0VkaHg4WGNkclpXaDhQdHdNaTVnTmtwMWVXLys1RHBCS0xFTnQ4QXEw?=
 =?utf-8?B?aGNRd3pjc0cyRG8rdUY1UnU1NVVQN0VLY1RuREg5WkdScWNtUTlGUHdOYmpP?=
 =?utf-8?B?a3NMcmdYbkRQL0JLWTBDVmtNOS94UnJZamtXNlF0WWRCazVqRk1rUzlFaTlH?=
 =?utf-8?B?RXBaSXZ5bE1rTTRHR3lZbjFYYlp1ZEI1M29WOXNLd1VScmtVd3VBR0xaT0tP?=
 =?utf-8?B?aFQ3cDMvbUpQR1FOOFE4VFhGblo2NE5xN2hlNlpKWHJQbjA5aDE5NGdLTmti?=
 =?utf-8?B?alJJQ2pjN1BucmU3V3hXRVREelQxdzI4dmc0QkJQeHA4cE41bUd0KzYvVmRX?=
 =?utf-8?B?bnhVS0hEUFhyTlg4dWxFd0ZMQjJib3RRTGdtazA0Qit5WWZWWWpOU2NvcjB2?=
 =?utf-8?B?T2ZSQUJoZ01jY0xYMStLRjBzNlFGS3R4clhISk5OYVZGdi9XdENPQi9PRzZq?=
 =?utf-8?B?SlRuRUlBTUU0dmZ2M280VldXR2M1UldtaUJPQTNrNDNMNWFqazlocDhVcUZn?=
 =?utf-8?B?SkhPR2ZvNVNuUWVPeG9ZeHVtbFJYU1JyZ0E2aVBhZGZ2QlNSYURnUGFORXRi?=
 =?utf-8?B?a1Yra1lXRHZRRVc0VVRGclpMNGlmTjVoajRFYzFBTHFuOW9UaXpUYkI5MnlC?=
 =?utf-8?B?TGpuMUxRdUk0VjdJT2w5cGhyNkVXSTJ3MDBqNzJNK2wwdktNSUZ0ZmpBNTdu?=
 =?utf-8?B?R1AycmlFVVRFbTFTajFXNEcvVHhidzUxN1dnYXVXdWdsU2Q2dFFNKzExOU5s?=
 =?utf-8?B?YTJITWNUSVNVZEswcEQvaktZK1F0c2wvMzFGaElwSFNuWTNUMlYzUE0xZG9E?=
 =?utf-8?B?bEg3Y2JqZWVGMXFtNzhvOGdJSXNuZUcxV3hqVy9USEhWcW1WaTV2S3dJWkxE?=
 =?utf-8?B?TUZzZnFncDA1NnNSbElQREJSdzhsLzNuWmRZZ0xRcHdHNWNTZm95VFhIblRx?=
 =?utf-8?B?Q3dDTmF5M2hKMnVONVdJZ0E1RDNsREJwNGhZZTREbWR0YzkrYU5leTFmZVVU?=
 =?utf-8?B?L2o3Y1M2d1MxRFd1Q2o5S0Rvd0FxNkRCR0s4aFNlZWtWNm8wQ2dpekZNdGVN?=
 =?utf-8?B?NU51Nmd0WDk2Y3NmT3hNbi9CL1NpYnM4MVQxNE8yckZoaHcwd0FTQkl6ODlk?=
 =?utf-8?B?bHhvNnhrMEtHUUdVK3FOdTk4enUvVW00aTdIV2UrbjMwampDSzQ4QXVVVWMv?=
 =?utf-8?B?S01od3AySFl3dHJ5UXUyejQ1RHU5Qk9ScW1wMUxuVEc4c0ZsWllwcFZGYncy?=
 =?utf-8?B?WHBIVGloOWIzTEw0Tldpb2twclpmc3RUbllNZnRpQTNJbW5OQmpGaENnbjZa?=
 =?utf-8?Q?332D1nm7WklMxL2Yibuw6MMYbW9ye83Ey158EuvyO9h+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c675ef-6a21-4052-dc31-08db851b11db
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2023 10:05:51.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hjx5Z+LBnf9hDtoG/0wbCHGBCqcJiOoae/zCkUpfpie5vYPwXTQxJjJLL/G1VqQ/0wPPy9GCgHW+u0b1SjbgEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9818
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



<snip>

> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 0f16ba52ae62..a5e77893b2c0 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -51,13 +51,38 @@
>   
>   #define TDREPORT_SUBTYPE_0	0
>   
> +/* Called from __tdx_hypercall() for unrecoverable failure */
> +static noinstr void __tdx_hypercall_failed(void)
> +{
> +	instrumentation_begin();
> +	panic("TDVMCALL failed. TDX module bug?");
> +}

So what's the deal with this instrumentation here. The instruction is 
noinstr, so you want to make just the panic call itself instrumentable?, 
if so where's the instrumentation_end() cal;?No instrumentation_end() 
call. Actually is this complexity really worth it for the failure case?

AFAICS there is a single call site for __tdx_hypercall_failed so why 
noot call panic() directly ?

> +
> +static inline u64 __tdx_hypercall(struct tdx_module_args *args)
> +{
> +	u64 ret;
> +
> +	args->rcx = TDVMCALL_EXPOSE_REGS_MASK;
> +	ret = __tdcall_saved_ret(TDG_VP_VMCALL, args);
> +
> +	/*
> +	 * RAX!=0 indicates a failure of the TDVMCALL mechanism itself and that

nit: Why mention the register explicitly, just say that if 
__tdcall_saved_ret returns non-zero ....

> +	 * something has gone horribly wrong with the TDX module.
> +	 */
> +	if (ret)
> +		__tdx_hypercall_failed();
> +
> +	/* The return status of the hypercall itself is in R10. */
> +	return args->r10;
> +}
> +
>   /*
> - * Wrapper for standard use of __tdx_hypercall with no output aside from
> - * return code.
> + * Wrapper for standard use of __tdx_hypercall() w/o needing any output
> + * register except the return code.
>    */
>   static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
>   {
> -	struct tdx_hypercall_args args = {
> +	struct tdx_module_args args = {
>   		.r10 = TDX_HYPERCALL_STANDARD,
>   		.r11 = fn,
>   		.r12 = r12,

<snip>
