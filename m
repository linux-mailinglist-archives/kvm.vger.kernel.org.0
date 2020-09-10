Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D402642F2
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgIJJyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgIJJvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CADC061795;
        Thu, 10 Sep 2020 02:51:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so4330625pfi.4;
        Thu, 10 Sep 2020 02:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kx7whO6ZCYHRATUGoFzPCq1CCU2l01VHTCUDbZIVyWI=;
        b=r7Dro3OwHZ7zTknULumOSLG9JV8KHr4ktmvsDyXpvuHYyFrHiK+OmM+t+zYql34ltP
         Yf2QHFkojLEZ1sNbCB97p6joWTF0dfIutegAMxIRWyyMuiXjWXeJZQ/SooxQEkJ7k6uR
         xi8ek+C2F/Yk9YzK7oVOJg186oDGUYN4nAvrppEf0lpytO5Hf7pzXroZKYemPB7+sYKy
         oSroWn1hXE8J0gB0aiDeDRK/RGydEHqAiIzhwrn+TqEDNZsWQ87qa69nogMW3DApTR/q
         a1f1p4v3uV8d2kpclG6C8Ira+n/NBqbmOdhVMF2+P4HkPdm3z8LDBBkk/acIunrhxcl2
         uzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kx7whO6ZCYHRATUGoFzPCq1CCU2l01VHTCUDbZIVyWI=;
        b=M05rqCxo/vbCUjYvO2b0lgSBLr8y0OEisW0/yIOEeyvaCnfevCvGajKzrurlbFyAOw
         RmvS/8sZS5PqvY2Tgulwxr1wddZXxInK5Oq9JAnkpsWJy7cGAVlbA+vG/Z0u8tgzs7nf
         gCf07W+KWa9KiKFFOdl0wl3DJb8L8JDUHLWQahEuE+wx9O3eASUkvreZw8kVnHQjePFO
         qFlEnT/u+C8s0cSbJC5tDw/NnnisGHkedCI/AsgcxTRu9ssZhF+6Mb3S71eusB3WMbFk
         6AMkQnGmMmlMCOlfQ70B6eL4iGWk+DiGfYUwYZn4TmaOlcVetwLD2j2bfi/qkgyUhY84
         qByQ==
X-Gm-Message-State: AOAM533N31sVyXUmpq+5wvrqy0NPK5v7j51sKEzjYnqSNUg4GgWNiseV
        1+5VpidMXUE+OtEj3ozIKIz+Qw0apcY=
X-Google-Smtp-Source: ABdhPJxIfzznZfSjzdpMV+TClLMq+JvquGerhc18a2TLYYe0aNJ/PJMsL7TI6MrTC38L77qdtaJgMw==
X-Received: by 2002:aa7:988d:: with SMTP id r13mr4713746pfl.93.1599731470981;
        Thu, 10 Sep 2020 02:51:10 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:10 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 5/9] KVM: LAPIC: Narrow down the kick target vCPU
Date:   Thu, 10 Sep 2020 17:50:40 +0800
Message-Id: <1599731444-3525-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The kick after setting KVM_REQ_PENDING_TIMER is used to handle the timer
fires on a different pCPU which vCPU is running on, this kick is expensive
since memory barrier, rcu, preemption disable/enable operations. We don't
need this kick when injecting already-expired timer, we also should call
out the VMX preemption timer case, which also passes from_timer_fn=false
but doesn't need a kick because kvm_lapic_expired_hv_timer() is called
from the target vCPU.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 arch/x86/kvm/x86.c   | 6 ------
 arch/x86/kvm/x86.h   | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e446bdf..3b32d3b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1642,7 +1642,9 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	}
 
 	atomic_inc(&apic->lapic_timer.pending);
-	kvm_set_pending_timer(vcpu);
+	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+	if (from_timer_fn)
+		kvm_vcpu_kick(vcpu);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d39d6cf..dcf4494 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1774,12 +1774,6 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
 
-void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
-{
-	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
-	kvm_vcpu_kick(vcpu);
-}
-
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 {
 	int version;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 995ab69..ea20b8b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -246,7 +246,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }
 
-void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
-- 
2.7.4

