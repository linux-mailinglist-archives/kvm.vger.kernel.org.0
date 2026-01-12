Return-Path: <kvm+bounces-67736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BBABED12BFD
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 34AF03012A43
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207C93590C0;
	Mon, 12 Jan 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XB7BZgzo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9Ntespt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FF357717
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224232; cv=none; b=toS6L5J7CXK7hHeLqdzl58W7/o9wY4yT+Ef+mMwjbQX2tlEYo77Mb5AQyTqUY1Ef3X1JEsEc94kPTfxCxCxcT8bN1GyqnYrxQh1l/yUty6428DUbSGfbyPfmMjKPdN3cU1M9HAOPI6mkQmbB5KZ4K63FphxA7LBxqcZh2FpprSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224232; c=relaxed/simple;
	bh=KdGKXKftvVkub+yTCB0kCSD/UQai1Y9bEOp2JNpJFIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW4C/I5OmEHR8Qc3rHL9chA+WUHS2Wx/5Hyjm8s2cn/1qrC1c/ip6y1QHOf/J0uYyVxS0/sTxMrvouD6GCJ8xdpmEc4Aw1FZZpV6CkShoUbh77x93QhaIpDHGhPWSQ9AcUW6sS+6QnvcpTQiN7RbU5VvLGeGJdmxcYtVW7tF5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XB7BZgzo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9Ntespt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mXnd/EV42IZ35HCUh2hymkokKll/IVZCRGZsgYgJG/k=;
	b=XB7BZgzo6vxLQIqr/Yb7XiPLrgA6x08Onb+mLonUz3fsbSxltudBuSVvcwsKvnWzfOJov3
	uN2C+bpUu/vz8k3xfR62Ls+U4cTFXsIYmqfP9F/J6kaT5X+UBErnAcZ6PTYnrc8nz8rSwS
	M9b5HAdxS++gDpi9TL8qgrL+YixwmGc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-TR9Pk1mBPhStrXomF0Z1Lw-1; Mon, 12 Jan 2026 08:23:46 -0500
X-MC-Unique: TR9Pk1mBPhStrXomF0Z1Lw-1
X-Mimecast-MFC-AGG-ID: TR9Pk1mBPhStrXomF0Z1Lw_1768224226
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c5291b89733so2621975a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224226; x=1768829026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXnd/EV42IZ35HCUh2hymkokKll/IVZCRGZsgYgJG/k=;
        b=g9NtesptANnMqsfKVmQTBYTn0eHNWX0lwAHVu4uX3Afbm1qnZPRw7Aa/lfPtAQyOWZ
         bA/NIS1YAYfUV+SqReJCu5qv4X4HyX0ksP9dSkp6qF/UxHKZFSWYArvLE37ZWpLhiNKW
         HqIP7LqASlDkniu53el8Eqf1fbKGfn39bwvp/7EClZZB8ABU2u2ZnhPxIpCZeR7g06TD
         QIJXCr+QjxzDhp8rD3ntHOVCK/KSLpOODzwT6L9lFF3MqhizItqT020sIADQC1yn6wp3
         sEZYtKe7+FnKQJN6h2Ye7REW+B4NQZYyv5MZxOYFLem4zF/FW+zhLrrF/EJ1GZSWmzcd
         HLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224226; x=1768829026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mXnd/EV42IZ35HCUh2hymkokKll/IVZCRGZsgYgJG/k=;
        b=rVSDau9VEOvS0UQON1Cy3zkfGrrDOh/UL1QotZLFwTcvFTAHB52BSEOZA5LdMOLz8G
         6P5VtpPS0bi2f2s0gIQbjyB2DgreO9h2v7hurNqe+bZ9Fh9WjQF3NO3gSfpLm8/DqzLX
         ROx5kjW9RkbAZ5qY09ELkjZxcN9+0ZuoXU8kJgwyRbeEDyGSuIDzxtxQ3WeU2js+wtGL
         JibivBdZtmDqg9LWRkb3s7svjqzt12gLaQlMyMBnoEcUb+mcv66fiv4nIQ71ln7e//Uc
         8jvvQhpAPBTTEoOjTK7E2NjuyolJT1DfH+XVpdF2QOFhJVZV78bc57dpa/ALhS1YtUR8
         Bvrg==
X-Forwarded-Encrypted: i=1; AJvYcCWq2rJlCHBILsxHRr5Mr/m/yaKPqyDUJulmQ3B5nrjC+5eVdKTduOFoGdR7/rEA3eYvsUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLwaGd2M8J29v4G23/9lHYeDx4vlpZcgwrB4LrV9hX2Hpk8nhJ
	GzzV/PPWT+a6dUqGbdEskGRaHGgQBlYy+nLEmuVJBCIuWCokM7GosEpt2VysvIdi3LoaWNOYNlW
	xjBck/De2WbYbmE9yPdobn98nBVCcWy4Gr/iK3vizUNmkJSxfEWAy1A==
X-Gm-Gg: AY/fxX73g3QfOOXg/zdPa6zfvSfvYmljVvkuEXAppXxOFJ6t055vM/H52VOZItfmFNm
	PkByn6AmrNWCYUBKBXhKmiZ0/YjYepRMsGoB5TA5AFkuZkBFdeReDXayIUj5l55MrnudBIeGH9Y
	U2Md5EflbYB/kdez7U9cjZ7GoT31vXlTbntap+PRd2zme84omry2JG3UXA6jIPMhdFRPIf16e1e
	NS8gTO4Pc6UxIqajbTTWq7r/57JOWWrzLlSDNZN9zykDC1/P9QZl+ErW2kJ2ncsV4FvjRifHHhm
	lH0YeXpwqfTaaUMxcw0jtuyUDDhMgDw12jaJgNggSNfYIGRHMaEHReJqypS1NoRnkLCtPrQ/gdL
	zc/vN2b32DzF8Dj/AoYtvk10cUfGfCOLgZt+hpfwLi9E=
X-Received: by 2002:a05:6a20:a103:b0:342:d58b:561c with SMTP id adf61e73a8af0-3898f907cefmr14777672637.27.1768224225715;
        Mon, 12 Jan 2026 05:23:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFs6vdKuXiT9xGiDjo8b+a6b0Gvb8YUqfg9iXUDT1nezLkJVAiTWy1CvXHvEfiiPoDEtsOJ8w==
X-Received: by 2002:a05:6a20:a103:b0:342:d58b:561c with SMTP id adf61e73a8af0-3898f907cefmr14777651637.27.1768224225286;
        Mon, 12 Jan 2026 05:23:45 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:44 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 07/32] accel/kvm: add notifier to inform that the KVM VM file fd is about to be changed
Date: Mon, 12 Jan 2026 18:52:20 +0530
Message-ID: <20260112132259.76855-8-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
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
index ef8e855af5..367968427b 100644
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
@@ -2654,6 +2673,12 @@ static int kvm_reset_vmfd(MachineState *ms)
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
index 7df162b1f7..edc3fa5004 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -587,4 +587,19 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
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


