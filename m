Return-Path: <kvm+bounces-29740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 288869B0BFB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 19:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F971C232B8
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 17:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD5015444E;
	Fri, 25 Oct 2024 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUR/GHB/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975E20C313
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729878123; cv=none; b=Wo8x7H1NFVIJrbNYg2GhnI00ee+W/Kmj887x7a5/15b5DI/V2dM2elvwrHFXe9OOeieIM6+OIcG0r7ZmkTnPlp5xq/BoIS7X3dewbgHbz8oqeP+0X8u22Ej3wIMrtyD/W+aiTLYliKej0VQ4pwtsHd9rbxhehW+pFfN5qgawtuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729878123; c=relaxed/simple;
	bh=luHPkXcmkzXARAD1k+1siQ/blVliFRMh2F/pQQLu2Pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b+zsvzckxD0wkVJgxJWJSHH1eKLE+U48GfKDcsBIlqKh6yLzkqppBWySywJ9pRrwYw9gTwhip1qbz5mDCGyTPdaJjXTJoWqSJpXXx0/mDitz1/VOHV0RFqng86uMrjUA1QdITXZdkkqEUY0rXstsSXljzcz2CC7sYvpsCbF3orI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUR/GHB/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729878120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=luHPkXcmkzXARAD1k+1siQ/blVliFRMh2F/pQQLu2Pw=;
	b=DUR/GHB/zU+ENd7g+McH4suIHL5pOTJGuRu8QKQ+h7Un9UEoPuSk+jqrywXWwjDZJhA/no
	Um3Mj0+A1d7YMQc4ernvQv0RlT4B0xiOSx7Z5Cskx3DQrVpX63ono7Bk7UxENws7HH3N8Q
	wBz/grDCW1W+wVtmTOOo5d2LS5a1Hio=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-sKxD6_yoM0K5IsNslOTbFw-1; Fri, 25 Oct 2024 13:41:59 -0400
X-MC-Unique: sKxD6_yoM0K5IsNslOTbFw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d5606250aso1187803f8f.2
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 10:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729878118; x=1730482918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luHPkXcmkzXARAD1k+1siQ/blVliFRMh2F/pQQLu2Pw=;
        b=oC27+EY/B32MQQKy19m/bVYQUgQIcfGbFYuSIj92weHBtnplqWGhNTIK6yTUmyrUh6
         I09/0g6qkUrpF0RtgFjWfu6KcPmeirC6Dva5LCmp30Ykhp2NvQEjG+ZMZNJnwHxOIZf4
         YiJNsnrrGXXxRum+U3meSTJq3pOj8jWEZkZksJwOnN2MJIJ7ZLN7F4qJw0MkLdq/Q/os
         tGb0Sk7zPJ6g3KFdIPUv/dv7RtT/C4BAbrFnTB9jcecO2IRSQMNruJ3pk4DTxu3K/sLQ
         /9dHhDAWFhRm1YHH6qDbI/Nfm9psYDHMp1f8hG7jIeUmQZ/TT/h9blGDEFBltAMOmS2A
         4rRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmk+skCQa/heQrHx5/ThOspZvS+1BIRBO+k1XauLJLNCr5MS/Wxq7FDmS1E6+Swsv6Zqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQoXrWpniRRGWJoyMAx1PxvAe+faecK6uYFOr5aTaQj4GC9hTz
	Mw5RVMTJeFb1SvOaZMN5PW6ih0gPs8JFhodm1Vj7Qw83I2SbvISMWFRD63IWKBXkQSq2orpkUQ8
	Xt4S79uU5stpwkEW8oFSsI1vgD3QJyhlR9lbc1iJ9bUw8aXxKWoE7uQNIfM+ABfY9ZLGw+CSp32
	Nf9pwn6g8uCuLIGB1cEsdiHZsi
X-Received: by 2002:a5d:410d:0:b0:37d:5436:49b with SMTP id ffacd0b85a97d-3806113a07emr163667f8f.13.1729878118151;
        Fri, 25 Oct 2024 10:41:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJirsSaLOjUEz6kn7HmxOjIyhE9ZfBrB9GAGHgNcgNSBUFOeNbcRoyDDrANp8n6mxM4gCIddwEWDqpYot15qQ=
X-Received: by 2002:a5d:410d:0:b0:37d:5436:49b with SMTP id
 ffacd0b85a97d-3806113a07emr163639f8f.13.1729878117761; Fri, 25 Oct 2024
 10:41:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <CABgObfbQW-3vp=mNcR4giUGZ_gxhuRykvKj8gzBDY7pOg6xdBQ@mail.gmail.com>
 <Zxbw9XcFCHYR1Ald@google.com>
In-Reply-To: <Zxbw9XcFCHYR1Ald@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 25 Oct 2024 19:41:45 +0200
Message-ID: <CABgObfayH1x3qFjOiM=rQjxiui5tXJXObgR_qOGV5Hn_2QLEJQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/85] KVM: Stop grabbing references to PFNMAP'd pages
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024 at 2:25=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > Looks good to me, thanks and congratulations!! Should we merge it in
> > kvm/next asap?
>
> That has my vote, though I'm obvious extremely biased :-)

Your wish is my command... Merged.

Paolo


