Return-Path: <kvm+bounces-22241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 238F993C3E5
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05FC1F21C24
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FB719D07D;
	Thu, 25 Jul 2024 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGYBSJe3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFF16F82E
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721917050; cv=none; b=kltWvciNm6ymWMlQG6gDjZqLW2Imya6KzJsCkgJUSNiSc4WtR/l7fSZJ/1L+PsbHPuw1MB84yZ9TGkRvL1MiaHIRKwcvoKjfs4uRemIBerl36Jo4fCvBv4AgtWOcffBhDap6c0EnGHC+TgxNilQpblb1WhgluJ6HvC7ZCGKPImM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721917050; c=relaxed/simple;
	bh=m0ZMQ8YI6zzsbMmByAgfdbdlLMaKgzSyQr5EHwcRrR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mkMDMo1cXhbIlWLD9BDPSVTDzhLoa2wF1up6znrbUlI1KIutJR9C6Q+KoVwcV/AUbfZqkz1PEcYa8NVrhDtVNv1t4ap2u3D0t377j5LbN9XF2zjX6i4GvZ+wYYOQK+66glD9JcOTZkt1EPMeURft+1Ih4i18ZN5ifbaHEe14t5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGYBSJe3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721917047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6tWMEURn2dHv81Y4P6gz/ql3VBVwZZJb7ZSFI752Xs=;
	b=KGYBSJe3Spy95Og8+as035miM1RbsAfQazvgT1BMZnbvGlQewfmRExflQZGWhIahbqwrP+
	Km/tzpPARcwaSroNA4iso2mt6pFLL8w2T5NgRk1mVfv/WfSfU2tdgMYnqM2FJkZ0y9od1l
	TTQK3hJQjdcL6LhJMQ3LDv2GXSg17RQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-A2rr9j54NoC367Mi5-d6yA-1; Thu, 25 Jul 2024 10:17:26 -0400
X-MC-Unique: A2rr9j54NoC367Mi5-d6yA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36863648335so625147f8f.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721917044; x=1722521844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6tWMEURn2dHv81Y4P6gz/ql3VBVwZZJb7ZSFI752Xs=;
        b=QjhG1yMTb9UYTPKVeZZg1uY7JxkDvwgkOkVq7P7YAt80FwiyTX/okPE8+KVOoCjmJ9
         Ei6UMLnZk9ITDVm7XTil9GaKkwwl7utvfLq4mGpXlNTq2ioGNMTLa+ECge+k92huiHxB
         BjBOzWTKsPdbmbQMs1d5MTzNrnkc/R3v5yNunMquZvUnVqzyrp2KOfGQ8bHUxz3Ywv3i
         zBmQJO5A5aK1wLp0Tmh8cjJGTuMqAE3ZOrS/A97m38UhgchIEaHQc2a901+ghB6976Bl
         hSRi4vv8lkJrK02tQ03WoaNzAnHcpbsE4VhWnjH6ZyldULu4knExc0kyLQk4fNtJMUv9
         cjMA==
X-Forwarded-Encrypted: i=1; AJvYcCU8FrLGKMfFy+XI59+NrkM592mNtezd/YduBDkEa8S0gX2cm8RSmQ/GC2QNhSlACmfsfkVjto3dvwxqdgHI6XkvIQpW
X-Gm-Message-State: AOJu0Yy2cEETBC5Bnwhpw667AJqlngD8RrNdsIz8krhTehfkhMk+7DMj
	nKGL+WkcbFpKEvlWUabG3QyBpRzFIHS5mdqosuMx6WrHt0q+XUbU04TLDYDkzH8dWsPSmgWkG5h
	hxe5efybfDypwKNPTcTtbDrtqWumYiYpSdx4BP2V9DsA1gglGOxvVLVjnNWPoZsN3yoiZphGEP3
	usIznMxCG8ieU9XFae3L/9O+2MTbGBphnO
X-Received: by 2002:adf:e5cc:0:b0:368:7edd:b141 with SMTP id ffacd0b85a97d-36b3639e019mr1635253f8f.34.1721917044019;
        Thu, 25 Jul 2024 07:17:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtE1P2i6EA6Nq11L4VNIqAiLzqnkGkUx3rairfHagP1FO4kiy9c/WYOcLgA6DWVqdqFLq/bQE2fCFI1g75aC0=
X-Received: by 2002:adf:e5cc:0:b0:368:7edd:b141 with SMTP id
 ffacd0b85a97d-36b3639e019mr1635239f8f.34.1721917043618; Thu, 25 Jul 2024
 07:17:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACZJ9cV2gv+A_2wCXowzi9M-HrySeBxNLKfK+bXRLffwR94=fA@mail.gmail.com>
In-Reply-To: <CACZJ9cV2gv+A_2wCXowzi9M-HrySeBxNLKfK+bXRLffwR94=fA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 25 Jul 2024 16:17:11 +0200
Message-ID: <CABgObfYzEzZuDSKjB1SYcveTaRMaayvY8cvtPD8qGLvkDiwV5A@mail.gmail.com>
Subject: Re: [PATCH] KVM:x86:Fix an interrupt injection logic error during PIC
 interrupt simulation
To: Liam Ni <zhiguangni01@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 4:00=E2=80=AFPM Liam Ni <zhiguangni01@gmail.com> wr=
ote:
>
> The input parameter level to the pic_irq_request function indicates
> whether there are interrupts to be injected,
> a level value of 1 indicates that there are interrupts to be injected,
> and a level value of 0 indicates that there are no interrupts to be injec=
ted.
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
> @@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int leve=
l)
>  {
>     struct kvm_pic *s =3D kvm->arch.vpic;
>
> -   if (!s->output)
> +   if (s->output)

This is the old value of s->output. wakeup is needed if you have a
0->1 transition, so what you're looking for is either

if (level)
  s->wakeup_needed =3D true;

or

if (!s->output && level)
  s->wakeup_needed =3D true;

but your version is incorrect because it would look for a 1->1
transition instead.

Thanks,

Paolo


