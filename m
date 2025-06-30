Return-Path: <kvm+bounces-51065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A25FAED5DF
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B3FF16F278
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450FF224B15;
	Mon, 30 Jun 2025 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0US/af/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336F21ABB1;
	Mon, 30 Jun 2025 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269132; cv=none; b=TMWuTswvl7G59NDVRQuznnBo5HTl0/TJWg3ZiohTZAKZ5hbsvsz09XUHhfXmNrwKs0qdZapd+O+qS5ZDJop42AvdnQAzHD9l/0ZUVKDwkugJjhdFMjhSqftVrzGzNoybyi6cheoifvuu2xjfjRpJQOvbhNsDDDrH1wKSDa0VouE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269132; c=relaxed/simple;
	bh=C1EHD1z59F2SyLvaExWmmS5+b7cLnftKwrKslD1pIe4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qCLQ14vZ4WNW+a8yY59Ur6T1t8TE5BT77xtTmw4waoNDL2Njr1ENEt94EV7d1XFBPdlJ4P24yZx2EE03UwBVOwkITEB++Pbeq6a8z3mmEMZnnuKtpJOH5s645fwCHtNCeiyBG0/3qCWku/nGbaGeuKUhfw63ZC9nWRrpmevYkjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0US/af/; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b34a8f69862so1673122a12.2;
        Mon, 30 Jun 2025 00:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751269130; x=1751873930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LMFps7gQrYkD6CPu+nOWqI3O3a/AKcYoOahC3/xHR+8=;
        b=E0US/af/eSEhdOvd+fo+Oz045HDRFtoCDyY2ykFE2oGLGN7Yh+JE+FJx9MUyuFN0KK
         Gk7LfaoY82U6s6QaSBnVrHaJGy2nIq/uiYgSqshoDRkcF/tHJWvBGC8s6EI9dgIlGSxz
         PiPzo9CouP86j9PnKvM5UBvORyHU7YP3Scu3mxyvk/4lK3OgAqDyKLMTpA7yyfdc8pug
         ml65VhUZa11S/cu56L9XA1s8apo6StXXxvYV2vejS5TPdiR6JbWRIBocU3zeCu8SnqF5
         /fYneIu2RM5GvJgdpxiDACMylbUhCBu03CbI+YiMBlFGVn47IUZ5txImVg/NeMFy7WC5
         u+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751269130; x=1751873930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LMFps7gQrYkD6CPu+nOWqI3O3a/AKcYoOahC3/xHR+8=;
        b=SKvWL+ZdChOuQ14zQmefpp/md85ZefDsZBSJ1LHqNEh3cckuH29dRD/QI8HDKVAstF
         Q/xTmSSJzCAJKAqcnrVOKlaHVTwxJqMpvuq4Jhg/a6hVUbwEveBcxFzSOk1G6O4gTBZQ
         WcXp8gmk8NwVge/L2pKMNNVHKxnbTpDSl69Xp60DRz5GgGDaw+ETLm7GxH65oiQQ7EJp
         NyUKu9l6wlv5DBioAstORDIeO50lKULyE8jC1cxVBdNZ2RjIHc/kAkaTJgzWm4ReBgFZ
         REq0eRHogLlZhZxai4YqPBNNjQj8aMb8lzv/UwodRU6VUgoFwmy/SSdBZ1yy0vptgbGO
         YnuA==
X-Forwarded-Encrypted: i=1; AJvYcCU93k2KpGyIxQQqRIE9euoMGFfovgmKWalcZqhoR7KGQMH6DCkiVk7BGo4BiBZGtUjfZLmZqSOInUr9cxn7@vger.kernel.org, AJvYcCVrge/K+GdYFtKbcSybAAcbBzvWPR2+cRxXBE+yzrzdRRWiTg5+FUZ8mkifpu7Sa9C5zu8=@vger.kernel.org, AJvYcCWTkcfqtKmd4yhcXLfA8CgAWDOzCc8YxI6X6zzoY4DiF0avH0s1uO4od8EMDSN35VtLsPEuBSa7@vger.kernel.org
X-Gm-Message-State: AOJu0YwJVo8C/029VREreRiAh3MH9z5qLfBCBRH++2PvmJVSsTnafv5+
	J3H9q8su9Xnus2NGw5y2nkqiwm6VOh+0TgZtJzoimTtQpvMxFASto2x9
X-Gm-Gg: ASbGnctKga6paordo8fiaG/4zDROCBnxehgIGh5r/g0fg36curImdEY03AGJ88v410/
	RHb3ZO+i4K1J/alUlSRDDhlqBwyd1MkBbmr0w0N3A8zd3szrMYeTH5W3aGsjD2E18cI900g+m9q
	WXS8FUZMrM8LzQKl2HIK4ynPNg8kWcNXVzWsZ0z3Xu27/SoQBlhWieIkaqjZjSQmNrJ98vPMhXB
	fav5sDkHTjzV3NJ8ZqA1iGtMJGaEkBXZ+97xcSPhUS9kY1YDtdUl7BRHdDk4tufYYS8XbdK6TcW
	rFn6RCio5Ai65cxRquVGdRCbXXfI5aSCezYfyP0rzPQYSaH7HmBQD8KEJhNEZ4pGPucyjrXNgWS
	tT26NYlQS41JgbH+smRo=
X-Google-Smtp-Source: AGHT+IEg5uwH/kF0lYf7Hq59I5MKkHWlSxwYXEhG/7GCgHeyClrt5UgqGkpLTI+EfuDwglRv5LlslA==
X-Received: by 2002:a05:6a21:4683:b0:220:245d:a30b with SMTP id adf61e73a8af0-220a17e9d75mr18242672637.38.1751269129983;
        Mon, 30 Jun 2025 00:38:49 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af55c8437sm8075175b3a.115.2025.06.30.00.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:38:49 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Mon, 30 Jun 2025 15:38:24 +0800
Message-Id: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
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

Xuewei Niu (3):
  hv_sock: Return the readable bytes in hvs_stream_has_data()
  test/vsock: Add retry mechanism to ioctl wrapper
  test/vsock: Add ioctl SIOCINQ tests

 net/vmw_vsock/hyperv_transport.c | 16 +++++--
 tools/testing/vsock/util.c       | 32 +++++++++----
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+), 12 deletions(-)

-- 
2.34.1


