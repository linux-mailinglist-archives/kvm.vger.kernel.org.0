Return-Path: <kvm+bounces-28765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B425C99CEE0
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29AA0B23DB9
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70EF1BDC3;
	Mon, 14 Oct 2024 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NVapV5l5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DBA1AE017
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917200; cv=none; b=hY4MkVTndndSAbPhNEdoVx+8JuV3L6sDFeVq7MCgq6LOe1rA9EvUECUAUNs0zTW0B5vVfR+gx6kv6U4B/VQ8niNK5m8HF4Wuun9M2BpurdLhTXU0Z/Pgj9FVqzcXhiXgWZMujvexl1pZVTsi8qNzslaInAVAekB4q0P34wqmt1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917200; c=relaxed/simple;
	bh=vyHcmYVND/8sAhmy2mkfCXOuTQ/V3gOInOxW1tqxOKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J+xwaxfKDSrx6Z5k5+CnfX49DKdkPcssyM1lYp2YEA2zeqJI+E7EXQdpdeyKHfBx2pPumD18VAxnseA5XS01Q+Jkk6/qdACfZ6CnS7lWwbBaCRh+pedgZ6+6PjX4YDZ6ZyIkGIlaH49hjatc6qkecUqpwbHHqGV/OcVaiWeoxu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NVapV5l5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728917197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CNpmOCUST08vkHQoeG1NSNtCSmJNv1NINO7OIcBeA0Y=;
	b=NVapV5l5fPwEtDZJ+OTbuJ14j7Kphn7XJ6L+veIc7kyZm8Rovr7i90V3FARdLcCGN3I6bc
	M2X3wrN2fhPk66PXaQ5FFfm/NUsQNXF1/wZWMSHpOWLxf6BWtziKZQKvT4IgdbvBJoKadb
	LgA0bAzO/H1nM6ZMqXkV3mLUv8F7W4Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-NRRBshLPP-2vKK199e8dRA-1; Mon,
 14 Oct 2024 10:46:33 -0400
X-MC-Unique: NRRBshLPP-2vKK199e8dRA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 806081955F40;
	Mon, 14 Oct 2024 14:46:31 +0000 (UTC)
Received: from t14s.cit.tum.de (unknown [10.22.32.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E97671955E93;
	Mon, 14 Oct 2024 14:46:23 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 0/7] virtio-mem: s390 support
Date: Mon, 14 Oct 2024 16:46:12 +0200
Message-ID: <20241014144622.876731-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Let's finally add s390 support for virtio-mem; my last RFC was sent
4 years ago, and a lot changed in the meantime.

The latest QEMU series is available at [1], which contains some more
details and a usage example on s390 (last patch).

There is not too much in here: The biggest part is querying a new diag(500)
STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".

The last two patches are not strictly required but certainly nice-to-have.

Note that -- in contrast to standby memory -- virtio-mem memory must be
configured to be automatically onlined as soon as hotplugged. The easiest
approach is using the "memhp_default_state=" kernel parameter or by using
proper udev rules. More details can be found at [2].

I have reviving+upstreaming a systemd service to handle configuring
that on my todo list, but for some reason I keep getting distracted ...

I tested various things, including:
 * Various memory hotplug/hotunplug combinations
 * Device hotplug/hotunplug
 * /proc/iomem output
 * reboot
 * kexec
 * kdump: make sure we don't hotplug memory

One remaining work item is kdump support for virtio-mem memory. This will
be sent out separately once initial support landed.

[1] https://lkml.kernel.org/r/20241008105455.2302628-1-david@redhat.com
[2] https://virtio-mem.gitlab.io/user-guide/user-guide-linux.html

v1 -> v2:
* Document the new diag500 subfunction
* Use "s390" instead of "s390x" consistently

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>

David Hildenbrand (7):
  s390/kdump: implement is_kdump_kernel()
  Documentation: s390-diag.rst: make diag500 a generic KVM hypercall
  Documentation: s390-diag.rst: document diag500(STORAGE LIMIT)
    subfunction
  s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM
    memory devices
  virtio-mem: s390 support
  lib/Kconfig.debug: default STRICT_DEVMEM to "y" on s390
  s390/sparsemem: reduce section size to 128 MiB

 Documentation/virt/kvm/s390/s390-diag.rst | 32 ++++++++++++----
 arch/s390/boot/physmem_info.c             | 46 +++++++++++++++++++++--
 arch/s390/include/asm/kexec.h             |  4 ++
 arch/s390/include/asm/physmem_info.h      |  3 ++
 arch/s390/include/asm/sparsemem.h         |  2 +-
 arch/s390/kernel/crash_dump.c             |  6 +++
 drivers/virtio/Kconfig                    | 12 +++---
 lib/Kconfig.debug                         |  2 +-
 8 files changed, 89 insertions(+), 18 deletions(-)


base-commit: 6485cf5ea253d40d507cd71253c9568c5470cd27
-- 
2.46.1


