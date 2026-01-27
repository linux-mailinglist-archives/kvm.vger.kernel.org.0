Return-Path: <kvm+bounces-69206-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNdwKVpLeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69206-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D6D90187
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AC75308DB11
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1632329387;
	Tue, 27 Jan 2026 05:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HleKLDgk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lr5+QHLx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131A15B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491087; cv=none; b=N8bCWEwxBYApH1a9cu7jijklcHU38FhGBIUtcf85DoZnUCwEjYq9BOfpGPxeDDc7TtwlSCncXeIUg5f2womBI5yH2f+FISEb7nLzXtEBfUCucF7S++AmAIE8nzxA/f3B15Z0lmGOQmLRwcnP8aAusuZZJmFKduCXEPZpJKRvXHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491087; c=relaxed/simple;
	bh=0SzeZ9KA2vvNrf/uLWsbg6EXdicxRvCE9P4vKsk0Rbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGn+uCRFygSkrYqcHDWQ2XPryTIq6np3fNj3lbR3aHllceZPX9xTNaiQypGyPaC5jqJkFLsTOZenlsz+gsMP3jX10sNpVgd0PR2RNwfgqbiykPnKmjMzWikozQDjYueIR8MQzVTdHTaxhTc9cn6vpv5YNFHMpKMOA/A1gTst0cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HleKLDgk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lr5+QHLx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bEDYSbwkzm3iHaRebY1agUkwYGBShvhOSyrbmVbxi+E=;
	b=HleKLDgkylfMiYRYEEP4VNBlm1NZ2gXZ1AQryNFUQTEFBcDLj0wFDq1Jli7s4IxkK+U9ww
	HMB0TBan8t+iPub70J5iwdzfJTjM4L54IP9LN8L/PQu+s6z54ajLzWY/sHwQy0iatuVRFM
	Lg5llOScvtbAJsk2dJApZSzu8tdMVpU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-JxgCRJDTNKyVMMfx9ufURg-1; Tue, 27 Jan 2026 00:18:02 -0500
X-MC-Unique: JxgCRJDTNKyVMMfx9ufURg-1
X-Mimecast-MFC-AGG-ID: JxgCRJDTNKyVMMfx9ufURg_1769491082
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-bce224720d8so2937821a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491082; x=1770095882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEDYSbwkzm3iHaRebY1agUkwYGBShvhOSyrbmVbxi+E=;
        b=Lr5+QHLxr6/fgucvAPZERik7kzk6TMyH70gfX+m8Q3ZEkiEO8eq8JDZOqgsyPld8B4
         GkjpiSilV8dUUlUfarWitRkIkzEiS0Lr2u63FnkoJ0s8AyMu6n7tGXvqj1/6JOGfBhxr
         amPzkqKISBqrZ91KUHC45rLFEjCL1zvHs9v3+ZqKvhv39qpgc/sbtM8F4jY3e6StBRbT
         Mw8MtcutbfkYkOAAmVZf6EXj+jiDEeS1yC+G2x2HiOgRIHNu2xrDHMauBY+grqm8zVow
         OFAb1b09iHze9oZCzsW4I1oes6ffiU3DSKYNazbprQ9mV0920zRlpMuOSjLV3y+t2NHE
         gVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491082; x=1770095882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bEDYSbwkzm3iHaRebY1agUkwYGBShvhOSyrbmVbxi+E=;
        b=JFZpaFWZ4fefTmPIqt+Tmt+WG/sMqcqfewpjLB3gzSTvYCxtEhtKxGUQO6oQd2T/aA
         b/Gh3Qx0DNVf6BZkpzsB3slVjtCUqN1t4ZkpObShWj60M/EuZ9DckQs1JATk0kiR0umi
         3EX1Sfe1SlH6FB5h69NEJNlgB1cdtI1gMOW/bq7Tb49Hdsokqu4ggzXg5uov8reuS93X
         aulf3YevpL4dpGBrr6RkTx0c+qJLPCd5+RDxoEW8xnxR8+btsOCrbEe7pOLMRLwvVw5p
         gC9Y/dLARywsAYoDfzyKz8mxTYssGrBADRyn10bqdQcyl3HER6N1NxY1D8jTPzThgBPp
         H3zg==
X-Forwarded-Encrypted: i=1; AJvYcCUsGd8X35ho5qncNtqj+NGAAJKnpSPSbhdw2CrnhjwSPSfeZ+mmxKfYpQgBptXqQJO3BUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfbBwIyG/3GpjVqwQCFNpdnXN2Cp0Na+xstUZ0OW9efP5Zxro1
	ofAGgliKr204hujl1E9optSDmTGEgk0hhCCD0PPT1Fa0Xn3Vz+9yXhvy+3mIrNvKzHr/S5466DJ
	Hy+/pcoAWjNdJybddnSJHwMKhAQr0Z1/DdeaYs/VB+Vpa6guWiTPkiA==
X-Gm-Gg: AZuq6aKmMVo1SgYA22qTy6/+KXZec/Ou+XEMGj11TlkNGJ4sYJTVR6U2BB5SgnvQgID
	P8xbdkNcuzml/etOIz1DcwokYxfG8cbh5QTUPSk1391Xey6HRVAmgryG+UFAsbyD44AjkxXk3vm
	5G0jnu4bI29TMkeEwo4U0iz+UFIyvDj3fwtkRCd3bRC/x4//jfUVn8DeTNy+Pku83w5up0wVYu7
	2MsZ7RA2ZdbobnF7FeeocRfFFdVhhvAlR+R0YaNTKWJZwmdZvOUVVXZfMN1jNb8vUD/Tys1o+cL
	96AvP8xXkf6DqmmLwHwbBbeHug7gTY/5PBcZ8WFJec4vhqgXMlI3X82+5DdpnosO5t2tkXpAmEJ
	YNKn+iwsoMK++bnIppRmcVlMu50OeiVMjlEBbJNkEVA==
X-Received: by 2002:a05:6a20:918e:b0:366:18b3:85c3 with SMTP id adf61e73a8af0-38ec62899cdmr496033637.1.1769491081802;
        Mon, 26 Jan 2026 21:18:01 -0800 (PST)
X-Received: by 2002:a05:6a20:918e:b0:366:18b3:85c3 with SMTP id adf61e73a8af0-38ec62899cdmr496015637.1.1769491081377;
        Mon, 26 Jan 2026 21:18:01 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:18:01 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 29/33] kvm/vcpu: add notifiers to inform vcpu file descriptor change
Date: Tue, 27 Jan 2026 10:45:57 +0530
Message-ID: <20260127051612.219475-30-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69206-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 48D6D90187
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
index d43a363488..a28b0edade 100644
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
@@ -2313,6 +2316,22 @@ static int kvm_vmfd_change_notify(Error **errp)
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
@@ -2840,6 +2859,13 @@ static int kvm_reset_vmfd(MachineState *ms)
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
index a17cd368ca..8265d0ff4e 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -589,4 +589,21 @@ void kvm_vmfd_add_change_notifier(NotifierWithReturn *n);
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


