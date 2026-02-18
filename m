Return-Path: <kvm+bounces-71222-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMKCLMmllWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71222-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CCC8155F69
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BFBD3011879
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3E230DEA2;
	Wed, 18 Feb 2026 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8lgr7ry";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYc0MANg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4612DCC1F
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414974; cv=none; b=S973EmfhDKyakeSdaIgprLLG9TYIrgl2YbNuhguiYPc+TO30mITnNlI4ed9IgAyS703ww0LCn4n2VYdCRa0mbmx0/j712Mg+7t7//PDd257ukZdCcQjvgP7AVmdWtyH74RfMBW+edzO5yASQVIPapQJterJ1f4S1nWMOcMELzIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414974; c=relaxed/simple;
	bh=oTcjVgaqLYrAFcHEyYYKxaZLD1+4d1CHz6oLzCUPLZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf38IRenUIKINAHXnGY4eZR1ol0CVVX5q4ZPnc89RSwq3jL7jbUsCLk8HGtxm0uACB4EJyUN25e02PjmIaKi6FntIkhqm5ttW963NqG0gwJ/A+2sj6XHTKd+tNnO7ZDvtfiweif2WVzbe7cMNOkCxk53iXGJfL0e5g/QZ91C9uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8lgr7ry; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EYc0MANg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
	b=C8lgr7ryoWOyBtlOjEmyV7Ha5MIMH2gY2fJkzPTv3I9sCoVoSRYn655ygbC4JhOHeL61Pe
	/Q5ljqrw3vAsqTjsA1KmO60XRqp6219nmtExPp0ph/oN6ja3bZ3n8Y4KIWPYez+uMgcnru
	f2MtCqLoITEEIKuZmc2Y1qk22gnI808=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-lRoZjkljMjuFVLtYyD-vdg-1; Wed, 18 Feb 2026 06:42:50 -0500
X-MC-Unique: lRoZjkljMjuFVLtYyD-vdg-1
X-Mimecast-MFC-AGG-ID: lRoZjkljMjuFVLtYyD-vdg_1771414970
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aad60525deso273710375ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414969; x=1772019769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
        b=EYc0MANgx47eFLvbBiAVHqr+EVkPjIcZCB6KJ4ogyUljcWA/OMcaZtS6VOryXOYFz5
         cL2Au40RgBNMoRuy4jcc2vFUet9xUgcxLnk+3L3iNAfhOpEmEUOFzyvu9Yt6mII95DNe
         i/UEkjakOYOtI9yw12NwECNzE/uio5N0xeJzih3thB9AWwfSxBqH/3nLDNK4DXj7G9bk
         6Sjs7tN+aKBey05jlm+WPbgBauI1mAQVNoov0V+0ueGp2NWnKCqPpOkifPqcWm9jlPbF
         sO4z6kYwWzQcWsro8H2LBU2+aEA+9FSbDjZil8wMqv2RcpS2IX01EFtkj1TQY6oKT2Rb
         TT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414969; x=1772019769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tl/hVXrG5h9KMQqt7EBB/wY/rgh04YPReYpJxV14peY=;
        b=qNRatDYPtfhb6KoUKrA5QGBdaOzdOXda2tNP7sxk3xD1FYvLnP04Ri5omJOjjPOGLL
         XiJP7nFlwnZqJELNn4MREH0UUkqaTDHi1vR4BUbdrL8uLQKaBwHP90zI/SYbmHn9olVn
         Tx7oZWd44RGO1S30YlPRRgelkQK4e91D3YhXGCn79T6w/20H2f5KnHyB7IQ+fKLSFizT
         RCVwaDoWryy8qnxKdfrcdaOrcKyRo6d9YbQunyxClV8MITlFlkU98aAaQO4XqMDFL+Hv
         KJ09K33jeQk8/bKjIk5HWQUyVagLxnKRQqPhJls+Pmvs36fKjODK0v9gUE1pU+TdXWgN
         M+MA==
X-Forwarded-Encrypted: i=1; AJvYcCXPB7fcYxVQdc3VTFx9G8rloRCNdefEG3iW4qwsls/T3Y7wmTqUB4okxdxJN9ZgbRSvBJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQWMqqOUDL+aH1IeULzSRN7RRAi+5oIa0SrfWWH2+a7YrYrZSA
	G1Q8zH1mBbtbJocv1C7/mXvQQT4GuRtXyY7WpZiBWElHRvK7T6RjPU4vHemRv0mr4muuCPwZojj
	P1cXaKr6ylGtdvDdACscWY8qUdIe3e39dULAfn0NIsdCgLh8i7nbFQQ==
X-Gm-Gg: AZuq6aJdOM6OQfXGwnwc7HfidEJxjhek0NjvuA38RXXobsTWMnnulMgTtPuOEyqwJ9u
	/qp8ND9wMg41mi7qs9iW5iRDqmjO8+U5APzt6xMmcvVGkSyq/TbcdbLMDCictRsxXDcTIM/5aZp
	FGoUTi/9AslNJK303zzzTpfodouKmIzdjkYXnfNrDOYKI7dEo4ReN+j2p1ljqg06OYohT8t7CVZ
	88FH/yjkiM5HifriaJUJndzzkuHUW6CSXGBauLWnircpURHSXaqiI15wKZPijz6X+p76FfSJr4k
	vXCE0/ZBgeG2qg3ELpSXWlcKMSwBfzpAQTcRLZnGfPGDm7yytpNIorrvJenTeKkEjUp/GLUXeS5
	Z+IQ/HXcFaZ6a0xPZ/l4bSiK3VTCr1PZnsxJMsJ/tnog+YbAxnqgN
X-Received: by 2002:a17:902:f60b:b0:2a0:bb05:df4f with SMTP id d9443c01a7336-2ab4d053111mr161183705ad.44.1771414969596;
        Wed, 18 Feb 2026 03:42:49 -0800 (PST)
X-Received: by 2002:a17:902:f60b:b0:2a0:bb05:df4f with SMTP id d9443c01a7336-2ab4d053111mr161183605ad.44.1771414969251;
        Wed, 18 Feb 2026 03:42:49 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:42:48 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 01/34] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Wed, 18 Feb 2026 17:11:54 +0530
Message-ID: <20260218114233.266178-2-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71222-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2CCC8155F69
X-Rspamd-Action: no action

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9f1a4d4cbb..6d823a7991 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6278,27 +6278,33 @@ static int kvm_install_msr_filters(KVMState *s)
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr)
 {
-    int i, ret;
+    int i, ret = 0;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
-        if (!msr_handlers[i].msr) {
+        if (msr_handlers[i].msr == msr) {
+            break;
+        } else if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
                 .rdmsr = rdmsr,
                 .wrmsr = wrmsr,
             };
+            break;
+        }
+    }
 
-            ret = kvm_install_msr_filters(s);
-            if (ret) {
-                msr_handlers[i] = (KVMMSRHandlers) { };
-                return ret;
-            }
+    if (i == ARRAY_SIZE(msr_handlers)) {
+        ret = -EINVAL;
+        goto end;
+    }
 
-            return 0;
-        }
+    ret = kvm_install_msr_filters(s);
+    if (ret) {
+        msr_handlers[i] = (KVMMSRHandlers) { };
     }
 
-    return -EINVAL;
+ end:
+    return ret;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.42.0


