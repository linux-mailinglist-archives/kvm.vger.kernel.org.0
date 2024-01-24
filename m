Return-Path: <kvm+bounces-6844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 554B983AE7A
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43B5CB2B17B
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF74A77620;
	Wed, 24 Jan 2024 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TN1vD+8M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C8BC2D5
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706113941; cv=none; b=Jtgnfb5SnaeaCNgOczCOcbgMROBh8a3k1mQ4cAe3b3KTQyUQfJXQU6iEPU29YumNDtY3d1NHd9rdm2nGhLas2DlsNxwej60Yhx9+JFfv2jQi/bfoWvDlPVBKY61J9h/7lSe6zigTrpMA670MSk9tQ+gARxAjC7xESjOC7XrcQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706113941; c=relaxed/simple;
	bh=+zqCmFWMLWHr8Gkc0x56tIkqc6LdU6Qb3vc+IyEL5iA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nZ+TgbpeGjaMd/4DcDRBYKT/v3iOQz30O2JrMxzrk9AcBiEI3VBJ84puLt9eGmlC7pxYozR+KpA5CQ3oasioj9VUOzIUIIppcjfRj+pDt3qJ/EGeWSwK61+MNdFNDU32xeSzPAOvbzJ/+/d9taKfTi5oIocTXlwTD1k7Q61aCXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TN1vD+8M; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a541b720aso8383646276.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 08:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706113938; x=1706718738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g82foanF1CJTmaDLSQP4Ghn9FVcWHiz28lTGASp7l48=;
        b=TN1vD+8MPZC6fnYjgQZlBEbZ3eBtbBn096XKshKSkcci03jMpdy4KMMGHZ+mOQy7BL
         29RXIlgX0bA03ia5Hm6chxI2PrQ7NqtXKfO8k0a3zXn10ZKmsEmqmpuq/dxTj6nTnP4Y
         RePx1/3ZJEaAQNlbLh/lv5FgDi/VdCEYhk8r9pHM4zmZ+CytG6DTc1b51n9jZlIjrb6L
         96RokG7ut7qBNGHmyLD6m2GDLILecD41NWgASmVeuhmlOvxWUisXhq+4DjZ89sB+6RqW
         Ur6AbzijwYqNzzgGD2vG+jBfMewBXy1L5A6EKtQBBjtHaMusxWsSf0cXxGu0icuR/fty
         UbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706113938; x=1706718738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g82foanF1CJTmaDLSQP4Ghn9FVcWHiz28lTGASp7l48=;
        b=Mpcn2S2oZ6qvfERUB6LBGQ/wWLI82AfOaBPhp2skYdzYfwYVJv7P80mJnLyhkb4XS4
         VkYRcKWP0NKc8pqbQJRfuUGvLcecHF+OFUjKuYAhbDfwq33UO0YiUp2JnjMRTheBp+XF
         W98EigDD0L9yPKusa448IY1gqJxAPP872pepu2futWX/Twvqc76zd9DLMK0CFdgIUag9
         I0UdgMzSDM6SEAg6Yl1Osd2GOTYqGVtSXsYZlLSRx9e/au+1JR3ASSQufZiJFj6Pwju3
         aOZEP3zxb+rHBKMvYgUrwXq5y7NjVueN73D9UHWEFTnOyTwZgvfmokc+8pzcdQkV65uz
         8qiA==
X-Gm-Message-State: AOJu0YxOcrGjM+S6lZ+Y+RzOilCxlXWj+PFz9otNw0jjlUnoWdUWhg6u
	f7f7sfjUFffE2fjegW+0LydNruxCLi+kWlwivhdGt/rlSob1aVf94jXV1gH990I+4SCrBW7AsAI
	X6w==
X-Google-Smtp-Source: AGHT+IGm+X2BYZPWf+ByTxMEw+p1Jyx19F3jDSILRZ/fuxnNRR0npnBrb0S8PZ9zL6t3gEdep8RITYwr6nI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:989:b0:dc2:2f33:bc28 with SMTP id
 bv9-20020a056902098900b00dc22f33bc28mr453003ybb.6.1706113938754; Wed, 24 Jan
 2024 08:32:18 -0800 (PST)
Date: Wed, 24 Jan 2024 08:32:17 -0800
In-Reply-To: <20240124160248.3077-1-moehanabichan@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124160248.3077-1-moehanabichan@gmail.com>
Message-ID: <ZbE7kd9W8csPRjvU@google.com>
Subject: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
From: Sean Christopherson <seanjc@google.com>
To: Brilliant Hanabi <moehanabichan@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> support via KVM_CREATE_IRQCHIP.
> 
> Without this check, I can create PIT first and enable irqchip-split
> then, which may cause the PIT invalid because of lacking of in-kernel
> PIC to inject the interrupt.

Does this cause actual problems beyond the PIT not working for the guest?  E.g.
does it put the host kernel at risk?  If the only problem is that the PIT doesn't
work as expected, I'm tempted to tweak the docs to say that KVM's PIT emulation
won't work without an in-kernel I/O APIC.  Rejecting the ioctl could theoertically
break misconfigured setups that happen to work, e.g. because the guest never uses
the PIT.

> Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e23714e960..3edc8478310f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		r = -EEXIST;
>  		if (kvm->arch.vpit)
>  			goto create_pit_unlock;
> +		if (!pic_in_kernel(kvm))
> +			goto create_pit_unlock;

-EEXIST is not an appropriate errno.

>  		r = -ENOMEM;
>  		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
>  		if (kvm->arch.vpit)
> -- 
> 2.39.3
> 

