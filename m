Return-Path: <kvm+bounces-46962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DE3ABB58F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C638189462C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B86266EEC;
	Mon, 19 May 2025 07:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeFwk7aO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36D265CCC;
	Mon, 19 May 2025 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638431; cv=none; b=YreT3omztG9RvmyFZfKOMT+nBwJxLz4cA1ruxND63Z5sUzOI04m1E6V7QtYUGjN6OraEnFu5Vh484hoIw/+0e8rrqrrBHL9nSem6wzSb5qpwvx7BzZpgTjHndw4cRl5pafGEgYJZjpQlpyb902pMGkcN7XYh/Q4NapF66baeGv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638431; c=relaxed/simple;
	bh=eoGMF2Rt9uZ2gIcNe72NFY9+t/U8Awv10xG4k5ShIao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UvBgdY/gk2kcRGCmnhBeFMUIX0y/jjVgIBLEYYhuHU0DW0DegaGG3Cvr/XuiPyAOmkayALU64djhOCqZoiICebG2KFs6ymPi1ZPUMic8aFMZt6DSAu6xhDMbUZDhdGl3yQk1We/ZJBXGXVyqGcCvAdOVRRcLswPcjpYtFqEhSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IeFwk7aO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-742c27df0daso818801b3a.1;
        Mon, 19 May 2025 00:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747638429; x=1748243229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHAaWm/nwPVfz2tbZm/P8yaDDY/dUJ8pDKEX+ugzIbQ=;
        b=IeFwk7aO4wqUwyq9P67QZiI/r3wp4VOPcoMCeS82fqpZRDXwXUZy1jV/0LFJvG21MS
         IXS7mUWxYXKmaR1yS4u0cynlH24iBgmf15NqpHHhPbLnAat5Ar8TLcROcniuWzEQcHLc
         FMzUXPRBE5Fs4YCuPC92a8Plk3lNkvUdzxWn0buq5G1H6nB9t2ds9JDEmMWQB9Hnpl9G
         VI7Co1V9sKIIJbZ5xYMLQ5jXSqGI0cahkFCe0vI496PW6xGPd5/V+AhTe8sYQVr5EmuO
         JvvK/tHhYY5RFi6cTcQLR6/GgaxjCcgLdJjkR7mGo1TSG0RBNjiUrYnvdwmH9CbME2kw
         1e7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747638429; x=1748243229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHAaWm/nwPVfz2tbZm/P8yaDDY/dUJ8pDKEX+ugzIbQ=;
        b=v1DqJl71IWVo6lIUwoSER8H7mtE38jwO6Z7EzBjN5S96gc7ZiSArAHM+g053alZVMS
         Wq1BzF5++Z0/zbqwJMumAWVhGKvItrla9z6yUGPhINiuzuojpymUWUk2yAjo+f/RiUBr
         npdFl2bvTr9ctgbEJ2F6tnyef7LbcpUmgKTNIyrWLPIhgCU7u29lgWX9c6C6qdtGrsVl
         gVzitT3UWQ0yKcwywCQ26c2O72tvnQu4p5AnHov57ALlc25N+Xi4rS1OBGnC5n9Y2Uhu
         BzrUWUdLZxcFO9YUOYRIHpQCEmdnyt9pIhTP2ezQMT6FL/xY0pZszUn5zK7x1F8S/kdt
         rmdg==
X-Forwarded-Encrypted: i=1; AJvYcCVBxBm3bRgFgQPgMsHXdrowzBjGZZdzKk62HvfhaLuCyO1wRELqspI3nRqgClzjvZ3FScg=@vger.kernel.org, AJvYcCWRSUUlXRAfr/wcyVBNwnMfGkU01XethAKZ/XgZFlySQFCxrCggwlFY+pM9wpsPYxVgsNsPkD0XA1K4lWT5@vger.kernel.org
X-Gm-Message-State: AOJu0YxLz6K3j5Jc7g6Uy+4PKTYfDYgV98Xd2a7ual1b4qvNVEq4wfH0
	HCFl6hHcNfOsGjWfjNE5PacAKVCrvu3MHnu41HAcBB5BpV4cUxgiIh0I
X-Gm-Gg: ASbGnct59Rp6+uXP6U/fmOD7Ok68jaE1sbp8J46ogqFp0NR/3PJKhb+zR8xAKSR9zK5
	NF0GdHeyTPZoEJcRA1jFOLK5BgTjOREksmvjF3MZeK8pjJWkG0lJyCJKtnd/GOEJWHMh/+1M1Sx
	M8q/ftKpgRtEbKIA3ciTW2fUxtxpf7qm663KSYevzbGfsJFdFyYJzAMLO1urJvS4beGbOpRqwSN
	uIsliXDbHRH6FB2Bx2TY8G8q98dEs07JoPW/eevbBYaIWWM0XdNn+tLYwUdTk5gYYM4TviUNhfA
	dWlYGWaNrrRwy2ZEWHIUd+ofjvkT7SLKpQ+1zObrcF11kI5p71Q+08h/+TdapG9RQmc7d0Qjcg=
	=
X-Google-Smtp-Source: AGHT+IENpOr+coy+nuUYSAQz1G13SXO8o5nY1ZaRb3QaUw56V4IvmR4mxX3+5YP0g6/vBT3U7sT4sw==
X-Received: by 2002:a05:6a00:9455:b0:73d:ff02:8d83 with SMTP id d2e1a72fcca58-742a9786a85mr17865169b3a.3.1747638428863;
        Mon, 19 May 2025 00:07:08 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a0120sm5574336a12.63.2025.05.19.00.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 00:07:08 -0700 (PDT)
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
Subject: [PATCH 1/3] vsock: Add support for SIOCINQ ioctl
Date: Mon, 19 May 2025 15:06:47 +0800
Message-Id: <20250519070649.3063874-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
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
index 9e85424c8343..6f32a2601a49 100644
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
index fc6afbc8d680..288bbfd43bc5 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1356,6 +1356,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
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


