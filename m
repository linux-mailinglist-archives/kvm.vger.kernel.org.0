Return-Path: <kvm+bounces-71768-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iH4ZJjdynml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71768-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:53:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F141915ED
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86FE3310E146
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529F129AAFA;
	Wed, 25 Feb 2026 03:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DeIXeUZa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jUFjfRRf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0452641FC
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991514; cv=none; b=ZF4AfxI0NOQSpvQ61viJdVLOOvRl0SeNef+7yFuiX/3zXOqMKMfT84txoWdJDDDiu0MEBLMzCcpo6MeLe6gwuuAEA2R9V/PpkjRhTynEQNcy1bZwxGCR5/67ZwFG7vpwjm5S2NI1rnyGUXJiqCFF+uQ8IVtAT7H0VphQWh1fyIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991514; c=relaxed/simple;
	bh=JxATHAEirCV2Xi9bhU3Rtjp8u0tgIjSxay95AflnYZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm56Ed/odj6c9SHHv92G6ulkxDN72zZv9E334kkS7FVPPmLxZUYeXjKNefFQ0Y1X/jRCDRPEulNFiT8xrE5oBsv+r3Bk4xk2Qq++0SioV5yHEVj6aAVM0ZtJOyp6qtjbYkxg+oD2QA6/zhvoCZN++JZBmS1OOA3a+2oqU7K8zxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DeIXeUZa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jUFjfRRf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWSmk7aS39eozNMeUrD49ba8qpOrFdvcFtxo/v8o3SM=;
	b=DeIXeUZa+i6OTzls1BNn3vLetmqJQZniHzDEp01ST+zIuaSqGuRh5HRabO4E/ZrbKdHqiB
	sLjV8w+bA/6hZp+z74kZTWMhYlgkhqsoFCGai5Hqlm7h8sEzMTESMrwwLzBqeQy2Eu6ZEr
	NYfBG8qWnZStnljApSC2PKF2Ev5RcWg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-xgA7jYHDMIGmUwt6cpN0tw-1; Tue, 24 Feb 2026 22:51:50 -0500
X-MC-Unique: xgA7jYHDMIGmUwt6cpN0tw-1
X-Mimecast-MFC-AGG-ID: xgA7jYHDMIGmUwt6cpN0tw_1771991510
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35641c14663so6638373a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991510; x=1772596310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWSmk7aS39eozNMeUrD49ba8qpOrFdvcFtxo/v8o3SM=;
        b=jUFjfRRfi+zavxXapeVOWpjpoP6kSq1VFrjC/Bhr+jNJlfIpXdIuFZjuQzLM+ujCmR
         tx8XEH04hYOLSt5ywYS8y8pw6pkiMErHxiChm05ZWrzJx9lX/d/TZ7JBX5Btmhf/Hx5c
         8AMqJf7W4U3gM7GNyzhWwmgf+wfkGPN6y7G2xz9RlVxPBY6Kakywu0Ri1XNe4Ay8wiZ5
         yTD67xTkPpNPBG9YLfbMaoXi8fW39RJks6lrN0n+B5pcFeaGohXFy3cDVmABFHL0hfL2
         f/opPJxFd2nWGgYtnoZZGdnrrQ1yTHDzMWiqk781/l/YeZqR5DlamdyhKPMRarNGfWlv
         +Kiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991510; x=1772596310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lWSmk7aS39eozNMeUrD49ba8qpOrFdvcFtxo/v8o3SM=;
        b=prsErczVbKt2gYtRJZEnLUqJgug/RyMWhmdxa+UBl5G9lpBzudoQyV6DL6tpCfsWJK
         X2mEoG+VA6+pBeEjp/3tyVobDQ3sNv6t2cL1g/+n+N1SoqCoejtUngN/SYo7zO8fRIBR
         d002hnOAkp1adK1jEtLzjgmfhMLP9wRvWDWD+ANOtphyV2jYTUWNw/B4U8MOD/aX+GYw
         NZHfchKsSJkRWQgYa1uiV4H52Wj5TD8bU4NLoaMB8IoxV0PAYMQY6hCIvJqvKXjAKHgz
         BC0fXakEp3TOcL6lvmmtIFxmsggEvs8E7Re8U/DA/pg/NLEi6F1bqO1zY11282sJbJDA
         bF4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBL2Tq/zXaaw8P6afw2SFYSeBMMJ0mJ4u7poQsm7f+HpEogur/P1LkCxLuU8ew0by5ZRc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxto6Ca3eyZVUNMuPrk+/bV97luaFjp6nOV9C711TQBhkaYPGbM
	asBINQZtMm25jTWbBlj+2GoPoVTWpkC1m73opFPSYboECaxqQNF2wKr1BzV5reeVoJEeq/qVIz5
	LJ5PUGz1hvBR8rHNbFRdEzWWc7R08l7zRWisq5GxAl3O+VQpOU/Jlgw==
X-Gm-Gg: ATEYQzx8WvFA+SZ3+G3RSHDNX6cGRFBvXI2ZUzvoEZhgqvRhajgRlxlvZNrqwi0na3I
	kyXOv2lEI+ivvPx2m/0LPD8e8eqbuV+Vp9I96nJ4R2ueMz+/lFFs+0pUodWubVWmtG0RnNdtmbo
	KnGaJkd7/7JsfnLoi75vG1fo7/2qQ6G4H2SEgozMzxcZo75wXe5k5RwPTkJelCZ7FiO79H5iclT
	s0zR6s3UEx9rbP+eCYMHnhcql55BWoT5BjHPyAtlIUplzNWfuJ4yKHU0UwgO0UqbzuC0ofGWHWU
	l8b85uZB2Ep/qGp+c0ZHqeAljZxQkiYfVdJP+4WEk+WqTSRmHc8cORmECKiNJFc7J/SQjNJufOB
	G0vozKIdLr60Og2QL5j0w3r4yOlBgA+jMa6GqkcSepBEoNkqapa5WUOg=
X-Received: by 2002:a17:90b:5624:b0:356:2eff:df05 with SMTP id 98e67ed59e1d1-358ae8a7d46mr13550207a91.16.1771991509817;
        Tue, 24 Feb 2026 19:51:49 -0800 (PST)
X-Received: by 2002:a17:90b:5624:b0:356:2eff:df05 with SMTP id 98e67ed59e1d1-358ae8a7d46mr13550190a91.16.1771991509471;
        Tue, 24 Feb 2026 19:51:49 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:49 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 30/35] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Wed, 25 Feb 2026 09:19:35 +0530
Message-ID: <20260225035000.385950-31-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71768-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 37F141915ED
X-Rspamd-Action: no action

When new vcpu file descriptors are created and bound to the new kvm file
descriptor as a part of the confidential guest reset mechanism, various
subsystems needs to know about it. This change adds notifiers so that various
subsystems can take appropriate actions when vcpu fds change by registering
their handlers to this notifier.
Subsequent changes will register specific handlers to this notifier.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 26 ++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c | 10 ++++++++++
 include/system/kvm.h   | 17 +++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a347a71a2e..a1f910e9df 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -127,6 +127,9 @@ static NotifierList kvm_irqchip_change_notifiers =
 static NotifierWithReturnList register_vmfd_changed_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
 
+static NotifierWithReturnList register_vcpufd_changed_notifiers =
+    NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vcpufd_changed_notifiers);
+
 static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
 static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
 static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
@@ -2314,6 +2317,22 @@ static int kvm_vmfd_change_notify(Error **errp)
                                             &vmfd_notifier, errp);
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
 int kvm_irqchip_get_virq(KVMState *s)
 {
     int next_virq;
@@ -2841,6 +2860,13 @@ static int kvm_reset_vmfd(MachineState *ms)
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
index a6e8a6e16c..c4617caac6 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -87,6 +87,16 @@ void kvm_vmfd_remove_change_notifier(NotifierWithReturn *n)
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
index fbe23608a1..4b0e1b4ab1 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -590,4 +590,21 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
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
 #endif
-- 
2.42.0


