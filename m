Return-Path: <kvm+bounces-12961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E83C88F685
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEA54297AA2
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB9022094;
	Thu, 28 Mar 2024 04:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fO6txLIu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65062D046
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 04:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600951; cv=none; b=dPs4hg/70TX1Xs8bhAHwS+egYeWclXxuH6C1DJTE1Xu9aLCTp+g/OX20Z3Ur3Pd7YaPBxCsTTT5qT0NOcB8iR4spEFjDhG/kYoHKBBhAmJNlphpAteCxG9tmNTnKiH2RZj3PvzUM+UxDWxeevLYz1j70FNHmal3tD+dXXncXcwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600951; c=relaxed/simple;
	bh=lke8Mb/+VlM0WFVcd6AGtqJ7F4qGSoxqh/tNas4oTT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J2XM+lv288d0ApiGAJeWXHurNTJ3XXQPB0BU1aaKCRpPempu4j0I0nr7+AMIKFQxML0Yg3Zro98omTzYI24ipRjLtAJTKEm5geLx8P9KASkTQD8dHnzX1URnnbtQjX0xpVN+T6CXKaFPgsIZd4coX+eNqRCSfF/Ea5OgbcGjKFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fO6txLIu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711600948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lke8Mb/+VlM0WFVcd6AGtqJ7F4qGSoxqh/tNas4oTT0=;
	b=fO6txLIuPBIIsSGWEDXTqmKYuzEbG+cUh2puTVUQ1RDS++rGfQI25oKz2gOtkuZidHMNY9
	/FYtvuBEbMBESGogK8ZG9HUlrNvr9nY1UnP2cJ4I36cS6XwWFrkt5+LKpHevccoCKU2zcN
	V7VxkcHj1pepcqkFAbcXpnaLoqndGT4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-dJPKJ5ScMRuZXBPs8qkT0Q-1; Thu, 28 Mar 2024 00:42:25 -0400
X-MC-Unique: dJPKJ5ScMRuZXBPs8qkT0Q-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso362336a12.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 21:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600944; x=1712205744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lke8Mb/+VlM0WFVcd6AGtqJ7F4qGSoxqh/tNas4oTT0=;
        b=lHfJV0lJKcEh9Ekjq+TXT8LZfUcN13tXvY8IhZCLgPufGnISsb83NnXxXpXJVeWKca
         FxNcCHkCbVR1ZdmCV0cE2EdHoC1ZEV9l+eys5au3ixfWMa+fxA40snIEjxvbAd6CjTbe
         rUvjWZFOnsdDR5JsbmwD1J6pubtlB+8rTeDI1IJib35NOKZ+2jlCZbY5I/XdIBJmAmAE
         Vv/n4mCHoVhLz+EG/DfwBsT4lFNNbkdCZw1Nzf84qCiqc1ej9PpiXi6Hxoan7YQKzwt/
         ec/cDpAnhd/wU90XrcsJCHBTpNxotD8FvHfsYs3zbeqTkWOqs1Gtw5NTTlwM5Z+ExM8d
         6ywQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmBWExfSQxFbe1d604LTOD1b+HD3puyPtcCSvvUyn9tO7ZzxoolyfwC0kZvjpV9cpphUiAZsT98RD0LMwE0fcw4yPQ
X-Gm-Message-State: AOJu0YzaC0ogjz2xtvpfwcLyj8EzxpRl8R+SNBFBz3o+WTYky7dsrstp
	GL03MSjeCqrxYF67+w0K3jiNvRgOBWckPq+OSjJywhnBIl/vdFUCG9C8G3yyxx9PrCTl4CxoM8A
	2YfxVp4Sl4cQvYcb+N32FcrzVkwu7JK/nDTSNxDTRMdOmn7u5FBxhGl470wwONDFuvXlL5WvgVK
	4v4kQdCq7Ip7g8I/gvRrnHGz2H
X-Received: by 2002:a05:6a20:3943:b0:1a3:aecb:db60 with SMTP id r3-20020a056a20394300b001a3aecbdb60mr2612155pzg.9.1711600944745;
        Wed, 27 Mar 2024 21:42:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGqMeGlScFLGjuf9ntL+wJAbmcBUMH9qH8VV+quAV82wNT4oC4BMh5FM/UUwwoJlJBLwmVhiSP74tk9QYL8V8=
X-Received: by 2002:a05:6a20:3943:b0:1a3:aecb:db60 with SMTP id
 r3-20020a056a20394300b001a3aecbdb60mr2612140pzg.9.1711600944494; Wed, 27 Mar
 2024 21:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327095741.88135-1-xuanzhuo@linux.alibaba.com> <20240327095741.88135-7-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240327095741.88135-7-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 28 Mar 2024 12:42:13 +0800
Message-ID: <CACGkMEsViOCh-DGuRqZr=XGT+wJcG68CFAdiTcLc-q_2CtZ8tg@mail.gmail.com>
Subject: Re: [PATCH vhost v6 6/6] virtio_ring: simplify the parameters of the
 funcs related to vring_create/new_virtqueue()
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 5:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> As the refactor of find_vqs()/vring_new_virtqueue()/vring_create_virtqueu=
e
> the struct cfg/tp_cfg are passed to vring.
>
> This patch refactors the vring by these structures. This can simplify
> the code.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


