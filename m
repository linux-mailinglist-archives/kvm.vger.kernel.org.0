Return-Path: <kvm+bounces-17269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026348C354F
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 09:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 915AD281BEC
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 07:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3F111CA9;
	Sun, 12 May 2024 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STmaAlEA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C6FC0C
	for <kvm@vger.kernel.org>; Sun, 12 May 2024 07:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498589; cv=none; b=j0gGo4Xopr3RNTGKzSwZ8FG75B6CjpOXYgI8eGJXcAH/ObW+0dzRu/8f/iYHJGJMFALcIabkMVw/h/0NQdCBeSm4nMlgHxI775IP7P9q/H6s2NYul45eNAt5uKPjqIpsg3AJOYhM/UhOC3nEJ/GHB0i2JsVgb3rNzYi7fS0XCIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498589; c=relaxed/simple;
	bh=SjhuRfJMuyO7GM96jJNtrPoACgPadZ8CofQaX4mKANM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iToV3Rcv3kmgBCBmPj3gx1lHHIdoo+TOx7fEVm3hwtqjfEuj6Jee+tX09qP4kQA3k2vnDOELgLuP9L8vsXHHLmeDl5vKfi4QWHpEseTmHzdShVYFDNIJxy4UTetGa6UeNEALS8UDtuI+u4C34CEOK8qMtZ9PnGi4suOaCXTTfBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STmaAlEA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715498587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjhuRfJMuyO7GM96jJNtrPoACgPadZ8CofQaX4mKANM=;
	b=STmaAlEACpkE3R4151vokOW+8Dblj10DlSjagYbMOw5GYIK/PLY1WgBAvHA31rur2X42tW
	WF6fGBTeNZRaEn1sY6OTyGbtRyzEjij31JD1iAg3yeUGO3XeWpUi8Fv2oj+ZYpJ9dOkL6t
	qqC3X+0m5wwx55HcDEmOabByIw5wtSU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-T3xjzF03OFCb8lphFkXpkQ-1; Sun, 12 May 2024 03:19:31 -0400
X-MC-Unique: T3xjzF03OFCb8lphFkXpkQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-51fa2c23f62so3107148e87.1
        for <kvm@vger.kernel.org>; Sun, 12 May 2024 00:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715498369; x=1716103169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjhuRfJMuyO7GM96jJNtrPoACgPadZ8CofQaX4mKANM=;
        b=Y2x9cZ6kFpnU3GXiNJdXWxXJ2IVZ8huA+xkilGVX1oVbCC+6cVSvLVKHUy4N6KJA8/
         wADkDnXTvd+c1CtJ3O8itpnaaQIuDtEuzrqUU6z6hkIa6r6dpEai9pbHqCgOFuflw3VU
         0Ra1uAU7ZOYSMi3pC/mNsbQWgAlydkiY15mkgrC3XDv2DXCURfbcxwqPuWdckQAzjAO9
         s3SYhyGvVqxluiAapEuWELoEGIBcUEVHxl3vvDObXRdsiLgWC2SATOcX8h0Kz6oVsOiI
         KR+0YE8lrDGGEyRRwe+W9czoZUuzfJquqvR31cJnMVHziiX5EicbgxQGot3iFU3M4hqG
         0sVA==
X-Gm-Message-State: AOJu0Yyhv+yzxB10jeTwOOEXmeDZ/ZzqMxWQt3tgURT2s5CPpd2Uaz1l
	E4ib/CquqvyC+OsjxzGlPSPX4r9v+zBkYPUf/HQN0aRPs2LBKA4SMNKmYQ77PrrMD5Qji6u82j+
	Ce3z5uMBnI/lBrntnY9vMc6iWpaY18brRtQ6TftEkZZN4SPjoFHnPEM9I1BA/QMkKJ4+r6sziVp
	QA/mJnZ/rzNjl4WxPArpUFEXhdxXg+vg5b
X-Received: by 2002:a19:770b:0:b0:51e:f8ae:db35 with SMTP id 2adb3069b0e04-5220fe798b9mr4043006e87.43.1715498368834;
        Sun, 12 May 2024 00:19:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzsEg1aJ25kKXmalZ4iS95ClJKdZVZF8uHKMumVpfk3l28kpvTcd6c9CIHX58M/zdIrqZBVfHzmNsuYtTNFMA=
X-Received: by 2002:a19:770b:0:b0:51e:f8ae:db35 with SMTP id
 2adb3069b0e04-5220fe798b9mr4043000e87.43.1715498368440; Sun, 12 May 2024
 00:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510235055.2811352-1-seanjc@google.com>
In-Reply-To: <20240510235055.2811352-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 12 May 2024 09:19:17 +0200
Message-ID: <CABgObfauP2zPdhK65uVJb92kwp7TBve_8n7AE2Hhe9sQf+iNZw@mail.gmail.com>
Subject: Re: KVM: x86 pull requests for 6.10
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 11, 2024 at 1:51=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Nothing notable to say here, this mail exits purely to be the parent.

Pulled all of them, thanks.

Paolo


