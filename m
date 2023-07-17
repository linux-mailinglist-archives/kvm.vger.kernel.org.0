Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB7756450
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjGQNTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 09:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjGQNTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 09:19:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B7A3A87
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 06:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgwcixCEUdQM7qfuiLJ9Fz3xcR83ND/KH89DnJqko2U8glWhI1Gxu64Pl0GIpvy5BsMkoThIRgOQ1OU31h9xsVrElUST8WzdPAlMztpOu01Ob2985C5zedVQW4V0HLazLaeqK/SJ++s8LLHwSSVLTIDqqVHtBmavSZSG0zyqBeJwwlXP8mMXlrmGF9qpxsQz4aZMODbUvRf32FtiPvoDX4gNquYo2AhO3GcMzdK1Nfs9ywFfCPqIDMERoruXlo2dN+mVLajKwRIgT7QxXFK2FQwDgblYzHkxwrCJBpg9sjS1B5JN+ZH4pAtq77vWpOY+PceoabQLG06t5sPIQ0a6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/xaw+axgraIMK9ekuzSGDIn5oA3WK4H/wFAku6wpeg=;
 b=cyfD4AYXodEZwKLpuHI6w0Cps7AOUjifz/XNHrOrq99D7tdxiPrXih0CgElGGp9yNWJWc2ybvQ5Ki61ayRgKabiGVK9VV5priqlaTwktXqLfPcNc+Oxr2oIzJpu3YyBB6+l5gBPBAXFwJmFoPkCNpxKLyEyu2B20At1hSn00lFSfI5MKnlIB2y7m1Bz3kpH8p0oCGesQwqF0xl/U1ox3YaGuek54gtsU/a3bL4xlrcvGEs/ruFtEMfQiDlkz5VgV5jDwcF3vaABhno/IMly3qkIRHRGPJ4dx5wArjKF18+FWIldTlZ4aifhO/W2QRrSVusKQ7YnxLpMsERn7O0sJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/xaw+axgraIMK9ekuzSGDIn5oA3WK4H/wFAku6wpeg=;
 b=XsXcTqsLmQZCGxaMQlJPyNhF0QKG14gHMhKUTWXJq8K8jlqYVzNBZgKXjS36fbFXzhpgpHtt4EydkQrOzgAo+A+7aftXxIodhfGTrkKkmq7d+E9DiwMAS1Wt4SonNTHqwcKuYoczZ7l18x2s97x2djJ7EYPBM11OTQkdUAf2bjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM3PR12MB9433.namprd12.prod.outlook.com (2603:10b6:0:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 13:17:26 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 13:17:26 +0000
Message-ID: <b6f80cd4-acf7-bc87-087d-142e8c54b098@amd.com>
Date:   Mon, 17 Jul 2023 08:17:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB
 save area
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com
References: <20230717041903.85480-1-manali.shukla@amd.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230717041903.85480-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0073.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM3PR12MB9433:EE_
X-MS-Office365-Filtering-Correlation-Id: d3a461a0-ff11-474b-fa82-08db86c82a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9T59J7RvVx0hIXuNxdImAa+oPFInegNeA9H7ltdEoIdT2xLqqSl0UTTVP71y0fYlevvsXUgvbXXAF2G4rE7eOCH2PpCB1a5qciUcU5h5F/UOudkdHyZZLI2g5hsdNHVIG5fVJB/jDV6WgdtR0UlBnLJGb9zNLsgevo5gFO7YgVe/Yeg8O6L8nNNqPzr3QKfx+k9mm7WsBaIorNgbXTOllhgQpr6Sr0kbgMWFrjKvHN2oq6Nj5u8/5BPKmqlK1ZIxQwxjovZzg3r1FJXNWvNpKaP5uxmrXeo0UWvzH59PllAMLJBsyu804pQu80Vi6n5NcZEB5wQ/ESsKI+gji0hvAaGU9g4t3souRZSb4C/b1yP/zBjmPqjkVmABmZS82crVipWJ2GJtc9XYLM1CqnDWiwOqIw+KpldvpJkhrgMH42vP7dE4auNEVzNToP+mGrhW8C216kff5jOh2oOBxmhllS7V8YuKHgN05BgvkavR33uufubV06PyiibihYq0sTrbYa050Xk9+bWQ/g9y5KBKa7xSVuyDtIIeUXeCOkiwiyw/pFqPF52dr2LumXv6hCfsqaBHFLa8wPXsbbcvXxKkCUuBVP0/KJIkCWtvxQHof6tAocWMS0A3fVAhdb/isoO0w3FIHSwr4bsVp3S39H9ljw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(6486002)(26005)(6506007)(53546011)(6512007)(36756003)(2616005)(83380400001)(86362001)(31696002)(38100700002)(186003)(8936002)(8676002)(2906002)(41300700001)(478600001)(5660300002)(4326008)(316002)(66556008)(66946007)(66476007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Um13NU00KzcrVm92K3EzZWtqYjZjdXFRTHlXRklxc0NxaVRWTmFweE84OWc1?=
 =?utf-8?B?QlI2Y25WeEswUVFZdEVXSHhjSzMybHJqZGR1Zk5GN0xuOFZqaG5OU2o4UGdY?=
 =?utf-8?B?VDEwMTkxZ0l6OHhwaWlHa3pzYXc5NGVHVzVWSzdGc3RCZEVuVUtZMUIzazJK?=
 =?utf-8?B?bzNUUG5NKy9Yb2VuNVZpMjloRy9kb09Zc2RDWkJXUUtaWmxzQTYrNm5JMU1Q?=
 =?utf-8?B?Wk1hQkVjUElvWnQ4bXNCa1VDejZQaHVyVGNDNE9oQ0pPbmdPUmdSeVdsSjdk?=
 =?utf-8?B?UVpudk1UTHkyTm9ONUE3eVhpcUZTY3c4VWdtVzR4UXk1SGw1OTI0YjhwdkhT?=
 =?utf-8?B?UHh6U1BrdjRlZzViQWVyRDVwUWdXR3U5djFQT1VvcmJLQzV4ZTZNTHpuRHlG?=
 =?utf-8?B?cnNLTGdabkhQMlgzRXVVOVlSWk1laXRQTHYvb3hSbHFyRGJZNk9tM2t4eEQ2?=
 =?utf-8?B?UlZveXV2ZVZaczNPQjBMMHZDMXlvSUhuOUdxTTRjeDg3Y2VGRXplSUVUdlhr?=
 =?utf-8?B?YjJndXloZ0ZINURacmZDR0U1aTFobXBqVXBXRnVPVEl6YTduM1JsSVdGTmFL?=
 =?utf-8?B?SGFKSzBtejNvT2FwZE40QmJCU0xGbFF2RFNUVlZKaUpscVBFQ0xIWGR6S2JI?=
 =?utf-8?B?ZGhML0JLWnZLT2p1blg0VEZZV3BiSTY1STFrREVuUUd1SlZyMGVlVHFZcSsw?=
 =?utf-8?B?alJUQXg2dWhoMlMvM2xWMHNaVzNGK1Q1aWtwNkQ0NEtudCtwTUYwN01Cd0E0?=
 =?utf-8?B?anVtNGtlYmgzZVhmWWxvYzhDWEpPTzdzUkd6YkkyV2ZFa2dwN2FkdjZXZEMx?=
 =?utf-8?B?azVBMGo4dHgvMjVOU2tqUGpMRVRCQXBmcUZ3Q0tneWpsR1FWR05HSC92K2pT?=
 =?utf-8?B?T0dldDNDWFNlcGZySGFINVJIOGlQdllDQmNMNnVTbEdZbm5QaG93YWIzeHBp?=
 =?utf-8?B?c1U3U2xtdTZXWmJ2ZEFZbHpST2tFL0RNaHRuUHZpKzZGaUd1cTN3THFpMFoy?=
 =?utf-8?B?TjRCZ2llRG1zZmtBbnc0S3AzUGwwRXUxVys2b0w5TlRtcm5wNGlNd3dNRWJC?=
 =?utf-8?B?ZFNUTVcwS3g4eVVNT212aENleFk0TTNmbkpEUmI5ekw1L3JpSDNCTnJuUkYx?=
 =?utf-8?B?Z0p0eERydWdVQ3l0Z0ZjSmdjQkRONDlGbGg5cElsOGltdmxZRjhSa2xBVEZi?=
 =?utf-8?B?azk3WkZ6MURuUGUvZGFVQW5UM3YyUFNOSm1PaEIyOTdjeURCbEhjakJtRXVO?=
 =?utf-8?B?UEdRdkJFK0RkWnhPS3lHUS96eVU4Tnk2VVFnMURNMlQxWU5hY05JMjZaNjhP?=
 =?utf-8?B?WFNWN1hkQnBPZ3U4cXEzZXg1OTJEZ0VxdHlUSEJQNlc3bmp5S3F6YVNuYXAz?=
 =?utf-8?B?ZlJ5SU5nZDhzcFJiTVhob2hGSFdYTURub214Y1hmN2RvaFBtcFVUMG95NDZo?=
 =?utf-8?B?VmR6aHZ6Z3JaVGU1NHhheUg3d0o4UFdkTmlldHZidGozNW5FSWk3eHNJM3p3?=
 =?utf-8?B?OTNtN3BOYXJZbjg4K3Z2MDRPbEwyWm5WeGtBUjZybWp6S1N4WXBkclJqcmk1?=
 =?utf-8?B?bXVNVkwrc1k4bHhndXRRdFJBM3RzQWtxOEVYbzNQb05nZ0MrTmg4cEpKNnlR?=
 =?utf-8?B?NjhGdmh1S0xINXg2bzlKakRHUzVJRFZyYXZ4SGlQeVNuNDkzcVhBNHlYNDlC?=
 =?utf-8?B?VFNZa1NlODVRU0dtbFVtN1crU2U3OTJRM1BRdFcvT0xoZ1haRW5WY0RMZjVx?=
 =?utf-8?B?aXBScGRpT2tqbkRvQkJzUytlcUdYK1ZaUmlhSWJBaHEzODk5azBpellPVm1D?=
 =?utf-8?B?S0d0OWUvdlBhcFFURWFKSFU5dWh0Mk92VXJJNTZLeGpGUURmMTFxTWJDbzBn?=
 =?utf-8?B?MktSZ2IyOGZJRFMvRnJ1aHZlSHc1WTUzTHBoTEcrVFA3bkp1Mk1BWngxaUhU?=
 =?utf-8?B?bTZJc2dwdUM5YWRjMWgyNkZoNThMaGEra0FUd00yYWRoRUZQRkNaay8yd1hs?=
 =?utf-8?B?cC9oWjlVL215Nk1EK09DWXphVnkvdTlmN1ZkSmhkdGNtTlUxUHhKaFVPVWta?=
 =?utf-8?B?emdWV2k1U1lGbFNhcU5sZ1FzMVBJNnp3RTVZOXUyS2ZZRzhGczFVbEhWSlBk?=
 =?utf-8?Q?ZA+6YIiUQ3QzERJGnYH+0Vyar?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a461a0-ff11-474b-fa82-08db86c82a0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 13:17:26.2034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTjxoTkJIeWmMfHjBaZKI9UlvATOgaCQd5sjti+h8vjojaqDAwT3wlIrA/ATZr4oLrHPhjDNHdyMMA/EUrYHuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9433
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/16/23 23:19, Manali Shukla wrote:
> Correct the spec_ctrl field in the VMCB save area based on the AMD
> Programmer's manual.
> 
> Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved
> area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
> in VMCB save area.
> 
> The Public Processor Programming reference for Genoa, shows SPEC_CTRL
> as 64b register, but the AMD Programmer's Manual lists SPEC_CTRL as
> 32b register. This discrepancy will be cleaned up in next revision of
> the AMD Programmer's Manual.
> 
> Since remaining bits above bit 7 are reserved bits in SPEC_CTRL MSR
> and thus, not being used, the spec_ctrl added as u32 in the VMCB save
> area is currently not an issue.
> 
> Fixes: 3dd2775b74c9 ("KVM: SVM: Create a separate mapping for the SEV-ES save area")

The more appropriate Fixes: tag should the be commit that originally 
introduced the spec_ctrl field:

d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")

Although because of 3dd2775b74c9, backports to before that might take some 
manual work.

Thanks,
Tom

> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/include/asm/svm.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e7c7379d6ac7..dee9fa91120b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -345,7 +345,7 @@ struct vmcb_save_area {
>   	u64 last_excp_from;
>   	u64 last_excp_to;
>   	u8 reserved_0x298[72];
> -	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
> +	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
>   } __packed;
>   
>   /* Save area definition for SEV-ES and SEV-SNP guests */
> @@ -512,7 +512,7 @@ struct ghcb {
>   } __packed;
>   
>   
> -#define EXPECTED_VMCB_SAVE_AREA_SIZE		740
> +#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
>   #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
>   #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
>   #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
