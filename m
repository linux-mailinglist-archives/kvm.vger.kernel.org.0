Return-Path: <kvm+bounces-49364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B6EAD8173
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7370E16891B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FB126158D;
	Fri, 13 Jun 2025 03:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kanvOKyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC9F25D1E2;
	Fri, 13 Jun 2025 03:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784332; cv=none; b=u4kSNKcoSJdw9mk7rPNoMnROjzwKu5ortqWKN3puxpuvnERZMy0vCr4928GYQhHCjmbGEJ2EfODek2jQaeiOyt1T9RSbllFQsx68rJRIItV1p7KJJJM/7QGVHe4MuqeaSvwMbJBvtWNH6hxoVyL4li8K/bnA7LmlD/G4Ue8qza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784332; c=relaxed/simple;
	bh=zTdqwv9Ssej6orvsbamVC5PHhURL+JyHsh7Gy+vvlK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B5QgbilpS+8ZFC/jzkmVQtjVy+CkulRptzkQh7CFOAUMYJX9d7xT1aCydyOI6Rz4qVXR7luZdkB0VlIGI5aK0d0X7vMEBh3VF+1feDBPpIqrKgzkfNZInYioLkp8tqYCliPmuOXjdpcg6XvIxR6t9arCnGSCVeCss2N6BnupjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kanvOKyp; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b2c49373c15so1233686a12.3;
        Thu, 12 Jun 2025 20:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749784330; x=1750389130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JaBNyC5lfL5DwQH+KQYKj542RoCqVrJF6tcJtmbxpA=;
        b=kanvOKypYcQh1zGFjbzRjor5jk8828yV1yYNliCBWZCLklkGlkS+6F7OmFdfzDEVMV
         6Ncspr8MqrQlVaJzun61nxlXAWK4sWdoRSKRBlicKaRYsjLN4651vh5Roqpzq3Xp1zQH
         My7xE+aooUpWyrGbzxrN21SUGa24UEuYEcQDVSrRp/NATrNSNmRUa2T2n4r3zbw5EvKl
         6yHtGvWXA3Wn8gJ2fJgGPN2JmXQpBmnj39BoutJjVEf9FyPLUghPywNgKUzoXMzER0hl
         hb5mDYHuWO4/L64YFKgTOt6/7iMjHMToevWlF4i3Lrrg3lqTiHe66GXVsLjj8xpZLoEk
         YOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749784330; x=1750389130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JaBNyC5lfL5DwQH+KQYKj542RoCqVrJF6tcJtmbxpA=;
        b=UoB4ZzeuCpBoYy9IcXs+DcqUAUiZcVr2Mu1wuSUVxqBsNExrtHmRG1DY3Gah647CJ2
         O7kJR9FFCmxQht16NooOtOLiH3dpGoTgd0EMycLwHtNRQWfAQEzCIinlQMoYHdGVcrwp
         xZlF3wI0d6WvVvCCzhXOv3p+Qx4QWj+0TUALKyevnpq6fZQnil4+oFbUL6Qmh3AP0Cpc
         /1o6ekFUEUBFEo+XLEhfLtYpca/tQwJzFPD7eZW+7eZ+BwKRr09FqCgExad64tUpJGa9
         2puZ8iBpQa5e6++qa8V0w6EgnwzYHgUhNf+WJwOmHy/T8A/e+tZqLzaKKeLDv37rdN1K
         tk2A==
X-Forwarded-Encrypted: i=1; AJvYcCUV4jc1Na/6eFIZJ22esb8jEUSwsCgVDX5XWql2hqMkn8LB34aIHi/glYNTdSn2H4oVWuQ=@vger.kernel.org, AJvYcCVYOGIAlm5DRLKFZDwUdA8kYAY2T17htjiGuMEV9f+V4yymIIvXhP4oUBdxggyK1Xbs8KgGO6gO@vger.kernel.org, AJvYcCVzGGVVioRgiBRA6KZX+uw9tmPjr+WWj9087Ahz9eERdWA5pToRymFpnWNS5k5ZBuXdhfHwz9zodq/ol0go@vger.kernel.org
X-Gm-Message-State: AOJu0YwTvk8dsEDCg9UB0YP3DsMXtQOg0Z0ml5Cm4FIflVDzn+PPt8Ur
	bAWzWrit1joirQd9EG0fg/zq5lJENsyAAyAN9IA/WVTCl/g3wFZek+QG
X-Gm-Gg: ASbGncu6YgjNJ14Ap5VTM7pd1soYUyMYOFMvcLgMk6KiYbespFtY4VYE4imolWSQMHD
	jicPtH21WZiAWjxwqFj4XCZLFekHCzTtc2n/SmrwizJXGukiECYvmtXLC76xhI3s/r4kozFnNbA
	oe8Y7r9HXGOWympu76RfORC7QyVe4gOPcYk4p7HN6TxSCyo+KDZg9Kdmw2BItTrAVdukKPwO/EV
	+FjdH1sZwgHBFGdQqnCmAXCCLN3QvrRktPEm1MZQ6C8t3dtppT+o8RtDdne2O1MnRoV2pAgVp5f
	PF1TAzkdIRKauRSPye0kWZaUory8A+lNwkTeVmQAW2hx3OwcC2OfbENMZ5/aIefBpsMMWvJ/FQs
	0k5iFaWf4
X-Google-Smtp-Source: AGHT+IF6ZIGLNpqqBVYQhsnYee4rQdJFSL+hFV4nO+/toKNKtFhZK00+NJViwASyw5ZSKmQr/HD8ww==
X-Received: by 2002:a17:90b:264e:b0:313:28e7:af14 with SMTP id 98e67ed59e1d1-313d9e93c27mr2245323a91.19.1749784330326;
        Thu, 12 Jun 2025 20:12:10 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbb39sm2291801a91.8.2025.06.12.20.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 20:12:09 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/3] vsock: Add support for SIOCINQ ioctl
Date: Fri, 13 Jun 2025 11:11:50 +0800
Message-Id: <20250613031152.1076725-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
References: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for SIOCINQ ioctl, which returns the number of
bytes unread in the socket.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d56e6e135158..723a886253ba 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -171,6 +171,8 @@ struct vsock_transport {
 
 	/* SIOCOUTQ ioctl */
 	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
+	/* SIOCINQ ioctl */
+	ssize_t (*unread_bytes)(struct vsock_sock *vsk);
 
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2e7a3034e965..466b1ebadbbc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
 	vsk = vsock_sk(sk);
 
 	switch (cmd) {
+	case SIOCINQ: {
+		ssize_t n_bytes;
+
+		if (!vsk->transport || !vsk->transport->unread_bytes) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (sock_type_connectible(sk->sk_type) &&
+		    sk->sk_state == TCP_LISTEN) {
+			ret = -EINVAL;
+			break;
+		}
+
+		n_bytes = vsk->transport->unread_bytes(vsk);
+		if (n_bytes < 0) {
+			ret = n_bytes;
+			break;
+		}
+		ret = put_user(n_bytes, arg);
+		break;
+	}
 	case SIOCOUTQ: {
 		ssize_t n_bytes;
 
-- 
2.34.1


