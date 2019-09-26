Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3630DBE9D6
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfIZAyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 20:54:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38052 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfIZAyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 20:54:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id w10so483010plq.5;
        Wed, 25 Sep 2019 17:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Z6sKx/0P0u+Z8GgG8NcI3yZDJtsQNc+elyq5c7t7uY=;
        b=CVS5CuuEyeJ9AxOuRXwFQBHDKIpQVJlflZCXpP9w2R2qUkhxDWKw4PHYYDceTGzXIl
         aRf90qJvN0dXzDy0eFubAesTX38DEr/sQYiKVIyq9u/p2Az0mzbC2cRYIV+RWTEu8g49
         5EZ4mTZWj5XTCTMn/oRj9AAFcYoPzcF2/Etci9tqjz3ibvqKwn+4xt/tOnTSXFkZ+xGR
         e5FxqyI4Qz3yzZ+vpoERiACapz36J/iLqHDiwLmCPx3WOtrwSGJxNKqPzgTkkUyj1pmO
         fH7+Gn1hQu4vUqn0vkhoaZ7PToj6tpllTaxM8bbWJJxnFf7Y43mflhgHFopwYqoSnQxE
         VQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Z6sKx/0P0u+Z8GgG8NcI3yZDJtsQNc+elyq5c7t7uY=;
        b=pM/WnwokbBLYamN/mO+16LGlnYao7B368U2g2Sbnuz3an3w3EtWRfHOTgYMwOM1aH8
         Al/XUfSq4vy3f/E07ja9Cj/BUvsU9rK3A8vnLXPucEeySa2+uEIsSYticm/KtZ+nmzLP
         R/kdQhNycFCU4JGASJDwCCA/iMtHEvSMMiTZD36kOKrIAVWoTT5ESHZTBZcqLDI+8JWx
         6zn4BzFKHfJ4iN4//YyeE0Fqr3XDXA/4NrW7oMknsowEzzi0xNB6YtudDYjALeuVmJur
         OQOuRu4eRyXrLSSt5CDa6QOH3Q2wDw5BIImBQ9RD31HIEWrirBOrGrmrUU2DVeeI3ht1
         HNiA==
X-Gm-Message-State: APjAAAUzdvQOCHkqsc9A69l49Pv9SfBzGrSyOraVKAnxzoTc9AqggpSI
        q/dwunzVwLXRHH0ZU91/yUZudHk4
X-Google-Smtp-Source: APXvYqxIFnfj+RoZcEVjaRNZGH4fjsfzhfgirIv+2mKqixHQVmaVu6O+3sOeBAHs12+ULSak9LyvVw==
X-Received: by 2002:a17:902:36e:: with SMTP id 101mr1372100pld.46.1569459247956;
        Wed, 25 Sep 2019 17:54:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id h4sm211320pgg.81.2019.09.25.17.54.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 17:54:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: LAPIC: Loose fluctuation filter for auto tune lapic_timer_advance_ns
Date:   Thu, 26 Sep 2019 08:54:03 +0800
Message-Id: <1569459243-21950-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

5000 guest cycles delta is easy to encounter on desktop, per-vCPU 
lapic_timer_advance_ns always keeps at 1000ns initial value, lets 
loose fluctuation filter a bit to make auto tune can make some 
progress.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * separate defines for ns vs cycles

 arch/x86/kvm/lapic.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3a3a685..7bfc3c0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -66,9 +66,10 @@
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
 static bool lapic_timer_advance_dynamic __read_mostly;
-#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
-#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
-#define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
+#define LAPIC_TIMER_ADVANCE_EXPIRE_MIN	100
+#define LAPIC_TIMER_ADVANCE_EXPIRE_MAX	10000
+#define LAPIC_TIMER_ADVANCE_NS_INIT	1000
+#define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 
@@ -1488,8 +1489,8 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	u64 ns;
 
 	/* Do not adjust for tiny fluctuations or large random spikes. */
-	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_MAX ||
-	    abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_MIN)
+	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_EXPIRE_MAX ||
+	    abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_EXPIRE_MIN)
 		return;
 
 	/* too early */
@@ -1504,8 +1505,8 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 		timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
 	}
 
-	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX))
-		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
+	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_NS_MAX))
+		timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
@@ -2302,7 +2303,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		     HRTIMER_MODE_ABS_HARD);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
-		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
+		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
 		lapic_timer_advance_dynamic = true;
 	} else {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-- 
2.7.4

