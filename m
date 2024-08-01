Return-Path: <kvm+bounces-22831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 316DA9441F4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55DF41C2187D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849B313C818;
	Thu,  1 Aug 2024 03:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zh3uhhOd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4081EB4A0
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 03:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722483592; cv=none; b=MBL70luj3Z3frP2PV2m1zhEZLaCeezf8oKk8XIT+Us0oaQ2prY5ufTV3w4EKzF9ZzrP59YP3vFQiVUD03TBzRIWilY8Drf1q8IU+sfVe8/bzg7uT26hEmglvZpADre8FlvmbsJGnS00z/yLjg5elzh+RIGIz1LB+LwgoHpL2ZLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722483592; c=relaxed/simple;
	bh=vWtCZxxAAPO6zJnXDAJSgm3vET+YUexDNg/707VMj5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqylI0FM5NgUrECK8APlZsl/9RnbkpPinK2I7+5qDOsBHl7YWVvZo8X4mueFOmT/lLx0ajBZxjxgNG1e8mzRS9ufIjX62MGDyPIbEBQ+GG9fy56n7rZfQ/XoGbAmhCVX/ZKk4Hiyw42Ly2roshvtrMflz81629rprE8YTD+HbHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zh3uhhOd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722483589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a9W2VRIIGErciPW7gZomIT9/wCLlvJpDwZh2b3ecZfw=;
	b=Zh3uhhOd9/s5i20Prnd+UkjoqOTjCNpj//kECTRFyhVPjn95NkigSnhH70uc5abPA6z5OC
	iihXlLCgxpZ07dQq9QMf/PJj1tcZEsgt7Knnn5qnmDPis5HyyrKfKL8D9lDCFaaMo4dQQl
	L7ZovpjOrpyTQEG5Fac8mfJHYhptDaU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-vXZG02OFOqitr8q6pae5cQ-1; Wed, 31 Jul 2024 23:39:48 -0400
X-MC-Unique: vXZG02OFOqitr8q6pae5cQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-650b621f4cdso118891047b3.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722483587; x=1723088387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9W2VRIIGErciPW7gZomIT9/wCLlvJpDwZh2b3ecZfw=;
        b=WjKIGAL64Zw0ROCUfj5vom/qlo7H9euYif7kVFF5esBLwwVCZ9cpaNFXiyQkGvULXd
         Shfso2tnK4qRc/BEcK7XbcgKqdBPoc+Nlts6ez4E16eaCWh96rn7YOQu/yfVXnZatfqa
         xFIuknjx22NcdHVFhxDxYNzCkwN9+gQ9zdaNadr+6eE1osM41qZwGO6wlLQj832MoH1e
         HKdwm6yqH6t+QuOHvNVHtMiBJXDPJ9BeamDkaOjzlsnsF2fFvttDwyMwcbLtPn9xX3Np
         /4HnsoYX6ZrECxnZs3u/Yi2UtjJkfn1Npe4qdAtc0pB95sJEnU73GlHGtKhCbMa5cdvf
         57Fg==
X-Forwarded-Encrypted: i=1; AJvYcCUayYdsCxHN0v4q6UXdXKBXecGda4KRyHwLyB/1os8R2jDdaYHkjZY1SArEVWiR1+VQCI7uhbqqVM923eac+sGqYeZs
X-Gm-Message-State: AOJu0Yz8arEYe1TxNGX/iiR3Qm3ss2p/uHb7KaMdHcrk9i7snNc+DB+r
	nQm+AF58AqR8D+Znn5y2pCdd3YneJkxF50aMKIZFYBAG9qWV21mXz8A1TvLWrT+rJimojGghF0j
	bEqP2siSDCsT26SVwP0t/VsiC4CB5V5bVq2mC99W2n1f2xzWFm/22N89iVFY2h0WKm7S5fNGauu
	4brIVYVtUyY4K0pnm1RAF5Y/rU
X-Received: by 2002:a0d:dc81:0:b0:65f:8218:8b2f with SMTP id 00721157ae682-6874f605a38mr12027997b3.43.1722483587798;
        Wed, 31 Jul 2024 20:39:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLNXMjkzKFeq0Hkwcz0rr8sBTxEfS/YnzcIywxu4UXEdTXHUdyXidwbCMQ4MFl7YAW13Q/2xD4unAf0lbN7CQ=
X-Received: by 2002:a0d:dc81:0:b0:65f:8218:8b2f with SMTP id
 00721157ae682-6874f605a38mr12027747b3.43.1722483587507; Wed, 31 Jul 2024
 20:39:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-11-crosa@redhat.com>
 <a7f2d78a-4de6-4bc6-9d54-ee646a9001fe@linaro.org>
In-Reply-To: <a7f2d78a-4de6-4bc6-9d54-ee646a9001fe@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 23:39:36 -0400
Message-ID: <CA+bd_6L7o05mENKVuLLfMFK9OF6ckU23ue0xmxiWO5oiT4ZEbw@mail.gmail.com>
Subject: Re: [PATCH 10/13] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 10:39=E2=80=AFAM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 26/7/24 15:44, Cleber Rosa wrote:
> > Signed-off-by: Cleber Rosa <crosa@redhat.com>
> > ---
> >   tests/avocado/tuxrun_baselines.py | 16 ++++++----------
> >   1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > diff --git a/tests/avocado/tuxrun_baselines.py b/tests/avocado/tuxrun_b=
aselines.py
> > index 736e4aa289..bd02e88ed6 100644
> > --- a/tests/avocado/tuxrun_baselines.py
> > +++ b/tests/avocado/tuxrun_baselines.py
> > @@ -17,6 +17,7 @@
> >   from avocado_qemu import QemuSystemTest
> >   from avocado_qemu import exec_command, exec_command_and_wait_for_patt=
ern
> >   from avocado_qemu import wait_for_console_pattern
> > +from avocado.utils import archive
> >   from avocado.utils import process
> >   from avocado.utils.path import find_command
> >
> > @@ -40,17 +41,12 @@ def get_tag(self, tagname, default=3DNone):
> >
> >           return default
> >
> > +    @skipUnless(archive._probe_zstd_cmd(),
>
> _probe_zstd_cmd() isn't public AFAICT, but more importantly
> this doesn't work because this method has been added in v101.0.
>

While it's not the best practice to use private functions, I just
couldn't accept rewriting that for the skip condition.  I can make
sure future  versions (including 103.1) make it public.

Also, these patches count on the bump to 103.0 indeed.


