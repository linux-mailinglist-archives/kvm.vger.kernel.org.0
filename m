Return-Path: <kvm+bounces-46961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3312ABB58E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95FF77A4E00
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B871F1507;
	Mon, 19 May 2025 07:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKsHsiqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B074257AFE;
	Mon, 19 May 2025 07:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638423; cv=none; b=C95FHu7g/5YUYdQ5SXlDUWAQA5H7T4MyW/wvsfviypEkfpuRo8yQDr/6GxA2Uo+ZZIrZuF+XRfwwr/wRaHZnc60cI9CWl4ThdSyqPgoUyWJWrxLVP5E+df6bWQZjW55521ciRjlmbF7ynr1PYfEMFJ6hRQBKn8b6N0CSI+SNAUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638423; c=relaxed/simple;
	bh=5lYdAnViKm8ZvLr7E7yBx5ATwm/YFLGHyRh1AvmTXmg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e7+U7vEqy73Ri+MMXh+daGAvnLUSV7SZOJHw9OP0R6LU5itkFOq2AYKHlxZ0pDCZd/3taWnTZWf2DfmE1qYP2yyOWgakbMYVLVkVS1Xm4Zysr5/0PsXo+Pa+wpbtPLcpVt7za9CBEqMuACMluRnipyj9TKX2gj6dnCoFKnCx38I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKsHsiqF; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7376dd56f8fso4657246b3a.2;
        Mon, 19 May 2025 00:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747638421; x=1748243221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xs2BEGm0Er+d1dRSYQn4lykSzo7rxtonmxLe+6KSkkg=;
        b=KKsHsiqFX7JwDqdKg8WHOBQUle5f5S4o2BwSNYCztH+CmRrWZP6cu1mL1nyTIR1ojO
         kib7NGvLVUs7lIPZ/V2aHyOLyrKI2efShXa7DJE5rL133wkcbGzDj3uwGfC/vaqJSzpM
         h7Ws70577VSBD0bbYR+J3GjXP+UVp82FzTO+ivU258LelDxnz5BGyWOGhUjZUkWlYwhX
         pyzaSvIZJU5xmnYNutvEEsrDkxWQosffUqdyTZR4NU03RL+Aft0gIL/9+eNh9P2CoiHW
         Y46iewoVIS8FZmwkt/ZhyzsEwKcIJSx/PthSjlvpkBSoKw9sVxzAVYYd2KPZdvxF+p3d
         Ijpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747638421; x=1748243221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs2BEGm0Er+d1dRSYQn4lykSzo7rxtonmxLe+6KSkkg=;
        b=nw6t+HgSMTXFpuikVllpWLzr8Jlv474zuSR2qLRoMf69n2D3+z+GMG76anVCGDv2hm
         Brl9pks3YPCHNDFLDF0xtLcJtPkxwgf6QZXVcoJ3l/X1bxz23TBt+Ifi31ixyEP0EiWY
         XRsEqnXTSIv2UvmX5HCczn6gp8Go88V0KiLDmO9jtoYCh988d0WY2z8UOuNoZowFB48J
         xdCyb6Wx7ZGK+7sKpPNb8uiM10EY4w1usD4wQSpOK/blu12B5Cfh3nvUXYsjw92m/4Qb
         B04B4R5tDX5l5HrDL2wqOfhed3qWSRdilDRP4Yo1cA5nAKDN+VyuI0GNYgCQQxLTC6Fz
         73XA==
X-Forwarded-Encrypted: i=1; AJvYcCVsqyPmhxy56ym0Ipe27Lfhc82hHkzYaysCXOqojgOIL7nq2lZt0pu2x/tPZ0kIEPr0wXA=@vger.kernel.org, AJvYcCWcI+aX6KYcViE3yPJGvHU9vL9Vt2UAnbzBjV+S+0hVfK+aEVFgrBj9g3BAOtQTkAwh3SlDA+YmuLaIlGiB@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu19QmMflHNkztRa5mkVk/zN0hO6eSkw/KYIfdOqGktP+vBedj
	IrwnHzYCZBaw4PMKCHmVauJqj9mH0wMji7GWHPZ7C8ug0Zrf9Wl+RaazjDFuBJFKVjI=
X-Gm-Gg: ASbGncun3cq6D/KHkaxU3N1lM+OI+hhRlFIp4JGCcvTedJyUB9bPM7EN+1NHMlIOaiY
	KVyxpTT79qFKtm3g8O/+oLc5TSsIiiUCrRE9b1d1lfYLknBk4rzkfGqviNLemfTD3DkP6zJLrn5
	mA/EriEMwOTto+frRO98pR/QbUjOnUHeXRteVTCtsPxFHhjSGKc1PvDvRD5i2LiY6CERH6Q1mwV
	r3Dlbsq7983mVSqGGTuR4EP0zo+bJdHKzv3Ahsp9rQejgoJzt81WfVJPDeL8mgXvkq0xXyuwYO1
	vPf/PxJ5zeV+hlmLKSrTD/t7jYtywBysLMUS7s7/Ri/QVWtZffr56Bo5VWiTrn7TB1soDup7Sw=
	=
X-Google-Smtp-Source: AGHT+IHA8A2vT2UvBCutX6PgYTZMcsbF6MTlQsqWarY6LSxYLDm0eBIJO+c55zh4t9TegLcLV4EIcg==
X-Received: by 2002:a05:6a21:33a5:b0:216:20de:52d9 with SMTP id adf61e73a8af0-2162189f109mr18185129637.14.1747638421326;
        Mon, 19 May 2025 00:07:01 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a0120sm5574336a12.63.2025.05.19.00.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 00:07:00 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	fupan.lfp@antgroup.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Mon, 19 May 2025 15:06:46 +0800
Message-Id: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset introduces SIOCINQ ioctl support for vsock, indicating the
number of unread bytes.

Similar to SIOCOUTQ ioctl, the information is transport-dependent. The
first patch introduces a new callback, unread_bytes, in vsock transport,
and adds ioctl support in AF_VSOCK.

The second patch implements the SIOCINQ ioctl for all virtio-based transports.

The last one adds two test cases to check the functionality. The changes
have been tested, and the results are as expected.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>

Xuewei Niu (3):
  vsock: Add support for SIOCINQ ioctl
  vsock/virtio: Add SIOCINQ support for all virtio based transports
  test/vsock: Add ioctl SIOCINQ tests

 drivers/vhost/vsock.c                   |   1 +
 include/linux/virtio_vsock.h            |   2 +
 include/net/af_vsock.h                  |   2 +
 net/vmw_vsock/af_vsock.c                |  22 +++++
 net/vmw_vsock/virtio_transport.c        |   1 +
 net/vmw_vsock/virtio_transport_common.c |  17 ++++
 net/vmw_vsock/vsock_loopback.c          |   1 +
 tools/testing/vsock/vsock_test.c        | 102 ++++++++++++++++++++++++
 8 files changed, 148 insertions(+)

-- 
2.34.1


