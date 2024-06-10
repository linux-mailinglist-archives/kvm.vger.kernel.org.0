Return-Path: <kvm+bounces-19164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F47901E16
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 11:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21C54283563
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 09:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A537580D;
	Mon, 10 Jun 2024 09:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IbWg1Wkk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2856D745E7
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 09:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718011442; cv=none; b=N6JAWoJ51INGS1M2QLBYuMtvij9e6IO7oZuCYMOc8+1ZmtFXDwJ45M4vuljJLF8vIvpiHiQqaWSp9aib0lFpamxbN8CepPFO3/xyX1wHtyR11MrJMeMaZmm7ltkeM8LM+Mm0pdhxCxbPLDRza1x4hfueU3lLtK23cvoUSI1eSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718011442; c=relaxed/simple;
	bh=nBZ9dF+0OABWdV1iqoE6bc8ju4Dqou9rPp9kvXoJsYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rSr4NBJ0BdW5Jsw7OYHRxekIeCIKVew5EUjKtML7T0YrVRMxr64LCRJMVcF8djDAxsAVFG/j604WUoNJIjMBsLEn33FiTlMXftQnDIeapC3ZRdlOghIN4x67YhrhqbnPX7QDik28ACZJ189Xk77DxGmXR9DhQ4YyTsTllg/bqAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IbWg1Wkk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718011440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBZ9dF+0OABWdV1iqoE6bc8ju4Dqou9rPp9kvXoJsYU=;
	b=IbWg1WkkljKQLcpEj92QZcrRKANyNd7trmM3NwAHUfuwg3Mm918IJn2tFKkXAAomWsP6h8
	zxFzmq9yxLXfVQ8NNMEdAyZD7NuaM28olIDUmvqEYcFvYfr5pcQgpvjb2R4kHzAANJb7M5
	76AfaDYFEZFBtZ03WAcpULu6pYhpcFc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-XXKpyAo4Mb6UW_zpkMbMlQ-1; Mon, 10 Jun 2024 05:23:58 -0400
X-MC-Unique: XXKpyAo4Mb6UW_zpkMbMlQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-358f9dffbedso2469411f8f.3
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 02:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718011437; x=1718616237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nBZ9dF+0OABWdV1iqoE6bc8ju4Dqou9rPp9kvXoJsYU=;
        b=YyEfb9JcN9Xk+NgWg+AA4fvBdhvKM5usmcA4q/vzjsNgx83MlSn79bt9r1F3Eszap8
         dTEOZgGcnQ5SzwBrKj6i8ivAzqBHZRFLSa75UmEDRvDbnxasiWc0Sgvq7Ou429b59/ju
         6TIlLWzoudI5nAWcw2XXLaxSZ4zZlG+E10oG0tJ1GAIiH6MlaLfEk5J+4jzwoMSKqde5
         QkKU2c0gl49xzwlb+3ADnXo0MA6prnPYsCxE4VToF98FkK3BERqr01jT2sz7Xax+29b7
         TyTWvjE57v3seDLeklz0A5BIsGzpf47yuGqS6aZduwvuHYGW4cFKiLT8S/HJUm1nh93m
         YCdA==
X-Forwarded-Encrypted: i=1; AJvYcCWEQXA3n7yhfnU7oYrYjsE8QGmnq3UlGbEdf+EarDn6er1n22ADJEExzEFeUo7QqSzSjFjSzdaA/tsMVyKSc7lRL3D1
X-Gm-Message-State: AOJu0YyfeN/cqmLudvQ93D7DjMybE36HsZALDa50nq8elfeuwoLEvr0w
	Zj6/45pMCI6PPK7kqu23Zm/QtjsUzQ8lK/UDqa6zpXI/5KOxU9zlFcJ/x2l8DeqRzwizsPmECH5
	QMAdVKDqQn9S8Tb0MJmsgJShLl3j/Ds1N8auqXY5aXu+xcplH75IOoQRB9qVI18Om0MosgcoYPA
	B7gnDkBoYzth8bmbmmSrqYu4tk
X-Received: by 2002:a05:6000:b0b:b0:35f:20e6:43b7 with SMTP id ffacd0b85a97d-35f20e64490mr3111352f8f.46.1718011437383;
        Mon, 10 Jun 2024 02:23:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnD4OricjHIzeZrQUhiUfQSyNi2612qbHoQWqNdACOC0oufkWPT8VkmnBnvIprzUGJFTPIyjwrWV8EUkAWz2I=
X-Received: by 2002:a05:6000:b0b:b0:35f:20e6:43b7 with SMTP id
 ffacd0b85a97d-35f20e64490mr3111338f8f.46.1718011437042; Mon, 10 Jun 2024
 02:23:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-10-rick.p.edgecombe@intel.com> <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
 <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
 <CABgObfb1L4SLGLOPwUKTBusN9bVKACJp7cyvgL8LPhGz0QTNAA@mail.gmail.com> <9c5f7aae312325c0e880baf411f956d4cce3c6d1.camel@intel.com>
In-Reply-To: <9c5f7aae312325c0e880baf411f956d4cce3c6d1.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 10 Jun 2024 11:23:43 +0200
Message-ID: <CABgObfYd4TWq4ObUzkDruj_e111cTniWtXckzB_Ft7SOdv7YMQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 2:09=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> Agreed that this is less TDX specific and it means that this part of the =
generic
> MMU code doesn't need to know that the mirror/direct matches to private v=
s
> shared. I don't love that it has such a complicated conditional for the n=
ormal
> VM case, though. Just for readability.
>
> The previous versions checked kvm_gfn_shared_mask() more readily in vario=
us open
> coded spots. In this v2 we tried to reduce this and instead always rely o=
n
> the "private" concept to switch between the roots in the generic code. I =
think
> it's arguably a little easier to understand if we stick to a single way o=
f
> deciding which root to use.

But there isn't any other place that relies on is_private, right? So...

> But I don't feel like any of these solutions discussed is perfectly clean=
. So
> I'm ok taking the benefits you prefer. I guess doing bitwise operations w=
hen
> possible is kind of the KVM way, haha. :)

... while I'm definitely guilty of that, :) it does seem the cleanest
option to use fault->addr to go from struct kvm_page_fault to the kind
of root.

If you prefer, you can introduce a bool kvm_is_addr_direct(struct kvm
*kvm, gpa_t gpa), and use it here as kvm_is_addr_direct(kvm,
fault->addr). Maybe that's the best of both worlds.

Paolo


