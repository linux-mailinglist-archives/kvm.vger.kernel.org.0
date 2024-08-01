Return-Path: <kvm+bounces-22826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE3C943FD8
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E26391C22DD0
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 01:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F267A12E1DB;
	Thu,  1 Aug 2024 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K67U6rB8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7D91CFB6
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 01:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722474173; cv=none; b=NiRuu1Vv9hYfMwJAgEjur64Icst1HNIZakJ9OAzSwT+W6dUclpXKe5aM8BnumDEOUpZB4rTOAgZCptJ/puLPlLNUEPabisfNTqV0Oc6p/4PALFNXF0RIFbUt9cjQ48vT82gHPB2pijfX/xm9s3BOr31I4HlaRqhNNDWsKtw4JtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722474173; c=relaxed/simple;
	bh=trfOjqROMQExmdAYqvVqzCEWjlvRDVsttppf2bDr/Uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KWGKP59324uZYJk9fPA7ugZLSB/v0kCS4p27ZyHU7/Ian2nqt2RX2cvxWUE27lScY/6D8p69KAZBf9o0PD4JuNR+q+Pb+j9qpYYPyNOBWZxOJpkDThvf2+tz0Efgzooq2WhNp+yhN9/XRCmv4gUPFmMgO+6IaIv/BPdXQVc68u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K67U6rB8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722474169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2EPtgXVG1DmXN8mUPqzXK4hPCx8jDKiZuZxR6dbrnTQ=;
	b=K67U6rB8qJl5o215w6zBP53N78+ecuQTEfIsQt/3PKBtmQFBc1X76wpZGgayD2sSAmIi+/
	luTSnAxP5MM4+QeGzpeflLHmpj3uahsmLpEfnijqfrpZp+I7YHSag+WxPhTqmFpw+9rwX5
	VYPtidLgDQ8mzdhzAOktMTkUG3y8fZ8=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-B6U0GAdJO4GqUKcmqOId0g-1; Wed, 31 Jul 2024 21:02:48 -0400
X-MC-Unique: B6U0GAdJO4GqUKcmqOId0g-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-6688c44060fso128546207b3.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 18:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722474168; x=1723078968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EPtgXVG1DmXN8mUPqzXK4hPCx8jDKiZuZxR6dbrnTQ=;
        b=lUmprxCPdKtllfa5UtkEBTRUDdH/TkTos3ubbjCvVjZzr0YSBJCsLJOi/JynjlPIr4
         FyLyPN8/8GjyS0edGHcDmQHg38bdY4EJszGYIoMaAK10vnetWyqN10mdxZmUC6pCKh2U
         NkvZkNScwtQjDvZBIOuKSHSFpxhx4+K39sijwhEk3kRX3Z9hGpyA4cdxbcGnbu1ieZDh
         jSCrDFtL/WhDuqZkcfSqlVLVvo7Qah0vVAr7P88+Y1fAbLK23FoFs8DYYUhFZsFaa/op
         JI+x9D25GjZ/PR42mWzcWlLn/PsHTlQMhj45B2IU7YUpxcxldSXrwfp/94oP7ReIqHMA
         0Jtw==
X-Forwarded-Encrypted: i=1; AJvYcCVVJea+++T8reTo6MrfABMLDpPc6uYHC8vtQO6zOTiiwGa/i8DhDkv3OunVX2oF+MwR7tgo1C2iZe2GXt4JQ2xKzIjC
X-Gm-Message-State: AOJu0Yz8LRMffDE7uZurv8Syv6IgU0Z4hFFHfFNkkFRU2PNRm4Ps4+Kf
	ihQPoX3pN4ZLJCeb6hlK1yuZTiibfYa0fAdfWrr13uXcq2fyNoB9iP25EUDJ1sM77/by8DnB6B5
	0N11fA3CmjdKBrgvuXMEBitlMSzYDZrmbR+NS9YJE3PdhHw0XuJrXAP+zqtmnGG44vIpJb98E/d
	zt7tFEcOJAZJt4bl3cru/7qT8D
X-Received: by 2002:a0d:d2c2:0:b0:65f:7cee:43b with SMTP id 00721157ae682-6874c831fd1mr1432647b3.19.1722474167827;
        Wed, 31 Jul 2024 18:02:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkc15aDKVHH3uOKMYYIWFcMJ5yGLicXXFfZd+KYx38Ns7DB7mfW6sSOPgdc+j5g3qEXTbXjO95vBc0SsuX67E=
X-Received: by 2002:a0d:d2c2:0:b0:65f:7cee:43b with SMTP id
 00721157ae682-6874c831fd1mr1432307b3.19.1722474167551; Wed, 31 Jul 2024
 18:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-4-crosa@redhat.com>
 <ZqdvR3UFBCAu8wiI@redhat.com>
In-Reply-To: <ZqdvR3UFBCAu8wiI@redhat.com>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 21:02:36 -0400
Message-ID: <CA+bd_6Lepg=uXs1NViYV5eZBGot2ZRAYUi-NDXwSBsdBk17LPA@mail.gmail.com>
Subject: Re: [PATCH 03/13] tests/avocado/intel_iommu.py: increase timeout
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>
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

On Mon, Jul 29, 2024 at 6:30=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Fri, Jul 26, 2024 at 09:44:28AM -0400, Cleber Rosa wrote:
> > Based on many runs, the average run time for these 4 tests is around
> > 250 seconds, with 320 seconds being the ceiling.  In any way, the
> > default 120 seconds timeout is inappropriate in my experience.
> > Let's increase the timeout so these tests get a chance to completion.
>
> A high watermark of over 5 minutes is pretty long for a test.
>

I agree.

> Looking at the test I see it runs
>
>    self.ssh_command('dnf -y install numactl-devel')
>
> but then never actually uses the installed package.
>
> I expect that most of the wallclock time here is coming from having
> dnf download all the repodata, 4 times over.
>

Exactly.

> If the intention was to test networking, then replace this with
> something that doesn't have to download 100's of MB of data, then
> see what kind of running time we get before increasing any timeout.
>
>

I was trying not to get in the way of the original test writer.

Eric,

Are you OK with replacing this command for a simpler file transfer?
Any suggestions?

Regards,
- Cleber.


