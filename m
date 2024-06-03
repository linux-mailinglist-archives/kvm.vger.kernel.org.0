Return-Path: <kvm+bounces-18616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6788D7F86
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCF34B24EF3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95576F2F2;
	Mon,  3 Jun 2024 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvNl8jz/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA66E619
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717408611; cv=none; b=TfTyy4JUZD/K5LckkwyzKFxVIn4QGapVh5wuMB4dauOP9GX3dS6lXtkCRV7pgqLwKu6VQ4FIrixFId3T4KZv8PUwwLD9nxmqbcXbkTeHF4BNRubwVgK0wwLDA0jvuUPwN6EWsC5BwnPia4KlFH2lwmvH/QI4jU6rO3YvM4MxVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717408611; c=relaxed/simple;
	bh=yIC/Ldvt2IR4jAvfUi1RxadFaqS61O1fsshvomRkKOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qtrDffwzPNQUJe+nEH1mkmaAaEqjX8uDr7TVQ1xInapREPVM4T0+i5nzbTn4i09BHXufm0fhmIx6q1Is27rs552ddvoxa2/IHgU4NMl8Et+tBD2TrZGdkSRVZ2XcexwjZeimEr1mfUd3/H7e8jt0c9SrTGBuvS6x6m3ZcuK5WUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gvNl8jz/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717408608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6j4B8RTqm/h0LZmOaZ2lZMKsTQvKQaZNoZcsl+dutdc=;
	b=gvNl8jz/oRrKfY3+eslKmfhxBjcLCK9xM9F+dwAC2Zs6NzwRHEGK70vLNDKFcyTQvtwuow
	JcCVcN+tAbAhiQ6zoduFB6wb4If1KU2Xo1w6O+x2JqlBeMDiy1mk5MKtIftfbigU/DzUDm
	pSVkLFO5Hkstkw1Qhjpkj92v1hCIXF8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-LOWViqGoM624uT83Xzirxg-1; Mon, 03 Jun 2024 05:56:46 -0400
X-MC-Unique: LOWViqGoM624uT83Xzirxg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dc060e68aso2484977f8f.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717408604; x=1718013404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6j4B8RTqm/h0LZmOaZ2lZMKsTQvKQaZNoZcsl+dutdc=;
        b=wMg/KNflQMmOO7hERs3YKazy3VXtCqKDGgw2aQshCnwqSOaJo7U1504of3mpZ75Bo9
         VLHS76Ex+z1EhEOEJ2FJt/pQzyPEcXb55NsHlV5Fl5Ns3KjGHO6+jBv9PimIXMqDOird
         kAgTqxdIM8k2Q6A0cvg+zMyRqEyK46IviB3Tm+viWeEcvtpAocnEG5ivLgSOWAEXccse
         tYoShJE1sycbCLpJ3FS9S1STVdmyznlEVYU0eXL6s6+grITBQRrlU04MKOTvJ+XIYRvv
         sbd4LLfJBlDZB5fy+UvrVImB4gMgQe9U4jAqODIe4CFAifsh+VqtAEtEey7hH0JwPlAs
         J8Lg==
X-Forwarded-Encrypted: i=1; AJvYcCX+4HJY6Diuz2LUvw8sjZC0s5T/g18qQt9SDvMPe2hvGWYGu92MzNQkmi8FI3uKf2F27YHpDDDlAQLJehPMlwXggIeK
X-Gm-Message-State: AOJu0YyzwVUsv32VDFkJMo35olVvRnh3IUqL0SmPaAdpcBin0WgKI7QB
	f++TxSvSbAuPchXUp8+F8q1Jnz/abYx60dJh78E0Ls1HuZimxj1O16XiO630hVG5AP5qnVBv3Lu
	yLjFLw4eqZgxoIrVYGVZU4BIU4o3NNG2jhcCEDEUZKTiWtWMPvhu0Irf7g4V5hIoTUxaQ29mIaL
	YJUV2hMoej7KXS8c2wSYfsJMwbIE251jmM
X-Received: by 2002:adf:b306:0:b0:35d:ce01:7957 with SMTP id ffacd0b85a97d-35e0f32e2a0mr6382562f8f.66.1717408604582;
        Mon, 03 Jun 2024 02:56:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH96Ar6w0zSkf/w/wCqV0SCBzi+9iqoZ88rQlP1wPos45/GL7H/VL/pmrU2ZRWmBGYVRIRkA9gaZDQt0FCWhbU=
X-Received: by 2002:adf:b306:0:b0:35d:ce01:7957 with SMTP id
 ffacd0b85a97d-35e0f32e2a0mr6382543f8f.66.1717408604258; Mon, 03 Jun 2024
 02:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <11311ff6-9214-4ead-91f9-c114b6aaf5c6@redhat.com> <CABgObfY4SCxXCyb8JJtyJ+0j2QLCutB0SU8vKKifEHakEu88pw@mail.gmail.com>
In-Reply-To: <CABgObfY4SCxXCyb8JJtyJ+0j2QLCutB0SU8vKKifEHakEu88pw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 11:56:32 +0200
Message-ID: <CABgObfaSCXyqvfAgqn5kpR6nChqpuUiMmBj9kG4rgcm83yhXJg@mail.gmail.com>
Subject: Re: xave kvm-unit-test sometimes failing in CI
To: Thomas Huth <thuth@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 11:55=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Mon, Jun 3, 2024 at 11:11=E2=80=AFAM Thomas Huth <thuth@redhat.com> wr=
ote:
> >
> >
> >   Hi Paolo!
> >
> > FYI, looks like the "xsave" kvm-unit-test is sometimes failing in the C=
I, e.g.:
> >
> >   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000623436
> >   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/7000705993
>
> Is this running nested?

Ah no it's TCG - so it must be a recent regression.

Paolo


