Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59538F290
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhEXRwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233645AbhEXRwu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMi9zXi2gPJ2ap3L2lM4o50ERJihHyR/00c7PHLRKr0=;
        b=brvwiXDugJGHJ0Y2tLUwvO4Lzn1bbsx/IiRMR28ok2RTBOVv+naMhMELQ461Krlnw3K8pE
        tK+TC+LOr8Wpoc611iXNdiqtajCBz1sB5xlALDNzgzVeA2VFKWvmVazydr/s5O5yFwt04o
        /IS9zMNORSTIG2SIfeulJ5FRab9EtjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-mYxwOOMsN0S1Xe4Kjo-Sbg-1; Mon, 24 May 2021 13:51:20 -0400
X-MC-Unique: mYxwOOMsN0S1Xe4Kjo-Sbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5B908BD1CA;
        Mon, 24 May 2021 17:51:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BD2A60855;
        Mon, 24 May 2021 17:51:10 +0000 (UTC)
Message-ID: <1110a7a9079031d9148142fe00356bf3a855258f.camel@redhat.com>
Subject: Re: [PATCH v3 07/12] KVM: X86: Add functions that calculate L2's
 TSC offset and multiplier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:51:09 +0300
In-Reply-To: <20210521102449.21505-8-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-8-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> When L2 is entered we need to "merge" the TSC multiplier and TSC offset
> values of 01 and 12 together.
> 
> The merging is done using the following equations:
>   offset_02 = ((offset_01 * mult_12) >> shift_bits) + offset_12
>   mult_02 = (mult_01 * mult_12) >> shift_bits
> 
> Where shift_bits is kvm_tsc_scaling_ratio_frac_bits.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0f2cf5d1240c..aaf756442ed1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1792,6 +1792,8 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
>  
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
> +u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier);
> +u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
>  
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
>  bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fdcb4f46a003..04abaacb9cfc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2334,6 +2334,31 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
> +u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier)
> +{
> +	u64 nested_offset;
> +
> +	if (l2_multiplier == kvm_default_tsc_scaling_ratio)
> +		nested_offset = l1_offset;
> +	else
> +		nested_offset = mul_s64_u64_shr((s64) l1_offset, l2_multiplier,
> +						kvm_tsc_scaling_ratio_frac_bits);
> +
> +	nested_offset += l2_offset;
> +	return nested_offset;
> +}
> +EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_offset);
Looks OK.

> +
> +u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
> +{
> +	if (l2_multiplier != kvm_default_tsc_scaling_ratio)
> +		return mul_u64_u64_shr(l1_multiplier, l2_multiplier,
> +				       kvm_tsc_scaling_ratio_frac_bits);
> +
> +	return l1_multiplier;
> +}
> +EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
Looks OK as well.


> +
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	vcpu->arch.l1_tsc_offset = offset;


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

