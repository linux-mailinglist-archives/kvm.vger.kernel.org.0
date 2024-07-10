Return-Path: <kvm+bounces-21352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D44392DADC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22154B207CC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1872015ECD9;
	Wed, 10 Jul 2024 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1WwWfhD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60379156238;
	Wed, 10 Jul 2024 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646765; cv=none; b=DwcillEvtuVhXf+pkAJGa5zOSMqRFBRyUj2PauNjTU2vjB+59HYGOSh1salDLi0uxtvFSlbwn1qSSU938RbsdddS9O6sSjMkwBjWtalkGY75p5gSivH6+M6rnITizULzW723IVn+It2+s1Ic0RKTOKIxHyfGjaSjz36Z7CRWVvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646765; c=relaxed/simple;
	bh=J/OYaM6+jTGguEhL1pMHM9vGNQQe8xO7deLzLD0Zrlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sk9hROwv5BqPOpRhsg7/HYYlRU29CkzHTBAcpabeZglLJxcFOYZtR+V5yJlkE3djGGpCPBrhK8L+cdxKkOtPpdUIqTcFG4i/UgsHq+4uXE9MxkqvEDkOkwdt0qXyyHrAJP1NpPkCllOHYHN/772nLX4t58KLn+M6ze32RLs2LLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1WwWfhD; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d9bcb47182so149574b6e.3;
        Wed, 10 Jul 2024 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646762; x=1721251562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZum7xcXnx/YZciY9jm1etfeGDFDR11AzV+Fk8UpldY=;
        b=j1WwWfhDliyfqk7jkdNBFvxXeOzqA1npLhw6UgLs6h/JJLhRavoMeQUSfMWNc/y63Z
         9Zd7utwewuW/TKx7TRnVBt1IVDefMPXFvss8zRYDafgF+poWvNvVaFYSzCFQNT/EWWOx
         9oWodGlIvnhWlCpXSBHBO+sbYpram2krMDQQr0co3HJVvFn9C+MdADp8XFVev6B0TQEw
         q5ZOLPvww5UZalCFMFmIKGI5JtUuPovvKuxEQ5ny087BXA4j90VsaYJY3vLXk/aqmwdX
         /OlwQ+RLYnXIxex5gqXQAbTSDII4K30o0X1HUWm73ZUPfEj3j6b1eC8v+S7x9GLNNCex
         Rndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646762; x=1721251562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZum7xcXnx/YZciY9jm1etfeGDFDR11AzV+Fk8UpldY=;
        b=l36AfmQJ5R/KgyRTDKku7VAXwe75FrtZO9iWy6UyON4s+vYoLQxbHCibPLqZqHa9oL
         1RpY8KtDe3pmSLkpvwhoHOYIzB9C3u9nfek1yMAQscxgu10qgb9I/7tInMYInax+ukh8
         kSuWyu7jeEYbqv/D55e8Su8YAYk2RD70FnR5v4F6j+a465yeg8fzXjtNVIvhuTkQV4xw
         diqD7mgQZDjhii+KCV45wOL5ajoPNkyuoF+gKp/rudrt0iF7n8849yvxJp9ysI89ZqTQ
         5m2f4qLnsBbRyL+6DZBYRmdW7aD6K7pSRStb5cPiQWUdraM1U3lCrNddisc4YrVw7v2T
         pLOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVna4Fr2sBTijJdYB3EKGiJwuphZlFDXysQ9WGE2tl37+X8KcBj5alQtGFROeDJpSAp8R21sLzxx2Zt4FdCNae6l+qbGv6lfHt5BY/5mw4nceyj7qmy+yCMjl4y+6Zn48kGBW785s1QdHP4XzBYqXqKAPD1hjz+gpNJOK12MbJ34M5tPlE19+154NshaP0PIjkd6crLNOZ2ahQDKKXIylVxus/0dmeLriMY6KKH
X-Gm-Message-State: AOJu0YwYfN7A+5E1wXt1HUiaHZvri9ndjoqG/jHTH4dBlW6BdDtwFhJ6
	uEuG7SD/+puF7BOEDeYFK3XJLnjMeCupxqqJTA+IWT3Vh+4mQYOR
X-Google-Smtp-Source: AGHT+IEwAeV+NVV9eWvJ41Uh/5eeH740eMks+WRw93+ZS4FZF5Q7SDWMuOErRunlQoY//g+dgPPf/A==
X-Received: by 2002:a05:6808:1455:b0:3d9:2925:cd37 with SMTP id 5614622812f47-3d93bddf767mr8767261b6e.2.1720646762507;
        Wed, 10 Jul 2024 14:26:02 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:02 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 08/14] af_vsock: add vsock_find_bound_dgram_socket()
Date: Wed, 10 Jul 2024 21:25:49 +0000
Message-Id: <20240710212555.1617795-9-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit adds vsock_find_bound_dgram_socket() which allows transports
to find bound dgram sockets in the global dgram bind table. It is
intended to be used for "routing" incoming packets to the correct
sockets if the transport uses the global bind table.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 6e97d344ac75..9d0882b82bfa 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -218,6 +218,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
 const struct vsock_transport *vsock_dgram_lookup_transport(unsigned int cid,
 							   __u8 flags);
+struct sock *vsock_find_bound_dgram_socket(struct sockaddr_vm *addr);
 
 struct vsock_skb_cb {
 	unsigned int src_cid;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f83b655fdbe9..f0e5db0eb43a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -265,6 +265,22 @@ static struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
 	return NULL;
 }
 
+struct sock *
+vsock_find_bound_dgram_socket(struct sockaddr_vm *addr)
+{
+	struct sock *sk;
+
+	spin_lock_bh(&vsock_dgram_table_lock);
+	sk = vsock_find_bound_socket_common(addr, vsock_bound_dgram_sockets(addr));
+	if (sk)
+		sock_hold(sk);
+
+	spin_unlock_bh(&vsock_dgram_table_lock);
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(vsock_find_bound_dgram_socket);
+
 static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
 {
 	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
-- 
2.20.1


