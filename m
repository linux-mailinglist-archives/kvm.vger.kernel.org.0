Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873F6248FFD
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHRVQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgHRVQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F10C061343
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a75so18791602ybg.15
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=b4vn5hNHUerT2xKdUyT8CXu21Ulffh3/T3hLwB4Cqds=;
        b=fGeH8asQD3iWjC1bhYcm5WPGEwZ6QrUnjtq/PM+py12uhYzF0eT8IR5glTz95lyZ4v
         Grk73SYDqq4TMbMx3VKoAD449KN5M3wF0a6dU75XjWmhyDz8YB5kqRhH3n22eIh9h8+Z
         croWCrh36HPr1tL5OO7846dVCepibp7UdDqpS/LP2GM+TRZJ7mxVCZV/KMiEcreN+cwH
         sbq+n7R+Ye6KuxRhzpA9mNoT6mE3W0JsNcl1f0OHXMBpDvQiW8xGn3GEuMFxZSK8aajr
         3M4jJB71Ch4gll0khntB45Om6wm7bakeUd6/xKYK3pqG2FnzTRBm+HyhETGvta8AT+fh
         ed5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=b4vn5hNHUerT2xKdUyT8CXu21Ulffh3/T3hLwB4Cqds=;
        b=tiXvv9m5coQ4hWWHlSKjQ9Fo7MkN2SQcF3SywLV0rsFZxt0gfXpge/Spko/PthWmYR
         JeEiHrGECFknwH4tsEKMyrjdJibrog2XYRPe3LmRnVBEKEcSNhW5GMGS1l5Ty87NMNzZ
         O+ujT8CKogHq2Lt6LGv0chxHh7cUCa076EWghskQMpYOxmCuI+7aA5PleaGtp5Y4pkxe
         /YqCgSoaBNS6Cnk6aVoimqpsc80rRUb9oUbDDAp9vbZAoQATddGzGhFrwrz6GhkJgd9P
         ut5SvJjLMyYotEzFZGPmywKziOrGxBhI5GR8AAPxRQS4VZsPtEbQ0AQ3NkNmnm8p9JGU
         WrpQ==
X-Gm-Message-State: AOAM530051piwpqA1VmSfIjuBma5I8gQarl+VTKmRiDFaKlpki//kcqs
        W+DmiCXQA/MC8z2MibK3zBAzDzha+BXTYwX4
X-Google-Smtp-Source: ABdhPJwPseXTkgJf36rYRmNcvrgBP97EzFuNknfr/zg6tPrm3ZInuzaRehvEpTlC9n6Hj4Q5SX/rtRrkspJpJlj9
X-Received: by 2002:a25:b5cc:: with SMTP id d12mr29578657ybg.190.1597785397084;
 Tue, 18 Aug 2020 14:16:37 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:30 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-9-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 08/12] selftests: kvm: Fix the segment descriptor layout to
 match the actual layout
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the layout of 'struct desc64' to match the layout described in the
SDM Vol 3, 3.4.5 Segment Descriptors, Figure 3-8.  The test added later
in this series relies on this and crashes if this layout is not correct.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v2 -> v3

  - Pulled changes to kvm_seg_fill_gdt_64bit() from a subsequent commit to
    here.

---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..0a65e7bb5249 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -59,7 +59,7 @@ struct gpr64_regs {
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
-	unsigned base1:8, s:1, type:4, dpl:2, p:1;
+	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	uint32_t base3;
 	uint32_t zero1;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f6eb34eaa0d2..1ccf6c9b3476 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -392,11 +392,12 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
 	desc->limit0 = segp->limit & 0xFFFF;
 	desc->base0 = segp->base & 0xFFFF;
 	desc->base1 = segp->base >> 16;
-	desc->s = segp->s;
 	desc->type = segp->type;
+	desc->s = segp->s;
 	desc->dpl = segp->dpl;
 	desc->p = segp->present;
 	desc->limit1 = segp->limit >> 16;
+	desc->avl = segp->avl;
 	desc->l = segp->l;
 	desc->db = segp->db;
 	desc->g = segp->g;
-- 
2.28.0.220.ged08abb693-goog

