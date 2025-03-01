Return-Path: <kvm+bounces-39786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB511A4A769
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 175477AAF2C
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3769514F117;
	Sat,  1 Mar 2025 01:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3Ec/eOB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28922318
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740792582; cv=none; b=o4lW5eEKmLkZCOCb/DQBE5qVG2S8CW/+uQ1NfBXv+W/NtQd5hsHzm3n4BnXarBIG3TW/ZVu7r2aMPBYFbhlJ5CCyCrzm7Swi7Cx+37BLCVqslcWwybQ8/eoHlNqem6DpgBEe7uUGuEsxXCzgxxbLox3qZGjH6BazsA3iUaUAb5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740792582; c=relaxed/simple;
	bh=qay1XQpJ02X81EzQxN92CpuG0KEY1sx/6YinRhzxuXU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ikZY9wXxek7H8ZmPvFnz2g4dzpSKn0EK9rmaCiqNX9H+EoSWrzqM6r62vEIUGp3DHIrJtWW58dNT97gkn91cLkSJ6jp23Jfwd24ueNZL6+g891Yn0eUcW5UXFuecgJEG4x5m4mMkv1omMcBCgBa+WeK77tQQAV0Zxt/fowHjMNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S3Ec/eOB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740792578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9mLMW84mV8CqjBT9FwroY41UDoAqgbE+idQajKsM2z8=;
	b=S3Ec/eOB6aiqKnJpQ1hiMKS0/qEtTEBcZQYaIIxwI02NHsbDWQi1GJLiBQUfCThccCh+7t
	lcMIs0egax38McJK+20t6GRvQKK1b238lMYkqlQJ3jJY+1/ZSBet77YuXvM0W/IWELTbPW
	XcMmLt8zKtH+60MRGT+tkykRRl8hDjc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-qJzSBjF5O9GP3utxPXTpyQ-1; Fri, 28 Feb 2025 20:29:36 -0500
X-MC-Unique: qJzSBjF5O9GP3utxPXTpyQ-1
X-Mimecast-MFC-AGG-ID: qJzSBjF5O9GP3utxPXTpyQ_1740792576
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e88964702cso62345956d6.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:29:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740792576; x=1741397376;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9mLMW84mV8CqjBT9FwroY41UDoAqgbE+idQajKsM2z8=;
        b=uBixcQrIldZGKS4210a2+wMYeusAX427d86RW6jmyRXDdZvKmQo64azhAZi9nuv6W8
         AkYC3SSSDT2NaEy/1+niFB/P/9YvC6kimDnlGP/f9UlxrhdjGuH736r+RRci3hD8rxTY
         5vJkyGWS4HLKG4IFSpDhRswSj6dv2oj625YqLVXy/MXvF1+CiFn14/qdqzwOfMTdtbAb
         /4+wjbs5G12v8GbscA25PzpnxFaPBWn4RrGUb97mo8yemcYg5n2mNtDTb0uPPAQ7Ztnj
         9t6D99hkoMzYCRb1ZAQQFItUBm7i165Nh+a+VxHduUXDe4UovUMSYEVotRWHxA50S1fC
         VFQw==
X-Gm-Message-State: AOJu0YyXakkyh0Zu5OM7PbgCiICeV6fPRV3xSEx1YLC/6b4hE0hsKkvQ
	zesfr90YrYX60aUuYi97A9w6OB2WOxZBwSdbLsTJT/7UlJ7ZcJKTUn2hzaeokIvWf0qqjUSmmuJ
	uN970tK66NV49es8xFfyU/H95MmffB0WWTm5TLEkMo63qoi7vmw==
X-Gm-Gg: ASbGncsCzvL9xmU/8hddCAbuxsuupmBmwKzl0evSZt2UorSvyRjJadPlbuikp8+/7/D
	USWxcS7hQ1Xudesc0LS4qt7pHTrLmlzDfmRtTazpRK4us+MTWZrjRyxc8Cm6+Y2fOdonrbyfcLA
	yNA3yS6yKXDjB4YCDc3FtIJ+z4rZOv7cZlNEd3mUUO5AdS2MpSI/GkCWRobgNg4DokqMHVfPoCG
	3p1AMVFobrkrryGwKwRrWKTOwIB18a3vkJOfJ/5MidOZ36CKhSlMRudJGjWWaMhz4GUZcO7YGcc
	Kz2liSyu4zwjvnA=
X-Received: by 2002:a05:6214:21e7:b0:6e2:383f:4acd with SMTP id 6a1803df08f44-6e8a0ce0f95mr81017016d6.7.1740792576205;
        Fri, 28 Feb 2025 17:29:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3wC3zFb8P3zHquADvRKZ43FHIiwHHLk0ySJj7QI+8j+3vYjQkzHZ2ev0DCr/P5m1Mp1KcKA==
X-Received: by 2002:a05:6214:21e7:b0:6e2:383f:4acd with SMTP id 6a1803df08f44-6e8a0ce0f95mr81016826d6.7.1740792575883;
        Fri, 28 Feb 2025 17:29:35 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976608f2sm28282256d6.53.2025.02.28.17.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:29:35 -0800 (PST)
Message-ID: <2bb5b47e1b6c1251ae7fffe6d4d9836a401a1be0.camel@redhat.com>
Subject: Re: [RFC PATCH 02/13] KVM: nSVM: Rework svm_flush_tlb_asid() to
 operate on a given VMCB
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:29:34 -0500
In-Reply-To: <20250205182402.2147495-3-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-3-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> svm_flush_tlb_asid() currently operates on the current VMCB. In
> preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
> refactor it to work on a given VMCB. All existing callers pass the
> current VMCB.
> 
> Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
> callback.
> 
> kvm_hv_vcpu_purge_flush_tlb() is only called when the current VMCB is
> passed to maintain current behavior.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 08340ae57777b..2108b48ba4959 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3954,7 +3954,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3963,7 +3963,8 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
>  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
>  	 */
> -	kvm_hv_vcpu_purge_flush_tlb(vcpu);
> +	if (vmcb == svm->current_vmcb)
> +		kvm_hv_vcpu_purge_flush_tlb(vcpu);

This is hyperv PV feature that should be looked upon very carefully.

To recap, 
each vCPU has 2 queues of pending TLB flush requests that target only small range of
memory pages. 

One is for L1 and one for L2, because now KVM supports a mode where L2
can ask L0 to do a tlb flush on its behalf, and KVM will figure out to which L1 vCPUs
to send this flush request.

Requests arrive from other vCPUs.

Here we purge the TLB request queue because we flushed a super-set of the requests,
which used to contain both L1 and L2 TLB, but soon that won't be true.

So I think it might make sense to also add vmcb to kvm_hv_vcpu_purge_flush_tlb, and then
depending if it is vmcb01 or vmcb02, purge the correct queue.
I don't know if this is theoretical or actual bug but it is better to be safe IMHO.


>  
>  	/*
>  	 * Flush only the current ASID even if the TLB flush was invoked via
> @@ -3973,14 +3974,15 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  	 * VM-Exit (via kvm_mmu_reset_context()).
>  	 */
>  	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
> -		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +		vmcb->ptr->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>  	else
> -		svm->current_vmcb->asid_generation--;
> +		vmcb->asid_generation--;
>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  {
>  	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	/*
>  	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
> @@ -3991,11 +3993,13 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
>  		hyperv_flush_guest_mapping(root_tdp);
>  
> -	svm_flush_tlb_asid(vcpu);
> +	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
>  }
>  
>  static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
>  	/*
>  	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
>  	 * flushes should be routed to hv_flush_remote_tlbs() without requesting
> @@ -4006,7 +4010,7 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
>  		hv_flush_remote_tlbs(vcpu->kvm);
>  
> -	svm_flush_tlb_asid(vcpu);
> +	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
>  }
>  
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
> @@ -4016,6 +4020,13 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  	invlpga(gva, svm->vmcb->control.asid);
>  }
>  
> +static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
> +}
> +

Small nitpick: I think that this change is still unrelated and thus
probably should go to a separate patch.


Best regards,
	Maxim Levitsky

>  static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -5055,7 +5066,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.flush_tlb_all = svm_flush_tlb_all,
>  	.flush_tlb_current = svm_flush_tlb_current,
>  	.flush_tlb_gva = svm_flush_tlb_gva,
> -	.flush_tlb_guest = svm_flush_tlb_asid,
> +	.flush_tlb_guest = svm_flush_tlb_guest,
>  
>  	.vcpu_pre_run = svm_vcpu_pre_run,
>  	.vcpu_run = svm_vcpu_run,



