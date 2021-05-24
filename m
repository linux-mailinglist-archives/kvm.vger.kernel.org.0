Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8238F285
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhEXRvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233199AbhEXRvI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fz0T0ejJHuebghS5Z0ND6NkHR4k7KRsdFbY1k9dZNyM=;
        b=SJo4rpd2EwWx343inqbe2MQZKxJ6GJA5+CkF58WvFY3kyH/31PPc5TH0+nWNWvxYfPCq6n
        Bw3u7MgZJXv232qbV4ofVt4gHQ9VJupY5JPlSdmMo2NIc0vUOIcQiBcfxVAFg2Iro7s+KC
        IOArn7d4xD6kBNLlZkdxNgymGN+6+Xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-nMQI2-k4N7a9HaqNmXoV8w-1; Mon, 24 May 2021 13:49:34 -0400
X-MC-Unique: nMQI2-k4N7a9HaqNmXoV8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F31CC801B15;
        Mon, 24 May 2021 17:49:32 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7489C36DE;
        Mon, 24 May 2021 17:49:29 +0000 (UTC)
Message-ID: <05c98b5e6627ddb01bbedb08a2854d8c55bdc2d7.camel@redhat.com>
Subject: Re: [PATCH v3 02/12] KVM: X86: Store L1's TSC scaling ratio in
 'struct kvm_vcpu_arch'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:49:28 +0300
In-Reply-To: <20210521102449.21505-3-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-3-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> Store L1's scaling ratio in the kvm_vcpu_arch struct like we already do
> for L1's TSC offset. This allows for easy save/restore when we enter and
> then exit the nested guest.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 5 +++--
>  arch/x86/kvm/vmx/vmx.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 6 ++++--
>  3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 55efbacfc244..7dfc609eacd6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -707,7 +707,7 @@ struct kvm_vcpu_arch {
>  	} st;
>  
>  	u64 l1_tsc_offset;
> -	u64 tsc_offset;
> +	u64 tsc_offset; /* current tsc offset */
>  	u64 last_guest_tsc;
>  	u64 last_host_tsc;
>  	u64 tsc_offset_adjustment;
> @@ -721,7 +721,8 @@ struct kvm_vcpu_arch {
>  	u32 virtual_tsc_khz;
>  	s64 ia32_tsc_adjust_msr;
>  	u64 msr_ia32_power_ctl;
> -	u64 tsc_scaling_ratio;
> +	u64 l1_tsc_scaling_ratio;
> +	u64 tsc_scaling_ratio; /* current scaling ratio */
>  
>  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
>  	unsigned nmi_pending; /* NMI queued after currently running handler */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..3e4dda8177bb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7453,10 +7453,10 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
>  		delta_tsc = 0;
>  
>  	/* Convert to host delta tsc if tsc scaling is enabled */
> -	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio &&
> +	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio &&
>  	    delta_tsc && u64_shl_div_u64(delta_tsc,
>  				kvm_tsc_scaling_ratio_frac_bits,
> -				vcpu->arch.tsc_scaling_ratio, &delta_tsc))
> +				vcpu->arch.l1_tsc_scaling_ratio, &delta_tsc))
>  		return -ERANGE;
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04e67ad..6ab95ac188a5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2185,6 +2185,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  
>  	/* Guest TSC same frequency as host TSC? */
>  	if (!scale) {
> +		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		return 0;
>  	}
> @@ -2211,7 +2212,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  		return -1;
>  	}
>  
> -	vcpu->arch.tsc_scaling_ratio = ratio;
> +	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
>  	return 0;
>  }
>  
> @@ -2223,6 +2224,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
>  	/* tsc_khz can be zero if TSC calibration fails */
>  	if (user_tsc_khz == 0) {
>  		/* set tsc_scaling_ratio to a safe value */
> +		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		return -1;
>  	}
> @@ -2459,7 +2461,7 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
>  
>  static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
>  {
> -	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
> +	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
>  		WARN_ON(adjustment < 0);
>  	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
>  	adjust_tsc_offset_guest(vcpu, adjustment);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

