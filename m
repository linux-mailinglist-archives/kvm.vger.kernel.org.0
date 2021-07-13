Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1233C7148
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhGMNiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 09:38:11 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:25963
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236461AbhGMNiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 09:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kag48Iia7ao9eZ3nvRQ1jySFy7MctR9NRfaIyCxM06FSIls43g7FLEPezzluNybmsdrLhR3fS5TQ3zdN71+oE6c4xzeVjAWFs4WoeKkSeoHokfRO8JZMbHnyZE8Y8VaVdsQ4Wi2Uo7rJ0MnPNwjrb5Tw9IWqzuZfWRCJs5nTNgU4AlR1U+GkQDtmYPUmLk+fHKNXUKChcGcb0ADb4HEy+lW90dEFEeBTQl5OONiGRrV92jXOXXBdb3N+2gweOiICms72EFsX63NiJVdf29w/aCz8/vBWhrbYzx39oiIv7KHrptDD57b5v2cb9mPg+YSjK/fCfhqNwlUFtGJ4MNFTBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnQZ2nwjwI5sxvlHhWpJtZUVo3P/PrbeJoCtbkjPJi0=;
 b=JU2wjtK6fOffiIrEfriYMXI3qdN9/QcWNuC1YSMWMwGfN3zvddkd+ZG+yosubFIoLOxlVJCu4qKeclG1OJmLnBdgNlEKEvxOqn9qpGkKsTNM2Js1lL5igQ/PqBxj7ZrVHSUN2gjNVhInP5bpVvGiekhpKSC6KX+vZ4iIVy4AH8eR3B2FUNz5FJXpH8NpX2B8ppJimXosAUh7yDupHs8nAIYKhBggb8xoz7ue5+1EzMHPjdFJOd3EHzhFQDI0zwR/r6ebDN641cumQ0LuaPGpaCQTFhr8n98dbWiF2DNkD7KklMc/JQ0VFkVM/PC7j1gnytFy86zoVAsrPQZ4wqXfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnQZ2nwjwI5sxvlHhWpJtZUVo3P/PrbeJoCtbkjPJi0=;
 b=ggIw2Gevm4lOyWOojphZ+i8aC7Ty/EniaQLUD90DLDY1eJLw7UhY0j/Eov5yIgU5QjP8mxCJmWGW53H0ZRUM+poY76yDr/oKGMQIE6w32wF4CscudptzoF57po+dvgisbe7HCiW9pZYuDupr084tpJUqPHtCHVInRPc9CTy6WKs=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 13 Jul
 2021 13:35:19 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 13:35:19 +0000
Subject: Re: [PATCH 2/3] KVM: SVM: Add support for Hypervisor Feature support
 MSR protocol
To:     Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>
References: <20210713093546.7467-1-joro@8bytes.org>
 <20210713093546.7467-3-joro@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3e49625d-93c8-c7fb-2c91-d5bdc3af0fd8@amd.com>
Date:   Tue, 13 Jul 2021 08:35:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713093546.7467-3-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0001.namprd04.prod.outlook.com
 (2603:10b6:803:21::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0401CA0001.namprd04.prod.outlook.com (2603:10b6:803:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 13:35:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5e153c4-03e4-4892-e0f9-08d946030e3c
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5549B99080CB28C7A123F036EC149@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kJZepwtFgplEea5YdUQ/h90tRvhxJ25iF3mRb530TXlpMSOuCkM51oEUFxK4kQyq5FXtQpzV7f0FxzHbvAlph7JjsX57mQU4B45AOJ+MKJYKBS2TptKnFNKCVXKwEYO7yq4iqdl9eMKxs3LBbs5brcIzQ+Gi0EcCZRDyfBXhvUFMwGA53P6Y6cjAkdvMv6/yM8AcN4KYBEwtKaCXqOc0V4ENyn2MmodKtx2e3h5JeSc9FidcBT2hVLD/fcBthhRym3B/TcDGwEr9cqdcu5+aPQm6GGCoeXsIjTcYuf9/CEPmvVvJDCoR6O4wD8tOuC4qmQReV3829R+pR+FeS6jWc21hzbagsgDp0AWnYDy5CpF7JII7woQ46GJifucpYsGRS/yCx/dFC3TYPFDJCos+kA2NJdOtrKlSGFKF7vUJ1u14htPOffissUnxjnj97cs/yl1+AsBb5jnxE2c6LO/7y0VLIX3pkqPb/ZBEEm+TjYqFSP7TqMprQL+fUKV/5hzcRzDZK6VxQgMxxZwHIhmm5aYk4sQ3kHuWJanj1cpQi1TpzvmBPrxx+KXZAlGFWrpXms5fAoZ+MYiyrFloAnDsGulrwGU2hBy9iwdSbDHGfBOMhhgyeJP8Wk8pmx/cjZuEzgJEkn+qCowSlDGoQ2zqn5WVutJU8mQ0AAKYCjgIYHJZ4fDkFFtsYV82/Cg47+CUNIoocKSfUYRdOIJKKo2bdDBnO+g0ohRa1YYFaSGPGn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(316002)(36756003)(110136005)(16576012)(31686004)(26005)(86362001)(83380400001)(8676002)(5660300002)(53546011)(956004)(8936002)(2906002)(66476007)(31696002)(38100700002)(7416002)(2616005)(478600001)(186003)(4326008)(66556008)(54906003)(66946007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eC90cGI1QjI5OWlraWlGNzJaM2dmUy8vd05zZXBoYUFnaGpxT1JEM3FreU1R?=
 =?utf-8?B?Ky8vM2srTWJBVTZsMS8vVzkwcFhHMlQ1bHJVSlhvRkk1eWkrN3VTM1kxSU53?=
 =?utf-8?B?SUdMclhuNkhHN2pYMHl1OWw5aW5VWWpTSG5HNlVBZHVIbUlGaHhNWnZYVVFK?=
 =?utf-8?B?SUNOSGJiM2s2QmY5MnhDVWZnaU8zbGc0ZXQrTFpLVFREMllFYk92VE9pR25o?=
 =?utf-8?B?eERIN0V3SnIzUC9wdnZuU1ZYeStIWHdvMjJnUmp6b05yWmFjc3FFYk56QTgv?=
 =?utf-8?B?TXhpTU1DOHFmSnp5a2toVlNFdVRKcE1yR0w5c2ZQZS9MSDJDUkZkMzNNd25p?=
 =?utf-8?B?TzNWQUgwUHJuQ2xidHJJWERwaEYva2lma0RKU2dMVW1nRkVSWm9YREQ3RUsr?=
 =?utf-8?B?SWwxV2oyUnNOa0pzc2gxTFEvYVI2WjRMREFNU0pzR0Y1alE3ajZRLzNiVzZV?=
 =?utf-8?B?ei81di9mNy80ZEhUd3RPOU5zRmZBL3NvTDV1ZXVZa0tsWFVZRDg1Mm1uQnZp?=
 =?utf-8?B?UjJ0dVVVRlFrZjkwY1Z4ZlV0SlEyeFMvL0IyaEZPREhRVUpTeGpVU1NVd1Bk?=
 =?utf-8?B?aVN5TmNQVjJwWVg5OXRsQUgrOWtnSEczZFAyeFAvYVIwUTE5RzBuNG05bXZF?=
 =?utf-8?B?VkNOWDZRd01wZUZ3cktxNjB1T3ZqQ2NmMG81Y211QklpVEwrZVlFT2Vydkt3?=
 =?utf-8?B?U0tOWWp4T0kzMUg4b2lCRnZ5bEJGQWQ3Y0g3NlNvOW9PKzc3RVRZL3NkNU5t?=
 =?utf-8?B?TTZybHo2anlhaDFvcEJqZjJPVjBob2IyV1NuUEl6QmRJc3ZCTTZiL2lFaFVU?=
 =?utf-8?B?TXNFb2sxUUc1ajIvZU5pd0E0V0g1NXFWKzN5Z201d2lsSlNvck5YZGpSRnVQ?=
 =?utf-8?B?REpleDVpbTZJb25aOHQxTVpUSzZ5UDdmWHByaEN1NWZNRFVIbldDZktENk9P?=
 =?utf-8?B?UGxPVEdjWFBlTWxUMk91TXB2SmMvdHdidUhBUEdpNjFSNHlMeS94eTYydytN?=
 =?utf-8?B?ZzZqY1g1RmloNXY4elI5YmxPQkxMQmJwLzFpQVJTazZTOU5RbWZyanhqejhs?=
 =?utf-8?B?MjVnR0lhUDlFek0vUG1ONTV0aEN0K2JrdFRGdXpMTHBsd2lTQUltMDBUUUZm?=
 =?utf-8?B?c0tTdEF3clluQ3dqektqOVpuZmdhWm04OGx2VkNpQUtHbGJpUWtERDJWdlda?=
 =?utf-8?B?TVJabTZkTS9iMnQ4TVdRWjJVQ3BCTFJiSFUydmhaVHJoTzJqckVHVVhqNUQ0?=
 =?utf-8?B?Z0hhZ0ZKZlVEbVArSnpsSWtsSDBqY1c2SHR4ZW5JWldQcjUya2ZnKzJySGtu?=
 =?utf-8?B?OTRycDVRTnd0R3k0RldTQ3BidkFYQkpIdGV2b1h1SElPVHdoVHUrZ3BsdGta?=
 =?utf-8?B?RnZ4SjE2NnVLVGE0T1FER2dETzFuMHBMWnRnR3RKUU5NNk9uK0VyZUZVMFdC?=
 =?utf-8?B?LzAwbGMxQ0tnQnlhOUxrbTZRUk1veUFHajk2N0w1MVdoMG5HQXVlRnIyMHJC?=
 =?utf-8?B?UGFZdkZ2TWVsaVNqT2F0UFh0TVhyRVA4czRxdVdDYlhnMW9nNzVPRURyUjlI?=
 =?utf-8?B?Vlk1QTBSUUx3eGw1a0dwRFlUcEkvWmtmK09NeXZQaW9ONDJvM3VGRDNwZngw?=
 =?utf-8?B?Z0ZWZm9iY1RXUklET2I5SHFLbUNQdlJlMys4U3JEMS9Ta2VCMnloTUcvMkp5?=
 =?utf-8?B?U0tRUSs5dnlYV2NYZVp2VHlqVlliRUxHdkxqWVR5Tnk4STQwRkh6c04zQytY?=
 =?utf-8?Q?x3Y/ey9kAz+/Y+x3YeANL2xtj1bPA5h59X0Uzn1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e153c4-03e4-4892-e0f9-08d946030e3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 13:35:19.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFdDQFyLedLc9K1vMq6cm57B4QSPDKFaabbtU1sdV+uZp8WkHaqeubXCrab9gr+w2E90WevpHEu5XC5dH/pb9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/21 4:35 AM, Joerg Roedel wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of the GHCB specification introduced advertisement of features
> that are supported by the Hypervisor.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/sev-common.h |  4 ++++
>  arch/x86/include/uapi/asm/svm.h   |  1 +
>  arch/x86/kvm/svm/sev.c            | 12 ++++++++++++
>  arch/x86/kvm/svm/svm.h            |  1 +
>  4 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index dda34ecac5c0..0374f5687fc0 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -60,6 +60,10 @@
>  #define GHCB_MSR_HV_FT_REQ			0x080
>  #define GHCB_MSR_HV_FT_RESP			0x081
>  
> +/* GHCB Hypervisor Feature Request/Response */
> +#define GHCB_MSR_HV_FT_REQ			0x080
> +#define GHCB_MSR_HV_FT_RESP			0x081
> +

Looks like some of these definitions are already present, since the new
lines are the same as the lines above it.

Thanks,
Tom

>  #define GHCB_MSR_TERM_REQ		0x100
>  #define GHCB_MSR_TERM_REASON_SET_POS	12
>  #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index efa969325ede..fbb6f8d27a80 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -108,6 +108,7 @@
>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
> +#define SVM_VMGEXIT_HV_FT			0x8000fffd
>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
>  /* Exit code reserved for hypervisor/software use */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0ec88b349799..8121b335651c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2182,6 +2182,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	case SVM_VMGEXIT_AP_HLT_LOOP:
>  	case SVM_VMGEXIT_AP_JUMP_TABLE:
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
> +	case SVM_VMGEXIT_HV_FT:
>  		break;
>  	default:
>  		goto vmgexit_err;
> @@ -2434,6 +2435,11 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_HV_FT_REQ: {
> +		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED, GHCB_DATA_MASK, GHCB_DATA_LOW);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
> +		break;
> +	}
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> @@ -2549,6 +2555,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = 1;
>  		break;
>  	}
> +	case SVM_VMGEXIT_HV_FT: {
> +		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
> +
> +		ret = 1;
> +		break;
> +	}
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  		vcpu_unimpl(vcpu,
>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b21b9df54121..77379e1442cc 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -546,6 +546,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  #define GHCB_VERSION_MAX	1ULL
>  #define GHCB_VERSION_MIN	1ULL
>  
> +#define GHCB_HV_FT_SUPPORTED	0
>  
>  extern unsigned int max_sev_asid;
>  
> 
