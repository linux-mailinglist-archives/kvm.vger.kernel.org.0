Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8717F53
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfEHRrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:47:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46302 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEHRrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:47:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id y11so376785pfm.13
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c8UNygLBqbuxTHtNnAkZZpldUtji1ooOZFn9hGJjKHw=;
        b=S0NWK4Djq4kBt28IgPOaqBaho/ctZ52vbx8hocuwleH2soe8ZyBLOWlVxXuYvB9aSU
         tcLOc1DMIFk36vcjJo1Ycf44tYXjZvVBkXagVcekZFYh9m2CHuTNFrCjrknS2G5C5WAx
         BnacxW5TGHqCUC8OKXkxuxlTwmyKdXW8AfS4XpXiwlk2YHK4FTzBfKJ40Xg5mbFsHL87
         JdvvjOd2BjSrWBAYtsJOftDHk0L6Dr34GCdWCUXupQCRzxp9A7BQvVjTFBt9oQMi5Osj
         F7rO2idiHJT7YoOQrpCdfefhJ9w9OOtn5D4V0lElsMwnjHsHUAOZK/0Vq2OcwFhHSWX5
         MVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c8UNygLBqbuxTHtNnAkZZpldUtji1ooOZFn9hGJjKHw=;
        b=sLVzE2CkZPj5jUbbjK7lSir5yVui7Gp/CxXMYV9YVRSRV0xuHmz86WLvKof+Hbyd5c
         BXj954XvwroJcmVyIcugcC2KMUzkj4ruCAgJlm86zJ43P1SG53/elbWuqELTq8XGbW/b
         MEJjpKcPoD2e0x0WGYM5fDIvVCX44Oc981ugw8J5ia7bbc1TVtsBPAy0Sp1ftfz8QPXQ
         vDBFQmN2wpGNUgiTXiYZ1z/crpZwu8rB3c8BM5ij6q1HpAzoUlVd401A0h8dZRSUgb2p
         ViV3jFcw2U9w6jpeiEXHu9Q45NAxfJ0VxCciFp9Rhg9C7iGjnGWkY1fne9iO9WKYje0+
         E2ag==
X-Gm-Message-State: APjAAAW3AjSrN9OHcUQ1U5XgxTEwHaKa3ZGNVgm8LZkoZDuJwzFMTotq
        GAlk98lEXq3r3m3Ro94opCk=
X-Google-Smtp-Source: APXvYqzSrfKZxI0MNBT1yFtqIZx7Dd1TVYsHILklTwQigWtPZAQ2jqntrTP13PBVUF++2EV5kqSlcg==
X-Received: by 2002:a62:2e46:: with SMTP id u67mr10496111pfu.206.1557337661203;
        Wed, 08 May 2019 10:47:41 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id q14sm10097189pgg.10.2019.05.08.10.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 10:47:40 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after NMI/INTR-window tests
Date:   Wed,  8 May 2019 03:27:15 -0700
Message-Id: <20190508102715.685-3-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508102715.685-1-namit@vmware.com>
References: <20190508102715.685-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
events wake the logical processor if it just entered the HLT state
because of a VM entry." A similar statement is told about NMI-window
exiting.

However, running tests which are similar to verify_nmi_window_exit() and
verify_intr_window_exit() on bare-metal suggests that real CPUs do not
wake up. Until someone figures what the correct behavior is, just reset
the activity state to "active" after each test to prevent the whole
test-suite from getting stuck.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f921286..2d6b12d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7063,6 +7063,7 @@ static void verify_nmi_window_exit(u64 rip)
 	report("Activity state (%ld) is 'ACTIVE'",
 	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
 	       vmcs_read(GUEST_ACTV_STATE));
+	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 }
 
 static void vmx_nmi_window_test(void)
@@ -7199,6 +7200,7 @@ static void verify_intr_window_exit(u64 rip)
 	report("Activity state (%ld) is 'ACTIVE'",
 	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
 	       vmcs_read(GUEST_ACTV_STATE));
+	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 }
 
 static void vmx_intr_window_test(void)
-- 
2.17.1

