Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D751E81CC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgE2P24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:28:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgE2P2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j3fj27W3uN/6I5026Um93rPcQiLMmVXJm0WFtCISxNo=;
        b=Jscl4jNE3UVEn8gcB8Y+jpx8+L3FkV4ACc+kN+N29xivYK2acKuamXrh6U7favn3o7jRz7
        Mi/iZ/pvC/AIpMxbQaxv1+x73tv3Em/H4odw/EWQG11zwuvoBhqYDgZkYYkXfa4BaRKeq1
        9Nn9L8+ppQ7g2vAum4CEBh6V3VX/FjA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-lwjb6qLZNj2ucjXMm3jPLQ-1; Fri, 29 May 2020 11:28:52 -0400
X-MC-Unique: lwjb6qLZNj2ucjXMm3jPLQ-1
Received: by mail-wm1-f71.google.com with SMTP id s15so817996wmc.8
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 08:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j3fj27W3uN/6I5026Um93rPcQiLMmVXJm0WFtCISxNo=;
        b=AO2gmpYZGmtRlBpUqPxYBq3S3mkvdwG4xYFsRWnIVWKyjJZorw+4NhksX6tiBKcgoH
         TTzVXdP/3qgz815T0kTY1jskLYHp2WvbK4VhUGRJMTHuckMPS6uxEFf/izA6PpvpWw46
         BnR5wb1WlyW4I+eT49znlXKd9F0vFI7mPseBbrcnTimlgG6hf++3jsBaNOd/+3wFuXAo
         nGeAfhzKygPZoseS5EfvmdzqHJFkNs1+c5udLOi9CJqkk3bN0nrwqalP6MoF31Ii+QDr
         sJ8VPnsLJm0Anv7ErGwNCmkFQ9RAEayCxBkJr4HKnU2lFzk8yxMfLsfF+5tt7U90RleD
         T7Eg==
X-Gm-Message-State: AOAM530rx1bKtt4yRveqKrVM4rLSCvrMfqcyh3KbN0t1GMk/dPEGrgUl
        HavYT6u1WkuL1dGN9H1dDDTD0wVGCa66Fn8TI2KW8ehy/wQXtiJvDPzelYJpmBzNrUYkk9LhHx4
        bG9ftD13n2U++
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr8963610wml.70.1590766131255;
        Fri, 29 May 2020 08:28:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnRui06oIE29aIFnuFue1mcO0Hf+Lm/Bg8BZRE5Ct4zWqlhVRIPkukT4yVFlsYfNImtzGcdQ==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr8963590wml.70.1590766130978;
        Fri, 29 May 2020 08:28:50 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.160.89])
        by smtp.gmail.com with ESMTPSA id 23sm10556087wmg.10.2020.05.29.08.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:28:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] selftests: kvm: fix smm test on SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200529130407.57176-1-vkuznets@redhat.com>
 <20200529130407.57176-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d355ab9e-416f-582c-11e6-3fed437feca2@redhat.com>
Date:   Fri, 29 May 2020 17:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529130407.57176-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 15:04, Vitaly Kuznetsov wrote:
> KVM_CAP_NESTED_STATE is now supported for AMD too but smm test acts like
> it is still Intel only.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/smm_test.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 8230b6bc6b8f..6f8f478b3ceb 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -17,6 +17,7 @@
>  #include "kvm_util.h"
>  
>  #include "vmx.h"
> +#include "svm_util.h"
>  
>  #define VCPU_ID	      1
>  
> @@ -58,7 +59,7 @@ void self_smi(void)
>  	      APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
>  }
>  
> -void guest_code(struct vmx_pages *vmx_pages)
> +void guest_code(void *arg)
>  {
>  	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
>  
> @@ -72,8 +73,11 @@ void guest_code(struct vmx_pages *vmx_pages)
>  
>  	sync_with_host(4);
>  
> -	if (vmx_pages) {
> -		GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
> +	if (arg) {
> +		if (cpu_has_svm())
> +			generic_svm_setup(arg, NULL, NULL);
> +		else
> +			GUEST_ASSERT(prepare_for_vmx_operation(arg));
>  
>  		sync_with_host(5);
>  
> @@ -87,7 +91,7 @@ void guest_code(struct vmx_pages *vmx_pages)
>  
>  int main(int argc, char *argv[])
>  {
> -	vm_vaddr_t vmx_pages_gva = 0;
> +	vm_vaddr_t nested_gva = 0;
>  
>  	struct kvm_regs regs;
>  	struct kvm_vm *vm;
> @@ -114,8 +118,11 @@ int main(int argc, char *argv[])
>  	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
>  
>  	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
> -		vcpu_alloc_vmx(vm, &vmx_pages_gva);
> -		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
> +			vcpu_alloc_svm(vm, &nested_gva);
> +		else
> +			vcpu_alloc_vmx(vm, &nested_gva);
> +		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
>  	} else {
>  		pr_info("will skip SMM test with VMX enabled\n");
>  		vcpu_args_set(vm, VCPU_ID, 1, 0);
> 

Thanks, I'll include this in v3 of the nSVM series.

Paolo

