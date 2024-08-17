Return-Path: <kvm+bounces-24464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C20955432
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E461C21F29
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3201FBA;
	Sat, 17 Aug 2024 00:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YzgK5Lj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB01C32
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723854760; cv=none; b=guQoyqUkQTOVo/pMPWzQNXnJ1erm7/RxQqUMr8dU0exQazsj0V0ShiYiyY0+OKxELBTWldJjNt9JFbyATqjgZUO9gex6kKotsWaJjqMUq3vzHXiNxFTOgsXl9W+CyJHq8HLEs4OYcEKH4L0UwuRDDrM3oZFtzEyKRCRaM7pgO0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723854760; c=relaxed/simple;
	bh=qvnyY0A85VDtqWxqSsWJnJnceTfmZS4IyLgE9yBOTBo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Eez74n0VCiuJPpyfem7FPPIrZBS72nV31sIP5AhDFMJEKt2M7V8F7Rb3cMZBZS6Bfi53ASwcSTlVl7t3nAz618lxzucWyVJJJiiBLnPKMXuaHNOTHl49ua5K5B6ETyqRzlR/sGN0vUu2kNe9/EC9lOpHrbtTiQk/pO0ou+SPX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YzgK5Lj3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1995368a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723854757; x=1724459557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRMAqDHIaXd/9Vu41g3g8ugdHm3NdNHSXvqjD6sYwTs=;
        b=YzgK5Lj3n4Qo5wueRyqFl24cT8zBvP6zMinbfpL1pkAudT1RLnwxC43PX4m5tZRH8H
         EManmqNTki40C/Ifgnfk3xEr2pxK7yS6lREbaC73uADhbaUg57HkOhfXnREEPx6COUyw
         B6bZeVwnMARmQ9SEeSW0OIfhCTo6fTON8K9aV3ZtDJwiGCPeKKI0I8ogSNc1GuhBGvqf
         Jda3JhI0cgWRoEXSpyZmYYA0x1vv2iZpkqVP3D/ygQTAWweIGvLFUyJDASBEAd3eUESq
         OBAS7xIE4s43imiV4KCYMlD8vLiusBFwzFz8ZF/4abR+bEup+soMug7yk8tLerWGgPJt
         mwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723854757; x=1724459557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRMAqDHIaXd/9Vu41g3g8ugdHm3NdNHSXvqjD6sYwTs=;
        b=XAVP02F2IJTnQQVDEWDIvPVnnZf+ddTMMqY6lxgAadC1e3cxbbOqIvype0cQwVpoc0
         G5eVklRF/eH19CB1weLba9PjDBDikO4vYJvPlkP7MGkhNjd04MX3bKzg/dbAAb4xnyxq
         u/Z+srrl/q7uzkgDfLoTb5AbfmGZIt7M25qN62CjDOAhRQEnhqcLhQwiA9enLTLf6P2L
         7fYisvKxUl6JUakpugQCLyHO93nb8CUiWD/22NY3XPMlI8li8S15ABvypZGPoZ0I3ONx
         oTkhfT9PdmxgtczfJ0eEEY/2hH9oF1nRCNLhLO1enF1wN+14kXE8j1BTBCPH9Qgun2FE
         ut5w==
X-Gm-Message-State: AOJu0Yy7F9c3GWFpGIxGDxsKESbOlDpfVlyih82yQet+X8QomZZeIASw
	UEVSXpvyf/dvhcw43fqdGg+Yakqi4JomaV3GtZnCnPW3zJTANYfd4f6Yt1YMEQ4RWmEVVF+0DEX
	KEg==
X-Google-Smtp-Source: AGHT+IEAl6su0XNJBkrmjngptpk1ledQh6hcsaLtOcC/+cBaPEkAwh8LlQVSAwROz41684Cp0mMJPQorlF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:595:b0:7b6:c922:4827 with SMTP id
 41be03b00d2f7-7c6b2d40ce3mr64866a12.1.1723854757042; Fri, 16 Aug 2024
 17:32:37 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:32:35 -0700
In-Reply-To: <20240718193543.624039-3-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240718193543.624039-1-ilstam@amazon.com> <20240718193543.624039-3-ilstam@amazon.com>
Message-ID: <Zr_voxMsDyHdZmxx@google.com>
Subject: Re: [PATCH v2 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 18, 2024, Ilias Stamatis wrote:
> @@ -40,17 +42,14 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
>  	return 1;
>  }
>  
> -static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
> +static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_ring *ring, u32 last)
>  {
> -	struct kvm_coalesced_mmio_ring *ring;
> -
>  	/* Are we able to batch it ? */
>  
>  	/* last is the first free entry
>  	 * check if we don't meet the first used entry
>  	 * there is always one unused entry in the buffer
>  	 */
> -	ring = dev->kvm->coalesced_mmio_ring;
>  	if ((last + 1) % KVM_COALESCED_MMIO_MAX == READ_ONCE(ring->first)) {
>  		/* full */
>  		return 0;
> @@ -65,17 +64,28 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
>  {
>  	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
>  	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
> +	spinlock_t *lock = dev->buffer_dev ?
> +			   &dev->buffer_dev->ring_lock :
> +			   &dev->kvm->ring_lock;

I'd prefer

	spinlock_t *lock = dev->buffer_dev ? &dev->buffer_dev->ring_lock :
					     &dev->kvm->ring_lock;

to make it more obvious which parts the "guts" of the effective if-statement.


> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..9eb22287384f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5246,6 +5246,10 @@ static long kvm_vm_ioctl(struct file *filp,
>  		r = kvm_vm_ioctl_unregister_coalesced_mmio(kvm, &zone);
>  		break;
>  	}
> +	case KVM_CREATE_COALESCED_MMIO_BUFFER: {

Curly braces aren't needed, the above case has 'em because it declares local
variables.

> +		r = kvm_vm_ioctl_create_coalesced_mmio_buffer(kvm);
> +		break;
> +	}
>  #endif
>  	case KVM_IRQFD: {
>  		struct kvm_irqfd data;
> -- 
> 2.34.1
> 

