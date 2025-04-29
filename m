Return-Path: <kvm+bounces-44653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 491CEAA00A5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F5401A84257
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C13270EAB;
	Tue, 29 Apr 2025 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="boH5feWJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E131253341
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897841; cv=none; b=cOUwH/RwPLdLCjtomfJBHskc+tP8hiyJQain/NgDPAPjYIf4tMkuwUXm2RrRKKDvZl6otJGQTw2DwbAeJsoHso1K6PgY2lKJEUcxR3UFN5xWUEuY1atw345Vdyhk8R3nr6ABp8jr1L837FOPZz9HnHfZ8l80MvHoNquuawxNDyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897841; c=relaxed/simple;
	bh=vZnrLPvp1SezavRSb+3blfciooE35zWcwCY/HASVrFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Df9Ukp7JQDTlVv0ymvD6RKsEFpx30jsMNcGf8vEiB2NV5N+RephariCorQPR2zAt2jLxdP/tVKBfw3jrPueJX3ehIhFoTJpWsv4VfgfNDlB4+xnFVNnJYq35xYIsmoq+YInsFYI3AdD8Jti0cScw/K1YBwSrEZicClOtkXmqwWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=boH5feWJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745897838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtBx4B5toFccZ4nF29kycNJ0OC1KNDOrp48cQ3Ehw34=;
	b=boH5feWJT5Z4lS6HyrV6ftSRPQ61Ydqo/qgkuTnejJA6A6qHDAWXXK7C/1Xe+sjE5WBroC
	AcjzteHT0/Qc3FsLodoefbFuRk8mZAkp2BpK1O7kTetJ9/e4g/bSrAYSiaZNU/W2Zs2VDU
	uK6gCVXQ1nLJkZUH7T2ngMQ6BMw4k0o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-Kelp1yO5NbWKqrlOJX8B_A-1; Mon, 28 Apr 2025 23:37:16 -0400
X-MC-Unique: Kelp1yO5NbWKqrlOJX8B_A-1
X-Mimecast-MFC-AGG-ID: Kelp1yO5NbWKqrlOJX8B_A_1745897836
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22406ee0243so38065565ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 20:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745897836; x=1746502636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtBx4B5toFccZ4nF29kycNJ0OC1KNDOrp48cQ3Ehw34=;
        b=R8ubVbXuHCS6oSb3LVAG3VRkYnOqfQzo2DmXKdSFoOq0DkWe+WGTes5+DaFCP3ZfuN
         q9rASDIp+E8ljByhH3PyjNYvTQwABFTN9iGqCt72W2+gIlKC0byTWt7SaaPHOE/kv0zf
         58KUp3rYwIhrVLA0EGnhoGiI2UXppS3eB5btzbrq5OpOs55zaAUEZ6aFskrkDE+ZW+ks
         DE2ZNbnwpG7a0IyaWK/D6hStilFuLay5AfXVHPr6Sq1Y/LBBEP34nhlnTbzQq0Rk34r9
         //d4traAoUPgxw3/MfFceFTlArTpOu7GXLLlxCTG6HIA4/1oBRF3o2wusjNItVB2xgMn
         e+LA==
X-Forwarded-Encrypted: i=1; AJvYcCUKiBm1X0iWfZlmYypHFeUumM/XIaLb8Kybg6SpM9vA/YYVkapPiWQcZwZU/R2RM3TJa8E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe0YgI9KYdlFMJWiZ5lknaaArbVOmYZ67MBU6cfeThiWDvaVdE
	61eNh4xeis6Fcjz7bzdA7WTHbnNNy18mJ+PfnJntkPFqOnC8DmOeAbACIwiSqs9Jnun6s8QoZEj
	a+jqprq8SPx6/hW/kJiO8/k+htYswuT9BTLLcKnwjJ403vDn/jZPyDuPJVXURniiJJLr77nHrLs
	XVRESgGS1ca8YIJ0EZ7/m6DjKN
X-Gm-Gg: ASbGncvu3cCwhCrVMor7XgSBL4Qz3ZsEc27VODAK1dDFIZh3t6YNxfJSfYieHQmp6nt
	GeZnG/jsEFRUfJ7io/BN5camcKV8Q3+91rdZX7D5EFmW/zHLUezP+PzHQmaeuPj1WUg==
X-Received: by 2002:a17:902:cf05:b0:220:e1e6:4457 with SMTP id d9443c01a7336-22dc6a0f26dmr163635055ad.26.1745897835857;
        Mon, 28 Apr 2025 20:37:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLe9pBRSxy4N+dD8KJSBtALGak10QhPScgb+yK1nBfP5vXL9NgrfdYgJEs/q16qDKuA3cYH0GoD1aU/5P+RTM=
X-Received: by 2002:a17:902:cf05:b0:220:e1e6:4457 with SMTP id
 d9443c01a7336-22dc6a0f26dmr163634775ad.26.1745897835513; Mon, 28 Apr 2025
 20:37:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250426062214.work.334-kees@kernel.org>
In-Reply-To: <20250426062214.work.334-kees@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 29 Apr 2025 11:37:03 +0800
X-Gm-Features: ATxdqUHKrokOvlJhfFqnRSp5WKJr5Ro9UGb-ViD4ru9HrHYYXv8eFZRyEkZAZdA
Message-ID: <CACGkMEtPmDBsyHTsAMZ7aygPQ1CVELd8H4_1u4ySH4sMQXe=qw@mail.gmail.com>
Subject: Re: [PATCH] vhost: vringh: Use matching allocation type in resize_iovec()
To: Kees Cook <kees@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2025 at 2:22=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.=
)
>
> The assigned type is "struct kvec *", but the returned type will be
> "struct iovec *". These have the same allocation size, so there is no
> bug:
>
> struct kvec {
>         void *iov_base; /* and that should *never* hold a userland pointe=
r */
>         size_t iov_len;
> };
>
> struct iovec
> {
>         void __user *iov_base;  /* BSD uses caddr_t (1003.1g requires voi=
d *) */
>         __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
> };
>
> Adjust the allocation type to match the assignment.
>
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


