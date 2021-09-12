Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23D5407CE1
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhILKhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234942AbhILKhh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631442983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jtt+oEw1ZNN1QEhzO+iGOuy7I227KftkhvSAbDZ7/c=;
        b=igpL6NC/oF/dPjTlZcJb8tXgigYbe9h2N8FLMkjoaj3f8kG/TcR1Ecx4felCBPdVtp/fzG
        hlr1IpWjnwf65RCFPwvL9i36SpDifCx+RymI1RRcRnaC7XfPMXYrtzy49Ef4y3fkVdp0iM
        Z5lNeP36w+fZzEKhBSBGujepnkKcCEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-rwu6vjPmM4CHXSKAtNZ7OQ-1; Sun, 12 Sep 2021 06:36:20 -0400
X-MC-Unique: rwu6vjPmM4CHXSKAtNZ7OQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F7F836307;
        Sun, 12 Sep 2021 10:36:18 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E9861B480;
        Sun, 12 Sep 2021 10:36:12 +0000 (UTC)
Message-ID: <fc4c9ba831c75781a4831d13fde7b3034342afc0.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic
 in nested_vmcb_valid_sregs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 13:36:11 +0300
In-Reply-To: <20210903102039.55422-2-eesposit@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-2-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 12:20 +0200, Emanuele Giuseppe Esposito wrote:
> Inline nested_vmcb_check_cr3_cr4 as it is not called by anyone else.
> Doing so simplifies next patches.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 35 +++++++++++++----------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e5515477c30a..d2fe65e2a7a4 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -260,27 +260,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
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
> @@ -302,7 +281,19 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

