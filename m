Return-Path: <kvm+bounces-14066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5589789E8F1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86D6D1C22530
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B7D10953;
	Wed, 10 Apr 2024 04:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmgcX4go"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C0628F0
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723722; cv=none; b=BhoihXQbTFxM/+bRaI7VG4+BgEu78T408/V8KogO35/zFOecEM1G8mCI18PSusc4uyf1DISwEUn+UKiraTpeKV4MRlkZ9UZM4l2hhS/iyPAFJ/G5Frc0q6ZUyYKKA6lzgd6wqZtvVGwgZBF9TmHfFkr8AIaEzQkbpEVUuXb9+/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723722; c=relaxed/simple;
	bh=GTPYWUExqaKJ1ffWv/5oel5WsLqZgzXUVtWMpIIX7Mw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E7OrpGr8hbgSSBy24fLc6Hc5bL4pd7yFnkxtZfl5EQkvdxfwvp+eGQGvBuIf0x+3b6lUhF56QQSQNrTZmG1wTI3lco0bWUJ8pa8Mh5TBn6sK71HdA5YI/q0BT+o3uxS074V+9e210bj8EER09FggTX5yoA/AjaOi2JFDIXIGczk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmgcX4go; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712723720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lUyt2lP+iaweP7GGIQcQN2/vMQc1UDRPtDmxt5CULrM=;
	b=gmgcX4go+d49x3tB4QofJmWMMN0vbV4390Etxaz6hcE19r7gxGgJcvdaMlsHASPSEXGRmq
	Fhb3t2/75cGPEorX3x9YpmAEiO0q9LFL1EgFRMMUfbkKxAGIxrNz5u5HeYUM8KArlc97qV
	kG376r4T0mDLQPe0arBzd0A7wMVG90s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-xXVMCXk2OW2YAcuTvXrPhQ-1; Wed,
 10 Apr 2024 00:35:16 -0400
X-MC-Unique: xXVMCXk2OW2YAcuTvXrPhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C1F21C0C644;
	Wed, 10 Apr 2024 04:35:16 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.217])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC93C47B;
	Wed, 10 Apr 2024 04:35:12 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] virtio-pci: Fix the crash that the vector was used after released
Date: Wed, 10 Apr 2024 12:33:14 +0800
Message-ID: <20240410043450.416752-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

During the booting process of the Vyatta image, the behavior of the
called function in qemu is as follows:

1. vhost_net_stop() was triggered by guest image . This will call the function
virtio_pci_set_guest_notifiers() with assgin= false, and
virtio_pci_set_guest_notifiers(） will release the irqfd for vector 0

2. virtio_reset() was called -->set configure vector to VIRTIO_NO_VECTOR

3.vhost_net_start() was called (at this time, the configure vector is
still VIRTIO_NO_VECTOR) and call virtio_pci_set_guest_notifiers() with
assgin= true, so the irqfd for vector 0 is still not "init" during this process

4. The system continues to boot,set the vector back to 0, and msix_fire_vector_notifier() was triggered
 unmask the vector 0 and then met the crash
[msix_fire_vector_notifier] 112 called vector 0 is_masked 1
[msix_fire_vector_notifier] 112 called vector 0 is_masked 0

To fix this, we need to call the function "kvm_virtio_pci_vector_use_one()"
when the vector changes back from VIRTIO_NO_VECTOR.

The reason that we don't need to call kvm_virtio_pci_vector_release_one while the vector changes to
VIRTIO_NO_VECTOR is this function will called in vhost_net_stop(),
So this step will not lost during this process.

Change from V1
1.add the check for if using irqfd
2.remove the check for bool recovery, irqfd's user is enough to check status

Cindy Lu (1):
  virtio-pci: Fix the crash that the vector was used after released.

 hw/virtio/virtio-pci.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

-- 
2.43.0


