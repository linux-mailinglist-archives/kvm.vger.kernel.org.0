Return-Path: <kvm+bounces-12355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13309881C6F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 07:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4423D1C20F71
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 06:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6AC3A8CE;
	Thu, 21 Mar 2024 06:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sfk6VZjM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF460B65F
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 06:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711001988; cv=none; b=DAD7YhkHeSCK+97sAt3r66ShbzOP5g9rNyf04Z7IO1uzG26drzd3XckDH4YCEPMPcbeMEmIMeISwGRqT94gy57+QytIdSFrWNhFfqbFvNuy/C9SDSe05YJ6fajXU47oTrvDhkRhFeMumRbtcoyxVqlI4zv8MY+CLnxUIFQPAZFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711001988; c=relaxed/simple;
	bh=PvH1cfyj9tq34qKSQ8G2LMShu7m/sSRAzhUFKixFQWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBsf0so5SIpNsNQ4FCoGWitsmH0KhcjyuRcdZ5kmBcuzJjrnZKj27oX693ytKrIGNM8Yh0a3NXnnPKMf4ci3MTD9S4DFIkKN0DBMibaC0RRfgCA1ka+8/MiwDWAbZWaw649H+2obooWYsty3LGxRFw/nd+QII9F517RE146OAIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sfk6VZjM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711001985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HxC6eNhmW+PAI4/9jT45g+UtHc7I2enc6jUMC2U2v08=;
	b=Sfk6VZjMZKoZNvUgBtHCALKqrCJodB2ftBTn+tWKIhCIVqamgjFBXqWipXb4Ve7ikjgl3A
	XVaL/Ma5ZkXK4iO7WtRNXmYKFrwOHUFkyUPvayB+5KZlF/UjYpaiI8/niI+p5arXWoDOAl
	EqxUI9VxDK1+l0psXHQL9dZftFrjMlA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-N_JPFDpBM7aI0MBFMsHLeg-1; Thu, 21 Mar 2024 02:19:43 -0400
X-MC-Unique: N_JPFDpBM7aI0MBFMsHLeg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c8a960bd9eso57904139f.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 23:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711001983; x=1711606783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HxC6eNhmW+PAI4/9jT45g+UtHc7I2enc6jUMC2U2v08=;
        b=ey3ArXWE9xKcfpWXiUc5dNPJpeq2K26Z3Akq63iVtSKksoV2wLrbBmgI/n0W92zeXB
         fMPhf30bSmv46xd74o0Z3jrywvQZ3+SDTfsY6ctsbZj2btslFfGugjJaRgTc5+sXxDKG
         oIXPydMFuUt2HdX9+UG20otQKPU8ACP4sYWJIRFwTMZVIB49V5Ev2JMSudIQSTc3cF3c
         0Acj0to8P7cR0k9k4pMbFiLqcuLxqz3V1dnPOqzWmoBwWafLZhYarTgpj2Dcf+ve/op/
         X5UHUe7WoeQRsmrhQSTGC+jF8EszQNT1rnPHHSfPl8oibWf1dW8U7R5L6I07OQEVhpow
         oRaQ==
X-Gm-Message-State: AOJu0Yz2qIiv0AN6cF0UQMpIRbn1U9pzxJi//E3Whocvaj6mtJcSz43R
	rZMjzGmO2JK+CaQSZEYVyeLoUvMp8PZS/OlKuJew+QoKfkmY62ZXTKG7D8qMBwPUGZyndsOmfGb
	1mQSE0hHiQU+BW5bgNXtLcxO5Rc9FGhPSw0xpPTLyOUnwo6Cai8DtW7SZ4UleESirzp+9bYbeKO
	MQMdCn2/RKkj+/kN0yu7gKhrJS9uEVp0Dl
X-Received: by 2002:a92:dd11:0:b0:366:b29e:d282 with SMTP id n17-20020a92dd11000000b00366b29ed282mr1108817ilm.19.1711001982653;
        Wed, 20 Mar 2024 23:19:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4Yt7dxyAIXv6/bFL9PaJMlyj62Mjo6L96hnlDhpXVsTa7ONtv2Tos+SvbI4D1eLbMM+YOhVspi1lC7N/b/tQ=
X-Received: by 2002:a05:6a20:d49a:b0:1a3:8e26:4ba1 with SMTP id
 im26-20020a056a20d49a00b001a38e264ba1mr1418043pzb.18.1711001630127; Wed, 20
 Mar 2024 23:13:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
In-Reply-To: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 21 Mar 2024 14:13:39 +0800
Message-ID: <CACGkMEs1t-ipP7TasHkKNKd=peVEES6Xdw1zSsJkb-bc9Etx9Q@mail.gmail.com>
Subject: Re: [PATCH]virtio-pci: Check if is_avq is NULL
To: Li Zhang <zhanglikernel@gmail.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2024 at 1:26=E2=80=AFPM Li Zhang <zhanglikernel@gmail.com> =
wrote:
>
> [bug]
> In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is involve=
d
> to determine whether it is admin virtqueue, but this function vp_dev->is_=
avq
>  may be empty. For installations, virtio_pci_legacy does not assign a val=
ue
>  to vp_dev->is_avq.
>
> [fix]
> Check whether it is vp_dev->is_avq before use.
>
> [test]
> Test with virsh Attach device
> Before this patch, the following command would crash the guest system
>
> After applying the patch, everything seems to be working fine.
>
> Signed-off-by: Li Zhang <zhanglikernel@gmail.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/virtio/virtio_pci_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_p=
ci_common.c
> index b655fcc..3c18fc1 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
>         int i;
>
>         list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> -               if (vp_dev->is_avq(vdev, vq->index))
> +               if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index))
>                         continue;
>
>                 if (vp_dev->per_vq_vectors) {
> --
> 1.8.3.1
>
>


