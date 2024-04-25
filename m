Return-Path: <kvm+bounces-15898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CA48B1E67
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AEEF1C2409A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 09:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992888529B;
	Thu, 25 Apr 2024 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dW5sVIxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A7C84E13
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714038570; cv=none; b=KzMwRhVNosuX0yuBiBTSbeOUHthijpsIduoDYrywowS3LL2pwpWWVnyN3dfrth7i83c0mGLNfjNze02BY5+ss5M7qz32jn1e0EDTGjbXtKgemK2FzkpIu8te22jdA77QU0y2kA8mh1zvlqKhbmd6hvEWUSMKhpAFLPnh0EkYqf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714038570; c=relaxed/simple;
	bh=35aW69QPE+lCEJiyyhy9K78gc5bTQ0CCX9ATNwOcmrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sQIYvPDMFsGjfrZCEhorkKxQe8fedGkMYHBL3faVBdgz4nfLnA/MKHkr/eZARSIQUF7LiT+QhF75v9lkMeJq/nnR6nht5JlfRmpKG2lqwquhqw+prc7yXtlsIejy6wv9WEQYjiDfiakhk8bsKS54k46CW1DaR1JjuOJjdo6Zx4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dW5sVIxC; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-47a21e0cde6so346317137.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 02:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714038567; x=1714643367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tClP56HRC4jtLkyQNL35pL67xVeU0Fa8cWNQ8DcTkjY=;
        b=dW5sVIxC34/UKwEhLrDvZQB1q44rzx6pOA3BqtXgaM46wjukJcG4kxyvq2Sjl1ppkf
         dA09IwEC76tG8p9rG9dDPJghLMI9xvAYCB7kp9bywikyc5FaAupZltIUfkuDI+UNXWTp
         Sd2HPP2KEHbUhCSLj7gOQF07cJjoXdmpOi8yzRxX+gaSRNbsuLRdKwhWEWoxFYPv80d3
         Oy0wflZiWgAzAKHdbg6uH42KNbIZt7GGfhUBcxYLQmJgnZfrPYOMmEhBtinnhuv3wS1i
         DQDawGAzhz9PSEyQpbPo8M/L1N3oSSAvo/KskPjzUwX852oGlo+e0GZmXqHMSdUGVLvO
         vJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714038567; x=1714643367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tClP56HRC4jtLkyQNL35pL67xVeU0Fa8cWNQ8DcTkjY=;
        b=B7aiITsWDGvrXhtKfwEUhh5sd/HBnNQUbaopeSpRaX5lnP2VnoVZJi4WZ4fJxTtTNk
         YaPWXJWhiDznVlGJEk9YxXSE0BBbOwGT/9eHV7Ub0K9GggILoP/hZz77g1vevQ2eL1nF
         k4StrLt5F1zXMak5S6jsDErYC3em26C/6uoORJFJRI+tzbNRREEn/IsZQD4jjwlo2BsC
         WrUO2Ol4m1mXgkC8glxFAF5uRGd+SB7/U9mGy4UZYHU4Vi2vKucKxKBhWpoEU6dIfbjC
         DVvxh9NcerYRcfLGrkZ9vR+L8OLLhbEaJ7ujPz8Ll+jcnmkY2JbLSQFh+Wc1gPRPclL2
         mJFQ==
X-Gm-Message-State: AOJu0YzOFLM843i4wPxTX15woKRczuDpQERrnDKNoRqN4BGYIxbnIQOb
	A7D/3gaa23FhK7SuMbzuYNCFdnb5NsTEt7z31xrlMlmfEsCfNDMY+Alxy4FtbFY0Yeok9N8qAVw
	kHVyOCfbQXFqRDU1DGbyS4Ev+euuNmOfbufio
X-Google-Smtp-Source: AGHT+IEC/dRlxbrk0648Rxs8czpEdv4hXYFhGbXj3jiK+CmRCTvqhbhhoKq/K5RAClwxB81VEQO2Gra7meS06C6gGrs=
X-Received: by 2002:a05:6102:11eb:b0:47b:9ca3:e03d with SMTP id
 e11-20020a05610211eb00b0047b9ca3e03dmr4935716vsg.11.1714038567115; Thu, 25
 Apr 2024 02:49:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com> <20240412084309.1733783-2-steven.price@arm.com>
In-Reply-To: <20240412084309.1733783-2-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Apr 2024 10:48:50 +0100
Message-ID: <CA+EHjTwDaP6qULmjEGH=Eye=vjFikr9iJHEyzzX+cr_sH57vcA@mail.gmail.com>
Subject: Re: [PATCH v2 01/43] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Sean Christopherson <seanjc@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 12, 2024 at 9:43=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add flags to "struct kvm_gfn_range" to let notifier events target only
> shared and only private mappings, and write up the existing mmu_notifier
> events to be shared-only (private memory is never associated with a
> userspace virtual address, i.e. can't be reached via mmu_notifiers).
>
> Add two flags so that KVM can handle the three possibilities (shared,
> private, and shared+private) without needing something like a tri-state
> enum.
>
> Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/kvm_main.c      | 7 +++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..c7581360fd88 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -268,6 +268,8 @@ struct kvm_gfn_range {
>         gfn_t start;
>         gfn_t end;
>         union kvm_mmu_notifier_arg arg;
> +       bool only_private;
> +       bool only_shared;
>         bool may_block;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fb49c2a60200..3486ceef6f4e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -633,6 +633,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva=
_range(struct kvm *kvm,
>                          * the second or later invocation of the handler)=
.
>                          */
>                         gfn_range.arg =3D range->arg;
> +
> +                       /*
> +                        * HVA-based notifications aren't relevant to pri=
vate
> +                        * mappings as they don't have a userspace mappin=
g.
> +                        */
> +                       gfn_range.only_private =3D false;
> +                       gfn_range.only_shared =3D true;
>                         gfn_range.may_block =3D range->may_block;

I'd discussed this with Sean when he posted this earlier. Having two
booleans to encode three valid states could be confusing. In response,
Sean suggested using an enum instead:
https://lore.kernel.org/all/ZUO1Giju0GkUdF0o@google.com/

Cheers,
/fuad

>
>                         /*


> --
> 2.34.1
>

