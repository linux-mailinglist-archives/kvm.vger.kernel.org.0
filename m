Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AAC38F4C8
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhEXVQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:16:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232662AbhEXVQl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 17:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621890912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSqH+teOXpDHWZon+DBvYi3eou87Q03md2WpxZpsMus=;
        b=iD+ZcrvpkHK3YpOS0c0zJUc2hFeHB4e7O6Ad4fjO40eGs1wmMYV/EEbiZPW+/PRVJtPxAd
        7KYaslf9NWsBzs4y12OMxl0KRFzkADC1UFGSbQwJTaoj5ndGDjp/TOt0zqkgYWBMGqD2Y5
        37p4poIP8HVJ5HpqFcLUFp7940u1axs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-D39dBMEMMFaG4zfDyRl9wQ-1; Mon, 24 May 2021 17:15:10 -0400
X-MC-Unique: D39dBMEMMFaG4zfDyRl9wQ-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so8061009ejw.22
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSqH+teOXpDHWZon+DBvYi3eou87Q03md2WpxZpsMus=;
        b=OOAa/wpiz6M7D37wbd7t7jbExgg3AiD1tmsdx+xdX6qyGcxP0d0C4f7aBzAVnCexcn
         y/lJ18QOUrm7hn9PUl5QQsR1u9MpZju0tBvMSiSzvUuMo9YYJRc1Wnj4EFf6MoOdYRYZ
         g+esxZCkYcUcKm6WFNZxWikfd468cw63WRR9zy7UNt9ZyP9dcyo4QJBS305PUC6TelcD
         3OagKRqaxNgfJUhnL5MfMRuKfqd3yGvh7MDGcCM49xoG+hZ6vJejUP36oVWWn7mmkD5+
         GL1Z7aicWJ+5lJcRUJGqIHR2cYN66EGgW+QSp8N42mpHb5tllV8CnzRxSs0ULdSSqMv5
         /8xA==
X-Gm-Message-State: AOAM5338LxQn4E4OrK17Z+2dJTrAGmQgw0ZxanEOpqCWWl3W6nTw7o8+
        ZimHBUGf6YAm52gmz0rx3zTwhUqu1uKH3sSXr/np3FBUYAEY8goK2K+ieEqpYqLxRKh8ui/8s3q
        Of5bo/hOmW/jB
X-Received: by 2002:a17:906:c04b:: with SMTP id bm11mr25020153ejb.263.1621890908939;
        Mon, 24 May 2021 14:15:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz51YimQBkMpa9ns4Adz91j+xw6D5Bn0s1GpKaDoZphhcT9OIEOBiGHwPu/jv+luDjGbwmtog==
X-Received: by 2002:a17:906:c04b:: with SMTP id bm11mr25020137ejb.263.1621890908744;
        Mon, 24 May 2021 14:15:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u1sm9837524edv.91.2021.05.24.14.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 14:15:08 -0700 (PDT)
Subject: Re: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU
 RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-43-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
Date:   Mon, 24 May 2021 23:15:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210424004645.3950558-43-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/21 02:46, Sean Christopherson wrote:
> Don't waste time writing zeros via VMWRITE during vCPU RESET, the VMCS
> is zero allocated.

Is this guaranteed to be valid, or could the VMCS in principle use some 
weird encoding? (Like it does for the access rights, even though this 
does not matter for this patch).

Paolo

> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 29 -----------------------------
>   1 file changed, 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 78d17adce7e6..74258ba4832a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4427,13 +4427,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   	}
>   
>   	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
> -		vmcs_write64(EOI_EXIT_BITMAP0, 0);
> -		vmcs_write64(EOI_EXIT_BITMAP1, 0);
> -		vmcs_write64(EOI_EXIT_BITMAP2, 0);
> -		vmcs_write64(EOI_EXIT_BITMAP3, 0);
> -
> -		vmcs_write16(GUEST_INTR_STATUS, 0);
> -
>   		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
>   		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>   	}
> @@ -4444,23 +4437,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   		vmx->ple_window_dirty = true;
>   	}
>   
> -	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
> -	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
> -	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
> -
> -	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
> -	vmcs_write16(HOST_GS_SELECTOR, 0);            /* 22.2.4 */
>   	vmx_set_constant_host_state(vmx);
> -	vmcs_writel(HOST_FS_BASE, 0); /* 22.2.4 */
> -	vmcs_writel(HOST_GS_BASE, 0); /* 22.2.4 */
>   
> -	if (cpu_has_vmx_vmfunc())
> -		vmcs_write64(VM_FUNCTION_CONTROL, 0);
> -
> -	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> -	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
>   	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
> -	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
>   	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
>   
>   	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
> @@ -4493,7 +4472,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
>   		/* Bit[6~0] are forced to 1, writes are ignored. */
>   		vmx->pt_desc.guest.output_mask = 0x7F;
> -		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
>   	}
>   
>   	vmx_setup_uret_msrs(vmx);
> @@ -4536,13 +4514,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vmcs_write32(GUEST_LDTR_LIMIT, 0xffff);
>   	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x00082);
>   
> -	if (!init_event) {
> -		vmcs_write32(GUEST_SYSENTER_CS, 0);
> -		vmcs_writel(GUEST_SYSENTER_ESP, 0);
> -		vmcs_writel(GUEST_SYSENTER_EIP, 0);
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> -	}
> -
>   	vmcs_writel(GUEST_GDTR_BASE, 0);
>   	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
>   
> 

