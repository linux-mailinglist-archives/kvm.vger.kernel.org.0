Return-Path: <kvm+bounces-7190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2868383E11B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C86461F261F6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1612520DCE;
	Fri, 26 Jan 2024 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGc/ziW9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16020B24
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292761; cv=none; b=Y5m9gH9YvKWkO7SkEeKL+auI/QpJDTdZdM+zaX2nEyYqULB/sOUzwo8ao576aHtrfqbEeCG94Sr+jBlkgGACKI9rwqQibFNJJAeCH9M3/6PalElC9k8DPoWY2qIwEhJekDOmcOMBSc2Euyd4VF1n/TYmyiRq4xXDg7chPMJckg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292761; c=relaxed/simple;
	bh=6yCOi67LSlnU+pmKW/Ep4Ha9/RlzYxbaLQYCGWndYNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MXeljihVl6671M1s/kIjOV9vEEVqnjdA7KoQedTI+x9awIvN/kE8SLAG5Jse85nytXghrKwO8zbWEwBHUci4NlkXAFO0PWSgN1gxZAYznndm7Ee05v2sSl9uGwUjLbVpGPZ5TAeD8/9DcTbECoFo88r3hvV4w7TfchaPoloiUzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGc/ziW9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706292758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcV+9Bo1H23A9wxX2UhBXjVrN11bidIv7zn0dsKCWms=;
	b=CGc/ziW99IYRgNoSWJpPT1TG6eTKsuE2X11C9QutBNhciUXZIIvZRqSYRNeyeYFafVaw+J
	qiEzVlJROQr5qV1lwK5WxBBhdkEvxLR8VokJm4vwDBLyuk4vi7SfdoPPDhQ6XC802LTQxM
	K60hfmhOGyo0VSjgVTnVn56EE2jCFLw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-bMuqrGp6O9aGXPX7Kspvmw-1; Fri, 26 Jan 2024 13:12:36 -0500
X-MC-Unique: bMuqrGp6O9aGXPX7Kspvmw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3bd4b623e4aso932385b6e.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706292756; x=1706897556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcV+9Bo1H23A9wxX2UhBXjVrN11bidIv7zn0dsKCWms=;
        b=ZYMvV78UBxnUJllvMwIk1uhJ1vtOUTMb+SuyGzO6UClqXuMJ5ztCFtGoGVGxvMhqlC
         31aZ7B2IWSkT3JFatiNLnVPHvASPLDu/pwFMhJcRBioZjFZr6UVloyQ2RXvdWql1c0zw
         fUyCg9yPljRnysIzSlZLU38y4YaYB5U5dh9QyynmLGSr8tG14zR1O44tmfuxvmi8L9v3
         pJFiUIebutbvr3VSmaHc4ohnqf/bweXQvdYE7MTPYuj/HWpcmKzf5zw7PO2fXrcAIis2
         pYurF5DiYrO0pQYjs0vhpGToKxuPZmGhYKgXP+SBzrhec0XpYMpawigPuuRivfyXA92t
         2sFw==
X-Gm-Message-State: AOJu0YwST66BUMkNqiR9GY/X/mLjml2G/28D7wlz0Toefx2hIPyCuFB/
	ORegY1SRBEQZ7kVwMufw4jAKU9dIa2GxpnZQiaSpXSP9FjR2kM5GDL1KxBkFTVLN8zLkFeecBgm
	Dd8ybEGEF52sPdKLv/9tz4JPGGtpyENWbuZ5wy2PFK6oJYMZ9Q64j0LgBz2GBJnjkTy+W7jDqVw
	22eSy97CgXCPzse7zqPtmCt49c
X-Received: by 2002:a4a:bb13:0:b0:59a:f1e:9b3b with SMTP id f19-20020a4abb13000000b0059a0f1e9b3bmr31628oop.16.1706292755833;
        Fri, 26 Jan 2024 10:12:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWdCtjgO3580n6V/ysz5cdqBhP2YbS7PowzyjTwjU/nOPK/g3zR7PIHStrWznjt939pfIl/ZSUhr6xwGM74cg=
X-Received: by 2002:a4a:bb13:0:b0:59a:f1e:9b3b with SMTP id
 f19-20020a4abb13000000b0059a0f1e9b3bmr31613oop.16.1706292755620; Fri, 26 Jan
 2024 10:12:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZbGkZlFmi1war6vq@google.com> <20240125050823.4893-1-moehanabichan@gmail.com>
In-Reply-To: <20240125050823.4893-1-moehanabichan@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 19:12:24 +0100
Message-ID: <CABgObfbjzmv3WiVUMpxLHHYYf+EyvGxRvaMR0_-PkiKGOmSsxg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Check irqchip mode before create PIT
To: Tengfei Yu <moehanabichan@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 6:09=E2=80=AFAM Tengfei Yu <moehanabichan@gmail.com=
> wrote:
>
> As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> support via KVM_CREATE_IRQCHIP.
>
> Without this check, I can create PIT first and enable irqchip-split
> then, which may cause the PIT invalid because of lacking of in-kernel
> PIC to inject the interrupt.
>
> Signed-off-by: Tengfei Yu <moehanabichan@gmail.com>

Queued, thanks.

Paolo

> ---
> v1 -> v2: Change errno from -EEXIST to -ENOENT.
> v1 link: https://lore.kernel.org/lkml/ZbGkZlFmi1war6vq@google.com/
>
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e23714e960..c1e3aecd627f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7016,6 +7016,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>                 r =3D -EEXIST;
>                 if (kvm->arch.vpit)
>                         goto create_pit_unlock;
> +               r =3D -ENOENT;
> +               if (!pic_in_kernel(kvm))
> +                       goto create_pit_unlock;
>                 r =3D -ENOMEM;
>                 kvm->arch.vpit =3D kvm_create_pit(kvm, u.pit_config.flags=
);
>                 if (kvm->arch.vpit)
> --
> 2.39.3
>


