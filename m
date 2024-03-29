Return-Path: <kvm+bounces-13100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E4689215A
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 17:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03900B21FDB
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD7685C43;
	Fri, 29 Mar 2024 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lAb271IH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D9617E;
	Fri, 29 Mar 2024 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728806; cv=none; b=F2JVECFTrjYqAZqZN8JPXzNOZGZ/lufdUV745RzBS4/eGA8WQS1HscRokP0gd9niJPaBkMbk+jM6+mexJxJWL32vzQcnChpNGkm2iDCeMwSPBpTQWs/UmfTIP84I7bCILjbjHFI043AA0KBEbjTR0648VsgXAWYV5ZW9VjK2kHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728806; c=relaxed/simple;
	bh=I6FaA8lE1xu3cAiFmF8W7/Zh4WtxN7EK1Ev2dqCqEoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TdzyUoXl+4HQ0UCL3cLzwG+aM4kpgUqJFMZmp3ledCMtyUnn3UbM0ecWe3oVoPMPSABF2BynfdD7/KkFdv3TXgxiDBBC+eQHiJUVhP+nfzMTywk3NLulf7hS7AH6Mc67EyiILHbP3HE6yzgGFn6BD0dvxAz0wegXcr8hnCxwUho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lAb271IH; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-34261edaf7eso1434695f8f.1;
        Fri, 29 Mar 2024 09:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711728803; x=1712333603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g+ENIHdShqwsDq8iCSWp4zm4/fE/0J9kqrrA/ykJ7CU=;
        b=lAb271IHKTAfLugLDCj0uSeopS7vUiIP6f+KHAa1s9YE/57qq45AVuivO7ouIGOL+q
         YcrpI/yVeGTV22LRoH+L5qnbKqu2d5yUrzb2LlVTYR1Vbfn23Vjr97iiqNV490o9q5pv
         YjeKTyrN2LyUaEngnjt1yM1G6dScpXxwSjEWMSRDASzjOOHs/wZramX/ra5LcsZvcqBU
         /tv2bHoOnywNuzk89AP+t9fRDVwuTJ9Bi9HVXZQ8r54Cz3JEpIG8rzIb16U5k3JN2JLm
         0s4LdFTBQAPU/bY2luB9Gybxh3yygEnOk8oqp2oseLUQibnyTDV/dAK3POpLIyWidUcm
         Pi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711728803; x=1712333603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+ENIHdShqwsDq8iCSWp4zm4/fE/0J9kqrrA/ykJ7CU=;
        b=BHUZXj5KK8eWDaI3sUNULxLDNCkDWFquxngBuR93BOQc74WuMY++tt6Srave+RTvOQ
         iYqde4jl0r9INElYR8ENgHURgXM0szkG1yKA0gmLn9IFLdOW+ab5bc0BKdA+WV1MNfPd
         08dFadCybdu258APvfyOHq2m/MwdkKqdPrEjZHW6QcJELicDHt/F0/FFh2IThruNZj92
         NcT4NITcp1nzumcQOivGwahTNZvHzReHRQyhJHtB5QlF5iHinwuVskd+AadEeOAsKW6V
         VYdv5p8quiZX994rslCrbUbAwzwRUl/ksQMwnuOcePkrcsAp0++xqi5BRDOGdFAk6EV8
         vZBw==
X-Forwarded-Encrypted: i=1; AJvYcCUXQqgLjUzf92nFDbin0oeaL2WLXMuLo2GCyiRsErp8QwIa+WwyCH5sA3K3HvOOLYFGE1kcw7iu/SVOPAhftL+sXvDmRYlQc9mNzH/wrE4c5myHY1jN0zvvC8lnzSbhPLMWLsyLisI4jGuJD8Ahwy9KWDPvpDY5oVNR
X-Gm-Message-State: AOJu0YyiVWPnePk90XHoCh8Q/dcEE/f4CjMGaUGn91+lgu2JfT7z5WTG
	EiDXf1Zb9FeowjDWP6Z7/tp6vvqMz+XoaETmLhSnNt5yFaZ3tDnr
X-Google-Smtp-Source: AGHT+IFlnSDXyqsWCoK4FhHyzIj1G42ZayTzwCniQd6CJMOPqt0tBI0jfZghP0OMpk25e+c8DeoHdw==
X-Received: by 2002:adf:f982:0:b0:33e:c69f:2cae with SMTP id f2-20020adff982000000b0033ec69f2caemr1453465wrr.23.1711728803359;
        Fri, 29 Mar 2024 09:13:23 -0700 (PDT)
Received: from localhost.localdomain ([82.84.234.137])
        by smtp.gmail.com with ESMTPSA id u4-20020adff884000000b00341d9e8cc62sm4464208wrp.100.2024.03.29.09.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 09:13:22 -0700 (PDT)
From: Marco Pinna <marco.pinn95@gmail.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ggarcia@deic.uab.cat,
	jhansen@vmware.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marco Pinna <marco.pinn95@gmail.com>,
	stable@vge.kernel.org
Subject: [PATCH net v2] vsock/virtio: fix packet delivery to tap device
Date: Fri, 29 Mar 2024 17:12:59 +0100
Message-ID: <20240329161259.411751-1-marco.pinn95@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks") added
virtio_transport_deliver_tap_pkt() for handing packets to the
vsockmon device. However, in virtio_transport_send_pkt_work(),
the function is called before actually sending the packet (i.e.
before placing it in the virtqueue with virtqueue_add_sgs() and checking
whether it returned successfully).
Queuing the packet in the virtqueue can fail even multiple times.
However, in virtio_transport_deliver_tap_pkt() we deliver the packet
to the monitoring tap interface only the first time we call it.
This certainly avoids seeing the same packet replicated multiple times
in the monitoring interface, but it can show the packet sent with the
wrong timestamp or even before we succeed to queue it in the virtqueue.

Move virtio_transport_deliver_tap_pkt() after calling virtqueue_add_sgs()
and making sure it returned successfully.

Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
Cc: stable@vge.kernel.org
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
---
 net/vmw_vsock/virtio_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 1748268e0694..ee5d306a96d0 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -120,7 +120,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		if (!skb)
 			break;
 
-		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
 		sgs = vsock->out_sgs;
 		sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
@@ -170,6 +169,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 			break;
 		}
 
+		virtio_transport_deliver_tap_pkt(skb);
+
 		if (reply) {
 			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
 			int val;
-- 
2.44.0


