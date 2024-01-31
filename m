Return-Path: <kvm+bounces-7551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBCA843AC6
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5026F1F25D76
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62FB79DB6;
	Wed, 31 Jan 2024 09:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N7kBPgcS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940B769D19
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692397; cv=none; b=OjYs1FjSVyMpaJkVsMvXpDhmtdfvhEgdxcm9tNw69q7T/J/zZLt/0hj1zGIULIQ1DAzzhij65xulZgFfLkN9lGbh+ThaSnJR8RgtYJUA6YkngoSThjRROlusuo53z0XISsJdUIQGkOeUDS437oX2SyqTyNw6rpceORaqCv47xsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692397; c=relaxed/simple;
	bh=GFZDXlK/s4D6vSBTxs5Uj6beZ7wLcQBUCOrs3aA1zrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t9ymA3ETJtJuNqBKqjGed+tlQ+ahDwkkLouxfk6bhrVpq+ere6uExU+OdaYCkRVUnr4SGIsF+nIV1Kqlr4Ix+ZkyjRktTW3YaNqShwWXGztEuqf+LI/HGtJMM9hQAMG6cmITmJxoFfVKiXxva86axsVAT3iaVdDsCwnGa4ki+VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N7kBPgcS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706692394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GFZDXlK/s4D6vSBTxs5Uj6beZ7wLcQBUCOrs3aA1zrk=;
	b=N7kBPgcS3SOu0RNWXUvW6sLMSs97kVg5hAuyLL2UucWOPI02SS7gbLdeFaiaoSZ9k1Rtre
	W0kNPqD8fcmFAy8vULepFgn8J37h9pCwpFB1ezU3vW354LEhOjCOlbbBBmEb5qGf9DvGVZ
	I9i3GWRoBx8JtT/G+63ClST0VhJh3F0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-8Rc_1sBcN1GO8-UNw65Ycg-1; Wed, 31 Jan 2024 04:13:12 -0500
X-MC-Unique: 8Rc_1sBcN1GO8-UNw65Ycg-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-46b15d4c6bcso1152676137.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:13:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706692392; x=1707297192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFZDXlK/s4D6vSBTxs5Uj6beZ7wLcQBUCOrs3aA1zrk=;
        b=q/fkTIwb3jUuirLIE0p4IJFoQx7a+5wuty7K3PSd2MX5xRUJrjDX53wnws+6T31KSq
         kRsAdvODZsZkhlzZx/euexV5pvvZFtPyNwP7RoXlYr9Pfo1ZmjQ4uX2BIJGQOWfF1tZf
         WjYCTy7hUHtQsnX4CW9GzfNOF4k0xsg6yNTcgGbBKgwXzBgKngOeEcgObRehBcPID9SV
         CHltfSlAR3Om0KTi6UAxel/UgUXLvMf3DMUyMm3C8ByNx00xhKci4ZCD72gLfXaoMR/9
         4U0q3pwJPKkvZhHDbfshKgVmzaGo4ggLdgjFCBFijsCV87B2Fx42R8cJBuVMOSiOLePS
         ecsQ==
X-Gm-Message-State: AOJu0YwDa89X2ss3bFgjvpz4Tz9cjgkBq0zcnL7j05/uXNy/lhyF0MxD
	xircj1ILdc8cag7RoV6cxO+jw4CdVGVW1lCtOEJYvHvKAko/Py6Qt/yAf/rW/+FATcgFQ43TOfG
	LHjuf0JQ6ow0sSimWZyfGn7OySZrOATj4fFuU/HOgFE4I87BWB1SPZg5K83myaLFCfzhmqHTerG
	f3lr+gHNf122pMHo9F4juF9KZW
X-Received: by 2002:a67:ec18:0:b0:469:96dd:4a93 with SMTP id d24-20020a67ec18000000b0046996dd4a93mr924037vso.10.1706692391852;
        Wed, 31 Jan 2024 01:13:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/cR50d4YHDD+w1IZRT3VXxyAnkVgoZf6Jvq1cGXaHp7Wnd5AI92yFzXhl3he/qD1ctU9FKOVMa+BK0TXujPo=
X-Received: by 2002:a67:ec18:0:b0:469:96dd:4a93 with SMTP id
 d24-20020a67ec18000000b0046996dd4a93mr924015vso.10.1706692391631; Wed, 31 Jan
 2024 01:13:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com> <20240130114224.86536-9-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240130114224.86536-9-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 31 Jan 2024 17:12:38 +0800
Message-ID: <CACGkMEsOR-Sz6tZC_Lm-Qxdh4Ugjyn4APsX28rkL6nA87oa_Yg@mail.gmail.com>
Subject: Re: [PATCH vhost 08/17] virtio: vring_new_virtqueue(): pass struct
 instead of multi parameters
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
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

On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Just like find_vqs(), it is time to refactor the
> vring_new_virtqueue(). We pass the similar struct to
> vring_new_virtqueue.
>

Well, the vring_create_virtqueue() is converted with a structure.

We need to be consistent. And it seems better to use a separate patch
for vring_create_virtqueue() as well.

Thanks


