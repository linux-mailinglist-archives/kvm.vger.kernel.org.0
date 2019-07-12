Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529CD6646E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfGLC2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:28:41 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43113 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbfGLC2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:28:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so3985459plb.10
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 19:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Shs1mPjCZ9q2Cf9BC1SlIhJhmVvlv0+gzbQGhV8nv4=;
        b=Gci8ZBBYe+iWxKvaGLrUKLQhe9scq2Yq1PFwqfJIRZShtOqiJiZLFibetNwDDFi3OR
         7u73wCTdQP+1kdEHptrBn+CRRCDXZnwMPpTInediebbZPm03sCMMn3O+3Mw0hiWVlb0R
         6E0PmlQdQpGxrq5unZwMkjVgcv/0T4eJGfNVZgdUw5CgI+/DPFXEHpBE4TRrWfbR9PAK
         5wOHqMQX+8E1dw6rQ7iYfB9NRbnyNMalv5myiy4i9BXElu6EsEIhEldmEleIkcq8v0ju
         F2pHP/tGrc89T07ONGysrwUN27I/Q3YWeJbhdjFpyzK3WVu1pkROsccKFtUceGkaNQ1w
         /pOw==
X-Gm-Message-State: APjAAAV3RyGlaR6mQSo8GL4yTHKzQTPr63esQ5+ZKqQAaYAqDLbr9q7h
        P+fmlISnWiH/89X8yEIbJhQPwBZMF+EtQA==
X-Google-Smtp-Source: APXvYqwhA4da0Y/lhyRt4NCloh5qj6TBSTxTIpUqG9pc2JP32ljyo5Q4NDS6hKe1Zbb85KlCL0/0qw==
X-Received: by 2002:a17:902:2be6:: with SMTP id l93mr8488822plb.0.1562898519799;
        Thu, 11 Jul 2019 19:28:39 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm7389259pje.17.2019.07.11.19.28.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 19:28:39 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, peterx@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [kvm-unit-tests PATCH v2 1/3] tscdeadline_latency: Check condition first before loop
Date:   Fri, 12 Jul 2019 10:28:23 +0800
Message-Id: <20190712022825.1366-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712022825.1366-1-peterx@redhat.com>
References: <20190712022825.1366-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes a tscdeadline_latency hang when specifying a very
small breakmax value.  It's easily reproduced on my host when set
breakmax to e.g. 10 TSC clocks.

The problem is test_tsc_deadline_timer() can be very slow because
we've got printf() in there.  So when reach the main loop we might
have already triggered the IRQ handler for multiple times and we might
have triggered the hitmax condition which will turn IRQ off.  Then
with no IRQ that first HLT instruction can last forever.

Fix this by don't enable irq and use safe_halt() as suggested by Sean
Christopherson.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 x86/tscdeadline_latency.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 0617a1b..3ad2950 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -70,8 +70,6 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
 static void start_tsc_deadline_timer(void)
 {
     handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
-    irq_enable();
-
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
     asm volatile ("nop");
 }
@@ -116,10 +114,9 @@ int main(int argc, char **argv)
     breakmax = argc <= 3 ? 0 : atol(argv[3]);
     printf("breakmax=%d\n", breakmax);
     test_tsc_deadline_timer();
-    irq_enable();
 
     do {
-        asm volatile("hlt");
+        safe_halt();
     } while (!hitmax && table_idx < size);
 
     for (i = 0; i < table_idx; i++) {
-- 
2.21.0

