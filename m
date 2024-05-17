Return-Path: <kvm+bounces-17611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B3B8C884A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 269E31C21BD3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294DE604DD;
	Fri, 17 May 2024 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mib+p2X8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA19379F5;
	Fri, 17 May 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957179; cv=none; b=IYiX5tm9jYBgn7CqqwLJysrvwojQvhpBZU5Wi7HK0UqzKq9XZNn33E1LhPxg908n0suIlPP5DG8UUg0RUS5itIa6RIEsCH/MbxiNgpuFJZB6ALgHhiTn2F0aq/4+xFVrCiLY9qcp/2WEala9f0ytJFf6DVlcmcQb82FgWOr9yl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957179; c=relaxed/simple;
	bh=dvlyMnDZEzGzhw+M5Rk7VgDP3ma0N8aNDBsghbfPKV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=JBKNBtqeivseq9q0ZTHg1lTOwKGKHjg74OIY02sWceZuZ3KgySrgQmz3QePBiBB4OXFZM25oeBGK5qDMzUWwTDhOa7b0kCwhmJ+SJn6OvuzjV1zkNpEjdykBdQ3lVuwGE9GIP0wLqSv83vxSoB8OqlTszLyPjJEr6Um3hzRUi4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mib+p2X8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f082d92864so11204045ad.1;
        Fri, 17 May 2024 07:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715957177; x=1716561977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FBz6A3nac4XOk7LaxYPX60HvEv8JbFpWi2kVXn7/eiI=;
        b=Mib+p2X8qsZMNzOnchtz8BHSLkpcXDJpgX7CuRcJtBpVb0K731rqsIvOkYxmw2gAuz
         WY3GzJeE9qzUvXfF61MsBL8/6atXwuLi1R9ynZrCYbbYBPv5/G8FhQ0rn1doBx8RNLKG
         mt+qaWgxbmZlXh6a7AO3z+a1565RAnuePxhffFDNY+Ks9RGLt5WwnZ6IuJzVtfK7g5jM
         qcco8DUs3u6MhKBPuXnw1lCatgXZtBrDTQSVDZ22Z4zfXc+Dbwyr6JG19S2eAD6WUNWk
         +Ph5u/cal9scqmVmOL+doNz8M5hJdHAC0tCzC7goxMPSVVLwbKlhDCrMJMlytDDSEy0A
         b4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957177; x=1716561977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FBz6A3nac4XOk7LaxYPX60HvEv8JbFpWi2kVXn7/eiI=;
        b=Y3yfYz2LX4QmpIF6ozP0YTIAeh5lY4/ToQc/2EPvdYuKrPp4AoE0fIFZOUR7TARyzk
         OPf0pbN5Gyk2ukyKRTJ63y50q7fe7BR+gBK0FJhOKc61iqehVDqLdf0uj0jMW54QIoSV
         BgJt+1lR/L8STeppUrW2q7lqxLqDA4PKaUOXGjC2U9Y+tUQkpurO1zCVuRWM9ryU+wHs
         27MKYmrIagYJ98/nxm5KhBJE79XGxClKqEd9dh1hm0/4zI6yuZFSTdh+WByVkx2oPKBQ
         Aa3pb6L6YqiJ7vexED4OjfNeRVdGl6kjX4V1OP/mlgSKkCSuXpbMebTWTINcQzgGk2l0
         3twg==
X-Forwarded-Encrypted: i=1; AJvYcCWYS/ogW42pbnVygQsUThqq2lnuw+WTjlB3jz1gYLV+LPthwlWSuYjly7NFdPJeWLvHGEtCWj5gw/EebMp+8VOwEv4S+FQd1DOPNX4GKd7jTci1hFSVnv7RYb/2EdB2r9zDSg8oUBE3sGA3Z5nPYSc0JEx584t0GNSj
X-Gm-Message-State: AOJu0YyER1bbRxDzmWm/W8bIVXt1Tgwh3wcio++dNLkdUuePvxIMRJHD
	zxOM/52FsioZimF5h88EQ4e7GUHiLZuJG2TZ52tcjBEPngY5Cuuv
X-Google-Smtp-Source: AGHT+IFoDOmAvGHTELPDHGM3rFd4a0Z1ijNML2xr3QJt794ZsCSH7hG9LvUTKQG3epczE85ZgIfo+Q==
X-Received: by 2002:a17:903:1107:b0:1e2:307f:d283 with SMTP id d9443c01a7336-1ef43c0f5e7mr246214275ad.1.1715957177085;
        Fri, 17 May 2024 07:46:17 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160a1esm158504985ad.279.2024.05.17.07.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:46:16 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: mst@redhat.com,
	davem@davemloft.net,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RFC PATCH 0/5] vsock/virtio: Add support for multi-devices
Date: Fri, 17 May 2024 22:46:02 +0800
Message-Id: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

# Motivition

Vsock is a lightweight and widely used data exchange mechanism between host
and guest. Kata Containers, a secure container runtime, leverages the
capability to exchange control data between the shim and the kata-agent.

The Linux kernel only supports one vsock device for virtio-vsock transport,
resulting in the following limitations:

* Poor performance isolation: All vsock connections share the same
virtqueue.
* Cannot enable more than one backend: Virtio-vsock, vhost-vsock, and
vhost-user-vsock cannot be enabled simultaneously on the transport.

We’d like to transfer networking data, such as TSI (Transparent Socket
Impersonation), over vsock via the vhost-user protocol to reduce overhead.
However, by default, the vsock device is occupied by the kata-agent.

# Usages

Principle: **Supporting virtio-vsock multi-devices while also being
compatible with existing ones.**

## Connection from Guest to Host

There are two valuable questions to take about:

1. How to be compatible with the existing usages?
2. How do we specify a virtio-vsock device?

### Question 1

Before we delve into question 1, I'd like to provide a piece of pseudocode
as an example of one of the existing use cases from the guest's
perspective.

Assuming there is one virtio-vsock device with CID 4. One of existing
usages to connect to host is shown as following.

```
fd = socket(AF_VSOCK);
connect(fd, 2, 1234);
n = write(fd, buffer);
```

The result is that a connection is established from the guest (4, ?) to the
host (2, 1234), where "?" denotes a random port.

In the context of multi-devices, there are more than two devices. If the
users don’t specify one CID explicitly, the kernel becomes confused about
which device to use. The new implementation should be compatible with the
old one.

We expanded the virtio-vsock specification to address this issue. The
specification now includes a new field called "order".

```
struct virtio_vsock_config {
  __le64 guest_cid;
  __le64 order;
} _attribute_((packed));
```

In the phase of virtio-vsock driver probing, the guest kernel reads from
VMM to get the order of each device. **We stipulate that the device with the
smallest order is regarded as the default device**(this mechanism functions
as a 'default gateway' in networking).

Assuming there are three virtio-vsock devices: device1 (CID=3), device2
(CID=4), and device3 (CID=5). The arrangement of the list is as follows
from the perspective of the guest kernel:

```
virtio_vsock_list =
virtio_vsock { cid: 4, order: 0 } -> virtio_vsock { cid: 3, order: 1 } -> virtio_vsock { cid: 5, order: 10 }
```

At this time, the guest kernel realizes that the device2 (CID=4) is the
default device. Execute the same code as before.

```
fd = socket(AF_VSOCK);
connect(fd, 2, 1234);
n = write(fd, buffer);
```

A connection will be established from the guest (4, ?) to the host (2, 1234).

### Question 2

Now, the user wants to specify a device instead of the default one. An
explicit binding operation is required to be performed.

Use the device (CID=3), where “-1” represents any port, the kernel will
search an available port automatically.

```
fd = socket(AF_VSOCK);
bind(fd, 3, -1);
connect(fd, 2, 1234);
n = write(fd, buffer);
```

Use the device (CID=4).

```
fd = socket(AF_VSOCK);
bind(fd, 4, -1);
connect(fd, 2, 1234);
n = write(fd, buffer);
```

## Connection from Host to Guest

Connection from host to guest is quite similar to the existing usages. The
device’s CID is specified by the bind operation.

Listen at the device (CID=3)’s port 10000.

```
fd = socket(AF_VSOCK);
bind(fd, 3, 10000);
listen(fd);
new_fd = accept(fd, &host_cid, &host_port);
n = write(fd, buffer);
```

Listen at the device (CID=4)’s port 10000.

```
fd = socket(AF_VSOCK);
bind(fd, 4, 10000);
listen(fd);
new_fd = accept(fd, &host_cid, &host_port);
n = write(fd, buffer);
```

# Use Cases

We've completed a POC with Kata Containers, Ztunnel, which is a
purpose-built per-node proxy for Istio ambient mesh, and TSI. Please refer
to the following link for more details.

Link: https://bit.ly/4bdPJbU

Xuewei Niu (5):
  vsock/virtio: Extend virtio-vsock spec with an "order" field
  vsock/virtio: Add support for multi-devices
  vsock/virtio: can_msgzerocopy adapts to multi-devices
  vsock: seqpacket_allow adapts to multi-devices
  vsock: Add an ioctl request to get all CIDs

 include/linux/virtio_vsock.h            |   2 +-
 include/net/af_vsock.h                  |  25 ++-
 include/uapi/linux/virtio_vsock.h       |   1 +
 include/uapi/linux/vm_sockets.h         |  14 ++
 net/vmw_vsock/af_vsock.c                | 116 +++++++++--
 net/vmw_vsock/virtio_transport.c        | 255 ++++++++++++++++++------
 net/vmw_vsock/virtio_transport_common.c |  16 +-
 net/vmw_vsock/vsock_loopback.c          |   4 +-
 8 files changed, 352 insertions(+), 81 deletions(-)

-- 
2.34.1


