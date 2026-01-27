Return-Path: <kvm+bounces-69193-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCVLL5lKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69193-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9989005E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70B8C30440BD
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65765329C71;
	Tue, 27 Jan 2026 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TfVDmuFX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLDb76J6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6166B242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491026; cv=none; b=bGkGpe5p53ylQ0ikbWpjxsY/sIfjohTlSK4J9HMsctoRGnSsks9djc0RZGqNPo6b5nFRL7dSvf9D7OZa66DA2Wopkqew/qc/8kfqX6yUUa5Jd3XIu6m73raZemE4UJ54BSg3jKCDg0pK7pckeUAl83X51mKyiwC8FZb9FDmV8uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491026; c=relaxed/simple;
	bh=P1hLO6AuUWl9mnlg6xVBkthXhZ5n49Tg+jMbbX/0smg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2ZqnukL2NG38YIA/IQOY/q6zyJog3LuqiWyVDmuyLwnPNSnBw+4gEd/1HNnLtlkTyQr2ZrXjIonV8GhJ6L8C0+siyknLch+NTUNzgwugHIk4dgzUiJ93gblSPQ5cps1+WO+/ML+/o883wKtQ98aOhcVxE1KOByD5uRunZMOrPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TfVDmuFX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OLDb76J6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdNlCVdePrLQZM93WRK6oLwv5KTpdxmb5b92LGcPxUQ=;
	b=TfVDmuFXdpOnjgCrlKEsw3fv7Cm5jBylQ1bKaJqcI5qNrbhZOSuzB1k5kds11bJdDjUJPR
	zJt5bXJHftOiaW+aakMLunEXmaenEZfJBS3+WVAGCvknBvqYl7JhyI5IbPATv6PM4diCOG
	4ZoiSeYX3KYzMfIKgAfQKhSkRMHI8OU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-0uajNtLXMqieQy1oJ_CIEQ-1; Tue, 27 Jan 2026 00:17:02 -0500
X-MC-Unique: 0uajNtLXMqieQy1oJ_CIEQ-1
X-Mimecast-MFC-AGG-ID: 0uajNtLXMqieQy1oJ_CIEQ_1769491021
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c6124a9fb86so8242409a12.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491021; x=1770095821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdNlCVdePrLQZM93WRK6oLwv5KTpdxmb5b92LGcPxUQ=;
        b=OLDb76J6ojs3voNNSkT+XM1etBiOxKNW5DGkRla2qFPNaz38xEjtmDKa4r8lOMrcR1
         tyVUPPiN1L1p83nE0JX+63K1XLADv+pUd68CNmvh9Qnci+M6qhrgoFGXXAcfBIx/RXbo
         bZulFgX2ob6H9GmBCu5nro3s6XGb/fbqpeOr+/1n+CjUophNOtjPl3MAyP1YlgzcMmaU
         J8Nt80orkrnaeNN2D0/AVQZfytZOkdL1lpydbBNqb8ld6udrjslfE9TChh7dsEiPCBcJ
         1lGeCcwjzShkivdvWnRMUjXZWOyDFQ5j3z8gP1aM6isiI4cPldZpLjLtvf/8GQCQ/H2+
         x5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491021; x=1770095821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gdNlCVdePrLQZM93WRK6oLwv5KTpdxmb5b92LGcPxUQ=;
        b=WPS0BKlr97R0CkYyenacCKB0XgUtnHpt4S0Gzq9vyPrnGOFlhIkhVrSabv/6LJdlnA
         6VPG+dmIcaIlwrP0B/bW1Dx4lIaH3BS0CEN9hzjChu+wUG97USWh6w2mRK0A0nzUJEgZ
         8A6f7NwEIK+lEX3/PDc8+x04AaMqgI7LDamb59/29hNtSHtO4I2DAKs2yDHju3QJUApA
         MShUfsnP8KkhPnzcx7nxrJJj6Zco0hKAp2Ha2lIdKO64zvoqz+rxKZ0vowA3OnEYyosj
         D5k/qOprHBfNLNuLRdrhcD8j/EsRrFCMEuQllaWEqzb5QdzYkr1yALw8FWAzSS6+yWh2
         IIQg==
X-Forwarded-Encrypted: i=1; AJvYcCVJcT/IEPUvwwibUIGf+0L8BoClT58uJxSTX+5WY9I0N2bx30oL0y1GS7WUHD2ZEPlQjEs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2FkcitpGy45VkrLjLDj+t6AYxdEyNuS3TIX1nd3qK7j568p5L
	RWHwXL9r1LSkWi4EjM4dqMLl4JFtVUzJ7oHolsIz2WO3CQAVhbG70MuulAKxw2Tlun3vko9J4DU
	yqn8Dev9Zq99dh4P4Zwyfohbduw5r6PBIcaJAJc9oKKWWemcXnaUfgg==
X-Gm-Gg: AZuq6aKWvyoRIilUF6DVho8kWOTPzLOWrkzX3UUygaoiKoiZPxSisKABW/LJDy8jVJP
	94Z4N9WR2unDuGl4G9szJmpFYyFoLsrP9kfWEZdyYU3ZzX6hrPQTiLh+JwKxY4bBEd1c7GOMkQB
	tVjnXPrlaCmMgRtY3QfwnmMSG0GTlq02LinpW9z+g406cOf2dzDoPhPZfUM91do/zmetclvWIS5
	zscXJbbQkbRiguowjCpArmHvrnWBpEEfE/7ZAOYy++b92GKF3IYVgBnhvBTEpnzd7H5fPc4iFRl
	PWLCPEnA/SRubw7Gum17Wc2ufoqVhDUIVZ2UCmjVGhPQm55aBwlAo0XRoQ2+dC5L3SrcUxEIjcw
	QE6RIZtgkcJeP/9hOdSm03l8X17fgNJk1NHx4BmC9Nw==
X-Received: by 2002:a05:6a21:118:b0:38b:ebaa:c167 with SMTP id adf61e73a8af0-38ec629e677mr543681637.20.1769491021021;
        Mon, 26 Jan 2026 21:17:01 -0800 (PST)
X-Received: by 2002:a05:6a21:118:b0:38b:ebaa:c167 with SMTP id adf61e73a8af0-38ec629e677mr543656637.20.1769491020586;
        Mon, 26 Jan 2026 21:17:00 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:00 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 08/33] accel/kvm: notify when KVM VM file fd is about to be changed
Date: Tue, 27 Jan 2026 10:45:36 +0530
Message-ID: <20260127051612.219475-9-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-69193-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 4E9989005E
X-Rspamd-Action: no action

Various subsystems might need to take some steps before the KVM file descriptor
for a virtual machine is changed. So a new boolean attribute is added to the
vmfd_notifier structure which is passed to the notifier callbacks.
vmfd_notifer.pre is true for pre-notification of vmfd change and false for
post notification. Notifier callback implementations can simply check
the boolean value for (vmfd_notifer*)->pre and can take actions for pre or
post vmfd change based on the value.

Subsequent patches will add callback implementations for specific components
that need this pre-notification.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c  | 9 +++++++++
 include/system/kvm.h | 6 ++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 06d72111e2..538a4cc731 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2654,6 +2654,13 @@ static int kvm_reset_vmfd(MachineState *ms)
     memory_listener_unregister(&kml->listener);
     memory_listener_unregister(&kvm_io_listener);
 
+    vmfd_notifier.pre = true;
+    ret = kvm_vmfd_change_notify(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     if (s->vmfd >= 0) {
         close(s->vmfd);
     }
@@ -2695,6 +2702,8 @@ static int kvm_reset_vmfd(MachineState *ms)
      * notify everyone that vmfd has changed.
      */
     vmfd_notifier.vmfd = s->vmfd;
+    vmfd_notifier.pre = false;
+
     ret = kvm_vmfd_change_notify(&err);
     if (ret < 0) {
         return ret;
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 6ab37fd440..a17cd368ca 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -570,12 +570,14 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 /* argument to vmfd change notifier */
 typedef struct VmfdChangeNotifier {
     int vmfd;
+    bool pre;
 } VmfdChangeNotifier;
 
 /**
  * kvm_vmfd_add_change_notifier - register a notifier to get notified when
- * a KVM vm file descriptor changes as a part of the confidential guest "reset"
- * process. Various subsystems should use this mechanism to take actions such
+ * a KVM vm file descriptor changes or about to be changed as a part of the
+ * confidential guest "reset" process.
+ * Various subsystems should use this mechanism to take actions such
  * as creating new fds against this new vm file descriptor.
  * @n: notifier with return value.
  */
-- 
2.42.0


