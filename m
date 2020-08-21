Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF2824D148
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHUJRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgHUJRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 05:17:49 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD962C061385;
        Fri, 21 Aug 2020 02:17:49 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id d4so559975pjx.5;
        Fri, 21 Aug 2020 02:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FowiN7wGUIsFhFJkyzUhtvp+B7SgUmBl2oc4E8odKUg=;
        b=u5imW/obXnthlptyuM+UmZMrIJpnkZhelXsiU1c0RPMDUbj3oQWZdP0i9N4UfPSleC
         KfJ/OfpP0+MYveLl9IG5eAvuVZrZxxi0NB63ep5eZsz2hD99jBPZJQC0VkarKWVs7c+m
         2qzbfQOKImRQONRgimycy8is1Ho47cs+XGHJRcTSTa4hnzhi3dqhZ9IphiTAgGSZykl7
         36NmF4e8k7/DPRUQcxW4i/DonSqdJAtMDycWwa19T1Z8As5IMjLJkRXTbQ/JeOYi7YWk
         YsMPSgpTyFyYHsflZ8QzTReDRcTciU7WF1+e39v+mZe8aV5axhVeFOzivWEOGNdQawP6
         AAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FowiN7wGUIsFhFJkyzUhtvp+B7SgUmBl2oc4E8odKUg=;
        b=FGNivJNRu8Ap6dDiffaLT0JzahEKWmo36JrHQtCoXRRBildcW9WZ/y0JS1Gwk0aiQ8
         anF//EJpJKPb8x+cKWq6XGLu36rXMszbEdnA+XdznfDKXLnZUxb2tYEmsjYQO6VWZdbN
         meg8k0AnT6gkAUIwd5wvufYIzFcB+ICc6G98ahB/tTnDAxH19FgF8vUjUxDBA7GvEBHq
         97pHpV4R/oylc56TC8sg//CPNUguymamRsAAisObl1hC9d/qiZa+x654zDY6lBR0NFLa
         pIUL6FfxfzUeAwdNX5qAjqfhQO+00eK1tmh1OE6w1ghnGLKI06DHwUeBfMTBisfp1b+Y
         wOIQ==
X-Gm-Message-State: AOAM53050MGsIvoNDsrOdewfdwha5CygnJJAHr14l9m/dMWktcQ6W6vE
        /t9n4T+3isHJFA3dqVnI962qF30Z/WU=
X-Google-Smtp-Source: ABdhPJzNNdQKEjdNXXETsWvOfEIJS9o3AaeMqd6oRQlM6ML8PWimk/XtWQ755wUwRXMeFh9RI3JzRQ==
X-Received: by 2002:a17:90a:ee08:: with SMTP id e8mr1840282pjy.86.1598001468857;
        Fri, 21 Aug 2020 02:17:48 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id b26sm1961190pff.54.2020.08.21.02.17.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 02:17:48 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Don't kick vCPU which is injecting already-expired timer
Date:   Fri, 21 Aug 2020 17:17:34 +0800
Message-Id: <1598001454-11709-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The kick after setting KVM_REQ_PENDING_TIMER is used to handle the timer 
fires on a different pCPU which vCPU is running on, we don't need this 
kick when injecting already-expired timer, this kick is expensive since 
memory barrier, rcu, preemption disable/enable operations. This patch 
reduces the overhead by don't kick vCPU which is injecting already-expired 
timer.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 arch/x86/kvm/x86.c   | 5 +++--
 arch/x86/kvm/x86.h   | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 248095a..5b5ae66 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1642,7 +1642,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	}
 
 	atomic_inc(&apic->lapic_timer.pending);
-	kvm_set_pending_timer(vcpu);
+	kvm_set_pending_timer(vcpu, from_timer_fn);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 599d732..2a45405 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1778,10 +1778,11 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
 
-void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
+void kvm_set_pending_timer(struct kvm_vcpu *vcpu, bool should_kick)
 {
 	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
-	kvm_vcpu_kick(vcpu);
+	if (should_kick)
+		kvm_vcpu_kick(vcpu);
 }
 
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 995ab69..0eaae9c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -246,7 +246,7 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }
 
-void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
+void kvm_set_pending_timer(struct kvm_vcpu *vcpu, bool should_kick);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
-- 
2.7.4

