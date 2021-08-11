Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31673E99C6
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhHKUib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 16:38:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229589AbhHKUib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 16:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628714287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ka+IaiRT9uoAXjkqh+ylnD8wbn5wPgLIQgiXRNpQ8s=;
        b=T9zTIiAGVKKA+PItBhu7/jtoNoUCsw0whYRFeP88Votj+8rq2X78MgDi13/Zv3to2KeILV
        1Z4cu7TUdaa2bQqh7mvzEgK0L6967pnJZyBPNis+qEQTwAGo92cl+/pnx089v5hCTLAJvo
        EuIz66YoLMSn8rA42Oui5ugb9sbx8Og=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-udhTEI-HOB2sH51f10f_Gg-1; Wed, 11 Aug 2021 16:38:05 -0400
X-MC-Unique: udhTEI-HOB2sH51f10f_Gg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6071818C89E6;
        Wed, 11 Aug 2021 20:38:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76DC56A056;
        Wed, 11 Aug 2021 20:37:57 +0000 (UTC)
Message-ID: <3194331f42f5bcf760564b9714edf3d99d7a7b73.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
 nested_vmcb_valid_sregs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Wed, 11 Aug 2021 23:37:56 +0300
In-Reply-To: <20210809145343.97685-2-eesposit@redhat.com>
References: <20210809145343.97685-1-eesposit@redhat.com>
         <20210809145343.97685-2-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-09 at 16:53 +0200, Emanuele Giuseppe Esposito wrote:
> nested_vmcb_check_cr3_cr4 is not called by anyone else, and removing the
> call simplifies next patch

Tiny nitpick: I would call this 'inline the nested_vmcb_check_cr3_cr4' instead of
move, but please feel free to ignore.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 35 +++++++++++++----------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5e13357da21e..0ac2d14add15 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -257,27 +257,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_cr3_cr4(struct kvm_vcpu *vcpu,
> -				      struct vmcb_save_area *save)
> -{
> -	/*
> -	 * These checks are also performed by KVM_SET_SREGS,
> -	 * except that EFER.LMA is not checked by SVM against
> -	 * CR0.PG && EFER.LME.
> -	 */
> -	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
> -		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
> -		    CC(!(save->cr0 & X86_CR0_PE)) ||
> -		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
> -			return false;
> -	}
> -
> -	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
> -		return false;
> -
> -	return true;
> -}
> -
>  /* Common checks that apply to both L1 and L2 state.  */
>  static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  				    struct vmcb_save_area *save)
> @@ -299,7 +278,19 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
>  		return false;
>  
> -	if (!nested_vmcb_check_cr3_cr4(vcpu, save))
> +	/*
> +	 * These checks are also performed by KVM_SET_SREGS,
> +	 * except that EFER.LMA is not checked by SVM against
> +	 * CR0.PG && EFER.LME.
> +	 */
> +	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
> +		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
> +		    CC(!(save->cr0 & X86_CR0_PE)) ||
> +		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
> +			return false;
> +	}
> +
> +	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
>  		return false;
>  
>  	if (CC(!kvm_valid_efer(vcpu, save->efer)))


