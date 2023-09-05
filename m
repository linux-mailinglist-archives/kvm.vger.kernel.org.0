Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E579279E
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbjIEQEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354884AbjIEPac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 11:30:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823B2EB;
        Tue,  5 Sep 2023 08:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK5b6q3461nYVY+/m9TdNwUJxnMJjUAEjLjJXYTcQ3G5sGzY5Yv39zbKFxH00lhpkPH6dQocdQgG7MTwVlu1Bc1kGyHbf/4GHBr1oeOVWXjHXNFAu2ja8eNyWfFHDZzt5T0DrmVtKq3HkS5Nzl9O60iMhgam7v316HBxagoEKbX7iO/4JJ72m/MJDLEwhi7uhCA6LzUH1K8o7oxXH0YD4HVnD16tTkMb+QvdocmLs91XAXxNHY7i7Lwb+723ygP+Eq28E3AUHHCHNPMQq9h7sr8mij+Xue6uNDvHZHluTGQtm3oKHtn5dwmZkBPqLPVn/Uq/hJST5VvgOzYUBAHASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTlgFl4dJnX3/5BPIJLx49nCboyhrOcwFdglXSMfHuk=;
 b=YycdT1gnoDoyrHnmqjBANjPiVg/XV2w/HWzsVehmR0IJdGtT7Ee5I75MmADrSWaNrsYxN+/TvTi+Evp2aOeT26cC4akPISKJC62ZNKENdRZBeHFmX4YXIaWKIdTktpKQfxPSwgrFxUceF4S2AlMkU+lFPkA/Iv1jaWRBzsPsokQCPdZAoogo+D4uDPqh3gocVaLIjr4vJPKkhcCsX5qj0x7ZjTo0CAsnyE/JBQFgg5bGhLidg2UOq+BpENj7kNEfIM1SBSEPGprtb5JaYISLoWS5hqWtrdaGmcFYFwJ+Fg9bnny+IWofI9UIk6U9qkPXgFAzgagVe5WsFB/zeo7IGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTlgFl4dJnX3/5BPIJLx49nCboyhrOcwFdglXSMfHuk=;
 b=MARRc7/+0IcHZeOfHFvIlxNxB5I1LEED0ax8h2HO1VdCW81sW9tLOtts4oy1F4K+2B7yf2C0+CZ8HIudjCgR4ppwdDJ7cBHxEX/dJdpDKotFgDTYNr7bPOT5Yn87TNH7kuc3/FjMOC8dohm1y6qrrHVtj7EM/I3DIv0z0wKznKE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB9344.namprd12.prod.outlook.com (2603:10b6:610:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 15:30:23 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 15:30:23 +0000
Message-ID: <2bdec424-beca-7b67-7241-c1e0b0cf987f@amd.com>
Date:   Tue, 5 Sep 2023 10:30:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 09/13] KVM: SVM: add support for IBS virtualization for
 non SEV-ES guests
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        seanjc@google.com
Cc:     linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        bp@alien8.de, santosh.shukla@amd.com, ravi.bangoria@amd.com,
        nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-10-manali.shukla@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230904095347.14994-10-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0165.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB9344:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a4c8c9-506e-4798-3ccc-08dbae2505a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzwSWZrll9LkThaMRr8EPC61GqS6KvwDbq/twMiy+hc1KS2Emz1JSvfrbRIKCeiq3xGQzJqNKRZqvBNHH2DAZ+k8znscHEJZHRBc4SeXcO5EARkom4hF2netmBoRFAPMhHi5irl8aTbLYEIYbD4n78jg6h5zOPoPouOSfLm2KkX9d4KDCeowEG/3UKAbQGuBv7H1rv1G3xJi2otxbEAm7s4/SECEGkxYkR37VarYkL994BQWJMz5zXelGlI2JWke/B3PVk0ipLYjWZXnRDGYILdxj9MrTOfk7P9vqde7/9Sb944XGpJkBd3pWiQ86Y7f1pxp2lNkn35Q5viF3IWdBOvBiIoWU60umtYSArPoVtsb/qpyR1+y3yxjOigqq8Mbo0pO+sRKs02Y5NQj0iUFpccJho+AEE9llaZQ9aDtBHx1PDn0S/jV0KFHFLr0N55bZNvX6la/VulT2F7KdRz+aEQm9dfO4BefwmErwlONvwErowu8522SKjLazknYtct41vGEang5FBZd1a0YzktPRoORxM0SusgmjbEWFNjvdzeeZJRVkffWMyxiL0tCBuhczdRgv+Po5Nk4pW2aJsIZ64+w15WS7RpjcqYa9CpAEJvmHbVS7nV8PIXLWe0EYjXQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199024)(186009)(1800799009)(31686004)(83380400001)(31696002)(38100700002)(5660300002)(36756003)(86362001)(41300700001)(66556008)(66946007)(66476007)(26005)(2616005)(478600001)(966005)(6512007)(8936002)(4326008)(8676002)(316002)(2906002)(30864003)(6506007)(6486002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHhQVUNoRlRaMEdwUmJueG1GWUFXcGp6T2lTWDRWRlpINE55cnlpbWtsVWxR?=
 =?utf-8?B?dmhtK283NFRvanlvK3VEQnEyMWhQYldJNlRiRi9QVWJIR0JTY3ZqZlJJN3Fl?=
 =?utf-8?B?WE9SZUtvTlpYelhENW1xMlBhMjZrRFh6TlpWcGlsM2hsTUQ4NnF5M3B5czdx?=
 =?utf-8?B?bWIwZ0JCZTErbk13UmM4T05semZIZTVkZlh2UXhUSWZOUTg0WlRVNVF6NWNF?=
 =?utf-8?B?OUpHeFNmMzlpSUtMbjZ2WEF4bGpCV08yVWhtblk3NjV4K2MydTNBZHNyd21t?=
 =?utf-8?B?dnJ2VEF5TUhOZHhOeGsvRnQ2eTdmaGFLNFUrRVgyKzFVOEo1R0dmY2Y0NTJP?=
 =?utf-8?B?ajRTRU5WWmNFcVpFQi93cktybTV0WWNOYTA2d1J5ZnpBU3JxS01XYVRzbXly?=
 =?utf-8?B?Sm9nemk3aHBQekhCbnNLbkFWbDA2bWpJa2JFL2xQTzhrRnI1L1NEMGJJMkYx?=
 =?utf-8?B?NFR2cjU5Y293aVZyRkViUEZ4aHN6WThJRjlMcDNXTEdVdm9xYVpOTjBXVlZo?=
 =?utf-8?B?eDlITGQvV29PMmpNTHBOdEN5dmp6aURGRVJaU0NacVpPRHhaMjM1bnQyd2Zi?=
 =?utf-8?B?eDZZVkhMMTR4clh6Z1VGNmc4NUxaeVdXdnB0c1NPaU5WSXlubE5zcys2bmZ2?=
 =?utf-8?B?ak5KZ2J2WUdkQWV5SVl6Sk5QeVdORTFkQWplYUdWOHg1OERZcmtyYlZYSTlR?=
 =?utf-8?B?ZitlRGtMTzNRSnJDQWlVRHZ6NnVRYVJKcnFhME9WcGFZNGYyN3FVYmxxQXlk?=
 =?utf-8?B?WHBZOWZQNUtSNFBNbmFXdThUdTdEZ0ZBUFAzUTBuRjVXZDd1Y2N3Q1NRT1RN?=
 =?utf-8?B?cVI1TWRnMEtTSG9PWENQeHpsdytlbmlucDVsQ2I5NUlJb0I1TitKaEZEWVZi?=
 =?utf-8?B?MFdKWVUydDVSTUtLUlFpWG1XRVFESWFEMWRseDlrMDVSZkN6QTR6RitNdlRY?=
 =?utf-8?B?NkR4ZWRybXQ5ak8rVVFiOE9hYUFkcTcxNWJGR1NzVUdRZTVJZ3ZsZzFIVDJ0?=
 =?utf-8?B?TVJ0V1IrY2dQcU5sNHFlek5BQThRL01xbWROMEREN2ZEUkFEeE9ZK1lHOHIw?=
 =?utf-8?B?dk9EK0lHUDVpNTNLM1prWmlSN2Y2WXVndGR1NzVSZTF5alJIMGdOcHIvaWJN?=
 =?utf-8?B?L3F2TStmaFNydWhrWmowZExHSXM0cVpiY1M4OXZMQzg1MUVQOFltV09oNFUx?=
 =?utf-8?B?Rm5XWVI3RVNUOStrVGRiTG9FZG4xMzJhenRUQ1c5UG5GYkh5WmNWTERTbG5j?=
 =?utf-8?B?aG4yY1J1TDFMSnVZRGg5bUZwY0VSTHZ3bG5HeVF4NWRldXhyblBCT0QvRjJZ?=
 =?utf-8?B?c3dmdk1LcEJvaXNESUtZL0pmWlZPZXdIMFc3SGVsQ3U1S2Fvc3pvU0N5bVVo?=
 =?utf-8?B?cEVhdi9lTXdGMlNUbERIT1NpbmR2eE1kNGFPTU1FZUovVHpuaExaby8wTUtG?=
 =?utf-8?B?YlZZbWJPRGZWYXZxQkZJQXNMek94Ky9NUHU2L25peVBsNWpOZ29LdHd0R1Mw?=
 =?utf-8?B?R2RyOEdQQzZiN2c4R2xFdGQ3N1EwYjJWZUk5Smhib1kzS1FvbkxTbzFQTGFa?=
 =?utf-8?B?OFVvWmk2VWd1V2kwY2FrVHkzdTEzeVJnQW5LeUllZUxqOXRrVm44OC9LVkIr?=
 =?utf-8?B?ZnlCMDhmMGUvUXFPZ0xSZzk0OGFtNjU4cHMvZnp6eTdqcXVCVVVHVjNjd2p3?=
 =?utf-8?B?UWxieXlETncxZFkrR05JZEtLT1JQQ3hWK0RXSjBKbCtIS3BONWkvcmdhb2xx?=
 =?utf-8?B?S21VNDhTTDNGeDF3MXA0ZzJTQXFQRGZSRlUrb1BiRDM0d0xOZ2NjcTcxNHRn?=
 =?utf-8?B?U3h0aWFESVBFT01BRU5mL0RUN3pSdjYyR3A5VlMxbUlDZFAvZW11bUtnQXEw?=
 =?utf-8?B?MEdJKzdMMzZXNk5LcGlHcjJDWUVpMnZCV3ovd0prd2xqVWo2SWVSMWRnNkdz?=
 =?utf-8?B?enNiTXhac050dHBuNWxRMmJKaEVXUGpZYjh0N09ZaU95TmUwenlqaGhZYldn?=
 =?utf-8?B?ZFJZc09WZHoyOENJYWFHVnZpS2krMEFBTVd6RDZ0elpzRmxSKzJoYmpsYWhY?=
 =?utf-8?B?a2hDTFRCRkJwdm0vcDJnQzQ3c0R1YmZqMHBvYjl2N20wN3RlcDk5L1ludFQ5?=
 =?utf-8?Q?XqrLDqMqT2F4dvgSMBTGYKIU6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a4c8c9-506e-4798-3ccc-08dbae2505a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 15:30:23.6410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7IE4mckEWjJL40IeuvKqBvDXZEaClf6ijbyzASGmojfmxpn9CdUkwIpyCiAGoNJp2KxrBbUl5WVy9px7OJSkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9344
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 04:53, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> IBS virtualization (VIBS) [1] feature allows the guest to collect IBS
> samples without exiting the guest.
> 
> There are 2 parts to this feature
> - Virtualizing the IBS register state.
> - Ensuring the IBS interrupt is handled in the guest without exiting
>    to the hypervisor.
> 
> IBS virtualization requires the use of AVIC or NMI virtualization for
> delivery of a virtualized interrupt from IBS hardware in the guest.
> Without the virtualized interrupt delivery, the IBS interrupt
> occurring in the guest will not be delivered to either the guest or
> the hypervisor.  When AVIC is enabled, IBS LVT entry (Extended
> Interrupt 0 LVT) message type should be programmed to INTR or NMI.
> 
> So, when the sampled interval for the data collection for IBS fetch/op
> block is over, VIBS hardware is going to generate a Virtual NMI, but
> the source of Virtual NMI is different in both AVIC enabled/disabled
> case.
> 1) when AVIC is enabled, Virtual NMI is generated via AVIC using
>     extended LVT (EXTLVT).
> 2) When AVIC is disabled, Virtual NMI is directly generated from
>     hardware.
> 
> Since IBS registers falls under swap type C [2], only the guest state is
> saved and restored automatically by the hardware. Host state needs to be
> saved and restored manually by the hypervisor. Note that, saving and
> restoring of host IBS state happens only when IBS is active on host.  to
> avoid unnecessary rdmsrs/wrmsrs. Hypervisor needs to disable host IBS
> before VMRUN and re-enable it after VMEXIT [1].
> 
> The IBS virtualization feature for non SEV-ES guests is not enabled in
> this patch. Later patches enable VIBS for non SEV-ES guests.
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
>       Instruction-Based Sampling Virtualization.
> 
> [2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
>       of VMCB, Table B-3 Swap Types.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c | 172 ++++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/svm/svm.h |   4 +-
>   2 files changed, 173 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 20fe83eb32ee..6f566ed93f4c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -139,6 +139,22 @@ static const struct svm_direct_access_msrs {
>   	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>   	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>   	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_AMD64_IBSFETCHCTL,		.always = false },
> +	{ .index = MSR_AMD64_IBSFETCHLINAD,		.always = false },
> +	{ .index = MSR_AMD64_IBSOPCTL,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPRIP,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA,			.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA2,		.always = false },
> +	{ .index = MSR_AMD64_IBSOPDATA3,		.always = false },
> +	{ .index = MSR_AMD64_IBSDCLINAD,		.always = false },
> +	{ .index = MSR_AMD64_IBSBRTARGET,		.always = false },
> +	{ .index = MSR_AMD64_ICIBSEXTDCTL,		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EFEAT),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_ECTRL),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(0)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(1)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(2)),		.always = false },
> +	{ .index = X2APIC_MSR(APIC_EILVTn(3)),		.always = false },

Why not keep these X2APIC_MSR registers with the other X2APIC_MSR registers?

>   	{ .index = MSR_INVALID,				.always = false },
>   };
>   
> @@ -217,6 +233,10 @@ module_param(vgif, int, 0444);
>   static int lbrv = true;
>   module_param(lbrv, int, 0444);
>   
> +/* enable/disable IBS virtualization */
> +static int vibs;
> +module_param(vibs, int, 0444);
> +
>   static int tsc_scaling = true;
>   module_param(tsc_scaling, int, 0444);
>   
> @@ -1050,6 +1070,20 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
>   	}
>   }
>   
> +void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
> +{
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHCTL, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHLINAD, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPCTL, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPRIP, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA2, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA3, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSDCLINAD, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSBRTARGET, !intercept, !intercept);
> +	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_ICIBSEXTDCTL, !intercept, !intercept);
> +}
> +
>   static void grow_ple_window(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -1207,6 +1241,29 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		/* No need to intercept these MSRs */
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
>   		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> +
> +		/*
> +		 * If hardware supports VIBS then no need to intercept IBS MSRS
> +		 * when VIBS is enabled in guest.
> +		 */
> +		if (vibs) {
> +			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
> +				svm_ibs_msr_interception(svm, false);
> +				svm->ibs_enabled = true;
> +
> +				/*
> +				 * In order to enable VIBS, AVIC/VNMI must be enabled to handle the
> +				 * interrupt generated by IBS driver. When AVIC is enabled, once
> +				 * data collection for IBS fetch/op block for sampled interval
> +				 * provided is done, hardware signals VNMI which is generated via
> +				 * AVIC which uses extended LVT registers. That is why extended LVT
> +				 * registers are initialized at guest startup.
> +				 */
> +				kvm_apic_init_eilvt_regs(vcpu);
> +			} else {
> +				svm->ibs_enabled = false;

Can svm->ibs_enabled have previously been true? If so, then you would need 
to reset the msr interception. If not, then this can be simplified to

	if (vibs && guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
		...
	}

without an else path.

> +			}
> +		}
>   	}
>   }
>   
> @@ -2888,6 +2945,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_AMD64_DE_CFG:
>   		msr_info->data = svm->msr_decfg;
>   		break;
> +
> +	case MSR_AMD64_IBSCTL:
> +		rdmsrl(MSR_AMD64_IBSCTL, msr_info->data);
> +		break;
> +
>   	default:
>   		return kvm_get_msr_common(vcpu, msr_info);
>   	}
> @@ -4038,19 +4100,111 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   	return EXIT_FASTPATH_NONE;
>   }
>   
> +/*
> + * Since the IBS state is swap type C, the hypervisor is responsible for saving
> + * its own IBS state before VMRUN.
> + */
> +static void svm_save_host_ibs_msrs(struct vmcb_save_area *hostsa)
> +{

A comment here (and in the restore function) about how IBSFETCHCTL and 
IBSOPCTL are saved/restored as part of the calls to amd_vibs_window() 
would be nice to have.

> +	rdmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
> +	rdmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
> +	rdmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
> +	rdmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
> +	rdmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
> +	rdmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
> +	rdmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
> +	rdmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
> +}
> +
> +/*
> + * Since the IBS state is swap type C, the hypervisor is responsible for
> + * restoring its own IBS state after VMEXIT.
> + */
> +static void svm_restore_host_ibs_msrs(struct vmcb_save_area *hostsa)
> +{
> +	wrmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
> +	wrmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
> +	wrmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
> +	wrmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
> +	wrmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
> +	wrmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
> +	wrmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
> +	wrmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
> +}
> +
> +/*
> + * Host states are categorized into three swap types based on how it is
> + * handled by hardware during a switch.
> + * Below enum represent host states which are categorized as Swap type C
> + *
> + * C: VMRUN:  Host state _NOT_ saved in host save area
> + *    VMEXIT: Host state initializard to default values.
> + *
> + * Swap type C state is not loaded by VMEXIT and is not saved by VMRUN.
> + * It needs to be saved/restored manually.
> + */
> +enum {
> +	SWAP_TYPE_C_IBS = 0,
> +	SWAP_TYPE_C_MAX
> +};
> +
> +/*
> + * Since IBS state is swap type C, hypervisor needs to disable IBS, then save
> + * IBS MSRs before VMRUN and re-enable it, then restore IBS MSRs after VMEXIT.
> + * This order is important, if not followed, software ends up reading inaccurate
> + * IBS registers.
> + */
> +static noinstr u32 svm_save_swap_type_c(struct kvm_vcpu *vcpu)
> +{
> +	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
> +	struct vmcb_save_area *hostsa;
> +	u32 restore_mask = 0;
> +
> +	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
> +
> +	if (to_svm(vcpu)->ibs_enabled) {
> +		bool en = amd_vibs_window(WINDOW_START, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
> +
> +		if (en) {

Why not just: if (amd_vibs_window(WINDOW_START, ...)) {

no need to define "en" just to use it once.

> +			svm_save_host_ibs_msrs(hostsa);
> +			restore_mask |= 1 << SWAP_TYPE_C_IBS;
> +		}
> +	}
> +	return restore_mask;
> +}
> +
> +static noinstr void svm_restore_swap_type_c(struct kvm_vcpu *vcpu, u32 restore_mask)
> +{
> +	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
> +	struct vmcb_save_area *hostsa;
> +
> +	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
> +
> +	if (restore_mask & (1 << SWAP_TYPE_C_IBS)) {
> +		svm_restore_host_ibs_msrs(hostsa);
> +		amd_vibs_window(WINDOW_STOPPING, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
> +	}
> +}
> +
>   static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 restore_mask;
>   
>   	guest_state_enter_irqoff();
>   
>   	amd_clear_divider();
>   
> -	if (sev_es_guest(vcpu->kvm))
> +	if (sev_es_guest(vcpu->kvm)) {
>   		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> -	else
> +	} else {
> +		restore_mask = svm_save_swap_type_c(vcpu);
>   		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>   
> +		if (restore_mask)
> +			svm_restore_swap_type_c(vcpu, restore_mask);

Unconditionally calling svm_restore_swap_type_c() and having the if check 
in that function would make this a bit cleaner.

> +	}
> +
>   	guest_state_exit_irqoff();
>   }
>   
> @@ -4137,6 +4291,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	/* Any pending NMI will happen here */
>   
> +	/*
> +	 * Disable the IBS window since any pending IBS NMIs will have been
> +	 * handled.
> +	 */
> +	if (svm->ibs_enabled)
> +		amd_vibs_window(WINDOW_STOPPED, NULL, NULL);
> +
>   	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>   		kvm_after_interrupt(vcpu);
>   
> @@ -5225,6 +5386,13 @@ static __init int svm_hardware_setup(void)
>   			pr_info("LBR virtualization supported\n");
>   	}
>   
> +	if (vibs) {
> +		if ((vnmi || avic) && boot_cpu_has(X86_FEATURE_VIBS))
> +			pr_info("IBS virtualization supported\n");
> +		else
> +			vibs = false;
> +	}

How about:
	vibs = boot_cpu_has(X86_FEATURE_VIBS)) && (vnmi || avic);
	if (vibs)
		pr_info(...);

> +
>   	if (!enable_pmu)
>   		pr_info("PMU virtualization is disabled\n");
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c7eb82a78127..c2a02629a1d1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>   #define	IOPM_SIZE PAGE_SIZE * 3
>   #define	MSRPM_SIZE PAGE_SIZE * 2
>   
> -#define MAX_DIRECT_ACCESS_MSRS	46
> +#define MAX_DIRECT_ACCESS_MSRS	62
>   #define MSRPM_OFFSETS	32
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;
> @@ -260,6 +260,7 @@ struct vcpu_svm {
>   	unsigned long soft_int_old_rip;
>   	unsigned long soft_int_next_rip;
>   	bool soft_int_injected;
> +	bool ibs_enabled;
>   
>   	u32 ldr_reg;
>   	u32 dfr_reg;
> @@ -732,6 +733,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept);

This doesn't seem necessary and isn't part of the sev.c file anyway.

Thanks,
Tom

>   
>   /* vmenter.S */
>   
