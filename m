Return-Path: <kvm+bounces-41229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7653A65165
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480211886C68
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3FD23ED68;
	Mon, 17 Mar 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B7TDVKou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82B4EBE
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742218729; cv=none; b=fRfKD8ocALYlBMSFPrCHdCNrCFZ5bUHuwKv2tqQIFkrb8SpbUuykciNpkiDmmCTJRZpRTfOIxv2NJATeKw0pg59uQSzwZXxIG1xVXlq5LUYrDOTOmvE0wIYuonQLHQIilXTPO4p72ksgpvBE5R4CEhrPCyga2jBCJbLN0wEct0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742218729; c=relaxed/simple;
	bh=O5LLRL0Ix46XKZVpQxNBMRaa1XxUVDJZAOZfV7jkOMc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oGA1uwAiIUIk1v0uiYB8UpBCJbPvFkvRrQLbdZoxAo67fOxPur2FsuZWL0/Fq/QPw4GUVLLRucwSAKDpbAWIvPRuXdhEai316a5ByzdBcxUbPyNUIrLyg+TvcP6aq9H64MlPnj/wgpVvFDVMzrop4owCE4g/tNU7ZPF7+wGuybY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B7TDVKou; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7f9a0b9bso2964696a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 06:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742218727; x=1742823527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=excEqqlL1qVse1/2isbt5XTtkZviRpOUJTRb6pKmchA=;
        b=B7TDVKouoIknXeV8V7oHI3rtVnMI+GOLDyy2LPW/GpI7yH64KAPWHdjQnrDryU9ff7
         u6TKKxNlGFi2VCLDsec/F67in1B6zwDP1+/7P69cWIT70tR7zMNtRdd0Inc+508P0G5W
         Lms4m/UPI2ggxNk3MQW3W+XSyGbthuR3Awu7k9AVJ5+LAJNBMN2IFCrBX+b2wj9xnfjb
         3vW3d6R8LN3eVvsVIqlkyGFdn678xcRhlE1OoLchpeOyr0tIdhEfkmq0zDbNEar+FcMk
         cZ4IYaQIpVhMz/QiN+a94sSyQHYOxkYea++3lYO0p3WKBr3C1cNV25w4LsTq75MR4KcZ
         dL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742218727; x=1742823527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=excEqqlL1qVse1/2isbt5XTtkZviRpOUJTRb6pKmchA=;
        b=S4kcDaQ8DIuJRTvQ8/sTvP9/zGs3AlF2ydBp20p+N7Mb0F3MXNm8BmYv7+mw0lskHp
         +svzIFNiFl19K5+hT66mU0OUqZ5dt2afiJL9wxjmP6R6JLowtvvC9BQUXSKfBa3YaQ2t
         dOF1iofy18hXuy3Mww8tmbDjFujWmMdgH6/QM7UIfB9tiNXqC41GtupGOk+BZpNeVt9b
         k72sbN8uG1khQxLLprFeMUkH/xr8RWKRMUSvTQraFfZYdTnb8kucsIf7/DvjYCCT3OzI
         fR7obQqE3PfuF2CebST20f9Ud1uzOr2rtTQMKyzNak3FT/ro2dhzhz1JytSkiLz1y9Tg
         BIlQ==
X-Gm-Message-State: AOJu0YwR73GCtLLD6D8/bhottSqIirrWiX6Af1hbxmXmvzgMbvMpdeMJ
	BSZL7gdK/LfUokixvsV4ppaKQVUilvVAUjkuPD4zTuBH+Pg1oyJ5vNff3nmjxNIvipWP5tp5itb
	vFw==
X-Google-Smtp-Source: AGHT+IHm1GdirBM0gHNKnUjvp9IiSMJcCOdqjVN7aHrhPCsdY64Jeho8SGXW+VrGvRIvp3h8uBNvfPLiygs=
X-Received: from pjwx4.prod.google.com ([2002:a17:90a:c2c4:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3804:b0:2ee:6d08:7936
 with SMTP id 98e67ed59e1d1-30151cfee83mr15293579a91.20.1742218727181; Mon, 17
 Mar 2025 06:38:47 -0700 (PDT)
Date: Mon, 17 Mar 2025 06:38:45 -0700
In-Reply-To: <20250317091917.72477-1-liamni-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250317091917.72477-1-liamni-oc@zhaoxin.com>
Message-ID: <Z9gl5dbTfZsUCJy-@google.com>
Subject: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
From: Sean Christopherson <seanjc@google.com>
To: Liam Ni <liamni-oc@zhaoxin.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, LiamNi@zhaoxin.com, 
	CobeChen@zhaoxin.com, LouisQi@zhaoxin.com, EwanHai@zhaoxin.com, 
	FrankZhu@zhaoxin.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 17, 2025, Liam Ni wrote:
> When using the dump-guest-memory command in QEMU to dump
> the virtual machine's memory,the virtual machine will be
> paused for a period of time.If the guest (i.e., UEFI) uses
> the PIT as the system clock,it will be observed that the
> HRTIMER used by the PIT continues to run during the guest
> stop process, imposing an additional burden on the system.
> Moreover, during the guest restart process,the previously
> established HRTIMER will be canceled,and the accumulated
> timer events will be flushed.However, before the old
> HRTIMER is canceled,the accumulated timer events
> will "surreptitiously" inject interrupts into the guest.
> 
> SO during the process of saving the KVM PIT state,
> the HRTIMER need to be canceled to reduce the performance overhead
> caused by HRTIMER during the guest stop process.
> 
> i.e. if guest
> 
> Signed-off-by: Liam Ni <liamni-oc@zhaoxin.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 045c61cc7e54..75355b315aca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6405,6 +6405,8 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
>  
>  	mutex_lock(&kps->lock);
>  	memcpy(ps, &kps->channels, sizeof(*ps));
> +	hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
> +	kthread_flush_work(&kvm->arch.vpit->expired);

KVM cannot assume userspace wants to stop the PIT when grabbing a snapshot.  It's
a significant ABI change, and not desirable in all cases.

>  	mutex_unlock(&kps->lock);
>  	return 0;
>  }
> @@ -6428,6 +6430,8 @@ static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
>  	memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
>  		sizeof(ps->channels));
>  	ps->flags = kvm->arch.vpit->pit_state.flags;
> +	hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
> +	kthread_flush_work(&kvm->arch.vpit->expired);
>  	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
>  	memset(&ps->reserved, 0, sizeof(ps->reserved));
>  	return 0;
> -- 
> 2.25.1
> 

