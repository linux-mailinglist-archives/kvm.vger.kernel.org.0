Return-Path: <kvm+bounces-7665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B718450F4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33CF1C239DE
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 05:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244517993F;
	Thu,  1 Feb 2024 05:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdzxbxNI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30A6BB5C
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 05:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706766455; cv=none; b=Fs1USYyanyta8yadAnx/CsqJslok1V18MAIjBCT2Fk1rEnDZUgofd/nCPF/W4En39YD26jy6dGQVVg6F+pZt+Y+Lug7bLxZxdxoc1TZzxfyE/UkYA+MsV3OMkB8gS9K8P9ZpsanJmw/tQ4KyKko0emXoBsQJwFm1TEKwJBSu6jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706766455; c=relaxed/simple;
	bh=CBg4S8QmOTSeweCbha4veMntFYrtd8iVVLl9ekfIfl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maJmXbpQrFBeFzkOR01mirzMRRx8m3a3DnOTt2uABLR5ytzCYeor7xCgKqu2tY1xukNvdSL0MWg3vqieKzvma3hazW+YNdW2XzR0vsmv9DiGuQky+OViD8xLXuQme16GheXVZwlEza1rBzh7gie3eYwstUJhwRe9Zuxj/kJkv3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdzxbxNI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706766452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBg4S8QmOTSeweCbha4veMntFYrtd8iVVLl9ekfIfl8=;
	b=gdzxbxNI7YXA5dDFK/Gzd8uKcmrh//zZOuwZrxFyyM09/Fc+kuKbSgI34yVYjxE7hX+ybx
	t5m1NkyxTUsni4+j3WuD2qScwiaQROS9SrWZ5Jk7jWceYSpHTly/nTvet23FkvfQyrEM6K
	pgPDvAVRQX7izSdlYgoDCg/o9zU4ItE=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-2aYA1WQAMaqkjNGor-R-Pw-1; Thu, 01 Feb 2024 00:47:31 -0500
X-MC-Unique: 2aYA1WQAMaqkjNGor-R-Pw-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-59874c4b5ceso599112eaf.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 21:47:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706766451; x=1707371251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CBg4S8QmOTSeweCbha4veMntFYrtd8iVVLl9ekfIfl8=;
        b=wC1RE+JlFcwQcpLyAKaCAsSw2x4nkViCZSBqY5f8ZxhS6LycvbhBmzJ5IpLpOKt5Zg
         bRoeo8EQn9fBLZGJCbxoN3pDua0d8xId8kDs1WHzF+fNgQMHogrdhPJXHskDeuLfmE1+
         O2f6csubLkLJhOMheBTVY/ylfF/itLfXpyEGKnGRT6gyulqUUrSJlYu6+Y31OV8SITBN
         HUHfPWXyxEGzIkOnmcogfa0IPBXYfg4SLmVfohwc7F4yFV3a5ImmYKUNlk+Y4iomBRpS
         2AIeIgnN4xslldCpNDNE+ieXQF+LgD/GNk4GQIoeHolHTrNb8ohJHWbd/yRH373D86ul
         soYQ==
X-Gm-Message-State: AOJu0YyM+lSWq6tncHRbQiAI7ae0110yPgM8TRthguIAg1B+7Uo55h6B
	+SHuHczBD0TfXrVMARupDDXJmSJ+cewFa7pCt09FyhLsxwdTncq78T5cfT6nJZ2U5/4Iaifm/E6
	Y+PfV13M54fmsDdndLsRflU7/SHADzzPV3hrwpKvqRw9197Tk+lsiibY2gq63sIRxxGZt3TQKaf
	9dkwA+9emvTA+pM6oDLaKq5jmG
X-Received: by 2002:a05:6358:d39c:b0:176:8f0a:be with SMTP id mp28-20020a056358d39c00b001768f0a00bemr4016590rwb.13.1706766450820;
        Wed, 31 Jan 2024 21:47:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3An1AT31hO5hdkkjtXW6+RRmDXc3skwLBvXnf7TlMSMjKRjtJlegau4gTcU4VNwvLpLMGyNjYJHuT0DVlBR8=
X-Received: by 2002:a05:6358:d39c:b0:176:8f0a:be with SMTP id
 mp28-20020a056358d39c00b001768f0a00bemr4016580rwb.13.1706766450596; Wed, 31
 Jan 2024 21:47:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-5-xuanzhuo@linux.alibaba.com> <CACGkMEs-wUa_z_tGYEwBf7EVJAtuJdkX4HAdjqMXHEM1ys-gKQ@mail.gmail.com>
 <20240131044244-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240131044244-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 1 Feb 2024 13:47:19 +0800
Message-ID: <CACGkMEskm6O0q86LOJGndiCmaTCnoqKYWVct_g-0fwV3c+_1fw@mail.gmail.com>
Subject: Re: [PATCH vhost 04/17] virtio_ring: split: remove double check of
 the unmap ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Benjamin Berg <benjamin.berg@intel.com>, 
	Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 5:43=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Jan 31, 2024 at 05:12:22PM +0800, Jason Wang wrote:
> > I post a patch to store flags unconditionally at:
> >
> > https://lore.kernel.org/all/20220224122655-mutt-send-email-mst@kernel.o=
rg/
>
> what happened to it btw?

Haven't got time for a benchmark. We can evaluate whether we still
need it here and do the benchmark if yes.

Thanks

>
> --
> MST
>


