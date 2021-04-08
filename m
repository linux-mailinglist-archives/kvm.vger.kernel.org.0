Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95C7358B37
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhDHRUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:20:11 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:9200
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231676AbhDHRUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:20:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWMHW0NldRFgCLmrrrT5R/Ld6L3hIP02raz1NYxtA9OXNNoeDos0XQ3tBsRn6RLbXSyix7AaYyo5jpU4DrB5L+Ed8B2UlxlBYQvaDFqDOVrTPjD8MwxWsxROBAM7bom48LwLAVbzH4fFfE1a0uGCb1365wZFWnUt1Y2zZdMruf4uadAwDeE8lnilAjunEoC2sH9CfJO/ur5uba5rHxNh0jSrcPF5CTU/n+ZjGasYrCpgjleB2jbplz8oRTn1hazZYr8UwYC/mM1JCnaG9UehJn6a1edPymZkoeBYgu03FwqfWj6ox+LcwGdk8tufYYW3adKGbNqrPPHLFf5pdRgM6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcb3wfyHrVhTVSA+2pgZv29jRPYNG25Tsww/RUsUXE4=;
 b=KwXJRwwFbPe0adRmMhA6ZVzQvd3YVuwu+BuNmdYY0rMlIDuTpcBqMqfjFL4ZqzsMez0AWT+ttcCXbNLLLKJLPEPWjSHe+qE+pBC+4cyKBtyKpYfKGKpHj8B6WSyc0HIVmSy6khLiL85xPF5zwk89qNucp+LcwFeH535c13xqzKLsQwjshGu8DADDrS0RcbzSlOj3OO+8Pp2IbGD34yZ6Fw8m1QeHGiyZvpjx0DBxHlBr8M3z6xgZ9q2ZkDOH2noyF8nKadHgpJ0QY6qd+jfC6nQcnBBGx0svs3kW/pWUz0Cey78W3wQmyE+BPzdOKzLwbOGVwa3kAYW5TTnGwE14ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcb3wfyHrVhTVSA+2pgZv29jRPYNG25Tsww/RUsUXE4=;
 b=oNL2hN+qoKoc9RhjQLBIcuC54Bp/cFNrs6FN76UjNC6jMr+t4o76mKCkFOMnhuPNIn4XS76MU7ZSn+5wuCHrgDhgfHT2Z0DDrYfuwXCmnpj6VRAs46Pt+DRJd2fg4cCHSrbMJu3bzCIninCkYqlQy8ocaXvwGgJLoAp8qiDjuDA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.20; Thu, 8 Apr 2021 17:19:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 17:19:55 +0000
Subject: Re: [PATCH 1/1] x86/kvm/svm: Implement support for PSFD
To:     Ramakrishna Saripalli <rsaripal@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210407194512.6922-1-rsaripal@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6514c479-4b7b-4902-632e-54f3eaf436d4@amd.com>
Date:   Thu, 8 Apr 2021 12:19:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210407194512.6922-1-rsaripal@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0801CA0009.namprd08.prod.outlook.com
 (2603:10b6:803:29::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0801CA0009.namprd08.prod.outlook.com (2603:10b6:803:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 17:19:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f586c84-6aad-4dab-a9e9-08d8fab286f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42977DFAD89FA6E5BA1E2450EC749@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzCT30RccTAKyM1qp55pvEUaU+MUV4OTjp38SitFMtcAacrY5CnRrjUYIfwexpTX7ClLznMizvExkgLrb7ACZmRb/0P4fuHtRgqMjEWlxfM9tD6ppKLip1l1hIttdOv5+2zOLa6UuZ+sRFsmcwlnkQb5LnhFjVTjytOQreCZ1PeNieJJwXUiZrqIoubvhlmSAPLg0sGckR0n4sFhARWAWEgGFQHfsZSvtx5v8RT52JzWz2L0BIi5AsXEz6NMz/L8P5e1+5y5Lwui12aFRnkP9ZKbzUXpvaMtrs6k5kXIoZcGU9cNHkqdhJoLAeBsvFsEbHu4WCcv4nHHgHjrj0oiNuOj7qpKyAzC8e2WfUKlsfnOgAKVb2nrIwY1icaBBfSrEr2wF+iBF/uCR8UH9OA2nlGeqBGH3PE3FRCvMdcDqZ44NqzruVFvjlQ6ltf6WMVPb+KZrhI2TJ+FcgyP3w00vYHf0V+K55UMhOsjpvhGChPJV/+VCqVXflZzHDSPTlbMqUcyEb+r73wsONbL/Z/QzO81lqSdWHt6g3ewG98a8bbiZ7H90cd1Q5765mxyFREXFRaNfdvClp24wWJhF8RhvXlqOPXyr9xagQO1eotcqhK7PivycB4iB6RhJRs46sFxLmscG7q5AYCrQTQ5wcMETldRBDM8u4sa2idg7u8zc5mOOggQM/zgd5oPz1vpOvM3nMTJgoGv1zcQpxqTnJypdFpae5rmtQFxpRZlLnaW0N/o4lDYdUXZg/4lJvqF1rl7Hv3uS6LiaoEsjGgIYyV46+yqMHl5bj1379WfhWAkQB1Yl5rUrj7ghMql8e+3GgdK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(26005)(186003)(16526019)(83380400001)(66946007)(316002)(36756003)(8676002)(6512007)(956004)(8936002)(7416002)(2906002)(2616005)(6486002)(921005)(31696002)(38100700001)(966005)(478600001)(86362001)(5660300002)(66556008)(66476007)(53546011)(6506007)(31686004)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N3lYMVBHWlNtZVZzR05yUzlvMmhPQUVyN0ZMTjF6czA4bXVIZUpIMktBK2xp?=
 =?utf-8?B?dUJlcmkrSTZTVG9KYjNQSVQ1cC9COFBEWHBLaEErZFhFaC9YZlVKT2hlZ1dq?=
 =?utf-8?B?bUR5bG1oZC8vTnM5MTVnNGNtWFpWYlBoNEFDNDg3bEltQks0M2ZXOVAxbnMr?=
 =?utf-8?B?WURCSzlObllYUS96L0VvdFRMTHROOGw3R2wwK2ROYklEbHZCeThEME1JR1lu?=
 =?utf-8?B?ZWh1WnFYTkFxS3pueWRJTjR6N25JNzg5Y2RJYTBramh0TGxUY3dTZi9MNC9V?=
 =?utf-8?B?Y3NDcVVlcVN6VFczb3BNZDcwSC9QMlpjTjBRRjkyNm9EWlJOendMV25YSkhG?=
 =?utf-8?B?Y1hxNG5JRDVhV0lXc3gwdmIzWnFsUDZrckgvS0sySUN1eW9TWW9uSFh5Q1or?=
 =?utf-8?B?ODZtNTA5ODY0a2RlSW4vb3FESy9qVFBSMWF4SEpVbXVxcldidEJIWStxVkJT?=
 =?utf-8?B?ZXRFZ2h3clljMmlDTGhKYjcwVDhoWGZmdWxBZEg4SFg0eWxBVWlFNEoxanp3?=
 =?utf-8?B?R3lBTURCSGhHUzR0QzRhaG05bmJiZE5XWG5taExlNHlhaHpHZGtuU2szVFhO?=
 =?utf-8?B?MVh4RnVkU0w5U04xRis0SGZEUmlyKy9paGQ3dWp4bmM5ZDYrWk1uSklMQ1U1?=
 =?utf-8?B?ZU9vT05WeU4zL0ZlbGJlcmNrWWVvcm1pYW9ZZTNGeE9OcWZ0Sm9vdVFKdUJS?=
 =?utf-8?B?TFRKUy80ejNEWitPTDR0Mm1ES3AzaDFYYjZPVk5YWFRYSmpMMmtYQkltOU8y?=
 =?utf-8?B?T2VMb1h2Nk9aNDFaVWt4amhmMTVRWHdpUlhxY0doYk53aUZYUlFJRVdYMWNm?=
 =?utf-8?B?OVliZEZIdXdhZy9ZMEJ4TjJLc0VzMlpqRnJLWENFMXplbmtmRFZlczdOVDNJ?=
 =?utf-8?B?ZHE0WDNmamw3ZmtyVWZWMXNOVzJYQ0xrUW5YaW1iUCtDTGw2Vi9NOVM5cVV3?=
 =?utf-8?B?SjE1cmFUYmpkTTVXVlc3MWxzTklXTTNaSnhHTXIvVldhYjZMajVzRFpSM1dN?=
 =?utf-8?B?Q0lSWnlFWkZZMDZidkFrbjZpL01vb2Y1MFFVWmtnV1J1NmFHVldLRkJ3UWdZ?=
 =?utf-8?B?eDdUaWNFc1FPdXJqYmthTzZ4RXArcGRDdUlRczZxaXo3ZXgxVElCQ1UwQ1RJ?=
 =?utf-8?B?a1U2cFVSVXF2d1hHanYvU0xYYmVjL2lubWpyd20ydDBPNStPVGUzbjNEZGgy?=
 =?utf-8?B?OWNMYkh1U0ZOOEhEZGY1NUhmTnRDUlE5TXJtVkxvc1VuMjMwOGtSN2RuT3g2?=
 =?utf-8?B?ZDhiUHcxWFlCYXZJcUxSekZpNzhpWXZKTm8zWXJVQURpVDRCZC9SUW1wTjRL?=
 =?utf-8?B?ZG9ZNHVUb0lKbVJOdGpLTkVFRFFwNkNsWm1YR2lKU1NnTmFkOTdOUkoyL1k4?=
 =?utf-8?B?dzluelZLQnR5SUFva2NGT0V6OHVFMmVLcjBUcy9jUzV1MVc1a3RrWjVaa0pI?=
 =?utf-8?B?NE1ZZ09UYWZUSFRmd2J0a0RraFBnVHliM1F4bkdSYmdMd3RQQ09hVkVjUVps?=
 =?utf-8?B?QlpyZm9BR1JDZHJsb0lGNFBNUng2RU9ZZVEzMXBsb0NnTHhoQjhtS0hRWFk4?=
 =?utf-8?B?YzR6T2d4akJySU84ZFY5ODhUbEVrQVpQOGV3ZnA3S2dlVEc5UC9CVGo0ZG9Q?=
 =?utf-8?B?ZURra0dXWXMxOTBMdGt4OVEweWpSUFRsYUZIK0hLTkNnalBLRk1wNDR6TjZC?=
 =?utf-8?B?Y25leGJPMHdNczQ3a3kvcC91V04wdEhma3BEWDMrUWE2V0xxY0NRQUVQUjFT?=
 =?utf-8?Q?0eBFuuM1nTaHyQGBogHTg5jwRq2GSa/+WGMshKW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f586c84-6aad-4dab-a9e9-08d8fab286f3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 17:19:55.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6lkBx1HegYOvBd2W83GDHhREYXdVhqqJyFQqjdQlmbUT9X+OlXoNejoaY05rfxu6k3jgTtIlydbNEPQ/3NmMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 2:45 PM, Ramakrishna Saripalli wrote:
> From: Ramakrishna Saripalli <rk.saripalli@amd.com>
> 
> Expose Predictive Store Forwarding capability to guests.
> Guests enable or disable PSF via SPEC_CTRL MSR.
> 
> Signed-off-by: Ramakrishna Saripalli <rk.saripalli@amd.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6bd2f8b830e4..9c4af0fef6d7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -448,6 +448,8 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	if (boot_cpu_has(X86_FEATURE_AMD_PSFD))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_PSFD);
>  
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX_VNNI) | F(AVX512_BF16)
> @@ -482,7 +484,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>  		F(CLZERO) | F(XSAVEERPTR) |
>  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
> +		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F(AMD_PSFD)

Please note that this patch has a pre-req against the PSFD support that
defines this feature:

https://lore.kernel.org/lkml/20210406155004.230790-2-rsaripal@amd.com/#t

Thanks,
Tom

>  	);
>  
>  	/*
> 
