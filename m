Return-Path: <kvm+bounces-67894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FE9D166B8
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E6F38302EAD6
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFCD30FC2D;
	Tue, 13 Jan 2026 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irPpLPU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D944D30DEBD
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273980; cv=none; b=PHSDsGUqwZK/d2v7aZEJ9vqfGEOKLaV31Q+CgxMkPyLls1XO7qZ4TBxJDdBZfUfdfs/QF/zwK2E8ptcTNnxL2NvOZZn7kQQN7lz2kGkbOZK88kl5Yz4oEtebTEatWfGRM07zAXFs07w+nY2Pya7SMVYlHRn7aDq538HdVg93oyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273980; c=relaxed/simple;
	bh=vD964Lj1wPSOw/16ssWykcRPX0KDwrhlz4wvw7+NTyw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qamtTZQUUww56htk9GMzh+/tgYzhyyj/EghWyUh4mGHFF9+FPiH1WFJn8G4+mt8xQu1d5rWLHhETbsfvYah3Oc5tHCM2ak4/FyyIS6ZIS1FPVn2RfaFIKYyg0SKqAzdHyoTZJSIlvZxy/K2QKqne+X4eTEa9KrD1bT29GiG60PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=irPpLPU2; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7927b3e5253so20640897b3.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273978; x=1768878778; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=irPpLPU2XzmI+2sVaJdVcskUb/Tttp2FaeL030WnEqu/DYNJPFMCTG7PrKIJL0OCIy
         Pgxz1DBwFphhLICgm19CHrv/fo+K3Q9MMMI70K+wADSmbbeM4o090UvrridrdEGg5ZpZ
         7hOqPkOHz9jZFErUvSC19JrSRL08gNsE3EelM43J3hejO2WbjvO6tHNbmXGQYZG1DPFb
         xgV3doQwigaiGiNnu40vkPsFTVeNCoEkfmDR2H7JuwqCLAbVHA3Dyp/trJkaE6K7wIrX
         Lq4D5m5tB/SndBie0zEwcAHsb4obYWMyHbb9oiXOgyuwzzh3tVhtFnARjTU4jwG374r5
         a9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273978; x=1768878778;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=lzK71M2S7jReuuw7kXruQWC/Kd2ZUHjbzqwj34oPvAt5HpszDu49Gi7MHvTApImHZc
         W7kt3LQWLDVXsXa2eVqGM9zsTqApIEs4syIdzzkBBtahG9MnWxH12Nti6GtPyh+cP+MU
         QQT0CwW2J5b6WIntHO1dV6UAHZJ2FPIc+XSWu7bGH3kAM/UxgUEMCDlayxv/fnHUtTda
         ykxrRBs3N0sG/2HOWjXII02B86vJ0bg+ZKsK7WTS7FmuAHhyYNFAlKa3qwn9f3DgGwzE
         +2TCVMNgizD+ehwvOes5nhctZ8kUDDtMS81VSv+txYNXpSs94yj/UselGAdCa6EVqLAv
         8qWg==
X-Forwarded-Encrypted: i=1; AJvYcCXHDQKiW39EiFhgWIjfugg11FglK/pCrrKuvhbAwINHkrqzQMxTc9djTkSM50vRknBNtbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhgFbdDi2FSUMkzREQstLpvgpeCG6fODEuURkJeM1w0y2KG5Gi
	7NGgcWNzNrUoRqjkoWhDHCKiwXfbF1uFzVgfFL5DU0ebC0jEbAjgIP1J
X-Gm-Gg: AY/fxX5iauiY3caAeP4C2q5B9iRzE4oBY/d7kERr1q8U8REdr6yJGA8GaKP83lrY7y3
	tw7d4iij535ZVL8hQ7pf/tbcZXdYTfNx8v3ERfEyfEndXRhNjH3LBLuzyUpo3pQWCbQxos2/Hzp
	nbyCZEdfvWr4Hupbu8yiGs9o9vlgjQsLSj2QF+kwa8d63koboEiHT2xj3BX1upZiDYP4pIlwGfN
	jnOgCjokdquMmD+KkzRchKOFFPRWUH+SL1e0gJU0pBKipyZhLO9QPfSd3mv5kEObs9sNuizMAfQ
	MgWddY5gEfEe07arzUWN/lCLJA0cwrchbFddIEKxz/v0NvKC3azvfqNmnpSEbF8XADEZTwtPPip
	art9RlluL2Ah3eifuq2ihstnQI6xF1QWkWOf0kaK7NodIyqMUvODCXMdc0IBEVTWGMNSbfuXIXC
	Vwa+x4dosAYw==
X-Google-Smtp-Source: AGHT+IHcF7Zmu1veaf8u0eg/Kbb68KxKW7zWjXp5XrByj/JKfJyEyOkbbQZuZ3nalmLjzPkGlfdNOw==
X-Received: by 2002:a05:690c:6285:b0:78c:2473:ae79 with SMTP id 00721157ae682-790b56a66bemr171959117b3.39.1768273977917;
        Mon, 12 Jan 2026 19:12:57 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa592cdcsm75715147b3.25.2026.01.12.19.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:12:57 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:11 -0800
Subject: [PATCH net-next v14 02/12] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-2-a5c332db3e2b@meta.com>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
In-Reply-To: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Associate reply packets with the sending socket. When vsock must reply
with an RST packet and there exists a sending socket (e.g., for
loopback), setting the skb owner to the socket correctly handles
reference counting between the skb and sk (i.e., the sk stays alive
until the skb is freed).

This allows the net namespace to be used for socket lookups for the
duration of the reply skb's lifetime, preventing race conditions between
the namespace lifecycle and vsock socket search using the namespace
pointer.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- move before adding to netns support (Stefano)

Changes in v10:
- break this out into its own patch for easy revert (Stefano)
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index fdb8f5b3fa60..718be9f33274 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1165,6 +1165,12 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
+
+		/* Set sk owner to socket we are replying to (may be NULL for
+		 * non-loopback). This keeps a reference to the sock and
+		 * sock_net(sk) until the reply skb is freed.
+		 */
+		.vsk = vsock_sk(skb->sk),
 	};
 	struct sk_buff *reply;
 

-- 
2.47.3


