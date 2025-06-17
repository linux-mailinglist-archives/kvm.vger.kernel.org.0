Return-Path: <kvm+bounces-49670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43240ADC117
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81BF41887409
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578B523B622;
	Tue, 17 Jun 2025 04:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7AzYwaX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F570238145;
	Tue, 17 Jun 2025 04:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136043; cv=none; b=iEjIzft+JKyXa126klf+byu6QiIAGFaEuPBfx71whTrIv+wnFiliE2DfO4MOjAiEElrlJcUicMex0FY5l8Qkld0KaibvKriAVYqSIQ7mkzYyB0Ru/NDA8i2C3uZwHZixqJMn2CoJHWAauiEc2ZEnKAmA1aI546pD5TdY8JGYGeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136043; c=relaxed/simple;
	bh=kMm7lgYQCIkhpkVmH9clHM0HFhSUZpxy/D1RGQ/mP4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p9VaPGz0ckkN7WNTsu4UsjCQTp3O37UAEji609CJA0l9BYmDXTptsA/SKzlUJR2Ak5kjvwyXtV4R0f7e3Mb2FY/g8eE+egXtRQ4ewKzT6JIzJenAdQTgF/jYK2SZAMJVbnJ2onMfXW0CnANqpEC1IRGV6jl95ZHvRkxMpgQt2Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7AzYwaX; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7426c44e014so4366090b3a.3;
        Mon, 16 Jun 2025 21:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750136041; x=1750740841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ux2aPBTIrlfQIKX8kOjNghDVGII2fwjUeeGrkzAJB28=;
        b=a7AzYwaXCUwysr5wLSYBtshcbVyg7jVz4JqoDZY6PK49odjGnIa3dzNIirU+KAxaCC
         jJSD+6wN/FtL5QmHnrpem1isbzbBzcdRZZh+vywzAsmsntjxDYOGg2reyFGe2E4UvYKt
         JXyrkOsB/EWvt95x7SVBJe2bCh6T3fReYJE5GYOMU9BBFmFqlmHdKLXBP9Ci+8j5Gj+k
         68+9CWpC+V/e51+/uKMn383JAqb34A58C6HzXp1TyGOX1/D9pcLoVkyBvHbz6knrdfjG
         6BoODdog0qEztTGjc0fjRe8N3JFsB7+QTPOe/rh3pPlxZrsb5g5boK45JlVIPyOI2dlC
         wKHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750136041; x=1750740841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ux2aPBTIrlfQIKX8kOjNghDVGII2fwjUeeGrkzAJB28=;
        b=bGs6LW+MdGi5bo91KfluO3N5Uwk7Jp4r7qL4QMP0jOMSL1Px0O4/zZJmaGI6cUCr70
         qNTMY5ox+jAxsee0LTeeyZOOVB4Zn8CVHuUOjj9goTbIKV5ld6pj07xcuaZJRK7syuZ/
         txpEBh0c0yGcBpHdrz1OoRQavVFKzYNw1N1Rpk3MUbTGneLha3/JzDPfWKG/Iej9AMKq
         CJtLrE0fHKNV1U0s/NREpcQWPzR62/7qH1ujE3asSqd2cTC8V/YjDRh4FhGFvitg6kXR
         ywBjNI39/yesLIpULD5tpdSEvUjm4DsBjiz7tGcU7uugXpZXpsjLlsC4Nt363KSixG/6
         chRg==
X-Forwarded-Encrypted: i=1; AJvYcCURhC2H4OHnr20ueCshqbPHmHfEE3Nd5zneGHhdSJq8NH6c73ZOGWRxiuUT2gkZblORyg/XX5QLHW4pUgJ4@vger.kernel.org, AJvYcCVH7fxU2HTplDhvAtYte0bDUy96S8Miw1BdVfNDLbZYQ0lWb0UfkKV7lIzjYKoJGq35d58=@vger.kernel.org, AJvYcCWTvPS7rAnz/+UcxH1JFj9W3ERyiE1B14nfecJFCKlweWJXNASYYyuPCn9zzzXY2M0GDu/98GoB@vger.kernel.org
X-Gm-Message-State: AOJu0YxJg2vZDUY1cyFy/H1qqxFSgp2OvYZRVUbTK8wxtHbjdEVdtGPg
	CErsL+ifrS8kLWzzH1tPT8U0KLcjW5uh0xhOOSBNqKhsdZVzkFUuYurz
X-Gm-Gg: ASbGncviA4o4EEynq8r/A/3K2IFO9+69ihm2cBh9DRLYtJKJTZow7XXSvengdmFE5iY
	ywsxrRv385yUJANNVG57OsIfeNHJcPMuXTFxdAU+4hGakFdDe7REb+t3w3dQ6GjfhkDrATThXJo
	TeZIdjuRGLBlDu+wr16YOH3ap5HpLUowZZPw36R84aZTgLd43UXOc5qpLLuT0K3+W3QLR4adSUL
	fIP+IJgLf+qBif3GUn7XcCGJUKszd57+DhSdUlivLq0JkBJjMBAvJnzp0P/5r1/0O2L0y6Pho1s
	zGZG6+pZqUbW0QvA4xSC5EQT2eAw/dHIQpjnk25gkK2Ac1qOQAqhpG+PiZWIbG0qgziDrI1jDma
	KuD2rpWpd
X-Google-Smtp-Source: AGHT+IEL2/Y3YEJoexZQiqPz6UZhDVycLFbjekKweKWb+g9AdWGm8CY4Beq+i2yz4rRVpeHFYam8DA==
X-Received: by 2002:a05:6a00:1823:b0:737:9b:582a with SMTP id d2e1a72fcca58-7489cfdb64bmr18949764b3a.24.1750136041147;
        Mon, 16 Jun 2025 21:54:01 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890005f47sm8132852b3a.51.2025.06.16.21.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 21:54:00 -0700 (PDT)
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
	leonardi@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v3 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Tue, 17 Jun 2025 12:53:43 +0800
Message-Id: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
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

The second patch wraps the ioctl into `ioctl_int()`, which implements a
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

Xuewei Niu (3):
  vsock: Add support for SIOCINQ ioctl
  test/vsock: Add retry mechanism to ioctl wrapper
  test/vsock: Add ioctl SIOCINQ tests

 net/vmw_vsock/af_vsock.c         | 22 +++++++++
 tools/testing/vsock/util.c       | 37 ++++++++++----
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 82 ++++++++++++++++++++++++++++++++
 4 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.34.1


