Return-Path: <kvm+bounces-23509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9957D94A5C4
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 12:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD2DBB256AB
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 10:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9C51DD3BB;
	Wed,  7 Aug 2024 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HwrL4VuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9213F435;
	Wed,  7 Aug 2024 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723027113; cv=none; b=oI8HzPB+IBHvkBJ3WPPk7e48KnwrSqLCitfZp6nufT/JHQLXvMFLE0QIzGfsvip260osSj5Nlv+bjRljVRAVTf9bpzfHzUlUiQFZxkGxKNj/WK8zaYLwpdr5yyC7EWrBkF8zWY45e+PH5TIF+mjMGw57MB/d3rIDwbx0LArmt2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723027113; c=relaxed/simple;
	bh=c6O8Jgn7YO0U0wq/TmhVflm+5+xCtn399q0/HbwQbI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJ9fZmBzR1JJ5eroBQrDtb0UfwS5ktRTCjKUdUW1p5oNCVPVASO8XtNbclEIU+7/A1CJCs2I2BaU3dMe5pucEAJIN4onrJ2FH/i71Pjm3JzTriLHxEHav8HADwjaPhLH8BaXpYEQdSduUFctvTNF6Egf2mj1owYy7wqvOg4KNCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HwrL4VuA; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a7abe5aa9d5so200751766b.1;
        Wed, 07 Aug 2024 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723027110; x=1723631910; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6D9+CdwOmxM4FaTBLRXVJ6Ds/OjiXCNs/JwlfPbm+oE=;
        b=HwrL4VuAjhRyzPqqGMH1XQUnIzgXssHo+tSi5oh5Ztf0fQV6dh+lofr8lx6PXAl/F2
         S89yqZgrcg0l5Jdv+KUB2BXya40qS2MA0l9/FsvzR7eWJgQDDWUvAQQKjnXn7nQR9Wng
         XFugdOMtCxDixYX2ob4exycfbrbhRQzTTdVdtT5dLRQZ6C7y3r+8gVH+4odBYloJmg1J
         ZHFIVgZbj+moHBw/hEs74EswtALWMNGqY/dJnnPz7qOEUuKJNhK5QJxLUINoM6gvDsXr
         1+kstdIohuPBjdBYR9QEWlD1/9daILxZafhbp8FVU+NIhBoaLBoeb8OAqZGihBZV0h/w
         FXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723027110; x=1723631910;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6D9+CdwOmxM4FaTBLRXVJ6Ds/OjiXCNs/JwlfPbm+oE=;
        b=qTy8+s4T0bHbLMntGrrRFvrg/is9PcCEtp8gJfSigvlh1NQG1EcyRKmXlT2ldD6ekm
         /XndyiJgIqUZo3Ff1EsnfTgdo3Psy+iDM0ieDFk0XfK8PMerYX/JIra5FbQSB2UduUF0
         UcVUOzN2MpfhAtRve9pPdaR6FqnTvn9y9HG4eGISq/nNNlUeriEzrHIBuR6q3rg+Xo2r
         4SHaYGkbq+mwkisYIn+YJTV5V9ah+loLraLcnhnAZ7OgDAKTpVJuyz4olLCu9qwnbULB
         Am5GOyhTObU6/Ec2gEY9cXSN2sMsc2Rbg8qDz5HWFyG+M/Zx3iAc1WljHmNddcWu+6Ay
         CSyw==
X-Forwarded-Encrypted: i=1; AJvYcCUbdtZ3FMSdkWq1nZ8F6CBrFAs4r698mhRtswl0dLUsgg2B818FFvC6gmu9QJ4LnfQOiqXbKr6FPxPaKGfkzaK6AQbC/3zcMMvjrzHtBKrkc6YzndZBxwzFQ/572DKiWFw1
X-Gm-Message-State: AOJu0YySXdtXT+vOZFGmhul9P70nIcfPlwRp76S1UY/pMqE8iEhvoQfz
	n8N4k4oR6H7taVSb3oj9WhJduhdZiYOTWqKu9vZfXQNviF3HI9ZbHAwzE+B13X2GFsqfDtLjTIY
	vScaDTNuhZvV6C+zwsBVKANZ0g5iqjw==
X-Google-Smtp-Source: AGHT+IEjski3W1e37FTxf7wMovob8w/MwKxzLAvdhiqyffExq5ZuKcFK1hOouTbc9BnN1dfY7RDzY11u1YnUjlHU6ZA=
X-Received: by 2002:a17:906:4788:b0:a7d:8982:90ea with SMTP id
 a640c23a62f3a-a7dc4ffb1edmr1225076166b.31.1723027109774; Wed, 07 Aug 2024
 03:38:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
In-Reply-To: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
From: Liam Ni <zhiguangni01@gmail.com>
Date: Wed, 7 Aug 2024 18:38:18 +0800
Message-ID: <CACZJ9cXcm+he98NTr8RiuZygvhZ6CtoOXFkASeLC4RQLk3Xqsg@mail.gmail.com>
Subject: Re: [PATCH V2] KVM:x86:Fix an interrupt injection logic error during
 PIC interrupt simulation
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

frendly ping

On Tue, 30 Jul 2024 at 21:59, Liam Ni <zhiguangni01@gmail.com> wrote:
>
> The input parameter level to the pic_irq_request function indicates
> whether there are interrupts to be injected,
> a level value of 1 indicates that there are interrupts to be injected,
> and a level value of 0 indicates that there are no interrupts to be injected.
> And the value of level will be assigned to s->output,
> so we should set s->wakeup_needed to true when s->output is true.
>
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---
>  arch/x86/kvm/i8259.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 8dec646e764b..ec9d6ee7d33d 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int level)
>  {
>     struct kvm_pic *s = kvm->arch.vpic;
>
> -   if (!s->output)
> +   if (!s->output && level)
>         s->wakeup_needed = true;
>     s->output = level;
>  }
> --
> 2.34.1

