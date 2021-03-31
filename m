Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81E034CD44
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhC2Jog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 05:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhC2JoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 05:44:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45760C061574;
        Mon, 29 Mar 2021 02:44:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso5646699pjb.4;
        Mon, 29 Mar 2021 02:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=U5U4X+ZOhi4vgTgaFmTIVBDWOm8KVT4HEd/HA9LL9Zg=;
        b=DlatJVXkwqLPHmaVGR45p/BOWtcCxdavc35cLcf00aTgyWgqryDueTSl1vW8kxxBII
         QuBWhR7SRW/ojJsXogmNVx1sXCkbmilH1C7Kw4sZ/XHsrQt7eACRMgnY7/N9LH7b/Gam
         3y39+pTcse9g45vH7WegK0gdUgdofxWrQZ8w31NaI0AAhrLcZtOhD2iQ1/sb0HxUqygF
         wX/Mt/71CHLgpZVXVZeCA1SiC5Uir1FFLmJnZftO47eeF/doW9zKaLjzXaSis/fGKedR
         3jU+KXRZZtISrvHYdasYok5VHX5nxpr3ltxMAj/nzntl0nLGeWrkG4m9c07xdvIGyk8Z
         opFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U5U4X+ZOhi4vgTgaFmTIVBDWOm8KVT4HEd/HA9LL9Zg=;
        b=mThAy4Y98c8YKTdeq1EHhXzJQJtmRQo6JEvlJ7ryKrgltJO9LXGUSjMm5wAvFEP9lv
         SLxGTNRaKVGAE4/XqSzetLXY3eqjjqQVjfXJSEOYQ13Nkyc2i4to7HSQoaSXA0MDSFUw
         Ici+P1w5E0WPNOMea/zzR/6IgzwgN1szyNvCOFPKhb0f1EootnWwiMkH2skbNde/js2j
         0HMwL+vZop8+WVgPsrEvOUiCo2zCi0lpXnNaxz8NPEJP68sSSRmgAArrOtrOLXmVsoEu
         tiIF9rE/kV9iq4O4/cgDdBrER06SNxB/cas2PY/ItN9byVaXNOwSYrkVaYvWuqsL2+h+
         nV/A==
X-Gm-Message-State: AOAM530NS28s6gfTPcUkOBuS3BvtdSoTcfCNIBJfc5+5fS3DZ0gToJ8e
        lzeVX8yfmOn7HU0+MZ63I9flyg5kl/k=
X-Google-Smtp-Source: ABdhPJwzAifXMNB/rOR9vWitJtHt9JOBN4qz/C2AqKhgh6EHTSUfZ+yHjV8cBOJZo6E5k2AfGIrqTQ==
X-Received: by 2002:a17:902:e889:b029:e7:1490:9da5 with SMTP id w9-20020a170902e889b02900e714909da5mr22000247plg.20.1617011049985;
        Mon, 29 Mar 2021 02:44:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f15sm15749610pgg.84.2021.03.29.02.44.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 02:44:09 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Properly account for guest CPU time when considering context tracking
Date:   Mon, 29 Mar 2021 17:43:56 +0800
Message-Id: <1617011036-11734-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831 
reported that the guest time remains 0 when running a while true 
loop in the guest.

The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it 
belongs") moves guest_exit_irqoff() close to vmexit breaks the 
tick-based time accouting when the ticks that happen after IRQs are 
disabled are incorrectly accounted to the host/system time. This is 
because we exit the guest state too early.

vtime-based time accounting is tied to context tracking, keep the 
guest_exit_irqoff() around vmexit code when both vtime-based time 
accounting and specific cpu is context tracking mode active. 
Otherwise, leave guest_exit_irqoff() after handle_exit_irqoff() 
and explicit IRQ window for tick-based time accouting.

Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 arch/x86/kvm/x86.c     | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb..55fb5ce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3812,7 +3812,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	if (vtime_accounting_enabled_this_cpu())
+		guest_exit_irqoff();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf828..85695b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6689,7 +6689,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	if (vtime_accounting_enabled_this_cpu())
+		guest_exit_irqoff();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe806e8..234c8b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9185,6 +9185,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
+	if (!vtime_accounting_enabled_this_cpu())
+		guest_exit_irqoff();
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
-- 
2.7.4

