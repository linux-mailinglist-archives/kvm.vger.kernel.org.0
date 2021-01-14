Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653AA2F6D70
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbhANVpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:45:36 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:13348
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730075AbhANVp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:45:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VR0a9EaaqdkVRMiGZdZ+sxJpzF60Ue29OmuP+1PBmqra2TjGHbAnVEnu17eBw5eNn7RaTROCPlO80G9yZLuYO7b2ckQdM7xixNJ3ofdipqxS9abEtToATdRJ4km4AyZMOGyC1+arGig9ZPfS4yYuoFC1T4GPaz4X/1oUe5trcozyyw1jl/uYfh7yFXHaCBeda2ed9pG8nSWUR8DpbE5lTDkxlGNfpKwvVIsP4l9ebjZTZVbPFeH9bxhUfIxb7LsHZPeEeViz1d358KCDRPVgstoSk/KeFVSLfsyqaeWHIQLKi7M2PlDK8kZCGFDCiwh/vmkCXl7bZdjy1Me3rmqaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZncCjsY1dVXYSHQnwm0G6qy+GVbwUqGWF9rxL5ItOg=;
 b=ImcDjBB3hW+FrtlW6rq8Kb+C9yH97ybjS4nUHPrxyeMzXXW9dB7jV+Tvzv6kBsvTTQmXqGsSUD9IxnTocq0i6lTdHdk5vUDqo1VTwJPt4pghUqNsDd0p7Bz//Xi6o8vR07T/3YkczEPz+5FxVU68Fv6Qs/ousiDuHBupWzP2EEgAMYyB90Hz2jZTvNtzFIJGsXB6y2sbPUwOR0oV8RD52FbvDtHi5lMdjlMNX1sm7v0YYhIj5jyzKF3B28m3nNXSqu9AVxdIoeOOPYmDUruB6FAyscX/mNPEl5ABZCOesFZMWnL+6kDEj094uvU7I+ngh8Sh0oV9IEAHHaZFg/bJcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZncCjsY1dVXYSHQnwm0G6qy+GVbwUqGWF9rxL5ItOg=;
 b=Epo3W1JdvTLgPoLxCZ8rwmip44w/7TIga6W8q5jyCGxw+mT5tw/FnJnHoDJfjeDTGQ3eT7R7K2tjNpbYbgf2HOmaBwLpBFoo5WrIACnqv1lImYxF2c81//zqMY4HMI6zKI74oTSvHEfX6kz8p4n0jKzDSyZR96gpRRAaiZs2T9s=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 21:44:32 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:44:32 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 12/14] KVM: SVM: Drop redundant svm_sev_enabled()
 helper
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-13-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <5cc747b6-f5c8-f23b-a341-d19a55007f3b@amd.com>
Date:   Thu, 14 Jan 2021 15:44:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 21:44:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32034369-ef85-44ae-5c5c-08d8b8d5943a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432E461BA0857582DED8A06E5A80@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWvtaxBHilW8+e/+/O9u7C0Ser/7M/eJsdRLvE7SXi5e1CgvI3qIpG6fia27nUO8EycRx6GrQxeKyQQA0QaPY07aDPFC5itBBF11AWFJSud38Rcr4wO58JKRl1Dgjjy4EzACw97ZSuPoA0R86YYOFj5RQgzqJfR4xQXEjgqGu7seN+1GKYim+jSItPUBps7tuy5uH2GxHu4re4su1GnTiizagCl+uzg19NOfF51nILY0WHobB97Mw7dQGpiNzPwYRk0t86aXDHlHEijjs4NeygVhkJpyw8KoHMyyXGQM/osEzDAWYqmSfN6WPzspyRbfMcwJ0/5VkrGKIvdpLm27e7stXJrQNq/e/vUxRc6cqWViQNc4nxp0dre2yT10ot93EaaMx1QXnO89rqNFY2dxeM7n2dRGwaEBIv6ou/jTxzKaE2yAhr4wLO5Jqt5CxDBN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(7416002)(8936002)(186003)(66556008)(26005)(6512007)(316002)(6486002)(83380400001)(44832011)(956004)(2616005)(36756003)(54906003)(66946007)(8676002)(52116002)(110136005)(16526019)(66476007)(4326008)(86362001)(31686004)(2906002)(53546011)(5660300002)(31696002)(6506007)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzdVeDlmNFpad1h5TmhreUVIUnQ4R0tqMHN2NFRqa2YyR0FyVDJUemYwTjdr?=
 =?utf-8?B?TVFiWFFoTHJ1YjBtVlZpY2ZYVFBIaU10SytNOEFpR2JvaThEVVJMUmtEUm9G?=
 =?utf-8?B?WWMwZ2VMMHNXK1JvaGQzeGlLWXZ5YU82WmltOTB0ZkVJMnlkcE8rajFVSHdM?=
 =?utf-8?B?dHRwNGwzbXZDMm1YbDAvMzJwL2duVnRPOGkzalBYdDllMnBhc0NYMXlmQm9Q?=
 =?utf-8?B?d3ZlV0xRbC9LaW0ycm0xc3d3RUlzNTJ4cENEcDNFVmErWXducnFYU21JZ1Mv?=
 =?utf-8?B?ajE0VDEzTXRjamdNWGs2OFM5N3pDK1c0VlBraTVLWDlqV2s3aDdCdUNkWmp0?=
 =?utf-8?B?c0lKM24wL0gxN0FiMUg5UWFUUElDdGw3OWhUeFRVODdudnZpdzRRR1pXbDNz?=
 =?utf-8?B?UFJSVjdta3RNV0F5MzNSc3VuemlYNGNXbGp1RFE5WnpVUklBOEF6ZEFRbi9m?=
 =?utf-8?B?cWlkaXN5UmZDdnNPdFllcUJMa0dzOFNrQmZiSkNEMTJzQ0xtTlZBVTZLc2ph?=
 =?utf-8?B?bkMxWHRpdnNpekJFT3FubGxHczBKZ3NmdWxncERRWmppcnE5MEpaeHhuS0JB?=
 =?utf-8?B?TG5UZ3dtUTdORHJLM1RWRTJrb1dIYW9BSkZUUDV4SWZmMXVpTG9NRm9QWFAw?=
 =?utf-8?B?dW45S2VkUzZCalhYM01qUktLMTcrUmZ2cmU2YVBpUllUcVh3eU9ESVdhbzFk?=
 =?utf-8?B?SlRzZ2hGYmRUNWw4MWFyNnlGVmVqZzFRYURXcnY2ZitNRG1BQkFZTUpkUVdC?=
 =?utf-8?B?YnpHb2VmWXdOQ2l1U2NxdWVVWWlxL09zTkxRbGVYcDhlUjA1dnZhVjA3OTF6?=
 =?utf-8?B?ZFNtNGowSW9CYk1samhYWWdsVWRPUmJtY1JqQVJTSGM2L2NSK25tVmhwTzJC?=
 =?utf-8?B?SDRjaldUTER1UDdyeDBjNDBGemNiWGY0YlQ5TlVQa2pUYkhFQyt3anpZZ2JC?=
 =?utf-8?B?UDZFbXU5dmJvMFFuMFg4WWl3L0VFdk1wZkVVWkR0emgwQjh3QUdNNWtORXdv?=
 =?utf-8?B?UjBPMytsZTMrRFBnOFkvbVRlT1h6RXc1dmgvL05PREdrMFRBK0Q5SklPLzhm?=
 =?utf-8?B?a21aWURmUHp1ekJjTG1sK29Gb0lZS3ZnakpOOHFCb290dExyei9NSUtLdDVM?=
 =?utf-8?B?b3VXNFZJWGlVNzIwQXh1dU51cUdXYmk3MklnR1hkQUp1WHc4N3RURDZrbUt4?=
 =?utf-8?B?QUV5cHhFVTJlWStudzlaOXpVejlyTjhLQjZ4VVM1OFUwanpaNVRmd1dLNjM3?=
 =?utf-8?B?WEVyeEg5Yjd6bDlkeEZtWEw0eTRkZWR3U1FDZDNWYkMwYi84YVN6ODVKL1B4?=
 =?utf-8?Q?KQ4DVUx7rUlkC4qOmFB7OCJEL3XxRmR0xS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:44:32.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 32034369-ef85-44ae-5c5c-08d8b8d5943a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjz73hhqiVV1dMnMfj2w6NSNbsvlRvlsQ7i3xZ7YC3JTakKR4kxeg0N+q1p50zrM+CzwnrsGBLXEkSJ0huwMxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
> in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
> This effectively replaces checks against a valid max_sev_asid with checks
> against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
> if max_sev_asid is invalid, all call sites are guaranteed to run after
> sev_hardware_setup(), and all of the checks care about SEV being fully
> enabled (as opposed to intentionally handling the scenario where
> max_sev_asid is valid but SEV enabling fails due to OOM).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 6 +++---
>  arch/x86/kvm/svm/svm.h | 5 -----
>  2 files changed, 3 insertions(+), 8 deletions(-)


Thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a2c3e2d42a7f..7e14514dd083 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1057,7 +1057,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	struct kvm_sev_cmd sev_cmd;
>  	int r;
>  
> -	if (!svm_sev_enabled() || !sev_enabled)
> +	if (!sev_enabled)
>  		return -ENOTTY;
>  
>  	if (!argp)
> @@ -1321,7 +1321,7 @@ void __init sev_hardware_setup(void)
>  
>  void sev_hardware_teardown(void)
>  {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>  		return;
>  
>  	bitmap_free(sev_asid_bitmap);
> @@ -1332,7 +1332,7 @@ void sev_hardware_teardown(void)
>  
>  int sev_cpu_init(struct svm_cpu_data *sd)
>  {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>  		return 0;
>  
>  	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4eb4bab0ca3e..8cb4395b58a0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -569,11 +569,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  
>  extern unsigned int max_sev_asid;
>  
> -static inline bool svm_sev_enabled(void)
> -{
> -	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
> -}
> -
>  void sev_vm_destroy(struct kvm *kvm);
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
>  int svm_register_enc_region(struct kvm *kvm,
