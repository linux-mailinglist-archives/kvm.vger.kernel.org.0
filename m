Return-Path: <kvm+bounces-65827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB29CB9073
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 016B83086950
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4022027979A;
	Fri, 12 Dec 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ji+HjAkf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sOF95aNe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74234285CB3
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551875; cv=none; b=ZAvtkpU9p9BLtia2P04LiKK0AhBLQZxp1XgL/z43YBYHh1p6pLAKKaHfQ8hRanYWn3eLwxrCmE3PkTmoeMFWJwqlvgeJWGR7K6k7w8kp5oIfIA7aZIgpcZ78Bl29wQtIi7QPSTFdsrFb9s3wZRz0AoxC3aqSuTYtVcksY9qWshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551875; c=relaxed/simple;
	bh=VB0ZpopcFUn7yJ690lRvNWdOpDXVVwAgkiwYBpSleUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+yfGMtN6OtcDA67MBL58VrhvEuBQMubBuA92k+y4Pydg+6uR9woI9czE69z7eo+nYL6Xnaz/qxBU4+U7dHxmc5iP4SKaVXh9teeCSebbcjH6K5lOgJ1ZAheE/PsZzT+SAAjESIRc0A+HBaRWHt6xytSZJVnd9bh+CPRK3kqvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ji+HjAkf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sOF95aNe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d+6NaZj6uCcfjgVjpMn6N6VF0Wu9Lu6jAdnQUGrVPW0=;
	b=Ji+HjAkf2TbFllsvAN1fy1HrMFlNxxRMdeoDQ8rQnZH8QsG33jPNGjnuy38db8WU6id9qT
	UKmJMVfRwddkDlVTDHc/DX6QUdiB9kXjv8J0+TKSjs3/nhBOJjC1QiLWgs+YW+SqxZ5yzl
	StseLyjj9gqt10jWWgjx9lZPZpWS4Us=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-5lKeoj__NemLjpb4TdbQZQ-1; Fri, 12 Dec 2025 10:04:27 -0500
X-MC-Unique: 5lKeoj__NemLjpb4TdbQZQ-1
X-Mimecast-MFC-AGG-ID: 5lKeoj__NemLjpb4TdbQZQ_1765551866
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2982b47ce35so15027685ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551866; x=1766156666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+6NaZj6uCcfjgVjpMn6N6VF0Wu9Lu6jAdnQUGrVPW0=;
        b=sOF95aNesvBL2IlhX0kZ5yy6tWjAPhSlAg7bg9zrgOwn7AmaI8FUjzy3/ZaIxIzWM/
         oEQf7s5Hs7mv/vYJD1cXpHIp1h80k9+UUcIGwq/jXPxLC688tEz3JOKChZsXMh8tCpaH
         ZKsWi68ZGGJJny2tD+3wghfUIj3O8gkw+oR1feq3Toc9u0SVv5lOp1kRiIyxi3rOcx+Q
         s3ATQG0sxrk0BCeSxEYPrT+PFh40R+gnSwSJv467B5y7oZM0mmP7buAaewXYh4VihO0j
         5Vsc9eWRFyPtjGMWMs7nGnjUS0HGNVYE2L9iB5cNxvUTlC5zJA+nDA4R0Wz0QMFvIubW
         3v5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551866; x=1766156666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d+6NaZj6uCcfjgVjpMn6N6VF0Wu9Lu6jAdnQUGrVPW0=;
        b=hmlt3RVhK9yDBGWcuVjMS05TA4aI0s2PduGOcL38E61HsUAymOTePgCoqpuPFtfqs0
         fnYwJHLwcy0+R/l+1eRioPf7yoHb3M3kfImf5+TUim6PxYWDNKfzoLBummj3jIGoGNYd
         eZU6fBGyVJLTTwzLtiHMARDs/RJ9v1Z0Y8A74egE7qN/WfL+j1ZaxjwocOu05hHK8gZA
         zQCnqtZuA26NpBoSlkB8XEbOpeNLq+neUGIgGPgzRE1prGlr/sJYlDy/JYcb6QMjniBN
         6LrPs/uLjQ6EFS6g6wbIwFfmouuvx1O7Rqrj9gjRbQY1A3xghJW9zXH2av0MESA/jZVW
         ZnTw==
X-Forwarded-Encrypted: i=1; AJvYcCUrp/ptEND062BR3/dqud+ML0G3kc41piDKZYKOIoB0sXURJHt0VR5r0ffArK0epgOpvzU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx969oSzsj+I84kaai9qBqL0DBAfNhGWY0YjeBW3xhKXO3tn9xF
	SGvuj80UwHKggSUj8o3u9GRuvcrzr7lN4ngKPH3TIozin1ccgfnPUuEaR0GFbSXkGBKGDq+Aunt
	iDy2rDZ9KMIY2vBJGQ/uahYRb+LUtasP3x3OU0ojHX54sZ/fBiBYDxg==
X-Gm-Gg: AY/fxX5fuuWVivzvk4di1m/GntyN4aoCC326lT5nHECIbV26Bp1tIORpInVxo9f0Ld7
	pO2NAMyGcnvEndQacBnwLh2RT+rjSCD89Uy6LHk5gCcgFImiQ+IT6bgF/RVRyJNXIEVlvqgVkH/
	/o3xJcz7GqvrdxiWx5KUDA5cxwvG+u/V+qAEmKczsi6qcWdvHq7w2HnDb5Q4ADeMkK5AA2Bz0tA
	HP706PaSicd55NdYhWsnKaoTTZGGXKfmL9xiDYM72s9yX2K3yT6LTqwBe2iWRDwPcgbMG2NArty
	k4IEPfP2or9Dta5OBeWCCD2lmPVELR1skdyBbuE7ZesvYQ6feHyZ/3xofxf68ptfEVi34s1twWP
	Nv1ydaVT1jGWv83UTZUJ/x/3+lM9MD+KkdBCMM+PAjn0=
X-Received: by 2002:a17:903:1251:b0:294:f6e2:cea1 with SMTP id d9443c01a7336-29f2403ae65mr20162725ad.38.1765551866239;
        Fri, 12 Dec 2025 07:04:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEV1fQTYZ+clwq9ydcPTOFwaYkLMqAp/AA+rJcxVTgTzUunLMGJFAylqzmwqrNF009OwJdo4g==
X-Received: by 2002:a17:903:1251:b0:294:f6e2:cea1 with SMTP id d9443c01a7336-29f2403ae65mr20162125ad.38.1765551865342;
        Fri, 12 Dec 2025 07:04:25 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:25 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 01/28] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Fri, 12 Dec 2025 20:33:29 +0530
Message-ID: <20251212150359.548787-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 60c7981138..02819de625 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5925,27 +5925,33 @@ static int kvm_install_msr_filters(KVMState *s)
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


