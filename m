Return-Path: <kvm+bounces-52556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F23FDB06B01
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 03:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD8C14E09A7
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC38521C195;
	Wed, 16 Jul 2025 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENPkD07o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91D126C17
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 01:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752628392; cv=none; b=U0bOwGPDJ0qW/OCcUSa8rUOoxRFZ6hmf77WknUtsK/5NRFbhNrpuOCcMhrz3wDC7/wk3OQ8kP/76YMsGzZ716jNYRaAzPSWY1rNeUd9krJPuoDJCagiwuOhbHefo9rJCn8szNEeIANnwQy6uoYJTMYi+l1vWGDX9s46CSWKniPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752628392; c=relaxed/simple;
	bh=BKWyQDlgpduqK70y5bsJ48SQyWbfCqQEOJF0Pjbu2y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNq92iSlVcSOpfdiKeDCuiQQnW3KdwAEOv95rqQSXGEcJIQI1ASD25KyV/CEenNZ1IuvzKIl6v0VZFbry5/wQ/SoYKFr/6BbIFNXbtwKGy2tDUW9AwnxqQAXZj+IiMonmXPs9uqweTQwcW2p3qDLFbLNx3OzW5mZt0YqaN0bTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ENPkD07o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752628389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/keS/EUkYyBiSPiys9/nqLBkkMQLW+p9NKDLAaBTJK4=;
	b=ENPkD07ouisyU8WItzwUq5QZFcdCpG7onJkf+7bzyjGYZb0zzwID4vffrzQdj52atFaoOo
	xvd3beDoTSvMypMhIKMma6zSoeSR0owYP29bHq/Rk/2OiTFyVyR9UnXoF+RviYVRYdFtNQ
	mKGADuqwCUW+Fq/bAA+GOcK9AWO9dR8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-IVS0TFQuM5-s-6YxG_Ix5g-1; Tue, 15 Jul 2025 21:13:07 -0400
X-MC-Unique: IVS0TFQuM5-s-6YxG_Ix5g-1
X-Mimecast-MFC-AGG-ID: IVS0TFQuM5-s-6YxG_Ix5g_1752628387
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ae0a3511145so421768566b.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 18:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752628386; x=1753233186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/keS/EUkYyBiSPiys9/nqLBkkMQLW+p9NKDLAaBTJK4=;
        b=qvu0tafYiqvure+mMZ3fAc1CJoIbgnFDefELs473AjsAjYMUP3XHLi1bNGeozGEGaK
         iwOWpq+e6mCYyCEEgGB0FdSaJknqogBAw50pwNJi430VseykTVTQKKZMh6YaYnKmMAEo
         tpQGSkgr08PAwV9iWYLuRW0F0Sq0lsQNeLS8jnw1wU8XFVthT3yXRD49A4QPPpFo/W5A
         LJRr7SIm8O9prLy+iYyq2Vxa4zn1v+Vd9boqRHUwwvng81njL4iTg5ny+oxwWhupt3vO
         2jrGVt3ntRbbmkmxJMI51GYUsxudC2rk91o4UXUyJXRdabWQtuNV5/vhqoRiSBMTG9he
         YNpw==
X-Forwarded-Encrypted: i=1; AJvYcCUF+J3nFu047VQVZ3dkDYzWYGGgekPys0sg6HlshRMQkH75Uj9BY8fTozzx7ejOvJ5rB7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDON7AnZXqu07wNOF82y778oj1WazyojZOcxGRCyiqLet+0evA
	HsKYcvQDrJE63xYwjVzdxjoAA3sNbXfm2Ji9/KT4dsoVVITPQnY+oWkkk1sCRrPL7+nsa3VvdSc
	8YoIdVl3ak8HigIV9zx6nFghK0ZvB1Hl8fMYN/dTirFlnStJKYdtTsDR8x+QdcpKDddDPCYzN14
	6r2VoC54P5Ia86HuZ5ZhuAZF9Q99VXsKO7dilYiIpkeA==
X-Gm-Gg: ASbGncs9qjUMcMGBDiPKAnUUs87jJ1rN2QO4BUY6+0x04qpcBEtU2jYapYRDkXMe+f8
	kzhjak3z3dWEdeW42+43x74h1lCJJranNpnNf6KiEv6lBo3hTlp8KiBuBbWaME8ze9U+srCJ8zQ
	CuZOSauzG3YmEQh5acKhX6bQ==
X-Received: by 2002:a17:907:c89d:b0:ae3:6cc8:e431 with SMTP id a640c23a62f3a-ae9c9b6c4f7mr138674866b.57.1752628386130;
        Tue, 15 Jul 2025 18:13:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUD3HiOIYDUW7hX6g4mjiRwOrmAALXXgw8/ypx88cvn2L6gXAwS9h7hC+qro3T7N25vt1Mq+1Ot39s20uVR1Y=
X-Received: by 2002:a17:907:c89d:b0:ae3:6cc8:e431 with SMTP id
 a640c23a62f3a-ae9c9b6c4f7mr138673666b.57.1752628385746; Tue, 15 Jul 2025
 18:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714084755.11921-1-jasowang@redhat.com>
In-Reply-To: <20250714084755.11921-1-jasowang@redhat.com>
From: Lei Yang <leiyang@redhat.com>
Date: Wed, 16 Jul 2025 09:12:27 +0800
X-Gm-Features: Ac12FXzEZyLhkQ-ZlRuaRJizHbPzC5U2b0INYQwKCqtanE6LNjchFHQweOloptQ
Message-ID: <CAPpAL=zo2nom7=nL6y8g5N+7qR3oG+bVip1KFxCnJCu9V-M8nA@mail.gmail.com>
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this series of patches v2 with "virtio-net-pci,..,in_order=3Don",
regression tests pass.

Tested-by: Lei Yang <leiyang@redhat.com>

On Mon, Jul 14, 2025 at 4:48=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> Hi all,
>
> This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
> feature is designed to improve the performance of the virtio ring by
> optimizing descriptor processing.
>
> Benchmarks show a notable improvement. Please see patch 3 for details.
>
> Changes since V1:
> - add a new patch to fail early when vhost_add_used() fails
> - drop unused parameters of vhost_add_used_ooo()
> - conisty nheads for vhost_add_used_in_order()
> - typo fixes and other tweaks
>
> Thanks
>
> Jason Wang (3):
>   vhost: fail early when __vhost_add_used() fails
>   vhost: basic in order support
>   vhost_net: basic in_order support
>
>  drivers/vhost/net.c   |  88 +++++++++++++++++++++---------
>  drivers/vhost/vhost.c | 123 ++++++++++++++++++++++++++++++++++--------
>  drivers/vhost/vhost.h |   8 ++-
>  3 files changed, 171 insertions(+), 48 deletions(-)
>
> --
> 2.39.5
>
>


