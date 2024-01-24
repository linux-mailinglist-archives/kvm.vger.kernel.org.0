Return-Path: <kvm+bounces-6847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 302EF83AF0D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5BD81F21360
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D047E78F;
	Wed, 24 Jan 2024 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+Qpv4s+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD887E76D;
	Wed, 24 Jan 2024 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115782; cv=none; b=kG41VGOvogts2SEAF5qb0wEM08ncXba4q1JA/etyZgAXRB1faM2NPM5Lp1j2GCMmNGV2GmiK5DX3DOhGuucjgyYYwIlw8LP7c+3rb3EJiuOqSKEIF9Ndo5GBXRLB/wLUszy29Vpc4lZFFxwJhpHMSQbKcbpmMmVg30EioWBbPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115782; c=relaxed/simple;
	bh=R38dR4MQyuR1txvccH1LWaFn1VVJMCDJwuazqCZJ7Vg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ql4gOgncX7CxpzYkzPojt68WgtTQnRfXmf/lVUm9P+huM14FVOuaUi7NywhzHkQPyyuyLmf+goFHS+BFZpS3S3zH8IHYHQwtjsyuvVrfLes+SCt0dbb6U8pTOthoMbLbLM6Dz2PKubSxvaoivB9q0OdAIZgJM6kCf3DrA4ANYbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+Qpv4s+; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6dd7b525cd6so1588641b3a.2;
        Wed, 24 Jan 2024 09:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706115780; x=1706720580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6JwMgDweZYejySMnkRfBGOCwhQQ8zuB1aX2MpP5io2I=;
        b=J+Qpv4s+2g3LjFHGknhPNKBgP9r5k9+lIvANLo2G0wCycs2g0dYmdBh5lEgq8jtXVF
         uLfLk5CCEr5rfPiq+0PKw21kunhmgTsWaeXi/qv4GyRTwCZOTQyWEHDSlxbYdpjTJCHr
         QkNKDO73Rn4mEstN/jyjlLUTgvc639zw87FfTjIqlydEt/XnpgFnRbZ+TgK1o+nTmTWw
         UfDbXz2iZp1nGnrOoZpM1rC2wMpaPnHRy20AaIxLbs3OcAoWXxVQboU9H28rwhwq/J6/
         zWMeaehETnsdobrr23P7pRi0LZAqc25NvwhqpbJFCejNFjOo2NFEuH8Z5qWJUpIhxeug
         VmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706115780; x=1706720580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6JwMgDweZYejySMnkRfBGOCwhQQ8zuB1aX2MpP5io2I=;
        b=GwtUWlx43AXTSu0Fj5f4byLP8gyv54QkOMfkFQHcuRCxqAwGbs1LSQz0O0szoeVfjs
         WUL/C3vbAshP6GeGBBBAK86f0Zzyc/ErxOyKNSJtNTeV6R9XrE9jita2FamwoHQPo860
         MU5f5WJSgLmumzcCuvvJ1ypNlznx4ovuRTZ/Cq1kORXuvLlSEr6PTdHCp+FRlV7h7SnR
         OFwfhB/HMwppdTkQBZl9AyxYrjzaR/WsYm7LaA+3xweuZxMh9ajp4idblJq2/Nq7Oadn
         aNy4/3kRM2KRBRii4A2Nlgvv3vUWbUEaiutz42upXMCbF2pbk6VyvTgLt7JafJr0I+Go
         jQpw==
X-Gm-Message-State: AOJu0YxCRVE1YNlY4xT+do7BnUcZzF6dmP25VV9ks+lZ22s6MgX0A0z0
	3rJS+6zGJA0XbxU9VTrJLekLcgpKZm6cwdo5zQ9XKwIKqbTHeAK6
X-Google-Smtp-Source: AGHT+IGKROj+Zo82c0TZfWf/0QNfpFmDncoPMVAhwkvFyahTHEXxoFPkaf5QQqYYh38qW2tS+Jecfg==
X-Received: by 2002:a62:6544:0:b0:6d9:8f4f:5526 with SMTP id z65-20020a626544000000b006d98f4f5526mr4306348pfb.36.1706115780307;
        Wed, 24 Jan 2024 09:03:00 -0800 (PST)
Received: from localhost.localdomain ([117.177.61.99])
        by smtp.gmail.com with ESMTPSA id fd30-20020a056a002e9e00b006d9c0dd1b26sm14408014pfb.15.2024.01.24.09.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 09:02:59 -0800 (PST)
From: moehanabi <moehanabichan@gmail.com>
X-Google-Original-From: moehanabi <moehanabichan@outlook.com>
To: seanjc@google.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	moehanabichan@gmail.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
Date: Thu, 25 Jan 2024 01:02:43 +0800
Message-Id: <20240124170243.93-1-moehanabichan@outlook.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZbE7kd9W8csPRjvU@google.com>
References: <ZbE7kd9W8csPRjvU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> > KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> > support via KVM_CREATE_IRQCHIP.
> > 
> > Without this check, I can create PIT first and enable irqchip-split
> > then, which may cause the PIT invalid because of lacking of in-kernel
> > PIC to inject the interrupt.
> 
> Does this cause actual problems beyond the PIT not working for the guest?  E.g.
> does it put the host kernel at risk?  If the only problem is that the PIT doesn't
> work as expected, I'm tempted to tweak the docs to say that KVM's PIT emulation
> won't work without an in-kernel I/O APIC.  Rejecting the ioctl could theoertically
> break misconfigured setups that happen to work, e.g. because the guest never uses
> the PIT.

I don't think it will put the host kernel at risk. But that's exactly what
kvmtool does: it creates in-kernel PIT first and set KVM_CREATE_IRQCHIP then.
I found this problem because I was working on implementing a userspace PIC
and PIT in kvmtool. As I planned, I'm going to commit a related patch to 
kvmtool if this patch will be applied.

> > Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 27e23714e960..3edc8478310f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> >  		r = -EEXIST;
> >  		if (kvm->arch.vpit)
> >  			goto create_pit_unlock;
> > +		if (!pic_in_kernel(kvm))
> > +			goto create_pit_unlock;
> 
> -EEXIST is not an appropriate errno.

Which errno do you think is better?

> >  		r = -ENOMEM;
> >  		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
> >  		if (kvm->arch.vpit)
> > -- 
> > 2.39.3
> > 

