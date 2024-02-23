Return-Path: <kvm+bounces-9552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9383C86187F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34427B2362F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09923129A76;
	Fri, 23 Feb 2024 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BaH5c2cC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A984A2B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707336; cv=none; b=S/2WCceSG6OxD3OjgLVFfXAXa/SIhezZXca9YuSP4JjCV2F8QFLQENqRgOy1194CrAck5Y+Qj6IDp0z2D8lBvQWr65405/JlrAgSF+IC4H8rksrEMO/zbu3Xc42NhsdlxehpraZ6BcLeGdaH5LzT+vUA/hHzK/AX8pIw6fQL2HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707336; c=relaxed/simple;
	bh=PjIbn7vuZmgpKFTS/S05Q2avNwgeNmQE/ZqtPcno5Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FucwhRc27SlgYV7k+PyV4FfX9oWOjz/Zs2Lspw5gVLfK7VMs2FiDiatGwFr+Mx608xkUK3MyJgPAQl7cEIp302Yf7ruNbKkY4gTLs3i90tvuHl4yAM5a5wat77uAaTIV2ymYIJGpmkr+xRl9ieegcXEhwH1eL5xQetqSHgKeQxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BaH5c2cC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607e56f7200so10698217b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708707334; x=1709312134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mYWLMbIxWQEENVSRztSfcr6/pOIUurrebXe4uMlvipQ=;
        b=BaH5c2cCwNrbilawcXGNrDwIdu8zV/1Kzt7bpg/6f6ewISt6vyPu+j42872+6PyuTE
         WvlOC3HiQz5jjubtKrePpaY2KYkr7wFrlX1NU4NJSxNmx5g2j87/wcrV4gMY4FEk0Igz
         h4eiHZfWqdD83suuahnUfMcQbFeX6DkRlqiwliPPvGf9BUm+wr2TcLnKveijmN8Gjt2b
         DNu9SR+gr4k5ijoqmw0wZ2+dJ+PKCGfE7YpfWyjwNfT8Utbcu4MoejJm+hCHdLjbMZcQ
         Ho+q+wBwvXOLzB7Lt0z9mYAjKZ5f83y8wR8xbeixOPbEyRIvgCZZd+ssisK7zAj3vtMe
         WTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708707334; x=1709312134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYWLMbIxWQEENVSRztSfcr6/pOIUurrebXe4uMlvipQ=;
        b=eLls8EJZQILo0NBbIMi/pDUL67patK527Tw9BMz6rKbVzWBHkXdEN97xCGubMdPhwo
         1rD6SM/vo6/K2HvcyA3PN29P+8gn1pgIv75jaeZtUl0u9K6HAJu7vRGsoki0vHz1Wmb7
         /l+WHOYz2SUfSIU+BbRSULKaae8x38KcOlZzHq95I15lz0EVWPYISN+L9pD+FDCQtIs8
         A3b2F15y7QCCJSqYMpUP+7yl+wkkXjd0vIBGUU8ki8vuDa9zTdBQBzriI1U13/R+D17X
         SA0QhXSIwPQ2txfLWmaQq8tUPOjMMtMXsHylZi4HIvaeduAM/EQFO/+ElNWAI1fX+qUj
         hnBg==
X-Forwarded-Encrypted: i=1; AJvYcCUZrEW8HaHhrO8THPIp+2ejSNZ9SAkS5Gx6OT+g+er/udk/6aTx6YK0QkNx3+94f8/4opiAdk6o+CfzFplJ/XpGXRZL
X-Gm-Message-State: AOJu0YxwZMC59qkblRzRLiZSQzP5SxY5JG+aYp0w5b5T73w74ToCCO4v
	KgEQg4sWe4FvTevK/ey3rC9qntpeSskn/vgHriFl+inSbKHJukarjcP3Nvuoe0nFXJXQrq8ja8p
	hNA==
X-Google-Smtp-Source: AGHT+IFkYP1y0rThJ5zyCPCZZDCCxNQ2WYNS10EMBTaaHdno7tm/mwyj/0/APM7XLuWGiQtT4Kl4EPdV/xw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c7cd:0:b0:dc7:865b:22c6 with SMTP id
 w196-20020a25c7cd000000b00dc7865b22c6mr25774ybe.8.1708707333910; Fri, 23 Feb
 2024 08:55:33 -0800 (PST)
Date: Fri, 23 Feb 2024 08:55:32 -0800
In-Reply-To: <20240223104009.632194-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-10-pbonzini@redhat.com>
Message-ID: <ZdjOBD-Ehv3qnuDu@google.com>
Subject: Re: [PATCH v2 09/11] KVM: SEV: define VM types for SEV and SEV-ES
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:

Changelog...

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 392b9c2e2ce1..87541c84d07e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4087,6 +4087,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;

Ugh, we really should have

static inline struct kvm_sev_info *to_kvm_sev(struct kvm *kvm)
{
	return &to_kvm_svm(vcpu->kvm)->sev_info;
}

> +
> +	if (sev->need_init)

And then this can be:

	if (to_kvm_sev(vcpu->kvm)->need_init)

> +		return -EINVAL;
> +
>  	return 1;
>  }
>  
> @@ -4888,6 +4893,11 @@ static void svm_vm_destroy(struct kvm *kvm)
>  
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	if (kvm->arch.vm_type) {
> +		struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +		sev->need_init = true;

And

	if (kvm->arch.vm_type)
		to_kvm_sev(vcpu->kvm)->need_init = true;

