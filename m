Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770A72F6D2A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhANVZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:25:52 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:36033
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbhANVZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:25:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFzUniNVVVj0/2/UhehML/kkNyLxOovKfh/x0T86wgCO83ZX2dcIKK0bTtSYFlasKsxw/7I6LG09hZeWqnY+Qfk4cmXBFtf1f2uqe2OB9CVLm9ZM2K1wWdKf/v1kV9KIeuUht6qb2IBe0hrvrb81M4uouyF3fRwKr3++dEv7B+jl21niNPzjZfrNH46c45BzWXcfghM3QRNRW+7asBtzAk9xF8fqFK7mJJH0H+h0RP4Z9dMzRXOurQXclAV+7wK+0BPz+kaBTSsUz0/8EbrnLtexVdnveZ2MbXgrKAjYKZpE9rXoyTc7m0KFqasFHWIMcKCmYUzpPwJ7YSdF0TXm+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfIg+vXRNPRXb/GedJ/IPlNC6UAEnFqCVdtgw/raN44=;
 b=WgzNZDGU+40qkgACym6mM8Hn7TyL2V1/iysj5LoTdWLAG0sSW2wdSVnx5xpEbGs3umtuvSykFEka0Y+iBfq93spFRXoqrmC1hZLPAEBYknER7O07DxJUEcs0JOq/jDIAeCB3GEdFBROy1/C3zCNJy4SPUmhS2CjyQ+V1wf/IfdiqLzrdWdxNJDQsNH8l5TSrnfX9VbdqoRk+E93TvEdyv2uXA5LIiOb2GqZ/i/9s5OnRI22FrlkuBltPXvUBzOwcFn1L+ZSCnllTjB22jlWH4x8njoHOmHlliHfS+Szn6W91EJx9S5q6Z4pen93a1lVtBx/3Qo2b745pV7LBXCPT+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfIg+vXRNPRXb/GedJ/IPlNC6UAEnFqCVdtgw/raN44=;
 b=38g6nEJ7+rni0fwV+tlpOCCKpQJ190yhvjqxLXDT3mmb2OnqvFB1PFOFYb7AK+2tF1F0ihTwb3Hi37PMUHn+w/5msY0J7QV+Fm56eKuuZDDVRDMOUe1g9HEz+uoMkGCKkmSn59e1Uz+rU9dlyktG9xuXUSE8VtGR15LINbjIgE0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 21:24:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:24:58 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 06/14] x86/sev: Drop redundant and potentially
 misleading 'sev_enabled'
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-7-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <58b021e3-6d76-7501-c75f-53b4bb254800@amd.com>
Date:   Thu, 14 Jan 2021 15:24:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:806:22::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0043.namprd13.prod.outlook.com (2603:10b6:806:22::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 21:24:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d0cab4d-e77a-46e1-8b83-08d8b8d2d816
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB241507D03A4160ED9AF8AEC2E5A80@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0EVawHqvTH2WNbgLzEnlDKC6WIdHVSXlea/M1/IGON3AjiV52lcQafFvUCxTIOBaXIkl0yGGU2PzmOM/XPKZcDZskeZSwSvOsb8S7NsSPCrgED/sZti7JFaP4Gesj1VU5EZA0PjPngtJfpwOT+xrd3mBNH/cEv/1dkiXLvr2F06VzLHMTVw3gyW78e/00FzoOHqjitfRvwQ3hs8SckrnOu4yJuJstyqSfwkqqdvtei2srfmmlu3pikWMyCpphR7p4xPAuAAyAPlarWpd0uSmXQZqOeY1unc0kBIgxM/dyvM7nl2G+DWy2qqMf7jWp38jIfby33UAw0erYExYU4rPFq/LTEHx2h7909IWVLj6UKQOlBVbai54zca8PRNx16+8EEORfetcmnzKyx3vB4uUk1bDGpPb8X85SdR+pcQ9tacduK1dmmm8OkzcbapARm1etsQnu+zHtZEvd/i5QAjqDsNuldBPPqiA1vUNHBZ2sd0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(2906002)(6486002)(8936002)(66556008)(31686004)(110136005)(53546011)(16526019)(186003)(66946007)(5660300002)(52116002)(8676002)(6512007)(6506007)(4326008)(478600001)(2616005)(956004)(83380400001)(36756003)(7416002)(86362001)(26005)(316002)(54906003)(31696002)(66476007)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3J6UWhzVHN1ME1zck91ZGxjd1hZQ3lmTEZ4QlprcnpxUUc4UDgvVXpGM1V3?=
 =?utf-8?B?ZktRblNsSEE2MGM0K2ZXdnhPdjNkeENSaFFLb2xkM0FMaW8vRytBZHloRktD?=
 =?utf-8?B?V3A4VERnazRQREk2dzQrY1J6c2hqRGdIbWdCT3pTSFd2MEVuSUx6dVhVenJD?=
 =?utf-8?B?d2FiTHYrWk1hdmNyWTVIdUNaNmxrS1Y3VGpRQlg0SU1lTGtjaVJrNURiTFk0?=
 =?utf-8?B?MEkxdjVYTXdyeVB2Mklwb1BYd2ZhR090ckFqSjJ5ekM4QWVtQmQrOW9uaWZr?=
 =?utf-8?B?bzlOMm95Qjc3NUJpT003OHRRUG96ZlBnemMxYUROb0pQbFdDbkwwa0RYMDc0?=
 =?utf-8?B?SVM0L3UxdFZPZkVRdklFc3pEbG1wRVkwTHhyYWowUzlFTEhkRXZKd3BKSXVr?=
 =?utf-8?B?SzhCNnVDWFZBYkhsaE01K25CT0Y4K3VrQ0lyNzJCVkE3bWx6REt5S2R1Z2ow?=
 =?utf-8?B?eGtqWDNlYUhjSUF4T2gwbHVEWFQ2TEdzREsxQjRkMWVPcmptRjhSdHk3NG1V?=
 =?utf-8?B?Z1MvZERiSUl1bmdZZEE4TWtoZ1l5MWE5Skc2RG93ZnFScDV4MVAzS3ZyTnZG?=
 =?utf-8?B?Nk1Fc2RHYyt0Q1d2TkVmamFMSjRVVnIrSXB0ak5rRVgwazhLdHc4aGtYRFZr?=
 =?utf-8?B?MGpiN0xkNU4xT0MyR0RpUEpvRS9DaVdmWlRWcFQ5V1RnK0wrR0tmNVN2aFpw?=
 =?utf-8?B?bkF3RWJnZGtDb1BPT0RWZmxway8vcXBNQWNOYk5xazh6VjIrcTFhclpYS25x?=
 =?utf-8?B?aE1SN2dhT2x3bDRnZW5EVlEraWlhV096MDA2VVRJTEdZSFFldHFicHMvTXRY?=
 =?utf-8?B?bXY0cjArcHowZzlRcndzc0phaHJvcGRLZ2xXYUNRZUJ3M1QxNnVoN2F1ZTRC?=
 =?utf-8?B?dDVsM1MrQXEyNzZ3OWs1TFhEd2hpbVlYcWI3anFrQjhoTlQzcTk4bmJwSytP?=
 =?utf-8?B?WVl4STZnZXd5bnJHUzF0M1M1SUxuZmNWSXVpZDZVdGJXc0FWM0hxM09SRkJN?=
 =?utf-8?B?aTRCOEN0K1N6U3gzSzhJNmJ4ZnhFV0hKaXJNWDBObkFjM25EMG1tWnZBVXpw?=
 =?utf-8?B?M3ltdmQyUTZvWkx5czUxWmE5em1TcFRkTWpkSDhJVXIvdmIxd0M3clFRY3lP?=
 =?utf-8?B?OE1LOWx1QjRpTUlCWWUwYkgvc0M5SThEQ2tIWHN2T09ucG5VY0JaUlhTd1FT?=
 =?utf-8?B?QlNwbGUyc01UMko2WWwyTDhkWnMrSC9zY2FSVTRxOVNVSmlMUXRNMU0yZXo1?=
 =?utf-8?B?RVBoUjh2RjJnWWpUeFZFeXBXVVlHTDVleXI2YkltZ3pTNDNQM250dVE1bU5z?=
 =?utf-8?Q?znfiAT6ndHItn2YIpCB32aIk46r0WcxDBJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:24:57.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0cab4d-e77a-46e1-8b83-08d8b8d2d816
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KL691eN2H/Cf56vB0WGhWHEuj1aAxJpQeE5zm2/sx42KGetNoz5+grVc19V9TX248WwvSBePqV4SKVqRI1iQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Drop the sev_enabled flag and switch its one user over to sev_active().
> sev_enabled was made redundant with the introduction of sev_status in
> commit b57de6cd1639 ("x86/sev-es: Add SEV-ES Feature Detection").
> sev_enabled and sev_active() are guaranteed to be equivalent, as each is
> true iff 'sev_status & MSR_AMD64_SEV_ENABLED' is true, and are only ever
> written in tandem (ignoring compressed boot's version of sev_status).
>
> Removing sev_enabled avoids confusion over whether it refers to the guest
> or the host, and will also allow KVM to usurp "sev_enabled" for its own
> purposes.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  1 -
>  arch/x86/mm/mem_encrypt.c          | 12 +++++-------
>  arch/x86/mm/mem_encrypt_identity.c |  1 -
>  3 files changed, 5 insertions(+), 9 deletions(-)

Thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 2f62bbdd9d12..88d624499411 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -20,7 +20,6 @@
>  
>  extern u64 sme_me_mask;
>  extern u64 sev_status;
> -extern bool sev_enabled;
>  
>  void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>  			 unsigned long decrypted_kernel_vaddr,
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index bc0833713be9..b89bc03c63a2 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -44,8 +44,6 @@ EXPORT_SYMBOL(sme_me_mask);
>  DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>  EXPORT_SYMBOL_GPL(sev_enable_key);
>  
> -bool sev_enabled __section(".data");
> -
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>  
> @@ -342,16 +340,16 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>   * up under SME the trampoline area cannot be encrypted, whereas under SEV
>   * the trampoline area must be encrypted.
>   */
> -bool sme_active(void)
> -{
> -	return sme_me_mask && !sev_enabled;
> -}
> -
>  bool sev_active(void)
>  {
>  	return sev_status & MSR_AMD64_SEV_ENABLED;
>  }
>  
> +bool sme_active(void)
> +{
> +	return sme_me_mask && !sev_active();
> +}
> +
>  /* Needs to be called from non-instrumentable code */
>  bool noinstr sev_es_active(void)
>  {
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index 6c5eb6f3f14f..0c2759b7f03a 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -545,7 +545,6 @@ void __init sme_enable(struct boot_params *bp)
>  
>  		/* SEV state cannot be controlled by a command line option */
>  		sme_me_mask = me_mask;
> -		sev_enabled = true;
>  		physical_mask &= ~sme_me_mask;
>  		return;
>  	}
