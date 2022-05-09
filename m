Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3036451FE7B
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiEINmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 09:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiEINmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 09:42:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD81F8F02;
        Mon,  9 May 2022 06:38:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FriSkLCuSDw75yuQkcdy8TLw2iuHrxISURmzoMmP3iyQvL1o7h50aBCKsvYAC5NIXIvllhwoWJrPIWjkh2m41VTNvH05bBvjiEYOGaLdeb7cSSlV/rxKcafc3yFVqYeNi5hAeUsbFkZ6FXaF/h+Cw3iDLvHwd0xSfzqfruMW8wq2sJaSxwhSrzV+spGxqmjy1Kar++fW9bjPK7hYvN+Usth/dJdUALZ4+sZ/p9FPSj4lAzNH4xTMQ3m2+dGS+kM7LhhzAil1zhhIXO5rBNug+xJajtfKdXqI0wMimLV11IP4VDsmiFnAMHd6dZ8wRQRSmkE9SFVhRwS+k2U7kTEZsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUjhGEyd3e6Nt8JvuHsBjAuC3m/paRIRx4KS4eflAfA=;
 b=bkFAunVUv2xaiOQmhzps9YpIBGoSUfxed/hYt92rbSrOXAvKqJOqg8Wuu4dPkY+m94aVoK9bhMh4GVMPNZv/af6bB+FgOc6L42IHy8u3FdJpiWerh2Tr9noRPlv9m/oUdub4oaxtEYBGPq8VN+utxIYqphnqvNxUt9AencDQ89KlS7S32Iuf+ZrmjfZWVhIsHZ4PKMr7wUcXlt+3tOB8wS55PFXNtHrcyu++hNa/WZxKbGlL5rdLNP1LDeR0Bm6W+94435F9Ns+wrAz2MPcDHM2p4UrIpi8pewmluDNk2tjLGGGu/TVmtPc9Hwz3IBSHutaXSlK3v8AkTWQlhOTORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUjhGEyd3e6Nt8JvuHsBjAuC3m/paRIRx4KS4eflAfA=;
 b=Aoww3DPIi5xQzgGSDzTm5CtZOwuOBuJflk0hPoFcAxiUcBEkx7TAZ7ypwx2WBNHZyCwugB3ym4DS6KyXSS+ndCB71vpZz8u0XOKbkTMAtHdzOnN7oVtDtUCeSSOz7+CKhhQX2b44aXmQn5JWnDFvH6w0gll3/+YSM41wFq3+GSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by MN0PR12MB6320.namprd12.prod.outlook.com
 (2603:10b6:208:3d3::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 13:38:49 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad%3]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:38:49 +0000
Message-ID: <2b4a1f92-e2ae-41d9-9489-a8873f16f9cb@amd.com>
Date:   Mon, 9 May 2022 15:38:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 13/15] KVM: x86: Warning APICv inconsistency only when
 vcpu APIC mode is valid
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-14-suravee.suthikulpanit@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220508023930.12881-14-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::6) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9401d25-1a6a-4eb5-a730-08da31c13f85
X-MS-TrafficTypeDiagnostic: MN0PR12MB6320:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB6320AFC0CBCCF08A7CE62EE29BC69@MN0PR12MB6320.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIVr09C8Bs8AvavujB3rJPpkPNmQVZku7V4vWEGfmV2JSMOJmlsPBF4PCfAsmd8vhoNe9Lt4Jqhp2RMx+QwEWCpgHIGyACTDMo9BegU7/PRC3xMM6foeVTGV1OoqeFBmrCpDdibtKsI7/Z/90kk20fbA71sDUg13IirQIqNfGgnoG2r5u9vmW19GBE86vCF+xfQQ8yTS6HzLoi2sxxmzHo+te0PNqj06dgyba1Pia/d9bt1NhrjZj6tXQVGstqRG0EWct2DtS97c2z1HaWAjDdebkmePm87wbxDtJh8zSN0P/DLRho4jnCnBcd97UmGv4FptiIXxjklQSSyOLJVGBpf0j9u4HWkILZOGNXtSWZb3Zt+jbBztNGW1m3wlyZdObLAnml5WCKT8prRioKPmsRdsGdFtpsc6qPifK6NASTmzGNBqD3RyBJmhrLNvH9kYOfAzH3imfzqzHyX3XZ7H730K0G5m8/BwGpLTU+rdYEQR1A/kOJFECavXXXEVeC0Rdtju4F1WjBBv9s3LZ5dE90tce+f3POcW/4JIl++I/4JL5Ngb6nWDUnlPFwg0kzhqAGGINmDEOSZEOhU8QKWuOfsZn+BNoksIpkHsP5UdxBiNhjwuhNMvFUQwsLuKEHrgZWHh10UUWpxK919ghDAiFvQD35xkB3jKN3QkPNgc2eg+9iRG1qzNibgYaYVL/WTz3oz+Uune8tou07+X1i4GRFNw/2oRyVc4h/J5queHPSE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(8936002)(6506007)(36756003)(2616005)(6666004)(38100700002)(66556008)(316002)(66476007)(66946007)(8676002)(4326008)(2906002)(31686004)(83380400001)(508600001)(6486002)(5660300002)(31696002)(6512007)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW9OZ2NUcVkxZ2NYaFIyd3Rza3ZrZEhOeGlQaTIybklWZUZDRXZNVnlTU1ZB?=
 =?utf-8?B?RTN0MFVyUUkwQ0pRS01uNFFhL0JOajhxeDN5MFdkK2Z4STZKejU5OG9lL2RJ?=
 =?utf-8?B?dWlESFovMW50eUJCeHNTL0xtRFhONjBQN2lZd1g0YWQ2L3h3NnlhSmNHMzgw?=
 =?utf-8?B?RHNxL2hYZ3BPRVN5NG1jclNQMU1QRFRGUzRlSWlTS0F6YWswRkRqTmUxMFNT?=
 =?utf-8?B?U1RLTi9jM1lpZnBHanpDb0ZNd1hncGJLSjRwY0lEWVZBY2lhSkJ1OEM2eDlR?=
 =?utf-8?B?dThWUXZzWVA2RVFURG9JQlRDRHZsYmFwYytaU25CS21iU2xKcUE5blJUTEpF?=
 =?utf-8?B?Q2pidlJEQ0Z4RTUrMUkzSk1za0x2MGFwNkhJbkNpQkRHNlFjTkJNV3UyVm1I?=
 =?utf-8?B?MnNCWTVBVk9raWlsOEVXOE1wTnM1VVZKZjNqZ2JKT1JsVmlDN0U0bzFCZ0Qv?=
 =?utf-8?B?UzNCd2JWYkFJOXZVR09CYkJmeXloRXNYU2xNSko0RzBHbmp5ZVpkU0xwYS80?=
 =?utf-8?B?emdKLzcrQ3cvOFRjRThHRWQyTTRSMjRhZlF1bVhhZmNMN1h2ZXVZb2Y2VVdG?=
 =?utf-8?B?Z1YvdjBrd0FDNVBTTG54Zmcxb3BCSjRyTlZ4bDM4R0VIK3N2aUR2UmZ6V2Js?=
 =?utf-8?B?RHI4YUVjSkJ5M2EyMDhSTzh2b2s5eXhPd00xYVc2bFA5VUFBYmllSlBRWW9N?=
 =?utf-8?B?RldZeGhRWHBqQmJscS83eWdlUWthdU52YjdDNVZOQUw1SEdIMi85SElqZ0pF?=
 =?utf-8?B?QmJsak84a05ONjdvdHJQRW9tV01mVWZ0TVlWV0paWGRHMk9IK2pQWGFhMnIv?=
 =?utf-8?B?YUpQWGZoVldlV2V3cG5WZ3V0RDdkOCtNVkFFT1dYaHBxdElZYiszbS9jVnht?=
 =?utf-8?B?YjlYSWJvYzVpaDRkUHJsTFV4NkVaNlp5UVY1RHIrVnNTS09UYXFtU2VGSTdO?=
 =?utf-8?B?bE0waW1FR0VRWDhhMm1hNU9SaUJBOFRHR0pyL3RqUFdDMU9iWnd5SjcxYkQy?=
 =?utf-8?B?Tmx1dEkvSkFTYnNaTHd1aFgwSkowbHpjNEd2QXNFejdIZnlnZ3E4d0VpQUVx?=
 =?utf-8?B?RXlkelVuY1hVamdWM3B2emR2TnVReGUrenVBNWpQT2FDYzN3Q1JvUUlVcDV3?=
 =?utf-8?B?UWc0aGFYcXgvSFRGVDdVWm9PY3JjVDdqOWR4UWh2NnBhL3VJRE1uSjhSTmZo?=
 =?utf-8?B?eEFBV2I3eWNrQWszZFlFS2hDS2Z0U1JiN0N4WXRwZjlzc0lBcFdvQzJDMGE4?=
 =?utf-8?B?VnRYWkloSnpITDRjUTNEdGIyc2pweU5sWEp0ZFBzdFZpanh2SDNLNzJNTmxE?=
 =?utf-8?B?SFYvMkV2b1JEQWJMNGZlVEh0b3JmZ1VJbUV1Wi8zblB4REFFQVhJZGFRNUpr?=
 =?utf-8?B?T00wQXplUGZZOU40Y3VvMG5sSUJHamRFb2lIZktlK1BZRlQrWGNpcWpBOWtj?=
 =?utf-8?B?WE5JUXJ0VkhSeERLR3JrK3o2VE5YcFJLNUtvR1FvaE45d1ZwRTNYc2M5Z1JJ?=
 =?utf-8?B?eDJOT2RuenRmUUl0SEhmZW9yemFaekFybHpOYXYvTEtxVFVNcFVYN3M1bDBC?=
 =?utf-8?B?bFA4cklLekhGQzhvUlB1RkR6TnFPd3Y3Y3VlSG5pQUJEcWVJT0g0bGFXcEdI?=
 =?utf-8?B?OVA4L0Irbm9QSTBTUERMb0dKeGdQbjBOUmhUdyt3VFZQTlJ5QitoOThrK2dN?=
 =?utf-8?B?aExNRUkvdTZ1aS9iMmFyZDNnbTMwVkcrUFpXRmVQbko3ZmZwb3VRbWFSdlpi?=
 =?utf-8?B?Q3Jad0RqRFo1dXdFa0tOZDJnOU02USsxZitMWUNiMys4czlCbE9zUExvK29t?=
 =?utf-8?B?aDQ4WGtTN3NndTA4dzU3Z0VoNHFMYnNGNTBGeFYxYU9CRlpSNDEzM1BVWE4z?=
 =?utf-8?B?VllQbnRSWmNUcVU1YU1JU1FrNWJoMDhXNnZadXAwV090NG1raUpXL2EzT0F3?=
 =?utf-8?B?Y2UvL0MzaFpPbUNCbURmL1Nyb1ZSSHdrdFViVEhuL0pTQTN3Q2dtYnZJS05U?=
 =?utf-8?B?SW1yN3UzUjNRVlJwYnQ5MkJCZlNGVkV4OVJ6ZVIrL1U5R1NyUDIvRjFKbkVR?=
 =?utf-8?B?MjNhMEI5WVp5d2JUMms5TWY1MVU0b1FldSs3d3NJTzVZZzdJbzVwOGl5elpq?=
 =?utf-8?B?ZVFRbjVnZkFScnFuY3FSVzlCSlQydzBUNkUzUDRlcU9reGo0WWN3WkExS0ZP?=
 =?utf-8?B?Y0c0aTFjYVZIcnEzTnFORFlsclYvYnRDOFhndmRHdVpGRGZuaVBiTjFpdnYx?=
 =?utf-8?B?TTllNC9Tb2loOHpxTW4yZjFMclNSR1ZuUjhqTjhuL2NIOXVjZjNHNEF2WkRI?=
 =?utf-8?B?elRLVndPcC9DRU1Nc3FIR2RzWmMxUVFmWCtvb3oyajhHT2ZJRWo2UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9401d25-1a6a-4eb5-a730-08da31c13f85
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:38:49.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94aRUnStNWqnl/EgSu0rdOkGnUz30TKVBHjvlXKlLVN8HcSW96oOMrADwje3CGo3hchPYhcqLZNf7tWv1G6zoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> When launching a VM with x2APIC and specify more than 255 vCPUs,
> the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
> The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.
> 
> In this case, APICV is deactivated for the disabled vCPUs.
> However, the current APICv consistency warning does not account for
> this case, which results in a warning.
> 
> Therefore, modify warning logic to report only when vCPU APIC mode
> is valid.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/x86.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 77e49892dea1..0febaca80feb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10242,7 +10242,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		 * per-VM state, and responsing vCPUs must wait for the update
>   		 * to complete before servicing KVM_REQ_APICV_UPDATE.
>   		 */
> -		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
> +		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
> +			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
>   
>   		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
>   		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
Looks good to me.
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

