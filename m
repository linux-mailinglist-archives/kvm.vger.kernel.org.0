Return-Path: <kvm+bounces-28771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C36B99CF09
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFF91B24B6E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0151AC8AE;
	Mon, 14 Oct 2024 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/fnZ6UH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CD41AC459
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917239; cv=none; b=hmrRLzZP7TDNaVeZGtWcB96bvdXBUpRLvViNzkTEb3D/XGjS8yWMqkm6TnY7WoqjbGn5AUsRY4Fk5/gMwgpZQUkKJykF4fD1PoAi36H/5RfssjC9qRANGNoDgrcDGnm7c1W6M1+cQ6j7sEhoxTIQ7g0WTyOTTNQOrXNcrZXmOD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917239; c=relaxed/simple;
	bh=S3/s3ZMKK541/JU2M9KfPl/Q+Jt53Z4H9d+ajg0VjME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZsvDT0HK2bIa8ZrP+DrCXcQC7QtzOaoQxI9ASXr2n5S7+jVCAyaMsYXO5NpH4s4WF5n5SdT/1TSNDywc8tuyMySiGr+36ECVGc3nIMKcJEDE9NY34jxrsBHxbgL/sDedjH+NfLYQ3Jki30HG0gQbGsvKZcnMm47kC0QaBoF4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/fnZ6UH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728917235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNutO1hsgpqcUEbfHgtLFq1UOgF2cMswuycNM8rERoo=;
	b=H/fnZ6UHwACmvgJw2lIbfxKBLtPvCj4PEiFuWKhetno7u5RNNyD0vFPtcMcF+DhApSC9rr
	SUDOyEm0+4eKsYD+oV65gJA0QKZNmH/9n7MP3kiBwO2W/s6uAx3WTYwZPQJpcWPXlHuAk6
	IUnK+ePlN4uUCFDLkQ841gaSw/xsWGA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-aFyz8o1aOxaBv2Y6jRkjlg-1; Mon,
 14 Oct 2024 10:47:12 -0400
X-MC-Unique: aFyz8o1aOxaBv2Y6jRkjlg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E358A195608B;
	Mon, 14 Oct 2024 14:47:09 +0000 (UTC)
Received: from t14s.cit.tum.de (unknown [10.22.32.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B54F31955E93;
	Mon, 14 Oct 2024 14:47:02 +0000 (UTC)
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
	Jonathan Corbet <corbet@lwn.net>,
	Mario Casquero <mcasquer@redhat.com>
Subject: [PATCH v2 5/7] virtio-mem: s390 support
Date: Mon, 14 Oct 2024 16:46:17 +0200
Message-ID: <20241014144622.876731-6-david@redhat.com>
In-Reply-To: <20241014144622.876731-1-david@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
index 42a48ac763ee..fb320eea70fe 100644
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
+	 This driver currently supports x86-64, arm64, riscv and s390x.
+	 Although it should compile on other architectures that implement
+	 memory hot(un)plug, architecture-specific and/or common
+	 code changes may be required for virtio-mem, kdump and kexec to
+	 work as expected.
 
 	 If unsure, say M.
 
-- 
2.46.1


