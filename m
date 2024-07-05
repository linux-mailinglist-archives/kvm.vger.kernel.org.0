Return-Path: <kvm+bounces-20967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F72D927F71
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC28E28332D
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 00:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB406125;
	Fri,  5 Jul 2024 00:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BNLusUNL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8436610B
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720140496; cv=none; b=L0CBBffmucwKZj3KMwgKIHI6hPTIbjP/TujKRJv/LDXDIxhf7qglFoh2Zcrtgcko0NRBN0UAR+S9bRsmu4P1rCkpSkPmKyLKfuy2zHpBYHJJQN1AXvnMg4mcDLmdiGesYt8DZDSvhLgCJmvEYA6n9dqAOihw7WXZENNuvoz3UeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720140496; c=relaxed/simple;
	bh=UCYavsOYlDJtoPoG3lzm2cK4S3yoWAf+mGlSkpNPZC8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uuZFDESNvlTn35EGmj1yov2cELZsD/G6YU+wVqnykV5iEPRzeDhhaOMPGnpThtuyzdwkKbT8dDaLpetoh8ZalwTX9U6wrRKH5F02bH+2y4CVDyJnlZjsL4uIoQP41l95SBV3BQ2kh8ba8Zckq5qR/wyG4j3vEwpIucq3b0bwmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BNLusUNL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720140493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1taNz8T2VLQRBGglDYc9q5xdZlahhRSOV1YwKJ4I0vQ=;
	b=BNLusUNLuAzV7fC0WM6dQSn5bmZUr00MgCHObiFGPsh9M8QL70zbegiEpvjXhkdrncIFAF
	BdiKZXfEnIBPRr4ltouIS8lIToWlGBIdbsZds1xo6lY9IueDDVRtt6dR701NvMffonNYhM
	1lQsopV2AAW1lqz/WlxbIc3ifbjfe0U=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-HVhXsNTFPQKXNDQ3fuhPlg-1; Thu, 04 Jul 2024 20:48:12 -0400
X-MC-Unique: HVhXsNTFPQKXNDQ3fuhPlg-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e03a434e33cso1944523276.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 17:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720140491; x=1720745291;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1taNz8T2VLQRBGglDYc9q5xdZlahhRSOV1YwKJ4I0vQ=;
        b=VVGhhGLGrnOm01uOpZQkOWCgsykHL0Kj1hegYKH2Q6VQkcX3CS77w61i5CnTZrm1+L
         ry+FX386konyyY/uhxSPIqmm3x9FTTuAzq4SkGgvBd9m2Sa/5Jy4PYQCNlWK4GS63HLA
         rVHA8FsgdjVWObbBGKw+rVVvZP6lS0cNE/vQcivImrtVkLMt+8MPWF8JVdyswfRCBRL/
         4EtDmbjxLwQqIVYIEh1pyVRU099Y06ogb5FiKqVs+16LdRJj65CAr2O6zBasZonnq19C
         7LHEqybsOZP2n0iUQDzTjQ/EzXS1P41E4zcTLgLpDpv07FWDdIFKw0ffz/cC3A6rAb+U
         dlBw==
X-Gm-Message-State: AOJu0Yx4Zu5fz5rFN8agNMhygJEOFHV20KYovJgbhzpqy5x172KbPTwc
	U2FuHKugMXJ8ua4BHR2aHcRCgCobAcWN7Ci+5A6VZfcefb0NAIPY5zEBFzCrvdaR3/4xaBK7BTN
	irxMWasiKk+6DBBGPJ07lidvlh2fmKqMKT7OechO94uPS7QZNSKBWdh+vMw==
X-Received: by 2002:a25:ade8:0:b0:e03:a248:7dd3 with SMTP id 3f1490d57ef6-e03c196966fmr3345507276.23.1720140491692;
        Thu, 04 Jul 2024 17:48:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLtTb8qCSDdsaN2DhQVTPgfPMllt0+iLg2fNvdycLvwNeGaSGnRSg7IVAaPsOWTpmD0ep1qg==
X-Received: by 2002:a25:ade8:0:b0:e03:a248:7dd3 with SMTP id 3f1490d57ef6-e03c196966fmr3345486276.23.1720140491395;
        Thu, 04 Jul 2024 17:48:11 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5f7e1esm68415876d6.98.2024.07.04.17.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 17:48:11 -0700 (PDT)
Message-ID: <62cbd606f6d636445fd1352ae196a0973c362170.camel@redhat.com>
Subject: Re: [PATCH v2 01/49] KVM: x86: Do all post-set CPUID processing
 during vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 20:48:10 -0400
In-Reply-To: <20240517173926.965351-2-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> During vCPU creation, process KVM's default, empty CPUID as if userspace
> set an empty CPUID to ensure consistent and correct behavior with respect
> to guest CPUID.  E.g. if userspace never sets guest CPUID, KVM will never
> configure cr4_guest_rsvd_bits, and thus create divergent, incorrect, guest-
> visible behavior due to letting the guest set any KVM-supported CR4 bits
> despite the features not being allowed per guest CPUID.
> 
> Note!  This changes KVM's ABI, as lack of full CPUID processing allowed
> userspace to stuff garbage vCPU state, e.g. userspace could set CR4 to a
> guest-unsupported value via KVM_SET_SREGS.  But it's extremely unlikely
> that this is a breaking change, as KVM already has many flows that require
> userspace to set guest CPUID before loading vCPU state.  E.g. multiple MSR
> flows consult guest CPUID on host writes, and KVM_SET_SREGS itself already
> relies on guest CPUID being up-to-date, as KVM's validity check on CR3
> consumes CPUID.0x7.1 (for LAM) and CPUID.0x80000008 (for MAXPHYADDR).
> 
> Furthermore, the plan is to commit to enforcing guest CPUID for userspace
> writes to MSRs, at which point bypassing sregs CPUID checks is even more
> nonsensical.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  arch/x86/kvm/cpuid.h | 1 +
>  arch/x86/kvm/x86.c   | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f2f2be5d1141..2b19ff991ceb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -335,7 +335,7 @@ static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>  #endif
>  }
>  
> -static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 23dbb9eb277c..0a8b561b5434 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -11,6 +11,7 @@
>  extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
>  void kvm_set_cpu_caps(void);
>  
> +void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d750546ec934..7adcf56bd45d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12234,6 +12234,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kvm_xen_init_vcpu(vcpu);
>  	kvm_vcpu_mtrr_init(vcpu);
>  	vcpu_load(vcpu);
> +	kvm_vcpu_after_set_cpuid(vcpu);

This makes me a bit nervous. At this point the vcpu->arch.cpuid_entries is NULL,
but so is vcpu->arch.cpuid_nent so it sort of works but is one mistake away from crash.

Maybe we should add some protection to this, e.g empty zero cpuid or something like that.

Best regards,
	Maxim Levitsky


>  	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
>  	kvm_vcpu_reset(vcpu, false);
>  	kvm_init_mmu(vcpu);





