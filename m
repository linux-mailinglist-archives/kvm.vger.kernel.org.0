Return-Path: <kvm+bounces-22829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2939441DE
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19F2D1C20F96
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E71813C909;
	Thu,  1 Aug 2024 03:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CidlYpRH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0837647
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 03:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722482714; cv=none; b=rbgUauTqrdjxxNaQmNBd2cyf1mvaikFlnd5re0tvLnWBmd9ehepufAncWUiu59o8LS3om8mgeTHgyujPARdvqbjosr+fq/hO4Y8aueapD6bLZXjK38dosSxhe6eE3oZVyC8J2ht927xdTkqrsKDx7ObAQysmRV+727NwK+bBFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722482714; c=relaxed/simple;
	bh=GXBiP3NwlDGapsq9dd9eAohl7hgIIMWcrNmA/vson/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p6oBcSXgin/50+mDnSChogg/7L1JGUKNN6rxW2zw/Gyh4IhldGKKAWZbQnU9vaigGxLv4YoG4pPeKwhYVlD5GGsz1TJ5w3DukHi/N7T2k9zLMn/NA0TLDuYJE9bSSiudcRAnGr1QdwhRJpQo1plgA+YB3j0hEyKBhTr82HucE8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CidlYpRH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722482711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA8qtIEwBqGQojB8vR+PEMLSgLeUXkAJyI8y+mq9FA=;
	b=CidlYpRH16vBsI5EwsppOBqs3TfUcywPOdgN7Ls20a/d6lCyqEB6UM5PjMf+MXudO4NPZ8
	Sb5TnjSuF1JCkrHBLzqlpTGJUDworfyNNMrdIlw/BTDoGYwMz25rnysxPA2lajyrbhimtK
	hWBhXcRHZ/TtbHah63aaY3rFoUhP3ME=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-SFEy0C7SN9OoBKMNBkA1Uw-1; Wed, 31 Jul 2024 23:25:10 -0400
X-MC-Unique: SFEy0C7SN9OoBKMNBkA1Uw-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-665a6dd38c8so124546537b3.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722482710; x=1723087510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LIA8qtIEwBqGQojB8vR+PEMLSgLeUXkAJyI8y+mq9FA=;
        b=d5SZRd7NMjjtyWFD1j4cVqDLZ/U4vdjT3BpbUPdGa1tHqF2lHl9vJzyiHhgJngrG8F
         Ikv7Og+4YtlyO4z6PLzzVQ7v+GlLbj3dj1MOpK1IPp700I/oruGIMVYJqirwzwLND9yy
         soHGvFSKSrlgMVun1ri57sUQBscuscZ0pI6vrj/bsX9sLOWvuXKimPsQWG2Qp+G4esYe
         vr9fxBOORH7xEqn1zqmm/pNpn+WAQ/xr3ywPrImjJe2FrHOcZh8kvugC6onWF2u32Lyc
         hLwUH6s811Rxgo8yfyZvg13w0S5CGTwjvjlq/kBYma+ZdTeFQuB+iVquNVNgXGXTpv0z
         fJMw==
X-Forwarded-Encrypted: i=1; AJvYcCWnvB++Ys+HSmt7zzBemXIe45vpCSECm5MooQ5j7aSldrCDpUOVE/aFYDWYG2fTYOuj9p/6C0JHeIsskOGiJpQsDl9f
X-Gm-Message-State: AOJu0YxfEAzqRHp8/W8Uc252v7rJWzErT8RfsZjBK2WSkVidXTn2qcqX
	rtrIiOI6MLykLkbHywXZoSszaVInhOilwHccm+Af+00/Vijff8nmi1Sv+G16LV7Vlu75nZWZCCp
	W6RqtB88Bw1YPZtLyMO0r13Op626h6AZJ0Ji090/JolWCfMdPYD/d4sPPyd5ZbQafHUUtFxwIgP
	qSeAjpfOl1r5ry9Pb3l8qRw3Zn
X-Received: by 2002:a81:5b04:0:b0:66a:843c:4c38 with SMTP id 00721157ae682-687521b9560mr5159587b3.37.1722482709713;
        Wed, 31 Jul 2024 20:25:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdm8eONMfPaB0Qsap8XfUDxD67qSjsWH3V5PzSZRWN1oS7bhdQe8tBToa8XMYEsh5v+snsMPZPXHV3aL0f7zE=
X-Received: by 2002:a81:5b04:0:b0:66a:843c:4c38 with SMTP id
 00721157ae682-687521b9560mr5159337b3.37.1722482709450; Wed, 31 Jul 2024
 20:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-10-crosa@redhat.com>
 <Zqd2edn1-aNiVriv@redhat.com>
In-Reply-To: <Zqd2edn1-aNiVriv@redhat.com>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 23:24:58 -0400
Message-ID: <CA+bd_6JBpV3A_yyi_R5uELfZkf4zfKJSW9YuZd+am-guK7-QjQ@mail.gmail.com>
Subject: Re: [PATCH 09/13] tests/avocado/boot_xen.py: fetch kernel during test setUp()
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 7:01=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Fri, Jul 26, 2024 at 09:44:34AM -0400, Cleber Rosa wrote:
> > The kernel is a common blob used in all tests.  By moving it to the
> > setUp() method, the "fetch asset" plugin will recognize the kernel and
> > attempt to fetch it and cache it before the tests are started.
>
> The other tests don't call  fetch_asset() from their setUp
> method - what's different about this test that prevents the
> asset caching working ?
>

The "wizardry" of the "fetch asset" plugin limits itself to analyzing
test methods and the setUp() method.  This test currently does that in
the "fetch_guest_kernel()" method, which makes it blind to the "fetch
asset" plugin.

If there are other tests doing that (in custom methods), then a
similar change would be desirable.

Regards,
- Cleber.


