Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC5496830
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiAUXTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiAUXTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:09 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D5AC06173D
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:09 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y2-20020aa78042000000b004c5f182c0b4so4694041pfm.14
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hlvb/hx2BUH2uE3lUoLe079bNUxBjtgrXcPfnAdXjKk=;
        b=mS2tF/ffGYv023FrdG2qeDm9il/WIl4kUuCj0eIvX881qShcxdEU/831Na5UR/zq61
         /5eFsSvWNea3aB9NmMSFuWwyL1ImcbNxn4wmjVoCJ6ae0dqgoWtoq28dA8TBBmSGZp0n
         hY2tdZ6dB7aKjmlXrwXc+jRXDbY6+VUqjJZ/+jQOOlhTxSBDNqMF4vyaQx9MuA1qQCCy
         ykTscfJaO8mUBYTiPiNrClKRqpqXw9smh5DMbW0Awtz9Pk7WyM8GT86csntpu41CNJ9b
         q388mXWwVzzabRbQQm/urOD/GWUhowN81V+VD312hOZ04BEP50KE/p7+m18i3Ui71Cf2
         Q8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hlvb/hx2BUH2uE3lUoLe079bNUxBjtgrXcPfnAdXjKk=;
        b=0zjaoQR5oFDHWJEghUzPwb7PPy3iXGTwStlwuEICvvEf4XlXhP0tqh9IMO3UeCTzlX
         t8mt3ZACwlfh/AICyQBB4atwSYcT58xp5ZvDOhEyP+AmWKiHiPtQ+z4VBDkrav/qAbhd
         YGTORg+SmKiI7OrICn2Bq68KXU/NEk8nzBdPhv3r1mfa9IvmGIFClp2P8IwVo2E31P9x
         WJXn/qOJFW/F10uDmUpO+a4XYGLGTIF3il8yo0T7fONggwP8Wvidab5GT8YTq2jDkY33
         FPXWXid7iG7Z/p+4wtIKL3Q7FVtcUw+jJa7w+eZWs9sPaxdSQDxnUTDbSg7/DSiwa0xA
         QVLw==
X-Gm-Message-State: AOAM532LuNHEQp/8jOYy4Nkp4FrhGUoKyK8IexRL6pcrSdc2sdL9pH6I
        F/jjYwEwolGZ2mUEPcbgqWxph9mP2dw=
X-Google-Smtp-Source: ABdhPJwV5wKd7cj5FCBT5lpH94XsDi6FPlMuY/6PtLxIKqRFaaygQt0HwnqZlEmp4aTMy0ObmOXCr1iFbfU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8ec7:b0:149:8d21:3e49 with SMTP id
 x7-20020a1709028ec700b001498d213e49mr5531777plo.111.1642807149040; Fri, 21
 Jan 2022 15:19:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:52 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 8/8] x86: apic: Make xAPIC and I/O APIC
 pointers static
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the pointers to the xAPIC and I/O APIC static as there are no users
outside of apic.c.  Opportunistically use #defines for the default values
instead of open coding magic numbers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic-defs.h | 3 ++-
 lib/x86/apic.c      | 6 ++++--
 lib/x86/apic.h      | 3 ---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index dabefe78..4db73da2 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -14,8 +14,9 @@
  * Alan Cox <Alan.Cox@linux.org>, 1995.
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
+#define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
+#define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
-#define	APIC_DEFAULT_PHYS_BASE	0xfee00000
 #define APIC_BSP		(1UL << 8)
 #define APIC_EXTD		(1UL << 10)
 #define APIC_EN			(1UL << 11)
diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index d7137b61..5d4c7766 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -5,8 +5,10 @@
 #include "smp.h"
 #include "asm/barrier.h"
 
-void *g_apic = (void *)0xfee00000;
-void *g_ioapic = (void *)0xfec00000;
+/* xAPIC and I/O APIC are identify mapped, and never relocated. */
+static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
+static void *g_ioapic = (void *)IO_APIC_DEFAULT_PHYS_BASE;
+
 u8 id_map[MAX_TEST_CPUS];
 
 struct apic_ops {
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 7844324b..6d27f047 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -6,9 +6,6 @@
 
 extern u8 id_map[MAX_TEST_CPUS];
 
-extern void *g_apic;
-extern void *g_ioapic;
-
 typedef struct {
     uint8_t vector;
     uint8_t delivery_mode:3;
-- 
2.35.0.rc0.227.g00780c9af4-goog

