Return-Path: <kvm+bounces-65844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1B2CB9121
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:12:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D713306A047
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C953631A7F8;
	Fri, 12 Dec 2025 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQaITVNO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h0lxk3dA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D618318157
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551957; cv=none; b=ROufdkDXQ+1xDjyoUNCQtUbGZP/Awc4viF3ANDSNUMF8BQyNxSLc1ByPGk9317I7kjDkm6nSCAoi0R/Rq9HjphzR/qN5cVBx5XH6mZQSyimEFeON7lFZDEdqeFonuVGEhytgzOjyyMBK0MnqKRDxZhDprchV0OaPTXmj+7/AE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551957; c=relaxed/simple;
	bh=HaS9haONEXTMb/WZ6lX6YGsSMUTXc/P0Bre75KEcMjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoKvjAgATXKc7mHkvf8hgb5dU68fxNGgswAWH1PAYFQ+10LU1qJGVu5mOSjh+nitI7KpZxJ00sRh7+XmDss2RD54DgvPb9tWneWzkBVpaZhgXMvzzzailmN/bHZgUD7Nr7Zo6Sto2k8hXrQc3A2vkb4QXoXB1g0UdVTWMHkDtqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQaITVNO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h0lxk3dA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MC5lbXLd3guV2ptWnUpo8dxa+q+3ySAOJ4x29/7bkmQ=;
	b=DQaITVNOVDFkzplBNJSli2rbMReYetYXiml6f+3/FGdd5qM+XqcJT7op5vmF3UBwGKgJEu
	bb+0ZMnPWcNicr8TDWVbVfrOmnwK9Yp8jU5o6jjASCKKsRfY3CkZJ75AR8G+mRUYhRIeFj
	DF+VmStFMdP2fgND9f3uK5dW1HE3Ij8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-tg6xRI8jN_e0GvWu1rQvpg-1; Fri, 12 Dec 2025 10:05:53 -0500
X-MC-Unique: tg6xRI8jN_e0GvWu1rQvpg-1
X-Mimecast-MFC-AGG-ID: tg6xRI8jN_e0GvWu1rQvpg_1765551951
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297e1cf9aedso23826785ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551951; x=1766156751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MC5lbXLd3guV2ptWnUpo8dxa+q+3ySAOJ4x29/7bkmQ=;
        b=h0lxk3dAN70tf/FuaSqu5yzVwuPiVkxqbE1CRSIbMl80A4PgjoUYvzMSBA112poHMB
         n5BYu0eF2lLelGOLtXn3m6fg6yvukg3V/W7+VlRbmZixQCRMhWWiSF1zIs2zy/i8hjgh
         ouSP/L+adVo+aRQJSvKnVAU5tA2r182LNzUazrqr/uHSfqoYst85YbHmkxYtvRQVhh7m
         7ANZ46AjiA/IuH9vN47jQfaJsqie+Zpv21WPslGCNHY3CUCSxxTjZQ7NXhkX+Soq69Mr
         V5lMw+hNlLRCw2x381Xz0RIbJLvV789xhbXJrSUpo/xlNFgkOp0s3h3a+SUyBs4fgJCO
         bP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551951; x=1766156751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MC5lbXLd3guV2ptWnUpo8dxa+q+3ySAOJ4x29/7bkmQ=;
        b=Z2RFldi5/qP5eDHfsSbZ8QpHEf8kRPco08Si23zngOmwMwaXClKAKoKs9VVpHE6rRO
         efMaPTX5RoPNdm1Rsr0S5RuJGSVYnFUD5kqJz4FJzEMK936E7v73PzJvFkbiKD71NQkl
         063JKEAGY2Y3v+lXmtAyFE0wRGjtbTvI1oB2DMvXtEpE0MsWTvBhtBtsP/Sy8/7GTHNM
         /GDvfqZiph4aIaqaUVcDTwMAr2v6HgtWY3mB/ZoTjsfAi9a6qDAEV1m44lyc4nreb6Hi
         uMVIFSGtoliyi1CJUSTEnOyverbvHQw+lIEQgl9KO1l5Lpgst0KJyZ2Is/+EyZyxMImI
         A5pA==
X-Forwarded-Encrypted: i=1; AJvYcCUB9HXBcPBKtOxjEZRLBxyke+kdJIoyoEJdimXel8yT/0Z4kMT/zRDpe4EsWK01v6VTG7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN+lnpn4gZPTg7xEDHFI3RteidUKrVMHDpjWry/Sb4aJSHql/N
	lY7V/yrcl8QpWiMOxjjkoql1cApuiSQQc99hY9D8hm37O+BRhU2/HqD5pFBOt/KxHqYjag48Zau
	AAZcECRpHoUtOsHn3p47yiQ0bVrhG+Y0JzZNQqxfvJ0S/nVWY7RkBOw==
X-Gm-Gg: AY/fxX5cLeOLjY+GytPxC4zu9ryuyhBebIuIpbCJMi6lCD0y2BZlJqaIHlMtLfa6kVv
	dpn4ojFpPpAXaUL1ki3ytp+yqBZJxogPltwyOp74q66RmKVyl3tPX3vxj74pMzz+uf/d5yuwOo5
	qMcxojhHSkhga8ueoBQd7kc5J0ee9rddRCQwcKySXJPIq2d5r4aoX6saNNLkkImDfbmgfMn35db
	+ZzeX0QPhSsAyTISWfI4LdEPcBi8/PQL4C0CxRk/Cas9uG1o6qR3pGJUT+5aSNbpgSg3JpxuHx7
	GIF7W96Anz8zsIr7DBRc3764imbFrzY5LlE4sOFbzf7B2+7Vrl+zQucwhHheZrVqL5w1v5dtSuN
	OBWyWJuasmrNo7NXQ1uPq50ACCmD4151++zWGKxFoxt4=
X-Received: by 2002:a17:903:2ecc:b0:295:592e:7633 with SMTP id d9443c01a7336-29f26eb34ddmr23525645ad.29.1765551950902;
        Fri, 12 Dec 2025 07:05:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFINyFysyaG3Z7M7nKx2uV1+TcX6mLN4/JurQM2jroBzGQCP/c1s4YHv6IamP+nxOelN0SRRw==
X-Received: by 2002:a17:903:2ecc:b0:295:592e:7633 with SMTP id d9443c01a7336-29f26eb34ddmr23525245ad.29.1765551950285;
        Fri, 12 Dec 2025 07:05:50 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:50 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 26/28] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Fri, 12 Dec 2025 20:33:54 +0530
Message-ID: <20251212150359.548787-27-anisinha@redhat.com>
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

When new vcpu file descriptors are created and bound to the new kvm file
descriptor as a part of the confidential guest reset mechanism, various
subsystems needs to know about it. This change adds notifiers so that various
subsystems can take appropriate actions when vcpu fds change by registering
their handlers to this notifier.
Subsequent changes will register specific handlers to this notifier.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 27 ++++++++++++++++++++++++++-
 accel/stubs/kvm-stub.c | 10 ++++++++++
 include/system/kvm.h   | 17 +++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 638f193626..7f9c0d454a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -130,8 +130,10 @@ static NotifierWithReturnList register_vmfd_changed_notifiers =
 static NotifierWithReturnList register_vmfd_pre_change_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_pre_change_notifiers);
 
-static int kvm_rebind_vcpus(Error **errp);
+static NotifierWithReturnList register_vcpufd_changed_notifiers =
+    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vcpufd_changed_notifiers);
 
+static int kvm_rebind_vcpus(Error **errp);
 static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
 static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
 static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
@@ -2327,6 +2329,22 @@ void kvm_vmfd_remove_pre_change_notifier(NotifierWithReturn *n)
     notifier_with_return_remove(n);
 }
 
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_list_add(&register_vcpufd_changed_notifiers, n);
+}
+
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n)
+{
+    notifier_with_return_remove(n);
+}
+
+static int kvm_vcpufd_change_notify(Error **errp)
+{
+    return notifier_with_return_list_notify(&register_vcpufd_changed_notifiers,
+                                            &vmfd_notifier, errp);
+}
+
 static int kvm_vmfd_pre_change_notify(Error **errp)
 {
     return notifier_with_return_list_notify(&register_vmfd_pre_change_notifiers,
@@ -2847,6 +2865,13 @@ static int kvm_reset_vmfd(MachineState *ms)
     }
     assert(!err);
 
+    /* notify everyone that vcpu fd has changed. */
+    ret = kvm_vcpufd_change_notify(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     /* these can be only called after ram_block_rebind() */
     memory_listener_register(&kml->listener, &address_space_memory);
     memory_listener_register(&kvm_io_listener, &address_space_io);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 7f4e3c4050..5b94f3dc3c 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -95,6 +95,16 @@ void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n)
 {
 }
 
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n)
+{
+    return;
+}
+
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n)
+{
+    return;
+}
+
 int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq)
 {
diff --git a/include/system/kvm.h b/include/system/kvm.h
index cb5db9ff67..bfd09e70a0 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -586,6 +586,23 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
  */
 void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n);
 
+/**
+ * kvm_vcpufd_add_change_notifier - register a notifier to get notified when
+ * a KVM vcpu file descriptors changes as a part of the confidential guest
+ * "reset" process. Various subsystems should use this mechanism to take
+ * actions such as re-issuing vcpu ioctls as a part of setting up vcpu
+ * features.
+ * @n: notifier with return value.
+ */
+void kvm_vcpufd_add_change_notifier(NotifierWithReturn *n);
+
+/**
+ * kvm_vcpufd_remove_change_notifier - de-register a notifer previously
+ * registered with kvm_vcpufd_add_change_notifier call.
+ * @n: notifier that was previously registered.
+ */
+void kvm_vcpufd_remove_change_notifier(NotifierWithReturn *n);
+
 /**
  * kvm_vmfd_add_pre_change_notifier - register a notifier to get notified when
  * kvm vm file descriptor is about to be changed as a part of the confidential
-- 
2.42.0


