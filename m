Return-Path: <kvm+bounces-28392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E71998149
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CEC61C20E9B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76211C57A0;
	Thu, 10 Oct 2024 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BPBCV2yU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891DF1AF4E9
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550682; cv=none; b=UVhD7ZiiIJI7X9D33Ux7NmDz4kKG7TyiD3StaWryq/s9YCH6hucN/M7/BoWPmG0WK7fMsjvfZnZuhNOUZ8kMgjRry9ZDJE6HhVwCZ6VkmATTExfSQNL9+RYnliuPgwtRAFtspOq+vINAxVft+ZnPH2PzYbtDdyx6oPaadF3fWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550682; c=relaxed/simple;
	bh=uEoD+N+ErCzjUQzAybretMtYvnPznERIurac1+tT/ug=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WPQ1886ucTQTV8V6vEFMSMPxOjwRirtgp6FdGswRPBt9r7mjVQzZlO+u20LBMoFQJ1ODPQev2g+E4BSgMvZFxgOGDAYiEB0refbwTNMDTJlJfGpxakMEcElY/Xh/i9fG5KKAOqhwjXTbdQvm3YZ77k6atxoU0wQMXMjsEJn7RIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BPBCV2yU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728550679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V3mfLBxE7mgA5D2j+dKOJ0660aCNEHB3kXbTGLynC34=;
	b=BPBCV2yUr/1yFMwuHtkIMBME2oPxGZE5HOpc9Budoa4tDQbnuOHITHaoQppR4tfAg7ov76
	0w5o+DCiBT3wrVnbMU+TG7vFn0WTLNqBBmthENe6cQvq1EaDRnzQSI2Bt+Us6jFUtOmb0G
	EnRZiGq1yjWW6l5Y0GvS3pZnDvHoqAk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-OEaqkyw9OPKDevaNNrMgwg-1; Thu, 10 Oct 2024 04:57:58 -0400
X-MC-Unique: OEaqkyw9OPKDevaNNrMgwg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cdeac2da6so4089975e9.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550677; x=1729155477;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3mfLBxE7mgA5D2j+dKOJ0660aCNEHB3kXbTGLynC34=;
        b=DoGf5LZhvIPfHJ3f/gRbO1wxg/B2Kc9FQMIy9kJ7cyLyHq8MZ9uy9FQwNCGRwrHD5r
         gGAJC8hrWj2ERl3lHV98d7+b8kyKSODOqthE/fCHOn/PvQfflLkTdblKK53GVZeDcKyM
         CTGDYfSHvBR3mwYY6c0pJCjGSJx7oZxfRgRDFNRhJ5dGa4DIpTQAcPVChpljqP4A6H2F
         +6XWn7sbdO4Ch2yqs65JNMNS5wcyuCHvutGvi4UtXcAtLj0TzjvLUzr/rlBZqVP+HPBR
         L/548fDnCIuyoqUnXxfnoEVQ19r85E86SjJxZXxsuFwpESB1Ng3xE1E5HyP6dmSsqrMp
         KkJA==
X-Forwarded-Encrypted: i=1; AJvYcCXGMiZXKRvNVXtCf8c0Ny8ki2WsWxVERHn1hYtoSgkn5g/WfVGpiQ9Iwu+7jhU+wD3aKV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/hhQ38+CIwQDMUE7XzcZEDoazP1PU+nP6LGpbtqrxR27OsEey
	fPd4nPiekN3VAr2a13uUSJfDwxCDE89HlYqmKR5cWDHDVrIGLqj2xM4Xpk24QqF5enzAyAteGs2
	bySUBahFmwQRm14pF0wMjihb3KTQxZeWsM8q/vVryyhunv4GS6g==
X-Received: by 2002:a05:600c:a08:b0:42f:7ed4:4c26 with SMTP id 5b1f17b1804b1-430ccf1d794mr43479705e9.12.1728550676804;
        Thu, 10 Oct 2024 01:57:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO2YZz0KIdt9CH7YpTmaKm1V5sN7oLsDloXPoVkbSMJb4dyCl0+OpMHrvepMEuByPjcRlSzQ==
X-Received: by 2002:a05:600c:a08:b0:42f:7ed4:4c26 with SMTP id 5b1f17b1804b1-430ccf1d794mr43479505e9.12.1728550676374;
        Thu, 10 Oct 2024 01:57:56 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6a8666sm913435f8f.22.2024.10.10.01.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 01:57:56 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nikolas Wipper <nikwip@amazon.de>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.com>, Alexander Graf
 <graf@amazon.de>, James Gowans <jgowans@amazon.com>,
 nh-open-source@amazon.com, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Nikolas Wipper <nik.wipper@gmx.de>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Add API documentation for
 KVM_HYPERV_SET_TLB_FLUSH_INHIBIT
In-Reply-To: <20241004140810.34231-2-nikwip@amazon.de>
References: <20241004140810.34231-1-nikwip@amazon.de>
 <20241004140810.34231-2-nikwip@amazon.de>
Date: Thu, 10 Oct 2024 10:57:55 +0200
Message-ID: <874j5kgwrw.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Nikolas Wipper <nikwip@amazon.de> writes:

> Add API documentation for the new KVM_HYPERV_SET_TLB_FLUSH_INHIBIT ioctl.
>
> Signed-off-by: Nikolas Wipper <nikwip@amazon.de>
> ---
>  Documentation/virt/kvm/api.rst | 41 ++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4b7dc4a9dda..9c11a8af336b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6443,6 +6443,47 @@ the capability to be present.
>  `flags` must currently be zero.
>  
>  
> +4.144 KVM_HYPERV_SET_TLB_FLUSH_INHIBIT
> +--------------------------------------
> +
> +:Capability: KVM_CAP_HYPERV_TLB_FLUSH_INHIBIT
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_hyperv_tlb_flush_inhibit
> +:returnReturns: 0 on success, this ioctl can't fail
> +
> +KVM_HYPERV_SET_TLB_FLUSH_INHIBIT allows userspace to prevent Hyper-V
> hyper-calls

Very minor nitpick: I suggest standardize on "hypercall" spelling
without the dash because:

$ grep -c hypercall Documentation/virt/kvm/api.rst
56
$ grep -c hyper-call Documentation/virt/kvm/api.rst
3

(I see all three 'hypercall', 'hyper-call', 'hyper call' usages in the
wild and I honestly don't think it matters but it would be nice to
adhere to one share across the same file / KVM docs).

> +that remotely flush a vCPU's TLB, i.e. HvFlushVirtualAddressSpace(Ex)/
> +HvFlushVirtualAddressList(Ex). When the flag is set, a vCPU attempting to flush
> +an inhibited vCPU will be suspended and will only resume once the flag is
> +cleared again using this ioctl. During suspension, the vCPU will not finish the
> +hyper-call, but may enter the guest to retry it. Because it is caused by a
> +hyper-call, the suspension naturally happens on a guest instruction boundary.
> +This behaviour and the suspend state itself are specified in Microsoft's
> +"Hypervisor Top Level Functional Specification" (TLFS).
> +
> +::
> +
> +  /* for KVM_HYPERV_SET_TLB_FLUSH_INHIBIT */
> +  struct kvm_hyperv_tlb_flush_inhibit {
> +      /* in */
> +      __u16 flags;
> +  #define KVM_HYPERV_UNINHIBIT_TLB_FLUSH 0
> +  #define KVM_HYPERV_INHIBIT_TLB_FLUSH 1
> +      __u8  inhibit;
> +      __u8 padding[5];
> +  };
> +
> +No flags are specified so far, the corresponding field must be set to zero,
> +otherwise the ioctl will fail with exit code -EINVAL.
> +
> +The suspension is transparent to userspace. It won't cause KVM_RUN to return or
> +the MP state to be changed. The suspension cannot be manually induced or exited
> +apart from changing the TLB flush inhibit flag of a targeted processor.
> +
> +There is no way for userspace to query the state of the flush inhibit flag.
> +Userspace must keep track of the required state itself.
> +
>  5. The kvm_run structure
>  ========================

-- 
Vitaly


