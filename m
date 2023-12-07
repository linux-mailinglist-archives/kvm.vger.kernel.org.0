Return-Path: <kvm+bounces-3872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E446F808BEA
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74561B20DF5
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A4F44C9C;
	Thu,  7 Dec 2023 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8rQ0hqj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D688F10E3
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 07:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701963183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aXYZcThuYCHAbdORgsP32hhjeEYnS8/VdqpfdkBxubc=;
	b=K8rQ0hqjCe12m5DoO+vze6wBcBt4BPGgE6WiWnr9noiE4tS8LDStRkKNDER4XyTl1lu9m1
	E/jK5g70iRK7ODp9zTfa/D7eTwCI441/T70lLzfjVm9neKPhQ1gvww+hOhUi4IYpUscy1t
	/+LeMfn5oHqB+lygxxQIMG3m9nSM140=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-CwqABT82OduYvTT2vZkuXQ-1; Thu, 07 Dec 2023 10:33:00 -0500
X-MC-Unique: CwqABT82OduYvTT2vZkuXQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40b3d4d6417so7501065e9.0
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 07:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701963180; x=1702567980;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aXYZcThuYCHAbdORgsP32hhjeEYnS8/VdqpfdkBxubc=;
        b=S/9RtDo3HCq42CMuI5ecKevQOGVgOaCUklfOK6J/dNxNolv+ixMwVKA+5pUv5sLULl
         K4jqU34kcbcnBfDKvPyWIjWIqRTt1eALZJO/YMrpXj7SfzxTi9AIR82cffWkfRAGqE3h
         gXjn0f9xx8sv/c2m6mvyTZejK19anfw0JB8C7ZfypkrYVm//YEZzhFj7KMeXEYr6uxXg
         hJARPs5txD1kTk1ZgeeYTgahFw+vTwcAPwsZZWBDbx6KfqF7qrWwxrHwFlwTmoAUSV86
         J9NAL11vdVQSToGWtTzreaVBeX/N8IWjf2ICrpd3koQi1tU9mDSvG7g7dzDViHEDI8KG
         bHsQ==
X-Gm-Message-State: AOJu0YxM4ZKmEi7wzfzIFdRnFPIEb40lqPQXr5CDkNYQw/mRWgAha60Q
	y5cvh+NUerClxtxfzVApR46UYnhusbONzvnicz2gFDHSyYPptDWnQZypw3GLb0UOmcujbFs48Se
	+0ABYnLyfMdzF
X-Received: by 2002:a05:600c:231a:b0:40b:36e6:9ef8 with SMTP id 26-20020a05600c231a00b0040b36e69ef8mr830437wmo.17.1701963179764;
        Thu, 07 Dec 2023 07:32:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF73xG1rWSXPP6/USJKY6WpXHrYjibzf4wMxRh4mD+xclLWUKJS1MJJMWuoIt+KM6fE1rncgw==
X-Received: by 2002:a05:600c:231a:b0:40b:36e6:9ef8 with SMTP id 26-20020a05600c231a00b0040b36e69ef8mr830428wmo.17.1701963179400;
        Thu, 07 Dec 2023 07:32:59 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id w4-20020a5d5444000000b0033342d2bf02sm1697325wrv.25.2023.12.07.07.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 07:32:58 -0800 (PST)
Message-ID: <2cf82d25d687ce6747b729146c1a0ac194a1ab7b.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Like Xu <like.xu.linux@gmail.com>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Dec 2023 17:32:57 +0200
In-Reply-To: <20231206032054.55070-1-likexu@tencent.com>
References: <20231206032054.55070-1-likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-06 at 11:20 +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Explicitly checking the source of external interrupt is indeed NMI and not
> other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
> positive samples generated in perf/core NMI mode after vm-exit but before
> kvm_before_interrupt() from being incorrectly labelled as guest samples:
> 
> # test: perf-record + cpu-cycles:HP (which collects host-only precise samples)
> # Symbol                                   Overhead       sys       usr  guest sys  guest usr
> # .......................................  ........  ........  ........  .........  .........
> #
> # Before:
>   [g] entry_SYSCALL_64                       24.63%     0.00%     0.00%     24.63%      0.00%
>   [g] syscall_return_via_sysret              23.23%     0.00%     0.00%     23.23%      0.00%
>   [g] files_lookup_fd_raw                     6.35%     0.00%     0.00%      6.35%      0.00%
> # After:
>   [k] perf_adjust_freq_unthr_context         57.23%    57.23%     0.00%      0.00%      0.00%
>   [k] __vmx_vcpu_run                          4.09%     4.09%     0.00%      0.00%      0.00%
>   [k] vmx_update_host_rsp                     3.17%     3.17%     0.00%      0.00%      0.00%
> 
> In the above case, perf records the samples labelled '[g]', the RIPs behind
> the weird samples are actually being queried by perf_instruction_pointer()
> after determining whether it's in GUEST state or not, and here's the issue:
> 
> If vm-exit is caused by a non-NMI interrupt (such as hrtimer_interrupt) and
> at least one PMU counter is enabled on host, the kvm_arch_pmi_in_guest()
> will remain true (KVM_HANDLING_IRQ is set) until kvm_before_interrupt().
> 
> During this window, if a PMI occurs on host (since the KVM instructions on
> host are being executed), the control flow, with the help of the host NMI
> context, will be transferred to perf/core to generate performance samples,
> thus perf_instruction_pointer() and perf_guest_get_ip() is called.
> 
> Since kvm_arch_pmi_in_guest() only checks if there is an interrupt, it may
> cause perf/core to mistakenly assume that the source RIP of the host NMI
> belongs to the guest world and use perf_guest_get_ip() to get the RIP of
> a vCPU that has already exited by a non-NMI interrupt.
> 
> Error samples are recorded and presented to the end-user via perf-report.
> Such false positive samples could be eliminated by explicitly determining
> if the exit reason is KVM_HANDLING_NMI.
> 
> Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
> is cleared, it's also still possible that another PMI is generated on host.
> Also for perf/core timer mode, the false positives are still possible since
> that non-NMI sources of interrupts are not always being used by perf/core.
> In both cases above, perf/core should correctly distinguish between real
> RIP sources or even need to generate two samples, belonging to host and
> guest separately, but that's perf/core's story for interested warriors.
> 
> Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> V1 -> V2 Changelog:
> - Refine commit message to cover both perf/core timer and NMI modes;
> - Use in_nmi() to distinguish whether it's NMI mode or not; (Sean)
> V1: https://lore.kernel.org/kvm/20231204074535.9567-1-likexu@tencent.com/
>  arch/x86/include/asm/kvm_host.h | 10 +++++++++-
>  arch/x86/kvm/x86.h              |  6 ------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c8c7e2475a18..167d592e08d0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1868,8 +1868,16 @@ static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
>  }
>  #endif /* CONFIG_HYPERV */
>  
> +enum kvm_intr_type {
> +	/* Values are arbitrary, but must be non-zero. */
> +	KVM_HANDLING_IRQ = 1,
> +	KVM_HANDLING_NMI,
> +};
> +
> +/* Enable perf NMI and timer modes to work, and minimise false positives. */
>  #define kvm_arch_pmi_in_guest(vcpu) \
> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
> +	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>  
>  void __init kvm_mmu_x86_module_init(void);
>  int kvm_mmu_vendor_module_init(void);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..4dc38092d599 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>  	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
>  }
>  
> -enum kvm_intr_type {
> -	/* Values are arbitrary, but must be non-zero. */
> -	KVM_HANDLING_IRQ = 1,
> -	KVM_HANDLING_NMI,
> -};
> -
>  static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>  						 enum kvm_intr_type intr)
>  {

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> 
> base-commit: 1ab097653e4dd8d23272d028a61352c23486fd4a



