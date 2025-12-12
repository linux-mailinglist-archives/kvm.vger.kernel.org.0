Return-Path: <kvm+bounces-65833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C76CB90D6
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5C19306168C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0AE3161BB;
	Fri, 12 Dec 2025 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMzIVdfO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6oyWxVe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEA627979A
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551903; cv=none; b=QPEHM8prrf4pMw/Jf5p6PJcucgeSFgn8WTto+XZa3runHatmqOp8FYVAPOPJTHz3Akmgv07Z0UI+8C2EJQLAiIJrYdQ0peRRq+owIsWGFb4gqb7XnWB77LZ+H15BcMTXT6cVGSb1Oh7CDbx22eVnLNsY7Pzf9GCmlwFLLRf7IRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551903; c=relaxed/simple;
	bh=7QemQt7wjJV0dSbEsse4d4QITDUBmX87JoCE/9hTzRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjRsy0qTwGz4bCVmYflzrAX9DEfope++C7drvX0WDPwR+3t8Wg3IbIMkU/4dCPwGfpiXQgQEjLcbFv8ypHy28fRg67o84aVrq8OGqi7ziPV83iI4iKo2LV7RY4A+21Ee9ZhfJgbipFganbhq9dYsOX9DnosLusD6awMff6Dxu9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YMzIVdfO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6oyWxVe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rgjX+7Zs4GjKiVepp+8rEO8AQv67kp7/f2WN1WL8v60=;
	b=YMzIVdfOjAnAz5OvnWXXmUoteCaVTw0S9RuFAgKkchsrLyfA1eKKS3MJyYzEi3L7MSjc/I
	r/IAtZ0mb/S5ZkppDkb+LL0vu4CpeVWLc12M3MgPs/mjw6C4Diu2db16O1loUe8VgFoKDH
	COu4XaD37NdcYAjNg9gPsMxF/hfR6lc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-gdYVuS-BNJeCQzxexpQRWQ-1; Fri, 12 Dec 2025 10:04:59 -0500
X-MC-Unique: gdYVuS-BNJeCQzxexpQRWQ-1
X-Mimecast-MFC-AGG-ID: gdYVuS-BNJeCQzxexpQRWQ_1765551899
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2958c80fcabso27083655ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551898; x=1766156698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgjX+7Zs4GjKiVepp+8rEO8AQv67kp7/f2WN1WL8v60=;
        b=H6oyWxVeSQI67GEFxjNkyFugXpDcaNzhQi3SkgzWam3TU10mM9TG5jq1f7AhCuMtXm
         9SM4n8ZeRyLDU1Bzg2dAFxol+GpDSUsSGkBGW5PU10h6bscZXODVWk70YVB3bogTj/7Q
         KsZsW+wrx+MuWrfbOmOPcas4tjDhAqJWAlTa+od2ZtHGn0u3QgBFmOyre7i6vQvsIyJE
         MVkKjv71XOUOQ1KYwfO9mWrtrdpNLncWrKA2gBzD3yudK4UmtXnICIP9zBwC7tq4Ke3N
         TJYaI0dNiACfzf7K/RyFLIdyYd3N23njlcHz/u2pmGJHn1VP01Ju4dYebbxTB95UHZn/
         3eDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551898; x=1766156698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rgjX+7Zs4GjKiVepp+8rEO8AQv67kp7/f2WN1WL8v60=;
        b=Oe8ELSNov/GAt6n+n/oIeflSr89S6ZEah2pAR+qomzIS1JwAZq5GakSEIPJKefZHy1
         D+znZhxdqApO79QR8V7wHNFFosmI7OohiWVapVP0SFLQfF9Ev75KX8aNz91eeqS3BmTB
         FFocCOT+T52qcyG2JJUf0gc33gKK878wMANOPo8EeuaWTeCVKPHLlCJgCnkHmL7JOIIy
         jASkmju36YRz8MnNny88mAh/iqcnwUl/4KmoGQsjDQFu5qRO5eeirZ1gUv0NO61rRi45
         lypLS6I3+kM3TitJ9N9EBEgKMjIcZnTf89EOyjqEa61FsDBgCEJ8N+TrAlHc2bOPGu10
         2GTw==
X-Forwarded-Encrypted: i=1; AJvYcCX7b2qpEnoDnaJWcS8ZXWNlLwOI0B8Dhcehw2rZmpKdc39T2+JdwoUGM5PP9ooSOFUF4l0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMoypYXZ5qimuxCyr/V8RMqX7yuHJusze3Ew2xQWlCSpPocBc2
	+iOooNJhfJ7GvDUvOtUp8IX2OtvSuObZ6VJ/eWN9SHWFQ6mgcA/2CBmLri20qyfvTXTbFNgY3MC
	582ErEj3COCTupkLexBkdkQWVV9n++yNaXQLFvWCqMNCXaqisQCwUfNh22aVrZQ==
X-Gm-Gg: AY/fxX61BX+QA74BwEsw9KGPUyx9U/kVinPsrGYSn5Y5xqmPYREQpnXnm3iD/K/4QZp
	XaaSsH3QyOzHdnQk5Emani51DmrfD98oZMO4jH51L7YBYGq3X6G/8VFjAK0iA6Kpt7aPZroGH9k
	u5EM/anEW6/Viib9HcvkruV87nXG2qIWpTQG/rKtO1/7qgEzeDonqHkmTeKF3A05l8IKF00mJIJ
	Eqp19684RBkM5JXp1ynEveJ4QLIdhuGnF6AG8k10vIAttwc4p8CS7npiMNrIW7dwYBOPbJmEH0m
	yk9rqkgAsODJYix+pGzl97dVtot6CgoCsKWzo6XWB2d+J+X0w2ktfq7mvJT4R9RVu0UXOEKv7fE
	0Y0oGadZCGm9r5J+h/DvAfhBwNcJ3eO9cr/fTtUffi+k=
X-Received: by 2002:a17:903:38d0:b0:295:9db1:ff32 with SMTP id d9443c01a7336-29f23cc4083mr22674645ad.48.1765551897961;
        Fri, 12 Dec 2025 07:04:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzZSIzSedS7i5fW89+07VJqVZhC3NyNAYZLpbH9Gha7pzyQN6PN9hZP33q+bh0g/hvLJN8Uw==
X-Received: by 2002:a17:903:38d0:b0:295:9db1:ff32 with SMTP id d9443c01a7336-29f23cc4083mr22674195ad.48.1765551897348;
        Fri, 12 Dec 2025 07:04:57 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:57 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 10/28] accel/kvm: Add notifier to inform that the KVM VM file fd is about to be changed
Date: Fri, 12 Dec 2025 20:33:38 +0530
Message-ID: <20251212150359.548787-11-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various subsystems might need to take some steps before the KVM file descriptor
for a virtual machine is changed. So a new notifier is added to inform them that
kvm VM file descriptor is about to change.

Subsequent patches will add callback implementations for specific components
that need this notification.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 25 +++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  8 ++++++++
 include/system/kvm.h   | 15 +++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 679cf04375..5b854c9866 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -127,6 +127,9 @@ static NotifierList kvm_irqchip_change_notifiers =
 static NotifierWithReturnList register_vmfd_changed_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
 
+static NotifierWithReturnList register_vmfd_pre_change_notifiers =
+    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_pre_change_notifiers);
+
 struct KVMResampleFd {
     int gsi;
     EventNotifier *resample_event;
@@ -2193,6 +2196,22 @@ static int kvm_vmfd_change_notify(Error **errp)
                                             &vmfd_notifier, errp);
 }
 
+void kvm_vmfd_add_pre_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_list_add(&register_vmfd_pre_change_notifiers, n);
+}
+
+void kvm_vmfd_remove_pre_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_remove(n);
+}
+
+static int kvm_vmfd_pre_change_notify(Error **errp)
+{
+    return notifier_with_return_list_notify(&register_vmfd_pre_change_notifiers,
+                                            NULL, errp);
+}
+
 int kvm_irqchip_get_virq(KVMState *s)
 {
     int next_virq;
@@ -2644,6 +2663,12 @@ static int kvm_reset_vmfd(MachineState *ms)
     memory_listener_unregister(&kml->listener);
     memory_listener_unregister(&kvm_io_listener);
 
+    ret = kvm_vmfd_pre_change_notify(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     if (s->vmfd >= 0) {
         close(s->vmfd);
     }
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index a6e8a6e16c..7f4e3c4050 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -79,6 +79,14 @@ void kvm_irqchip_change_notify(void)
 {
 }
 
+void kvm_vmfd_add_pre_change_notifier(NotifierWithReturn *n)
+{
+}
+
+void kvm_vmfd_remove_pre_change_notifier(NotifierWithReturn *n)
+{
+}
+
 void kvm_vmfd_add_change_notifier(NotifierWithReturn *n)
 {
 }
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 6844ebd56d..cb5db9ff67 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -586,4 +586,19 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
  */
 void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n);
 
+/**
+ * kvm_vmfd_add_pre_change_notifier - register a notifier to get notified when
+ * kvm vm file descriptor is about to be changed as a part of the confidential
+ * guest "reset" process.
+ * @n: notifier with return value.
+ */
+void kvm_vmfd_add_pre_change_notifier(NotifierWithReturn *n);
+
+/**
+ * kvm_vmfd_remove_pre_change_notifier - de-register a notifier previously
+ * registered with kvm_vmfd_add_pre_change_notifier.
+ * @n: the notifier that was previously registered.
+ */
+void kvm_vmfd_remove_pre_change_notifier(NotifierWithReturn *n);
+
 #endif
-- 
2.42.0


