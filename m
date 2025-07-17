Return-Path: <kvm+bounces-52735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DB6B08CD4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 14:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B21831AA3EDD
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 12:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49792BD5BF;
	Thu, 17 Jul 2025 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sLlwHrkw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF00A2BD588
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752755158; cv=none; b=uviV6c2Th5EUpASQUVEl0MVle6XqAhjSxRUQGrOja8+bEZP+nz7occLIpX79+PwXIIah2bRPB8Lth27rooekaYcX2+n3z/Aa00JdmxpEupKXHCAt8fXQekttxB87AF6SjRoXR/kqykVK3L0fPbdAqHOc/DEgpQykSKpG6i1ZlhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752755158; c=relaxed/simple;
	bh=vFY0nUunvlGqLxXg8e41Kh2n8Hq2zaTpVxr1ylslpZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4++Mz7EvEUcbVR+3x5NItOGsBukkhbPUcXpTXThtawjUORTrYhaeItnT3n59XKtPxVl/WatilMbGw9eCJoM3qUSrKi2LnqtyETuwjyDWjUdNOGVBN8S2Plsw4UjdKzt4n34jtR36FCEfmt70ylywoEIKgvdkfhtrXBgUD/4kmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sLlwHrkw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-237f18108d2so144415ad.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 05:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752755156; x=1753359956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ChafKmeRDq7BBol4Pt9Xq7FfoEfLdZ8lQh7RZ12ztC0=;
        b=sLlwHrkwQvno3HHxMr20MYNp9zCM5Zu1rXPUz4Mnfc0XFt3sGfJwxeT/mmGJCL5hNk
         baCh/A536znQkEeKNSm1LGdwx+UCUCJype2xgSGQydUZ/7FMGI3YLOhcuxdHHsnoNzOr
         Bt3ywyLTrZzTYLN1e99nRt8Owqd3NARrLcQdSbycQDc7OnTlpoVzN75NLzmPqagEY6hH
         S8Pu9TSlokXqA4uprO4I3dxIZXToK2J3QvINupxZfJCWYMTC+5/6DpW1BetGKnSClv84
         EFBZoNbMcBZA654Ck5c5i3BSuvqgqPjm4awQHxwbEj1zFj/smVK7AYe6WgY9AlxijzC7
         1ksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752755156; x=1753359956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChafKmeRDq7BBol4Pt9Xq7FfoEfLdZ8lQh7RZ12ztC0=;
        b=vZOKZRAK3ccu3LCiAXcXxv2AB7gy/lYNL6iGl6FGFWe84s6ozX9vV9kFFc14G1k45e
         2sYKWupl6dazYdxLoQ97VQUySuuB4/gfO3zO+Fpxd81Rrf9u9MVT0SK+YTfilJ3xq+Zr
         R6lzZaQjbyX62NQsaXrS+5Hpnz30jU8RJ/5YfX9RaLDCuAzwIpjX5uD06hvkY2tNAYM8
         696uBnaM9ouJ1SyyCTc64Vw8TS+1gtk/AnN/Y9Au+WoQFPAm27eRQO+p0LcboPAmIARw
         TZZRl7UF3f3p4VL4to4XIj4LBuiJHcjou5cODymVnqRWE5uozR8dcjpqcR5HRbs4lLLi
         dWig==
X-Forwarded-Encrypted: i=1; AJvYcCUVXKxTH5go2+UUcqtk6dBrbXjsJcYXid5NyuNaHAh0SAQRyavpReh5XAxG6DUzfurYGIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsxtdJhkDbE1knA3u+xdB3nlMYRFp1Sw6J6/Icc8b+kesCAr6Z
	GT+5IBMNwioA5essFHO75aDLsLbxCrl+OTp1eptKMG9i7BV9LE7R92U9QjlCbKrbH/n3JM5gLfd
	oq/S4Q3PyhtREckxq/Cv6R5NEjfngMEKSjEKm8Jj8
X-Gm-Gg: ASbGnctSPa7pyiX1Qwh7m4gz2hY95ATJih9pz6o6XRILiU2fXurB5RltlcNuXBEnJjA
	T4LSpcI9to76rAPiYXeiCs1Ic4q4Xas/Gsc4NvQqekZwLwdzepbwX0+ufiXeEM6ClA/D6LIY/+9
	pTzWkuQwHHayZqIXuYDuVvsK1d9V6VHe91zEOlfYhRdVLFH29b4BwLl7tvs0ZsK+pb4gMF6aZtA
	EOdMxfhcbWfCQLjQ2G2SUnvSSB2vUYd5fDpWEPV
X-Google-Smtp-Source: AGHT+IEuSUvLGjJ9LnJSu0ASEm9Hu6l9HxUyAYK0uxHFZ7HyWOgUNlbykOmydDQTYxgeeX0nRB1YUMf/QZK64flQTCE=
X-Received: by 2002:a17:903:22cd:b0:215:42a3:e844 with SMTP id
 d9443c01a7336-23e31497285mr2701935ad.17.1752755155331; Thu, 17 Jul 2025
 05:25:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717022010.677645-1-xiaoyao.li@intel.com>
In-Reply-To: <20250717022010.677645-1-xiaoyao.li@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 17 Jul 2025 05:25:42 -0700
X-Gm-Features: Ac12FXzEyO5jZX8xOPwmf85jko29MZEzFgWRNZrg89OfQOg-N2XQCdwntWcuzLI
Message-ID: <CAGtprH_fNofCjJH1hWKoPwd-wT7QmyXvS7d9xpRNYxBznNUY+w@mail.gmail.com>
Subject: Re: [PATCH] KVM: TDX: Don't report base TDVMCALLs
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2025 at 7:28=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f31ccdeb905b..ea1261ca805f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -173,7 +173,6 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_ent=
ry2 *entry, unsigned char i
>         tdx_clear_unsupported_cpuid(entry);
>  }
>
> -#define TDVMCALLINFO_GET_QUOTE                         BIT(0)
>  #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT      BIT(1)

I am struggling to find the patch that adds support for
TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT. Can you help point out the
series that adds this support?

Thanks,
Vishal

