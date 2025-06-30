Return-Path: <kvm+bounces-51066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9844AED5E7
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C6AE1894400
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417B1235364;
	Mon, 30 Jun 2025 07:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPk7wZTk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1C230BF0;
	Mon, 30 Jun 2025 07:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269137; cv=none; b=M8JsnWkSC2GBATzIjRWqbS8p4r+hs6fmyi7fIONkCV5GUsSn6+RhAQ+oedxkEujmzCNDuIjAHQSvaD1nRRVxnUU1MIKraIf5YjxUcfyfIPO4KIBFzdCwAIHk0KirzLHMX79Ng73iAl7lClkyJrcn0xj8H9BsiQKqD2gCiYonDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269137; c=relaxed/simple;
	bh=8zHWFlCigM4oKQM+XUD7NX3O01Q7p6W6jnTQzPT3UPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=deESLCWshZMjtIUGQXWDzgdeFzF9g22aLKn11qwApb8ldUQMVBooyc0/g+bJzDYehvRFFSMp+eQ9RVrZAK2CQGV8CZnwvXT9TxoV536accyekf23mWRKW3owYX8mLACHeP9zxeJpH1RqO2Ok1O4lOXpvoLNCKc6ET+iZHUjtLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPk7wZTk; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b3220c39cffso2016027a12.0;
        Mon, 30 Jun 2025 00:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751269134; x=1751873934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zxu7ig/S9LCUmwMcMSykN7rd/mLUHqPQuKn7T6xu2vY=;
        b=gPk7wZTkRigQ6yMrSj14kyTtJwzxXQQSTEfM7ssB/kZF+SNxvPj2O50MoDRLh6aJjH
         pVkMxHpZ1h7c0xfalLieYhW3iGmGxGwIPlx/pMgF7et+cEMtqbjo9oRIp/YDnBIU3nmA
         wb7pYpOOQWuqtfBoI6EgkNKoy/LNgKyFbPcWS/asU4azFjWUNFjDmX10BzeOvDxZWxqK
         s8FWrXK2zP5fUi26bQpjT2kZ72D73POH2Cj9fWDwOR80+5n8+kclh+R60ClK67hINFhf
         Sap+Jb2f/82knBe5W+lITU98JTL2bDTuRmYH2V3lMpwEEbZRfaTiSwiwyvtXDbxRQCGF
         oOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751269134; x=1751873934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zxu7ig/S9LCUmwMcMSykN7rd/mLUHqPQuKn7T6xu2vY=;
        b=OPdtZ6wSCV4+bhTo7gfFZpo2TzU1UL03ohfmkVjmhutpQhYrsKPAh36k+T0y8oBuOU
         tNXg4cLqjCw5InsQhwQeemls9q+PUrked+jsN5k5cTG+ijkB2FJyYuMKs4FqO4chFFCc
         tmJt0clIy40YurQQ/0bQDc8a8bq40i8ZIHaqb5jBcPVAyiBwLBZkdA3SKPhp3ahJiDxT
         90KUFlumlmqn6/rFWW4ZmemzOtHX7gWNgGCP8dpgVhjJbeRc0I/DA0rBD2YT8D9DxLyG
         Y6ukkGquPUJs6xNexFBElKPYGCJOMm005+Mp3sffVMPavPFg+eg4zHCC8coY8QBxGwO1
         WPVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWDXm1Zs63pnPlv+KjEaaGJg1WmI386ylhKh+0WqQN98Lkw7zsmM5Qic6PNVOj8lykhsllcfUgy6va/+Wq@vger.kernel.org, AJvYcCW6sb8V5H5MX93EkPYE8rxYW6+caQv5cSD1GmeRc2NWQFAmhYInA+zJZs2pQmlo45pYpug=@vger.kernel.org, AJvYcCX4QUR/+JmU5EVQdn2PX4tjvhcXdC5yPYIafiCVwCBx+hJ94FwpZdIO6LYmfEivLVLCQ/wklCwu@vger.kernel.org
X-Gm-Message-State: AOJu0YwuLZ1tO6U/Q6ipHPRy7A9ShBgaZzOBRGsk2Zz1hPFNC2UltBsl
	hNmrNHcw5upOWLQNg/6zZ5iabKj1DaoJPkS5Y57SI49xedIlRKokN1RV
X-Gm-Gg: ASbGncuVE26FLWAxBYRrWCC1LV1rij12XxeyGIdfUgCrS5xfRFXpWnGvHea+8NsDSyk
	VJ9hoUEjsDBqeiFW/Rz9Tn8o/BTrCUHkMDrH9qB8lMJ4EucXcBqeob9IWgOm12xTqnSfl62GOBI
	S6Dtq9VHMh82roIl4+TYfwB1IBjWVCYNx+P7Cf3bfdA0OdYui7gva5BH5umJgsCAloht14bOIUT
	QvjZgZC+WZ+fBEYZM7ObwWE6jKGtRyt43rP6qd7cKDENW0NSoMmbXjfrfmiyoeUyiyuV+MWPis1
	p/XEB5Qak1JtWSI3ohKjc0LR94gJjs/A53FWLWoAigJzmttbatPJpPCR6ENcFPpdeMF5UmBtcVI
	WcNYj1ZDK
X-Google-Smtp-Source: AGHT+IE1QdmSYxev8iN4dxDowA6la8V3gpzolPl3kw80LV0ejyoAdzLd6I54yNlIqSmD3I5yGH7Rww==
X-Received: by 2002:a05:6a20:c704:b0:220:63bd:2bdb with SMTP id adf61e73a8af0-220a16ca7famr20405202637.40.1751269134043;
        Mon, 30 Jun 2025 00:38:54 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af55c8437sm8075175b3a.115.2025.06.30.00.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:38:53 -0700 (PDT)
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
Subject: [PATCH net-next v4 1/3] hv_sock: Return the readable bytes in hvs_stream_has_data()
Date: Mon, 30 Jun 2025 15:38:25 +0800
Message-Id: <20250630073827.208576-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
References: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When hv_sock was originally added, __vsock_stream_recvmsg() and
vsock_stream_has_data() actually only needed to know whether there
is any readable data or not, so hvs_stream_has_data() was written to
return 1 or 0 for simplicity.

However, now hvs_stream_has_data() should return the readable bytes
because vsock_data_ready() -> vsock_stream_has_data() needs to know the
actual bytes rather than a boolean value of 1 or 0.

The SIOCINQ ioctl support also needs hvs_stream_has_data() to return
the readable bytes.

Let hvs_stream_has_data() return the readable bytes of the payload in
the next host-to-guest VMBus hv_sock packet.

Note: there may be multpile incoming hv_sock packets pending in the
VMBus channel's ringbuffer, but so far there is not a VMBus API that
allows us to know all the readable bytes in total without reading and
caching the payload of the multiple packets, so let's just return the
readable bytes of the next single packet. In the future, we'll either
add a VMBus API that allows us to know the total readable bytes without
touching the data in the ringbuffer, or the hv_sock driver needs to
understand the VMBus packet format and parse the packets directly.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 net/vmw_vsock/hyperv_transport.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 31342ab502b4..64f1290a9ae7 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 {
 	struct hvsock *hvs = vsk->trans;
+	bool need_refill = !hvs->recv_desc;
 	s64 ret;
 
 	if (hvs->recv_data_len > 0)
-		return 1;
+		return hvs->recv_data_len;
 
 	switch (hvs_channel_readable_payload(hvs->chan)) {
 	case 1:
-		ret = 1;
-		break;
+		if (!need_refill)
+			return -EIO;
+
+		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
+		if (!hvs->recv_desc)
+			return -ENOBUFS;
+
+		ret = hvs_update_recv_data(hvs);
+		if (ret)
+			return ret;
+		return hvs->recv_data_len;
 	case 0:
 		vsk->peer_shutdown |= SEND_SHUTDOWN;
 		ret = 0;
-- 
2.34.1


