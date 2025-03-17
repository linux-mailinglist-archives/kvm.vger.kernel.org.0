Return-Path: <kvm+bounces-41155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3291CA63A28
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 02:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B16693AED18
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 01:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBE413C8EA;
	Mon, 17 Mar 2025 01:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICzomQ58"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF235674E
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742174722; cv=none; b=sXvf2Fexcw9nYgVIUw7af+c1wXTRVmstriR5y5zTBdqW7KeKhB3o0NGaYU9jt2mekExUdEdQ0SgPLG4kCJe74pCnUZS4Ne3mzHokrL/F6gufj1V+B7gUWdHeGIchct+NrlSawL6wUaYqwlq3Vanlxsj484f8bXA4RfPAPtmqRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742174722; c=relaxed/simple;
	bh=z2j4KcJQv7zmf0c5iq2uhZ0gNgD/LlN6plFD8qvMa68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N3gIKtkzOpjbxhU163SkIcNdYkPOzjlSnc86FUVxbWi7OlgiOL28+9COze4Mickk23TLD8+RtLWUM0YQXZf4uASUIRISgwTK7IDaKJa8UNWV4m5D44XX7pnErPbM6G8UQK6QQWJJF8wDFqxCkW+WuA9u4ckDCBb5Xlqzx5fdaoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICzomQ58; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742174719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z2j4KcJQv7zmf0c5iq2uhZ0gNgD/LlN6plFD8qvMa68=;
	b=ICzomQ58MBgRwCTb4onufFl5uy0tSdeRRLR32yV5VdC7lFQHc7JVkYooX5NOaqK2mS1tlJ
	rpeiJuGO9Hd0QogC6HyWe0yQ6kUSXYoVYLPS9Pe/sJibqPWk8jhjGtjeFokKnHZ6NQDO3j
	HGRH1LdQvG5IWpMmemL95tGOK0rfVWY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-x3jiMjsBPhWHjj9RIuRb7g-1; Sun, 16 Mar 2025 21:25:18 -0400
X-MC-Unique: x3jiMjsBPhWHjj9RIuRb7g-1
X-Mimecast-MFC-AGG-ID: x3jiMjsBPhWHjj9RIuRb7g_1742174717
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ff581215f7so1526305a91.3
        for <kvm@vger.kernel.org>; Sun, 16 Mar 2025 18:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742174717; x=1742779517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2j4KcJQv7zmf0c5iq2uhZ0gNgD/LlN6plFD8qvMa68=;
        b=PGZterbiHBTenPySx8G6lTCR89++Z5zapMSCJ+eT9UJgUDjO02ckplEibZ+loV5D44
         +ru2y5pEG4sL3EuEVsWZbWyySNUgyoqNf0lwJVIUpG31CmOtvVWJQALPph/rQvN+q5BO
         8kmaGXbGVvkMw2lYs9v8lj+F+TE7is2VLRQ1yxI8SPquRfnxOlqmBcdi4xbt7/z7Ju4W
         ukblierW0RWn6ky+ZMYRnLWXgR6gzUSwQnUs05FpoeYvzs5YcZBkTGcTRsn/VfPymsuY
         umdd1ICl+7GT9Nu11g+VSoKnp8oJ9TJJS8jRATnjXV8lQwrx2AdfX46EmFjq3h0Le4zD
         9dkA==
X-Forwarded-Encrypted: i=1; AJvYcCXwj2pETDTdU58P9soOBBXDayfhcs3OJvHB7ikuhW+OYgVedPD9PAwppJCl2p0GEyZjrCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx01d1HE4I0MUXR/OSi47qm6HEImw89MMH/J7Mpiv1IJpg7uoP
	cEGMbMMVcO4P9LxR/JYC0fRnfSQoFGUE51QKcuOUf788QdtFowELyXiPW6nDa2QNn30qOavZ3fY
	N4YZP+mo/lE6cWL456EhVogMpM8rC1XFQYrkB5rBJn3aDcc48bo9hn0HNyBBEDAg3+Cs1k4aXam
	LpQHXyGS34VCaev2/423ALGolS
X-Gm-Gg: ASbGncsK6RJanyrfn0/m97HX5aNPpxQCv7fhy3sm0cOZNv/dWsnSYWEP0W/RZGUl1oV
	sWvbBkS55YIlhYB8Y32v+MAOH9gCSBC/df0VDG5B72I1AFjmgwKy3oIStUzKHkk8b78xXyb/eVQ
	==
X-Received: by 2002:a17:90b:1f90:b0:2ff:4e8f:b055 with SMTP id 98e67ed59e1d1-30151d820f1mr12979538a91.35.1742174717401;
        Sun, 16 Mar 2025 18:25:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhY7Q6CEBtn6gSdQV7+N48LRSWSFUwUYTebXNWN8iyFQF0YN/QWMy1GYMr8eTv0NQFETp81q/gb2zZs+fo6Uo=
X-Received: by 2002:a17:90b:1f90:b0:2ff:4e8f:b055 with SMTP id
 98e67ed59e1d1-30151d820f1mr12979510a91.35.1742174717010; Sun, 16 Mar 2025
 18:25:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250313-rss-v10-0-3185d73a9af0@daynix.com> <20250313-rss-v10-3-3185d73a9af0@daynix.com>
In-Reply-To: <20250313-rss-v10-3-3185d73a9af0@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 17 Mar 2025 09:25:05 +0800
X-Gm-Features: AQ5f1JpE0rK7CwWDqP6FbtvINFxO-X4ILccNQzNMTQCiB6CvQEMSnvUz3v4UdcU
Message-ID: <CACGkMEv8g6JNvGCy95x9jRD893qBvhztkCzBy9sFz+9N6A69Bw@mail.gmail.com>
Subject: Re: [PATCH net-next v10 03/10] tun: Allow steering eBPF program to
 fall back
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 3:01=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> This clarifies a steering eBPF program takes precedence over the other
> steering algorithms.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---

I think we should elaborate more on the advantages of *not* making
this implicit.

Or what's the advantages of having RSS has a priority than eBPF.

Thanks


