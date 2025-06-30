Return-Path: <kvm+bounces-51071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9AABAED650
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A59F1899194
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A54D239E77;
	Mon, 30 Jun 2025 07:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVGDOkaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E772367CB;
	Mon, 30 Jun 2025 07:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270264; cv=none; b=aIJy8hY43I+qgWjsZdLH/Y3ewSD7Ff/CNraQC7pbQI1qm0kw25Oayj2iyMOInxP+uRrrcvYGeoyQxqcnlzvXZxMPZPaCCJtm/t6NDKXpjf7A+EvFT5nq7oYkvZO+LY19BTFWoU//J6FIaycE7jlOYKxfcBWa3XxC1CqLqf6PJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270264; c=relaxed/simple;
	bh=cV9kGGtSpuj9ayDd59Bcu0FzngJmMJQI55Uv93VBVqI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D0RJ7WXuukFogXZ5xWZGxq9gbrcB0i/5NUaPsozNC74xYwt+FtZ76HQzQ8clQINmp6Kk6kEhGhvW+tEn85J94DM2vOWUIlKppEISwwdcLWCrBnZTjb4RaQFMoRkIq+w1H+cvgwPQKqWEhQ0tv81OH6IGTHMoM+dXQ9Hjg1n8N5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVGDOkaE; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b2c4331c50eso4047484a12.3;
        Mon, 30 Jun 2025 00:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270262; x=1751875062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bD+6aG4x+JD90CmHGtgHXlJ8LrN4y8VLK/JYbhDdraM=;
        b=mVGDOkaEbnwIqDpUCcZIPCrFkyVjcgYwuRFp/F3Vxsfb5CYMZ5p70HcsfhQJruX+HD
         Az+Iv+/TFP8pe0MT1jV/8N6gVxA0aPzwMHmv5unvDVv1Edyonyw3lj0ATt/F9LeIgkK4
         vzOe+JEEbWM2CmbTIKJffB135RhyT9wDn+tx4A50LafVaiRxG8qnZdo/OKdPCDM+MKEl
         EyLrhvlYbm+wjUaKG7UrB6uSNx+ks6FiEC0fG00hNqAA0y6z3RnUOAmMHAGH5ETi/h9I
         dw0WMSBnn8C5h35rvF3StQnf54uIrXFkz0m9R2y675pd/fntuee2/z1FS6gihSUhudEV
         vGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270262; x=1751875062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bD+6aG4x+JD90CmHGtgHXlJ8LrN4y8VLK/JYbhDdraM=;
        b=DaPvc1DGdopGky3F3oiXSaHh5VaYiRYu3nw/BeyoU++mxguDcNcT/BH/bnJmqys7X5
         3E8S57QCld5v1OnXsXE9YKhGoIsqoLchjtFj9hcT4lZ6vUmDododh4DQWFYol/Qxd4/R
         VASELS+580+g8tbptFQ29n+pOd8yl0Nz7sN5KaIsgbMzBIJWWgm/w+FNrnwf3joPQBtq
         nukgydJZG/j/pJwwXEJuaDPNGElJniJK0nVL/gG8TMp1T3zscAsST5TTJ5cjdg/5i+yT
         WTq8IdO1Fmh+jj0gJvM0WKkklJ5XojoXSgFsGo58MHUDpeUuvZkwQ0ZLzY6GlTSHQqe1
         EU7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0UpoHb1GDqrEqLQEFxwsoFoBeJxEbU43QTbJULr/qNZxiRnV4PjjGvMVC28qbyDAV9IOWlnmV@vger.kernel.org, AJvYcCUyTqpStxDZtWIuob8N5wU+GffkFJQpr7mgAFoCGDtsbcXWFhvfnQkafIm4XSSAPChOzZQ=@vger.kernel.org, AJvYcCXPRj7jJbSNcw1yjnhEBKM14qNax4ytXux3lk1lSamVyroP4BNYu0XNHgDKKhULziSUWox2AdjacPb2OzvE@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb+tpOWj2hb4/18tJ7C71wz0ZzlMxrbnkJmFsgIhv7tNAnqWuU
	4PwtnTa8UjUJ6HB1hdglFavo55dJ5rSsDvKu38PBLeFCpOKVq4rT39JrelBpWeipeH81+Sw8
X-Gm-Gg: ASbGncualdjga9zzyOZ58WTdhyH1ECbe9BMGnIeDBj9Klc0c3hS1OGmyLBz7BV8iY1G
	f13jvf8I67liCYKrX8fCYq0W/1TA19FWkFPFFchvRKpu7I46Co6I61HQ/qUtxvMAG3MUDG7v11B
	edkhbdzMAVBRlmOvIMWo+ZWlRQtT2y/VRvsLxf5SgUsA2p4k4IAjRWkmRJcGtJFdK+AQm6P8cKH
	vlC1eqGBImVwN9scyQ+NHEbSJ2xpPY4lfC0ozJ8NeoIBm/bhDvAVzuhl0xPOUOomEjiNCchPGlL
	RrHz1TrsAzyTJNDdEW5XWB9ZVoSp9GBCPQ/yHz3C5DRctI5ma8wqRxt8BEA9j1RPEWbO+G2nC+N
	bomQm6C+u
X-Google-Smtp-Source: AGHT+IEEvimpY6QSzTZmdL3WxdfP/MAUUSc9hilg6q/dGJ0NqSBc7Y1vD/GcdGQYhgCtqpN/c3inzg==
X-Received: by 2002:a05:6a20:9194:b0:1f5:7b6f:f8e8 with SMTP id adf61e73a8af0-220a127661amr20551081637.6.1751270262432;
        Mon, 30 Jun 2025 00:57:42 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm7414931a12.63.2025.06.30.00.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:57:42 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	leonardi@redhat.com,
	decui@microsoft.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RESEND PATCH net-next v4 0/4] vsock: Introduce SIOCINQ ioctl support
Date: Mon, 30 Jun 2025 15:57:23 +0800
Message-Id: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
bytes.

Similar with SIOCOUTQ ioctl, the information is transport-dependent.

The first patch adds SIOCINQ ioctl support in AF_VSOCK.

Thanks to @dexuan, the second patch is to fix the issue where hyper-v
`hvs_stream_has_data()` doesn't return the readable bytes.

The third patch wraps the ioctl into `ioctl_int()`, which implements a
retry mechanism to prevent immediate failure.

The last one adds two test cases to check the functionality. The changes
have been tested, and the results are as expected.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>

--

v1->v2:
https://lore.kernel.org/lkml/20250519070649.3063874-1-niuxuewei.nxw@antgroup.com/
- Use net-next tree.
- Reuse `rx_bytes` to count unread bytes.
- Wrap ioctl syscall with an int pointer argument to implement a retry
  mechanism.

v2->v3:
https://lore.kernel.org/netdev/20250613031152.1076725-1-niuxuewei.nxw@antgroup.com/
- Update commit messages following the guidelines
- Remove `unread_bytes` callback and reuse `vsock_stream_has_data()`
- Move the tests to the end of array
- Split the refactoring patch
- Include <sys/ioctl.h> in the util.c

v3->v4:
https://lore.kernel.org/netdev/20250617045347.1233128-1-niuxuewei.nxw@antgroup.com/
- Hyper-v `hvs_stream_has_data()` returns the readable bytes
- Skip testing the null value for `actual` (int pointer)
- Rename `ioctl_int()` to `vsock_ioctl_int()`
- Fix a typo and a format issue in comments
- Remove the `RECEIVED` barrier.
- The return type of `vsock_ioctl_int()` has been changed to bool

Xuewei Niu (4):
  vsock: Add support for SIOCINQ ioctl
  hv_sock: Return the readable bytes in hvs_stream_has_data()
  test/vsock: Add retry mechanism to ioctl wrapper
  test/vsock: Add ioctl SIOCINQ tests

 net/vmw_vsock/af_vsock.c         | 22 +++++++++
 net/vmw_vsock/hyperv_transport.c | 16 +++++--
 tools/testing/vsock/util.c       | 32 +++++++++----
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+), 12 deletions(-)

-- 
2.34.1


