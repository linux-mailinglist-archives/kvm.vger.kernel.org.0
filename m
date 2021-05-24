Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAECD38E6AC
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhEXMgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232744AbhEXMgJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWAemnMdLESRbRSHAcnPaLJhW1sdIBiwkO7JDr1KeaY=;
        b=EvzovdQaqZGL4vKZewpg8UYbzJbf8BeN6oWBgTkdm3zOkHUvIwD1dqTU3101r/WM5ec1KL
        diMvEsQxyZfgOFH5jJE9aEiKvqxbZ86lOB+3nyY//eNHhhyo0fnyhNYv+oAKP/kK+qMl6Z
        0xP3Ke1vtqST6TuRSA17vBHy7vDjCog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-cS7AYd5zOkulW-jISTK3UA-1; Mon, 24 May 2021 08:34:39 -0400
X-MC-Unique: cS7AYd5zOkulW-jISTK3UA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AEF41083E93;
        Mon, 24 May 2021 12:34:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 197A46267F;
        Mon, 24 May 2021 12:34:35 +0000 (UTC)
Message-ID: <2abf028db2a77c940d89618d66c4e6cbc3347bc4.camel@redhat.com>
Subject: Re: [PATCH v2 5/7] KVM: nVMX: Reset eVMCS clean fields data from
 prepare_vmcs02()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:34:34 +0300
In-Reply-To: <20210517135054.1914802-6-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> When nested state migration happens during L1's execution, it
> is incorrect to modify eVMCS as it is L1 who 'owns' it at the moment.
> At lease genuine Hyper-v seems to not be very happy when 'clean fields'
> data changes underneath it.
> 
> 'Clean fields' data is used in KVM twice: by copy_enlightened_to_vmcs12()
> and prepare_vmcs02_rare() so we can reset it from prepare_vmcs02() instead.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index eb2d25a93356..3bfbf991bf45 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2081,14 +2081,10 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (vmx->nested.hv_evmcs) {
> +	if (vmx->nested.hv_evmcs)
>  		copy_vmcs12_to_enlightened(vmx);
> -		/* All fields are clean */
> -		vmx->nested.hv_evmcs->hv_clean_fields |=
> -			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> -	} else {
> +	else
>  		copy_vmcs12_to_shadow(vmx);
> -	}
>  
>  	vmx->nested.need_vmcs12_to_shadow_sync = false;
>  }
> @@ -2629,6 +2625,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  
>  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
>  	kvm_rip_write(vcpu, vmcs12->guest_rip);
> +
> +	/* Mark all fields as clean so L1 hypervisor can set what's dirty */
> +	if (hv_evmcs)
> +		vmx->nested.hv_evmcs->hv_clean_fields |=
> +			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> +
>  	return 0;
>  }
> 

Hi!
 
If we avoid calling copy_enlightened_to_vmcs12 from 
vmx_get_nested_state, then we don't need this patch, right?
 
In addition to that I think that we need to research on why 
do we need to touch these clean bits, as from the spec, and
assuming that the clean bits should behave similar to how AMD
does it, clean bits should only be set by the L1 and never touched by
us.
 
We currently set clean bits in two places:
 
1. nested_vmx_handle_enlightened_vmptrld with vmlaunch, where it seems
like it is a workaround for a case (as we discussed on IRC) where
L1 keeps more than one active evmcs on a same vcpu, and 'vmresume's
them. Since we don't support this and have to do full context switch
when we switch a vmcs, we reset the clean bits so that evmcs is loaded
fully.
Also we reset the clean bits when a evmcs is 'vmlaunched' which
is also something we need to check if needed, and if needed
we probably should document that this is because of a bug in Hyper-V,
as it really should initialize these bits in this case.
 
I think that we should just ignore the clean bits in those cases
instead of resetting them in the evmcs.
 
 
2. In nested_sync_vmcs12_to_shadow which in practise is done only
on nested vmexits, when we updated the vmcs12 and need to update evmcs.
In this case you told me that Hyper-V has a bug that it expects
the clean bits to be cleaned by us and doesn't clean it on its own.
This makes sense although it is not documented in the Hyper-V spec,
and I would appreciate if we were to document this explicitly in the code.

 
Best regards,
	Maxim Levitsky
>  


