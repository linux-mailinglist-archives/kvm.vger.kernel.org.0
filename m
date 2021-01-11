Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4E2F19AC
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbhAKPbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 10:31:13 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:25313
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727824AbhAKPbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 10:31:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uv+WkrxMHudJAomvERu3sv1rX7q1fy+j1nJ9ZDpmwETj+E3tguiSU50GLv8GqbZrV7zeEect375mDWNFjz/ulAN5Hr1mqEv8URElDtl/CO0g8PqfQ/Q0ABkbKOfpfdhZ6IIZpNIuYG5hIzx9SU8fGigLUxAUNx1Uwp/caTux9RdnFq7LbtHs/eBx8ptF4to1SE1lkI0jhQdr/kePxivLK+Ij2qtPHSZCDQQTVY0Z6Tjxv0hfsAN7QR8cNtQ6sw9q/ZrRGnfSrrnWKBtZ5Xb6ojwaGD+ew4VsORgXdvD/9gMEdopUOMG/AC7UUBjo6lsWQavdGT3x6cwsot0jpMgxDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtkFJvIVYxXxO69PdWAXKYBK6E/s/rLqISBggdd8h3s=;
 b=j8hiQ6q1FYFvMYSpV0nTG7UIC8EyVqmBcz16jGyhmu3s2dhcp/vpWb2GLgpGezbJ1r8ECUR1fP64irYE7IR4/Ghi3q4WU2wcJ93jNmfL78IBnBr4UttpP4ScUo+qGMf1EtcfhYcBjvnmJ1q4snQH91jBakBIsyd0T+zsiazcIhLLbCBqiZDIWpOO82VREfvOR8h30TnupPYhZmSZCaSB0IW6yFhEvo4HzRtI3U1zp6UDnByh2mGtuvrWz7CEQet7qktdZeWpuNIu5Vi7ITMBNqoPUwkNMHPSiEYYP2SeHLiG1guA3FtV8nEHHESVHuvdBOLn8ae5Ua3juc0j1gwMpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtkFJvIVYxXxO69PdWAXKYBK6E/s/rLqISBggdd8h3s=;
 b=y6PFIZ9bL1W0fkIQonvccz2GM2heWsjLzKevk+bkYbkjLUkjjTQ+W/SRL1WWWRAgElWlFo43zTJEV0OsRIEcSXKAb2+KJNAwBZZ3xxx//igXoQLEX4sX5d9z5vMldHTSVDnA04zkpcT4MtjA2xFtY4VfrgRyOcZSY1ZCNEcf4wU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3468.namprd12.prod.outlook.com (2603:10b6:5:38::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.9; Mon, 11 Jan 2021 15:30:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 15:30:19 +0000
Subject: Re: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-4-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9b121aeb-2aad-7581-088e-a8f0a85ef85f@amd.com>
Date:   Mon, 11 Jan 2021 09:30:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210109004714.1341275-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0052.namprd12.prod.outlook.com
 (2603:10b6:802:20::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0052.namprd12.prod.outlook.com (2603:10b6:802:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 15:30:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f672334f-8123-4245-0014-08d8b645cdb3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3468AA7D1B0A7A39B006694FECAB0@DM6PR12MB3468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baxS4nDzYYxPEOJ6KiP8DReJ6D504cxbJ8d4cgEurCl5cDILnmHdhYk/wxVHhVBwVAiuDvODzfuop2eJLz0HE3rGzJr9hVAyj8T2KYbYJM3BGNFrfUsr4Ao5BI/8IoBr+hEPSOlotcaXp6gsseWHzvOzKr6mbtmuMOBQYmlrZQeM5wiDD0mOBEHElzVTaTTrpetqWwDUla7469V8HJU1Kqo0ZEznD6GuF1WUg1rw8Lv5+Ev5iujzQ/h/WzLQZ31+mnhhkrETQgV7WhBi/RfVT0VVZJ0rIZFm7TNBVMAe5immqFG79YhUuYxSLdimaCvdqixyUUUC1RX8bav70Md5SDQvOix5Wxjypu6fl0vkTg3eEagJqE7JOVBpR/fc3fLIOqFUOyqxJqEkQT0BFgAfGoEpTGrlN0bob7C2wCRSTFZxvHeJeqz1P/nFp3NJKoqCD3vz1geXUcmPotRlEq7/YXb3HtaomVE53PfM3Hwv1Go=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(36756003)(6512007)(2616005)(53546011)(52116002)(186003)(478600001)(5660300002)(316002)(6506007)(6486002)(31696002)(8936002)(956004)(31686004)(83380400001)(66556008)(110136005)(54906003)(66946007)(86362001)(26005)(4326008)(2906002)(7416002)(66476007)(8676002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?KzA4YWhndm9zMk8yU1RXNVFYTjVjK2MxQzBsQkZDZU5ldmwzU0R2bkEwR2ZF?=
 =?utf-8?B?dFAzaisrVjAzL2M4bjNUVzhHY0FrSkQvTThReTJwRDRTeVpvd2wwTVlsamZq?=
 =?utf-8?B?emFwdzNxc01DcWFsUFZ0YXBVdlhLZ1ByNHN3ZlFqbFR5N2ZnWUJ2QWc3TUVz?=
 =?utf-8?B?YTdnOTV0SUM5cTZWRTF3c3ZxbzIrcW5JQlNWNGJkZktJM0xSMlNtQkxIM2cv?=
 =?utf-8?B?TXcvWWdjZWIrNER6aG5jTG5QdWNFKzFQSThxb3Y5QXFWanZQdXcycWt5NXNq?=
 =?utf-8?B?U1hrQUM0MmEraU1qbEE4VUpnZ01nbzBrRk9PMFRqbGhOUm8yM0swb1E4OVJ4?=
 =?utf-8?B?UGsyOVRXb1ZHbnM0TjZwMnRuYlNaaEJPODZFSitWNlA0cktZTUJOQVA2VzVt?=
 =?utf-8?B?ZmFpVVppbVprcGhUMkZ4dk9rMUpvUnlDdUE1T05yN1cxamhLQW0xZlFxYUpi?=
 =?utf-8?B?M2lKMlhldzc0VVVhTyt5NnVCaDI5M0RCZkR2SndWYVdvWXRDeWNUdWYvSDg4?=
 =?utf-8?B?ekhmNFgrYXdaTWQ4THoyZFZVOEhxVHBYOW9DRHNlOGk1eXBPRHlhUE9oVHE3?=
 =?utf-8?B?Zk5MV0tRQmV4eFNyWnpkaGFQS0w2cDBSSGNQRG9jdW52YzNLMmtsK3lCUVVH?=
 =?utf-8?B?b1VGS2Q5U1FsTFB2Rkc2QTJYNkxkWjgrQ1ZYSEZTREJmdklFeEptdkNIaVhW?=
 =?utf-8?B?T2lmK2Y5bVRVeW9WWG44cDBFNHcya0dHaUxMZGNkMmpDdFFIRXBCOWcwNXI4?=
 =?utf-8?B?V2VLeGFXekhFS1pkQk5YVGpGclRyNkVxT003anhyaEFTakZDc0ZVenNGSll4?=
 =?utf-8?B?d0NkU1B0VEMrNTJybkw2WUdCWFBBZHVoc1hKWkVkbmhuTm1VZ3FhRGZ5MGFm?=
 =?utf-8?B?TTdyS2IrYVRKWi8xV1Q1MjNJNzZhZnJYeXBoTTdISVNhMTdlR2cyeCtMa2VS?=
 =?utf-8?B?Z0NpYlZMbjM0SkFReFFSYlZMTTg2SW9tTzU3R2hvUkgxSEFUYWw0RUI3bG9m?=
 =?utf-8?B?c2p6R0wwZG5lK3VGUitiTTF4M2JFRENKYjlvMXZhakdTSjhnUEs0dVlaR01v?=
 =?utf-8?B?bVp2SHB6TjhtSzI5L1dmNXpKand4T2p5eTJHK0lGL1JaWDBPVG1UOWxkNDIx?=
 =?utf-8?B?N3dSTE1UUm5jTjEzcmVOV1lEUFBUNlpzVC9VNzRWeFhnT1pCdXdzZUJueWo3?=
 =?utf-8?B?NStlV1BKb2VNdTJlRFdOVEVVemp3WDNZcWk2TlI1R2pHTFRWZjVtN2dYWnVk?=
 =?utf-8?B?ODltTzNUTWUyN1VoSlQ2RTdaS0l0NkRIL1NuWHR4WlpYUFBHUHhxSmh2ank2?=
 =?utf-8?Q?ltMoiwkUJNlCdE/631r7M8cNp8eAGMdD92?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 15:30:19.1764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f672334f-8123-4245-0014-08d8b645cdb3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIV/qFM2VBd0ioQKbANh0vOqtUQIFeDfqr46wl0Fq1/kQeckM9ER5LNcwWvG4ksWD0Juzt0hAhTKaDWATYMFBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3468
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 6:47 PM, Sean Christopherson wrote:
> Unconditionally invoke sev_hardware_setup() when configuring SVM and
> handle clearing the module params/variable 'sev' and 'sev_es' in
> sev_hardware_setup().  This allows making said variables static within
> sev.c and reduces the odds of a collision with guest code, e.g. the guest
> side of things has already laid claim to 'sev_enabled'.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 11 +++++++++++
>   arch/x86/kvm/svm/svm.c | 15 +--------------
>   arch/x86/kvm/svm/svm.h |  2 --
>   3 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0eeb6e1b803d..8ba93b8fa435 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -27,6 +27,14 @@
>   
>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>   
> +/* enable/disable SEV support */
> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev, int, 0444);
> +
> +/* enable/disable SEV-ES support */
> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev_es, int, 0444);
> +
>   static u8 sev_enc_bit;
>   static int sev_flush_asids(void);
>   static DECLARE_RWSEM(sev_deactivate_lock);
> @@ -1249,6 +1257,9 @@ void __init sev_hardware_setup(void)
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
> +		goto out;
> +
>   	/* Does the CPU support SEV? */
>   	if (!boot_cpu_has(X86_FEATURE_SEV))
>   		goto out;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ccf52c5531fb..f89f702b2a58 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -189,14 +189,6 @@ module_param(vls, int, 0444);
>   static int vgif = true;
>   module_param(vgif, int, 0444);
>   
> -/* enable/disable SEV support */
> -int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev, int, 0444);
> -
> -/* enable/disable SEV-ES support */
> -int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev_es, int, 0444);
> -
>   bool __read_mostly dump_invalid_vmcb;
>   module_param(dump_invalid_vmcb, bool, 0644);
>   
> @@ -976,12 +968,7 @@ static __init int svm_hardware_setup(void)
>   		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>   	}
>   
> -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
> -		sev_hardware_setup();
> -	} else {
> -		sev = false;
> -		sev_es = false;
> -	}
> +	sev_hardware_setup();

I believe the reason for the original if statement was similar to:

  853c110982ea ("KVM: x86: support CONFIG_KVM_AMD=y with CONFIG_CRYPTO_DEV_CCP_DD=m")

But with the removal of sev_platform_status() from sev_hardware_setup(),
I think it's ok to call sev_hardware_setup() no matter what now.

Thanks,
Tom

>   
>   	svm_adjust_mmio_mask();
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..8e169835f52a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -408,8 +408,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
>   #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
>   #define MSR_INVALID				0xffffffffU
>   
> -extern int sev;
> -extern int sev_es;
>   extern bool dump_invalid_vmcb;
>   
>   u32 svm_msrpm_offset(u32 msr);
> 
