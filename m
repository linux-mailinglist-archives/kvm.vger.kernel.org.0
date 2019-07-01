Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E99558A5
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 22:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFYUUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 16:20:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40794 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfFYUUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 16:20:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so52856pla.7
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 13:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7fwJGVjI/vYaJLYXwrnnh/5smhE6omSuLsZz2GjewYc=;
        b=UIVMOZDZllitrNVQNJXbnUbX0Sn/yP/3KWo4bMwe2dE9H2TdWkzcpj3VH1gCx5ZJnS
         9/qKZgBWJbzUQpiRI/V2qNjaLFDDcvidjo8fSe3cdAV0clpvq6gL1sRgBDZWpA1SYkS7
         eqkswg9a6Tbmcd1EEwdBGtvQv2LDNmi+WtWLh9gE6m9cYZ37ZgcVedOlzMxaBjgRq6oc
         m93TB62xctZovHQfOha+gqEA1iA29BFzqUvc89ZjKmcvDRLWxVg8EWYt5Lz8R+7BgSw5
         CqBV9nbPUKieavUGDASKipNSL7Pjg6k5NCGliEgQNakT1slCwthNtApY6LfPe7pIw5QO
         3+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7fwJGVjI/vYaJLYXwrnnh/5smhE6omSuLsZz2GjewYc=;
        b=SofJfHtqXgPZeJj9XlHikfUy7qeMpwVe7+DZEUn32Z/WuF0HGj8OFIanOzdtN0axGq
         WhiMNhODGbsKac814uADGz3D+PC9Od4DxMtvZayDl22R/InASzPmtE1Z6adXDB4CBO+o
         cBkdERXQMcF7Zbi0eJuJIxGGT+m/lUI40x09UM/c+yeQLv4HPXzw84ihWlFkq6XGjDOW
         f1sfmY5MOD+rGm61V0VT1hsz/6/0jDWLq6HI4HanEm+ETP9CsPa2v8LyZ8USlyM8YS8m
         nfCM3Pz9TRkbVVUlch3nAyACVD3JUmRMA9g1xrFwng9DOj1sQ0EiMmvwMnR41JvjauAh
         C+Sg==
X-Gm-Message-State: APjAAAWBx/7tzW+rc53nHxbwaT62m31NwWtmBfmRC+aizsMuI4kFy6ht
        jWbKFBvCwQKpTxG0kezbrL8=
X-Google-Smtp-Source: APXvYqwa3yilVRwP76ruHdF4dwoMIXiEg6X96jGo5ql1FQUuYPCFfP/M9wZ5QxQH/Hq/5/5iOCci5A==
X-Received: by 2002:a17:902:8490:: with SMTP id c16mr605855plo.1.1561494050519;
        Tue, 25 Jun 2019 13:20:50 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id v5sm18622403pgq.66.2019.06.25.13.20.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:20:49 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Memory barrier before setting ICR
Date:   Tue, 25 Jun 2019 05:58:36 -0700
Message-Id: <20190625125836.9149-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The wrmsr that is used in x2apic ICR programming does not behave as a
memory barrier. There is a hidden assumption that it is. Add an explicit
memory barrier for this reason.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/apic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index bc2706e..1514730 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -2,6 +2,7 @@
 #include "apic.h"
 #include "msr.h"
 #include "processor.h"
+#include "asm/barrier.h"
 
 void *g_apic = (void *)0xfee00000;
 void *g_ioapic = (void *)0xfec00000;
@@ -71,6 +72,7 @@ static void x2apic_write(unsigned reg, u32 val)
 
 static void x2apic_icr_write(u32 val, u32 dest)
 {
+    mb();
     asm volatile ("wrmsr" : : "a"(val), "d"(dest),
                   "c"(APIC_BASE_MSR + APIC_ICR/16));
 }
-- 
2.17.1

