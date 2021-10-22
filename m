Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0B437963
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhJVOyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233122AbhJVOyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 10:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634914311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJy0TbYPUEu7s3b9vebFORfNw2jMil9GFR8f8Kyxi+A=;
        b=bCQYyOPRkjHTKs33fFEDNhPfESh+o9xiJW/cyWh3rXQZfPuR+Fa/Tkzb8evFj9EY1ZJ5PH
        ZXIeKLfL6e4ReDuTlcUUFJf/glrBZXLYHENu3BiRck2LflVURtYnnjDp4mTXvd/7Mtse1p
        G8kRNJUDndSyenBS8PxlyruPnywfs18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-en1edNvDNfSL7eZVwJpQ9A-1; Fri, 22 Oct 2021 10:51:47 -0400
X-MC-Unique: en1edNvDNfSL7eZVwJpQ9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DDA81006AA6;
        Fri, 22 Oct 2021 14:51:46 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8748E5D9DE;
        Fri, 22 Oct 2021 14:51:42 +0000 (UTC)
Message-ID: <5769f5eca1d55f9d94a2fe6d957041b3fb856a12.camel@redhat.com>
Subject: Re: [PATCH v3 8/8] nSVM: remove unnecessary parameter in
 nested_vmcb_check_controls
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
Date:   Fri, 22 Oct 2021 17:51:41 +0300
In-Reply-To: <20211011143702.1786568-9-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
         <20211011143702.1786568-9-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 10:37 -0400, Emanuele Giuseppe Esposito wrote:
> Just as in nested_vmcb_valid_sregs, we only need the vcpu param
> to perform the checks on vmcb nested state, since we always
> look at the cached fields.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 13be1002ad1c..19bce3819cce 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -209,9 +209,11 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
>  	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>  }
>  
> -static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> -				       struct vmcb_ctrl_area_cached *control)
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
> +
>  	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
>  		return false;
>  
> @@ -651,7 +653,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
>  	if (!nested_vmcb_valid_sregs(vcpu) ||
> -	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> +	    !nested_vmcb_check_controls(vcpu)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
>  		vmcb12->control.exit_info_1  = 0;
> @@ -1367,7 +1369,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	ret = -EINVAL;
>  	nested_copy_vmcb_control_to_cache(svm, ctl);
> -	if (!nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
> +	if (!nested_vmcb_check_controls(vcpu))
>  		goto out_free_ctl;
>  
>  	/*

Because of the issue I pointed out in patch 7, you probably want:


static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
                                         struct vmcb_ctrl_area_cached *control)
{
	....
}


static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
{
	return __nested_vmcb_check_controls(vcpu, &svm->nested.ctl);
}



Same for nested_vmcb_valid_sregs 
(maybe you even want to rename it to nested_vmcb_check_save while at it?):


static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu, struct vmcb_save_area_cached *save)
{
	...
}


static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
{
	return __nested_vmcb_check_save(vcpu, &svm->nested.save);

}


Best regards,
	Maxim Levitsky



