Return-Path: <kvm+bounces-67735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5250BD12C3C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35802301559C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B187C3590AA;
	Mon, 12 Jan 2026 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUHa1LyZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sHWKbbT0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EABF3596EE
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224228; cv=none; b=ChAliczLQInSA2ODmPq/BelIowtxP7ykrqw5geQXM4Y6dtpkf1ce5yU6ceVUvYm716lx5wX5jjxIuWlS48ZeT3SEinRXo+Uj2UViagUbZ8mSBPGxmDUjl+UYUoxS0yICNeM/+IsrEph/bkXnqsIghHvHd9hvpIrlDCiyQNzExfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224228; c=relaxed/simple;
	bh=3Cr4kquqMpaW+dkZPAeX0z8r5Oyo7zFyniOviQUwLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZYtnp9gIDG7G4snHZoWXeJPAJevABQbgkaRBr26MzTwYa/Af5kmCyyFmtJWUbChCEntRldshvxaGguBUbZV+tEAUspAlr+kLHRWhTdiQriO7vfl+WpUtMzsUZZnG9T0Jsc7PZI9/KbE7n5UflZBnhyETqH9/dRiUqfHEqv8t/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUHa1LyZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sHWKbbT0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lPuM56addYmauPE+CYUQ8UQqZP2E6PELtzBhAc/1xHg=;
	b=XUHa1LyZM/QCDf6UqTGUTAKbsMgaKNFLPAiVFm+riFEwvCO2eKcNTGRK/dYChPHyoCrtL1
	KXlXF0I6f/b3bkcss4IuRQ1DoW3Fa7PK/LgvauzAgVi4ubH5BZKFoci3l4/jBw8HS1kc1G
	gmWwafZLNvYp0Ew65VZPVFLJUVkdZRs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-LTAXwMY9PHWYkOEIjpwsKQ-1; Mon, 12 Jan 2026 08:23:44 -0500
X-MC-Unique: LTAXwMY9PHWYkOEIjpwsKQ-1
X-Mimecast-MFC-AGG-ID: LTAXwMY9PHWYkOEIjpwsKQ_1768224223
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c55434c3b09so1602495a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224223; x=1768829023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPuM56addYmauPE+CYUQ8UQqZP2E6PELtzBhAc/1xHg=;
        b=sHWKbbT0jLLW2mpnARWDnOC/VniY4ofnuQUk0+vk20Z9hs9Esh/TqcXfjUMYt7LOoF
         EvutOHXfnOmH7aZIpFBxV+fOpm+yXHxeI3q34/FeKLXTaMPdqPg+4JEVP+p9IaBLQw23
         fgiKUlFBW9YSt1PtukkBWlSTOAujMQdRDmE0wew9Pue29mgLKZAwxC2cpigI/r3kQuk+
         zKJVqPDJIHqVqz9HQTInktLdUJOCoYe8vwl67n2onrsh2pkskNQJt03PimEEYm2jzJep
         yislUbwgppGaffy6jdZdveCjrA40E3QYZV3xAa2kojQIuSgd6jTp1EKXwl4S+SuOzFVJ
         /4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224223; x=1768829023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lPuM56addYmauPE+CYUQ8UQqZP2E6PELtzBhAc/1xHg=;
        b=Fbma4tvPd689qC/8EGmI2lcL3y7Bf9cUBubQBfp3ZLino23ckld/niyTRJuObAxzvO
         nZy4xiy3ciNUWB8+Ko//ghyeXidfueUYSaSwtVbelV18gzWdHA7C7q6thKKbWXLESNRN
         Crc+E5UZFsckZwufVA9LO9iZh+/gefddduDBNChKVUZpVoMttmSUFAdqauO490vojPeU
         JmspcSyd5UQMDpz+heCubtG5DJy2Q0ZtiRyusKGketl2UjmWIw0JvAYXtb7m7u/FJYJH
         XfdZVJKbq/khvrDPb+gjjPN0wh7sc7iY/6VYfYxpJ64ph7f3uEpo3y97I41U+fP6bWp4
         SylQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGmh3roqDeNnrh7Nl5WBNgh28rfXZ4kzOLbPHuRdtbWwbNSbdCCtVRno8mj9D1bH/AmwU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0+SEjvgrg+U2bUpewLfJggTCtLWdGUuNz1IZCUXmF64WAuXzD
	0UiGaDKHhWmjJth4PJRe7WIoNvkBsjhAXvmj57b7MYNLpCS4VO+2OrcPa4HIXGfjcwFpbP6uxtc
	FEaoGYXv5lsKjVGgfS4oj8bMdXic++OwY+tUVrj+3loccYEaQG3UZag==
X-Gm-Gg: AY/fxX54m2LF1KPWl3qZfFpMk3LOfFh4u9jIPb+uFO0VJAqCo3cSSa1+2UWPWuBxmp6
	cVlpGNY6czYAw0BW2Wxbbf8DuIf4aNpicB7WvyiI1ootRM7Vo9buIgcYtpPSdIyacmJ/723TmMg
	Au2++R5sAl9QebdceA2iIbECVFFo9wW1LEtVvtKlW/cIc95FVLwjSi1djZpuYjwzT7SFqat3GUl
	r3e6zed57gVUmjTwGuWWGtH1qWnigcnfHJPUrUshJ3ySSntwxQOethcxCJ2sNd1e81MdI+qe6O/
	f4/uGigWqiWOL8DSAdm1sCru3cVJ8yybERW5WMCC1vUj+mOfWK6t2Qc9z/akzz4nAGjwdJq0YaT
	tnmNZW5jBJSAFLRd7mRQrOM0dTdreb6e4v5ByCWEUg10=
X-Received: by 2002:a05:6a20:3d90:b0:35d:8c8:8acb with SMTP id adf61e73a8af0-3898f91d382mr16602110637.26.1768224223413;
        Mon, 12 Jan 2026 05:23:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGK1u9WC9nhoiyAr5vmMG3ufIQ8YPfuY4suBxhryhWv2uGiiK25n3oA/yPi5HyI2ZGlkvNYng==
X-Received: by 2002:a05:6a20:3d90:b0:35d:8c8:8acb with SMTP id adf61e73a8af0-3898f91d382mr16602097637.26.1768224223029;
        Mon, 12 Jan 2026 05:23:43 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:42 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 06/32] accel/kvm: add a notifier to indicate KVM VM file descriptor has changed
Date: Mon, 12 Jan 2026 18:52:19 +0530
Message-ID: <20260112132259.76855-7-anisinha@redhat.com>
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

A notifier callback can be used by various subsystems to perform actions when
KVM file descriptor for a virtual machine changes as a part of confidential
guest reset process. This change adds this notifier mechanism. Subsequent
patches will add specific implementations for various notifier callbacks
corresponding to various subsystems that need to take action when KVM VM file
descriptor changed.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 30 ++++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  8 ++++++++
 include/system/kvm.h   | 21 +++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index df49a24466..ef8e855af5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -90,6 +90,7 @@ struct KVMParkedVcpu {
 };
 
 KVMState *kvm_state;
+VmfdChangeNotifier vmfd_notifier;
 bool kvm_kernel_irqchip;
 bool kvm_split_irqchip;
 bool kvm_async_interrupts_allowed;
@@ -123,6 +124,9 @@ static const KVMCapabilityInfo kvm_required_capabilites[] = {
 static NotifierList kvm_irqchip_change_notifiers =
     NOTIFIER_LIST_INITIALIZER(kvm_irqchip_change_notifiers);
 
+static NotifierWithReturnList register_vmfd_changed_notifiers =
+    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
+
 struct KVMResampleFd {
     int gsi;
     EventNotifier *resample_event;
@@ -2173,6 +2177,22 @@ void kvm_irqchip_change_notify(void)
     notifier_list_notify(&kvm_irqchip_change_notifiers, NULL);
 }
 
+void kvm_vmfd_add_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_list_add(&register_vmfd_changed_notifiers, n);
+}
+
+void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_remove(n);
+}
+
+static int kvm_vmfd_change_notify(Error **errp)
+{
+    return notifier_with_return_list_notify(&register_vmfd_changed_notifiers,
+                                            &vmfd_notifier, errp);
+}
+
 int kvm_irqchip_get_virq(KVMState *s)
 {
     int next_virq;
@@ -2671,6 +2691,16 @@ static int kvm_reset_vmfd(MachineState *ms)
         do_kvm_irqchip_create(s);
     }
 
+    /*
+     * notify everyone that vmfd has changed.
+     */
+    vmfd_notifier.vmfd = s->vmfd;
+    ret = kvm_vmfd_change_notify(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     /* these can be only called after ram_block_rebind() */
     memory_listener_register(&kml->listener, &address_space_memory);
     memory_listener_register(&kvm_io_listener, &address_space_io);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 68cd33ba97..a6e8a6e16c 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -79,6 +79,14 @@ void kvm_irqchip_change_notify(void)
 {
 }
 
+void kvm_vmfd_add_change_notifier(NotifierWithReturn *n)
+{
+}
+
+void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n)
+{
+}
+
 int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq)
 {
diff --git a/include/system/kvm.h b/include/system/kvm.h
index a5ab22421d..7df162b1f7 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -181,6 +181,7 @@ DECLARE_INSTANCE_CHECKER(KVMState, KVM_STATE,
 
 extern KVMState *kvm_state;
 typedef struct Notifier Notifier;
+typedef struct NotifierWithReturn NotifierWithReturn;
 
 typedef struct KVMRouteChange {
      KVMState *s;
@@ -566,4 +567,24 @@ int kvm_set_memory_attributes_shared(hwaddr start, uint64_t size);
 
 int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 
+/* argument to vmfd change notifier */
+typedef struct VmfdChangeNotifier {
+    int vmfd;
+} VmfdChangeNotifier;
+
+/**
+ * kvm_vmfd_add_change_notifier - register a notifier to get notified when
+ * a KVM vm file descriptor changes as a part of the confidential guest "reset"
+ * process. Various subsystems should use this mechanism to take actions such
+ * as creating new fds against this new vm file descriptor.
+ * @n: notifier with return value.
+ */
+void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
+/**
+ * kvm_vmfd_remove_change_notifier - de-register a notifer previously
+ * registered with kvm_vmfd_add_change_notifier call.
+ * @n: notifier that was previously registered.
+ */
+void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n);
+
 #endif
-- 
2.42.0


