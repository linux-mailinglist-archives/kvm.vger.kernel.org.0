Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613F72F6CBF
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbhANU6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:58:43 -0500
Received: from mail-eopbgr680044.outbound.protection.outlook.com ([40.107.68.44]:31143
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730271AbhANU6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 15:58:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4VyFDdRuEJy3lzQ6m6SYoAHc4VNIk+hZo299+sAO9y7XLEArwB2qP9UVWHqeUTZPnWURL/yERcblZtkLRoL30C+tMwDSOBGgM59v2Mxf0tp7K9+V1bAnPkziKO6AlpQhzeKhJmV5Gqr6CkY5xcZ7/x7msH/RH48kYavkR8/4FMRsogixvoJsO8AIrJXF8EZe3Lo885EXI4iZKP98eOUhp6ClradX2Pza4+VtR7qkotHxS0GHxX7pif20GYXEfcHB2BKicrwTlqCp0BHoJJM00HSditK66a2M/SLZKAJ94dbrVjh0+7WddZQULAvHXy0bWDleiXqpXCwS5gz6bJ+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymbSXyGpClSwPtyDWIZB/QPAVtW3GgbjFIk1m7oOi50=;
 b=ab2havncNZq3nZhG1q7FTGVEu7V9x0pXCCc7zJsHCsCped++XkfnSIfrLsvAln1HKMEt+/YBAKGuFvLwRgQD9bfyXZRUMGdjzLyduqixomSm7IolMIyfROuAJNu29rjs7jCZmx+F7JqHAtZ+dRk/MpIxQxr0LE8Q5DPePnSf+4v7cfW6u+PPan+QboX7zegqH1V/MnUIN7cqFc7iu1VRkSVkJsAkBwNeFoSkAZZ0aA5CzhPgu6Seqjfocxxo9pqLXBG2d7b9gKca72Ih40VG0soLSaqQZ+bg0OSvUsI3A7/0CypoYt/UjXj0fXEhWNu5QH8O3SYzrsrq/6IncV+tSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymbSXyGpClSwPtyDWIZB/QPAVtW3GgbjFIk1m7oOi50=;
 b=5N/lnzoouDXJf5mip4EG7m4BjSiCEWsVFkKR9L8URMKf624MPm/jkO10Wej8mxC54fJbw0t3yyuFEVlJ5pu4J0FMMW9gD25f0WuUU1OZetMloGeJgFU8e+SJ2Rmn727nsbfqrX1oVoWtkfnbsubFyIkaTmn8IfXQatq4+YA3D9A=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 20:57:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 20:57:53 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 01/14] KVM: SVM: Zero out the VMCB array used to track
 SEV ASID association
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-2-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <6d329b0c-e34e-6fed-8cc5-10b9ece82409@amd.com>
Date:   Thu, 14 Jan 2021 14:57:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:806:23::24) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0079.namprd13.prod.outlook.com (2603:10b6:806:23::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 20:57:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 24b2cc73-94e3-464b-2983-08d8b8cf0f92
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4750B5A9124F91D545BC7CEEE5A80@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4usfC9rHFjqavgJXW8M7evna0iJ+/yHag8SzCw4Y2KnDRuEvXqy4Xc9XUhGg+1yWM77c9pvZAx1yCkIySv6PBNbJGV0PSxlhnFTuBXEWadNr98KlqZ1E4sbjFhQzyS+Y1NURhGx+eYsEhhI0ruxUVnVLYR3tfJJqStaeOTU+fX1GIRDWsmE9WpD/DSNQjYyD7hq3+v/ULlXDTX48ITk2h/x6vxKdIe9Y57DeHQ8meSQxKYlvOJlLwhg9vmCnznhmtGscEalslSXBTaqbzvHyjqio+ys0c+380CgyXelacx0VYYtGJaThtya2sAmPNO7gpKKQdngEVCcnnx9jWOc5kaFc+zR1jkUaP3KRjMPNM1suql+NmYfJfh9sRMEvmt1t1Tql8sKes0NtEd7hmx0a1AzB4q5UYzvHuDLd3nFln/0HmYMtPnA+QsFsQVKq/1WIbnI2D5BXOC0Fc+Gva+8u5Uzg7rn1nCYbHTnjt+exZc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(2906002)(2616005)(956004)(44832011)(478600001)(6512007)(66556008)(316002)(8676002)(66476007)(6506007)(52116002)(83380400001)(7416002)(110136005)(6486002)(66946007)(186003)(16526019)(31696002)(5660300002)(8936002)(31686004)(54906003)(4326008)(26005)(53546011)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RXFROEVjQm1PZFFDTkpDZ09zS2NvWmZsSjgxemU2T3FuUDR6MkJoSGd6cjdB?=
 =?utf-8?B?S0xhdlBuQ0ZETU44TVRGSUxhM2RRRUdvQjFncGxpRXA1Qi9hWjFqZjQ0T2Jz?=
 =?utf-8?B?NlhxNzFPUEVQU2cybVhvOW1VSTkzaEh5cXdPajNnZk1EVFVhU0JhQzdocWhF?=
 =?utf-8?B?R3VSemQwb3BnMHFwVlBMYzhHN2hKNVlNMkgweG9Tbk1RdlRoc25MK1ZRdkpH?=
 =?utf-8?B?K3JhcUxsNTZKck8yMW4vT3k2Y3hRbERHbGpONmp3UEtJOHY0Wjc5T1QwNnM3?=
 =?utf-8?B?bG9xVTUxNFNsVmhVOWNCSVRmcm9VRDNwM2tQWFlFbXh6M0o3Z2ZtbHV1QmJm?=
 =?utf-8?B?cXFTNGRvUlRQNUE2VE8vbjErZGt3aDh5MFFUdzZ2N3RUZFJJQzM0V3UyWWJY?=
 =?utf-8?B?ZGhDUVdUbGFlYnJlQmxKWlBSQ1ViYll1Nlc4QTZ2QWZGcXdCV3phd1I5ZzND?=
 =?utf-8?B?Z094TnBOWGkxZjZDcmFsYnZlMUhCa21Sbmp6T2tvL2RTMGI2dmZ3MlljR051?=
 =?utf-8?B?Qk0xRVNFRUpITm94Z1ByTC9OdG1aYm1aWjc2bzBqUG4wM3c0cEdaNFYwNnZu?=
 =?utf-8?B?MFB0b2FYSGROcEM2VDhrNU1vdjVTemZiSWxVaDhRZnQvWlRQdzJibitTa21s?=
 =?utf-8?B?Z2ZMTEpRYnY3UERJZm9sa1B3QndDelcrZ25tTnBZRzVWSThrbHV6MVRMZENF?=
 =?utf-8?B?Ly9qeWJkdFRxRWdzR2VER2NEQmloSHdJeUJ6dk1GM0t3c3hxRk9ZL1NpM2hv?=
 =?utf-8?B?a0szUUQrRDl6VW1zWkMyaEJNbmxFUi9UR0sxRUllY3BObVNOcjFEQ0ZqckFl?=
 =?utf-8?B?VFdjUTBCMmhmSlVmd2krcXRmUk10MFVESEZXVm9hQUw3eUxHMTl5N0pxYm81?=
 =?utf-8?B?U2dPQk9aemlSSmRYS1NicjB2KzdXeWhzN1JDd2UvUDZHeEFuN2VYdTJMRXhT?=
 =?utf-8?B?MUNFcmFZRkN3WFN4RGE3WUZyeXdsMGlOZnFnbHVlODdncTB6ZkV4aUdUYUIr?=
 =?utf-8?B?YzlQRVFZdWxTQStxZ3M3SVUxNzRBb0tKaC9xWGRWYUMzbk1YMkk3L1JmaXcv?=
 =?utf-8?B?d0l4Y2hHd05pVm9WTWo0TndZZ1AyL0lXQmFlNzlQbEpvM1pTck9WZ2RCUCtZ?=
 =?utf-8?B?WGNEWDRIL2xsaXpZTWlYVjlONEVHbHNKL0x1dmtNakh1Vy8vdHBGYWFFWkdP?=
 =?utf-8?B?RTFaRERrYjJLQVh2NnRlL1MxZjdsS1Fucm95dWY5ak8yanJWWnJ1TEJXS05J?=
 =?utf-8?B?U2lpKzNVQkJkOTA3STRIc1IrNDRvQzRITTNVU2VFOGpmN1A4SUJ5L29mWnB2?=
 =?utf-8?Q?KkFfQIG7mgQua1KOej37KVm5QhZrkK+Dqr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 20:57:53.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b2cc73-94e3-464b-2983-08d8b8cf0f92
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBp2BM/IreevUB0Zkse9MGoMw7Y22W8yGNSc7/dUYW1vM+tvczRbXUZKYQunQ1PqMijr68rUnkLvnmLy9HtuIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Zero out the array of VMCB pointers so that pre_sev_run() won't see
> garbage when querying the array to detect when an SEV ASID is being
> associated with a new VMCB.  In practice, reading random values is all
> but guaranteed to be benign as a false negative (which is extremely
> unlikely on its own) can only happen on CPU0 on the first VMRUN and would
> only cause KVM to skip the ASID flush.  For anything bad to happen, a
> previous instance of KVM would have to exit without flushing the ASID,
> _and_ KVM would have to not flush the ASID at any time while building the
> new SEV guest.
>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..ccf52c5531fb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -573,7 +573,7 @@ static int svm_cpu_init(int cpu)
>  	if (svm_sev_enabled()) {
>  		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
>  					      sizeof(void *),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL | __GFP_ZERO);
>  		if (!sd->sev_vmcbs)
>  			goto free_save_area;
>  	}


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


