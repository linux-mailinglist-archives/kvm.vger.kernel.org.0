Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24413A066A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhFHVv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:51:29 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:55996 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhFHVv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:51:28 -0400
Received: by mail-yb1-f201.google.com with SMTP id m194-20020a2526cb0000b02905375d41acd7so28707370ybm.22
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qXkSbOYb2IC3X2Tl5AKB9URDdm1XI6BUL14Xin2r7eg=;
        b=F9podaJObKk/txBttzcQCUMN3bmiUkX6RaROZiUt4OyZK4vESkbOf4/II5yKFotHVQ
         alHKMpjv3ojhTmGJfKR0t8Pyc3bB+pnSBywsc97WcltB+In8AABdaquDC6LG0mdDRJni
         uH97XjL/yCGjxozIBw5JWghGNQXCuEsCu9BK04G/h9CcBweO7u09GJQdL0rl/obTCjUz
         dgck6LWM7TZyL78hf1fLz0pprF8fjd7LbZBlbaBcNXq8Uxv6B5cctb1GH046oxmztpJ3
         xwTLXOmKNCU36JKeHjq8101RrY8QnGF03HpMmuFmQFoASYx3qaG24I2W95/80lYrhHBd
         YrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qXkSbOYb2IC3X2Tl5AKB9URDdm1XI6BUL14Xin2r7eg=;
        b=s9nGEF8md3WR53Hkw7n3AoydFDu4L+bCEsNt4MF+DclS2JHY5ye8lFgNyQQTsrZjeg
         ZfQxyNwJT7xsPrE665d/j6cJLqvj7gWgAed3Dap5twKy15nBNkDuV+IczNVjU68JWX/6
         Ka8GCn569LAhclfDq2NmqbVAw4juJW7nz0cCwa9++IzMrH3v4uH+OASDh4wSAq70ER15
         M38wu8RopNkAcbOy0JQ4WjYZ+2dn4RxkL0v87T9NrmlXSQ43SdO0bVM7OD2nOptRZI5X
         hR+Wa/jQl+5XetE1urAp5+tDcyhoevTgKLg7E641ZWAulGJZz+OWgrp4KW7/OnmPf8JB
         jkLQ==
X-Gm-Message-State: AOAM532YS3iadrCBZCODjRnCZTZ+MFlJzU80pAdsyfWJcQLBGxHUM+mb
        Q22+nmBsWZmyZGQip06+B5ENO8iIbcm1z1CNcXjyIoHyTZSz46QAslAs8UYDLrvDTb1LRl1Arh2
        m0QbI6QjDS8A2hOTm53yBDXHnQibJxwIUobicKn39r6FMxw5BdI3MuFyl/g==
X-Google-Smtp-Source: ABdhPJxckUBKZ1i6dYMHyxVrr1ezG9WhmAhLTg+a5+kWk0J+vJAtGDvqW3iEOXVnlBNIdoUd9FtMux/VlVo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9bc4:: with SMTP id w4mr32208884ybo.168.1623188899905;
 Tue, 08 Jun 2021 14:48:19 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:37 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-6-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 05/10] selftests: KVM: Add test cases for physical counter offsetting
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for physical counter offsetting to counter_state_test.
Assert that guest reads of the physical counter are within the expected
bounds.

Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/system_counter_state_test.c | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/system_counter_state_test.c b/tools/testing/selftests/kvm/system_counter_state_test.c
index 059971f6cb87..f537eb7b928c 100644
--- a/tools/testing/selftests/kvm/system_counter_state_test.c
+++ b/tools/testing/selftests/kvm/system_counter_state_test.c
@@ -62,11 +62,34 @@ static struct system_counter_state_test test_cases[] = {
 			.cntvoff = -1
 		}
 	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = 0
+		}
+	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = 1000000
+		}
+	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = -1
+		}
+	},
 };
 
 static void pr_test(struct system_counter_state_test *test)
 {
-	pr_info("counter: %s, cntvoff: %lld\n", counter_name(test->counter), test->state.cntvoff);
+	pr_info("counter: %s, cntvoff: %lld, cntpoff: %lld\n",
+	       counter_name(test->counter), test->state.cntvoff,
+	       test->state.cntpoff);
 }
 
 static struct kvm_system_counter_state *
@@ -103,6 +126,8 @@ static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
 
 	r = read_cntvct_ordered();
 	switch (test->counter) {
+	case PHYSICAL:
+		r -= test->state.cntpoff;
 	case VIRTUAL:
 		r -= test->state.cntvoff;
 		break;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

