Return-Path: <kvm+bounces-59213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 227F5BAE41F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2422170A93
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AFC26CE10;
	Tue, 30 Sep 2025 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Af7a0oos"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E32526B2AD
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255136; cv=none; b=WiHbhfBMDOe50aMhpJvQZFPA511jhOc1QlrOe8d06riVPIb4IuNwPG7Ua51FWHYSYTzwAjS5E9cbqbp+nYSqCXoWEao0AjpbeU3FoOWKqyiSXN5A7tsTjZ+EtgsETX+8jlNGRUCRDoX8K68xHu3FnII95blFJhABDCCXPmKGxZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255136; c=relaxed/simple;
	bh=Nejn7Jw0qE+Kkdg0YSBfXxO/oPYC6wySV3pVzrR08nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UtGaHbuFkc4cReUiTjZCtxIIG3jxtXM2ByhgPU5q4PR2YHFUyz470xDDZ8Wx4/rfuBw6uiZ+pgk7tMRcpf4vfLfpEdEMpBTQ9WUj9NDiPyVE0Ar/IEMLpi7PD2x0LJPs827RXRFW9BF8++LdG2hWTcQMSaRl+pUZvNUa75d1S0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Af7a0oos; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759255133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8cF4VzuVf+MX0Y5TLwWhlMcsr0VxyJ6vPdjbuar+xI=;
	b=Af7a0oos1cNQqnSoBPjy6BJIbfaIqPqj4dRznlnfUXt3VA4ITYEAgwH1AThkytQZUI/p34
	sMvLewXLI5rRWt/RSt/R4KuuozVKuU/o95sT27zBytn65E/feXj1DF/rfBd8y5Qx08ExKB
	0AwC0XixIX7uBumkTcP2ZTD9vQInyoY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-qIEqfVJyN-a0x_zxNKOsdA-1; Tue, 30 Sep 2025 13:58:51 -0400
X-MC-Unique: qIEqfVJyN-a0x_zxNKOsdA-1
X-Mimecast-MFC-AGG-ID: qIEqfVJyN-a0x_zxNKOsdA_1759255130
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so39231555e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759255129; x=1759859929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F8cF4VzuVf+MX0Y5TLwWhlMcsr0VxyJ6vPdjbuar+xI=;
        b=lxpCXzT139Ar6F48UDeXwi83zk1FGXWCMzt09lmIGPTS+dElTZSeZEYAhTGoqguVbL
         FqrHUiVf8i9P5h0PTwbTMFXhE68VlUDSE9/PrLjlWShJ4FP8C5J5QOQ6LzBz6zbxZifj
         FqQAX4WeSBPR2a75CApLYXxi61RajQ2cK9Pjplzmp4TrI7ZYUG9zBsyJnDMuKiAocEOC
         bHjFaG0ex3muosJ0YhWUnFNO5gOvx0LazQLqpTK/TVXWyQdDxjih8iRRCXhce+jmsWbk
         2NUHoIJjKoIPWzH8cFz40VZSW6g4Md6dYFh3zNCOqBKPJWqa9dZfdF+eZyAU7KmsoCpw
         ixjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU206p7hbLn9YIHEWJI5ldH7YKIhwbOukIUFF4GidbdcA/r6RaJTPT3C7Nn/lEli4EQwg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfyYiTXhM6lKWP5nhvM06hVEXccXCn2Zz8zd0yy7NVtGzf0m4X
	/aauOPA0yVbfy7iJtqdBuvUCh8ct4SGlUysSQJv5RJJkhtRe70ICuaZc2WawyRe+eNofAg2SwFc
	2X5/xvo7BRtFRDXElgC9tJoCDPAS06wJhRpJYjlIkjJrqOtHtkgK39zOjmbM31gu+u+7GIcr2Q0
	Yf1qlkasTCK/W1r1SgPlFFpvpA2qiB
X-Gm-Gg: ASbGnctVzu5k3reM9JGEbMGm1L6Wvv7PTB3FVqNZ33+c0gwzFAX2ry0F0AlBhOQd6LJ
	IbQT8wFMTeDOIiieTCB6bvGf3LbbmYQc0F3wZ2Cm6uygiUihYwZ1yXSLVOiV/OJWNyqqVy8bTNG
	EuINc60Aeyq7G/cekm72v7yzGJu5amj+JXUibU75k0uwqUDziTXDXu8f2+GrR7Of88bmPt3hdQ8
	f42Lg2JmdcC0mJkQpyzO4yHDGeieSCJ
X-Received: by 2002:a05:600c:5303:b0:46e:4287:a85e with SMTP id 5b1f17b1804b1-46e612192ecmr6607325e9.13.1759255129631;
        Tue, 30 Sep 2025 10:58:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGX2ydmCLO7e7qdwMiaI77CR0x1R/qx+ietFiVLOLU40Tb+lvt9g/R/AsWRQlZ5JMQ4XFB+rlRpfSE5Yr1lgI=
X-Received: by 2002:a05:600c:5303:b0:46e:4287:a85e with SMTP id
 5b1f17b1804b1-46e612192ecmr6607135e9.13.1759255129262; Tue, 30 Sep 2025
 10:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924081305.3068787-1-chenhuacai@loongson.cn> <CABgObfZvdkAR6YGx7HKT+aVaE06w=FG7Jus=3B6nxadDiv5c_Q@mail.gmail.com>
In-Reply-To: <CABgObfZvdkAR6YGx7HKT+aVaE06w=FG7Jus=3B6nxadDiv5c_Q@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:58:37 +0200
X-Gm-Features: AS18NWCD5Cu1BM-gCbaA5ScKHErZkLAW39Qw6t4H90yeM5txDIxnZuzOmIqqkbo
Message-ID: <CABgObfaPEMTGYSSZp_5S8J67+=GdkxmwNuRMHVfV37iCQex7bg@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.18
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 7:16=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Wed, Sep 24, 2025 at 10:15=E2=80=AFAM Huacai Chen <chenhuacai@loongson=
.cn> wrote:
> >
> > The following changes since commit 07e27ad16399afcd693be20211b0dfae63e0=
615f:
> >
> >   Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git tags/loongarch-kvm-6.18
> >
> > for you to fetch changes up to 66e2d96b1c5875122bfb94239989d832ccf51477=
:
> >
> >   LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code (2025-0=
9-23 23:37:26 +0800)
>
> Pulled, thanks.

Forgot to mention, please pick one between chenhuacai@loongson.cn and
chenhuacai@kernel.org and use it for both the committer and the
Signed-off-by line. :)

Paolo


