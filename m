Return-Path: <kvm+bounces-40064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C42A4EC11
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D9A8E375F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494CD2BF3FC;
	Tue,  4 Mar 2025 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdhlIxQ+"
X-Original-To: kvm@vger.kernel.org
Received: from beeline2.cc.itu.edu.tr (beeline2.cc.itu.edu.tr [160.75.25.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21482BD5A1
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741108698; cv=pass; b=EDuwttgEKzQTZqHKkI91gUPH8zDN+XqKpXrV6yljQ4v8dngtpgoTx87TrAqdpMM3uUW2hB4oA/KJCNLRCraF6z5+9Xc8Mf/eZViEhU8ZORJmpDQl9WOSFv7FCwz2Cbrdc3oBY64Gixp/lR3eBURWmh8ezxoegqGtEPlLufoSaic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741108698; c=relaxed/simple;
	bh=hO/1w0WIreFcCNOGOIiuvQHBGfGmx0RKyWkuiZ5OENQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZl7j/B9gSdMfA3vjE1DmIxEbioNfikS8EjDklqivzhcTG9EpoXw4jE1OZHl0uyWCm5ISxSNmslP8xBxR6aS+7sz+17a/yFfkcFBd7CnYDTVpCLFdBjmVvbht02YdYAxWmcajy/Z5Bkv3RHcsgakdVWchcmlyDKI016n2jWGbSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=none smtp.mailfrom=cc.itu.edu.tr; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdhlIxQ+; arc=none smtp.client-ip=170.10.133.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=pass smtp.client-ip=160.75.25.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline2.cc.itu.edu.tr (Postfix) with ESMTPS id 23AAF4089524
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 20:18:13 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Authentication-Results: lesvatest1.cc.itu.edu.tr;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bdhlIxQ+
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6gTZ4kNyzG2H4
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:03:46 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id 0137C42741; Tue,  4 Mar 2025 19:03:31 +0300 (+03)
Authentication-Results: lesva1.cc.itu.edu.tr;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdhlIxQ+
X-Envelope-From: <linux-kernel+bounces-541273-bozkiru=itu.edu.tr@vger.kernel.org>
Authentication-Results: lesva2.cc.itu.edu.tr;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdhlIxQ+
Received: from fgw1.itu.edu.tr (fgw1.itu.edu.tr [160.75.25.103])
	by le2 (Postfix) with ESMTP id ADCB04281C
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 12:29:57 +0300 (+03)
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by fgw1.itu.edu.tr (Postfix) with SMTP id 31A4D3063EFC
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 12:29:57 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008443A7A56
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 09:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EE31F0E4C;
	Mon,  3 Mar 2025 09:29:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5E6AD27
	for <linux-kernel@vger.kernel.org>; Mon,  3 Mar 2025 09:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994177; cv=none; b=pmxvk+arnf9WJ2Be70MHzfvqAw8d52nYoLs9NE2BT/yhPMTnBVZrd8n/Tz5oedUYAzy/nen/1dK6Pa9TvKdYkC45rY5EzAEpN5Kk40lHTWK+QvlM9ivCFJ9MAHWFqF8cuPwAOaWDu/nIFPt3ANLygka9eFJp5fSG/YbanD7/7YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994177; c=relaxed/simple;
	bh=hO/1w0WIreFcCNOGOIiuvQHBGfGmx0RKyWkuiZ5OENQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/9rldAhKnRgUZKPedmtdETE4op8oXQ808cnwP54/sKHi04gMISqCfYJ/BwRFIxkmxWZuLNFEgfMfPAUVjfreEBaWGa4jZe65xMuj0B96w4rq5LDU8y+wOzJSv0nOB9qamIb1KgN4IW1yyPJ3PxDyEs6u3OIC/Ji040c1IjA4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdhlIxQ+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740994174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dm+Ad9vtaxKH6b/jFWjk7lOEkc1nxwN4lmuVSAb6Ah0=;
	b=bdhlIxQ+fjll9LbqpU7NQS6QgIISeDczyHOHsERwPUYy7zo6FFCQpmIX++GEa6bFte5IzC
	990mvIFsNyaD6fhBfuSrP01LH11fp6XVNPFaxP4Rvv8iC0QPKDY3qascTVltloejJodAZq
	e/v2kLme4sp5TiOG/FBR0/J/pJSv50o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-kQtZvCu-MsCOdHBpXw7VBg-1; Mon, 03 Mar 2025 04:29:16 -0500
X-MC-Unique: kQtZvCu-MsCOdHBpXw7VBg-1
X-Mimecast-MFC-AGG-ID: kQtZvCu-MsCOdHBpXw7VBg_1740994155
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22334230880so57890955ad.1
        for <linux-kernel@vger.kernel.org>; Mon, 03 Mar 2025 01:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994155; x=1741598955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dm+Ad9vtaxKH6b/jFWjk7lOEkc1nxwN4lmuVSAb6Ah0=;
        b=EIN5IcA40gGEXeo0d1EebsGZ/JrMvEDuu3djIBVakuTCfU/+8xvf8stZ1EPMZ8YMhn
         5CPfeEO/DuyS9fPRdCB/CXE8x2vwScJVwJ6TjyDTSW8Tf3M5oFlDxRecc4Mvtpz6Ru89
         wW6aF/K9BoZuWRoWYpOTqPbgg6TSslyPODjLSg3fLA/1fLBk5XZ2ZQA2N863KRURpanU
         40mOumU0GNTj52oQQnfXvv/Kp4MNlJco3cr83gNogm8zicheT2iQyJHluIwjz6My6C7b
         k2cOmJynQinNB7rF6DkOPTWEsRqiRNAGFX/sWUEj6cTGkH4r5kv3QmC7xFxwL3Taivby
         /sCw==
X-Forwarded-Encrypted: i=1; AJvYcCXeHqAzQiD1fIX7ETDvyXT/KoebIT1tO1fTPPUOChzC+06FeO6FHo8K/zbrt+Fo1wEc+avynWu5K2n5CZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWk0prGDDqTWNrMFeBrtUA2gbk1Eq3hdxa46lMqIZyypkg0zTI
	9hlV78oV8+n73TcT/r+Ygk2Ndy/b9opsPppKI47WDyRMsqZc7DAoLIMZqFh3PZ74Zc52Cv6Nu48
	hXoGiNT47HJaHMhc4rcDLCeW9WbtOcUUH3d15A/7/l0J1G+iHcWYhea7N8xHHaeCpCU2WNRGtcc
	cUi0TkSe/4rI1dP7iBmmYO/8az/1IbF2TC2Mgk
X-Gm-Gg: ASbGnctnIBr9UrM8QwnBwqmxZCeMg3uDmIaSY3M45421kgtTssUQOCkixRgr2KvtEa3
	KzK6pB1Qwz6BtlQcb3jZBXoVQH81ErSI/01Fcl/bFsr9GcTNpBAFg7NLUa8ZZJ9Sodp88hIo=
X-Received: by 2002:a17:902:f547:b0:220:f7bb:842 with SMTP id d9443c01a7336-22369255811mr196196075ad.42.1740994154027;
        Mon, 03 Mar 2025 01:29:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeh8T/Isef6u47m5QPpp9NHgJMkJl3dnUE8Ylea44Ny6EY1sjUVU9fZMYGnxlnkM9rFe7Jpp6zS4k5VEsVFKw=
X-Received: by 2002:a17:902:f547:b0:220:f7bb:842 with SMTP id
 d9443c01a7336-22369255811mr196195835ad.42.1740994153774; Mon, 03 Mar 2025
 01:29:13 -0800 (PST)
Precedence: bulk
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
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6gTZ4kNyzG2H4
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741713368.11371@Wl1X/Qhh14hhTrdnXBJtHA
X-ITU-MailScanner-SpamCheck: not spam

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



