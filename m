Return-Path: <kvm+bounces-64476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C16CC841F1
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 930163A1FDE
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07597287511;
	Tue, 25 Nov 2025 09:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5L2Msyl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5BC18A93F
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764061315; cv=none; b=FpwgaMQMXjueV9+EQPfE1DKQlmKjlDugGkOnmFRZZJb+pzuq4trBKpcpmFdGBqc+oHobfkdviR8wKv/0KeRL6tKLP2BDNIjX9QoQiQlZOQ6uXQjeHIVGqwIhjFtjQCXHpI7CklortOCXo0PIPfK8o9+2JNXZJUuO2v+rmE6tfa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764061315; c=relaxed/simple;
	bh=ifvlK1RA27Q/ZvBeyjlL3l6Va/e0AUWEJtNbozytgos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LtOFJd1KX1vjpucKB+nbzzgJUxPyY2V/2YtBj3yMZNzATZIU/3BNjQZFAwo8TDxBvhtXOKhYEMdvGcxLqVaA7Z32UTkzbOxt4ARQsuI43znMTa9tbTLFOJXhCgb4B2FGlgQk5bdSlAFAkJpOpGytJeyvYDp2RUrT0zSqN8LYYZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5L2Msyl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764061312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gP8zW91eMMdParUS51W1dDdLU/a1x//SHEkUd9rpKx8=;
	b=K5L2MsylUuomeo61AyRvw1/i7zBiM0Amb4e7xtmFFEbCezXNf6YpMPrHW/lSRIeABFw8XZ
	mxxi2yrMbTdBmHCYb8MnwCvQJzQIPIhvBmXwGvltFeqWIBf2CAWB9xrLYy8wvQcJM9Mozc
	v5QSADS2AMIj3xxIW70465Fc4k8pHrA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-SHih0t5eOj2vw_T57L6asg-1; Tue,
 25 Nov 2025 04:01:50 -0500
X-MC-Unique: SHih0t5eOj2vw_T57L6asg-1
X-Mimecast-MFC-AGG-ID: SHih0t5eOj2vw_T57L6asg_1764061309
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 897AA1954B0B;
	Tue, 25 Nov 2025 09:01:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4875F1800451;
	Tue, 25 Nov 2025 09:01:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A78DE21E6A27; Tue, 25 Nov 2025 10:01:46 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	eesposit@redhat.com
Subject: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
Date: Tue, 25 Nov 2025 10:01:46 +0100
Message-ID: <20251125090146.2370735-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Retrieve the @errno set by ioctl() before we call accel_ioctl_end()
instead of afterwards, so it works whether accel_ioctl_end() preserves
@errno or not.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 accel/kvm/kvm-all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f9254ae654..28006d73c5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3373,10 +3373,10 @@ int kvm_vm_ioctl(KVMState *s, unsigned long type, ...)
     trace_kvm_vm_ioctl(type, arg);
     accel_ioctl_begin();
     ret = ioctl(s->vmfd, type, arg);
-    accel_ioctl_end();
     if (ret == -1) {
         ret = -errno;
     }
+    accel_ioctl_end();
     return ret;
 }
 
@@ -3413,10 +3413,10 @@ int kvm_device_ioctl(int fd, unsigned long type, ...)
     trace_kvm_device_ioctl(fd, type, arg);
     accel_ioctl_begin();
     ret = ioctl(fd, type, arg);
-    accel_ioctl_end();
     if (ret == -1) {
         ret = -errno;
     }
+    accel_ioctl_end();
     return ret;
 }
 
-- 
2.49.0


