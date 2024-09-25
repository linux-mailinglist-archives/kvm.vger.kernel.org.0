Return-Path: <kvm+bounces-27401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0178E98516C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 05:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CE4B1F24A88
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 03:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB2B14B087;
	Wed, 25 Sep 2024 03:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cc50jO1v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22C136345
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727235026; cv=none; b=os6k9sVQ+JPQBjGJhVbcK923sg9L3c6ZwIkTU2ysQFFVm81MbcyiiaUQl132IlUJ2avr1vjpce6BpJ/CxIOJ/nx3Yyc7gUt7ZSwtM06VcT6D0CqeKDmXS6aUImlSyf+LatjuJvq3+Ynk9Q4IPgEv5ZJ/3YBvRzBVaJaE2AyT/uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727235026; c=relaxed/simple;
	bh=/pj+RCuXouKWKKmVNJjkG4mjtgCiJqE6IxJ4EvXxnE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfCOjSV5CUR7IBJUiq9y3kjelj2inSE7Ng4XJ2f7sbxfWY3sc2bZ+5MJVIubHWL+fE8686vn03Ro7MiaXppLau7tCHUs5y/BIYKZbrB9X2MKaBnU1FFzGzgKB36J1vVtvoCGZN+KcE9Y+mEZOl4MflGtspCLLvhDelhm1fPpRqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cc50jO1v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727235024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/pj+RCuXouKWKKmVNJjkG4mjtgCiJqE6IxJ4EvXxnE4=;
	b=Cc50jO1vwKFaEKU2XlDyrbNt/ghI8Q4f7OyGi9IdYTcKsiVT1tASj2oYd0URyrZRUE7e1k
	5Xg3T3sKJYlPAyDMdt9z7r6570YQXa97L6GW7EBMhp5bQ1Y3llL19jXoLqYbkqozaQpyDb
	IvLuAhyly3Iw+ra5b+DjdRpRwy+KIH4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-a7LgYqO1N2io2zHDMY9MoA-1; Tue, 24 Sep 2024 23:30:22 -0400
X-MC-Unique: a7LgYqO1N2io2zHDMY9MoA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2db446a3d28so8951697a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 20:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727235022; x=1727839822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pj+RCuXouKWKKmVNJjkG4mjtgCiJqE6IxJ4EvXxnE4=;
        b=sjiB4x8VwVjyTTGWcyETrqY1J0tBRHuymMgkNpxM6lgN6H/jqGbTgyToPkybPetyKR
         895M+ZRcQtC3UhsoDj2YuZIAsasVks07NMIs7m4cjquz0zxh7qenV3Lc+AHjR4kuibHL
         5ydxA4a4YwThsPuu1YVP66c+ymv/NOmrRXWKQMDdfe+qe5g75SK4a1Wz6WVc3JLI8B8i
         D1Af972VbHexc+xnb9G1js1lG+LDVNY+X1U1nOFQ0GM1PqDnviXSq/QLRIDviO79IpRF
         hhPWc2jtopqgeiWR9wroAIGOKdhF1Xe/FRABeS1NIIZO34/6V2A0f4QixQ4Kfi9TmWs2
         D4VA==
X-Forwarded-Encrypted: i=1; AJvYcCWY+BdiF8GVo0G4CdRS7cjM2Fj88s+nVLJS1bXfbGVMrtacXwT0SBcyALL/8KP6DXmm2EE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyAwJ1OdOBKMtkxeAafSdg0WmXVA9V2ks9slyzD7wng2om5SuA
	ugKSTkfBqRniRRXeYzrz3bSC/WJBiHsO/QMJHsL+256fB++TuHrni1eEK7SouBXVFCwih1hRuhf
	1jKSUaGlGNfyQIBZLRaeVo/ta+NZp1YT9JoZMx3BqvaWWL/3BlGuinVVojliJoq7+uspsqTTEjl
	o7l9cHGzcnFYVdDj86QjZnkki6
X-Received: by 2002:a17:90a:f2d5:b0:2da:905a:d88a with SMTP id 98e67ed59e1d1-2e06ae791a7mr1467804a91.21.1727235021749;
        Tue, 24 Sep 2024 20:30:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt284MvmYUlT8+AL6adgtTv8NmOQ1ld/MsvwYgsNGC040Pi/BgPI1vkZfb6OO4Jtnfla96r8UcK+AJSx61zg8=
X-Received: by 2002:a17:90a:f2d5:b0:2da:905a:d88a with SMTP id
 98e67ed59e1d1-2e06ae791a7mr1467782a91.21.1727235021240; Tue, 24 Sep 2024
 20:30:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
In-Reply-To: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 25 Sep 2024 11:30:08 +0800
Message-ID: <CACGkMEvMuBe5=wQxZMns4R-oJtVOWGhKM3sXy8U6wSQX7c=iWQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 0/9] tun: Introduce virtio-net hashing feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 5:01=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> virtio-net have two usage of hashes: one is RSS and another is hash
> reporting. Conventionally the hash calculation was done by the VMM.
> However, computing the hash after the queue was chosen defeats the
> purpose of RSS.
>
> Another approach is to use eBPF steering program. This approach has
> another downside: it cannot report the calculated hash due to the
> restrictive nature of eBPF.
>
> Introduce the code to compute hashes to the kernel in order to overcome
> thse challenges.
>
> An alternative solution is to extend the eBPF steering program so that it
> will be able to report to the userspace, but it is based on context
> rewrites, which is in feature freeze. We can adopt kfuncs, but they will
> not be UAPIs. We opt to ioctl to align with other relevant UAPIs (KVM
> and vhost_net).
>

I wonder if we could clone the skb and reuse some to store the hash,
then the steering eBPF program can access these fields without
introducing full RSS in the kernel?

Thanks


