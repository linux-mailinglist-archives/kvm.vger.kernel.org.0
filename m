Return-Path: <kvm+bounces-29716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B6F9B056A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97E871C227A3
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3F620D4E8;
	Fri, 25 Oct 2024 14:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShSOXgkM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC231FB89B
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865743; cv=none; b=QlSIVOVxrSEAE/0pzrN4CmIU34n8vErwvcJzlejeMxm0ZHz0Pn9YfjaTA31AAcyFC5AQIwjHwSeW23E8RRQ4YZbWo9I4qClVjh2UHekOMZOZjRJNI9fmvz7Gxg/OLkJZkMfuQ//gASf+KhXVPWtKn4yGAvGDgcwpXjRIinwgVlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865743; c=relaxed/simple;
	bh=3uLVz3eUeg9+T9hioMnqyLkEPRdi1XI/Om9ZxLUqWz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN/ijPBKf8aKSjh7oxshHOx6GP2ePBGxxqfoaBKZyBle3xEMg36qEjsYfhlRXY6N4Q5gBWRsbCBCwHpsojXqaQmXw8oDYZiBf+XiroWHf05KaewRmtjfDNH1VupHyz7LYLkvYouppUcVeYKbiMZ8Gh/sq1cRgIRJP/V7mJBX6hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShSOXgkM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729865740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+nIERtDVeS/EhO1Z1RMDJ6bPWg7jhlY/grynlrcupM=;
	b=ShSOXgkMjpQpehs+oxSbOCyw/0qd10e1Qs0u/n3mxDP2cBTt4FRIRp/PgV+ivYI86Xzuh+
	c4Cns7SEkVgazFj9J3j6BGHdCr/nPf6YmDnuhukgUkjMGHs4QM1lx2Ud1eVj+cqkK4NmU6
	pjJyt1xl+Jnu53wk4z4B2MD7i1saA1I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-F9VDsh4JNJadqAm0djARcA-1; Fri,
 25 Oct 2024 10:15:37 -0400
X-MC-Unique: F9VDsh4JNJadqAm0djARcA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA7941955EAA;
	Fri, 25 Oct 2024 14:15:34 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6E921955F39;
	Fri, 25 Oct 2024 14:15:26 +0000 (UTC)
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
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mario Casquero <mcasquer@redhat.com>
Subject: [PATCH v3 4/7] virtio-mem: s390 support
Date: Fri, 25 Oct 2024 16:14:49 +0200
Message-ID: <20241025141453.1210600-5-david@redhat.com>
In-Reply-To: <20241025141453.1210600-1-david@redhat.com>
References: <20241025141453.1210600-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Now that s390 code is prepared for memory devices that reside above the
maximum storage increment exposed through SCLP, everything is in place
to unlock virtio-mem support.

As virtio-mem in Linux currently supports logically onlining/offlining
memory in pageblock granularity, we have an effective hot(un)plug
granularity of 1 MiB on s390.

As virito-mem adds/removes individual Linux memory blocks (256MB), we
will currently never use gigantic pages in the identity mapping.

It is worth noting that neither storage keys nor storage attributes (e.g.,
data / nodat) are touched when onlining memory blocks, which is good
because we are not supposed to touch these parts for unplugged device
blocks that are logically offline in Linux.

We will currently never initialize storage keys for virtio-mem
memory -- IOW, storage_key_init_range() is never called. It could be added
in the future when plugging device blocks. But as that function
essentially does nothing without modifying the code (changing
PAGE_DEFAULT_ACC), that's just fine for now.

kexec should work as intended and just like on other architectures that
support virtio-mem: we will never place kexec binaries on virtio-mem
memory, and never indicate virtio-mem memory to the 2nd kernel. The
device driver in the 2nd kernel can simply reset the device --
turning all memory unplugged, to then start plugging memory and adding
them to Linux, without causing trouble because the memory is already
used elsewhere.

The special s390 kdump mode, whereby the 2nd kernel creates the ELF
core header, won't currently dump virtio-mem memory. The virtio-mem
driver has a special kdump mode, from where we can detect memory ranges
to dump. Based on this, support for dumping virtio-mem memory can be
added in the future fairly easily.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Mario Casquero <mcasquer@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 42a48ac763ee..2eb747311bfd 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -122,7 +122,7 @@ config VIRTIO_BALLOON
 
 config VIRTIO_MEM
 	tristate "Virtio mem driver"
-	depends on X86_64 || ARM64 || RISCV
+	depends on X86_64 || ARM64 || RISCV || S390
 	depends on VIRTIO
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
@@ -132,11 +132,11 @@ config VIRTIO_MEM
 	 This driver provides access to virtio-mem paravirtualized memory
 	 devices, allowing to hotplug and hotunplug memory.
 
-	 This driver currently only supports x86-64 and arm64. Although it
-	 should compile on other architectures that implement memory
-	 hot(un)plug, architecture-specific and/or common
-	 code changes may be required for virtio-mem, kdump and kexec to work as
-	 expected.
+	 This driver currently supports x86-64, arm64, riscv and s390.
+	 Although it should compile on other architectures that implement
+	 memory hot(un)plug, architecture-specific and/or common
+	 code changes may be required for virtio-mem, kdump and kexec to
+	 work as expected.
 
 	 If unsure, say M.
 
-- 
2.46.1


