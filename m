Return-Path: <kvm+bounces-16383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C1128B9245
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD0CD1C2124C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC997168B15;
	Wed,  1 May 2024 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sEwO7ik"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C62168AE2
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714605812; cv=none; b=c4+Gm68gYrleqvDDiYe94IUwlUow4wy8wqKzrr6VW9X3y+Lx2nh6X0L72L5KzJQrxUcME4BuQh1umk7Ns5uNmV26o9KZJqeQGWakwuisYbX9GYOz1U8TfHhWx2pg0LN8aT6I2AvdTLKJdVygXXTp6x0wVgCAAEzBB0lB9L/V6AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714605812; c=relaxed/simple;
	bh=231v0OwQJF08ECYNjJXoWz8Y+SFz+mViZcTa+7nlTz8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FZc6TUQGdsIgDOIN2uesD/dx82SO8Es8VhURbEYEGf5ioS+oGWmv9+v9p6oeAytiUz2SB8FvtHYp3Yj7EOCfzA/T69ntIAT5hFCW1fdF13R59L3vKo5DEOP3sa9/bkbgnExHKi8eQMj/xH9CkQVAbVS3pqXmvAyU9MOeItoee/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sEwO7ik; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61e0c1f7169so4298017b3.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714605810; x=1715210610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/FNnnFZTcKPfEm7VblCNu4kPLJ7DsOg30+YeTbsn4M=;
        b=2sEwO7iksPX3CiGGwtiZ8xIlyuGST4sTUhG/kGStcMODip3P6O3mA87jsXReKDx0zp
         6hnRBSvdPgSyHgRSCj6l4QgXgzwUGrPCGLwg9P3xSsLVtKuUpJy33UIKfchHlMtcu1T9
         gfTD5uX8MIYPRA5dI1q6cefrsXaI7kmFvuQlzZIJJs5JcU5yscZYI7WN+EyP0q4QeFNs
         jvdAO8WiCtdo2BvnzjadQSegB8rP/JCM/TlYfZfMm0NJSVmASWQ3oCJIJkOxCsr3muzo
         h4nTBvs7poR2yxFXDbcOuGPDxZkzog1NreOSFr/8eIEu2Tp3GMfSr7WIwT4g/V5uUpCk
         8BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714605810; x=1715210610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/FNnnFZTcKPfEm7VblCNu4kPLJ7DsOg30+YeTbsn4M=;
        b=eDItaz6vnGrrZvq5Ux7RECvmcApSObfURIcBJCiP5KBC948++DQUDOF0SCiPKItVr0
         5ANuy3KqKtOeaTRFBMGigHl7k/sHP1oYq+pE4PVSem9hEjYwd/bCqhVH46CP85Vfx0+u
         cOpwKsjjaNReYzw9SITUgQ0M85g5LWACiz9QvuQZki8cPI5nkJHCdjcHci9DH3wQG+Cn
         HI/Q8k/fun0mP7ZqqyjNh+jr18d0k5e5RBZEmKAzc9CrojuDD6y0K0ynGd6ZeWcKjULM
         qNpOIkp2q+vgLFOb4tF4ZoGJF3aCbcVqs9BHADOFbbVa8cqPNFEAH027T1yMV2hP/Djp
         NE0g==
X-Forwarded-Encrypted: i=1; AJvYcCVnUBiawXDxkm2RvXxewiMe6B71oykcoso0p8A5OtP9QG9hFsxVs5FawE799ed6TJCLmIoq6CRccsN09F0eptJGwqOK
X-Gm-Message-State: AOJu0YxkkxnvLyR7Vt3WMLxzMAfKfwf6PHHVUb/sFkhiGkOLjNf+mZgy
	s/AKWw6052UUeZWgHVyKl06HhvqEZYGBxlyceJH3XPlsrVb9Gajrjt0+8y3g8CVqScbheaF6iMp
	z/w==
X-Google-Smtp-Source: AGHT+IEOjeIyS0Vq7PCwvO7KUdaZE2d8RWnqhYBXhtHAcO9e78TZV/qDl2RIwSPsFQChQCrvTG3v5kji/6c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c0a:b0:dd9:20c1:85b6 with SMTP id
 fs10-20020a0569020c0a00b00dd920c185b6mr278499ybb.2.1714605810351; Wed, 01 May
 2024 16:23:30 -0700 (PDT)
Date: Wed, 1 May 2024 16:23:28 -0700
In-Reply-To: <20240219074733.122080-27-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-27-weijiang.yang@intel.com>
Message-ID: <ZjLO8FsnJ7NgED0G@google.com>
Subject: Re: [PATCH v10 26/27] KVM: nVMX: Enable CET support for nested guest
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> @@ -2438,6 +2460,30 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  	}
>  }
>  
> +static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *ssp,
> +				       u64 *s_cet, u64 *ssp_tbl)
> +{
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
> +		*ssp = vmcs_readl(GUEST_SSP);
> +		*s_cet = vmcs_readl(GUEST_S_CET);
> +		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	} else if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
> +		*s_cet = vmcs_readl(GUEST_S_CET);
> +	}

Same comments about accessing S_CET, please do so in a dedicated path.

> +}
> +
> +static inline void cet_vmcs_fields_put(struct kvm_vcpu *vcpu, u64 ssp,
> +				       u64 s_cet, u64 ssp_tbl)

This should probably use "set" instead of "put".  I can't think of a single case
where KVM uses "put" to describe writing state, e.g. "put" is always used when
putting a reference or unloading state.

> +{
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
> +		vmcs_writel(GUEST_SSP, ssp);
> +		vmcs_writel(GUEST_S_CET, s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
> +	} else if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
> +		vmcs_writel(GUEST_S_CET, s_cet);
> +	}

And here.

