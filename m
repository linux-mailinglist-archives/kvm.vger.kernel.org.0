Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D07D8501
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 02:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbfJPAnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 20:43:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbfJPAnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 20:43:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9G0dqH2003599;
        Wed, 16 Oct 2019 00:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RO+XrYrDaeBDBxb1QAxo3QY1K6pbqEr9rfJZhor0FR0=;
 b=gkk5uU1QPz3pbW3mvR/PL+XZDaVfWIA3KgJD1tICgkTq04qP2LRQ4b9QQTxGdfae+vbD
 MWqnAiZ1yKyo09CvbtkuXG5osuKUNnzs0mr9+qLxSM55L7THOJW+XGdDmIfCOoYKrn6Q
 uBNh2sj6j9clhaoSjcDM3PmbUJqdr4BM70dnGctX09WWasq9eTEBiT1bOwP4Sosbi3lz
 WU3ndcM4/66BpxDL9LLiaYQJFh879sJ3LTlrXWyJtzB4VSh7YYDcfYcDI3a++8tbhoWC
 bYDy4CEiqjMBLaRonpcjNxWYqAdjnwb17XxqauDmvnQzoHXlAhofSFJ8FnT+/z9MXk2l +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vk6sqkfmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 00:42:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9G0dKZL099099;
        Wed, 16 Oct 2019 00:40:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vnf7s7m4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 00:40:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9G0eZvr007898;
        Wed, 16 Oct 2019 00:40:35 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 00:40:35 +0000
Subject: Re: [PATCH 2/4] KVM: VMX: Setup MSR bitmap only when has msr_bitmap
 capability
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
 <20191015164033.87276-3-xiaoyao.li@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <05ff009e-5f60-54ff-a371-111763a1cb7f@oracle.com>
Date:   Tue, 15 Oct 2019 17:40:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20191015164033.87276-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/15/2019 09:40 AM, Xiaoyao Li wrote:
> Move the MSR bitmap setup codes to vmx_vmcs_setup() and only setup them
> when hardware has msr_bitmap capability.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 39 ++++++++++++++++++++-------------------
>   1 file changed, 20 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 58b77a882426..7051511c27c2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4164,12 +4164,30 @@ static void ept_set_mmio_spte_mask(void)
>   static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
>   {
>   	int i;
> +	unsigned long *msr_bitmap;
>   
>   	if (nested)
>   		nested_vmx_vmcs_setup();
>   
> -	if (cpu_has_vmx_msr_bitmap())
> -		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
> +	if (cpu_has_vmx_msr_bitmap()) {
> +		msr_bitmap = vmx->vmcs01.msr_bitmap;
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);

vmx_disable_intercept_for_msr() also calls cpu_has_vmx_msr_bitmap(), 
which means we are repeating the check. A cleaner approach is to remove 
the call to cpu_has_vmx_msr_bitmap()  from 
vmx_disable_intercept_for_msr()  and let its callers do the check just 
like you are doing here.

> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> +		if (kvm_cstate_in_guest(vmx->vcpu.kvm)) {
> +			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
> +			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> +			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> +			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> +		}
> +
> +		vmcs_write64(MSR_BITMAP, __pa(msr_bitmap));
> +	}
> +	vmx->msr_bitmap_mode = 0;
>   
>   	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
>   
> @@ -6697,7 +6715,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>   {
>   	int err;
>   	struct vcpu_vmx *vmx;
> -	unsigned long *msr_bitmap;
>   	int cpu;
>   
>   	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
> @@ -6754,22 +6771,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>   	if (err < 0)
>   		goto free_msrs;
>   
> -	msr_bitmap = vmx->vmcs01.msr_bitmap;
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> -	if (kvm_cstate_in_guest(kvm)) {
> -		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> -	}
> -	vmx->msr_bitmap_mode = 0;
> -
>   	vmx->loaded_vmcs = &vmx->vmcs01;
>   	cpu = get_cpu();
>   	vmx_vcpu_load(&vmx->vcpu, cpu);

