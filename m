Return-Path: <kvm+bounces-21461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF45C92F2B2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7691E1F2340C
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 23:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10FD816D9AC;
	Thu, 11 Jul 2024 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IB6uPHY9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6615A4B7
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720741286; cv=none; b=Ni7revEJwZ6U+tr7N6nkkgtGhIXiy68ul6czQt3UyYbGfokV17dGKblyOtfQsyN5b0CSqwEX+KvBTwHrLHaePaWzr9AHMgrH8L9qwwcNGfUsWhca/huJJtLPMGUoh0FqYt1jdGLipWh03HAf9r5rP8VwtvvOrnZw+QLaCN4qWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720741286; c=relaxed/simple;
	bh=ZdwiAaNOEcsQ1iawVne670iRqDXG2wC8RCl2vG0f8s4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqK2HzdtjgESvHoqeG9ucX86D4sF6r2MUAsb0phNdc2iKG2vviu+6z3zS9cYbQA6axtI+CQHpCuf4oyiLd9o9eupo+pcAfm3b9hIW/I5s6jBUl8Ys+AP+ey4ThIxs4LlDmIPBfs74EDbZcjw+ybOb86+elrmzOilrj3tDsqrsxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IB6uPHY9; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77b550128dso184940966b.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 16:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720741283; x=1721346083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfuHNi5R9KMj0UxFnDquGekhSFTlViomrJL3yZ6eHpI=;
        b=IB6uPHY9b3oD5sCw2UHcPFkbTlKmi4/7xOElYQ8683WO3DaPYW2eSl7j0xLwm7Rt8V
         MQxnsZXhMYO0X42+P9zjHyFXVBvCNlFybjPHGijzQb3dpwPqx1/fISZQyeT9ROE1t7DN
         cly7UhAEE2irDxu9+vEfzlhFvQHt8euTxRCKE/VS1MDcieh35mL9ph5m1rHp4O3uyaIg
         UdQ33LbDBZZQg4GosPxXYQ9s2WTZgj2myGFFEqBvA7PTpF8tpT2fLyZQq+3yl/CcSUOK
         64jzmYVsKdcFyxYm83i54rUY2z2NjLeOsGbEW8ZHhhq8Ufnm+F1gcy3s41I1andsrITP
         Ja7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720741283; x=1721346083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfuHNi5R9KMj0UxFnDquGekhSFTlViomrJL3yZ6eHpI=;
        b=ccfQCpSyzAOB20w2EBdx9K6/cldrpaJ9BoOJMaqtnlsiof6A/jW8Xu+gsWVWZIz6OY
         24CfXXDzyMAJ2tH5zFkdPJWRKtugPt7y5ufWJp7XhxQE7tupI1CbJpLwPgOurvqUkpZz
         k5lTzO+XhuZJR79ocHsQU4Ub5HL7kDEmGvF+61Tapfk5QIkTgQAgqWKTxQPP6R3ywJZ4
         /w+bZ6YQ8w7TDIwVnhpPWyCtwDfRhSzZH52avN3y81LVwi7eEpYLHFX/ThYEiUNbsdvK
         afqJIz2rijFYgDG+KKvF2S0JQVikxJMtvwLnZ2vstDGo/OWJ3m92778MPet3UrsqmoHq
         Hq3g==
X-Forwarded-Encrypted: i=1; AJvYcCX/xxMaXUA+urWYurLvQN7mI8VJQ/NS8yJITa8av2x01HJlnTRtfgHypQ3qHjAcT+c0OE4W4a3AK86CcL0ioVmkTahL
X-Gm-Message-State: AOJu0Yz4Ja0KaBbdr4WH5/mqpDbs2bd/sgijZBKt51S0AOnG4tdAruXD
	KoWKgKOpgZ7+teEDbgJZVFeSfkC1lEC/93IHy3W/oNrmUlRqw+3XizLpMUN1biT49uWgdOR/qDv
	jb+oY7+PhMVR4zgGa1cReKdLVnoM1xa0IQThp
X-Google-Smtp-Source: AGHT+IFND8OJ4Hc6Luty4DujmFBUJFFOnOhkbf4bXVfGHjmUWdjIMHEqzQfgESAoCPprxuNTe9hiEGwJ28pFonfz9vc=
X-Received: by 2002:a17:907:d93:b0:a75:20f7:2c71 with SMTP id
 a640c23a62f3a-a780b6ff667mr1002583166b.38.1720741282837; Thu, 11 Jul 2024
 16:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <20240710234222.2333120-5-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-5-jthoughton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Jul 2024 16:40:54 -0700
Message-ID: <CALzav=dfpy=BSZD4hOVMFSrfxgc5OhDjZHek7CzMDYRqTBALwg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/18] KVM: Fail __gfn_to_hva_many for userfault gfns.
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
> Add gfn_has_userfault() that (1) checks that KVM Userfault is enabled,
> and (2) that our particular gfn is a userfault gfn.
>
> Check gfn_has_userfault() as part of __gfn_to_hva_many to prevent
> gfn->hva translations for userfault gfns.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/kvm_host.h | 12 ++++++++++++
>  virt/kvm/kvm_main.c      |  3 +++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c1eb59a3141b..4cca896fb44a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -140,6 +140,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
>
>  #define KVM_HVA_ERR_BAD                (PAGE_OFFSET)
>  #define KVM_HVA_ERR_RO_BAD     (PAGE_OFFSET + PAGE_SIZE)
> +#define KVM_HVA_ERR_USERFAULT  (PAGE_OFFSET + 2 * PAGE_SIZE)
>
>  static inline bool kvm_is_error_hva(unsigned long addr)
>  {
> @@ -2493,4 +2494,15 @@ static inline bool kvm_userfault_enabled(struct kv=
m *kvm)
>  #endif
>  }
>
> +static inline bool gfn_has_userfault(struct kvm *kvm, gfn_t gfn)
> +{
> +#ifdef CONFIG_KVM_USERFAULT
> +       return kvm_userfault_enabled(kvm) &&
> +               (kvm_get_memory_attributes(kvm, gfn) &
> +                KVM_MEMORY_ATTRIBUTE_USERFAULT);
> +#else
> +       return false;
> +#endif
> +}
> +
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ffa452a13672..758deb90a050 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2686,6 +2686,9 @@ static unsigned long __gfn_to_hva_many(const struct=
 kvm_memory_slot *slot, gfn_t
>         if (memslot_is_readonly(slot) && write)
>                 return KVM_HVA_ERR_RO_BAD;
>
> +       if (gfn_has_userfault(slot->kvm, gfn))
> +               return KVM_HVA_ERR_USERFAULT;

You missed the "many" part :)

Speaking of, to do this you'll need to convert all callers that pass
in nr_pages to actually set the number of pages they need. Today KVM
just checks from gfn to the end of the slot and returns the total
number of pages via nr_pages. i.e. We could end up checking (and async
fetching) the entire slot!

> +
>         if (nr_pages)
>                 *nr_pages =3D slot->npages - (gfn - slot->base_gfn);
>
> --
> 2.45.2.993.g49e7a77208-goog
>

