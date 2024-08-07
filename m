Return-Path: <kvm+bounces-23570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F7194AED9
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40759282FDA
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF58E13CF86;
	Wed,  7 Aug 2024 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+akD2lF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B976BB4B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723051578; cv=none; b=VMOSgVR1ALCn4Dn1cABPcorofas/nNkoVGPeofLESgjYA8OI94ITiIZrecm5sbuApsqRhlxCnbXq5mecdIIw9uULstcZd06Ag9cgzZxTWtexYrqPHI7fa10smOCJbqiwrJ+N6ybjRsGvTnM7i9k65kiOxWrRd3OGMDzCD8DOMyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723051578; c=relaxed/simple;
	bh=kDD+AYYDs54ZsUAuP5P9kcg2rTIPo2RFkbemp3kLQgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUAcjuk67/fqv13GTtv53aOzqfN4iex4AyqEmU5DG2WlSDw9oMaLJ5bdKA5nrvE7B2iUTZKFFRJF9XMntH9bJAtnUMY17fu/B46EB1nX+bavoTf8qoA0AgAjqOq2np8lCHrH/2vNj/K3Hfe7lmgVSezaj+NMCYMjLo8HjVRoVTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+akD2lF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723051576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5QV4+iopPwY0m4DyFRDxo2bCkauQC1irFXatbAdCSc=;
	b=N+akD2lFoQDJlM0ZhoKXXIKh69GhszAMLwTH9asZxBkVm7QZ6wUq/kj1kjn0rr8nc8OP7x
	2vybGEdegsib9TDnowSmvrm18XxA7C/fD/lA1Ynb+M2keyps81ywAQ+jkR2B45z6LLJsgC
	cq7z8we+QhVdMyzfXNDmx2MnH+HOhws=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-i3BbBhooNUm-uyycfpY1KA-1; Wed, 07 Aug 2024 13:26:14 -0400
X-MC-Unique: i3BbBhooNUm-uyycfpY1KA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-66890dbb7b8so2181107b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 10:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723051574; x=1723656374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H5QV4+iopPwY0m4DyFRDxo2bCkauQC1irFXatbAdCSc=;
        b=ZfjblAKtspFeiBj1tzkAsrxA3HvL9lLMuvWM5D5vBVo3NFcOAumzJp/8NiG1UFOcR1
         bqlNxn6/Lk3+WZQgxDC67EeefHCIwp4VWhvC9FJmd4a/xYgh6wEJZCQE9df5c9g6m8Ch
         qkT3ZTpAuK9GD7K/LzcOjQJFuAVzo6khh8EuCEBBK53mhhiigbp3E8bOLnj6++3R6Fb8
         kL3ks+j1FafpEGkLQZFqhnyQiUfdW1L+7LVqbnk5BthzJTbsObEhGwke0khzkCN6eeKZ
         2gnxHXHONXYc7nOBu1G1mTzFPSu9a3ajx3jyoQri5grY+OD2M13s7pG7cW8mOH9wSAMc
         761Q==
X-Forwarded-Encrypted: i=1; AJvYcCVN7YgKIjzyKHwweQnJfNjFLcxA4v6v7RQ78X2cRKdwzJByQEZgGwGvuWyieYG2QH55OcbLEOpl4WkiPlfQr2kDYRzq
X-Gm-Message-State: AOJu0Yyz1fCukrONq6fvOqm9oIvlYcexin5kvKskscEBL+G2tdYLx2A4
	xc6G+adUXNj3ZJLFSyvy/JSi5k48JgC05vAufbErP4vH1rXsUq/YhjqwRjqN2P70UYv140nhPb1
	SbkcwaE2jq3uwB2S3Ic2oh/TfmVF9q3iAuGs4qwS6Krru28q29JWdjC51/+zxHoeU+Z5320Vi+E
	U/jxPI0BWl5tzZPRXfzVnVAPO7
X-Received: by 2002:a05:690c:2910:b0:632:77ca:dafd with SMTP id 00721157ae682-6994e688610mr28408477b3.10.1723051574404;
        Wed, 07 Aug 2024 10:26:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzODDu5SuLmPC3x0D9XfVYRIqe/hUT4RhAAbLaRi+yjfrc7hm5AZ2wB3etv3qjrV+Oivcb6giYGkElvoa+ze4=
X-Received: by 2002:a05:690c:2910:b0:632:77ca:dafd with SMTP id
 00721157ae682-6994e688610mr28408047b3.10.1723051574034; Wed, 07 Aug 2024
 10:26:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806173119.582857-1-crosa@redhat.com> <20240806173119.582857-9-crosa@redhat.com>
 <fff8c0f4-881a-4317-857a-0d20a72484eb@linaro.org>
In-Reply-To: <fff8c0f4-881a-4317-857a-0d20a72484eb@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 7 Aug 2024 13:26:01 -0400
Message-ID: <CA+bd_6+-9Mqu-qmRowXhRUSVZenY6dugVE+no15coxbCot1Lkg@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] tests/avocado/machine_aarch64_sbsaref.py: allow
 for rw usage of image
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Radoslaw Biernacki <rad@semihalf.com>, 
	Troy Lee <leetroy@gmail.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, 
	Beraldo Leal <bleal@redhat.com>, kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	Paul Durrant <paul@xen.org>, Eric Auger <eric.auger@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	Steven Lee <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 3:30=E2=80=AFPM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
>
> On 6/8/24 19:31, Cleber Rosa wrote:
> > When the OpenBSD based tests are run in parallel, the previously
> > single instance of the image would become corrupt.  Let's give each
> > test its own snapshot.
> >
>
> Suggested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> ?

Yes, sorry about missing that.

>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>

Thanks for the review.

Regards,
- Cleber


