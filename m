Return-Path: <kvm+bounces-39867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 007FBA4BACF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 10:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 025621890E84
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 09:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5B31F0E5C;
	Mon,  3 Mar 2025 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vnqx3bc1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC09D1F0E50
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 09:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994183; cv=none; b=CjEC8W3+dcg9L1ktBzGjX22/dHlyuMdj0mExg/c+jhYN1XaCv12TudHOwsRSDgAc3j8eL/bSFE3nurp4K1ZR4gyr4tkEjVcUF2yaj6Nl8VkPytKNDCZdfrirIrqbUq7MSEYuacpxUUNgI5M78fP2v36GxDqkLXj+wuwYD97k7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994183; c=relaxed/simple;
	bh=hO/1w0WIreFcCNOGOIiuvQHBGfGmx0RKyWkuiZ5OENQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1T4zUKAnUI+M/90d1BCmRJ9hnL+UFZ+OIqhIPfipJUqA8Rrs6A8hqY/ktFDxkzHzE4x6mkNUcM2ZGnCQqt6bDu8LLgyw2mFaJ39Dq2ev0G1P4m4kCP9NouVRissaBFuBVnSSv5xVUP4W67/uFTos+GR3//gnRJ8iga0SJnYtxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vnqx3bc1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740994179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dm+Ad9vtaxKH6b/jFWjk7lOEkc1nxwN4lmuVSAb6Ah0=;
	b=Vnqx3bc1aNPedPa4JUTrjtarmagh3gGaZ2wZ/LJr2h+eN1Vcri003ozZo1KTVNfkVxxvf2
	Rx/YeYjmXYYg6SnhFu+5UPZrV67sRi9DfsSi/zA7/OTwKOKMYKbqtiilr19F2DRfwOxjm6
	P6o0Kwyk60Uc/820ANtGYehq3lIg6/c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-rnzXVbNIPdqejnvZhekS3A-1; Mon, 03 Mar 2025 04:29:16 -0500
X-MC-Unique: rnzXVbNIPdqejnvZhekS3A-1
X-Mimecast-MFC-AGG-ID: rnzXVbNIPdqejnvZhekS3A_1740994155
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22379af38e0so35617515ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 01:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994155; x=1741598955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dm+Ad9vtaxKH6b/jFWjk7lOEkc1nxwN4lmuVSAb6Ah0=;
        b=kiUd74LxJhlic9H+EcXL7vo5BnXdiiQmUJZZAtfMpANW08LXYhc0j88uJRMSMvN7rL
         vCnAMR0WCHzpmAIIi1ozVthjNX0G64jLpQF2/jCqFM1HUJPqBCwixCHCAubDLKHPby8N
         eDAazTvqJGYcxDm/hw8oMfRLPqGyKLVK23+K6bZGut2tPmoFk69gg58ygxnfO2UGcRst
         RAZv+O++RDutK5nXHw8o2Ne0mOXjpXGkQL7oSg/ns+I4maxJ3sGY1nT6oY8bslPE/bhl
         B6oWUhoF23XmMxzUUt3oBTlt6UM7NjZ0Qzi4aHhqJh71lfxqcp+bfNb+HhEpcx2DmgxT
         +DEg==
X-Forwarded-Encrypted: i=1; AJvYcCWfH5AfrksMqikQs0xsRhDhXYlRFuCEopcaG29i5l1boFmtGk+xQ8Q/PLaRC2i3qcc6xVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV23Yq4OQEE5b+xBfAbmrqVmb/Xz0ScAz6njxMBbftzLp1aEUZ
	P36iVWS9xzyHzzkZghsYDREHGpZ4Tb9mGv7Yfrx2s3N8y/9zoClXzanwYg4dBHLgqpyMGxxghCU
	6fRbHannlY+jgOCJArnMqpJ+9z/2GZc5BVgVdcvVuXR63SHS1B7sXp2lqEZzKAVKG18oCpTIhUP
	UTRWKnMb+v/pua16wMsBPOpsSp
X-Gm-Gg: ASbGnctK4pV2MGZFSYjQ8Bh/AJCU/s3035NpQiKhn0BV5/0s9HK3YQZA2Db/ntQunpn
	xjRRhZ0D2HswRsWO9PWlpVNK9MfhOz1RNEfwB9LdW4eU4JNo3gmiBCcO4XawggWQAB/MxDPQ=
X-Received: by 2002:a17:902:f547:b0:220:f7bb:842 with SMTP id d9443c01a7336-22369255811mr196196115ad.42.1740994154031;
        Mon, 03 Mar 2025 01:29:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeh8T/Isef6u47m5QPpp9NHgJMkJl3dnUE8Ylea44Ny6EY1sjUVU9fZMYGnxlnkM9rFe7Jpp6zS4k5VEsVFKw=
X-Received: by 2002:a17:902:f547:b0:220:f7bb:842 with SMTP id
 d9443c01a7336-22369255811mr196195835ad.42.1740994153774; Mon, 03 Mar 2025
 01:29:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303085237.19990-1-sgarzare@redhat.com>
In-Reply-To: <20250303085237.19990-1-sgarzare@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 3 Mar 2025 10:28:37 +0100
X-Gm-Features: AQ5f1JpYz8RUYj9eXvkfBI5yoVaRYAPygFZFSo69WGk-H92b36v2eBIN9Cg-xmM
Message-ID: <CAJaqyWfNieVxJu0pGCcjRc++wRnRpyHqfkuYpAqnKCLUjbW6Xw@mail.gmail.com>
Subject: Re: [PATCH] vhost: fix VHOST_*_OWNER documentation
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 9:52=E2=80=AFAM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> VHOST_OWNER_SET and VHOST_OWNER_RESET are used in the documentation
> instead of VHOST_SET_OWNER and VHOST_RESET_OWNER respectively.
>
> To avoid confusion, let's use the right names in the documentation.
> No change to the API, only the documentation is involved.
>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/uapi/linux/vhost.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index b95dd84eef2d..d4b3e2ae1314 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -28,10 +28,10 @@
>
>  /* Set current process as the (exclusive) owner of this file descriptor.=
  This
>   * must be called before any other vhost command.  Further calls to
> - * VHOST_OWNER_SET fail until VHOST_OWNER_RESET is called. */
> + * VHOST_SET_OWNER fail until VHOST_RESET_OWNER is called. */
>  #define VHOST_SET_OWNER _IO(VHOST_VIRTIO, 0x01)
>  /* Give up ownership, and reset the device to default values.
> - * Allows subsequent call to VHOST_OWNER_SET to succeed. */
> + * Allows subsequent call to VHOST_SET_OWNER to succeed. */
>  #define VHOST_RESET_OWNER _IO(VHOST_VIRTIO, 0x02)
>
>  /* Set up/modify memory layout */
> --
> 2.48.1
>


