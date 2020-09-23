Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1256275C6E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIWPxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 11:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWPxZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 11:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600876403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvoZjFoAXATFKB4M1a0vPq8qr1vfsykSfzKsPDIGbgY=;
        b=BrNMq/fKB5bQMdBFifyPOjMy+lwBoG+TSRJOcihrdaTM5j56G2xB88MLbk4VLwAp7DCtML
        PT+nEwE8TXNxcTY2FSyqYkjTMsozs30BWRadr95kEKpfLeC30L9N7w0eL3sG0vi2lmZ/DI
        3ES62I1JKCfg9mh1hyQTFexKtNyTC/A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-34z9nsOvMqW2Rcl6fUkvCA-1; Wed, 23 Sep 2020 11:53:21 -0400
X-MC-Unique: 34z9nsOvMqW2Rcl6fUkvCA-1
Received: by mail-wm1-f69.google.com with SMTP id b20so2481483wmj.1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 08:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MvoZjFoAXATFKB4M1a0vPq8qr1vfsykSfzKsPDIGbgY=;
        b=hQqgEYnYVJIuthDemYSZq2cKdaA+NdyHcGu7wVjZj7d9k8bdLiZFWBQLEsACcL/Lbf
         by1Ix6x9p84c6xH+LsUlO5KYZf5jn0+99qpYI7abr7I1365UgA7FdC++jf9HCl6jZ/MD
         PBv1ZjsPPPPCeGBoxaDwf7HBn4U6reSVFLpy4NuHYvKmxmXnOq9T7/6KjfPLu+dV7qM9
         lGSIvz7lH5qPY2Kr1BFwLCYzGJxPkZHQyrWAWYH7y0ct/XYAQzP5jg78csScu8OtWt99
         x1S+xxM8pEm+07xSNlpWUBTp299e5951qQ2iizjs9/CYAyPl1JvAw2+JJayhD4mrjYcj
         /nZQ==
X-Gm-Message-State: AOAM531IjvExVwX6/hnfmnZAYnvVlF4IX5W/hrnBFXRJ4dl6pbM9dbwa
        Nn/Cstr58aeGBgB74mfkw9WC3F2PlpPeUe5mG0Nq6RhJfK00UEk5FZRnfwxko1pFY4wIZDDkat4
        GzNlFAV9eGayO
X-Received: by 2002:adf:9d44:: with SMTP id o4mr277035wre.361.1600876400614;
        Wed, 23 Sep 2020 08:53:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPS0sff79HiabvQgbnRUjq/GOZkD9cxtaZvGxT+hOWz/ZFrBZ7tBoCYQZzLL5cko+6sa4qNA==
X-Received: by 2002:adf:9d44:: with SMTP id o4mr277018wre.361.1600876400409;
        Wed, 23 Sep 2020 08:53:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id m185sm252566wmf.5.2020.09.23.08.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 08:53:19 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: nSVM: Add check for CR3 and CR4 reserved bits to
 svm_set_nested_state()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
 <20200829004824.4577-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af85c9cb-2bce-6022-7640-f827673c26eb@redhat.com>
Date:   Wed, 23 Sep 2020 17:53:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200829004824.4577-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/20 02:48, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 51 ++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fb68467e6049..7a51ce465f3e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -215,9 +215,35 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	return true;
>  }
>  
> +static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
> +				      struct vmcb_save_area *save)
> +{
> +	bool nested_vmcb_lma =
> +	        (save->efer & EFER_LME) &&
> +		(save->cr0 & X86_CR0_PG);
> +
> +	if (!nested_vmcb_lma) {
> +		if (save->cr4 & X86_CR4_PAE) {
> +			if (save->cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> +				return false;
> +		} else {
> +			if (save->cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> +				return false;
> +		}
> +	} else {
> +		if (!(save->cr4 & X86_CR4_PAE) ||
> +		    !(save->cr0 & X86_CR0_PE) ||
> +		    (save->cr3 & MSR_CR3_LONG_MBZ_MASK))
> +			return false;
> +	}
> +	if (kvm_valid_cr4(&svm->vcpu, save->cr4))
> +		return false;
> +
> +	return true;
> +}
> +
>  static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>  {
> -	bool nested_vmcb_lma;
>  	if ((vmcb->save.efer & EFER_SVME) == 0)
>  		return false;
>  
> @@ -228,25 +254,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>  	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
>  		return false;
>  
> -	nested_vmcb_lma =
> -	        (vmcb->save.efer & EFER_LME) &&
> -		(vmcb->save.cr0 & X86_CR0_PG);
> -
> -	if (!nested_vmcb_lma) {
> -		if (vmcb->save.cr4 & X86_CR4_PAE) {
> -			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> -				return false;
> -		} else {
> -			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> -				return false;
> -		}
> -	} else {
> -		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
> -		    !(vmcb->save.cr0 & X86_CR0_PE) ||
> -		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
> -			return false;
> -	}
> -	if (kvm_valid_cr4(&svm->vcpu, vmcb->save.cr4))
> +	if (!nested_vmcb_check_cr3_cr4(svm, &(vmcb->save)))
>  		return false;
>  
>  	return nested_vmcb_check_controls(&vmcb->control);
> @@ -1114,9 +1122,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	/*
>  	 * Validate host state saved from before VMRUN (see
>  	 * nested_svm_check_permissions).
> -	 * TODO: validate reserved bits for all saved state.
>  	 */
> -	if (!(save.cr0 & X86_CR0_PG))
> +	if (!nested_vmcb_check_cr3_cr4(svm, &save))
>  		return -EINVAL;

Removing the "if" is incorrect.  Also are there really no more reserved
bits to check?

Paolo

