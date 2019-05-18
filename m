Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DC22583
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfERXIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:08:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37981 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfERXIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:08:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id j26so4979214pgl.5
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O4jvqY5GMlxrT+RDmPkvTjgYqGbP78fuvh9eef0f20w=;
        b=FfJWS2il1ND5ydPTR5Awgtyd1LqRKIVD2PuSZ9hbf9XIpDBYnEy7E1hoo4DjKYNlJI
         ng25ysurRI5TqGmiy1IAmxC3sj0rGrcomHFAX6vqrcIr9Jlbi6YBSfUVGiLxymU3TSR3
         0cuWoFP9ualTY8Arig+htPD1c4kM37vDBxPmCPVWd+Ea14eP1m/lItpdXp94U0RFMmUz
         fX2nK4gZ65s09LAHE93Dzu2hZcoxZKJ6XcRkNEVtae2+NRItKXnvIeDXeyzoTab8fI1r
         xq/EclLj6Lf51Gj9ZL9VUhzJHJIZWrqyuVxQqQW4ABiHkkRwYxabYwhfPsjUkH6izrDh
         Ygxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O4jvqY5GMlxrT+RDmPkvTjgYqGbP78fuvh9eef0f20w=;
        b=hXEnZ+pwMBVgFYBiAh63wkwSSc0x/zCRlW23aCY0uYrjy8m9gQX13kKKIiAiKx/8ee
         E4qYsCTS8Vnoq16/bRN1b/iVH+vrg/iAvV0NbL6NkoG+3s5ElKyLwp5mC7YZeZHePb6m
         +ovbkznTX7vJ8vL+EmQIoCT96w0QDQ5tzGHVQJh7wWnRXQPj7iyLXIcy8cYURgxp4Vke
         6n2+iRNvDRaFvq3zzVY2T7S1s6hf6nixiTZP0OJjM7zg6Ita9RFrv+GjB3eGWf62Wg9D
         Pi4MIWAnW/jqc/TEz79XbRTZkaOPCZqvOmxGk3AxJLXu+YXF3HZ/BKlyzcKHT87mAA+K
         b9NQ==
X-Gm-Message-State: APjAAAXW+a4KGpvXgQLfRVpO55/dxkmN4lKJrAH5INzF6b6pC94YWYbR
        PlkDDp9TwVOcTO0SG4/qpgyW7BTd1xk=
X-Google-Smtp-Source: APXvYqwkJ5h1ETanHxNS6ZI4wKxhWkIHK0IS9jfSzZCNll9xSD0uGrOnQlRJOkV4VFu2o5vi+RakRg==
X-Received: by 2002:aa7:8493:: with SMTP id u19mr70197951pfn.233.1558220931063;
        Sat, 18 May 2019 16:08:51 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id 79sm24255346pfz.144.2019.05.18.16.08.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:08:50 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH v2] x86: Set "APIC Software Enable" after APIC reset
Date:   Sat, 18 May 2019 08:48:55 -0700
Message-Id: <20190518154855.3604-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the APIC is reset, some of its registers might be reset. As the
SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization to
the APIC may be lost and the APIC may return to the state described in
Section 10.4.7.1". The SDM also says that after APIC reset "the
spurious-interrupt vector register is initialized to 000000FFH". This
means that after the APIC is reset it needs to be software-enabled
through the SPIV.

This is done one occasion, but there are other occasions that do not
software-enable the APIC after reset (e.g., __test_apic_id() and main()
in vmx.c). Reenable software-enable APIC in these cases.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

---

v1->v2: Change 0xf0 to APIC_SPIV in one occasion [Krish]
---
 lib/x86/apic.c | 3 ++-
 x86/apic.c     | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 2aeffbd..d4528bd 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -161,6 +161,7 @@ void reset_apic(void)
 {
     disable_apic();
     wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
+    apic_write(APIC_SPIV, 0x1ff);
 }
 
 u32 ioapic_read_reg(unsigned reg)
@@ -219,7 +220,7 @@ void set_irq_line(unsigned line, int val)
 void enable_apic(void)
 {
     printf("enabling apic\n");
-    xapic_write(0xf0, 0x1ff); /* spurious vector register */
+    xapic_write(APIC_SPIV, 0x1ff);
 }
 
 void mask_pic_interrupts(void)
diff --git a/x86/apic.c b/x86/apic.c
index 3eff588..7ef4a27 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -148,7 +148,6 @@ static void test_apic_disable(void)
     verify_disabled_apic_mmio();
 
     reset_apic();
-    apic_write(APIC_SPIV, 0x1ff);
     report("Local apic enabled in xAPIC mode",
 	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
     report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));
-- 
2.17.1

