Return-Path: <kvm+bounces-28768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E1D99CEF6
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 372E31F242EE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02351C5798;
	Mon, 14 Oct 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3OkWOmk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE451C3051
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917221; cv=none; b=Zh6QlmL9Sa8qsX2Wojqp9mSIOgndCbnR83ud8Npaj1iW2u2x/lxY2K0071bvTQJE3y0fBE2tRMxl6ngCmYi/fZfs1d8u0nk475rDpYzXE8qE04iZEM7oletMn9u1vj4zomG31m5EkgvRqNc0/DVHqDVmb36zdXklvf+toGmFVso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917221; c=relaxed/simple;
	bh=xo4mYAPPBob7V8aqw/TudOSIkweMqUBbW3QuvBb1KwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCEDIrk7MY1fZz4Dl2muiVe2D0bkabg+OUzSIL2qCbP2EFHldtDEccYempm9uxi4WFjjfoJ6xRlzL324cHW7ItU6jH4xj3o02aBcpHJ/hO5Xk4AwTSGjLrmHsAGoyCO5uZAUoRzVmnJYO87wrx5sgXPyLuy4J8NPh9mG/dTZp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3OkWOmk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728917219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Os76zwoG6jFijiPcIPH9iCyJSDWZb0dHletZ1AI4lw=;
	b=P3OkWOmk+8hYvGlubXH4aK0BEF0tu2EXYLSAfRktVfpeBsUlGipXSV7jUkw9GmzsVUJnui
	4i6R1+oeM4EL4R9Pm4BsIi/ya8jnSuDZyAXs2J9ovaBwXL60geb8tI4HM67U+xsNsgZ80J
	bhYRuK2eSOeZO7hmmwfkduXAC4QtVPA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-xXFMHelCOC6T9rvvopYX6w-1; Mon,
 14 Oct 2024 10:46:56 -0400
X-MC-Unique: xXFMHelCOC6T9rvvopYX6w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DEEF19560BC;
	Mon, 14 Oct 2024 14:46:54 +0000 (UTC)
Received: from t14s.cit.tum.de (unknown [10.22.32.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A52E41955E8F;
	Mon, 14 Oct 2024 14:46:47 +0000 (UTC)
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
Subject: [PATCH v2 3/7] Documentation: s390-diag.rst: document diag500(STORAGE LIMIT) subfunction
Date: Mon, 14 Oct 2024 16:46:15 +0200
Message-ID: <20241014144622.876731-4-david@redhat.com>
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

Let's document our new diag500 subfunction that can be implemented by
userspace.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 Documentation/virt/kvm/s390/s390-diag.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virt/kvm/s390/s390-diag.rst b/Documentation/virt/kvm/s390/s390-diag.rst
index d9b7c6cbc99e..c69c6e0fa71b 100644
--- a/Documentation/virt/kvm/s390/s390-diag.rst
+++ b/Documentation/virt/kvm/s390/s390-diag.rst
@@ -77,6 +77,23 @@ Subcode 3 - virtio-ccw notification
 
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


