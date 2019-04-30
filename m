Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07E51020F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 23:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfD3Vyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 17:54:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42493 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3Vyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 17:54:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id w25so7713748pfi.9
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 14:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lqsgL2SytGowpwpBe7HKKM0V/8HoIpBoZfJDdpLitBg=;
        b=ADCwQCVX7x4AYhc8HZ7gLGX6MUVRBmacAdUqVG/0Fma98AdNGJa653cmaQNnsS68az
         cOQgJgbiAB/jepuMBk6DTpTLuIPSwBDUJTSniex5fzVsQUNjgiTWHeNm0Vco4be9o68u
         a4oaFrdRLmjbuSC0PwgGsdAH8VD/TGg9nxYer8JCCGC2WNz9RWF4Dz8BrZZKjbFQt108
         cSSZN2PLsfenG2C8AxrXyPOl48zQon90JVdF/45QAh5xgx6S1GFqzLFcOaEyrhhftLNr
         wx83Fbm1KvfGgaPd4TMlYEIwsR4WXyK4BEKmM3UuGGxIwVBGiuAx+lyx3lrVL6bzEmlt
         WvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lqsgL2SytGowpwpBe7HKKM0V/8HoIpBoZfJDdpLitBg=;
        b=p1KhEelwqc0An1aA4ArsBS6fQQS4raf11gpmCsVpOMasuE5OSAY5xu9KveV9eKCIb0
         W3ShUd9osqvb3aBh0c/aFTjJjoxUa942FoCIjPzOePRoXGtSyL7kNkO7SHcGgH5vVCYU
         7Kf8c94BoRnp2Pi+Un8kTIvAFsnXJQWo9ohtByzNFieuRIilLRqhNxGlfxRU4t8pfWM3
         cqCjmN8untXxZto//bY9sty+pOWeUsiWVVqGfr+7qEDNnIEId/5p0CB1t7hsu0wN1sV2
         YekuUj6M8znBYsZC8qf190EjurKDhyKswvniGn0xCNwm8MMN6iTFsTaQFfj1vISVUQhX
         2TDg==
X-Gm-Message-State: APjAAAVcX3x6C1+jNWPtLmzWL/Yr7LOr8ifw46BcP9LrwH7Ci2uQvlsH
        NoZcnAFI/Cr/Sy/GdOm5foA=
X-Google-Smtp-Source: APXvYqyFDwCZibhx+iWbctfLpC5++v2qNqDNLO/7JwUrNY/ltNRyJ4HqAimf5MOcs7qRXECw9xat7A==
X-Received: by 2002:a62:1a0d:: with SMTP id a13mr73674656pfa.198.1556661272099;
        Tue, 30 Apr 2019 14:54:32 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id f71sm74231935pfc.109.2019.04.30.14.54.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 14:54:31 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Fix APIC version register test
Date:   Tue, 30 Apr 2019 07:32:42 -0700
Message-Id: <20190430143242.4030-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

The local APIC existance test considers reserved bits (bits [8:15]),
which is not good. In addition, it is best to consider every integrated
APIC version as valid.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/apic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index cfdbef2..21041ec 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -11,11 +11,11 @@
 
 static void test_lapic_existence(void)
 {
-    u32 lvr;
+    u8 version;
 
-    lvr = apic_read(APIC_LVR);
-    printf("apic version: %x\n", lvr);
-    report("apic existence", (u16)lvr == 0x14);
+    version = (u8)apic_read(APIC_LVR);
+    printf("apic version: %x\n", version);
+    report("apic existence", version >= 0x10 && version <= 0x15);
 }
 
 #define TSC_DEADLINE_TIMER_VECTOR 0xef
-- 
2.17.1

