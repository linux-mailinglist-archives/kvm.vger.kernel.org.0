Return-Path: <kvm+bounces-52890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 407E6B0A514
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF7197BDCE7
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB6E2DCBF8;
	Fri, 18 Jul 2025 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NV+TrLw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7892DC356;
	Fri, 18 Jul 2025 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752845053; cv=none; b=WVPNRM9IXL6FiZJeArIE4RJ4+TB0mn8zcbi0d7cJ4guJSorgEo5Bt0nczR7Bzfm4e2Asz93ZACyzQ1FKwCY9cc9q/8sRpBbKeCUhH/xrzfNNyoX6uaTDk59u+C0umWEy6+2Dh1NQouJk7xWMLbQeXllLe2ITvDGGijtjLwFtoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752845053; c=relaxed/simple;
	bh=mmXvmXcLDBxvPVQdU/HvC7mqfk8ZdMDK3IvrQ4Z0goM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6XkMbwheZam9SQQ5DjHSOL+4hLRYvYCLt3p04i8EiRkFcqGXSnPZ2txb4B+eL1/D3GIiqhWf++lVhoOldpMyyWMgqoj8Pt8793bXCDubERagpHEyM679eyPO653cutqipli5sYH1eAeqAmob1ea0vl8GYXUzyQNYtqYpKbcOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NV+TrLw9; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b2c2c762a89so1620824a12.0;
        Fri, 18 Jul 2025 06:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752845051; x=1753449851; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SIdcZNxkLXX6lVhiVMbF7nofIkI0LLvCluRB4BfIRhg=;
        b=NV+TrLw9y/lFUU+Iy+gxLldx+WjCdbPP9Vw6MNEgpuKbPCR23/RL+C/OYqUI2OBgDb
         nUIrsl8NhPPRCaBA/TVkI+JvI5qyXFGzGEd922zpZUz7ZrdZ5qzyzexA2361Y2ysM+0W
         aTWGjh2zcnhO3CnU6xkuzB4/FWZveHnebt3ZOeAs6JHTiuBQ5ACxatC69q29Gc4TCeaC
         tF0Kke8IGpEHBslGIabfO/2CLSq3/rlVy8JJ+e3PmL5gSwmSHbXgncQm2MqEjlh2iB0H
         RjLwWgWM73CYv5y1SLwmJ43gppkd+vkOQPdShWDz6+qs7jYioIoGO7lld163nI+9lahf
         jdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752845051; x=1753449851;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SIdcZNxkLXX6lVhiVMbF7nofIkI0LLvCluRB4BfIRhg=;
        b=MBk+VCtfd3D1K7+/KgodVzhLIJEaXuFqpuoD4DZalMNBCRHkG5funr8Wth7Cb/diUX
         Cd68VrgReOuxBLl65khhWLEt4tpXmJlhyQ/GEcTy8fWIl5cNoI+3GKatIMkq6bt+28qB
         oggOnux81Hz6Lfy+31ooK61ie5MjX5gejNE5ninPDc+XsafymRsjOk+SrI7deXfsv8Q2
         vBcAIhxczyiz61xeGJxfAyPSfe0LbyBFqLgzz4cWWjTNsyqAR3t0+NLBhdD8dAuVIE+n
         FMc8uoaU9kPZWoAyf9OfKcN8Vqrm4umyWrX2L69rc4OJJfes5i98eXoIhtQzl9GfbUjO
         e+zw==
X-Forwarded-Encrypted: i=1; AJvYcCXt3h7DSAvK1b+A5prUspHXCk2WKOFz+9EqE5UcrgeAo/70FccoMPQA5wDnXNGGrnSVlxY=@vger.kernel.org, AJvYcCXtDpleIpbD8Q1E1/usUqXUVi5kfEClapvam9xrmNtg1lc2Rx6TS88xMFCXKDp1KTSO813JuzKtvEXzzYRk@vger.kernel.org
X-Gm-Message-State: AOJu0YyvYKyOyKNFc5FiPMi937YONJvLU+XiT8XtoEbK+rTh+1nI+8rs
	RumxRG7q866oQbvMu6FYMkEboDwqt1tsm6WjFLvrxC4ezEAkrRf7P3023ViVuA==
X-Gm-Gg: ASbGncs4hvmBtDfsrhixle9Rh2+PHP4CBPyW3BpiCYy2xOJIQxcP51b04VAZoYb5u1s
	gHHWe5QbnObDo70WJ2v/WTlV6VG8xyqLThcmagXmSJoPVd2xQksVM8QsK/Y07aoLY190nSdvNji
	ocy+TCKC+EWTL01mr85Gtut+ohwdNdsCinqkjLE/6tjrLIpx8KW0li8toA40EkPtKazzp10XaG3
	FbddlpUqkYVnMUSTDhk4SgRRuAhuiQMF83/3Lg1eLsIv79gfJO+EZNjDLMWt9F+dPnkR3iCduUx
	WTVBf6hoVBeaf7IC2aV8F6i3nfcdIo8SF8SNZHhoGOMQ+JGM6VOQsxqSd2SWYQq+sRhLqiIOLAb
	AXru3SAMtThJk7eHX9ioA1w==
X-Google-Smtp-Source: AGHT+IHpxQzVKJM4x5lAMiojCihB9xUwdI4b2u+bkg1/BkqblucnbhECD3b6zMG9R/Xus802gxBybw==
X-Received: by 2002:a17:90b:1b4d:b0:2fc:3264:3666 with SMTP id 98e67ed59e1d1-31c9e799ba1mr13985557a91.30.1752845050715;
        Fri, 18 Jul 2025 06:24:10 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f2b49easm5316068a91.43.2025.07.18.06.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 06:24:09 -0700 (PDT)
Date: Fri, 18 Jul 2025 09:24:07 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] LoongArch: KVM:: simplify kvm_deliver_intr()
Message-ID: <aHpK9xMDsK7tHjT1@yury>
References: <20250716165929.22386-1-yury.norov@gmail.com>
 <20250716165929.22386-3-yury.norov@gmail.com>
 <CAAhV-H729+VA4fAWX1SOhCAptSDSwLDAOp_RwB0hkDtvm0hMLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H729+VA4fAWX1SOhCAptSDSwLDAOp_RwB0hkDtvm0hMLg@mail.gmail.com>

On Fri, Jul 18, 2025 at 12:13:46PM +0800, Huacai Chen wrote:
> Hi, Yury,
> 
> On Thu, Jul 17, 2025 at 12:59 AM Yury Norov <yury.norov@gmail.com> wrote:
> >
> > From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
> >
> > The function opencodes for_each_set_bit() macro, which makes it bulky.
> > Using the proper API makes all the housekeeping code going away.
> >
> > Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> > ---
> >  arch/loongarch/kvm/interrupt.c | 25 ++++---------------------
> >  1 file changed, 4 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
> > index 4c3f22de4b40..8462083f0301 100644
> > --- a/arch/loongarch/kvm/interrupt.c
> > +++ b/arch/loongarch/kvm/interrupt.c
> > @@ -83,28 +83,11 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
> >         unsigned long *pending = &vcpu->arch.irq_pending;
> >         unsigned long *pending_clr = &vcpu->arch.irq_clear;
> >
> > -       if (!(*pending) && !(*pending_clr))
> > -               return;
> Is it necessary to keep these two lines?

No. They duplicate the existing logic, and the new one based on
for_each_set_bit(). That's why I remove them.

Thanks,
Yury

> > -
> > -       if (*pending_clr) {
> > -               priority = __ffs(*pending_clr);
> > -               while (priority <= INT_IPI) {
> > -                       kvm_irq_clear(vcpu, priority);
> > -                       priority = find_next_bit(pending_clr,
> > -                                       BITS_PER_BYTE * sizeof(*pending_clr),
> > -                                       priority + 1);
> > -               }
> > -       }
> > +       for_each_set_bit(priority, pending_clr, INT_IPI + 1)
> > +               kvm_irq_clear(vcpu, priority);
> >
> > -       if (*pending) {
> > -               priority = __ffs(*pending);
> > -               while (priority <= INT_IPI) {
> > -                       kvm_irq_deliver(vcpu, priority);
> > -                       priority = find_next_bit(pending,
> > -                                       BITS_PER_BYTE * sizeof(*pending),
> > -                                       priority + 1);
> > -               }
> > -       }
> > +       for_each_set_bit(priority, pending, INT_IPI + 1)
> > +               kvm_irq_deliver(vcpu, priority);
> >  }
> >
> >  int kvm_pending_timer(struct kvm_vcpu *vcpu)
> > --
> > 2.43.0
> >
> >

