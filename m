Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171165D431
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfGBQZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:25:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51608 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBQZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:25:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so1470107wma.1
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pcd0XRmWwoUD/RpPeUCfXmfFbh+pZv0zVTYYmYbsOcU=;
        b=M6fLBxXmsrV/zucWgED31J4e1I9jR20moyulRUe2E6Bc/BuenoQpjrn9mlHMEBVSQr
         Ug0LutcR8TVa1kW2c/QU99A2UbmsbEOk4SJa4eWLgvRz+IBpcPH3VUFLqHXo0FP/JrFW
         iAA1+yN3rFjTMCJZRpkumWKi6XFsvmgvJU+ajNKJkGTmbWyMoSTJ3qWaPna3Jgewlbwc
         k5ed4DVSZ3PnCP73HYqgF4KV5DVkcJmIjsX3El1UoePUBsJU6vSnA6lkY/XSvrepDhNf
         PWj0pOicOGm5gsFs+JzIYhFS3BYI+uqvrTma6JAKgVvXenEoeme9KN+gMn/OBSlLuEIp
         7tkQ==
X-Gm-Message-State: APjAAAUF7NIVO81aoc3exqmg74SGK4J90oyQnYhJDaE0qzCmKIJ9+yZg
        ciRYW2OqVWuQtUkc7Q+Jma/mdg==
X-Google-Smtp-Source: APXvYqxQaqmNAui8xeQUsTbndRjqZ/c84lNFZJc2LdTLKfPlC9cGWbYaGzF/VXYw566KNmNmDlUU+w==
X-Received: by 2002:a05:600c:c6:: with SMTP id u6mr4042113wmm.153.1562084712075;
        Tue, 02 Jul 2019 09:25:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id y2sm11570082wrl.4.2019.07.02.09.25.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:25:11 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM nVMX: Check Host Segment Registers and Descriptor
 Tables on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
 <20190628221447.23498-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00f32b48-28e9-2502-5145-52150f0307ca@redhat.com>
Date:   Tue, 2 Jul 2019 18:25:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628221447.23498-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/19 00:14, Krish Sadhukhan wrote:
> According to section "Checks on Host Segment and Descriptor-Table
> Registers" in Intel SDM vol 3C, the following checks are performed on
> vmentry of nested guests:
> 
>    - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
>      RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>    - The selector fields for CS and TR cannot be 0000H.
>    - The selector field for SS cannot be 0000H if the "host address-space
>      size" VM-exit control is 0.
>    - On processors that support Intel 64 architecture, the base-address
>      fields for FS, GS and TR must contain canonical addresses.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>

All these tests are getting expensive.  Can you look into skipping them
whenever dirty_vmcs12 is clear?

Thanks,

Paolo

> ---
>  arch/x86/kvm/vmx/nested.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f1a69117ac0f..856a83aa42f5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2609,6 +2609,30 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  	    !kvm_pat_valid(vmcs12->host_ia32_pat))
>  		return -EINVAL;
>  
> +	ia32e = (vmcs12->vm_exit_controls &
> +		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
> +
> +	if (vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_cs_selector == 0 ||
> +	    vmcs12->host_tr_selector == 0 ||
> +	    (vmcs12->host_ss_selector == 0 && !ia32e))
> +		return -EINVAL;
> +
> +#ifdef CONFIG_X86_64
> +	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
> +		return -EINVAL;
> +#endif
> +
>  	/*
>  	 * If the load IA32_EFER VM-exit control is 1, bits reserved in the
>  	 * IA32_EFER MSR must be 0 in the field for that register. In addition,
> @@ -2616,8 +2640,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  	 * the host address-space size VM-exit control.
>  	 */
>  	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER) {
> -		ia32e = (vmcs12->vm_exit_controls &
> -			 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
>  		if (!kvm_valid_efer(vcpu, vmcs12->host_ia32_efer) ||
>  		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LMA) ||
>  		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LME))
> 

