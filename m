Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0732F6D36
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbhANV3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:29:52 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:54880
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbhANV3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:29:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdxgqAOwUqULbyQmlS3X6E3Y4Mel8PaS2lkEfRItdN9c1A+Gs/STxn9n6MD7Pe0qp83WSnRchYvAaKVxMdj94e6MaSmMCZanCKVPRsR/IZuL/1iF8BFyKF+BqYxS5g7E/sEKMDYYJ8j1LOmJKa7H2odD9JCk2hWgcvofT7iGRSp7JFYrNyl3tBd7HbqUuvigVVf0fqHPw6hZqdRkYQFy+Wozkhu1SMzf9Dxz6H0nge03+KdyCgatRKuZFm3WaWlH9jwi4xiFH10KUgaonQwKUOPfj9F6mIIkGoVusKCG1vUMCZwy5clmlcdwKLFeYoIxj+LHKIX/CXc8kY2hg5XiGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGkH4XKHQXBBTfHKiw2JyRzV5AZvg3nHhC2n8zNBMiw=;
 b=Kz3qldLzu21bDeBuDCVxsRLW9dInuXikIQbtpSd4xvTRWUAvJAw2HN9Xh0k5Jfw5BWRhcbtHRjaepLblUn5yACJ6T3OuBuKkUjZ2wy9CuS56pA+wPIWSADECETKhocSh9ksPrIxfY4s8AkJ6xfbwqqCs7VAfBtdrMCsYBA57cpNdcWFwMe0jZnxXXPW2/l7hWdnTAPDvkQs/2uLjfzwzDNs/gBXJcPsgsad2p8fx070WpxCMrMCMhmGFabH7rnitELCkg/dobwTf0A7Wu8vlWJVKuwPON1ivZZXFUcd2Ow3LYYWJs6kfXJKpGCIHvxVUDYO9yn/xDsmStDsOcKXrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGkH4XKHQXBBTfHKiw2JyRzV5AZvg3nHhC2n8zNBMiw=;
 b=Ii7yL/vk5ZlQnw4ire84zdlEkDDyemz6UCzn6D7dIHi+1O0Ob0f24CE7cHlbzwgt7CnZxfujXGIStxFkOTO8mFcs5bRuglRjxQFfmLq/aexS6Gf5cgG8El2WvikGT7sJNmgZdO1T/UQFYCaFQMGOe6w0iImjuAGElOKk/kUGtMA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Thu, 14 Jan
 2021 21:28:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:28:55 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 08/14] KVM: SVM: Condition sev_enabled and
 sev_es_enabled on CONFIG_KVM_AMD_SEV=y
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-9-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9884ea36-0a6a-fb21-28a5-7c65d36c6ef6@amd.com>
Date:   Thu, 14 Jan 2021 15:28:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0002.namprd02.prod.outlook.com
 (2603:10b6:803:2b::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0002.namprd02.prod.outlook.com (2603:10b6:803:2b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 21:28:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a9f355a-2e0b-4a9d-aab5-08d8b8d36554
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451049CD7A4ECBD7F09A3AFAE5A80@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2+ANoLr7qwFUcqJpCCG6IBIlnOMxgtrOYkpop+ZxpEaz6UByQ3tdhGdwNMNxsi0xSQcL1u601dYvegrcxr9Iub+EQEcbvosZ0R5KcaDTbUb3vxDmfaGZGdUB+X0VlQbrftaGn0oE/qUcTVDj1Dh53vTSB7VWIais9lTLNi/08O236zhQELpeg8jyXnAHMgHLHKkEKP/VVZYo3S6nM9lHxokVM1y0cICXPhGLf/rCPHXsdAQnVHe4esQGrqwIuDvyy62ysjsnjtQ0+r0vSpfQyU7e74+HZvCVkRksidpWneU8u/O542hMcXFMsOyvf6G+YwO6aUaVYUNyr21ImRZGcusif6YyB3+GjqDU7k8dfrIqj4P8C+g79dEQLigDfBfNoWSjIf8FqVVyiyYBdk+TCb+mRhK4IgxRQlSXaY4CthZqlyj3MtQeoCP/1kTdfOc3LXJNjhMSp7bB7tBHKYKjfqRAwZs3zJfNXoyzRcHm00=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(316002)(86362001)(110136005)(66556008)(66476007)(6486002)(8936002)(52116002)(6512007)(66946007)(44832011)(83380400001)(31696002)(8676002)(956004)(53546011)(6506007)(478600001)(4326008)(31686004)(26005)(2616005)(54906003)(36756003)(186003)(5660300002)(2906002)(16526019)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QkNpdTBUWkhhODlsMVlzOUdRZ29wZFVoMDE4N0hnUGxTb2FpSXl1RWR4OW1i?=
 =?utf-8?B?TjR0bzZKTlZZVnpTUU1pREhsOHJuc004NDA2Tzg0MDBzVU1sTnZnSHkzbzRl?=
 =?utf-8?B?OFBDTUd6b1haNEhrK2lvZ1JET1RsdU4xbjJuRXpvZ1VIL2Qwb3F6UERBeGhC?=
 =?utf-8?B?OWxXMnhkWkFiNHFoS05PVTV1S1FNRzNtclZjSVc5VVN4SFVKdzNKenVRekla?=
 =?utf-8?B?Vm1JanhhSnVGSytVUVdCY0QrQ0lXTDBhRWNuQVpGdERzZWxHZW44dEVYWFdl?=
 =?utf-8?B?dWxuRTQ5ODlvWGF3KzdaMjNqajNCYXhvK0VBVnVtN2phVU1xVC92YVB2azlT?=
 =?utf-8?B?QWxHWXVWNmpEWks3ODdWenNPd0ZLTC9rZ2xHWkJLM2ZyZTFqdUo0YVl4R20z?=
 =?utf-8?B?OEtmMldlOXZWa1l0OU5JZldXd2kxSmFMWlh0SGpwcHdQbHVEQTE4MTJMUGdy?=
 =?utf-8?B?RFJLcDhlMUo5aXZIaDREanlNRUl6MmtrS1dHVjZhbUFHc3dGRFJkdU9VL2FZ?=
 =?utf-8?B?SHRLSFBhb25BdVU2WjZKc3d4RXZWR0dvYk5uMy9RUDZvcmJIajkwTjdMOXpD?=
 =?utf-8?B?WUVqY0RBbmtHTXI2c21oTHlWTklWVklaZEI4ZEt3ZDdMMTNKNlV1bFJxU2dC?=
 =?utf-8?B?WE1FZHQrNU03dFFkNkYvVWRqVHFQRm1mb09xR3h6Umlja1dDM3FCbmZlRkZy?=
 =?utf-8?B?UVVNMFN5RlYzbTNGVkw1QXZjWjlpOVl4ejZyV2pLVGtuQXEvYkxwZ3grOXpM?=
 =?utf-8?B?WHFsaXVtVUQ1Y2lTSVBna1FMdGZ2aWczZytxQjVDR3BFQVhBYkdMNmtiam1Y?=
 =?utf-8?B?bnhDLzlwSVUrZDhYK2kxRCtyMURDdjZkc1hUZkpSeHZ2bDN2UzJ0YkFnZHpF?=
 =?utf-8?B?aU44Vlc2VmNIcUo3aDBtM05JMUJXaDdRRWdFWnpPbXI3d2VzM3gxZVdDeTgx?=
 =?utf-8?B?QnJsY0w1Rml1L1QxZlk1bGpLMkNSc2hwUTRCV1l6ZTBkLzZrMFhibk4zNjMv?=
 =?utf-8?B?TngrWlAyclZuQ21qRTMzZFY2NjhhanFMT29IdmVoKzVwZHNPOHdzQU4yakx3?=
 =?utf-8?B?S3hNbmY1RWZZRWRuMGtOOWhvZXBaZzQyN2JZOEREcmpRRWtLeXZPZ29ITEFq?=
 =?utf-8?B?aXgrN3p5ZVVQS3hjSkt2OUwxNy91ZDk4YjF0SzNNQ2tVWDByMzB0YTlvdi9z?=
 =?utf-8?B?Q2w3bjUzOTlZSG90Z29iWlc0VkFIODRVSXU5YXVUNkthNVFCanFmRkNrMVV1?=
 =?utf-8?B?WExSdU1xajBoOUVhZmdlbWdlYklzVlQvOG9Ic2tIWFU1RWdOSFVvSHo1Umo3?=
 =?utf-8?Q?j/SLaYZbkclCObWRLMppWVFSL/g0KgYHSV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:28:54.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9f355a-2e0b-4a9d-aab5-08d8b8d36554
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhmwhTg2GhJa7i93C+Qz5YxTYUN0YDFq28h/rXSYBEQWPvyKa5noMahEMavGsL42u68c30ytAdIcz0myTBkdjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Define sev_enabled and sev_es_enabled as 'false' and explicitly #ifdef
> out all of sev_hardware_setup() if CONFIG_KVM_AMD_SEV=n.  This kills
> three birds at once:
>
>   - Makes sev_enabled and sev_es_enabled off by default if
>     CONFIG_KVM_AMD_SEV=n.  Previously, they could be on by default if
>     CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y, regardless of KVM SEV
>     support.
>
>   - Hides the sev and sev_es module params when CONFIG_KVM_AMD_SEV=n.
>
>   - Resolves a false positive -Wnonnull in __sev_recycle_asids() that is
>     currently masked by the equivalent IS_ENABLED(CONFIG_KVM_AMD_SEV)
>     check in svm_sev_enabled(), which will be dropped in a future patch.
>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a024edabaca5..02a66008e9b9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -28,12 +28,17 @@
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
>  /* enable/disable SEV support */
> +#ifdef CONFIG_KVM_AMD_SEV
>  static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>  module_param_named(sev, sev_enabled, bool, 0444);
>  
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +#else
> +#define sev_enabled false
> +#define sev_es_enabled false
> +#endif /* CONFIG_KVM_AMD_SEV */
>  
>  static u8 sev_enc_bit;
>  static int sev_flush_asids(void);
> @@ -1253,11 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  void __init sev_hardware_setup(void)
>  {
> +#ifdef CONFIG_KVM_AMD_SEV
>  	unsigned int eax, ebx, ecx, edx;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> -	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
> +	if (!sev_enabled)
>  		goto out;
>  
>  	/* Does the CPU support SEV? */
> @@ -1311,6 +1317,7 @@ void __init sev_hardware_setup(void)
>  out:
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> +#endif
>  }
>  
>  void sev_hardware_teardown(void)
