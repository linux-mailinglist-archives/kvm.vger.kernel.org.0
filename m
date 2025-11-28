Return-Path: <kvm+bounces-64940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CB08CC92713
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 16:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3FFCF4E220D
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 15:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1EB23D2B4;
	Fri, 28 Nov 2025 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8zalfVr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9B79CD
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764343258; cv=none; b=Mn0tiH8QDQ1AIHy/8FLrJ/g8z6DiisB9LYtSyg0WFPPZY/P9rWpW8zSJJ5f9Yl+9LiWmCkcAkEkyhtosVeoTeQXDYxfIbovp7l0jRMxpuD39kM9w6vo1Twq9ZP+o5yFeh/LD29P4fbr4CYGahjl5bBydUR7477aBrDwrVN+Qk8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764343258; c=relaxed/simple;
	bh=mTMeZVfsOMZGhNMiy/9o2AxSpOb97U39jM5v2s1iGjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T/yWkD3yJY24ch+vFaH1O+AlFfifORlg89QMEFp/Y96ws+VflLcdyQ6lSfzniCpmBwF70vDH1pS8sjirClR1dXZBSJryA8S7Wy1oL22+kN0Yyl5aue+C6E1m0/pSmqs8Q8ZzqHPraY7hoPO/Ex2Y+kAskA3eSbUiZP1p4OF9XfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8zalfVr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764343256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3+nXCSQCD4CyRuWI2IklWjDkfAFE8zVF5dLRe+1dRUs=;
	b=Q8zalfVr359jnUiRpYP0qylCIFDL6p79vfHPk82qiXCL6cAvPCW5hEUDE5B1cQQHuMvPRT
	j18WlHW1aDXz1h4jBFvWyrzSFENXNTfYLqreA0AXmbFwspgqy8uN+IZl6S8Yo7poY0wkQ7
	H9V7aztV7ORXUwSw8xD4TQvrTvX3pDw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-RmNxGP5EOw2_rgU9h7lEvw-1; Fri,
 28 Nov 2025 10:20:54 -0500
X-MC-Unique: RmNxGP5EOw2_rgU9h7lEvw-1
X-Mimecast-MFC-AGG-ID: RmNxGP5EOw2_rgU9h7lEvw_1764343253
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03F2E1800447;
	Fri, 28 Nov 2025 15:20:53 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A74091956095;
	Fri, 28 Nov 2025 15:20:52 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1AA2D21E6A27; Fri, 28 Nov 2025 16:20:50 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	eesposit@redhat.com,
	philmd@linaro.org
Subject: [PATCH v2] kvm: Fix kvm_vm_ioctl() and kvm_device_ioctl() return value
Date: Fri, 28 Nov 2025 16:20:50 +0100
Message-ID: <20251128152050.3417834-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

These functions wrap ioctl().  When ioctl() fails, it sets @errno.
The wrappers then return that @errno negated.

Except they call accel_ioctl_end() between calling ioctl() and reading
@errno.  accel_ioctl_end() can clobber @errno, e.g. when a futex()
system call fails.  Seems unlikely, but it's a bug all the same.

Fix by retrieving @errno before calling accel_ioctl_end().

Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)
Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


