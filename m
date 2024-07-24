Return-Path: <kvm+bounces-22196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0668793B674
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA64280E9C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76541662FA;
	Wed, 24 Jul 2024 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z9xsy4WY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72F15F3E2
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844338; cv=none; b=MzjvT4QgPnLTBscKhRVMikJ3EUs69CkuCnd3KxbFRc5Rju5mx1NxmS3uCYA6RiLwsvpO3UAA9niuJsbAzwpztt8VgL41Ju3LMtpSbBg3nzMrNMe5x9qRL1X4I3GMlLi7nU/IdKrAlB95iVBZZ4AWovXIbZ0TEsi9PymC1gOdE0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844338; c=relaxed/simple;
	bh=XAS5FnfAyxRaqxP1LwIbsNSwrPYIUbrGJ3DtESBNdRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=O2Fjo/nytlAsetLt+a+DQQSggc1lG/2M6b+BuZOr+DUBY42e3qj+qrsIgBjfJYjuarSldK6rNiyxpgM7Wq5r+idxJvCWB4uyrNQ5TDlqhzGlPoKOlx5SiAyJwT9qpsPqOZiXIHMUuy2l9O3QUWB2wx0MRA+Mqwx5lD78wxHK3CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z9xsy4WY; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-44e534a1fbeso21211cf.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721844335; x=1722449135; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuGtKkPyK7vctEAZt4J3ZfJs6fEwB7j37nm/HIcPuxs=;
        b=z9xsy4WY/zFit8SBHmWx2EbYiMlzwVXLkXuyvS7bTjB8lACMgkyPxLLC7zUCTz+Zxp
         /9U6dgaBiI3631SnDwxiZ0Vq50E1de61844oeFpTg3r8lHYp9mPyVRJOIynPAak20CiK
         fkFWUTEFg/WExMDOyzIXl4DhS2BjjGqCPb3eQymts/Ozx4/g1jAy0Ex5XQpNkfGUxgWe
         XplgT+4EiaSYUpb4PtXNAoIDkwfv1O5B1VXxvhTv1+YABJIqnBeCn/Wk63kQA1R19rx6
         XCP6xaJCbyGYzPYPJhP+DmD6Dh+XiJ+eWCWvEg2ZIJRTpnyzB0kLsYjVDm3OlhTyVwJe
         ZyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844335; x=1722449135;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuGtKkPyK7vctEAZt4J3ZfJs6fEwB7j37nm/HIcPuxs=;
        b=ZcA6yYOMsGn0gk1mYp58qG9W02Sa8ri9qAGElctAgsnyJ5FjbiY1w6JVSugyYDDoJm
         HYrDJRvHyllGosThPTvLqzUGijV/I3ewsdeThaMhsFfEwl8o0nCgJEYZkIIVawJViSgl
         qohr6dodlQPNVLnzYxJA4JR2ysun4U+4EzuYGUp93/8RFaQ+V9fYKiO/T0MKJBrQJXtS
         w4TtQLIAiTikJH89+4GcFCuzXY0ceXcbBZJT1qQFeiMtTzJWlYbEf681xISy4QJzuC1T
         giY3fETsIkUaKA35k3FrKDLwYAXPYCM03HLzXBCDL4/18ebzzEVXQZr/JLSgEBQ0QkeD
         n9ww==
X-Forwarded-Encrypted: i=1; AJvYcCUMNPNYvtEKm0jSoWF3iFwBjjLPHJxDaSHDXhVqjJpNaOhbPdYmM1a5+/i/1HEa8oAxElHFX+fzSv2k4/oT6rk2Y44X
X-Gm-Message-State: AOJu0YyuFxyQ8xSwE0Q0meGbOp04qkyZutwygrgvSPBSRPwp8Ut5ECQP
	rLMuSb4EtdRxd13gb4CjBk39svHJTL/QHMxB+5y6o8ZJWusy5yrEECconUlQUVIDTdP8NGgbchv
	XQ/eGntVn4l0kkeuFkDN8077pb8zv5hS5QS0+
X-Google-Smtp-Source: AGHT+IFUxXUQLhiVTN7INUoYEedq0Zx3w8j41oaYCqQETbUHBE0QZW/hL5WKiVjoVwY4NRe72FQxYr7vdrBqQaaCDHA=
X-Received: by 2002:ac8:5e48:0:b0:44f:e2c1:cc75 with SMTP id
 d75a77b69052e-44fe52f4902mr276461cf.8.1721844334945; Wed, 24 Jul 2024
 11:05:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625235554.2576349-1-jmattson@google.com>
In-Reply-To: <20240625235554.2576349-1-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 24 Jul 2024 11:05:23 -0700
Message-ID: <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 4:56=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> KVM does not support changing the APIC's base address. Prior to commit
> 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or
> APIC base"), it emitted a rate-limited warning about this. Now, it's
> just silently broken.
>
> Use vcpu_unimpl() to complain about this unsupported operation. Even a
> rate-limited error message is better than complete silence.
>
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID =
or APIC base")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  Changes in v2:
>   * Changed format specifiers from "%#llx" to "%#x"
>   * Cast apic->base_address to unsigned int for printing
>
>  arch/x86/kvm/lapic.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index acd7d48100a1..43ac05d10b2e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2583,6 +2583,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 =
value)
>
>         if ((value & MSR_IA32_APICBASE_ENABLE) &&
>              apic->base_address !=3D APIC_DEFAULT_PHYS_BASE) {
> +               vcpu_unimpl(vcpu, "APIC base %#x is not %#x",
> +                           (unsigned int)apic->base_address,
> +                           APIC_DEFAULT_PHYS_BASE);
>                 kvm_set_apicv_inhibit(apic->vcpu->kvm,
>                                       APICV_INHIBIT_REASON_APIC_BASE_MODI=
FIED);
>         }
> --
> 2.45.2.741.gdbec12cfda-goog

Ping.

