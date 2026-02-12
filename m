Return-Path: <kvm+bounces-70905-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDCOI4RyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70905-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C29D612A95F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7CC1F300808D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6DD298CC9;
	Thu, 12 Feb 2026 06:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRQ2AKBC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbNnXSwX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376728BAB9
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877559; cv=none; b=C63i9gjeJIi/4Z+9cIbrCOSo/nKmPhlUwn9ZX5EIlp1Buxm+RP/w0SbvMHQK70Kw8oKr2vjAmTUQVWWIA8AOWdfseuBewvZf/AmV0PaTVYoQSUXNiDb+5b/Z+H8D0on5CPPWfDbNxicOSDypuxPGq7OaLCfxfkUZt4AAQ2U+6Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877559; c=relaxed/simple;
	bh=1zmQolyliyDU+ee4WdWPqy+5CKiKzfhkO843G1zIDPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLUwSRQP17lRrKKqWZbwxkcGpqaD+Ik4Tlf4qt9hq2Zo7Wnh+kRn0F3iBgDL+aOoaSzoU3i9l5bMl11POx591V1r3/6BsJ6smU6sP8+9nOYsTD6KHXknD78zSTrnsxw8EeU15Dt7Dyg1dxlnbZLjJfonwi2vefm9pSWLNUtK/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRQ2AKBC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbNnXSwX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o5PlrDMoIrug3cAYm+kTR0nrJ7BVWWy0jAqCy4UtGT4=;
	b=VRQ2AKBCBm5nMg8CecryXLoLuzPCwC/KE6i6ny+LWbmJL0snqDxbPTCky+WkKzlJuN/zDq
	QNFET9jOdvWBTP3wP6KZrlxJ38QgJts27RF5+IdGuyJ4lSPq5Kh2+cb7XaEhwdpq7vSZZ3
	0QH4+mJcXO+T6KroP3I2u/bgs2I07W8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-GTcWjYnbMQ-99nD-wxNtgw-1; Thu, 12 Feb 2026 01:25:55 -0500
X-MC-Unique: GTcWjYnbMQ-99nD-wxNtgw-1
X-Mimecast-MFC-AGG-ID: GTcWjYnbMQ-99nD-wxNtgw_1770877555
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso11548576a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877554; x=1771482354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5PlrDMoIrug3cAYm+kTR0nrJ7BVWWy0jAqCy4UtGT4=;
        b=ZbNnXSwXhR3Z5TutCHXqCGXN85E0KB7YiozCrqAaV4BsnZRB7esxyfmsEkF5WDQdJ6
         Kh4Mw7S/jmhrN/OssmhJ2Lwe28vj4KnaHyg0x8IbDnAmdlmRrZKA1A/IeCOWL/Ntc874
         +DyFGkiIoSm8n9HlocEvgVLgl9grx4EOpj5Ii6lAhtyvLZ5r14+qEuynbd8Mp3YReHid
         2pgGBGb2lnUrYVZXFzK5/P1SanK2uFzZ1/P/ib+Mhjep5MrT3tLzkGxR5/AD+Ke8HDsD
         7Q4euU6TiuNK/7gvwaHYInBjLcjk38Z746GN1/9aAFqPhLyP79tY3rZhFWIm8xnDDana
         YcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877554; x=1771482354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o5PlrDMoIrug3cAYm+kTR0nrJ7BVWWy0jAqCy4UtGT4=;
        b=weJgolEC7Tt+ebXvD1vkMIPopDovWXWV/VAEt8+zKieVquGDjQPj2t54qjskj15USp
         M4guYXAfjeqtO8Pxi5ebKJq8oUJZEKwNB7aCYUWwtOOTPnxNLOHT4NZZojw7wKmJVH//
         HKqi6C3jpilNHJwkObKmT8Xc2UelaXTt3fzEVE5I3jj0kvxZe53Rtm1P2GVZDpFdodY7
         X3inj1bo963iUojuci1HPQVLnQXi1Nhfx2Bvo0vnwUqTjZWEJprdbKWZWDgpRfJ8s0kY
         UUqk8wNOP7BT9gs89aKh8voqu9vAhZnqsQFcilSNC4e53PfW2UW9eG/FsOk+bOn+V+jW
         Cn3A==
X-Forwarded-Encrypted: i=1; AJvYcCVF/4mWR3KQ1I+enufAOzw4M85+i0lYMVHgTMlFM+nXsBL8P3RSpzarDkhhiGhqkUmNaXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMRxlVfOKx5kegoLN2Zizsz02f2RcxvGHma1WfIFuAo1J/mc4y
	vNdh9sAcyNh3akL+qLAWSBAcdPF8XhR+ujdSNqudJpBvAuaOmMlGXhtTuS1kd9F9lpd0bSD59q/
	EFtE0M3s/4Bj1AW78TOoALSP3Kn0Dc8FN0f5PKvztCSMNFwfyatlymg==
X-Gm-Gg: AZuq6aI/Oi8LW9C5vR6qHqHwcH28fRb0n4z6ttQLO8aloL+Q1tzWG6jUyPjHU97zBQX
	fHlaSIU9x7+knpxs1QlBrAEEJ21iQdIBWGObXypYemJqdx5Udt7//VVCe9B1A4tZJ6M4ON3ECM1
	qZbU4uNg/CDcrBG/jGoxKFYWQIUA3N21/rJgRjOzYtgsjDtPaN4Fos1q4MTIEJ8nVnehp4VD2yx
	jsPQZqu4+CnKt2AtsqbyPh/KxQzWgg7cDcWepQwLTWZcHVhjgVFkVmXHDJmc0O8iF9gFBZScYXZ
	lP3lYs8Q1ALQcnD53bANaR0b5QH2IQp1Kd7VDpEBMR40V52i2nCA2lELFf0n/DkJwmbdGBppvZH
	tiKMitHWHLPzbdlBcCJSLrIQlHX3z8kQOc82e4/Ou+hHVEhN+nECXY8Q=
X-Received: by 2002:a17:90b:2dcb:b0:356:1edc:b6e with SMTP id 98e67ed59e1d1-3568f2cc67dmr1813343a91.8.1770877554534;
        Wed, 11 Feb 2026 22:25:54 -0800 (PST)
X-Received: by 2002:a17:90b:2dcb:b0:356:1edc:b6e with SMTP id 98e67ed59e1d1-3568f2cc67dmr1813301a91.8.1770877553693;
        Wed, 11 Feb 2026 22:25:53 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:53 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 06/31] accel/kvm: add a notifier to indicate KVM VM file descriptor has changed
Date: Thu, 12 Feb 2026 11:54:50 +0530
Message-ID: <20260212062522.99565-7-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70905-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C29D612A95F
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
index 46243cfcf2..30d6295f53 100644
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
@@ -2668,6 +2688,16 @@ static int kvm_reset_vmfd(MachineState *ms)
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


