Return-Path: <kvm+bounces-49363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84222AD816F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32AF43B63C0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD655257451;
	Fri, 13 Jun 2025 03:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSN5P9dj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9132472B0;
	Fri, 13 Jun 2025 03:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784329; cv=none; b=ZLIZmRokCFGxm6MEJqq1yn+wSer0lUgKcPgHSonfedgA/5ZhuoMIbRbUmuELArbt1nP92lMxosTrpDWGhjOiPo2ICSIsb+4FUAVCzCIYrTPuYAvNwv8K9Axw8huWu71m4+nYxcqKv+B+wJnJ1+dRTDFZMfIjlW2akqQWO9ChOms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784329; c=relaxed/simple;
	bh=8vDZCrVqGSpvB+A9Uufa93gUzdJNJe6C92j12YvonB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LzLOx+iZQiItC+YXi8DhfwBVM99+yNiC+3WLIImypOAfsJyVqVHj3P/W8/MApgoBdoMuGW6/5m8YxIrToP2IsOCrTgKsfl8tS3RUc3xqeMxHEDtSG8ej3NYya3S6VPPmXxltHMy7KkAUwNTcTbyABgSIGidt6lKPBl9T9t5ezf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BSN5P9dj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23636167afeso16588095ad.3;
        Thu, 12 Jun 2025 20:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749784327; x=1750389127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jvQMCmLVoexZEbAMVw+cxcVxwTbZmJeFmGnASyg8vqY=;
        b=BSN5P9djiaYCKqPsWiJHkjtjeoZvMVnfYvTotYtg/8CpA2WMGmPpZatuA/5ncr3Wu4
         AXIhBw5Q6IClYcZHQ0EFqWeLkSWtG5Rv9qx6bajHteSdPYKq/3juoOgNlg3X9EfxYGYL
         ONnGpefvBlF6sZzVQtpfCCbZDc+wMNxIpkn9fl3Dmm30TUNMcFAX+/1MbtOul/6zBtED
         WEP8xgTSloL+bmINof0StUIE5cRdNrVm0l9Ov8u0JmxSUePVmeVInTGjOsFLe78uWTfH
         lfnAZf77ECICpNiej9jJiJMzzEU6pWlSnXZz3IRUtThdyArCvXzAlPlf+VCJgYkpMIu0
         I3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749784327; x=1750389127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jvQMCmLVoexZEbAMVw+cxcVxwTbZmJeFmGnASyg8vqY=;
        b=MQpdAdjiCSZz9T3dmxB9c5qqHCUwYS/dBpbVFlqtfgIk2U3qPn8tGyQPsKHvqZrowR
         RLVzVbAJA4M2mBN3IXEexaxO94Q0234p21TMHqHt/xe9ATu2aGPeun1d5AZB/eCDGE52
         0osCfrsUSDAjMOr1zlPj/SThyJ8aUFZioRAqVMz15mUGG0qGzafPZp7imi54NWu17IWf
         iTyGY0pBW3s2oXGtXZ8daBH/T6fUUt08hZtKJ2E3kGlJ9gxLqZteWfdfMqG43oHhg5Kt
         HZ5m/Ae5HVuPWebYFsoOK9rMVP7c+LVT5aOrea4d5S11isy5QJ79DqtXCPzmimVKKK/5
         9D5A==
X-Forwarded-Encrypted: i=1; AJvYcCUb/eXpk8SMsldBi4j+qUhZLfJqa3drFvUDc51pumdouEMJm2zjnjc55wAKYFte9OCvjno=@vger.kernel.org, AJvYcCWxB8svF+TSUbNKJ5qMxwnN/pK1WnyhdqgNcpxpBdTeX6MrFsW4wtlEKQbMZq2c1TFfvj1IyJyO@vger.kernel.org, AJvYcCXCPgtvDyqc3shUt/kLFn2pY8TLxXko3GDmHwaLr6u83QWNZCXkCLxaS7P4siLAEDPrzNg9jghAfgzHSTcj@vger.kernel.org
X-Gm-Message-State: AOJu0YzP326buqA4RsloWCa7r8xm0KOC9eBPljz9IuoxD/gdA0Mjl2nF
	lVGZGb1ZS5wWui/KS4ZaivR+Vd64S4gVGJ1fNzHnuVZoBtN+cLc/cvPFOSdzBsvlCWiXPLbE
X-Gm-Gg: ASbGncvuTFEjSGfgQ4gE4Pc3lpoomPz+p0ql8ENis13VJdWtpr8PbF/FywonHdJZad/
	F8FrN+rHmsfUwxLheqQcTS0glsr9NRlr4JtyOfVlN950yFus3gBsxrzxNhqD2FNXa2VWCuJsdZd
	1tFnjhJrhuRURjXsfsBn/vcnonj2i8lN1xwJ5c/J1cU6Z5bWKNpgWSrjJDa7PkSkOe3Rk+xtY2m
	fsocyavEiu13DTXNp6TmIpKwOGTmqhY5DXovGfSlJsi4w/rKPUKopwCCCQQtzl0jBe3Byzrz33T
	Ii88n/AeZXlNJiuo6KLoACQrWb/0XqVOlrM+Pg5GN0H83n2eHPbW8rjqWg1FskAAEF23cpiADOd
	lgFr291vU
X-Google-Smtp-Source: AGHT+IEWDr4/2rO+qFnFyPkG4l6WRFZhlQHqkd8lc3GlzWs2YR06IinaIb5kW1nJVC9KS1xMri1Yyw==
X-Received: by 2002:a17:902:e547:b0:234:a734:4ab1 with SMTP id d9443c01a7336-2365d886a50mr18462605ad.3.1749784326668;
        Thu, 12 Jun 2025 20:12:06 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbb39sm2291801a91.8.2025.06.12.20.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 20:12:06 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v2 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Fri, 13 Jun 2025 11:11:49 +0800
Message-Id: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset introduces SIOCINQ ioctl support for vsock, indicating the
length of unread bytes.

Similar with SIOCOUTQ ioctl, the information is transport-dependent.

The first patch introduces a new callback, unread_bytes, in vsock
transport, and adds ioctl support in AF_VSOCK.

The second patch implements the SIOCINQ ioctl for all virtio-based transports.

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

Xuewei Niu (3):
  vsock: Add support for SIOCINQ ioctl
  vsock/virtio: Add SIOCINQ support for all virtio based transports
  test/vsock: Add ioctl SIOCINQ tests

 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  1 +
 include/net/af_vsock.h                  |  2 +
 net/vmw_vsock/af_vsock.c                | 22 +++++++
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 13 ++++
 net/vmw_vsock/vsock_loopback.c          |  1 +
 tools/testing/vsock/util.c              | 36 ++++++++---
 tools/testing/vsock/util.h              |  2 +
 tools/testing/vsock/vsock_test.c        | 83 ++++++++++++++++++++++++-
 10 files changed, 152 insertions(+), 10 deletions(-)

-- 
2.34.1


