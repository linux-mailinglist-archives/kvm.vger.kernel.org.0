Return-Path: <kvm+bounces-15022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D953F8A8EE7
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DEEE283B6F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCA983CBA;
	Wed, 17 Apr 2024 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s2g7Mzbv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B6F7BB0A
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 22:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713393443; cv=none; b=f/Kqf37Iy65l7Vk/NEs9/4+Gly2xQC5wbc5ed1/CRzSeqXJ1/vkUNzkgYGDHMEfCNHYNGgHe8UQHPcbQBH7k/7wlg4YterGBt9+E16Bn7nhPzRJqSoLYO7ruOznxNxXpb46a4EHM0BkK7gnCOICLWOwnhyOEQVyYUB0q/ZR8LOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713393443; c=relaxed/simple;
	bh=9Diuar4zSEBe6PV6jqdWT8jOdW7PHA+9wjn/yHJKVn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wv1mHbV/K7sl5nxtYEfoXPLavdf53VTZ+pXb4LiDMF4gx0c6i01iI8jr7+qqyRRtN/OVhCaaknqoIEuvOG5CDWFh678uUYEPXiRNRdJfCs8uzxBFsALJ7twgv1oKAhNKDow1CXI7wds8vr1gsGPV/7Gwzg1ECOb8+f2O2C8kC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s2g7Mzbv; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc4563611cso479330276.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713393439; x=1713998239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLOqVnpH5dycTSpt7sJQ0gumy6eJRRhFek46wdDt8Nc=;
        b=s2g7Mzbv5FuAUrI/cD7e26NBv1YyWe5RsppfBbxAGZvKZtuYJkdh5/4eFeB7kR20U+
         4Eh7FjsP+O75woIk+BJy/RpgE2/MnTe8D9jP9mDRPWZ4hwFAefFFpwdBiaP4QKfZpSIY
         dAFnx7aqfRaC6vvwkuI12p3bTPBlFZed58Zqywv2Zupnmi2AHhG2zsaH7KyvePYdW9jK
         tkbbJgc+B6Bu5Elg/ELhWc9UgiUwtwKef/I1+wq/+ux7g29nFhtFV0qOgREmuTuYqECE
         zNkNRF2zqEoNT40/cd0bHtyX5KkIQolbaraT4AhWSURv065jI7ZCWS9F7NuI8YXv+O1a
         MCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713393439; x=1713998239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLOqVnpH5dycTSpt7sJQ0gumy6eJRRhFek46wdDt8Nc=;
        b=H+5/YIidk1u3NpfZ0Sg0s+pM17mmkByy7WY5XqYczPI/HHim1eOTaqncOc7kpyRPF5
         770QeSQajlKZwB2sDRewu/YwlIKDNiO+w5cOKV+8irLKnCskSUpIetITgAQips4GehsB
         LJDAcSaVEmimNxXTx/j9y1CSETfS7T8LzvxkBz+fan5tUVL1FccBttWQXbJgK66bsXf2
         NUAF9CLT3wsIzRAXyBCkkKdd82BZ2mcmiBABElEdKmPLlYfsvDak16axm2irtj/rre6j
         2D+KJqV5whAhsjq1P0bOIooHaynbbVP7XoPeGJtew+h3tYRAh3GYe9wyj8x6BWNAirrd
         EvhQ==
X-Gm-Message-State: AOJu0YxfqOdPSBdHbt6KKornTUpa2EKsQZqphUzLdfia1Xk+OeSJRdzs
	v1Lv4vaimMkIt+pUAIDYzKeON1KbuTtN59vS2BSr0+0W35aA9mF4ek1nFOuPERSTbyF9/3Ap9a7
	wvA==
X-Google-Smtp-Source: AGHT+IFla4GDZfHaU90+p/2AOWX0WflGLZrF5O8BHncJtppZttlhhCuIMLc3r7pr43yg6goGgjFtLzAvkvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1104:b0:dc2:1f34:fac4 with SMTP id
 o4-20020a056902110400b00dc21f34fac4mr202972ybu.2.1713393439333; Wed, 17 Apr
 2024 15:37:19 -0700 (PDT)
Date: Wed, 17 Apr 2024 15:37:17 -0700
In-Reply-To: <20240417200849.971433-2-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com> <20240417200849.971433-2-alejandro.j.jimenez@oracle.com>
Message-ID: <ZiBPHVKKnQPYK7Xy@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if
 APICv is enabled
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Alejandro Jimenez wrote:
> Use the APICv enablement status to determine if APICV_INHIBIT_REASON_ABSENT
> needs to be set, instead of unconditionally setting the reason during
> initialization.
> 
> Specifically, in cases where AVIC is disabled via module parameter or lack
> of hardware support, unconditionally setting an inhibit reason due to the
> absence of an in-kernel local APIC can lead to a scenario where the reason
> incorrectly remains set after a local APIC has been created by either
> KVM_CREATE_IRQCHIP or the enabling of KVM_CAP_IRQCHIP_SPLIT. This is
> because the helpers in charge of removing the inhibit return early if
> enable_apicv is not true, and therefore the bit remains set.
> 
> This leads to confusion as to the cause why APICv is not active, since an
> incorrect reason will be reported by tracepoints and/or a debugging tool
> that examines the currently set inhibit reasons.
> 
> Fixes: ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no APIC")
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 26288ca05364..eadd88fabadc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9999,7 +9999,20 @@ static void kvm_apicv_init(struct kvm *kvm)
>  
>  	init_rwsem(&kvm->arch.apicv_update_lock);
>  
> -	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
> +	/*
> +	 * Unconditionally inhibiting APICv due to the absence of in-kernel
> +	 * local APIC can lead to a scenario where APICV_INHIBIT_REASON_ABSENT
> +	 * remains set in the apicv_inhibit_reasons after a local APIC has been
> +	 * created by either KVM_CREATE_IRQCHIP or the enabling of
> +	 * KVM_CAP_IRQCHIP_SPLIT.
> +	 * Hardware support and module parameters governing APICv enablement
> +	 * have already been evaluated and the initial status is available in
> +	 * enable_apicv, so it can be used here to determine if an inhibit needs
> +	 * to be set.
> +	 */

Eh, this is good changelog material, but I don't think it's not necessary for
a comment.  Readers of this code really should be able to deduce that enable_apicv
can't be toggled on, i.e. DISABLE can't go away.

> +	if (enable_apicv)
> +		set_or_clear_apicv_inhibit(inhibits,
> +					   APICV_INHIBIT_REASON_ABSENT, true);
>  
>  	if (!enable_apicv)
>  		set_or_clear_apicv_inhibit(inhibits,

This can more concisely be:

	enum kvm_apicv_inhibit reason = enable_apicv ? APICV_INHIBIT_REASON_ABSENT :
						       APICV_INHIBIT_REASON_DISABLE;

	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true);

	init_rwsem(&kvm->arch.apicv_update_lock);

which I think also helps the documentation side, e.g. it's shows the VM starts
with either ABSENT *or* DISABLE.

> -- 
> 2.39.3
> 

