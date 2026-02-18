Return-Path: <kvm+bounces-71226-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eI9jJtWllWn4SwIAu9opvQ
	(envelope-from <kvm+bounces-71226-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 387C1155F77
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 951B4302FEA4
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F73A30DD2F;
	Wed, 18 Feb 2026 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PM7iPAvq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATS6aHpw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB730DEAD
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414992; cv=none; b=evqDq2igRHs+wB9rKFDrewGzALdpl04ep/M3NSOqxPDrx0gFW7eYLL4m47tJfKYFISPsyPctoq5P7RZ+vHUM7TjKLf5ilZnlDXX3asFIpHCVz26rlLqZuJ/5dNdv0bAKry9R7/NVfiek3zQ0jvVycgwokbHlFuPmriFClZRESMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414992; c=relaxed/simple;
	bh=3X3xQsYOO92ULZGK1/1c2M4+nu3Hijh0BzOdk6XLjIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaR6aI0SPQRFAMW4xrU4fMHzDR83rPLaQAG1TSBG+axLrmJApLsjSbRXnFRU/6Ona5eoXcgLCZOoxmoiwe8/7SKxufVvLD1KnslaUTKY08dBNqXrHdKqjjl8x/s2d3dcz4P9z64wPbGknDvZDTj+WS7yAK9/DUXf5+OnDWiGG68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PM7iPAvq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ATS6aHpw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JrYkaI8zWucrcUWEd6p2dGFw5Tm5nOCoxE1XNnZbb4k=;
	b=PM7iPAvq3DG/KQx595EK1neyb0OGwWUlz9Fl/ZFRLGfHrRALyo31jSHam+HvGi0xAcGoEx
	gSXTrFaznBsEOtFSbp/NG2S+/G7+NFMDz0WfLI6QnImBvSPp8HIOm9qcoZ5rI2HSCBGB3i
	+qUw/vzMUXsZTQCKwhdgilPGxfRzSk0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-kQoHZ9LjOqO0TEaZjKYBIQ-1; Wed, 18 Feb 2026 06:43:09 -0500
X-MC-Unique: kQoHZ9LjOqO0TEaZjKYBIQ-1
X-Mimecast-MFC-AGG-ID: kQoHZ9LjOqO0TEaZjKYBIQ_1771414988
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a90510a6d1so7023105ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414988; x=1772019788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrYkaI8zWucrcUWEd6p2dGFw5Tm5nOCoxE1XNnZbb4k=;
        b=ATS6aHpwpV/M+mVf0WGCvQiTc3GXupi+qSbFMdXuYBXuvZdz7C/9vkZuIteSggGrZu
         nabGYBPKHLYDIyYcm1lMgOU2HJmh9CriaXg1/Gc/wt8zz0o1FYMOA+QxauEJbspX3pWQ
         XvJ/ujM82KY1Qbrw1MH17iD0q8NsZ7d4dXlEzc0UiRYkgDVldgsISOUMLMv2AjHkPBnH
         TQc48erXk9o+xTSwO3CMFmbskpbmlhqsvyqHM2tVoh8kreYjod2it2xsQSLu2WjyaQWt
         +fqRcEjyRbh0XzwO4tIEGLReGD/xo7/DBaGEJdiIrpxVKk6WsUdPpr/SqlLT6USW+x3g
         Jrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414988; x=1772019788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JrYkaI8zWucrcUWEd6p2dGFw5Tm5nOCoxE1XNnZbb4k=;
        b=SW2b5zgGgNCjPwtl9Bjt8ax54c5fzm5JfSjg9Y2aNKXrdQzoVKOO0w0l088SdUCnlJ
         wkQtTQac7WP9Qf/qemMGCWmL5htNvfmRaA7i/vTPJh+ue4f2rhlZZbjQaxP4PG55O03G
         NYy2FPE6RnL4KpxSyb/v5tAqo8cWGnaDCfp0+dLo3Xa4CSt8X+9neBhjjxKlTFH1TjID
         hiXQtHAnZ1X+VOqxxX2cYRuuOavoqYplT13GA6mKUzD1diNg448SvowclNThJyDxPXpf
         0njS/bwFRsxn/tpPX05pvQEFsXMP605i2xMzvVZ3QzYAV4jPqFGuO0YvgWkj957+1za0
         ExMg==
X-Forwarded-Encrypted: i=1; AJvYcCVN1Jfqh2idYTo/QjX8YM6PMMmebFvm6CEObd6oXWldi9lld5YcPVVHc2cvvpz6mfXhruo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfWy7KMtJF8rw6bj8PUejHit9G+VBHHipK/QspgyE1JhlIWKXw
	wVrvESr6a2g73DRgY+cRuDlhw7zpgqC4mPMStrDYJpXzbnGSVuEEcoKIq879YQrUTNu1qm3TSgr
	s3rq/t5Pg8X23iSy9h0ORutLD5IwUjMyWibrOmtwdzd0y1XUdjtPV9w==
X-Gm-Gg: AZuq6aJFXvX3noU1AbDsDgpbrD9wFDqpWtAz63Aq8eWniz5tvIhLhNJ4a88A4fcbzUt
	Yl277QE6m4+QzwLzpKAchzVgLS0KHpyRkHsBKPDUG2rtZXAGmDDtL9rbX+5riOpwM3zJ86dbLK1
	IDBuvNb/mLCHKnyFUosW5wAehinNuKTbhl9bwV4DvOpOsVSecFNdOpfLKnUMqJ+acLhMZmNWDsl
	uvjvXxWYtYEJekA9CQ8RfHLnjcmz+Gvsi3sceQU4w6LfZnBBXzLnVQi5ds5d7+BzNmo7XaFp1YW
	DDtXB0M/CNLyPLvRbgGqkSMfN1AUB4tTbY0Ewj5v8mfFGN9kd5q03wV4EH1tcIH0LobdE4qWwwm
	h7yE6LroWvUX3nIrx+fEOEh9vxvN9COzCANTqMJsMfJ3tT8aPu9ZM
X-Received: by 2002:a17:903:2f81:b0:2aa:d605:a314 with SMTP id d9443c01a7336-2ad50b5a413mr16656365ad.4.1771414987867;
        Wed, 18 Feb 2026 03:43:07 -0800 (PST)
X-Received: by 2002:a17:903:2f81:b0:2aa:d605:a314 with SMTP id d9443c01a7336-2ad50b5a413mr16656135ad.4.1771414987404;
        Wed, 18 Feb 2026 03:43:07 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:07 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 07/34] accel/kvm: notify when KVM VM file fd is about to be changed
Date: Wed, 18 Feb 2026 17:12:00 +0530
Message-ID: <20260218114233.266178-8-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71226-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 387C1155F77
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
index b8a0685f7a..47589f92e2 100644
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


