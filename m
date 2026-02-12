Return-Path: <kvm+bounces-70906-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIUFE6FyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70906-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A895312A974
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A64E230AD8E4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A78B28D850;
	Thu, 12 Feb 2026 06:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6OBh5Nk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n0KzJs1d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB02A2749E6
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877562; cv=none; b=RtMwIQdwEKcXOKyAT/hPeYRC/FOSqU6B4MNokQqSYS1x5ZjYGrEf1evurs/j+IXQnbuuwvjtHTo9RgRoqKHbncecygGjv/l9+3lwZp80WncVLeVxLoMY9e+2PRe5RnT1cpxvHDivF4cGMRmdycJqcHSzr9Gmxk/PHvSXK6OGd/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877562; c=relaxed/simple;
	bh=Nxj8yJSnJvnKx8e7p31liGaQDgvSKbVha8h8wpB6e+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZdfuM7yfSxKUCGKiYE191KSdLqVGuGOX9KFZPGzp++ee7ryduZPlMCpbZjQbpB72/RR5Z5qMltjs/KY68HvABI/FVk270BcGOXh5EtLWAFy5QXLr+AgxaFyJrnyXmhRcjOMJnQyoUfl9wNm14tigCdMDWqtrTtOOqP7p+j5sx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6OBh5Nk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n0KzJs1d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+nJSPq641/KU7PW2uyxECihx9MetPiHgqWCX0M+BsoQ=;
	b=Z6OBh5NkH1u8KfS0XdznSciIGvUIGde1X0Io1I46G3mrUzZJxU2hH7lF7szIsXyLY2aAqZ
	9576eFYMs4ayTqnrG5IpzSlKOAFgmcdSKpEGZq9uliaMclclleExTtgOnYwAuFXNkVAQ3V
	lYH8P0vGZvKjreuDtAZDT2m6bgh/1W0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-sKdr2Ma1ObyeSfHDaAnksw-1; Thu, 12 Feb 2026 01:25:58 -0500
X-MC-Unique: sKdr2Ma1ObyeSfHDaAnksw-1
X-Mimecast-MFC-AGG-ID: sKdr2Ma1ObyeSfHDaAnksw_1770877558
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c56848e6f53so5051356a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877557; x=1771482357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nJSPq641/KU7PW2uyxECihx9MetPiHgqWCX0M+BsoQ=;
        b=n0KzJs1dGfdrHl47LbdK9RD0CN6h4LNZx0SDWXMFXIjRBQx2hWWQQXN6Mfjipc04Te
         IyB14lU3+hpK08B9+xVO4ZJQJKPGnaFIBczh65BE1k1rlW+dy3aRhAu/UckURplxSv3G
         vIhl6LoXi4HMIz/zwxbwiuKcdKoizYXc1Zj54s5oFcFnEmOVlAc5lGafU7ZOHBFbYS2s
         PpxUfzs4b3HHlu0e90XIRYn0lCmbx1tilGWTBFwmqssn2N/oFuBjoLTXONsUJ0YM8q6q
         HnoXgK3chKKbw4s+5IIB/7PXHIYRsZST2jcvn8xRINpBdMqzXu0BCdOmaqY+TQhyiLsc
         XYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877557; x=1771482357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+nJSPq641/KU7PW2uyxECihx9MetPiHgqWCX0M+BsoQ=;
        b=CcZzJjoMnrRQ9oUf+bBORl9h1g8sIQXifdozNuJVDqJriJiPyVgjaSqqmm+4F/Z/ES
         j8XBEEQJUJzyDSPIx3I79Ug+7B5B+xuoIgFOtf2ZB/BbO6BHggmnyxCbWpbGxbe683qS
         B3iesBP+4PaaRmCKFHcHDN0zsdfilobMQPVrlyxomJs+w/xpiodujCo9UopDPqIyK75H
         +zaCxEINagJ9CdAPLcuFw51hS/5g6HogM6YZmznO6+tMb1ccOl+bdwHQHTaA3xraSwlt
         E/3moVJekhB6maeml/Ec5oxLV/rUVcKKNmNlVq2pFHVb6HwUxR6g5AEYcMkNGjAYz4/J
         IITw==
X-Forwarded-Encrypted: i=1; AJvYcCW9cY4G82ByWK/sfoUN7ZhwzD7Z83iT5bA2c35dsKnv/l78k2nm6IkMvBlJnWvbRUUNfRg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8bG3xA0RPoguUoDq24B5Pqe98VD+AxGKvdibb+fa5S/ihMPsc
	Z16OdO7tKHJxlOOnq0CrKtOcjBDobhov5hxXl7zDodikkqvg+UlabQ7U6imZMCCTu9GajNBZ2wn
	merdM0i/+jrw5yO3D1th5XCj0X62p3o92Biz9uAIjLlVGz9a8y2DuTl84zZQDaw==
X-Gm-Gg: AZuq6aKbbXjRAsUr/pIOBFtAPuE/0rFQwsAEp3qisNLzuOdEEiZdtLiIxk1Nyv9rrpl
	M/gcfKip+7+qa223w71aC7ZFG+cjNvU1PoLQjN1yHLxZGQ4k2lbOIiCrt1J9gpDpRho62BJXpMx
	Q9LrwI1748Ng585+jTVr1kroVUuF892rDhSxgR3ajbnUUtZjiLfK/3YqoZX+jrLoJIqrUNbF8c9
	UrgxzG8+VpvR75KPs13ikXoqJDFCfJsj3agGCWzFvvQBGEIMiVQSHpBx5kEMxhKx9RZao5fkm5d
	7YTMaJV8Lgva55vXJa78QAWpu5pq7Ka0Sb8ZbIh2LKAZqMSFyynLuJkyqwWAcLp2MHsDRsXUOst
	arcf+dBqbM2E+dq1tKadvUUBUbH92sa+g8f6E9C+8x6sM2nvHR35qjSE=
X-Received: by 2002:a05:6a20:6a28:b0:393:7575:a8d6 with SMTP id adf61e73a8af0-39448bae9femr2036473637.71.1770877557399;
        Wed, 11 Feb 2026 22:25:57 -0800 (PST)
X-Received: by 2002:a05:6a20:6a28:b0:393:7575:a8d6 with SMTP id adf61e73a8af0-39448bae9femr2036441637.71.1770877556999;
        Wed, 11 Feb 2026 22:25:56 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:56 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 07/31] accel/kvm: notify when KVM VM file fd is about to be changed
Date: Thu, 12 Feb 2026 11:54:51 +0530
Message-ID: <20260212062522.99565-8-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70906-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A895312A974
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
index 30d6295f53..a6ff16a037 100644
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
@@ -2692,6 +2699,8 @@ static int kvm_reset_vmfd(MachineState *ms)
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


