Return-Path: <kvm+bounces-3943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BB480ABD0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDD0C28176D
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18ACC47A5F;
	Fri,  8 Dec 2023 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWbPB2w4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F72129
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 10:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702059265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KlSM/zpPbN5WwWA6OTGpQyhIkatTXb5IjuU41HMpNgA=;
	b=hWbPB2w46QVi+7fBhCnoQEcsRXH1TisVLcKgNyaza/b9tS4pRdUxArPXAjZK3tKxMH9S3f
	72xJCVyIGCxpC1Xz4tPFy7bEFOt460NjEv0VVK/FmlKWs8JKptww/hTgiRRI7XZpOYgxCm
	Tx+LSVP/oGMz4OK9u5+9AH03v805pUM=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-gOLSkbOQMWW90fFFCht3iA-1; Fri, 08 Dec 2023 13:14:24 -0500
X-MC-Unique: gOLSkbOQMWW90fFFCht3iA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1f9fa14709dso3826254fac.3
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 10:14:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059263; x=1702664063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KlSM/zpPbN5WwWA6OTGpQyhIkatTXb5IjuU41HMpNgA=;
        b=jfXzPPa8Vt8Sl4hhHurqiTW/rwMqXFHPqo+dHNWQQujlyk51gVEugkBko3ByZkRI3/
         LF3t63Ow1svOl4UKnSdfFbO28m+Emieus8kAV9BSNzGg7+mUHTUM2Ir9Tx5mhBBdDONZ
         7mVonJrEJsu7uZkxsxl10ndqnIHEPPrzhTKJ/oAvZQSXcYdkNVK6MnjhGKwZ2Dj5Bsg/
         HEKabt4bVjdVAJH1QdnbBlVCPFEgIEsGmy4RP05OoxZlZPhHRcEHgG8ricc9o7uUbOAK
         1QC1x2mFxc+GwNB5kQNeHCCqLSqgRpNF3sAA+D+v/6SjJzUf1UX0AHyLnuUJutCjl+lk
         UmGg==
X-Gm-Message-State: AOJu0Yy898RxLNUUsjtJPu7ymdDH44intCrRx/lcSeg/BPNAm3VMUQMO
	vimXPIDi7C55eKpKwKwBk4a0ICMLgwC464UkxNzjYPkwPGfhw8ejoMAsVxFylZT9Xn2OvPll26X
	dmn1yELlXpWHLGMvGQeu0swmmrQjt
X-Received: by 2002:a05:6870:44d3:b0:1fb:19b5:407d with SMTP id t19-20020a05687044d300b001fb19b5407dmr532223oai.61.1702059263599;
        Fri, 08 Dec 2023 10:14:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7AOACg3Lf1P9LtBQJnAsa//zi6y83Gtz28lS3HGdoEbMv7ZG8U5H36GSXA/O8Y6UBe2eDB9XKjKRDH8PflPw=
X-Received: by 2002:a05:6870:44d3:b0:1fb:19b5:407d with SMTP id
 t19-20020a05687044d300b001fb19b5407dmr532218oai.61.1702059263360; Fri, 08 Dec
 2023 10:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208020734.1705867-1-seanjc@google.com>
In-Reply-To: <20231208020734.1705867-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 19:14:11 +0100
Message-ID: <CABgObfYbWUy5Bvpnr3a+atE5Pyk72jnY8ynkdw7_cJ8_7A1raQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Fixes for 6.7-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 3:07=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull a handful of fixes for 6.7-rcN (hopefully N=3D5).  These have=
 all
> been in -next for a week or so.
>
> The following changes since commit ffc253263a1375a65fa6c9f62a893e9767fbeb=
fa:
>
>   Linux 6.6 (2023-10-29 16:31:08 -1000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.7-rcN
>
> for you to fetch changes up to ef8d89033c3f1f6a64757f066b2c17e76d1189f8:
>
>   KVM: x86: Remove 'return void' expression for 'void function' (2023-12-=
01 08:14:27 -0800)

Pulled, thanks.

Paolo


