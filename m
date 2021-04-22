Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52ABD367ED7
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhDVKjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235097AbhDVKjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619087914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TAfbdvFBQaIVmKooRRi6pz9Y0+v1LG1Et6O2Fwlwf8=;
        b=cHoDpdHRIYMdSiQcWNtFBhyWZvQjbkJ3VaTAOljX4jngpkY+25z1guA9TmDxDqFBoxsjg4
        JvqI46iNVvyi6oJ4bnQQetjoLHSlOs81dVpyzEJLkmFtdKuUBR3DPBdDukGq6vrZgMhq1u
        MKmiS74LYEWljStKuXb22/6fslYs5S4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-VVD5cHFcOYGzrtiRR1HZ7A-1; Thu, 22 Apr 2021 06:38:22 -0400
X-MC-Unique: VVD5cHFcOYGzrtiRR1HZ7A-1
Received: by mail-ed1-f71.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso16472872edb.4
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9TAfbdvFBQaIVmKooRRi6pz9Y0+v1LG1Et6O2Fwlwf8=;
        b=XwlvNva5MpAzMS/zIjVEI2maenAyreJKMTyvtUAnFzfPc37VemlVOUz8Lk79Q91Kn6
         iEgOOLRxzNr3hGnsOdYSjiec0we2zDnUz39hi/vDm8cwHvQX0lbve12mj+QPh9LXI6fl
         e9J5d6vbQBbBZ7MI4mvg0LOQuz31Ttb7YbKwEmMgL783beVBD2M0BcElICr0hGTVrzh8
         j27uiswA6jUqlzJ0lCB88X52k/UCpFcfg7XF9WPZBEIS3HcG8g6ec7RSnzghbb345bPn
         bcDLW4AUXb/2X8NJghxi1yPlpdvRb+T4XvicZy2PSxFybpLXTG9Lri/VwlPtjwlCFOc6
         M0KQ==
X-Gm-Message-State: AOAM533BjbyfP9EM7Qyhj65rmRNjdsGZ/iRZxpSFjW8+o1rPecPCcu4e
        ro21i5FdmJ3Yn4fkQIAZOO6NAz8vswqvSl2VSWBvvR6QhiE6XYZgIrJQv/DBLofBokM+wBUDG9y
        UkCYTq/AJtrTa
X-Received: by 2002:a17:906:d213:: with SMTP id w19mr2686237ejz.16.1619087901312;
        Thu, 22 Apr 2021 03:38:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwo5BxAB70ZqPRy20QdC390aMpoArh1F6x2NgiBaMgq+BTXgAUyKXMSqBKUMe/YAaUxpz1kg==
X-Received: by 2002:a17:906:d213:: with SMTP id w19mr2686230ejz.16.1619087901163;
        Thu, 22 Apr 2021 03:38:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w22sm1762359eds.56.2021.04.22.03.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:38:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: VMX: Keep registers read/write consistent with
 definition
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20210422093436.78683-1-yang.zhong@intel.com>
 <20210422093436.78683-2-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b5c9467-6358-66fb-47dd-cd8721ebe2f0@redhat.com>
Date:   Thu, 22 Apr 2021 12:38:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422093436.78683-2-yang.zhong@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 11:34, Yang Zhong wrote:
> The kvm_cache_regs.h file has defined inline functions for those general
> purpose registers and pointer register read/write operations, we need keep
> those related registers operations consistent with header file definition
> in the VMX side.
> 
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 29b40e092d13..d56505fc7a71 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2266,10 +2266,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>   
>   	switch (reg) {
>   	case VCPU_REGS_RSP:
> -		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
> +		kvm_rsp_write(vcpu, vmcs_readl(GUEST_RSP));
>   		break;
>   	case VCPU_REGS_RIP:
> -		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
> +		kvm_rip_write(vcpu, vmcs_readl(GUEST_RIP));
>   		break;

This is on purpose, because you don't want to mark those register dirty.

Likewise, in the case below it's more confusing to go through the helper 
because it checks kvm_register_is_available and calls vmx_cache_reg if 
false.

Because these functions are the once that handle the caching, it makes 
sense for them not to use the helpers.

Paolo

>   	case VCPU_EXREG_PDPTR:
>   		if (enable_ept)
> @@ -4432,7 +4432,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   
>   	vmx->msr_ia32_umwait_control = 0;
>   
> -	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> +	kvm_rdx_write(&vmx->vcpu, get_rdx_init_val());
>   	vmx->hv_deadline_tsc = -1;
>   	kvm_set_cr8(vcpu, 0);
>   
> @@ -6725,9 +6725,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
>   
>   	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
> -		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
> +		vmcs_writel(GUEST_RSP, kvm_rsp_read(vcpu));
> +
>   	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
> -		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
> +		vmcs_writel(GUEST_RIP, kvm_rip_read(vcpu));
>   
>   	cr3 = __get_current_cr3_fast();
>   	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
> 

