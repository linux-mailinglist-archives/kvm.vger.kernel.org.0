Return-Path: <kvm+bounces-30609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F0E9BC42D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC10E1F23A0C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D113819047D;
	Tue,  5 Nov 2024 04:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLISp5xV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E118EAD
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730779345; cv=none; b=r5wpcw6gE/b5XEy0/VDV7wB84uECe/Sp3i3dXpV6kKPM9vnHBaP8g9h9K4+qA+ZEEp+iJj+Ho3435W1mFgUioI66tDI9smCIPeKymljlOOp+xd1JHHLvcJyJzVjI1Sy3ROgiJ2qRelmJVgNE8zPhf89ONw6ro8LMv4ySJ5isVps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730779345; c=relaxed/simple;
	bh=Q2ss3K0zUMNodh6re2TKxKMMxEsGdxBpibUn+uIdaRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=mJJEgIV+SCM7EisfN/nYsLuphH+86BzKEwKe8D9KVcjEt/JW+iIg3PZNWAgZKnsmAWZmDC865parlDYJdDLC4cKKHxoCXPWQun2SgY6dBRusJGozjG7YaaLkZi7Wh7h++udrzjVErtGW9xM6cFAbZuR47FO5CzU1kk4LVSLdhCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yLISp5xV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e290947f6f8so8928939276.2
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 20:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730779342; x=1731384142; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sgrjmNrE+sRa4HOuh2Xl136a90BP2rGwHQTnSwPDwGg=;
        b=yLISp5xVh10DgW/Um3mq1wUA9ZR0ImO0vuSiEuo32FpZ4xj3evejokqna/B57uFczp
         oEy+N4BKUjjemo+gtk1IQ1ZiWIWMj6vT4CjIIUJTJFSDJh2jRDa6mrQ0tceZmejf2LE/
         61L+80Mv5mZzXEfj6vXYeq+5QHk43roXcw4avuFqgUMQGqPWgFLgLQyeCiXyBveXzTM1
         SBoNhbuaNlf4cHJXhIO9l1MdQuYjCae679NLKqD44HGJaXe9WP9yhS7N32b+wdNSdfyu
         Zpn6oDa1S49Oap1JbJI2D06adnzkvCZWeKjWxs1afGwSkDE8RjfZubThrFvIYp9Fq5N3
         /dsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730779342; x=1731384142;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sgrjmNrE+sRa4HOuh2Xl136a90BP2rGwHQTnSwPDwGg=;
        b=LH49PadjPP56xnE9SptrGX1ZC30dfm3P9bHSgkagyofGriUfJ9yF6RwY/wm4cVY8xw
         Qq8VFmFxnVnHQYZtXc4h3X3WMY82LwG8fkuWcG29/UKRtwHdQnNuOkkg1Mhy+YNAPoWM
         oMqB9VpiibKUVsztS3RhEdjIlkBsc0/k6Smv6PrIdgFz2j1le9EqIMYHG4aFNaviTvWZ
         XQ8pW1A/lK6uO1+KXWke184yLxTgGKjvVAV6hmI2cRGgnETIDq2s65smZednP9OoZHO1
         X1sHjlJshgxlby8RZPzM8GvkYdYQSM/P8cBfcjXkTWDW6p0oZPgxVTxUiwgiNpPgIXms
         YEQA==
X-Forwarded-Encrypted: i=1; AJvYcCVxyCdQyt1U/i1t3g4BeRdnqjz/rKNrg/c6W95IMPyqXWI7OxdTOTQ2yo5Xz87lPlXoqfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTebmNb+D9aj9W9dI0Y5sFabQqy2DDT6NpXEbcL90Feg7+L7CT
	B9TRVGHwVdVhwzXOqeUgdFpdieBjRNhMCll4zFSdiWwvcozbvTVZnrTf0ccp7ujxC3+zptVtc6Z
	VyA==
X-Google-Smtp-Source: AGHT+IHspGosbXbU/DsEEGHwYchnFt8SVWi/UJ4FV3mIGekpd4lux+5J+U19BVyi5SEyfjeTUHJXXPx5ZQ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:a291:0:b0:e28:e510:6ab1 with SMTP id
 3f1490d57ef6-e33026b3c56mr9958276.8.1730779342553; Mon, 04 Nov 2024 20:02:22
 -0800 (PST)
Date: Mon, 4 Nov 2024 20:02:21 -0800
In-Reply-To: <20241101192114.1810198-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101192114.1810198-1-seanjc@google.com> <20241101192114.1810198-2-seanjc@google.com>
Message-ID: <ZymYzawDv2wGA2c_@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Sean Christopherson wrote:
> Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
> can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
> occurs while L2 is active.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/lapic.c            | 11 +++++------
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/vmx/x86_ops.h      |  2 +-
>  4 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 70c7ed0ef184..3f3de047cbfd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1734,7 +1734,7 @@ struct kvm_x86_ops {
>  	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
> -	void (*hwapic_isr_update)(int isr);
> +	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);

Oh, the hilarity.  Got that one wrong.
 
  d39850f57d21 ("KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()")

Not entirely sure what cleanups were made possible by dropping @vcpu at the time.
I assume the end goal was ce0a58f4756c ("KVM: x86: Move "apicv_active" into "struct
kvm_lapic""), but that should have been possible, if slightly more annoying, without
modifying hwapic_isr_update().  *sigh*

