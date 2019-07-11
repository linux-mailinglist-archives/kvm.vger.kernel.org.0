Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A8B65252
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 09:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfGKHSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 03:18:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44041 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfGKHSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 03:18:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so2304288pfe.11
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 00:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0foxq1y5HVVtZLVQcGdouXtAi++b5VUOD3c8UM49834=;
        b=b0fRcvCl9km/LBorhVXuwdB8raoHYyH0opOFGTyv0ZuORdyO5PxkEE9nvlF5hQpFRX
         4vdlIYZwVqfAD5rRb2SMwKHcS3Bcy/Q8CzCczAEoB0mXYPr8/Yve39P0bO9WUfhIp8AM
         dDV3ev0wSeXNWxQaNxBaNE8msE0m1CoDQdi40xUL459TdtC8jQKlDqZFFwr1ecN1EpNX
         egVRPxvpuv+fLEGawstaN7vGTR2gjRECgowQSii002feaQTqzmwNifSSUoaodkEjlAg9
         W95D2w4LzZEaX+PBqOhDp2K/3kEJnQigVUp9FurH8So09/oM7Gp1QdfE1CbFiQSj/CcW
         4wVg==
X-Gm-Message-State: APjAAAUCBECLNxKTopM01C1LcxFZ0TziEVguo1o7JFL6wPjvOCDQsB0V
        ls7cyzAWatdOW1fKUHSFNQBJBU7Dm2M=
X-Google-Smtp-Source: APXvYqw4JFodAkATo2K+PdGjRGUg3VogvI2b2sakcQvQ+PayNJwBDcsbDWCwSZD38bISLcZ5t+aMcA==
X-Received: by 2002:a17:90a:c596:: with SMTP id l22mr3171881pjt.46.1562829487246;
        Thu, 11 Jul 2019 00:18:07 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u23sm4874594pfn.140.2019.07.11.00.18.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 00:18:06 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] tscdeadline_latency: Check condition first before loop
Date:   Thu, 11 Jul 2019 15:17:56 +0800
Message-Id: <20190711071756.2784-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes a tscdeadline_latency hang when specifying a very
small breakmax value.  It's easily reproduced on my host with
parameters like "200000 10000 10" (set breakmax to 10 TSC clocks).

The problem is test_tsc_deadline_timer() can be very slow because
we've got printf() in there.  So when reach the main loop we might
have already triggered the IRQ handler for multiple times and we might
have triggered the hitmax condition which will turn IRQ off.  Then
with no IRQ that first HLT instruction can last forever.

Fix this by simply checking the condition first in the loop.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 x86/tscdeadline_latency.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 0617a1b..4ee5917 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -118,9 +118,9 @@ int main(int argc, char **argv)
     test_tsc_deadline_timer();
     irq_enable();
 
-    do {
+    /* The condition might have triggered already, so check before HLT. */
+    while (!hitmax && table_idx < size)
         asm volatile("hlt");
-    } while (!hitmax && table_idx < size);
 
     for (i = 0; i < table_idx; i++) {
         if (hitmax && i == table_idx-1)
-- 
2.21.0

