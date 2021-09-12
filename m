Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6EF407E32
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhILP7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 11:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhILP7n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 11:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631462308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfkCLhQjkEJmJ1j4mWHgvbULQtNu9xPhouoVxezHb10=;
        b=RxRmJwVjx8no58lmhL4J9ebQCCbZmwv+qlyd0c3/Q7Ppc0y9c/AcS1WRONxQX2egG5tgCx
        NjqsqCxceGzOWEOqM46Bl0JJjqoQIX3xUKwEhvhG3UAkbaHBjERfumiLrZqz2Ay649V1bm
        GZguV/Dd64mhZ3/Ht3Jh05gzKJvtX88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-KJy9WGiHPBaMSXQvcAgnsw-1; Sun, 12 Sep 2021 11:58:27 -0400
X-MC-Unique: KJy9WGiHPBaMSXQvcAgnsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E74824FA6;
        Sun, 12 Sep 2021 15:58:25 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE0135D6CF;
        Sun, 12 Sep 2021 15:58:22 +0000 (UTC)
Message-ID: <6424b309216b276e46a66573320b3eed8209a0ed.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 18:58:21 +0300
In-Reply-To: <20210910160633.451250-2-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
         <20210910160633.451250-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 18:06 +0200, Vitaly Kuznetsov wrote:
> When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
> VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
> are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
> updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
> clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
> done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
> MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
> MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
> check if the resulting bitmap is different and never cleans
> HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
> may result in Hyper-V missing the update.
> 
> The issue could've been solved by calling evmcs_touch_msr_bitmap() for
> eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
> would not give any performance benefits (compared to not using Enlightened
> MSR Bitmap at all). 3-level nesting is also not a very common setup
> nowadays.
> 
> Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
> now.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0c2c0d5ae873..ae470afcb699 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2654,15 +2654,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>  		if (!loaded_vmcs->msr_bitmap)
>  			goto out_vmcs;
>  		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
> -
> -		if (IS_ENABLED(CONFIG_HYPERV) &&
> -		    static_branch_unlikely(&enable_evmcs) &&
> -		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> -			struct hv_enlightened_vmcs *evmcs =
> -				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
> -
> -			evmcs->hv_enlightenments_control.msr_bitmap = 1;
> -		}
>  	}
>  
>  	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
> @@ -6861,6 +6852,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vmx->loaded_vmcs = &vmx->vmcs01;
> +
> +	/*
> +	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
> +	 * nested (L1) hypervisor and Hyper-V in L0 supports it.
> +	 */
> +	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)
> +	    && (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> +		struct hv_enlightened_vmcs *evmcs =
> +			(struct hv_enlightened_vmcs *)vmx->loaded_vmcs->vmcs;
> +
> +		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> +	}
> +
>  	cpu = get_cpu();
>  	vmx_vcpu_load(vcpu, cpu);
>  	vcpu->cpu = cpu;

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


However, just a note that it is very very confusing that KVM can use eVMCS in both ways.
 
 
'Client': It can both run under HyperV, and thus take advantage of eVMCS when it runs its guests (with
help of
HyperV)
 
'Server' KVM can emulate some HyperV features, and one of these is eVMCS, thus a windows guest running
under KVM, can use KVM's eVMCS implementation to run nested guests.
 
This patch fails under
'Client', while the other patches in the series fall under the 'Server' category,
and even more confusing, the patch 2 moves 'Client' code around, but it is intended for following patches
3,4 which are
for Server.
 

Thus this patch probably should be a separate patch, just to avoid confusion.

However, since this patch series is already posted, and I figured that out, and hopefully explained it here,
no need to do anything though!


Best regards,
	Maxim Levitsky



