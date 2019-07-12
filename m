Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC1166470
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfGLC2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:28:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42493 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbfGLC2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:28:47 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so3808721pgb.9
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 19:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFN7IARNf/dh9h3GTyQlVk7K9Z+EtPM855+7HZjT3Oc=;
        b=OLKvXfdw9tSqtmd+pQljPQr9CKk43E0zGGXRRKMgJz1e3wK/0VrtXAD4rCU08oye8P
         j67zzzp/V49nUdnQqjJc+MN7I6Ag3KXVEqizi0ncf0Yz9DZXOuRRnVKv9NXN29Qynnkf
         5yuC0btwfalLvPpU27znD+M2wpdUsjq3zzsdP02BMFpKscxOLSM+R+EHInGMX0jppOEt
         pf75Idjz2aLMAQJyjMQaLs5+0NcA4dxjfHeOMm/kSo9Wdt8Jk5XuadY1QMa6kVcB2mvT
         tleIyGL2GY9ApL75o8suJTKyeLAoP+bdG21w9uNXsOPxWqG0vYD31nDKWT61qZB42/Vo
         4NtA==
X-Gm-Message-State: APjAAAVQnOZV0T09cuDc8wOOjoxI5bN0j3O1REOFB0k7M9KxsXA5yIKc
        Wd3KxjGB2YHQ6KOSnkmHkuDxtmpbZgOlWw==
X-Google-Smtp-Source: APXvYqygaxpxWjhPdVksaAv3LG4n8/WiRRkQJp+HSmKUI14J8m8IDfn2bajnPkr84EDoIssyPfMPCA==
X-Received: by 2002:a65:4841:: with SMTP id i1mr7833657pgs.316.1562898526157;
        Thu, 11 Jul 2019 19:28:46 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm7389259pje.17.2019.07.11.19.28.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 19:28:45 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, peterx@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [kvm-unit-tests PATCH v2 3/3] tscdeadline_latency: Stop timer when reach max loop
Date:   Fri, 12 Jul 2019 10:28:25 +0800
Message-Id: <20190712022825.1366-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712022825.1366-1-peterx@redhat.com>
References: <20190712022825.1366-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes another possible hang of this test when delay is configured
too small (e.g., 2000) so that the IRQ handler will trigger forever.

Let's stop the timer if we've collected enough data so that the
program can quit always.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 x86/tscdeadline_latency.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 0a3532d..a63f98b 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -50,18 +50,24 @@ int breakmax = 0;
 
 static void tsc_deadline_timer_isr(isr_regs_t *regs)
 {
-    u64 now = rdtsc();
+    u64 now = rdtsc(), delay;
     ++tdt_count;
 
-    if (table_idx < TABLE_SIZE && tdt_count > 1)
-        table[table_idx++] = now - exptime;
+    if (tdt_count == 1)
+        /* Skip the 1st IRQ */
+        goto setup_next;
 
-    if (breakmax && tdt_count > 1 && (now - exptime) > breakmax) {
-        hitmax = 1;
+    table[table_idx++] = delay = now - exptime;
+
+    /* Stop if either we finished collection or hit max */
+    if ((breakmax && delay > breakmax) || table_idx >= TABLE_SIZE) {
+        if (breakmax)
+            hitmax = 1;
         apic_write(APIC_EOI, 0);
         return;
     }
 
+setup_next:
     exptime = now+delta;
     wrmsr(MSR_IA32_TSCDEADLINE, now+delta);
     apic_write(APIC_EOI, 0);
-- 
2.21.0

