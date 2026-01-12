Return-Path: <kvm+bounces-67750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C61E4D12CD5
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 146F030967AF
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546363590D6;
	Mon, 12 Jan 2026 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U32ehVKP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="U/sewF9H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BFD3590AB
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224284; cv=none; b=O0AURLYBTwQRxen3zLioJocch1fzuRCMwHdD07XOeJz8/hDto47X/XAcPg5LKmpxtj65I6qCFyLt/guJVnudOCjT/4tqUh6SGvVsIXCD8JNhgxt/254uKoqo3Pg3pVeOon6IBAD8hlOa+/e7vS/o4zVNk3sOG0NN9GFI4V6JvY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224284; c=relaxed/simple;
	bh=NxPBuTx3g4yGDV+nWuMHXXrh4iS8vJixJcbJUENltD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWqsAscTXlu5uoz1iLyN0E3JcpwEjJiZ46weZVW8eRhr6FojQ6mOhWlyKWqG7Ip60u9j7zcFZziuJmgorKyqjVKIsQZxYcJWFopTncvkcdyYqQbXNC7HONpJqr4S+A+jvkDIsNzDkrYCboWA5pGNYPacDz6fJDfbLtAwKX6iwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U32ehVKP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=U/sewF9H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34fJR3EaRP0lXjDv/gJjVEbigtGQPR0fffJidhYwq0M=;
	b=U32ehVKPFm0jKIXevqM/x4IjONRfmClfECj/8kKJ+sV9B9k9O0eePrbTeYTdl3HeAHQVGT
	0MujjygIP4bjHdiqVmZkDXWck5n6Jte4g72SdjLEagM+/8nFZBEOGyxvpU4rqntDhf9wNF
	mp8AG1x0hez951HyYaAoCbULvQTn5wQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-e9WFndDxOkSOxOEsU3_2vA-1; Mon, 12 Jan 2026 08:24:40 -0500
X-MC-Unique: e9WFndDxOkSOxOEsU3_2vA-1
X-Mimecast-MFC-AGG-ID: e9WFndDxOkSOxOEsU3_2vA_1768224279
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b609c0f6522so11641367a12.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224279; x=1768829079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34fJR3EaRP0lXjDv/gJjVEbigtGQPR0fffJidhYwq0M=;
        b=U/sewF9HKBVB/pMmMZl7A/0UTjQNPFBEeIWPb7mMcAqKipGOurVya3Bete++uDVlEH
         JccFq2N3SLJwodnSE/eUqq15QKKvkZM84o/AB3tEds8L1IDvu7yu3XslAbwfM8asrl0U
         al0JtqLcgvbvntlBM3qZGKQCYtXv4wqe0IvoqNGMVDuZIiKsclVN8+kEjXJNZbU7xQrx
         Rjo+5HgYaTnAah7WPxuH58eDntEQzg8Mdu4mU5nStiuhct7iafHn+4nwvw1o61kxx7g/
         j44bS1HdKxjzwZoxUwKLLnPE+UV3GsgxBXd6nOwz3PV1YufC0jw4a+l/asmD/PIc5gVf
         ag5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224279; x=1768829079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34fJR3EaRP0lXjDv/gJjVEbigtGQPR0fffJidhYwq0M=;
        b=ijcJpEmFGGkiU9oJj1XiFKBLZFw7DtlPaHAU79iNlE+gV0U8ppm8z/MPaaXBAe5Mt/
         ULiKOu0udQHN5EaWnCfr2aV0zDxE3gg/jcyDZ9vwJ6jmey3BgWPSnwv3YiWqhciXG5bJ
         Ca1stobmkfLt6Pfs2VcuBKV6xLY1UKpCohi3x5RQbjMP88HUQ4wDRDgtE56K4yBPsr4B
         2w+Ziz0Zis8Gp4kaEVhpOyfu6cWcHc/GuWcv65qoqfmwMQBdmFjrRpJHKiBW9+kXPOS2
         QPF9eUR9sHEFnOH6IiW8NKmfxnruo+kscQCJhrHvYYBPVrGMwWCFw3inT1bBWZbXr5RX
         YGYA==
X-Forwarded-Encrypted: i=1; AJvYcCX5ZqYPZ28YAJGvNInJ4Y/24d2xJBKcJKRJtQFmpF3Ftt1w3MDrQdh4sdnAOTAdoV4rUVE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxahFf8O3AICk5HxkgLHHHKN7B2deo4tIiCWVfR1aZCtMUGbqw6
	Hm8bDdlrUUae+PVtVWTtt/y4AFJA4WtuN/Uu3XOaqGchdemxFpBJmUaMCzcSXt/94P+5/d5XyBk
	0ZHILUnnaBF3HI7Uvhw8JLoFkRriEKOyxeBGAagqrm9GbCHFjqP7/EyoBmmtzkA==
X-Gm-Gg: AY/fxX6dBmLagOLIj9g9fJiWnQ2d6b1uWpqJ3gE74x6XpU4EtDsbxYTlPlr1NM87rSK
	QnkiEowY2Yl1Szewu2X7xhmZCpIdfLV39bMbhQH+56tgw8PQ7ohWMoV/I5vy4Tp076uOmvh2RXY
	krVQis6brD5lWH6kQtpsHjAnblORxNyMxJfz1HZdVzj5RD6fsrmFYwetr5ea8KS+7p1o47LTHpV
	tH3bJpXClSoeaZn/cVFeOGM0zfZF7Tg9TXs/orc9AtHFKINBgIDz9l6t7nElDk85ETL2JCz6PUf
	eO+KIH378ytPQTeRDWArLkjrEAs3V5kl5dQcozNHzJ0U6VgFk0Oyeqi4GCnilnwsGAkSJDjrN8p
	XHltzxTxGqwsTOxxQbGjtNYEhUhIZVWalA8KO9Z5IdGM=
X-Received: by 2002:a05:6a20:7d9f:b0:350:7d78:18d9 with SMTP id adf61e73a8af0-3898f90887dmr15164013637.32.1768224279169;
        Mon, 12 Jan 2026 05:24:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIt8GOnuhdYsXeV1HU+lkzI4cU54UMzoMp+l9q2VHcfA0UCoD8L3XqEJJR5fHmm3onZd1kpA==
X-Received: by 2002:a05:6a20:7d9f:b0:350:7d78:18d9 with SMTP id adf61e73a8af0-3898f90887dmr15164000637.32.1768224278747;
        Mon, 12 Jan 2026 05:24:38 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:38 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 28/32] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Mon, 12 Jan 2026 18:52:41 +0530
Message-ID: <20260112132259.76855-29-anisinha@redhat.com>
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
index 2bd4dcd43b..efdfdf0ccb 100644
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
@@ -2328,6 +2330,22 @@ void kvm_vmfd_remove_pre_change_notifier(NotifierWithReturn *n)
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
@@ -2858,6 +2876,13 @@ static int kvm_reset_vmfd(MachineState *ms)
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
index edc3fa5004..120b77d039 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -587,6 +587,23 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
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


