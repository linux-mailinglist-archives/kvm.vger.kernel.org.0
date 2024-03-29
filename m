Return-Path: <kvm+bounces-13070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B79891629
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C222B212BF
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 09:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4490144C92;
	Fri, 29 Mar 2024 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fAxyWxyC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB288134BC
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711705130; cv=none; b=TUhyqPpsO719SQYHW47w+r53UvakxXZQYOdFXKi3OPSUIGOjFzG55IedttE2Zurm1fdI0JwKxzfNZULjHGxJV5cfJNFPKNWl626jIQilgGawU+8TETVx5Q1wFnFYiiR5u3WKk9sNTxhRn+pw0LCyCnVz2zevM8trWkjwv+KBEiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711705130; c=relaxed/simple;
	bh=hlgRWAsqEYqPaeCmYoojJySYxpwBfhEhiWetVJsND38=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RgVNkkQo071n7oFL6uyLjGlZXwaHf4QN7L/KjjNBMH0LG9ZtkMIRru1vCO9py0sjtnSRzg7D4HmSSXJM1cC9cuqihIMGF3SShOtPRpHTnGYBsRLbHJZ0j2AqU4+dEzm2FlQtK4a0C1bf3rbSbbZFjsXsZ7CuRGjsLjI+/OB38fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fAxyWxyC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711705127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9TfOEZSUpizBDk/7ZlbtcyuX+Zuz/XZGsV/0/N9TVsY=;
	b=fAxyWxyCoCHiXru8U8/3tusovyDs2w9GJkOHecM5q5Uc75O/D5NV0mCRCBTbBPHGHjeF2N
	sdrKm4qZdpwb55v2RLGkSkVAsKAx1/nHgTKmBS5NlSv8I1xx++zVFs8PNEgodDTgFAsDyK
	f42PaV0AuXpl9eeeXMHLqM9Z/BKKxSI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-jz36XEyxNSOsNelDtdEUBA-1; Fri, 29 Mar 2024 05:38:45 -0400
X-MC-Unique: jz36XEyxNSOsNelDtdEUBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 718DD811E81;
	Fri, 29 Mar 2024 09:38:45 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.204])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6484D202451F;
	Fri, 29 Mar 2024 09:38:42 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v2] Documentation: Add reconnect process for VDUSE
Date: Fri, 29 Mar 2024 17:38:25 +0800
Message-ID: <20240329093832.140690-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Add a document explaining the reconnect process, including what the
Userspace App needs to do and how it works with the kernel.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 Documentation/userspace-api/vduse.rst | 41 +++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
index bdb880e01132..f903aed714d1 100644
--- a/Documentation/userspace-api/vduse.rst
+++ b/Documentation/userspace-api/vduse.rst
@@ -231,3 +231,44 @@ able to start the dataplane processing as follows:
    after the used ring is filled.
 
 For more details on the uAPI, please see include/uapi/linux/vduse.h.
+
+HOW VDUSE devices reconnectoin works
+------------------------------------
+1. What is reconnection?
+
+   When the userspace application loads, it should establish a connection
+   to the vduse kernel device. Sometimes,the userspace application exists,
+   and we want to support its restart and connect to the kernel device again
+
+2. How can I support reconnection in a userspace application?
+
+2.1 During initialization, the userspace application should first verify the
+    existence of the device "/dev/vduse/vduse_name".
+    If it doesn't exist, it means this is the first-time for connection. goto step 2.2
+    If it exists, it means this is a reconnection, and we should goto step 2.3
+
+2.2 Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
+    /dev/vduse/control.
+    When ioctl(VDUSE_CREATE_DEV) is called, kernel allocates memory for
+    the reconnect information. The total memory size is PAGE_SIZE*vq_mumber.
+
+2.3 Check if the information is suitable for reconnect
+    If this is reconnection :
+    Before attempting to reconnect, The userspace application needs to use the
+    ioctl(VDUSE_DEV_GET_CONFIG, VDUSE_DEV_GET_STATUS, VDUSE_DEV_GET_FEATURES...)
+    to get the information from kernel.
+    Please review the information and confirm if it is suitable to reconnect.
+
+2.4 Userspace application needs to mmap the memory to userspace
+    The userspace application requires mapping one page for every vq. These pages
+    should be used to save vq-related information during system running. Additionally,
+    the application must define its own structure to store information for reconnection.
+
+2.5 Completed the initialization and running the application.
+    While the application is running, it is important to store relevant information
+    about reconnections in mapped pages. When calling the ioctl VDUSE_VQ_GET_INFO to
+    get vq information, it's necessary to check whether it's a reconnection. If it is
+    a reconnection, the vq-related information must be get from the mapped pages.
+
+2.6 When the Userspace application exits, it is necessary to unmap all the
+    pages for reconnection
-- 
2.43.0


