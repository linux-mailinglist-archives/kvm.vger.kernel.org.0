Return-Path: <kvm+bounces-69192-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNwcA1ZKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69192-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEF48FFD9
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8C0FA300D356
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B527329C70;
	Tue, 27 Jan 2026 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnTeN/sR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cf5lI/LC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4315B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491026; cv=none; b=YJ7pApUqWX6nC955/dOVDrJbmjovCoHM1EBmt1c/xr2CXNtTrqcfXABH+Mb/WfgmT2GW3R50WVGlYYUg9nzeTWMAlus/7fIy+g4SbaQwSdCnvJtpRMOlTDDq41QBnywWzvNwc5ESw4AmyjWPUXJeZB1CJpmX6t7f2xhHwW2abc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491026; c=relaxed/simple;
	bh=f5mfUZfEK8aNd/nVoG2S7pNE9ZlMs33Kft2+f2t1jsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnQOpIL9ujaU5yFlgvodhuWjfzC2V5lOBDSAAup4F8v9NXt8U7j1lNaATWPOeZGBpChHEip49bUfaIZuiDTlb4aVWecup2Abj0c1hjxakf31ViMrn0YNNB/Yb8nAThBm83xl1H8JLJ2595gzIESdA6MJeg4a6iasqgXjQwqiJ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bnTeN/sR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cf5lI/LC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ekxz0EEyBOQMVYi/GjNSmeh3FZ184pWI8lFYWcurNPM=;
	b=bnTeN/sRggopahrQjLxVRvPankNsIk7HCPdNopOMZ2KTcVq7slDkyA4aw7D46fYkV0bRZ/
	rWXlB4stK73e1pzG4iZdDh8V3QHY3EG/xyYqEIhTVYsrVCm6tbBjNwQ3h7blkFEZNy+7sW
	6AP1ccyfiok2njXmpVyH3Kp34eP8Ug0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-py58LzzoMF-fAS2upaV74Q-1; Tue, 27 Jan 2026 00:16:59 -0500
X-MC-Unique: py58LzzoMF-fAS2upaV74Q-1
X-Mimecast-MFC-AGG-ID: py58LzzoMF-fAS2upaV74Q_1769491019
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso4780637a91.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491018; x=1770095818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekxz0EEyBOQMVYi/GjNSmeh3FZ184pWI8lFYWcurNPM=;
        b=Cf5lI/LC8h3TeSgxIzraTD0EVEJKdMmTquEwNgIN82Gvxu2/+C6RdZXNs9er0tgC63
         mSWy43MtnIpWbIqncfvNli4qIA7hX6AbbG+hJ9ea/jgV15NqT1QKalfxADUyQDCzdsAU
         Anr5fZ1BLUyuVUIcPyL2IZuWWV6Em4AI4aL8cqQFW8z2Vi1Jm0DRCswADWZ6AQ+nt4FP
         X2cJZJKWhCngQ7GcDqJhg68z30rKS4lSuUraCodtWLqMvqufodoIpoCDqgNcNmLDfHDB
         4MykbqG1NYGAFeu8/9iY3UFZ0ttP0lGHEzSptMZYsVZ/lxUKRbPW3drxDMnzsbSZcKLr
         8TNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491018; x=1770095818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ekxz0EEyBOQMVYi/GjNSmeh3FZ184pWI8lFYWcurNPM=;
        b=J41zah4uNQDm3cTPpn1WAvcSCVdNZ2IoZVdVkne5+1/yK0S0ERsL96hSznFWSZcUDy
         G0Yj16wZycQaXXlF4RRBU9eGhRQ0fFV0bcFpfpS4lxRPCZSViNDeviVbu8D9wSHCVPc9
         S5VcouaTDKS9r6xXkl45RjiGSRQ8TNtCEBFGbHCj8MZWhmkOv8aLbupxdeg2xpSlSkSw
         P9jwiinYCWGHb55nIGc9SFvvOi7YlfxrXbchERZrPdOm50i0irvVgK75l5wdcGVQZQ3E
         r5h4K4qKnOKA41OzhtzkSZoFakT3lPHn8Wjt3sSLDy0oZs8Uc4RX6B5h1FimSfSDJECi
         zZrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0Gw6mPQ5dHCWg7IbJyesPKYieUjpdvdPy2g34EW1fgs91plZxS23EhMpwvLVNat9Mbzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFA4Jf4/qyRRSk9S///AtopehsJjKg/esgDUtIZ6UbiKBiIhi1
	Z17rAxO6xE5OphaZJj8TtCC9T/MGweyqqqAw0Z5P7i+8BAjojlOVkIrc4YFNseN+tkOpuPKBNxW
	VYtQUwzeou9J7QK0r+VWtf9gNI3dH5avVm9Ar6FI9f4nxoMyI4h5i/nlx/wjFrA==
X-Gm-Gg: AZuq6aJjJkeSPmQyn0XWFcpiMahQIzBowsIqk6iqziNzUnQu1jWQDFfMObJOGWIWW95
	I6wedYAlzBw9y6aLqQwRtjsFbHRgL9bPpoIMma0Hrz9qGoKoNPOiJI2kWZwgZ9POM+JwlEYZQp7
	Q0cGAB0aTmY7FltayBKLbWMELNMyKwv3993fMIs7V2pB1hb+s8tlwSqlhfsiyXDYJW/GkiShcvn
	fceOSLMq514HTqsJP2PvTDu+FXAIUo0na5SuZ/LUFFipQYFthrDtgiTQND1qsuUK4YyNK3zUMGH
	BBUNlduQyVerh1f6C2mrWoR3i68eIHls1pUCjLAZbcDHm6aWN5+SDuDb66zS+dsNhtgSn5JASa1
	QXMMhFyAiSwYaixLIaEBGXu5BsMNUqKkdTn5Om5j1sw==
X-Received: by 2002:a17:90b:3c88:b0:341:88c9:aefb with SMTP id 98e67ed59e1d1-353fecc6679mr585033a91.5.1769491018475;
        Mon, 26 Jan 2026 21:16:58 -0800 (PST)
X-Received: by 2002:a17:90b:3c88:b0:341:88c9:aefb with SMTP id 98e67ed59e1d1-353fecc6679mr585022a91.5.1769491018057;
        Mon, 26 Jan 2026 21:16:58 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:16:57 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 07/33] accel/kvm: add a notifier to indicate KVM VM file descriptor has changed
Date: Tue, 27 Jan 2026 10:45:35 +0530
Message-ID: <20260127051612.219475-8-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69192-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9EEF48FFD9
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
index 834df61c31..06d72111e2 100644
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
index d40cc9750c..6ab37fd440 100644
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


