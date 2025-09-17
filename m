Return-Path: <kvm+bounces-57828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A30B7D301
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B1F91C00B9E
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344C530BF6E;
	Wed, 17 Sep 2025 08:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efYDK7tp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E041D30B53A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758098493; cv=none; b=CLeVJ8dCtT5s2LnttT/nfsQ1BZntnhoJkGBPTVbBU5pXeVpWCxhItciCPlYHIEU0ObYQEdUrWVrWyWBjRQIl7C1L3lBdeMsOXcJLiU6Shfq7d2rx79zuFpg/e8GlPMgfRzQHpB3bGSBP9J7qJwjUl4vFjANQAReWwIeVxGEIgg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758098493; c=relaxed/simple;
	bh=+wuBB/CLNq1RtJJc8pKidovhSHWzMbLGpuRbJ63e2mM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lu9VG7La3DnjBWaZ7q1+QERvW18ndKpyI6jA8zFASDuGQ28QrjTsnJcA4wpws3WHojPZYTvcajyGcDW/Ch5vROjbpMnHGaL3XvG67v5USkP3q9EX/fNvdz0qhJ6hXdHybQp+VHGyOktVKHz2L4Q7CDqmSZRf9ff6KW5V94txCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efYDK7tp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758098489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xk1YDZxcM7xZ806Adb7sILX43779sE7ub9kXrnkxlpQ=;
	b=efYDK7tp98qCQdIB0Vqvo9CansAhTJ8YtxYGSUqll27U74SJHEkx2DhZLt5ARADzwnKACW
	NBoJovC33mm/62KTkVUPRASj1kPMNf/D7X1zQj4FleTMQf4ONboSe/D0zaUjmIgXI+H1yj
	YIBzY1/grKR37MwQIRcOp2hpDyRKBbg=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-KXGglel1MQ6fl6pNE-nPTA-1; Wed, 17 Sep 2025 04:41:28 -0400
X-MC-Unique: KXGglel1MQ6fl6pNE-nPTA-1
X-Mimecast-MFC-AGG-ID: KXGglel1MQ6fl6pNE-nPTA_1758098488
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-72e98443055so75096877b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 01:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758098487; x=1758703287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xk1YDZxcM7xZ806Adb7sILX43779sE7ub9kXrnkxlpQ=;
        b=jBu/wLNCtUeeVKmSKc4Hdg+P1+Y3Ggy/YP28PXrDN4KXN/R85PMLfElwCJvIZDR7vy
         JQi6DfafWF/NJNSSiJffWx9Z+uJI8epH+ZTwjlspvrpkpyxBtf3GHEEg+M4YmstWBVDJ
         +Aom37EZ6K9Tcqb61L1wjHf5UMo1S1M5AngQaTf3G8ekb75dtOybtuA4/VNDKXWjUMGo
         JjDPuL7UxAbI1efuDyx339pNi9l50d+fPiQxgNT49s6DTHmrY6p8ZPdIAlr8calsIywx
         znIAunNMoA4uRIBax/iJ5uFOsWked/g/ZcvfDgR0/ZWuhvkZx3AsBTChsXOFCehjVEkE
         m5Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWNpVKzMpczEEK1XjqPLd92SzXBlcnXheAwR/AJYAt6MGmTxYwjtNwkGA+p7YHG8NbOKlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIJQJPLMF93c/kbYn71FWqoFCWLOzr6aL4jJSw98OcEEBLy5QU
	MedEpr53TW56AiCOL9Z029eVrFlsGwBpJ2pfXDd4+J0FD9kOtB3gZ3TcxQaFg3bnq9QBdXzUnQD
	6x0k8PAEjxZWyGL06Q4P02lv4/wwHBQpZpYCPq7xilTsBUZ1NyZhbslxdHPqv6MRVBeO2veinWb
	7k4oOrNTumgREHKlEy3FIxiZDsonIn
X-Gm-Gg: ASbGnctXNeAjYSN+70rSMdIvm9Z53kyt9M8I/n9gf5BzWpb5UphyKpfFrmr2mAT2iXv
	OZQYcgBRV5j+sCNkNBo+fCwt9Tri8EOxOVCeA+tvyEYeTsQQyP5D6NaYPp5aeLcs2FzXibi6G1v
	Ocs5pCutHgH+YzppLEn34FjSrKPPy3hw84lhrxXu92cgt+keJewHwIkJ1JncvupTwMBtAuM7GDt
	dLO6Qni
X-Received: by 2002:a05:690c:3749:b0:729:afb7:2a2b with SMTP id 00721157ae682-7389254ad62mr8759287b3.46.1758098487658;
        Wed, 17 Sep 2025 01:41:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGla76rh1VJaXE/66DHe3qldHYQTe5nserK4YUTSrEtY8HjxPWvHFg/4R+WaJ3obw1G8XGpBOJzgwrt/fVLoWc=
X-Received: by 2002:a05:690c:3749:b0:729:afb7:2a2b with SMTP id
 00721157ae682-7389254ad62mr8759127b3.46.1758098487353; Wed, 17 Sep 2025
 01:41:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917063045.2042-1-jasowang@redhat.com> <20250917063045.2042-3-jasowang@redhat.com>
In-Reply-To: <20250917063045.2042-3-jasowang@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 17 Sep 2025 10:40:50 +0200
X-Gm-Features: AS18NWB1Dm0RAuncLLFYv9X6ibudv7SYOoL2RD1bGzGSS2vWNV11fGBE2RDqleI
Message-ID: <CAJaqyWdsA5kbotTRpHXzHAyaxQY05dcmiPs=Y5Bb_9EVxf0oDQ@mail.gmail.com>
Subject: Re: [PATCH vhost 3/3] vhost-net: flush batched before enabling notifications
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org, jon@nutanix.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 8:31=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> sendmsg") tries to defer the notification enabling by moving the logic
> out of the loop after the vhost_tx_batch() when nothing new is spotted.
> This caused unexpected side effects as the new logic is reused for
> several other error conditions.
>
> A previous patch reverted 8c2e6b26ffe2. Now, bring the performance
> back up by flushing batched buffers before enabling notifications.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Reported-by: Jon Kohler <jon@nutanix.com>
> Cc: stable@vger.kernel.org
> Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sen=
dmsg")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 57efd5c55f89..35ded4330431 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -780,6 +780,11 @@ static void handle_tx_copy(struct vhost_net *net, st=
ruct socket *sock)

The same optimization can be done in handle_tx_zerocopy, should it be
marked as TODO?

I guess a lot of logic could be reused from one function to the other
or, ideally, merging both handle_tx_zerocopy and handle_tx_copy.

But it is better to do it on top.

>                         break;
>                 /* Nothing new?  Wait for eventfd to tell us they refille=
d. */
>                 if (head =3D=3D vq->num) {
> +                       /* Flush batched packets to handle pending RX
> +                        * work (if busyloop_intr is set) and to avoid
> +                        * unnecessary virtqueue kicks.
> +                        */
> +                       vhost_tx_batch(net, nvq, sock, &msg);
>                         if (unlikely(busyloop_intr)) {
>                                 vhost_poll_queue(&vq->poll);
>                         } else if (unlikely(vhost_enable_notify(&net->dev=
,
> --
> 2.34.1
>


