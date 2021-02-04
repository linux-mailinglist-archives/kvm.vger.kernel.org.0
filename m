Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2FA30F730
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhBDQE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:04:59 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:3686
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237727AbhBDQEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 11:04:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEdQCaOT5e3Ve87504HWzC5piZcw3wkVOoc2iEUc0MlAWVCjrKjItvNUNZus0i2jkudNk58Nvx/8c+M2wwRneEeL2EWO7xMRdPj/Wb20XfR/VCYLxcJSoSMSceBA8FKPkd3GFw5rNB2YztdYfVZNfCZOkG9wX/mPKwUEgwCgfJChoSYUNljyA3DwcKPBK1arnbXmneNCt2onc2K2Yxbo5ITt9vAghpeXoMWBlDSM9T0wRc1wx0cwtorZRLjJLExqETuufMPomyOSe5qV1CfZaCiUcALyz8+FwlebRTcYrsBo0jbuxOo1a/rXg+7VbXNiOSieMGWOnI/hxYm5EZsBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThwcPqP+KdLolYRTT04RwBMOAQM8SF6oVXzr2Wkh7hA=;
 b=XA8mNOrSkPfopesCpM9Nl98i7AxfBoMVLJ697/icDxvYAi4TNMqXx40l8yYlYH9dqEgBfZ4iCTiwbRFGtSt25i1NaO7N/mbKaVAqtScwn6fK6JQjD8UX3en6Xfl94+00DRrN0OdEvh9n9NF+qtKV/pFN1+4UcS20BjuLGBOM0hUC6mDzyk+r38MpYRbyINGCdpIP5mXeOW9zIW+yfM1ausyfP/87xtIWP3JLkQeI/xNX0chP70WT2b5uoEyILuD/VGydAPcb6WRrQrmsBgXBHktE+CNSlK55SGRvVjktI7rQFYDWXf6DJY3HVvGam6s6Bwg1GjYU1vbickVXriP/cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThwcPqP+KdLolYRTT04RwBMOAQM8SF6oVXzr2Wkh7hA=;
 b=QXiCPwnb0OLzZji8f1ouZNLNYOA7neE6mFnDjsnFIJeBQmt7l09WopXJ0My0KjwuKm3vHZ0+wTD+kajXS5NSxSuv4QrEuPL3XtmCRHFDmuA042pPh8mad56sTk5B6KEx5hhf5Cc4MCEfpagb8b6j/yi3zBl4O/Yzp2xqG3WidDI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4603.namprd12.prod.outlook.com (2603:10b6:5:166::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.20; Thu, 4 Feb 2021 16:03:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3825.023; Thu, 4 Feb 2021
 16:03:18 +0000
Subject: Re: [PATCH v10 08/16] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8c46da23-b5de-aaa2-8568-4b90117d2da9@amd.com>
Date:   Thu, 4 Feb 2021 10:03:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:806:20::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR03CA0018.namprd03.prod.outlook.com (2603:10b6:806:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.21 via Frontend Transport; Thu, 4 Feb 2021 16:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fc5e2c8-c473-4eed-fc9f-08d8c9266314
X-MS-TrafficTypeDiagnostic: DM6PR12MB4603:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4603DD88559B0D9D780EFBF2ECB39@DM6PR12MB4603.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qO4Y+aNENT64zm1K7QejDt+gHtuRa3sRuOVmO9DQMyyG0fvC7VsGql2NZ+pA4XXC1f51Uxpei9HLWu3KYyKwtaaI3p36yVoQOO6KPHgSydeXELysKSHdDx9fl4tLtMcA/FA7K43RA8PrpqzrHTHdGvQQ9v7MkHwUjZqKLWvV1w6wu7Kpy+FLCRTrzNzaAp91uEbNbGoNiKay9Zt3HcOxSd495fzH/Sx1yQTQngoDaILp1neVS+yQ28HrWfITPnXiSc/u46hl0ikPA4Cn8aTM+qspKSYuDscYUHHHW0fnTWGWO4bkYAB5MagO3AAtWhddWg6rAekEn0Ev0ayekG8eLXetKOludp8Dkeao+w+3bbrCbA4+BbOhpyjJ9I5d+CoAWZj6AV6v/GTMJ28AJxfztJyOy4a9ocB1Zk18C5Mh54Wfzvt6aWzYd7yyxoj1kXbwcsynSmCva3XwMuj45mPtcew1TI/ZGgDO85lAJqB1jg4qlcHG1uc9bp3pdAZRfQyGMG6Hy8sBoM45++gqxoeCNeur/RJ4hepiJxnhdzL/ij1cQoqEhCtLRcwH7zVYXdKpvVvnogVnHjDzhFfIoQ4D3wNzDwUaEwF3uBeTA5pqc0U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(66946007)(16526019)(31696002)(36756003)(66556008)(186003)(66476007)(52116002)(6666004)(8676002)(83380400001)(7416002)(956004)(31686004)(5660300002)(4326008)(6486002)(26005)(2616005)(316002)(6512007)(8936002)(53546011)(478600001)(86362001)(2906002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFg2QnJEM1hMMHZXY1FJU1RZeGdvL2srWVN4cVlBa2Zjd2pzS3haT0dxNEJk?=
 =?utf-8?B?RnZxVlN0eExUWVdCT0sxRVJ3aHdabUd2Z2tDeHhOV3ZCMnZRbGF4MGppZHRp?=
 =?utf-8?B?bFdVVEE0YnJLTGRIUzVVNFNQdlBJUXgxaDNsQVljZ0hSNVhUTnpzNVNyT1BN?=
 =?utf-8?B?QVliQm5lbVYzM3NLVnVla3hTQmdjTGVMTUpYY1I4V0s1VHRZSFRRbWtiTXA5?=
 =?utf-8?B?UEhON24wdHlOZTRkdk55R1dyKzFoRmRtYmlobGw0ck5EYnJpZ2xZd04xUnNt?=
 =?utf-8?B?MERHb3FLRlF6NTJNbFNWZTZ6VWZ4RGZibmlGY0VkYWpVU2RScDc4MHlRdE95?=
 =?utf-8?B?YkVCa3RXbkxrL1JDUkgxMFFQZTViUW5SSzRIcVFjOXpPbkxPbEt5aStvUmJ5?=
 =?utf-8?B?amhQTWJjczMzK2tGWGJzQU10TndPYVZLZ3lhMVlBU2FEcnVzV3ZSY3dTN043?=
 =?utf-8?B?TTh2TGhkaUVPVVZFMXZTNzB2eEhZRWRzeFYxb1laempuWllKMi9uVHlWNXRo?=
 =?utf-8?B?TC93Q1BrTlVZVndHcENVM090UmdsUlBQNXkvdEV2RjNsdVF3VmtKbjZsSTVl?=
 =?utf-8?B?SDgreFc0Rjgzc2JkOTZ2b3ArYlNXdm0yYXg5L1ViVWloa2ZFUXpJd1A2QjRI?=
 =?utf-8?B?STJReTFkSTJYWlYvb25JTEE1REVIQzBoY08rMVpGQUc1MEUvdElVYmtQcFcy?=
 =?utf-8?B?VXBFTHBrWDVCbjdYWmp1bDhROWFBNXMxaG0xa3hjQW9HMlFyQVZOdS82WXdG?=
 =?utf-8?B?dXlmTCtLY0o4S3hReTlEVzNPMTFzSlAvNlpWWk5zaXhIbE5XbXZ3SkRmTC9Y?=
 =?utf-8?B?WDYySU91ZXRvVXR2UUloZXBnTDdqSlNObk90ZzM1QytqV3R2UWdIZit0blRT?=
 =?utf-8?B?QkdHRTJrcm9TelAzMUJhT29lWk0zaGtsNlRUalVlYThFa2hITmZCMGlKOWor?=
 =?utf-8?B?R1FWQ1htcklZN2t5Y2x0RlRXcENXd2wwSHBJL2xHOXFXUG5sMGFaYXkvc3JK?=
 =?utf-8?B?eFpMUHB3UzdVYWtkK0hURW1iYXJVYUVLRkFVQzBoSDRsQWRlSGM3dTBxWVVp?=
 =?utf-8?B?WWZsOEhRYnFFQVdVM1MxSDJFdUs0bXJaYzU5ckVvS3hHWVB2dVUyamNwSWVS?=
 =?utf-8?B?Zi8xelNVdWdzSVlMRHJ0NDNYSWZvNGtyLytwK25RdEtNbmZLUlBTeVkwZjZH?=
 =?utf-8?B?U3F0bStGU1FHSmQ1bDl2RTkwWTFBV0l2bDNhZmNDYS9oVHovZ1lIOUtueXYy?=
 =?utf-8?B?ZzVLb1YzditIZjZnNzg1blJ5bDBOb2dIb1dFOU5pVC9ab0RFR25nZXRjQ0Ru?=
 =?utf-8?B?Rzk1dktLMkFLRTZmWXVnRklDQnU3b1I3NWsxcUxEZjUxbUxKVStqenZ2OWFs?=
 =?utf-8?B?RENyOU41WlBVRnZ3cjcwWE45bVhMNWFuNVplYWFYMFFxSWoxNVJZVzBZZmlL?=
 =?utf-8?Q?6vMjaS7Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc5e2c8-c473-4eed-fc9f-08d8c9266314
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:03:18.4253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6FD/iA/7u1q79FMOMhGpVwbhDWlwwzo/5hnoau+0RZyzh6h0A7JN0n2wj78xrxXgXHQ/BR8alaMYIf8UZhzeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4603
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/21 6:38 PM, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
> 
> The patch introduces a new shared pages list implemented as a
> sorted linked list to track the shared/unencrypted regions marked by the
> guest hypercall.
> 

...

> +
> +	if (enc) {
> +		ret = remove_shared_region(gfn_start, gfn_end,
> +					   &sev->shared_pages_list);
> +		if (ret != -ENOMEM)
> +			sev->shared_pages_list_count += ret;
> +	} else {
> +		ret = add_shared_region(gfn_start, gfn_end,
> +					&sev->shared_pages_list);
> +		if (ret > 0)
> +			sev->shared_pages_list_count++;
> +	}

I would move the shared_pages_list_count updates into the add/remove 
functions and then just return 0 or a -EXXXX error code from those 
functions. It seems simpler than "adding" ret or checking for a greater 
than 0 return code.

Thanks,
Tom

> +
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -1693,6 +1842,7 @@ void sev_vm_destroy(struct kvm *kvm)
>   
>   	sev_unbind_asid(kvm, sev->handle);
>   	sev_asid_free(sev->asid);
> +	sev->shared_pages_list_count = 0;
>   }
>   
>   void __init sev_hardware_setup(void)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f923e14e87df..bb249ec625fc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4536,6 +4536,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.complete_emulated_msr = svm_complete_emulated_msr,
>   
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +
> +	.page_enc_status_hc = svm_page_enc_status_hc,
>   };
>   
>   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..6437c1fa1f24 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,9 @@ struct kvm_sev_info {
>   	unsigned long pages_locked; /* Number of pages locked */
>   	struct list_head regions_list;  /* List of registered regions */
>   	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +	/* List and count of shared pages */
> +	int shared_pages_list_count;
> +	struct list_head shared_pages_list;
>   };
>   
>   struct kvm_svm {
> @@ -472,6 +475,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   			       bool has_error_code, u32 error_code);
>   int nested_svm_exit_special(struct vcpu_svm *svm);
>   void sync_nested_vmcb_control(struct vcpu_svm *svm);
> +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +			   unsigned long npages, unsigned long enc);
>   
>   extern struct kvm_x86_nested_ops svm_nested_ops;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cc60b1fc3ee7..bcbf53851612 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7705,6 +7705,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.can_emulate_instruction = vmx_can_emulate_instruction,
>   	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>   	.migrate_timers = vmx_migrate_timers,
> +	.page_enc_status_hc = NULL,
>   
>   	.msr_filter_changed = vmx_msr_filter_changed,
>   	.complete_emulated_msr = kvm_complete_insn_gp,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76bce832cade..2f17f0f9ace7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8162,6 +8162,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   		kvm_sched_yield(vcpu->kvm, a0);
>   		ret = 0;
>   		break;
> +	case KVM_HC_PAGE_ENC_STATUS:
> +		ret = -KVM_ENOSYS;
> +		if (kvm_x86_ops.page_enc_status_hc)
> +			ret = kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
> +					a0, a1, a2);
> +		break;
>   	default:
>   		ret = -KVM_ENOSYS;
>   		break;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index 8b86609849b9..847b83b75dc8 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -29,6 +29,7 @@
>   #define KVM_HC_CLOCK_PAIRING		9
>   #define KVM_HC_SEND_IPI		10
>   #define KVM_HC_SCHED_YIELD		11
> +#define KVM_HC_PAGE_ENC_STATUS		12
>   
>   /*
>    * hypercalls use architecture specific
> 
