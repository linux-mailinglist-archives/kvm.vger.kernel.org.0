Return-Path: <kvm+bounces-35614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B246A13294
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00EFC3A7D2D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 05:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5DC157E99;
	Thu, 16 Jan 2025 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sAGMil+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C8E7DA7F
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005278; cv=none; b=L42fJqJ7aO6cnXOIFo/74UYgYNHsELFS+Zls1zxCR1WT5T07yoR4pQ7asf++X0LIiA061BP82CwEu08YtsBAZH7dvIkA6rF9XElTfcf1r0BoV7FF2gYHwp70MKlE7Yboth+3bFmMZPPB3J7aWmf3Gmyx5692XqEAchkh8Za+8jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005278; c=relaxed/simple;
	bh=L60Ehz5m9IlSHWYuC/xkkOu/iLMWCIP63jqc9uA7u9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maB2UEPEw7CWxRMzTfbMYksBqam8e6opFv2zx0T0UiaAdXB4eOh1KBwLkM91X27UBoH1aLXNFGjGtpiViCa6rQgop0gnHO5vzzmfQnmtfK/dDVA2TQf2PNk8tm1fnRuE9dUuQ5W4Sj4yFtzFHB0DCO0i9F3SAzWcl7UIoNdrikE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sAGMil+; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a7dfcd40fcso65465ab.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 21:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737005276; x=1737610076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2v09XF9zQzvlNY8SqkOSgO3dMkdliSd6tfrxxCHfKAg=;
        b=2sAGMil+7FdujYSPxVePcV9jgFo8Xz787j4hOlLOCNG72ZDNA/LphtFGOUsY//Sh4i
         xLe3fr9fceOXZsjgfcEhFNKF/Uj+HEm1Y6N3pZjRiLp/aiTRsu+J+bheV/tN9ls4geXu
         wN/25PoHh+84/5WhtJ+miz/p5Ek/PxCRGh1a3+arM04M9TJiGdhyjIvs0qtwlRZByNAb
         iNbGQI30OXYhH43hM0jVKrYN8OCiuDkRf3xVizT1QqGlC2I9kNFnhDMJ6LLFyby8vMOK
         /uThP7TQceOMVz84DtcYHGzoioi1VnetDeiaPmpXutu+DwFqnz0P1ggWGge5x3KefHpx
         4hOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737005276; x=1737610076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2v09XF9zQzvlNY8SqkOSgO3dMkdliSd6tfrxxCHfKAg=;
        b=GifCV7fXdOry7dAPL5A4JV0JzhBPHOUy932ZueSRfmUvS7Zyl36WQ1yoU7UQSEU12g
         G5Asa8A65Bg4nFwxxPbX/0PsF8GKjVb8sBFcgVwhVbHuXydYGSjBUAGPj6Wim/ezMo6M
         fqez4xXmjVtQDoBFvCB1Aijxr+J+wo/lsaYcnHrzsfBQywmbwaWBjgVALval06Wzlg8Z
         TC79c7FuTmqNYm6ZSf/Y0yz/KO99reLMaT6ENAqqTlvpAfuH6nJ+9f5Jq3DXbgXvqWdu
         EysSw33YRbi2G9AxmvEKUd54Lm4iAGxzBPp+lW4GH9Zsxp10TIN+P1kYiiy3wymJzVZ8
         ormA==
X-Forwarded-Encrypted: i=1; AJvYcCU+K+Ei32Y23pkoTkv9/vA13zqClUslnB3hE7sk/DJ4vjP/hC/bg6aflV0D8fQx+J//WV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjC0NPGuoicNot5xw/oR5YNooslRBjHWo7/ZF+iuftZOCNuKC1
	VVUAwgZImYRNI3w8vrb385Pb/w4/kXIztFopfNgquQ0qTzYSXdsiUJlOCnr5teFXgvXJGU9uJVE
	t4L4mnEqAXgQdM6XOLPBwUESR+l9qT6u/qTvd
X-Gm-Gg: ASbGnctib3cUzxfyVcA243nXhsixkf/Q6rSKe/3J78l+WK6YCrMmvVa7BUNIezLhuth
	eBSjXZG403e7S27X3XuLax4cdYgFx2xE8Mhyq9g==
X-Google-Smtp-Source: AGHT+IEX0Kmq1j9tecJbTclxt72vIPZEI7ZYaku7Q5PHfm7vk1vO1fGSpG1blnXeJT3IvzQfoa/mkgZ0d4gBi9kVrr4=
X-Received: by 2002:a05:6e02:20e4:b0:3ab:502c:b526 with SMTP id
 e9e14a558f8ab-3cee0bf9f62mr2027715ab.28.1737005275711; Wed, 15 Jan 2025
 21:27:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com>
In-Reply-To: <20250116035008.43404-1-yosryahmed@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 15 Jan 2025 21:27:44 -0800
X-Gm-Features: AbW1kvamF9KeS-hJzKHDfuO7gQ1lt4YSKOxRPBVo0iiUMJMiiVQnV-u_XjNOCtc
Message-ID: <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
> nested_vmx_transition_tlb_flush() uses KVM_REQ_TLB_FLUSH_CURRENT to
> flush the TLB if VPID is enabled for both L1 and L2, but they still
> share the TLB tag. This happens if EPT is disabled and KVM fails to
> allocate a VPID for L2, so both the EPTP and VPID are shared between L1
> and L2.

Nit: Combined and guest-physical TLB tags are based on EPTRTA (the new
acronym for EP4TA), not EPTP. But, in any case, with EPT disabled,
there are no combined or guest-physical mappings. There are only
linear mappings.

> Interestingly, nested_vmx_transition_tlb_flush() uses
> KVM_REQ_TLB_FLUSH_GUEST to flush the TLB for all other cases where a
> flush is required.
>
> Taking a close look at vmx_flush_tlb_guest() and
> vmx_flush_tlb_current(), the main differences are:
> (a) vmx_flush_tlb_current() is a noop if the KVM MMU is invalid.
> (b) vmx_flush_tlb_current() uses INVEPT if EPT is enabled (instead of
> INVVPID) to flush the guest-physical mappings as well as combined
> mappings.
>
> The check in (a) is seemingly an optimization, and there should not be
> any TLB entries for L1 anyway if the KVM MMU is invalid. Not having this
> check in vmx_flush_tlb_guest() is not a fundamental difference, and it
> can be added there separately if needed.
>
> The difference in (b) is irrelevant in this case, because EPT being
> enabled for L1 means that its TLB tags are tagged with EPTP and cannot
> be used by L2 (regardless of whether or not EPT is enabled for L2).

The difference is also irrelevant because, as you concluded in the
first paragraph, EPT is disabled in the final block of
nested_vmx_transition_tlb_flush().

> Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> nested_vmx_transition_tlb_flush() for consistency. This arguably makes
> more sense conceptually too -- L1 and L2 cannot share the TLB tag for
> guest-physical translations, so only flushing linear and combined
> translations (i.e. guest-generated translations) is needed.

And, as I mentioned above, with EPT disabled, there are no combined or
guest-physical mappings.

> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

I think the reasoning in the commit message can be cleared up a bit, but...

Reviewed-by: Jim Mattson <mattson@google.com>

> ---
>
> I tested this by running all selftests that have "nested" in their name
> (and not svm). I was tempted to run KVM-unit-tests in an L1 guest but I
> convinced myself it's prompted by the change :)
>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index aa78b6f38dfef..2ed454186e59c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1241,7 +1241,7 @@ static void nested_vmx_transition_tlb_flush(struct =
kvm_vcpu *vcpu,
>          * as the effective ASID is common to both L1 and L2.
>          */
>         if (!nested_has_guest_tlb_tag(vcpu))
> -               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  }
>
>  static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
> --
> 2.48.0.rc2.279.g1de40edade-goog
>
>

