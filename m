Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B64378FFF
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbhEJN6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244106AbhEJN4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09CofHNrvg9lN9twReVEq7VYedQ1Z74TTqfhajoGBdE=;
        b=Q+pxh2+4UoviK10EAwWo0eDdtltkXvfNvuUubGAwU8Kku3sDx9hqqpLO6nvEPN9M17sZap
        N83XsmXyQsg0WwandPFdEIjcpe7f64+UKixezQLDq7XIzFQAdkrp+XrI2EIVWiEcu6Gs2K
        jUbd45Hs45Lp04h9Vx2S3HUofjU/EYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-2VnHGOGrN4mGSGxWL6FekA-1; Mon, 10 May 2021 09:55:28 -0400
X-MC-Unique: 2VnHGOGrN4mGSGxWL6FekA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0998081840E;
        Mon, 10 May 2021 13:55:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 421977013B;
        Mon, 10 May 2021 13:54:55 +0000 (UTC)
Message-ID: <a83fa70e3111f9c9bcbc5204569d084229815b9a.camel@redhat.com>
Subject: Re: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with
 nested TSC scaling
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:54:38 +0300
In-Reply-To: <20210506103228.67864-7-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-7-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> Calculating the current TSC offset is done differently when nested TSC
> scaling is used.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 49241423b854..df7dc0e4c903 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1797,10 +1797,16 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>  		vmx_update_msr_bitmap(&vmx->vcpu);
>  }
>  
> -static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +/*
> + * This function receives the requested offset for L1 as an argument but it
> + * actually writes the "current" tsc offset to the VMCS and returns it. The
> + * current offset might be different in case an L2 guest is currently running
> + * and its VMCS02 is loaded.
> + */
(Not related to this patch) It might be a good idea to rename this callback
instead of this comment, but I am not sure about it.


> +static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -	u64 g_tsc_offset = 0;
> +	u64 cur_offset = l1_offset;
>  
>  	/*
>  	 * We're here if L1 chose not to trap WRMSR to TSC. According
> @@ -1809,11 +1815,19 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  	 * to the newly set TSC to get L2's TSC.
>  	 */
>  	if (is_guest_mode(vcpu) &&
> -	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
> -		g_tsc_offset = vmcs12->tsc_offset;
> +	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)) {
> +		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
> +			cur_offset = kvm_compute_02_tsc_offset(
> +					l1_offset,
> +					vmcs12->tsc_multiplier,
> +					vmcs12->tsc_offset);
> +		} else {
> +			cur_offset = l1_offset + vmcs12->tsc_offset;
> +		}
> +	}
>  
> -	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
> -	return offset + g_tsc_offset;
> +	vmcs_write64(TSC_OFFSET, cur_offset);
> +	return cur_offset;
>  }
>  
>  /*

This code would be ideal to move to common code as SVM will do basically
the same thing.
Doesn't have to be done now though.


Best regards,
	Maxim Levitsky

