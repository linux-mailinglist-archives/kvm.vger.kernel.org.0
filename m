Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BBD407CE5
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhILKku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhILKku (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631443176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9OX2dXKujvgMs86f/6Rr/Q99b81OvOF+jxSI/UOzvA=;
        b=QWpDq6S3Nn8Ch9Fs3u8kkDuk4KwBPXaOsYwBEa0EFtU9dIJ+Hz8izJEL1ouGocj4kx5oxj
        VgloDJilcEzWcnGuTHXkLSvG6hO9XbZd9i3Jw0qXi/tXIJVBdVL1xbqfAqEFkfTinEMZmA
        JMweaxjCCSfMIL7N4qsF3TJGEMcG8I0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-sKp7u9X_MoKpKJn-y5GMIQ-1; Sun, 12 Sep 2021 06:39:34 -0400
X-MC-Unique: sKp7u9X_MoKpKJn-y5GMIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AC0C659;
        Sun, 12 Sep 2021 10:39:33 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE4DD1B480;
        Sun, 12 Sep 2021 10:39:29 +0000 (UTC)
Message-ID: <fbb40bb8c12715c0aa9d6a113784f8a21603e2b3.camel@redhat.com>
Subject: Re: [RFC PATCH 2/3] nSVM: introduce smv->nested.save to cache save
 area fields
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
Date:   Sun, 12 Sep 2021 13:39:28 +0300
In-Reply-To: <20210903102039.55422-3-eesposit@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-3-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 12:20 +0200, Emanuele Giuseppe Esposito wrote:
> This is useful in next patch, to avoid having temporary
> copies of vmcb12 registers and passing them manually.

This is NOT what I had in mind, but I do like that idea very much,
IMHO this is much better than what I had in mind!

The only thing that I would change is that I woudn't reuse 'struct vmcb_save_area'
for the copy, as this both wastes space (minor issue), 
and introduces a chance of someone later using non copied
fields from it (can cause a bug later on).

I would just define a new struct for that (but keep same names
for readability)

Maybe something like 'struct vmcb_save_area_cached'?

> 
> Right now, instead of blindly copying everything,
> we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
> will need to be added, it will be more obvious to see
> that they must be added in copy_vmcb_save_area,
> otherwise the checks will fail.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 24 ++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    |  1 +
>  arch/x86/kvm/svm/svm.h    |  3 +++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d2fe65e2a7a4..2491c77203c7 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -194,6 +194,22 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
>  	dst->pause_filter_thresh  = from->pause_filter_thresh;
>  }
>  
> +static void copy_vmcb_save_area(struct vmcb_save_area *dst,
> +				struct vmcb_save_area *from)
> +{
> +	/*
> +	 * Copy only necessary fields, as we need them
> +	 * to avoid TOC/TOU races.
> +	 */
> +	dst->efer = from->efer;
> +	dst->cr0 = from->cr0;
> +	dst->cr3 = from->cr3;
> +	dst->cr4 = from->cr4;
> +
> +	dst->dr6 = from->dr6;
> +	dst->dr7 = from->dr7;
> +}
> +
>  static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  {
>  	/*
> @@ -313,6 +329,12 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>  }
>  
> +void nested_load_save_from_vmcb12(struct vcpu_svm *svm,
> +				  struct vmcb_save_area *save)
> +{
> +	copy_vmcb_save_area(&svm->nested.save, save);
> +}
> +
>  /*
>   * Synchronize fields that are written by the processor, so that
>   * they can be copied back into the vmcb12.
> @@ -647,6 +669,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +	nested_load_save_from_vmcb12(svm, &vmcb12->save);
>  
>  	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>  	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> @@ -1385,6 +1408,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
>  	nested_load_control_from_vmcb12(svm, ctl);
> +	nested_load_save_from_vmcb12(svm, save);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  	nested_vmcb02_prepare_control(svm);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 69639f9624f5..169b930322ef 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4386,6 +4386,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  			vmcb12 = map.hva;
>  
>  			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +			nested_load_save_from_vmcb12(svm, &vmcb12->save);
>  
>  			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
>  			kvm_vcpu_unmap(vcpu, &map, true);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index bd0fe94c2920..6d12814cf64c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -119,6 +119,7 @@ struct svm_nested_state {
>  
>  	/* cache for control fields of the guest */
>  	struct vmcb_control_area ctl;
> +	struct vmcb_save_area save;
>  
>  	bool initialized;
>  };
> @@ -484,6 +485,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  				     struct vmcb_control_area *control);
> +void nested_load_save_from_vmcb12(struct vcpu_svm *svm,
> +				  struct vmcb_save_area *save);
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
>  void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);

So besides the struct comment:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


