Return-Path: <kvm+bounces-71753-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHVoNKlxnmlqVQQAu9opvQ
	(envelope-from <kvm+bounces-71753-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B6D1914F2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE96530D0529
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADE726B2CE;
	Wed, 25 Feb 2026 03:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABhT0X+F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RKzwgjm8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83E679CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991442; cv=none; b=PS2kAicxA+CM1KPuBYjubQrqEa1aBh6rRpM0iqXfhwyhzu9LLBaWGZfjo7HYw4lTmr0ocRzwQY98F14GXakFLwzRGfYgRrKyaf+pN6FcLtoj9QK2a7nDYpDZn+ME4PCCCRRaegdML9OBRW+GWelZjyZeRm/opb15ljHJ4UClT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991442; c=relaxed/simple;
	bh=Kri2Iqgv9XxyNr1aT82/3mdA4CkFAlDCoDbJYk0QAHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaxYUAqIkvIudGDDlZf8SlaB6FQVa/DrCzO4NsI4BZmYyZaaWbLhXetN9gd6af4WLnSYbvVeuuTD/GGXk9g6sGzJpZYIfStqxXBX9A6t6OQRHfxcSoq1/eDfkkw9DF8o+raSKZ+7L6BVlU19LwTyRGGf9ALZ6TYvLAyF3/XIfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABhT0X+F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RKzwgjm8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NiDP313hLYqjOYRS0lxOjLmlSH8sKARSr3ovVB1pph4=;
	b=ABhT0X+Fe8iGNLTytiovWnmuhpxvweUQQOAlQhHTr0A+Ll3XrADDKIamaHarCX3OFyfAml
	qn6NxBpRUB6OzG4ApIEvqUFyGDC1zi9CG4rZwN/64eVo86Q35a+h1yjUS0a7gG+0+/nz+D
	idKpEYBQtJpCsQ67PaF8O9fYTan+oaE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-oozdfC1kMIafEZQaPtOA2g-1; Tue, 24 Feb 2026 22:50:36 -0500
X-MC-Unique: oozdfC1kMIafEZQaPtOA2g-1
X-Mimecast-MFC-AGG-ID: oozdfC1kMIafEZQaPtOA2g_1771991435
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354e7e705e3so4381072a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991435; x=1772596235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiDP313hLYqjOYRS0lxOjLmlSH8sKARSr3ovVB1pph4=;
        b=RKzwgjm8WibZFPBAhu9l55TPx1qmZdXqUVnpZkiWBCwSrKHi7xkePNfvpkdpPG2KGs
         Oj1bTPB95J4rGaLsKTc5pj5KZFVn8d4dxb2ho472ockI2ppu1MGWpAh5zKa9nvEek6IW
         CbjnPTwW7v/1Z0cefYPQAlHjoly0CJcn+K78Ohcl2yDozdvWKxW8Z1qCvw9sytWZpohE
         uGZYajqq5odfnQbJOY1CbOp+rAnj5vQ5DgureMz1J4jfl186KdOFlB+VJOEcAt4FLl9Y
         FO3utc8ojARZGoHij+dbr/RaQCBZNhWZ+xnjZ9Z0yuxVAx6jKlkOvrulvv3kca9UvS2w
         cBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991435; x=1772596235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NiDP313hLYqjOYRS0lxOjLmlSH8sKARSr3ovVB1pph4=;
        b=ad8bgVlU23EPW7HyEqNoLi80pmvaSkTad04WsxUOg7Lqkd91R1bb5rFSRupZBTtjO6
         4sRvdgvlwzdTmV89esso5jXhxfPM4ARs0bDETjkIf2cPZaCmrb/0oBnifDbRWt+rIVqt
         jjXFa8WklmLQhCZJ75it4/mFxmTw7fNUaCuHkr43q28bkkXstK8qSHh3TiTrDfhT6zVH
         SlXB5j11+0JQj++Uhy5pKDjrIqIFx6Vasl8dYBL9U3Mh3apwX778reY8gXu/gnQe7Gn4
         A5faIIDYvR3d229Lf5W4pJYtX2RkiALF2uDIhpHAlqQBzZJpNgx6wVBu1DJk76Iquz1A
         hA8g==
X-Forwarded-Encrypted: i=1; AJvYcCUdTfOZSJtM0c92fjsgFrrAajMS2i6xEcOo5kNsUNCSP1HSxkWNyx60nE322yU4QxyB5HM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwryJZkIYpPYvfQpUvHuNHhkw34eaXkn1SnFOdBj2u6kpQFliZL
	NhxnxzuyyQhevgpuKQ6z4qnZE+zJ1qMc2eCgDKYttdxYQMTIxEWima+LUZn6HOmP0XdGBranFfu
	W+/onjsvwIeciOcX6nCd5Lap6vXoxRVocL9ucdsOnvfzX7/OzTfcWdg==
X-Gm-Gg: ATEYQzyWihsKF1ujR5UudOCN8q9TnFFkrt01llPyggTZSzQAAl6401nlbTEvhOnQCEw
	Sjh0JJHTYZJBOi/vVofKnQOeQ4AOavClBPgbZiUI327KO1dP5JOnLx809si8TgSzqxWDV6fcxej
	VEziO4UrybUrHcZps23JvY3KqV//KLKEKEwNl1WhECd1TxkBn8sOmhSnnp5hTkXjtWi7PU+UDEW
	LTwzmWfTeSt02EQcHUGVG5nRHH25PV0mwQXkcTscojBJNlPlPE2MvxnNg/L1to8p/tSwTyq9pwf
	xeIDaCutpXUtQZfIBP3SdzRgowUqlMiIqkK67qoN6PdhK6tJMalf8ZPxz+fA1wy8rdq0tjgl+ra
	CGTpn4lauGhalz3E4fRPNtpbDbhXoKRPkOHmxn55bCqY22Ve90uAU0tM=
X-Received: by 2002:a17:90b:5783:b0:354:7be4:a250 with SMTP id 98e67ed59e1d1-358ae800844mr11015522a91.12.1771991435193;
        Tue, 24 Feb 2026 19:50:35 -0800 (PST)
X-Received: by 2002:a17:90b:5783:b0:354:7be4:a250 with SMTP id 98e67ed59e1d1-358ae800844mr11015505a91.12.1771991434814;
        Tue, 24 Feb 2026 19:50:34 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:50:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 08/35] accel/kvm: notify when KVM VM file fd is about to be changed
Date: Wed, 25 Feb 2026 09:19:13 +0530
Message-ID: <20260225035000.385950-9-anisinha@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71753-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 56B6D1914F2
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
index 3b57d2f976..d244156f6f 100644
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
index f11729f432..fbe23608a1 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -571,12 +571,14 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
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


