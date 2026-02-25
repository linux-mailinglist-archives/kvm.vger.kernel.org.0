Return-Path: <kvm+bounces-71752-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sHxwHKJxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71752-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E487E1914DD
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6DBC530CC8A0
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B2F29AAFA;
	Wed, 25 Feb 2026 03:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SFwoOOMM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LhH9AWA4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC1B1DB34C
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991437; cv=none; b=VTi7jHQvqWZJ6uRcRpGXgHRSk71cp62r2uyDXVK+lcbPlysL3bzJA7sNvzimgFDzmmrtx5T/9FrmNIXHPGFefLTG1su74ruwu5Za7Xe0NOA55t8mAhtPgJ4Wr6w4firlZwzI2jeGw8U/bCtiGqMJQecSNFEtlSKgzYHvZ3xz5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991437; c=relaxed/simple;
	bh=XZVKrF0S/CosmhdtFFSaqzNrtOIc9VtHVb6KvXp3Q1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApOGHyl1GtZH55U5Ga04MVY8bhHlJa+KSsBncu1Z47NseN4iqoSRhWHKmTuwY+yFQ+nranbuwY33Jxzb0BP6ydP/QcRw1FWfckirNYe+FsvmSvpirkk0kpx+zId6reemSKk/H8coMjrWLK8dyPmaw2mdM/HeOre6OPyDyfFcz9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SFwoOOMM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LhH9AWA4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wunhJBbOcVRokAg1jAhfk7nGs+ox6MrG4ZKk3jSClw8=;
	b=SFwoOOMMQZEJflxDMd4ia0Q2WZoYdoeSrLOr8V4Tcu0TqeRyyt5TAiha8ataFikVzYMXbY
	GWTTp54oakQlagyz9sj6l1mjpv8k7hXNOs5ls8e9bwRr0z1egHsLRsKFclShOOYTu2aH9N
	xq6rz33vI3QAzyHF/Hq0cYgkCd+dG4U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-1_7g3um8MhWtawDtdYZHXA-1; Tue, 24 Feb 2026 22:50:33 -0500
X-MC-Unique: 1_7g3um8MhWtawDtdYZHXA-1
X-Mimecast-MFC-AGG-ID: 1_7g3um8MhWtawDtdYZHXA_1771991432
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358e5e33ddcso1220121a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991432; x=1772596232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wunhJBbOcVRokAg1jAhfk7nGs+ox6MrG4ZKk3jSClw8=;
        b=LhH9AWA4cJ9kvodYPI1wf30mWLfKNc5o0evD705oDFgpjFQSucg+E0A9XBBbv5EosO
         6GrtyHRFDRtm1pVRLAxYESLZ3zJPwD5qRiRZx66/5MZnP4V7gpY6vNb1Mss3Vq9TvOvP
         A01E1JxK0Gb9DbWxRx6Esb9BUJal9nsH/oCgOBp95YxhUQfWku2Hsja1I0WXGAJOjxrE
         5qEHpmPu2vqaQKFpduc3Ok9BjkStefmhx2Qex4kL6eELpvqDY+tcQNHbJjCLyKJMVHcr
         UNH5VjRgTy3wh2eKOJXwKGxWthcgpSMgYqUgW9flqUntbb3rtDAeaOZbjmvIYjb1FVyd
         sh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991432; x=1772596232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wunhJBbOcVRokAg1jAhfk7nGs+ox6MrG4ZKk3jSClw8=;
        b=XbUUDNC/jl21taIcPW3mSgsTLAlkB+ZorLCYHjTG+CJgkMfwGeVVLslv7CwzphOIKs
         24NQLEVxnStz7owybbks+ef9uqYFyvciqovRa3shV58umBXpkkslGxGsXDgIEpLq7Vt8
         FVSL+vYjMBFXk8U4ffP/xI798rRGF7Lq8ZAb0w6hC7KyeIvO1PUMpggAbgGIaLaaBsBN
         dv0rTEjoNMDDc+NTKfBOhBzza9uYrhL7e5+kI5UPnSkvIXXpY2Pz7ZJ/TLHBGQ5q/V+j
         b+8Wke5WTVMK3vv447fQfbd874Rw5mzov6ZW/hN0i7Ax71aHipEoZ51+DK91M1b+ZAcI
         zAqA==
X-Forwarded-Encrypted: i=1; AJvYcCWF1sxQK2LGo95SZZt6odmOXFdmmaG0hSsQ1fXhvfsKWSmFIFKdjznF96ocZQVhUTTWe50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyocm9ZwL/U6fnSAqPwexC4NHygaZF3zpZETQ+GkkG4RbPQ6VXK
	sSYCf1olyUyPGDIFcnq9YQ6A5yBBHEN0RT9cGag294CvU8H7CrwODlohm/wkgmbXHbdNdhRjm3M
	o8j6BijeTQYglnGY0+rXhHpI1ULgGAVA/+NT5Qtax/KGu0LCF0c0qiA==
X-Gm-Gg: ATEYQzxnX3+IF3T7xJiean1zZ/T60eEPumydyEHW77eDxGjjput8l91QseagO4KGzP+
	dLwhWySiB0syi/Eo47voIlUh1U0haD9TpkehPdabvakkO1PZ4iNwZutq99K9PhRf/Td4ntnGnur
	1/Px+u1h4k9/zSMjwKgKVDK2GP2Msnmf6QFQRXSnuV6qsswPBYNJ4w3IN31dsWG+S7noUQeyLec
	pjf0Bo/xVPIlRBnGxTIUL4FArw6b/RFmM0QUAQtZ5C8262b+FBPedflL7cpsB1QqUSYx4A0q4qV
	46cBgiQ4dHAxCMt1WT89x0hFERlblqcsxii3HCrAaoib4rRdwxdmK0bTCALPLCGy3Lgt/L++qtf
	SueNkSWlUuxtRJeIRonTc4ES5t9EyjEjSJzOVsNs/DKgg5juS2RTOCB0=
X-Received: by 2002:a17:90a:fc43:b0:341:134:a962 with SMTP id 98e67ed59e1d1-358ae8c80ccmr12428343a91.28.1771991432218;
        Tue, 24 Feb 2026 19:50:32 -0800 (PST)
X-Received: by 2002:a17:90a:fc43:b0:341:134:a962 with SMTP id 98e67ed59e1d1-358ae8c80ccmr12428333a91.28.1771991431798;
        Tue, 24 Feb 2026 19:50:31 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:31 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 07/35] accel/kvm: add a notifier to indicate KVM VM file descriptor has changed
Date: Wed, 25 Feb 2026 09:19:12 +0530
Message-ID: <20260225035000.385950-8-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71752-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E487E1914DD
X-Rspamd-Action: no action

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
index 096edb5e19..3b57d2f976 100644
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
index 5fc7251fd9..f11729f432 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -181,6 +181,7 @@ DECLARE_INSTANCE_CHECKER(KVMState, KVM_STATE,
 
 extern KVMState *kvm_state;
 typedef struct Notifier Notifier;
+typedef struct NotifierWithReturn NotifierWithReturn;
 
 typedef struct KVMRouteChange {
      KVMState *s;
@@ -567,4 +568,24 @@ int kvm_set_memory_attributes_shared(hwaddr start, uint64_t size);
 
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


