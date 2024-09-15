Return-Path: <kvm+bounces-26949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C5597988F
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 21:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3CF282C04
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 19:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB89B1CB318;
	Sun, 15 Sep 2024 19:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="LegECz0X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7504E1C9DDE
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429719; cv=none; b=rWor3zrGSvy3TD+w2Rivz1gPe7mXbPoBGeK1Twg0blT3lgYTUh1+HuCj9sHEv7Q56mZlSzSwhk0Bvjcidwd9AKSflExjn8kHpkl+K/zswX2tUqwlEysy82AYgLpeLAOlMixY+VtTYPIFPNzn0C9d3kU/EQ2VAMj8I3zjEXidNGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429719; c=relaxed/simple;
	bh=MRhzl9kpuCHu74clIdzWjSROzs8qD6POOF2vur5Iqeg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=procgIdvZ9oX+eco4kLWngdHeuDin0Aix0PLQfvjHwP7PGUOwWPfstTd7ZzQ0Tx8IwmiNoNulqEbVKjgppQiq+TpDhy7GUt+Eo3DW5APL+VR9yh+Zd4qG8rkgb+KDluXnsLtvkKCu3aDOp2Kv1bRHQT47ithm1sa2UTA1I2ureI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=LegECz0X; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2053525bd90so21619095ad.0
        for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 12:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1726429717; x=1727034517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNp5/hnkOy9FrJ592XEPwxvQOfrqTwTwJ+m8OyrqXK0=;
        b=LegECz0Xauqv1hObdVLXz96DmYUwaRos6scUz0g55lMnTM1wT02MZaM10rpc3JEbhU
         +VlYnJMFFMWqPqsOt/A9pPEAyZ6T9F5bclTXMnDl71mF8X6ysZye/rPeV8/2pVHqFNDp
         g6Is8+mZSZH880h5F5IxVe0mpH20g4rQSGW1HRJM8p6uh44Dpx+l97XwGAeasKKq5L2O
         9FZbzKSXf2+zn8a3GdDhTz54m9ImBEfDuzwhP7/dCHHbDw2lpLqVJj6Xv2/0Wm+9RoEm
         SQGTui91l5s3piY8IwK/9wH6HXu2kU4WDwLP66OqjGcIk9sXkebUjecAlKvRX/hBczLM
         d3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726429718; x=1727034518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNp5/hnkOy9FrJ592XEPwxvQOfrqTwTwJ+m8OyrqXK0=;
        b=XDIqmZlO+fSFLjTQNOeno5k05w58ftQ0XxfvpgGrgqss0hPGgK03Atajpdqpl2rFEt
         a4Ncf7gN/7AkIj/axC2ygxxMmpA3CcvdYpgmewU4KzUSqwrb9i6GuqxiN5edg5CjUR10
         ThLaKlcYzpJRCHPozB9bVxzJqLsYxsCFj6KzGcgvKDqIkCq7So3o9QVACRUE4DqbdYbu
         7vPJ/VgwbzhR1L9LPPuO10VEJbyoYzuu16ZhA7yNXbt/WZoY4YuQK78Qe2cVbYnzVqjG
         XNf2Z8OajgoDpGtAIhulK0cB3016OCPSfy1tS/BS/Zbjhis3RZrkxBqhLisu/T96Oalx
         jq9w==
X-Forwarded-Encrypted: i=1; AJvYcCVnnZyq+0XXGcAyEKiWxlPTj3dZ+nByhPEuJ39gk7oxXJSly2NHTJ7I2OkxfjiIcJ/XOOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZFPVcb8E+Gz+yX/+zW1dvmac8uhVjGew36RRcG/2bnPOwSbO2
	WDcWLAT2RwSTd89kl8NId4Uk+Acd9XqJdMIeXZ5tUO3pAVMKyPsdPlxDM4HgrHw=
X-Google-Smtp-Source: AGHT+IEIwQjnGlDPb3oEceDakpD1b1PWW6LbBCx4i0kZt1Rli+HqyHRriIrHVS++Yfgo5DfOZzymmg==
X-Received: by 2002:a17:903:32c9:b0:206:ae39:9f4 with SMTP id d9443c01a7336-20781d5f6fcmr138044405ad.20.1726429717591;
        Sun, 15 Sep 2024 12:48:37 -0700 (PDT)
Received: from hermes.local (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20794735719sm24738385ad.275.2024.09.15.12.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 12:48:37 -0700 (PDT)
Date: Sun, 15 Sep 2024 12:48:35 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah
 Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko
 <andrew@daynix.com>
Subject: Re: [PATCH RFC v3 0/9] tun: Introduce virtio-net hashing feature
Message-ID: <20240915124835.456676f0@hermes.local>
In-Reply-To: <20240915-rss-v3-0-c630015db082@daynix.com>
References: <20240915-rss-v3-0-c630015db082@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 15 Sep 2024 10:17:39 +0900
Akihiko Odaki <akihiko.odaki@daynix.com> wrote:

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

This will be useful for DPDK. But there still are cases where custom
flow rules are needed. I.e the RSS happens after other TC rules.
It would be a good if skbedit supported RSS as an option.

