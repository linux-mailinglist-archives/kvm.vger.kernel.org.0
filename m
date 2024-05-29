Return-Path: <kvm+bounces-18271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D288D331B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 11:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78F652875F8
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 09:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A5E16A37A;
	Wed, 29 May 2024 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="cG3RWrcA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAAC167DA9
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 09:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716975239; cv=none; b=j+Ptw22agnfYB05rmZBsYB65dcjMHn9EgpRpG/NnQSqq1QgN1H23QBhmqN+s9sfxJpg3IhZN7FHc/ppARQIqu6eniznB4oyY3Yvm23JZKuj+S/3wPVMH8Z9SNNc1ubIJThYsbBOdATliV/UyMwjJYQy2JDoVUE4/zE2Ma8AmDyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716975239; c=relaxed/simple;
	bh=l5QrRv4O9i6/p49Rq5SZv/lStE6jQlyT9WYDPbvrkcw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JooOv3T7z5L2OhpGZUKKNqF3zxBYgbVvN/w11Cg6hkeqUqjVKRFM31Aa2pNhl/VyN05h5h/tPod6rvgoCvfmSi2v2Dv+sjsYHA8iYzLm2rIEvkSEzt1mGHOREcdP7GVnP85k5qOUikt9kLD9CmbxgevaKEGJnOuNfElcbguqyEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=cG3RWrcA; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5b9776123a3so1023703eaf.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 02:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716975236; x=1717580036; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pa54c7QY45UehqcsWmO/45EGLoGqHOsodal/OABdWYY=;
        b=cG3RWrcABgDahNg8ywT7PPrRY8CYd5dqrP7erVFMYgXUZPh4LEn6MB6XGTQRA03kKP
         fnaKz5lhIymR+FUjsHehIhB6GOGIzFEDCyr54IWadeSVxp/OebtSDKc1BIidCPoKDTdY
         tKaARzM8Q/IaaP6O+74n+Zd0fStTN5IZDykofNp3ill2A2vjZZt/iUVy82YqtZyOsFvG
         JLG1mPXYNB5SAyqmtwLuwKIeOjoDnJ+bNH6eC33K1NrtJ90O8vAGFg5A8dzyCVlSqqqy
         k5Vg1eeU1pdMLfQ7H13PJRLzI7hQJKzNXCL1d2HM4iDePHS7vaAJ8ucVhK02KKxQv9tf
         08/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716975236; x=1717580036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pa54c7QY45UehqcsWmO/45EGLoGqHOsodal/OABdWYY=;
        b=lHuNB3ci5fvbahidwJqTKU9oGEYsMkdVB+ByNUluUlPiyGOZMYUF5m5j4Fl/qmHLr4
         1NCiNC/AJUjmbk3K7WDUmD/7a46iXS7m3Zp8nDxKFldzUnd7irqYoOm2t7K5NHkldpWQ
         mKnwPSmdUzsP0xE2+41tl9sRwEW1CLhDTDSlUDU2wYtGbk9b6D/kw2ghk2iyWdrk6IhZ
         agksYfdb2RH7wna166QoFo2Qs1Hlw4YcFVz1NzqMN7IZG/nbAp8kn759jsZB1gc720D7
         D3tJsVGyd8cxFrsN8E0lZnkgJN7dC2F+mnqoEU9UdwuRlr2jVeEz7apfH4Zmwes5Ex9+
         cIug==
X-Forwarded-Encrypted: i=1; AJvYcCVgHHcUjmIDLLrlGu65um4uvC9I3LioV6ykPzv8ACkntc24Xyhdr4W8kVWdejmHwYR/w8YiW3Dgmjb5Fm9t6ux/f9mq
X-Gm-Message-State: AOJu0YwIjL9Gvj9burHTlcFwXf4sVwaOg9HuHtBOs+M6NpwrAwYqJlVC
	Tb/lKfuvOXWEmMjwGvjYXCcavoQRmNwqIWeoH1jfwGAjHoDZCWQu6uaOqkrD58qQi1ZHWlVapvq
	xyKaN7J9MK3zuDnQkOPQabdMeUUgD1pN1/Gh7wg==
X-Google-Smtp-Source: AGHT+IEFckLl6SgF2ZIIsWM6r/IfyUxXDxJs1rCuhc04QaE6m5836ItC1YeowXBKeV4tdyQW4ZvMZo8zPmFUl/VM1Ec=
X-Received: by 2002:a4a:dcc4:0:b0:5b9:8dd6:3d62 with SMTP id
 006d021491bc7-5b98dd649e1mr8998720eaf.0.1716975236516; Wed, 29 May 2024
 02:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-3-yongxuan.wang@sifive.com> <20240527-widely-goatskin-bb5575541aed@spud>
In-Reply-To: <20240527-widely-goatskin-bb5575541aed@spud>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Wed, 29 May 2024 17:33:45 +0800
Message-ID: <CAMWQL2jHLVtGA3RzPG-Qp5k8qhzDttNQjkSp5X2EMYCyFWKwLA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/5] dt-bindings: riscv: Add Svadu Entry
To: Conor Dooley <conor@kernel.org>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, alex@ghiti.fr, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Conor,

On Mon, May 27, 2024 at 11:09=E2=80=AFPM Conor Dooley <conor@kernel.org> wr=
ote:
>
> On Fri, May 24, 2024 at 06:33:02PM +0800, Yong-Xuan Wang wrote:
> > Add an entry for the Svadu extension to the riscv,isa-extensions proper=
ty.
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> I'm going to un-ack this, not because you did something wrong per se,
> but because there's some discussion on the OpenSBI list about what is
> and what is not backwards compatible and how an OS should interpret
> svade and svadu:
> https://lists.infradead.org/pipermail/opensbi/2024-May/006949.html
>
> Thanks,
> Conor.
>

ok. I will remove it in the next version.

Regards,
Yong-Xuan

> > ---
> >  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/=
Documentation/devicetree/bindings/riscv/extensions.yaml
> > index 468c646247aa..598a5841920f 100644
> > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > @@ -153,6 +153,12 @@ properties:
> >              ratified at commit 3f9ed34 ("Add ability to manually trigg=
er
> >              workflow. (#2)") of riscv-time-compare.
> >
> > +        - const: svadu
> > +          description: |
> > +            The standard Svadu supervisor-level extension for hardware=
 updating
> > +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull=
 request
> > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > +
> >          - const: svinval
> >            description:
> >              The standard Svinval supervisor-level extension for fine-g=
rained
> > --
> > 2.17.1
> >

