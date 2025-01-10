Return-Path: <kvm+bounces-35024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0909DA08DD1
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D84367A3552
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA66020B803;
	Fri, 10 Jan 2025 10:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fLF4owk8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C31320B20C
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736504633; cv=none; b=CadmqxrhZcEAcLAPX0NON6O86i0gD6hw3dTiDlmzSjsOZXkQ7azcEQpAjsR0XN+AicZ4bsB2ceZGCpp1QlNBYpJU4zeDFmZmQbg7/mDws6Qpk29wOh9bfdNwDCO2eAwxJpQiAdvf5lLMaGhRp9OxJW3eWwIP78CyFew16fYc3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736504633; c=relaxed/simple;
	bh=xjzJiHVG1rcoDk2fTADzQ9apBt/E2B/VHNJo4JUJl8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAQ3fyzLgSzSdoQoHaU7FmbYKsXfLNso0cxCtn3ybrnQz5JDSJTRI8WXeRfwwqPFXxGAAcViQ1Kesnb4Tq87pDIGXC8hRz/toBLP1Er299Gpe8ikXGVDLxezySVYKZju89yT35TW91pb28v5WqcICJqB2yR5pRdJYa+011PKMX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fLF4owk8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736504630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jp3bnJiwix2Gu1b46TgPaNYsSc3q3ZVFUH5fpD6tH7A=;
	b=fLF4owk8wLRErACyXaGl1g/X0YnCNIqRnKGo0fvlYSph58SVpg5+qwvrQtkILIWhYF52Yr
	/GkxvjAB5drOr2BSUbjzpczdtuElxBTAX8uJj8f7KN8iMpZt2by6ueDhvi5IcE7KnxX/N3
	V59fjMnevDIiD/MT4av7QXYhDPU2HA0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-kUK4b8yFPfe-PD4NHcFksQ-1; Fri, 10 Jan 2025 05:23:46 -0500
X-MC-Unique: kUK4b8yFPfe-PD4NHcFksQ-1
X-Mimecast-MFC-AGG-ID: kUK4b8yFPfe-PD4NHcFksQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361eb83f46so16661085e9.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 02:23:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736504625; x=1737109425;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jp3bnJiwix2Gu1b46TgPaNYsSc3q3ZVFUH5fpD6tH7A=;
        b=jx2B7NMcMZOAb4HiD3QCT6bg2Pc6uSbP08cw6bvP2hGGc+jXYoMrIavtmfTR7kpccM
         Fm8vD/0fbFpw6oZzNpQmQ5nH7Odgm167nvR9SfRiUIU3mo5u81e3VyGin8oUMzK0kQte
         gZJmOjHRW4ordM36h5NkOJH+qpDifE1fEHt5/1C5s33+CYqJh3ykFSyKFx+uv+WYCJri
         Wo/S4h2cOCUEbcRBb82E0cc9hSOStpHlc2GTmg7kPm/2CNwiM5uJxs+ceEsnllwE+WRe
         f8a1kO6D7eyWJ1q4TZL1mQ5lnhevdrZG6R8mMP2GTBatCFnHd3reu+T6jLHJIVV3WRKG
         x98A==
X-Forwarded-Encrypted: i=1; AJvYcCXQT25H1yGWkpT5LWzbHVaUD8UPZp73hEvY8jxqrPqjeVn8nRiw6P7IsQNv1qprwgsc290=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy91xJjwpWvmb1QVg5ODZ2t2tjqA39g8AFGyV/5eRxvFRI/EEvW
	5WvVTQYaJNJ54acVBTrz4FS+OiKiiMhcyRFY+UxpJXe9/vCEprOrr9SnLhubT5dPfz/55XKIN96
	Bapvd1Hs+bZ2EtbosiuverS346GaqW8P8ehPANqSTNygj1Zoraw==
X-Gm-Gg: ASbGncspUw0YNOWcrV+AfVIflPTZLltvucvHmn2eqD1TWvgDUynGK6Fu0rfBSje/xVX
	+8YBzh10wh3ZAumgIKZfdwF2Ziyoj3VV8VkydhZpIesVbZv3Cf1bBo1olU/dB39/V781P8jd8v+
	etorVZYGu7HhLTQM0jrV6A8LdSAoFe4jAXzvIM1JDx5mLGBvGkAIyfSGj9kF9QsiG52lEYJ0GZO
	l7BT9NU6kSaQy9ygwP+QfZIuJAnTs3EDXtEpF1b+dn4xhr25l9t
X-Received: by 2002:a05:600c:1e09:b0:436:e751:e445 with SMTP id 5b1f17b1804b1-436e751e61fmr82747475e9.5.1736504625690;
        Fri, 10 Jan 2025 02:23:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCfvXG8JypksNxAK+IHkKlFtMebcL1LMAzRXVW08Nh57eky+TRviObBgV58/zlzJhK4cMqJA==
X-Received: by 2002:a05:600c:1e09:b0:436:e751:e445 with SMTP id 5b1f17b1804b1-436e751e61fmr82747375e9.5.1736504625358;
        Fri, 10 Jan 2025 02:23:45 -0800 (PST)
Received: from redhat.com ([2a06:c701:740d:3500:7f3a:4e66:9c0d:1416])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e03e5fsm47436835e9.18.2025.01.10.02.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 02:23:44 -0800 (PST)
Date: Fri, 10 Jan 2025 05:23:40 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Andrew Melnychenko <andrew@daynix.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	gur.stavi@huawei.com, devel@daynix.com
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
Message-ID: <20250110052246-mutt-send-email-mst@kernel.org>
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>

On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
> On Thu, Jan 9, 2025 at 2:59 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> >
> > The specification says the device MUST set num_buffers to 1 if
> > VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
> 
> Have we agreed on how to fix the spec or not?
> 
> As I replied in the spec patch, if we just remove this "MUST", it
> looks like we are all fine?
> 
> Thanks

We should replace MUST with SHOULD but it is not all fine,
ignoring SHOULD is a quality of implementation issue.


