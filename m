Return-Path: <kvm+bounces-40126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9324CA4F5F3
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 05:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E672F3A9C20
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBFF1A23BF;
	Wed,  5 Mar 2025 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hc65uFJ4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBAE1A5B8B
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741147753; cv=none; b=g6Q9I2W5iafjNKgog0vcsfNqgLrn1KJ0F/gh4gbo0d6A62G3SU47MW0jln6BtzD1vE4ohGcJmmp1X49B6/ExRecD3E5TWpxRbvslCeRtzGwmQc5KsqWH2Pe4dye1IFmrOM/upEQWvBiUl4caytYtf6k9K0CnZv6QAgGi9rTtgR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741147753; c=relaxed/simple;
	bh=sl3kF2jIRgykOyy13qNEYv7/mlV05yVeWOFjVH+qAtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXf6PUIQJm/OoGLYjW/QhgMDXsCr2WZ+6XKdU/cIUO4UdzB3hoFT4YGZIAGsLV36kNhgHXbQkjz2dV9usmYFEVo3iux+P6NdcmTwgYLTOYhouS7BOPpYIEsWU0lwYx2b/wU2Qukq5hH2zPJk8pvtffjEajxu+SIdqPVUnHg8SwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hc65uFJ4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741147751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sl3kF2jIRgykOyy13qNEYv7/mlV05yVeWOFjVH+qAtU=;
	b=Hc65uFJ4lzCEOKpChJX0j9NJSRQi0YzkgbxtkSM4vG4jTEkqqPRAck6wuYyixFhz3CsOP0
	XjkamHIbVFuf7+j/YNtSIFiksRdzHeQItEjRORWY/IMjl6miJQgnGuvddYySVZZTzApEUF
	Rk49GBK+HUz9R568MAjKazF340sVQkA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-Yw6VbydgMIqJbxxtiA5sSA-1; Tue, 04 Mar 2025 23:08:54 -0500
X-MC-Unique: Yw6VbydgMIqJbxxtiA5sSA-1
X-Mimecast-MFC-AGG-ID: Yw6VbydgMIqJbxxtiA5sSA_1741147715
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2feda472a4aso6861974a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 20:08:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741147714; x=1741752514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sl3kF2jIRgykOyy13qNEYv7/mlV05yVeWOFjVH+qAtU=;
        b=nBWbDIyr7VbqZdhEA8Ist1wqlGx0augtvEv00SdghRx0hWVjcqCMSjersbprcOkMTr
         DALv4+4psi//tgV2eEofsCSJ509y64Wj5bS5UmD5TnAZNC7wM4xxK1ugKe8jwu4jMiL2
         6E9wrGiZTJ0Z6m6eXSTpdtXlUyKp4cGRoP/2VBGFuQKoq48F54wEO8G3hnLFb0UJKMMh
         IKCvufPiYa4rG/S2QxLaR39WUMDahbFmMALDP0T2o2tv/ZGYK2w0Sz3//h6DtL5dzOXt
         4byXlNfNA9SYDDqsgAdy3ZJYEfwPRlJL62hDFkjvcaRjkyIvxmLNI2vcc+errHVgeqhJ
         2tpw==
X-Forwarded-Encrypted: i=1; AJvYcCXSkUHJr+kVWPRkpxp+cXRrLyiTiVDzkZAEOEVI0pHXP9tr9kHkFAaTRXSswF6V0EjjY78=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcTFdDDZO2HIJGtCpZFuDLBVCG3Omzp2KMQevyb+QKe44Uytd9
	nETQf6LK7cpp2dGLmE+jkCC6jteYuLo1uaIbQaY4JNEl+cftotJqmIEIJo5XCb3DhIKqtTtFJm+
	CP0m9f+8imgrRfQ1ld6y1uV+TYaxvpY5e4j6ykdP7MNmqgJe5OHXBAUaEkSE6QSTZlya+/xWWNJ
	npZgLCXdknfpkaqO4raHQo5MGPX92MguhZzj4=
X-Gm-Gg: ASbGncvQ+X1A3EwNSrHpTgsDdySTSmYRmAn3PA892cIS0/ZGyUKL7lTk3vDW4yaKZ5U
	j2l7IKdfidQkWEdRjAKolcG84cbO9IK8uY3BPA0BVzFwaGp5X5qNoZNFb5JrrxO4FL0HkwPrfZw
	==
X-Received: by 2002:a17:90b:38c7:b0:2ea:3f34:f194 with SMTP id 98e67ed59e1d1-2ff497a94d1mr3253877a91.10.1741147714159;
        Tue, 04 Mar 2025 20:08:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRhAjiy6oJgdTVYVOYk9K5LcroQa6MmEtafp7KA+t5KO8Pe7O1jHU38xtYt3z4pO+pz1vuRaGm1QENB3uSDNs=
X-Received: by 2002:a17:90b:38c7:b0:2ea:3f34:f194 with SMTP id
 98e67ed59e1d1-2ff497a94d1mr3253847a91.10.1741147713755; Tue, 04 Mar 2025
 20:08:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303085237.19990-1-sgarzare@redhat.com> <CAJaqyWfNieVxJu0pGCcjRc++wRnRpyHqfkuYpAqnKCLUjbW6Xw@mail.gmail.com>
In-Reply-To: <CAJaqyWfNieVxJu0pGCcjRc++wRnRpyHqfkuYpAqnKCLUjbW6Xw@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 5 Mar 2025 12:08:22 +0800
X-Gm-Features: AQ5f1Jr9X3ymlwY6PrZDcvmZUstskG7PfMhNEYJbHpQgXjCqpakU8L3BFGy8d0g
Message-ID: <CACGkMEtycEX=8FrKntZ7DUDaXf61y6ZE4=49SmQu5Nkh_tf39g@mail.gmail.com>
Subject: Re: [PATCH] vhost: fix VHOST_*_OWNER documentation
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 5:29=E2=80=AFPM Eugenio Perez Martin <eperezma@redha=
t.com> wrote:
>
> On Mon, Mar 3, 2025 at 9:52=E2=80=AFAM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
> >
> > VHOST_OWNER_SET and VHOST_OWNER_RESET are used in the documentation
> > instead of VHOST_SET_OWNER and VHOST_RESET_OWNER respectively.
> >
> > To avoid confusion, let's use the right names in the documentation.
> > No change to the API, only the documentation is involved.
> >
>
> Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


