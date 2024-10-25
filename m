Return-Path: <kvm+bounces-29714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322F19B055B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:16:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F2228469E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34324209F3D;
	Fri, 25 Oct 2024 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEsaMdXn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F01FB8A9
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865731; cv=none; b=I+ZluO2VtbcroolFUHFEszTDRszwzAPUt50UPDzKaH3jrOCvir+A7XdaRk0Lyultrj8q0LK+0er1xw5UxBqcUg9mFG7evtJz+ezeE7XRT7LUJo2jI36/mOf6RGTIg08wnntHUQl+/dRCihwjnJkqLNmHyJVSQbfYY67DKgjGU2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865731; c=relaxed/simple;
	bh=z6K13kZho/LfUENx7JBLb79HCm3qE9q6sRC1Evor1qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2hu1u8AdIANz4/WrR/wUekEafoS7M4AZJ17x7hyXjfX/QyLI4OyJ/kYFKZL7aScvY3cHTmyWeMYmomVPoRBb+FEblaw46/PL5Bu6MlOxKL5XQNgXzZe7GuK1yWYpXWO3OQ61+9HTnDYOSDDcHS150Rne9RbG+JAgba3IgPV4Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gEsaMdXn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729865728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZrDkTfigLaNGazXPM44aNCnZCzJMkV9GdJkwS2fHAmE=;
	b=gEsaMdXnLi8lveCQ6r2EnMx0GkFLlhxfnOgw7BprXHDmoCXhRmRPrSBGFUlDnjZXuRIL8Q
	iWqot5d92f648KgeYY8Edu4+mGbsHn2I/L1EGPnYs1k0EZlX1QFa/nG8lsZhWOXh1K4KpH
	2ymO55StYVyv6Nk+j6qEmXhXvzubWVA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-5G9aywhZMEOYyzT-kYfMXQ-1; Fri,
 25 Oct 2024 10:15:24 -0400
X-MC-Unique: 5G9aywhZMEOYyzT-kYfMXQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4594C1955E85;
	Fri, 25 Oct 2024 14:15:18 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25C4219560A2;
	Fri, 25 Oct 2024 14:15:10 +0000 (UTC)
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
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 2/7] Documentation: s390-diag.rst: document diag500(STORAGE LIMIT) subfunction
Date: Fri, 25 Oct 2024 16:14:47 +0200
Message-ID: <20241025141453.1210600-3-david@redhat.com>
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

Let's document our new diag500 subfunction that can be implemented by
userspace.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 Documentation/virt/kvm/s390/s390-diag.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virt/kvm/s390/s390-diag.rst b/Documentation/virt/kvm/s390/s390-diag.rst
index 48a326d41cc0..3e4f9e3bef81 100644
--- a/Documentation/virt/kvm/s390/s390-diag.rst
+++ b/Documentation/virt/kvm/s390/s390-diag.rst
@@ -80,6 +80,23 @@ Subcode 3 - virtio-ccw notification
 
     See also the virtio standard for a discussion of this hypercall.
 
+Subcode 4 - storage-limit
+    Handled by userspace.
+
+    After completion of the DIAGNOSE call, general register 2 will
+    contain the storage limit: the maximum physical address that might be
+    used for storage throughout the lifetime of the VM.
+
+    The storage limit does not indicate currently usable storage, it may
+    include holes, standby storage and areas reserved for other means, such
+    as memory hotplug or virtio-mem devices. Other interfaces for detecting
+    actually usable storage, such as SCLP, must be used in conjunction with
+    this subfunction.
+
+    Note that the storage limit can be larger, but never smaller than the
+    maximum storage address indicated by SCLP via the "maximum storage
+    increment" and the "increment size".
+
 
 DIAGNOSE function code 'X'501 - KVM breakpoint
 ----------------------------------------------
-- 
2.46.1


