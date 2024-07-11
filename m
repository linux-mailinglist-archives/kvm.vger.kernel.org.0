Return-Path: <kvm+bounces-21462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 407C492F2D1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C223EB23908
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 23:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E591A071C;
	Thu, 11 Jul 2024 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S+/L+bZg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA516D9B2
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 23:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720741987; cv=none; b=BcyAq/J/EbSOUKho21XKbKobas5bSc+WfQeRcqV94BMiAFqP7XRMHDejROHYfdRV7LAodyrjD21o8ct6y7t0199y5whUReIGg/PjQDFcf7dda51SJpkU5jibt7oCSnXyQ61SDQgIa5DiHmc6gBMJxrBuBnK3FJPMEOc+eMSLSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720741987; c=relaxed/simple;
	bh=eHwJddF+i82eOhfzBTfbWQn49KtPf7X+mrBUinBbdfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3NivrjAXyLC3AZpW0AX6ki588tbzzjBs1iY61KEiT4d/x/plsNDi++6GdTeYA2VHBaeTBEPdHJ2sPomoJQjkwAH4K5THGdY2E1kSjEcyyy+YxhwaZ0xgvZ+hOVDxw6uBdW45LoSM/xc03yfipiE7IYBA00tMrDs4E/U333iOfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S+/L+bZg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58ba3e38028so1958611a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 16:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720741984; x=1721346784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1ii8KLMLxRl5UF5VTiJZsw30BNj3HWI5MJg1fOCFrg=;
        b=S+/L+bZgkdvJz05Cm9iyiIJDNm355VyPSA9HsiMLiZePQFhWs/DcuEv9Z0lRvRBJXp
         guoj09t5IIQW2MpNUCgrlm5qgH3wF6HThmSWHv0ELUuBD5V0vSRXXX5U5Vbmb614S1lF
         9XgXKONT+TSjTnLj/MJxJUSV3h6nWye1mLgO9OK6JEsGV8r+hymtICdfta7Cb1GWWAhO
         OppbjFfIfhJZ86SzrewF/axThpXAlVYvncLP7Qz60FObvN80dBBPn69O8VeuiS+WRT8y
         +cRp2OSB2287rjKizRLGuA1nSo6RaI2FiaEIdA26v6OudFPv/q8yfkFmYNHlkzuhM+gP
         5v2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720741984; x=1721346784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1ii8KLMLxRl5UF5VTiJZsw30BNj3HWI5MJg1fOCFrg=;
        b=Q2Jdf6I4CsVANRKgo0rMb8fxPlbsefvjHq7iQF1JBbTSCX6NbsFc4jWUDKa0n5x3Fk
         QsZAdyVPgP58zaCD7A7DuhkqFKK2ShTIDjEXdJFEqbSJPAn324Vt2nPKSC7kFZN5Qso1
         yfHHCuHtymyrL6Z2YtyxpMck8bQMxZVQRmXdgYl4LTBCRRB7apiE0lXYC6bUWBhC+oyY
         IFwa8KN/6OdTOPQ5PrzvomjwLw2DKWgABZ7SAgNQnkbUffRJIbPyZoijzKbqx9NhQfTA
         A3AmwGlXWpGwjk8TwjPZCAKSb/6TMdrAbg+t/b1q7/dkm7VE5IvVw0crncLAU5TCCoXP
         C8Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXjEPWLPjQQ1umd2SDkAOwflEvWVZQhx08wLe29K35pFXssJrH5cOw8s4Q3Cq9ElkMqYNnAjIMvnV1xHqujkUB7Txim
X-Gm-Message-State: AOJu0Yx7yXH19ESMrnmIFfvmrRhzx+Qpky4zNOlT1MQVh2BVPdiGyUkB
	LCefJ3IC+xEZEvVrOHHvF0JkPYPN1zOz9RjVVIhfwBd8UiXwda4DDY04DUPIkZI3iwlO+3ejRnp
	i7LLCUaRMkqtXBbKj8M/s+9YHfQNiB1ZzPqiy
X-Google-Smtp-Source: AGHT+IGg/L+LIOLGS8JdBlkXQAM9OjIKvUIv0USQWI0ixWzGE8fSPNkcsknZoKiaKzNv9LECa/JaMTAQzxubG6QsFVs=
X-Received: by 2002:a17:906:cc9a:b0:a77:c7d7:5ece with SMTP id
 a640c23a62f3a-a780b701683mr557985866b.35.1720741984043; Thu, 11 Jul 2024
 16:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <20240710234222.2333120-15-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-15-jthoughton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Jul 2024 16:52:38 -0700
Message-ID: <CALzav=d=LaVCFTLxzJD8C_=6+fxjsoLxdKOnxKBgn_QdNDOoXw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:42=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> +       case KVM_READ_USERFAULT: {
> +               struct kvm_fault fault;
> +               gfn_t gfn;
> +
> +               r =3D kvm_vm_ioctl_read_userfault(kvm, &gfn);
> +               if (r)
> +                       goto out;
> +
> +               fault.address =3D gfn;
> +
> +               /* TODO: if this fails, this gfn is lost. */
> +               r =3D -EFAULT;
> +               if (copy_to_user(&fault, argp, sizeof(fault)))

You could do the copy under the spin_lock() with
copy_to_user_nofault() to avoid losing gfn.

