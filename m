Return-Path: <kvm+bounces-47207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE970ABE97B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 416DA7B5D30
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B5122AE6D;
	Wed, 21 May 2025 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvenjCUz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A826B22A811;
	Wed, 21 May 2025 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747792870; cv=none; b=pz4XIL2D+gG+BiUeCRSdm4fimOjJ/QteZsImY2BrRzXxPG8dDDrkSeOj1t5iZ9c9JqH+pPFQYbT7VuVDHbZ8qB72wO93P7qXTANy0+yLZUajR5Qi0mACo/4ivVvhPZdETICIitZg6DifgZ4glF7lVGmiLoXvSSJi7rdG3CJP5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747792870; c=relaxed/simple;
	bh=rfD1WdfiPVKd5LCp0hGuro5Zqx3sYVINot3Bg53oUCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HYIu7ZfJwOnAXj9tKcE4HWOG1PpoyOojf3x3AshRkilMqaDCnPXMM2Lb2VbtwjOLggBmDedKO+wUlznqoQF1sJq+/tmiklEhuxSoibB91ZA/kYeE1ih8gZiv2lMNuhWG9QM35OkqVxnbmlQE+/1xIxL0gC/kpBn8UY0RmQfE6XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvenjCUz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-30e7e46cb47so5042465a91.1;
        Tue, 20 May 2025 19:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747792868; x=1748397668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1n8xYtWpS3N+9P8jTX3q4mFWmzpvnHf8VvSlpwIoG/I=;
        b=GvenjCUzwnTpr6QZyDALLPfkkX0VwIPK+DZ5M4860GTXEaZXbc+sUMv5RyEzTHmjzd
         FqrhmJ1dIOJiCWDLo75FxaCz9BSmto3IYGYl+3h7kUFSbIYz03lutyfyjMbfhH8TMJ2Q
         3U36lYmQkKcyspw9B8UUbPMWL1V2radS5jGgJcnqv/U5Lq3P6s5ftj3nBmZOMTRRuyPL
         JXmrWrIPGlxMr7EOa5L9ho4k2X32k2aeo/ClfqzJLnJ1FR5gkfX5ZKFxRgBMXdPdPTLm
         8M+zDJVyOh2Rpm0XALasEyr5oR8tdOi/2piCSkQ0QEbsQw4YThYPbUKywfcp2wG7AWu4
         KEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747792868; x=1748397668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1n8xYtWpS3N+9P8jTX3q4mFWmzpvnHf8VvSlpwIoG/I=;
        b=MqngkzGB1Myeg7vaB9VqgTzUlf/7+MSXvpomqamVuAY0TGHOwGLCb/DrjmxXOF8kGM
         +dH+vs5MCJV3OZNGlctOgzn232nJMfdactwNnLTQlmHOpz0rX8yQwSvg5iE4wD8VNtKs
         Y/qJ4Ke739zoQYPB2Pfi+ZHeiFg5c0Dit/tgw1/F4YZyzGf08fw0FoP2Uyk0nKiPB32T
         HOey31T7xKb5hMFZYM8LFb0HRlIlgaLArMYMpeMM/ln1/axuXiJFiRoGfhtOJpQ5+esy
         wETq6sIwD2cae+9HvzmC+KH5zlTf6WrQhnehGGWQZmVsbClkA5ua5WmlKjbFS6qs4nbu
         7nBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVThWrgMngzh5BeEqeXfrv/okZCI8mgpvCwHY1zUfADlSIMY6cMIo5UBPJrOx1vhq7xJ1k5jOlDuMAmsXCQ@vger.kernel.org, AJvYcCXipIoE2RtFg7SBk5+JF0k+ttRMP8uDRzNvkGZfOOp8+2y0ykenlpJoAG9bh2IiY58kWTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDUDfc65fCOD/ULHdHBnkPXTPTeuY5+nUTp3mEN3xOXcroH79D
	QM+hbWiNDte8+bzJOd1YHPrmvllUPiqFYeHQOXqbwiyPW4KY/0KBQ2W7jyGD/c74HsE=
X-Gm-Gg: ASbGncuTMbqazsc8b94WTl3cby5v8zv84Hx6cf6Z0M5ysPgQPQjORZYBud/io1ylwVa
	FbqU7p9PNUS+ZN/W6d2DM/AK3zbDiHii3vN7fenAGM3diHSLjBpUQzlMEZMXR+OBXkIiHGcoDVQ
	unXxZw9KH9yKkSudtn2MIp2bscYbEfj4VWoknHEgxZD5ChFnEA3PkFdQIWOr/7aiQ+E9Y340jQA
	EyL+0fIfPKskUVdDzar9p7WiC9PCn9JcwUS+2SAvpdwIdgeRhy4/USEOsToyVLN0bqdCVUtH76a
	x1/yEN4rwXHu7m8fXohyZd5O/UfLkS7v3SVWjkOeDWiESkN0c2Fc8L0LPBm+EP4c+ysjURnqnw=
	=
X-Google-Smtp-Source: AGHT+IHWb+J1+0XyVk1FWW7GI32Fre4UxcrIQ+CYKT872G0qE9ugR2XJASnOtsJcO/JYKjhX6VIecQ==
X-Received: by 2002:a17:90b:51c1:b0:2ff:796b:4d05 with SMTP id 98e67ed59e1d1-30e830ebf21mr29331126a91.11.1747792867654;
        Tue, 20 May 2025 19:01:07 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36368e44sm2477647a91.1.2025.05.20.19.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 19:01:07 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Wed, 21 May 2025 10:00:41 +0800
Message-Id: <20250521020041.3215959-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <27pwterjsrrvgzcdwgkrfkthbqdaqptj6lj75gzfmhuouilexp@jg4t54gsnw2h>
References: <27pwterjsrrvgzcdwgkrfkthbqdaqptj6lj75gzfmhuouilexp@jg4t54gsnw2h>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, May 19, 2025 at 03:06:46PM +0800, Xuewei Niu wrote:
> >This patchset introduces SIOCINQ ioctl support for vsock, indicating the
> >number of unread bytes.
> 
> Thanks for this work, but please use net-next tree since this is a new 
> feature: 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev
> 
> Thanks,
> Stefano

Will do.

> >Similar to SIOCOUTQ ioctl, the information is transport-dependent. The
> >first patch introduces a new callback, unread_bytes, in vsock transport,
> >and adds ioctl support in AF_VSOCK.
> >
> >The second patch implements the SIOCINQ ioctl for all virtio-based transports.
> >
> >The last one adds two test cases to check the functionality. The changes
> >have been tested, and the results are as expected.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >
> >Xuewei Niu (3):
> >  vsock: Add support for SIOCINQ ioctl
> >  vsock/virtio: Add SIOCINQ support for all virtio based transports
> >  test/vsock: Add ioctl SIOCINQ tests
> >
> > drivers/vhost/vsock.c                   |   1 +
> > include/linux/virtio_vsock.h            |   2 +
> > include/net/af_vsock.h                  |   2 +
> > net/vmw_vsock/af_vsock.c                |  22 +++++
> > net/vmw_vsock/virtio_transport.c        |   1 +
> > net/vmw_vsock/virtio_transport_common.c |  17 ++++
> > net/vmw_vsock/vsock_loopback.c          |   1 +
> > tools/testing/vsock/vsock_test.c        | 102 ++++++++++++++++++++++++
> > 8 files changed, 148 insertions(+)
> >
> >-- 
> >2.34.1
> >

