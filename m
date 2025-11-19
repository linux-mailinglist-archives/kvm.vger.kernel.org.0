Return-Path: <kvm+bounces-63645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE59C6C4DD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id EEB232BA51
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E782A25334B;
	Wed, 19 Nov 2025 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHfBhFGU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbSa6r0n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6691ACEAF
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 01:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763517211; cv=none; b=nO5uarQeXTTu+yitMEra1idf+OkUUiWE/eme7jRRSxiw1+saZJ9z6SRz0Ry2WD4yy5cScWGlSupclo7IbFEVL/CfK6sNobUIU9gkr5zMaAv3FVmKgr7fAkGibA9ZH1XSZuPinawhf9BRRYkSawb5QL9gmZafQBF70A4OIR4Xq1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763517211; c=relaxed/simple;
	bh=KyrZzK9mqPm9s39/r9lrWoYLT4pjxbJQMQSDqyYyq8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLIrB+A40axuD/NGQ3W8IzY8oAHG8skLJEiy1B7tbOkI8cmXax1POX3+R8JOVZ9eF2MYiERfInfqfXpFzx1Kq1OqBqvlNQ7R3ZZJQ4J7YWAgVV8YbjNVomnDI90AFFA3nRB2oVbKstzLV4ovE/98S/hJqPf0nmEg7rbH//0whZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHfBhFGU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbSa6r0n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763517207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KyrZzK9mqPm9s39/r9lrWoYLT4pjxbJQMQSDqyYyq8Q=;
	b=NHfBhFGUNvA0R/JeeSMowgOUJvb1NF1iVTcG49Da/cYvayxI3H6lctjfIbFPaQ1dgix2RO
	jZ6lLmkP1B3pbDzfkCOpUXL0CYEeIOT8UyvlaBbtrcvyVaX1qZ7O0KWCTCcv2rroi0wypx
	3XLGsKZKnlw2i9FfHSwYxOOyTA7gUmw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-z0DAU1fOOASwfAyQj9PBOQ-1; Tue, 18 Nov 2025 20:53:25 -0500
X-MC-Unique: z0DAU1fOOASwfAyQj9PBOQ-1
X-Mimecast-MFC-AGG-ID: z0DAU1fOOASwfAyQj9PBOQ_1763517204
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-340c07119bfso16281484a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763517204; x=1764122004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KyrZzK9mqPm9s39/r9lrWoYLT4pjxbJQMQSDqyYyq8Q=;
        b=dbSa6r0nkDdbm+V5KCUkhCTZxbROcrLh0L+HY42grllXPmzS17SgzS36oXf50q4R8Y
         ywLUo/UoUhao0gswGVS2/79oQRXE+0FhQTy/kkysag1NbUOaWL0Y1IhJjScckP3HC7+3
         bM4aZ1/x5BeLKkLknumpdGDPXOLCmSliZ2jKUb4OfZUlZtwYYeRA/jkYWdJdweFLP1vA
         MabGVR5F3uM6g4xCANkfuvr4cLiaRdxSx+HzeRx049Xwbk9FL5QF11CcgMDLhccqFaed
         gudX08bOP5NQ/vVkDz5VZRM9EN76AUvVNeNGb5jQTYJIBzxZdYsUX/QWYMMTnbgsIEC3
         cysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763517204; x=1764122004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KyrZzK9mqPm9s39/r9lrWoYLT4pjxbJQMQSDqyYyq8Q=;
        b=X8xA3N7MSwOSH/BjREH+KRJLncFMLMF2zepOPf3LIxRY+RltE4CIcjUuT7jbUPG8/R
         ijmKf5RiSnG5buyDhMFwOM0A7iyKXQjYx1Ac1ZH0k6EwlAJlmkIv3utzW6wntXd+Se+d
         G2jvQoVLDvIkpbqCpwr99zktk7nnjhN9U0xRne31ZywF/FjAhe1wFsQ8hgJwz057Vvsq
         /VY4tN/bqLZAP1CxdEkRXSsyQtmNo14B9R+UVa6DPF7EgoiCtvzYFF05bK6EIsRALp2B
         AcSjFzASYwUyp2S4Ofs6A2fVm0bzEb5loqjcpb3GS+BReB5y4GiIO4S+s8kKEHACV2IB
         ggYg==
X-Forwarded-Encrypted: i=1; AJvYcCWOR9aq2tP8CEgU2plGPs65LBEgJ764p6OYrKNsJa0LNh6UN7WytX/KDkgXGcCimDQ+zUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDMLfeeH2zxg3J1DVbWIfPDGqHQyKDVpdcRvrgNzoUMGhAyGPa
	us5tV7KSR2ztaN6AiS0lRgNuPcTBrM+fjRC75gi6U66aS7rNJ0JYxfOlxEMmdqnTN4g6uG6G/TK
	rvYezTj7J0Z6dFa1vlVNsDE+wUqMyXV0myl4QJwR2JnZTaUdzHkphBZT80IaDNuVyFBNiatlc6y
	c6HqQoCY51f18IGu/xq4Pj2Q2FYRHb
X-Gm-Gg: ASbGncsGTqOkyHTiBisi2gIinCkje98XrkqJRIF3AHQpW0teMVOXeRbUHWQWMll5XYa
	YD1xVS7QvC5vG3wGLRRU6sfAGA4gDjrH+uWjNPxt/Xq+6oek8P8upJ2cN2HI50IlKi4Vn5JqoSl
	fB5CLnGIMbNBhHyNDDJz9TcEy4UwiLeSgyOBER3Fan7Az5SskMeRY9UOzXjoGqAAs=
X-Received: by 2002:a17:90a:c2c5:b0:32e:a5ae:d00 with SMTP id 98e67ed59e1d1-343f9ed96e7mr18500456a91.13.1763517203964;
        Tue, 18 Nov 2025 17:53:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGK0BojLkbLsinUEMLK9poTO5T3VKUI0LJ7vBrGV4ZQeudjfClMdb+kGPfFRQFUzDtww/LkSD4FupuTf50Ci1E=
X-Received: by 2002:a17:90a:c2c5:b0:32e:a5ae:d00 with SMTP id
 98e67ed59e1d1-343f9ed96e7mr18500412a91.13.1763517203120; Tue, 18 Nov 2025
 17:53:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763278093.git.mst@redhat.com> <67ae57499e779aef2c5bd7ee354af5d4af39bf60.1763278093.git.mst@redhat.com>
In-Reply-To: <67ae57499e779aef2c5bd7ee354af5d4af39bf60.1763278093.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 19 Nov 2025 09:53:11 +0800
X-Gm-Features: AWmQ_blKYAEU3q3XwJg467m-DKxSN_o3KNaIqr46lnM6uOA9mljHAoG_O8bYpVw
Message-ID: <CACGkMEvgQmUNVOzceNscLJiBxUiJDwJeST4Fe4Up7yBgbpxu4Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] virtio: clean up features qword/dword terms
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, 
	Paolo Abeni <pabeni@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2025 at 3:36=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> virtio pci uses word to mean "16 bits". mmio uses it to mean
> "32 bits".
>
> To avoid confusion, let's avoid the term in core virtio
> altogether. Just say U64 to mean "64 bit".
>
> Fixes: e7d4c1c5a546 ("virtio: introduce extended features")
> Cc: "Paolo Abeni" <pabeni@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Message-Id: <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@=
redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


