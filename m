Return-Path: <kvm+bounces-40855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8BFA5E5FC
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 174AC19C0AD3
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 21:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08C11F150A;
	Wed, 12 Mar 2025 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYkrB4xp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A91E9B32;
	Wed, 12 Mar 2025 20:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813180; cv=none; b=qpvGSuLFj/NmSpmB72iQA11jsO2MxwGFXyR59c7o4NAJaVi41WJGm81qMIYfmswuaUJUJ0EPGUM6XP3aZo/ed5pFKGW3VHBqMlil9MjQUvzGhSxP1iihzbNXCOkjH95T/YP5WRLk01J2b5cYBuQt1AxibT5RvU9zuDNMSDLpu+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813180; c=relaxed/simple;
	bh=sGE4HOOVVz7WqVzh06w2jhg2dPFxwpHqjhV9mWqBrUo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=az46zY+woIEeQMoP46qGhzOnE2K9DtP2CJPvHDqmdtim0daAmBEjOloIjOdnCcXaI54BHZEyQy7wZ+CRPHJlWLsbacU9YQdVQwKbRF0QcFRVRf/6zelMy2p5BCS+UbNV37tJ8cl8jiAPFC55KgAq732eqjL1j+gPSUDBleEbug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GYkrB4xp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2254e0b4b79so7317555ad.2;
        Wed, 12 Mar 2025 13:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741813178; x=1742417978; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ub4jX9+0jei2hftTvvZhRExenmWl6dTs0WmkODruC4Q=;
        b=GYkrB4xpEzT9UxPjrNnU8XWxYAN2UxodCUp9mnFJKbyndAO5N2sjDD24Dy9QY0mGbi
         NeaV0jkcVd+il59avMxwFenGFokHoGEC6Z4/wLs1Lg2bj+NRWtGA5s242DQ2LXzN4+50
         4AzVNKyH2jZeNA/Zr9wRFGQUqBas7CJMiH/yXtlwfDvp4XJcVFi+IdN1fNT21wgfQtcM
         sFxl35W+rNy9vwa89Z6Nz1rn/28nsKDrBd/AC7PTYi1wptOvKVAzxKWhOoiqrSrwH3RB
         LfCULYhWnCugIM0du97csNyRvNrywVl03yeeSTES4QF8g0ByyVC6SpYPoPdUyvYKChTg
         YP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741813178; x=1742417978;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ub4jX9+0jei2hftTvvZhRExenmWl6dTs0WmkODruC4Q=;
        b=HRaZFA/DZYvLGJBV94tFcfFMzkT1FYPr+Ygvd58Fqo815saPtvmZdTbg3iFliwoKVz
         Ww7YI22X1TYHRVD4c7mW4deefCPzDG/8uwv+bcnX7AFYp2nP/lZiLPrrPlmaQ0Fy9cFu
         SICFBVpKYmbCmb8B0yoH/GFByD36YN/qm0Qm78s7iGQO7LDpE6kOte0UkAaC/ssqSs2p
         IqC2C+ken1WxVDd3Hw01IEIcrWju3jE253JMCvmz6rlsah9Hi3aLK9qyf7kek0rB52ve
         RJMZ73igcJlCIZ/pX22D7HtuY4tit0umsQQBYnGLYb/hIPaSdiELGfjvJh/eRxR5R3Ow
         3y6w==
X-Forwarded-Encrypted: i=1; AJvYcCW/5M/ZJozdQO5IQXT/xSC9qBsZSo4es/9aq4LD0ktnCa6YbO5T/bPq7v1JJosW1YAggqkUKxlk/FCBTVhx@vger.kernel.org, AJvYcCW50b/5dkj/HrdME53VkWg07LUqjXQ71vQaTKACf5F3zTX2z0h/cfJ2ai1myFg5IIAIjYCa3ZJuGHUpx+5v@vger.kernel.org, AJvYcCXJrxiRgp7hjNga7D94GFFLfIqynhwWjhNyd/qVJuwSxsplmztAaqWsbdvz2HGdvJPPCZ4=@vger.kernel.org, AJvYcCXcYaIPzaQl35IkBQU1TZrCEIh1eT3/7D3a082FJjcdUtVthNZJWyXj+XRruGUsrBfnTha2gNnp@vger.kernel.org
X-Gm-Message-State: AOJu0YxWeWm2KqbRjePmT7H0V3CB5g98a2mf2WYX0BmADkyyEvLlx6xT
	xRl3Nnzvao2GSYmQAxu7/lrPA9SLBXs2YxfvmDTboFnd9ZM0YYY/dU+nVrjj
X-Gm-Gg: ASbGncuUqq57HNWmiCw4Wz8LZSLX2/rk0GKVcKBugDVpwR3tMsO8rJXeOaGQdwmPdwr
	PQlVjBJwGT+o5EAWSOXeb8psIRNOpz9hGxc0FP0lJqeXYUuS0lBFCSCLUeHU5HaDYi/Ht58+GN1
	0sNVCif8IBx4zWiBnyx/GLNRdfwyfmnFAqgXqs7aT+vZhH2WTqj4ZybiHu/mXsTTnpAFCDnQ7Ru
	NzVbPvGqVn3C7SJGcsNCYHpxVezg4I/hre9JjNqk55gPeEzF9DjiIsKs3sia6vzpPaiOf5AcCA9
	HTG5vcxNZc/ie5hCQ1OdcNOZmBL8x1jgCwN6hWoUhQ==
X-Google-Smtp-Source: AGHT+IEqhB5kSkIfZY/GZuI6Ky/XtS/IfhWT5TgQfFV/WZTAIT3v8fj5RDGB7a85bswkz94fpuya5g==
X-Received: by 2002:a05:6a00:2d90:b0:736:4b85:ee05 with SMTP id d2e1a72fcca58-736aaa56dc6mr29765479b3a.11.1741813178520;
        Wed, 12 Mar 2025 13:59:38 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736bc3f40desm9732470b3a.50.2025.03.12.13.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:59:37 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Date: Wed, 12 Mar 2025 13:59:34 -0700
Message-Id: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALb10WcC/x3MwQ6CMAwA0F9ZemZkLUOUk/9hOCxQYDFupiVEJ
 fy7ges7vA2UJbJCazYQXqPGnKA1VBjo55AmtnGA1gA5ql2FZFfN/dMmXpJaXw/h5smPDV2gMPA
 WHuPn3B5dYWCOumT5nvmKhx6Pc4gXbMjTtawQfdVYtDoF+QXhu/Awh6Xs8wu6fd//lcXAqqEAA
 AA=
X-Change-ID: 20250312-vsock-netns-45da9424f726
To: Stefano Garzarella <sgarzare@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
X-Mailer: b4 0.14.2

Picking up Stefano's v1 [1], this series adds netns support to
vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
namespaces, defering that for future implementation and discussion.

Any vsock created with /dev/vhost-vsock is a global vsock, accessible
from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
"scoped" vsock, accessible only to sockets in its namespace. If a global
vsock or scoped vsock share the same CID, the scoped vsock takes
precedence.

If a socket in a namespace connects with a global vsock, the CID becomes
unavailable to any VMM in that namespace when creating new vsocks. If
disconnected, the CID becomes available again.

Testing

QEMU with /dev/vhost-vsock-netns support:
	https://github.com/beshleman/qemu/tree/vsock-netns

Test: Scoped vsocks isolated by namespace

  host# ip netns add ns1
  host# ip netns add ns2
  host# ip netns exec ns1 \
				  qemu-system-x86_64 \
					  -m 8G -smp 4 -cpu host -enable-kvm \
					  -serial mon:stdio \
					  -drive if=virtio,file=${IMAGE1} \
					  -device vhost-vsock-pci,netns=on,guest-cid=15
  host# ip netns exec ns2 \
				  qemu-system-x86_64 \
					  -m 8G -smp 4 -cpu host -enable-kvm \
					  -serial mon:stdio \
					  -drive if=virtio,file=${IMAGE2} \
					  -device vhost-vsock-pci,netns=on,guest-cid=15

  host# socat - VSOCK-CONNECT:15:1234
  2025/03/10 17:09:40 socat[255741] E connect(5, AF=40 cid:15 port:1234, 16): No such device

  host# echo foobar1 | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
  host# echo foobar2 | sudo ip netns exec ns2 socat - VSOCK-CONNECT:15:1234

  vm1# socat - VSOCK-LISTEN:1234
  foobar1
  vm2# socat - VSOCK-LISTEN:1234
  foobar2

Test: Global vsocks accessible to any namespace

  host# qemu-system-x86_64 \
	  -m 8G -smp 4 -cpu host -enable-kvm \
	  -serial mon:stdio \
	  -drive if=virtio,file=${IMAGE2} \
	  -device vhost-vsock-pci,guest-cid=15,netns=off

  host# echo foobar | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234

  vm# socat - VSOCK-LISTEN:1234
  foobar

Test: Connecting to global vsock makes CID unavailble to namespace

  host# qemu-system-x86_64 \
	  -m 8G -smp 4 -cpu host -enable-kvm \
	  -serial mon:stdio \
	  -drive if=virtio,file=${IMAGE2} \
	  -device vhost-vsock-pci,guest-cid=15,netns=off

  vm# socat - VSOCK-LISTEN:1234

  host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
  host# ip netns exec ns1 \
				  qemu-system-x86_64 \
					  -m 8G -smp 4 -cpu host -enable-kvm \
					  -serial mon:stdio \
					  -drive if=virtio,file=${IMAGE1} \
					  -device vhost-vsock-pci,netns=on,guest-cid=15

  qemu-system-x86_64: -device vhost-vsock-pci,netns=on,guest-cid=15: vhost-vsock: unable to set guest cid: Address already in use

Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
---
Changes in v2:
- only support vhost-vsock namespaces
- all g2h namespaces retain old behavior, only common API changes
  impacted by vhost-vsock changes
- add /dev/vhost-vsock-netns for "opt-in"
- leave /dev/vhost-vsock to old behavior
- removed netns module param
- Link to v1: https://lore.kernel.org/r/20200116172428.311437-1-sgarzare@redhat.com

Changes in v1:
- added 'netns' module param to vsock.ko to enable the
  network namespace support (disabled by default)
- added 'vsock_net_eq()' to check the "net" assigned to a socket
  only when 'netns' support is enabled
- Link to RFC: https://patchwork.ozlabs.org/cover/1202235/

---
Stefano Garzarella (3):
      vsock: add network namespace support
      vsock/virtio_transport_common: handle netns of received packets
      vhost/vsock: use netns of process that opens the vhost-vsock-netns device

 drivers/vhost/vsock.c                   | 96 +++++++++++++++++++++++++++------
 include/linux/miscdevice.h              |  1 +
 include/linux/virtio_vsock.h            |  2 +
 include/net/af_vsock.h                  | 10 ++--
 net/vmw_vsock/af_vsock.c                | 85 +++++++++++++++++++++++------
 net/vmw_vsock/hyperv_transport.c        |  2 +-
 net/vmw_vsock/virtio_transport.c        |  5 +-
 net/vmw_vsock/virtio_transport_common.c | 14 ++++-
 net/vmw_vsock/vmci_transport.c          |  4 +-
 net/vmw_vsock/vsock_loopback.c          |  4 +-
 10 files changed, 180 insertions(+), 43 deletions(-)
---
base-commit: 0ea09cbf8350b70ad44d67a1dcb379008a356034
change-id: 20250312-vsock-netns-45da9424f726

Best regards,
-- 
Bobby Eshleman <bobbyeshleman@gmail.com>


