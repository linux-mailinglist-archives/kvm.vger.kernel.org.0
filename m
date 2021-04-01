Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ADF351E97
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbhDASnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237424AbhDASdO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiQ9rOWn5ijyokOAeU30eSmsI7AHHfrMvUwmLdRJ+Rw=;
        b=BHZ4YmHa8cbNFLoxyqK+U4vRWwJIqMxnHBYktM6Fx+PJMfHKanr9PmTqjZ9SZK8PONHO20
        1rm1maf7YlUZOBsD1L/m5C0qm+jIzMSR6Aej3v8o3QTEAbaqeIbrIBXZu7sheBjKR7OPf6
        BdFqdNAosXo4q0J8vVa3O6yIOwg9plE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-zRd8WInbNhqlZN4dOqk01A-1; Thu, 01 Apr 2021 10:31:38 -0400
X-MC-Unique: zRd8WInbNhqlZN4dOqk01A-1
Received: by mail-ed1-f72.google.com with SMTP id h2so2921343edw.10
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 07:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tiQ9rOWn5ijyokOAeU30eSmsI7AHHfrMvUwmLdRJ+Rw=;
        b=c9/ExypcbWC3u98TZmMZ0Tg/mV96eSndNJ0RShmL+XJpz0c+nqJuxVxz1Ia2Wp8Nc7
         BeOkak3iPa7FkNjE5P/8tIAhFnD4V9oPm0Cjh5OZze5AOcbjIbc2EXW7bt6AOQiodpT2
         wluMbbhz/DENonaSqMM8TqxnveG+74BrjOAPdNoXb/X5YxsiQyE9/X+yWVGpdmipxR0S
         4RPwtw81/sG/eYOHQAW/Sp7vK6c2WosQCakcxU7I+4B1EXdT5qOM5XWGyLhYLbKqExi5
         6kBBkSAj9AZX0Mes7VoDifuITScN00KVRuDGa1lK9nj9M76h5iSVAqauOaw/Btg8C2Jy
         0JLA==
X-Gm-Message-State: AOAM533I20YaZVcp9W3wIqhpHIpxyPKkBCiK9or4DJZCvQe6onY1fizL
        6TTd+Jy4MfpHL6v6zu7XsLK/HO9Nd4F8GLI7L3gM6iblsN1M5JBtxohFXDCbqZQ8jVTE69YXg1c
        2MzGwo8Ju+MQi
X-Received: by 2002:aa7:c4d1:: with SMTP id p17mr10264943edr.387.1617287497481;
        Thu, 01 Apr 2021 07:31:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6mU+Q/LOu84yiIIy4TEIjyXFKZ+mtVxpbEX19K1qtpR2QGe4UfmJAUakTOFz0J6BZmPkLow==
X-Received: by 2002:aa7:c4d1:: with SMTP id p17mr10264911edr.387.1617287497272;
        Thu, 01 Apr 2021 07:31:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gn19sm2760705ejc.4.2021.04.01.07.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:31:36 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: nSVM: call nested_svm_load_cr3 on nested state
 load
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8d2f348-c16e-a531-21b7-31af92b12125@redhat.com>
Date:   Thu, 1 Apr 2021 16:31:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401141814.1029036-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:18, Maxim Levitsky wrote:
> While KVM's MMU should be fully reset by loading of nested CR0/CR3/CR4
> by KVM_SET_SREGS, we are not in nested mode yet when we do it and therefore
> only root_mmu is reset.
> 
> On regular nested entries we call nested_svm_load_cr3 which both updates
> the guest's CR3 in the MMU when it is needed, and it also initializes
> the mmu again which makes it initialize the walk_mmu as well when nested
> paging is enabled in both host and guest.
> 
> Since we don't call nested_svm_load_cr3 on nested state load,
> the walk_mmu can be left uninitialized, which can lead to a NULL pointer
> dereference while accessing it if we happen to get a nested page fault
> right after entering the nested guest first time after the migration and
> we decide to emulate it, which leads to the emulator trying to access
> walk_mmu->gva_to_gpa which is NULL.
> 
> Therefore we should call this function on nested state load as well.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 40 +++++++++++++++++++++------------------
>   1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8523f60adb92..ac5e3e17bda4 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -215,24 +215,6 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>   	return true;
>   }
>   
> -static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	if (WARN_ON(!is_guest_mode(vcpu)))
> -		return true;
> -
> -	if (!nested_svm_vmrun_msrpm(svm)) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror =
> -			KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
>   static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>   {
>   	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
> @@ -1312,6 +1294,28 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> +static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (WARN_ON(!is_guest_mode(vcpu)))
> +		return true;
> +
> +	if (nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
> +				nested_npt_enabled(svm)))
> +		return false;
> +
> +	if (!nested_svm_vmrun_msrpm(svm)) {
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->internal.suberror =
> +			KVM_INTERNAL_ERROR_EMULATION;
> +		vcpu->run->internal.ndata = 0;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   struct kvm_x86_nested_ops svm_nested_ops = {
>   	.check_events = svm_check_nested_events,
>   	.triple_fault = nested_svm_triple_fault,
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

