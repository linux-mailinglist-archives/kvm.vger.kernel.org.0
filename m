Return-Path: <kvm+bounces-12609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B831788AC8C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6EEE1C3D4A7
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FA613D285;
	Mon, 25 Mar 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LF005WrV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C9813D265;
	Mon, 25 Mar 2024 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711386786; cv=none; b=sFn/VMBYuiAX0JiWkLagkTUvqs5WS4RhSBLlapvqErBVm6NxvxToMDxIHKgruhvYjImTeJwjE5fSc8zcMQ1rT6Sewilz54s6CVekvjZbpMXDj2xBufA7o7mceClXDXbCvLiPJN9U2KEQ5OZq+G1esaUIRuuZ1W6VVuEiyrs0qZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711386786; c=relaxed/simple;
	bh=0ZhgzFV5Xt/mswqGy6lswxgldIuR6Mr25B7wtDUTbrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pn/L3i4hsXEYj621Ey1ghptJToxff/voKayeDMXFrcG4ZolVq070f5Fs4Ln5fMqvQ1rfTwBa7nVu6mfAijB3I1igdjjPoX4jPvJ4nnjYW6XjMEiuBCIVA7a2SNVyQe01pAq0A/REGQYLZj+h57Cv7TdmQoDjtpoxXSPhhEuuIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LF005WrV; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513e10a4083so5134022e87.1;
        Mon, 25 Mar 2024 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711386783; x=1711991583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6X1NNxLlcRJ0g+9m4U+W77i//Qg7iE4ilrLW92aE7CM=;
        b=LF005WrVVtFb1+wnCyhHJR/O4Tu17HjgWqWTjNAX22BHiDn8LRrJh7U9AGR0v2UPT+
         RNZkfcSoa9fExJAurLDaQTF9eQGdynuaYoFLIwm7BRU1CZ+CEK+s9sFN3daTLWOozAJz
         WRUer+dAGX2mw601frqOixEB0qxFe72KeXZIbIRdR+92B81MpbtT3265wN46LGszp97L
         ge46B76q7VvWNywk3lvZJcJdr4bqgy3r5Q47QJw0Lm6sa2fjhsrCXGmfLJKumJL5RgL/
         S9WtPt8sb6f8wnVwN/hCJY2fwfIVQYJ+zQ/UWIyALzFsAR09xiIf+ZWl2q+koT1LYf5G
         IVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711386783; x=1711991583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6X1NNxLlcRJ0g+9m4U+W77i//Qg7iE4ilrLW92aE7CM=;
        b=J7aC3JGBb/KMne3gSz9uQASHi+lxTGDKMHCc/t9EI3+sWKwnyU/q2Z2frUKpWUXCk7
         IfF/+wsvE7dssh+en17MepfPqovMNcmPatoGhA0zlm6TuPZ1CpAsGrq21CFOleT9UZ8i
         XWmFU9c0kzoqW9Mi0XOO8JXjC5HPBvdg1QR9FK7Lj9XGOhSQVuujIPk24cno5QttK4Y2
         Yr+v5Kib6RQScjrJ7Cn3CLKOJAJmWDoMXfe98Iq9sbgsG3kOzRir/tNGLcz0lAnp1XbI
         sxoeIeXYrZV8Ej5FNcrJv5jhcQ/cnz8+5sAf3Ukml1neHccCC4HHZrN2OXHCBFZIL9ln
         Bu8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMCAtkZ0Sc4bH3p2CbebsVk8nJ0X+4wMgkQQI/z+gmbVnjag6gQQoAbI8D0AKUqMCMOlSjfU2+CpOta3w8V0bhXas5fxf+FCPRudJTtmn2weawXZMrPET6VBoZ4EYj5c1bdZjXT4Gcx78KXaGQ6cpa+oVtgTsWFyOa
X-Gm-Message-State: AOJu0YxsfnWC9Yutq+0pim0Fdakca+3hPAsJmmadyN3ro5nfsYUZmgWV
	aT2J99TYVyqwyHWLZne5FJ9vXWAEbeEFbU7myzj5r+6gkwqKEiyd
X-Google-Smtp-Source: AGHT+IEMfYysiCUhsoDAJD4rwXSiQC8clzZILdXxljLw1O/gnZYMnp0fL9CFIQ87w0fRRjJ8GC4krg==
X-Received: by 2002:a19:6406:0:b0:515:a523:d38c with SMTP id y6-20020a196406000000b00515a523d38cmr4000791lfb.63.1711386782887;
        Mon, 25 Mar 2024 10:13:02 -0700 (PDT)
Received: from localhost.localdomain ([82.84.234.137])
        by smtp.gmail.com with ESMTPSA id h4-20020aa7c944000000b0056bdf694890sm3225666edt.43.2024.03.25.10.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 10:13:02 -0700 (PDT)
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
	Marco Pinna <marco.pinn95@gmail.com>
Subject: [PATCH] vsock/virtio: fix packet delivery to tap device
Date: Mon, 25 Mar 2024 18:12:38 +0100
Message-ID: <20240325171238.82511-1-marco.pinn95@gmail.com>
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
whether it returned successfully). This may cause timing issues since
the sending of the packet may fail, causing it to be re-queued
(possibly multiple times), while the tap device would show the
packet being sent correctly.

Move virtio_transport_deliver_tap_pkt() after calling virtqueue_add_sgs()
and making sure it returned successfully.

Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
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


