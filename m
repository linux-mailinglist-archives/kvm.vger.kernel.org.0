Return-Path: <kvm+bounces-18265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AB88D2DF4
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 09:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82B261C236C6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70F4167D80;
	Wed, 29 May 2024 07:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsBsQ7uY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D571667E9;
	Wed, 29 May 2024 07:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716966924; cv=none; b=N/E7r7nsKqE4UULHZa+hj+T2BTbl6h+4/Qy++418x2jBDHeOI5cl1viWHrspURkSvk2aquN+1d1vvT9wnkArUMldMaeDJJuw7NChijRacn/0O/pQYcYJ9KkPRbmbQP6EGC0aYZkRP9EBeIH25zFM/ofAnYd0PrZ3GC2/8beVrhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716966924; c=relaxed/simple;
	bh=VM23rw6dU+frl/564HTXigSeDbMXZ1+KDQbkMYied2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ox3JsNRmtwQ+83ALS29J7pnlvqGIJI0PbhGfnGlO1V0X0506UbQgObGmwuQO5VrCbhQ3tSivsbrbqHeWb6eyL442RIw6sZqtYy346dCpXeA1m5Ng/v6JhhF7tpzYkxfvaZgnbIwqbjN+DDKBZFBoR/eFs0pnzuH0cAQuCiWSnB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KsBsQ7uY; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-24caa67cc01so742449fac.2;
        Wed, 29 May 2024 00:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716966922; x=1717571722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGIkK8b/tRFkmBW8sJbMAhIfVD5fwtlLdHMjbfiTK78=;
        b=KsBsQ7uYWMpziZmf75cE0L9dptchSJv3Sm2RCNPeL+YAnXhLmGGWbGf85AqwxQjoeA
         0nfjmdHwFgSZYo/h6r1ULYIEt2Abh4+1fX7U0uoMDQMwmaHKj6tK7ly8bAXzhLujz5G5
         /0oYgS8i2ISc9poeOGYh7EJG+8XyPpRBp5goTgJWlw1IVQKWA8hgexS/7K1a1kIkNNMH
         HxfgNC1Ybo8gg/huhbw5a0UEemOLKa+XsqSX7VuBvE9N5EHUFTgGySXvDTXUMdS/Asyg
         g5jo1htLKkM5m+LhJYKp5N5pg4sBEL/rtjNLnRHUUp7b0tZR0pcwTs0gsXNZg0ajmg2C
         iLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716966922; x=1717571722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGIkK8b/tRFkmBW8sJbMAhIfVD5fwtlLdHMjbfiTK78=;
        b=WC5/Q1ravvmsaO5Ryf/8ic58ZOO1jJ6OJW7tWnbk/KEiXtvHt3nQ5fr1nquFkMmSTw
         yaVr3FI6/M/d+po2kX/1u2v8A87+u/i2Y7xV0wsBGjywmzDLwuHw/JqT/9HWtymd2YBt
         diJ8Xsn3c6yDRzqZKQtW6MaRr2EFFXf5MRGSN7k6qSD0hG42/1DTc9cWFiolVauG0Xk/
         SAitkmDPgNZ31eWWLTpyO8GMLuFepGVmjIVoJRo0KKl9qJ/OLED0/szU97rx4wIMyXXA
         blhE0M3kHXSSTDrJat6IO2huOR/mrGPyRZbKXO0OORS9C79Li6DHQXrRZRvzEtHJj9kw
         Av3A==
X-Forwarded-Encrypted: i=1; AJvYcCUGGahL+HJan9WxFZoy/2Tjnknps0rl6L510q42ycrmJdU9UUcV/BeXoHC5+YjSPPIaDTB8xgkPQ/f+yB+/bUqPoml2tV6BaAn/SWTJoTJaXXmBj0IpAAbaeB4y+64/H+IExY8CtzjQY7pxhcRapYujtwuTE6F52aWq
X-Gm-Message-State: AOJu0YxEffPqxhy1R6fdW0m90SldqaGr9f02dbHXQAhju/EQiYP2NYq4
	7amzBlbzF4tvbORJhU+WrhV1DYkDBCS7sVZdC1QZPgE6YcacRRIs
X-Google-Smtp-Source: AGHT+IFpgK5EbeZmdQsPAD6gq3FDM0KmWMgWUg5qm7Tlx36oZyOez4zO17hG2GaX6tAQPImObN94CA==
X-Received: by 2002:a05:6870:8a0a:b0:23c:5f20:8393 with SMTP id 586e51a60fabf-24ca1472b59mr14007992fac.50.1716966922495;
        Wed, 29 May 2024 00:15:22 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbfaaf1sm7449629b3a.129.2024.05.29.00.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 00:15:22 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: mst@redhat.com
Cc: davem@davemloft.net,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	fupan.lfp@antgroup.com
Subject: Re: Re: [RFC PATCH 0/5] vsock/virtio: Add support for multi-devices
Date: Wed, 29 May 2024 15:15:13 +0800
Message-Id: <20240529071513.466374-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240523104010-mutt-send-email-mst@kernel.org>
References: <20240523104010-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, MST!

> >  include/linux/virtio_vsock.h            |   2 +-
> >  include/net/af_vsock.h                  |  25 ++-
> >  include/uapi/linux/virtio_vsock.h       |   1 +
> >  include/uapi/linux/vm_sockets.h         |  14 ++
> >  net/vmw_vsock/af_vsock.c                | 116 +++++++++--
> >  net/vmw_vsock/virtio_transport.c        | 255 ++++++++++++++++++------
> >  net/vmw_vsock/virtio_transport_common.c |  16 +-
> >  net/vmw_vsock/vsock_loopback.c          |   4 +-
> >  8 files changed, 352 insertions(+), 81 deletions(-)
> 
> As any change to virtio device/driver interface, this has to
> go through the virtio TC. Please subscribe at
> virtio-comment+subscribe@lists.linux.dev and then
> contact the TC at virtio-comment@lists.linux.dev
> 
> You will likely eventually need to write a spec draft document, too.

Thanks for your reply. I've sent a series of RFC documents for the spec
changes to virtio TC [1].

[1]: https://lore.kernel.org/virtio-comment/20240528054725.268173-1-niuxuewei.nxw@antgroup.com/

Thanks
Xuewei


