Return-Path: <kvm+bounces-9373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF6E85F5E9
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DF761F238A9
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14EA3FB03;
	Thu, 22 Feb 2024 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsl+0PXl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8422939AED
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 10:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708598539; cv=none; b=QAz5LOccTvYol44omFnPzcV08xSq9YjeJm2H8fDCkxI547J3QLTnPI0mmot8sHgvMrqku40txr5ZgsJE61j1BcJqOMRWtnjqXi+ckVvWDfJ+XmmTqNhG1r1jz/9HaY+tAYecVKlD/ZYexvT65XxC6LMGMAmOpSDdepZBDvX10bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708598539; c=relaxed/simple;
	bh=Wr5ytHS/LMlDWoRnSdVRq/OpKXEKN1tbEGP4/UioQ8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVvC3bNWconA+qqBOyHSu6c0y0B3MgvHepqndUshJDnctTNSldjwdI0hTRdj6HxJbVl9VHxEHaf3qkBE71rnirUEgWi7Blnf3CktfjQRlQd/f6eBupmTw1ZLz36irOrVnMQd+RdovTYwE/prus5jSl+Fz6vU/VCeLOJuqKnrc7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsl+0PXl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708598536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IVi5xtqagqhQr4yQkZ21VVqriPXn5rhJhhfioOmJJms=;
	b=dsl+0PXl7xUQ+poY/ZuamV1NQgy3wUnIGhUtwp2xHAfyeLLR2OMkOoRU83G67kHo8BAQ3r
	CdXjMkgiFRKG/+a1D2ISYVCQhmWR1nhDs9Ye+Pbzxi1/TaIA2SOrTtT4bgET0nJMEVcIkr
	VU0tpT1U2eunmrso3SOIgXQZVYiYgzE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403--fobdh60M1OnizOdfyUmlg-1; Thu, 22 Feb 2024 05:42:14 -0500
X-MC-Unique: -fobdh60M1OnizOdfyUmlg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d10bd57d7so2597146f8f.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 02:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708598533; x=1709203333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVi5xtqagqhQr4yQkZ21VVqriPXn5rhJhhfioOmJJms=;
        b=aORqgS8jGjGr7XN5jMrS6U85FQyDWQr17Ata3hqYhrkbuSrOko6G1fY8VWna2RlseM
         7ei/DLDBUr4PLb4yQtQ7dr9TRvqoiYdhutU9sWn3VPrGEtPKVP5JFa8v0+t5wa2k5SNc
         u8SwgY1sLpdlHWqFpoK4btjqtjxnoOReVBFDch0HjdrNwuuqAMGYRZuKilBSbZIX9rz5
         q6ch2Ko+HY0tTf3JRR0W2elNs7ktRaJEyVjMtsysdwnZyJhS7UhSJAMsEdvgyYyk0jzc
         fZl0ipIZ3h+Fo0bk8LUxAaGJpwYr5mABDgXiFcW1jePAQ3IHg5VNFfE8LHh3w71JlGGM
         NryA==
X-Forwarded-Encrypted: i=1; AJvYcCVaY2cBCkipr1IjgfKU5MVcL90lAJeURy0f4ylQkTqovgITE3KEXJu1JhMhKs/hbOUC/wOGz609Xud8Uy9c4qur3Eub
X-Gm-Message-State: AOJu0YxZNJobM8ZNzFS5vUW/ilZIEdFTk/3zQPaU6f+GRn04naI8YGfm
	kjeFtcbB/SRSypvkuM99CW3jmYMAsZLda3uCWoAqaBOQtbDu0wwNfXvC/nuZxqeQAheJsbuV/KM
	AjR1PefUowth+TmXTF3/yk2bS0MOXt3GxHQ1ZtTwcXt8OfDzUL+8gqp0ISbfvaBBwDsuMw2G9bh
	hYveJwVVNIMcPQbE2KYBgDfPXA
X-Received: by 2002:a5d:4850:0:b0:33d:391b:8db2 with SMTP id n16-20020a5d4850000000b0033d391b8db2mr9472699wrs.61.1708598533671;
        Thu, 22 Feb 2024 02:42:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFt816+aUtSBUADBI4CYXrHxRHYjhYyzfPh3WwqLeFMhlmXg2tNA3B2shw4FqT67BiVbto4PUojvsiihkGZ5Sc=
X-Received: by 2002:a5d:4850:0:b0:33d:391b:8db2 with SMTP id
 n16-20020a5d4850000000b0033d391b8db2mr9472691wrs.61.1708598533378; Thu, 22
 Feb 2024 02:42:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222145842.1714b195@canb.auug.org.au>
In-Reply-To: <20240222145842.1714b195@canb.auug.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Feb 2024 11:42:01 +0100
Message-ID: <CABgObfaDQMxj9CZBzea+=1fcFQXEemAJoH5Jvc9+tfiC7NAvrQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the kvm tree with the drm-xe tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>, Oded Gabbay <ogabbay@kernel.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	DRM XE List <intel-xe@lists.freedesktop.org>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:58=E2=80=AFAM Stephen Rothwell <sfr@canb.auug.org=
.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the kvm tree got a conflict in:
>
>   include/linux/bits.h
>
> between commits:
>
>   b77cb9640f1f ("bits: introduce fixed-type genmasks")
>   34b80df456ca ("bits: Introduce fixed-type BIT")
>
> from the drm-xe tree and commit:
>
>   3c7a8e190bc5 ("uapi: introduce uapi-friendly macros for GENMASK")
>
> from the kvm tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Lucas, Oded, Thomas,

do you have a topic branch that I can merge?

Paolo


