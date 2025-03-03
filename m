Return-Path: <kvm+bounces-39850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F39A4B715
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 05:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C3CD3AC512
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DF41DB12D;
	Mon,  3 Mar 2025 04:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hc6u9pgw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A10A18B494
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 04:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740974815; cv=none; b=Zkza0refLpTq2Nt1sQl2DnHj4uYKCnKJNvtaLplgZRRyXcGBEqhFkRyt7CXx+yI1Bt2v3/V2b+DAKEaJqG2klL5yvRrXVDrTrxuID2/fQ/jAEUfTK+9AbJK0rxHJZ0adKjvEchdwaQ2/vHBUoI3cwndr1kz33zgt9sn1d5vDxbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740974815; c=relaxed/simple;
	bh=1wzdOirKyTsZVCC1Ram2ZbDslf5ecQQUi0CW6qdxLA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W63ibPthbOqMN4dUbMw2VhISaK0ZD4rp1ummcNWHKK7uHLGi3tWAy2IzZ+FMAWhjUJZNNdKIWF0uMSWo1KQBPqdSXn1+5gY7WAO6cJTYQzZFqY6nxIxQ+XNOHNONYjZOia72ZRBM8XD65EN0wRfGdYevLOdONLL6Nix0U20DLHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hc6u9pgw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740974811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wzdOirKyTsZVCC1Ram2ZbDslf5ecQQUi0CW6qdxLA4=;
	b=hc6u9pgwVV5NjNAHCrQzOlQyxCqeYVoR4Nsu4tHN5xGf1NVr+gQiFQwtTT6y18fwXFmZLw
	2zJNt+w+bCan+SDspVLgI8/p+5+26d6mJoz4XIrJoRGqPFfwUn+87h+zulJzzp3FyPc2c1
	fSiqT56bk3ByFFE0YdCFzCJQvX2NZ/U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-62qgktVTOM-7SJ6_YGsoAw-1; Sun, 02 Mar 2025 23:06:50 -0500
X-MC-Unique: 62qgktVTOM-7SJ6_YGsoAw-1
X-Mimecast-MFC-AGG-ID: 62qgktVTOM-7SJ6_YGsoAw_1740974809
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-abf7171eaf2so81938566b.1
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 20:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740974809; x=1741579609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wzdOirKyTsZVCC1Ram2ZbDslf5ecQQUi0CW6qdxLA4=;
        b=Z78lYDe57kacItrDnWlwPPwgg3XSlPaasjQNyhDquan8iPzadbDv8maS7Fvqmry4Mi
         cTLMz9vGZ20Hj4RAGSPtmwjVZKPAjnKZQW3rFJkoDS8V2/s/3r6m1AnxTbDB79fQnQDG
         K74hRcIKzKQvGS77wguwFcRRS/UH/A9DNhNoSzTiOCmezoXCIG4lYr5JqCjh5ugvS6Ww
         Vm6cSBtOdR+5Hmft/rFBm3ofoj9r1is/tsvjBVbCb4W+Cm+58jKZZGto+tpl8YSOhlCi
         qKDs0LSKz0bCQ7pkVJOqXas6r8/Lh0m8DRad6GoQQZ2vayYVoku9SIGZLIONRCUSpb40
         nZtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ+Ln+7Xepb5vBvWUEP12KargQotZufBuwdu9Y2U0jzQUb4NgK7SbNyLS+RYUTf/fMmBU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl5XCQOmtieXh48hkd3ly7YjpZKC5Ji5w0YLwtIysWbsLP/R7w
	gucj0pGaJueMZTQ4rhS+c4z9DT/z33+kdIJDI/I1KX0wCXMTm1UMqrUjc/t+zveb3aDBFlXWmCB
	95tldbIhUwbSr4HIcqw2y+DwqHKViXgo/lszE9OmWhvNbAeNV54Mh8VhQW/KimRwAmttUjpAqxI
	avw9VWKvS5wCv6Mee1s++vNdTV
X-Gm-Gg: ASbGncvJDdVMEBlrMzX82QYJRoUor69vhRlRYVqEVgKMCYrQjAYqFjtsq05JTxmxdTu
	+Ma58/f9l4tPxn2DYbqDz6H/5HZORI/q1XDXpCiEQfHrVZRR/v1GL07ZLsQZP+f8UUHocsIJY0A
	==
X-Received: by 2002:a17:907:6d27:b0:abf:7a26:c485 with SMTP id a640c23a62f3a-abf7a26c67fmr190821766b.50.1740974809390;
        Sun, 02 Mar 2025 20:06:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmtrdRGgr7U86+kr7f7l+xUDJuXUAyByaCCPcM629oXjBKkXRBVGvEXjN66jpswo1w8JgxuIRD6C81df5Lbfo=
X-Received: by 2002:a17:907:6d27:b0:abf:7a26:c485 with SMTP id
 a640c23a62f3a-abf7a26c67fmr190819866b.50.1740974809047; Sun, 02 Mar 2025
 20:06:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220193732.521462-2-dtatulea@nvidia.com> <CACGkMEuUsh-wH=fWPp66XAFeE_xux-drf1gatSQSiGuS_rO_zQ@mail.gmail.com>
In-Reply-To: <CACGkMEuUsh-wH=fWPp66XAFeE_xux-drf1gatSQSiGuS_rO_zQ@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Mon, 3 Mar 2025 12:06:11 +0800
X-Gm-Features: AQ5f1JqUG0YYBVOhwWGb6YuP75KRc_vcIL7Lh2pD9dN004pjvXLXIThnUsVJvbs
Message-ID: <CAPpAL=zfKkWD8BVio__qHezhs-UDht6rq7mp6Rn5Z-tQG8RW6w@mail.gmail.com>
Subject: Re: [PATCH vhost v2] vdpa/mlx5: Fix oversized null mkey longer than 32bit
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, stable@vger.kernel.org, 
	Jason Wang <jasowang@redhat.com>, Cong Meng <cong.meng@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this patch with virtio-net and mlx5 vdpa regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Fri, Feb 21, 2025 at 9:13=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, Feb 21, 2025 at 3:40=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.c=
om> wrote:
> >
> > From: Si-Wei Liu <si-wei.liu@oracle.com>
> >
> > create_user_mr() has correct code to count the number of null keys
> > used to fill in a hole for the memory map. However, fill_indir()
> > does not follow the same to cap the range up to the 1GB limit
> > correspondingly. Fill in more null keys for the gaps in between,
> > so that null keys are correctly populated.
> >
> > Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > Cc: stable@vger.kernel.org
> > Reported-by: Cong Meng <cong.meng@oracle.com>
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
>


