Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3439C17C840
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 23:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCFWV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 17:21:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgCFWV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 17:21:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026MHvSn161425;
        Fri, 6 Mar 2020 22:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fI1UPEQ44PoSDGtXZrac2gt00MZqEi7a5V5btcJT3fo=;
 b=kQdLVX0Ok1uCCcrkpUP8TTkuO5ChmcvznTdtVct5Agn/ZvtV7yAPvSXA1SSaFAPdpOBD
 WuoMiasKAHXF44ujBMOKR1BGLMH0E4i85zRRQ6+TWMjT7TnZSJdjTXbgTImKaAw2Tn7u
 5tS6HTAUhvMVavD4bQWU8EXz8uaIE1kL7Iis5h5ydtLKZLF2tF9VTgsbgiDN3yPOIoSq
 QJqaXaXRDCm3S3bEqwPEUZp4NdtdUjFhsKmo+OvQ3/31vLjp5vn2hqr1/K3u5p1GVTZo
 /w+FszWprloETNgF2F/fMmR+7A/sI19R4KYPlOfv7rvwQ6V2MCTn/KS2iXJ4CtuVvPCk 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ykgys4ecp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 22:20:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026MGupO068764;
        Fri, 6 Mar 2020 22:20:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yjuf4n1rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 22:20:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 026MKEcu019651;
        Fri, 6 Mar 2020 22:20:14 GMT
Received: from localhost.localdomain (/10.159.228.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 14:20:14 -0800
Subject: Re: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when
 using eVMCS
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200306130215.150686-1-vkuznets@redhat.com>
 <20200306130215.150686-3-vkuznets@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com>
Date:   Fri, 6 Mar 2020 14:20:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200306130215.150686-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=2 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/6/20 5:02 AM, Vitaly Kuznetsov wrote:
> As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
> revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
> do so is not very straightforward: first, we set
> hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
> back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
> introducing 'enum vmcs_type' parameter to alloc_vmcs_cpu()/alloc_vmcs().
>
> No functional change intended.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/vmx/nested.c |  2 +-
>   arch/x86/kvm/vmx/vmx.c    | 34 +++++++++++++++-------------------
>   arch/x86/kvm/vmx/vmx.h    | 12 +++++++++---
>   3 files changed, 25 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e920d7834d73..8c0ed62b29be 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4566,7 +4566,7 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
>   	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
>   
>   	if (!loaded_vmcs->shadow_vmcs) {
> -		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
> +		loaded_vmcs->shadow_vmcs = alloc_vmcs(SHADOW_VMCS_REGION);
>   		if (loaded_vmcs->shadow_vmcs)
>   			vmcs_clear(loaded_vmcs->shadow_vmcs);
>   	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dab19e4e5f2b..a45d3721e7d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2554,7 +2554,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   	return 0;
>   }
>   
> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
> +struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags)
>   {
>   	int node = cpu_to_node(cpu);
>   	struct page *pages;
> @@ -2566,13 +2566,21 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
>   	vmcs = page_address(pages);
>   	memset(vmcs, 0, vmcs_config.size);
>   
> -	/* KVM supports Enlightened VMCS v1 only */
> -	if (static_branch_unlikely(&enable_evmcs))
> +	/*
> +	 * When eVMCS is enabled, vmcs->revision_id needs to be set to the
> +	 * supported eVMCS version (KVM_EVMCS_VERSION) instead of revision_id
> +	 * reported by MSR_IA32_VMX_BASIC.
> +	 *
> +	 * However, even though not explicitly documented by TLFS, VMXArea
> +	 * passed as VMXON argument should still be marked with revision_id
> +	 * reported by physical CPU.
> +	 */
> +	if (type != VMXON_REGION && static_branch_unlikely(&enable_evmcs))
>   		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
>   	else
>   		vmcs->hdr.revision_id = vmcs_config.revision_id;
>   
> -	if (shadow)
> +	if (type == SHADOW_VMCS_REGION)
>   		vmcs->hdr.shadow_vmcs = 1;
>   	return vmcs;
>   }
> @@ -2599,7 +2607,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>   
>   int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>   {
> -	loaded_vmcs->vmcs = alloc_vmcs(false);
> +	loaded_vmcs->vmcs = alloc_vmcs(VMCS_REGION);
>   	if (!loaded_vmcs->vmcs)
>   		return -ENOMEM;
>   
> @@ -2652,25 +2660,13 @@ static __init int alloc_vmxon_regions(void)
>   	for_each_possible_cpu(cpu) {
>   		struct vmcs *vmcs;
>   
> -		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
> +		/* The VMXON region is really just a special type of VMCS. */


Not sure if this is the right way to correlate the two.

AFAIU, the SDM calls VMXON region as a memory area that holds the VMCS 
data structure and it calls VMCS the data structure that is used by 
software to switch between VMX root-mode and not-root-mode. So VMXON is 
a memory area whereas VMCS is the structure of the data that resides in 
that memory area.

So if we follow this interpretation, your enum should rather look like,

enum vmcs_type {
+    VMCS,
+    EVMCS,
+    SHADOW_VMCS


> +		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
>   		if (!vmcs) {
>   			free_vmxon_regions();
>   			return -ENOMEM;
>   		}
>   
> -		/*
> -		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
> -		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
> -		 * revision_id reported by MSR_IA32_VMX_BASIC.
> -		 *
> -		 * However, even though not explicitly documented by
> -		 * TLFS, VMXArea passed as VMXON argument should
> -		 * still be marked with revision_id reported by
> -		 * physical CPU.
> -		 */
> -		if (static_branch_unlikely(&enable_evmcs))
> -			vmcs->hdr.revision_id = vmcs_config.revision_id;
> -
>   		per_cpu(vmxarea, cpu) = vmcs;
>   	}
>   	return 0;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e64da06c7009..a5eb92638ac2 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -489,16 +489,22 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>   	return &(to_vmx(vcpu)->pi_desc);
>   }
>   
> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
> +enum vmcs_type {
> +	VMXON_REGION,
> +	VMCS_REGION,
> +	SHADOW_VMCS_REGION,
> +};
> +
> +struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
>   void free_vmcs(struct vmcs *vmcs);
>   int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>   void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>   void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
>   void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>   
> -static inline struct vmcs *alloc_vmcs(bool shadow)
> +static inline struct vmcs *alloc_vmcs(enum vmcs_type type)
>   {
> -	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
> +	return alloc_vmcs_cpu(type, raw_smp_processor_id(),
>   			      GFP_KERNEL_ACCOUNT);
>   }
>   
