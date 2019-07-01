Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3790F101D1
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 23:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfD3VbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 17:31:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33615 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3VbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 17:31:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id z28so2397562pfk.0
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 14:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lzdC3PAF+ZIqCxXoKrUHIuggauok8E1eEYLCvrw/QZU=;
        b=vIkjqPa6gP33u5/DJboq+5iy+kNxSCADS8n2IyyghsGLU0HfGGIRqSAlHmYr1DJ2j4
         TVMWX0qSngov/LoARBwF30o12qGE6JARo4Xoe+hNjn0zFk1YCac9nmVbAutU/PNO0pNJ
         sEkg9TdN3MlYRWuFxPFKA/LB1MFpK4LTiA2sjhkGihm+vufN9pTRiaNtKQrw27tp+h0f
         1YrgrDCJxABXDHFb7NGe1tp80XZFRwYZNIPXnBOPq8QfhRqndvztXcVFIHDtTvTm7Fgd
         KgRkvj7hHNv33PIIXbFUEKeEi5tHXG35a0cjtKoBOG/gsZI20o8DvgEgSSarlJORj5uJ
         c5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lzdC3PAF+ZIqCxXoKrUHIuggauok8E1eEYLCvrw/QZU=;
        b=Le/hFdGpxo2b2Tk7UWsYPcW6bPqDXPCQw+reI6vE1RL2j3r9pwyRhOwq5g9BM56u/R
         TAwd8iX5szIwng4G16WUWrzm6BQi3NqQ+DQ3AIT7TX+dUl2jhol9JNuq2o/aKWzMUTrO
         G1sCKT+4oW1/9ZPNdrZ/pwSorKjRYvQpQBXwk8pa4ThwNb6d0bj15RVz6e7YsQ9zD0Kl
         MxHiGjGTLmGfZ+uZvjbcj+dK5ss9ZoSo8oxijvW2T70zWLDQzJM1fkSvGkDNJRA+FGVy
         coMjDvGfq6ZmPVPRWdnZMVEp6p1TzVdd2wZxiE7rlqgBTYbQAbTavu4kPZRiB9iRNrjl
         1kHg==
X-Gm-Message-State: APjAAAXQA0wjbOof/lr/d349tk6mnQpX0Qc1w1+E3/ImHWvoUcOhQmTu
        8ULK40uxH+z/BBTZZNrKU2o=
X-Google-Smtp-Source: APXvYqyAZS6W6En2s7dnNrzHc/YGsftqUtgZ8G6q7JoGy3uz66LQuvxBoA7yu89PVFgrgzgfafZPSA==
X-Received: by 2002:a63:db55:: with SMTP id x21mr18928535pgi.219.1556659877337;
        Tue, 30 Apr 2019 14:31:17 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id b9sm45606779pfd.32.2019.04.30.14.31.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 14:31:16 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Change ALTERNATE_APIC_BASE to saner value
Date:   Tue, 30 Apr 2019 07:09:26 -0700
Message-Id: <20190430140926.3204-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to the SDM, during initialization, the BSP "Switches to
protected mode and ensures that the APIC address space is mapped to the
strong uncacheable (UC) memory type." This requirement is not followed
when the tests that relocate the APIC.

Use the TPM base address for the alternate local-APIC base, as it is
expected to be set as uncacheable by the BIOS.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/apic.c b/x86/apic.c
index de4a181..173b8b1 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -159,7 +159,7 @@ static void test_apic_disable(void)
     report_prefix_pop();
 }
 
-#define ALTERNATE_APIC_BASE	0x42000000
+#define ALTERNATE_APIC_BASE	0xfed40000
 
 static void test_apicbase(void)
 {
-- 
2.17.1

