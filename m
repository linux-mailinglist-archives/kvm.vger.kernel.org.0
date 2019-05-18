Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CAD2258B
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfERXWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:22:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46915 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbfERXWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:22:33 -0400
Received: by mail-pl1-f193.google.com with SMTP id r18so4971864pls.13
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WjxX8zAwbhv74gaYcVoc/KxtV/PKEZnjymT0I9JZiFA=;
        b=Xi94euO9fwiwC3IzjOJuSmu9RS/T79vM1y/+jkItMEjWQDedUKmulXbccbNaAJVDI3
         dSxjGBczk1Ze4UAZo/emEtEnABpV9tuEmqjBF+4YjEIy8F1F4S7aFO/u95oZDa7ofQ2g
         CY1VyaG1frJoGvEVqWCZVtvb1HiIsgQGlsMe0TM7i5DZd7MbL9zDdlICy45IzCoDhfHk
         TGN6PL4L2AI1KMob4xpG+5ehzjCk4qKwCTZ/5eM9Qre67q5QSdmMDLBQXhytczo0j6OU
         Fj1blcdJvPbKmW5j/2SFgj1uV4w2BJVEJSZ9DdpA0lX7YbiljhNITuzT9Alu8nfLiHw/
         HX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WjxX8zAwbhv74gaYcVoc/KxtV/PKEZnjymT0I9JZiFA=;
        b=P3RzeefSJjJPrg9DlPU8tgY0oYiqB/EZbKqEVP8Uli1Cj7JXO2+UoYS2ePb7Uimb5e
         smoIfq/asAVlsuxs+u6OBKOUhFz3BZiSLLjliENm/Luq4Xc056piO8dSgUJLQMD+l53Y
         t4BxH8z3rITxtYdFzFedFWBGqK+8n7gfZ2D/F13Sh3HYwt82tt7jNPubOOPLpN8ezQwZ
         d7W0FM3OpkDj4x0/uiWTAQCqUnXN1WMvWpTtAfv4UuCNDFtWqFkj4cZNpFPhlGTGnjed
         tVVSLBW7taosQ4YWCjwH2QrGXHKGjQ0llTYXrMPYpqE2TNxCiClOpLWpIVWQ2udRTqxe
         5bbw==
X-Gm-Message-State: APjAAAW6/nJJ8IKcqH5K38HYNnDFek9fIX0koA/WDzsDXMWRVCX6qHqF
        0olDZC4RbNN5cy7mRfxlxPJImfoJVBw=
X-Google-Smtp-Source: APXvYqx1sgCzKdxjGykuGSvLXd6HPxVX03JpO7BYpF6uCCpcC1GQrvhxCGcyE3jVtqYhNo0Su4rOuA==
X-Received: by 2002:a17:902:b205:: with SMTP id t5mr17936343plr.314.1558221752496;
        Sat, 18 May 2019 16:22:32 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x17sm20496352pgh.47.2019.05.18.16.22.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:22:31 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH v2 2/2] x86: nVMX: Set guest as active after NMI/INTR-window tests
Date:   Sat, 18 May 2019 09:02:31 -0700
Message-Id: <20190518160231.4063-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190518160231.4063-1-nadav.amit@gmail.com>
References: <20190518160231.4063-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running tests which are similar to verify_nmi_window_exit() and
verify_intr_window_exit() on bare-metal suggests that real CPUs do not
wake up. It appears, according to Sean, that the activity state should
not change after NMI/INTR-window.

Remove the offending test and set the activity state to "active" after
each test to prevent the whole test-suite from getting stuck.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f921286..1092fad 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7060,9 +7060,7 @@ static void verify_nmi_window_exit(u64 rip)
 	       exit_reason == VMX_NMI_WINDOW, exit_reason);
 	report("RIP (%#lx) is %#lx", vmcs_read(GUEST_RIP) == rip,
 	       vmcs_read(GUEST_RIP), rip);
-	report("Activity state (%ld) is 'ACTIVE'",
-	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
-	       vmcs_read(GUEST_ACTV_STATE));
+	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 }
 
 static void vmx_nmi_window_test(void)
@@ -7196,9 +7194,7 @@ static void verify_intr_window_exit(u64 rip)
 	       exit_reason == VMX_INTR_WINDOW, exit_reason);
 	report("RIP (%#lx) is %#lx", vmcs_read(GUEST_RIP) == rip,
 	       vmcs_read(GUEST_RIP), rip);
-	report("Activity state (%ld) is 'ACTIVE'",
-	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
-	       vmcs_read(GUEST_ACTV_STATE));
+	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 }
 
 static void vmx_intr_window_test(void)
-- 
2.17.1

