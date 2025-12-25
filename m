Return-Path: <kvm+bounces-66678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1AE8CDD340
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 03:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83A783025163
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 02:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68F7246778;
	Thu, 25 Dec 2025 02:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XU6CLyrT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSzMxfdM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E873239562
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 02:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766628823; cv=none; b=Fbs97pG3EtNPRThvLqVWXs3tBtus4TTGGDSSmG+1SfhGiT7zy29XYt6WwvVIQ6bDrpNJb6JlBlV/3izao3jbo0+9pB6eJFQa8dOM0HYhs69+X5PpwrtLj9h4zZMPATHtvUuEAiImcFzzzwofJt9pjol8SNJv1LRlwXHn3g27m6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766628823; c=relaxed/simple;
	bh=7YpexbkHgi8MYJCeKGa6NmPLNo8dJlqBsM1QFzG+dqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C4dG1C7MBB+a+moPBhncoI9EBFV0n4Nf8xVEt9tIturFbCJCWm5o6mfaGY2a8G8oalUgXYGfhV9sWONi3Cx+A1d8PN0wEqWQIupRkzyYt6AETgDXbJ3w5XTrvruAF0but7r1f79azK6IPgTkM1/bpxDLI6/MMpFIPBc+0pN5Hhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XU6CLyrT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSzMxfdM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766628820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YpexbkHgi8MYJCeKGa6NmPLNo8dJlqBsM1QFzG+dqc=;
	b=XU6CLyrT/VdgXEPoWY5trT2aCyyOmuRYA+09DjZfEikqemKZxoyH1SBg5Xh3fjEEP/HKw9
	kliTWxSzsjq1Bs1D9jEWbATTsIUZNJ8T8KfR5Ple3NYWCT8bnU9pNgWZter0ImJTren6AM
	WgRMRVMHVgSuw3dC41Cdygjqaf6Kxck=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-23DtI8VBPGWTuZARed3baw-1; Wed, 24 Dec 2025 21:13:38 -0500
X-MC-Unique: 23DtI8VBPGWTuZARed3baw-1
X-Mimecast-MFC-AGG-ID: 23DtI8VBPGWTuZARed3baw_1766628817
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso6353834a91.0
        for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 18:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766628817; x=1767233617; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YpexbkHgi8MYJCeKGa6NmPLNo8dJlqBsM1QFzG+dqc=;
        b=JSzMxfdMJyuCsS2OBbrEAl+zrz6JqtaRczEID9eoCqvzYVhaDJwxX7yolyRTjueKSE
         gGhoKuN3bk1fehz3M7+kC/9kpUNlt3abGkxiVM7LPrWRsrYptYLfrgcp75gIPTNtgxF0
         OBe1sAw4BfegBgPc3GGLiKUxWdsMGB1CR3DZOqos2cB1D855fGBiRP5e/SFe8T6kb3z4
         FA0ofUTRi1m1Q232GXnMWgUGuqYfdaWfrJTsNpfWZdMsO1ZmgHrc7MXtZ7bj389jHGdA
         5PlR1YrvRoBzyG1qYkPQtvG9MoQYky0+gtPmHW7KCzEZnS7bEOaiguWRakghW/hqG93k
         KmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766628817; x=1767233617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7YpexbkHgi8MYJCeKGa6NmPLNo8dJlqBsM1QFzG+dqc=;
        b=P4ypgSgipzp1qkv07tuRZdVeBWgTciS6poOxwylgNMxO5e9gwegbxjRxqpebEVdPoA
         Av9zNYVrR4gHxjl3o3PTDXTCeEyWbeII0ydU+pQ2tJ0gDbHu0UWP9OMhf+UkYS/m94i9
         D6mCVAGGmgefC19WMn1wdNnP3HW5stu42xG7oMXnZEigoC3QQ/ke6FmDxb2aZU9PQRsZ
         CGjyzhzBnSiwAXtXqz6xAfZEwNQMNaj1xEg2OMPrTp42YYwM8z5ltiN0ZXkbqkL+N+0S
         iu95XkTv9C830UNqYzjOWzMsiY7zn0YktzlHI/DzYZn0j+tyXk0dvmQLnSNyynTC+2J4
         igPw==
X-Forwarded-Encrypted: i=1; AJvYcCUlUMH/EnyBtITmKucupQhLWZlMAUiQ/iVfXDKIjA2HtK8asE+I2bisnlKI7paunI209XU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKaB0ySOMzTCfzxTKP2N8XQpfxvVB+H7qBLhuxNc2jB9KVBwPY
	9jqOPJBMf9/RKjhP/rJ0Uohrd+sW6zAUdcVlaw9fvRCaGVAO2BOD/TylkIgfmn+9WFKyTX++OSC
	mkfOw/voVP1gvJlPjV0pB5K+Rp5pg3tiCNEwSuhy0c4U0/qTbFaNZOQvMty65O3JRBdfE+oGYsG
	+zGzSHD3W5qgx42tg75djvJu9bUqfQPQvFsFYvr3U=
X-Gm-Gg: AY/fxX56kJnFjr1HSAMV4bx6jyWPhodFvZnqoJxQERGTmGKznWTlIR2zyyLzcjZMtRX
	sDW1gTiEnhDzjLDj2D+FrE0K+kaec+YR6aSr/FFiImLKDmo4OrWgPv20Dl4Iup/ccXL702K0yoW
	g7tfFidX8vmBdEkc9HZT3hmCU6ISvNpOog1O4FMnLSGKPeJWEmYONRNHYveqaYjOeOdBjE
X-Received: by 2002:a17:90b:17cf:b0:34b:75f4:96d3 with SMTP id 98e67ed59e1d1-34e71d80c4bmr18119985a91.5.1766628816957;
        Wed, 24 Dec 2025 18:13:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwhbsMVHrIOb+o/clMZRBZzzVHUxqhhpyOgjv8QLYkGMTunA2LZlvhWcPpsC0hOAXEzKg6bxSfXCXXoKtYoEA=
X-Received: by 2002:a17:90b:17cf:b0:34b:75f4:96d3 with SMTP id
 98e67ed59e1d1-34e71d80c4bmr18119967a91.5.1766628816541; Wed, 24 Dec 2025
 18:13:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218091050.55047-1-15927021679@163.com> <CACGkMEvbrF=g0_yedXKsccVN6vmfm+oQVbRkR1PGtQgFHH+v3g@mail.gmail.com>
 <3a4733b.8bcf.19b4fb2b303.Coremail.15927021679@163.com>
In-Reply-To: <3a4733b.8bcf.19b4fb2b303.Coremail.15927021679@163.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 25 Dec 2025 10:13:25 +0800
X-Gm-Features: AQt7F2qv14pEjpotcQVKXINUs_y7jmmFmHc1_NfnTrxSaTXcN2AvZ9sBp2_RjGE
Message-ID: <CACGkMEtZUpTG5fG5+JvJw=4RGDo89xoXQjkLyLnWVXHx1gUW7g@mail.gmail.com>
Subject: Re: Re: Implement initial driver for virtio-RDMA device(kernel)
To: =?UTF-8?B?54aK5Lyf5rCR?= <15927021679@163.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Thomas Monjalon <thomas@monjalon.net>, 
	David Marchand <david.marchand@redhat.com>, Luca Boccassi <bluca@debian.org>, 
	Kevin Traynor <ktraynor@redhat.com>, Christian Ehrhardt <christian.ehrhardt@canonical.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xueming Li <xuemingl@nvidia.com>, Maxime Coquelin <maxime.coquelin@redhat.com>, 
	Chenbo Xia <chenbox@nvidia.com>, Bruce Richardson <bruce.richardson@intel.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Yongji Xie <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 5:32=E2=80=AFPM =E7=86=8A=E4=BC=9F=E6=B0=91 <159270=
21679@163.com> wrote:
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> At 2025-12-23 09:16:40, "Jason Wang" <jasowang@redhat.com> wrote:
> >On Thu, Dec 18, 2025 at 5:11=E2=80=AFPM Xiong Weimin <15927021679@163.co=
m> wrote:
> >>
> >> Hi all,
> >>
> >> This testing instructions aims to introduce an emulating a soft ROCE
> >> device with normal NIC(no RDMA), we have finished a vhost-user RDMA
> >> device demo, which can work with RDMA features such as CM, QP type of
> >> UC/UD and so on.
> >>
> >
> >I think we need
> >
> >1) to know the difference between this and [1]
> >2) the spec patch
> >
> >Thanks
> >
>
> >[1] https://yhbt.net/lore/virtio-dev/CACycT3sShxOR41Kk1znxC7Mpw73N0LAP66=
cC3-iqeS_jp8trvw@mail.gmail.com/T/#m0602ee71de0fe389671cbd81242b5f3ceeab010=
1
>
>
> Sorry, I can't access this webpage link. Is there another way to view it?

How about this?

https://lore.kernel.org/virtio-comment/20220511095900.343-1-xieyongji@byted=
ance.com/

Thanks


