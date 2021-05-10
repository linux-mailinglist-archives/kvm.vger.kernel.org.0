Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72CB377E25
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhEJI1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:27:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJI1q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWcIao3fyIb+rZwFq38FUEtAAU/boSjtt1gdDYbHnw8=;
        b=H/BPrvzpylHzy9s3eYdEUXkwlWTinHfBQaNOprEhE3D/TpIR/CSf+mYUGVeOOKEaqObkOn
        oLKzUUqr/l33csMthZ1UUauolO/3/MKnReCFyDK59F95WjHTnE6fCuKsjKIU61NnqoiI0/
        A2DDp8r+wioHvTd88nvcvicv/IaTuSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-618f1OB5MduTzUi6JbqDsg-1; Mon, 10 May 2021 04:26:37 -0400
X-MC-Unique: 618f1OB5MduTzUi6JbqDsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F6A01883520;
        Mon, 10 May 2021 08:26:36 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F36B317253;
        Mon, 10 May 2021 08:26:32 +0000 (UTC)
Message-ID: <a8595d87b67616a7ac25784c6acdebbd170d2f5a.camel@redhat.com>
Subject: Re: [PATCH 11/15] KVM: VMX: Disable loading of TSX_CTRL MSR the
 more conventional way
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:26:31 +0300
In-Reply-To: <20210504171734.1434054-12-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Tag TSX_CTRL as not needing to be loaded when RTM isn't supported in the
> host.  Crushing the write mask to '0' has the same effect, but requires
> more mental gymnastics to understand.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4b432d2bbd06..7a53568b34fc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1771,7 +1771,13 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>  			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
>  			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
>  
> -	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, true);
> +	/*
> +	 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations of new
> +	 * kernel and old userspace.  If those guests run on a tsx=off host, do
> +	 * allow guests to use TSX_CTRL, but don't change the value in hardware
> +	 * so that TSX remains always disabled.
> +	 */
> +	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, boot_cpu_has(X86_FEATURE_RTM));
>  
>  	if (cpu_has_vmx_msr_bitmap())
>  		vmx_update_msr_bitmap(&vmx->vcpu);
> @@ -6919,23 +6925,15 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  		vmx->guest_uret_msrs[i].data = 0;
>  		vmx->guest_uret_msrs[i].mask = -1ull;
>  	}
> -	tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> -	if (tsx_ctrl) {
> +	if (boot_cpu_has(X86_FEATURE_RTM)) {
>  		/*
>  		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
>  		 * Keep the host value unchanged to avoid changing CPUID bits
>  		 * under the host kernel's feet.
> -		 *
> -		 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations
> -		 * of new kernel and old userspace.  If those guests run on a
> -		 * tsx=off host, do allow guests to use TSX_CTRL, but do not
> -		 * change the value on the host so that TSX remains always
> -		 * disabled.
>  		 */
> -		if (boot_cpu_has(X86_FEATURE_RTM))
> +		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> +		if (tsx_ctrl)
>  			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> -		else
> -			vmx->guest_uret_msrs[i].mask = 0;
>  	}
>  
>  	err = alloc_loaded_vmcs(&vmx->vmcs01);

I also agree that commit message should be updated as Paolo said,
but other than that:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky <mlevitsk@redhat.com>



