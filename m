Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4C24F0D3
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 03:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHXBDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Aug 2020 21:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgHXBDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Aug 2020 21:03:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C42C061573;
        Sun, 23 Aug 2020 18:03:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kr4so3363836pjb.2;
        Sun, 23 Aug 2020 18:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mHdg7ZAGw/S9rL1jLVYu4KEglhQVBa3kE+9qg01kLDU=;
        b=XWfhn3tb/CT6dh4iItrfklOil+TX8ZdWg2R1Mze0W7ts71wK/IveEYyUgjoCK6Lu7c
         ENdIeHaH2bBs+qqFLVWcp/8ghnM00i0uiXy8LH4mI1aezmmrv7l3WcmoL9bQ3G8DK+kb
         3sSscsg8Y9omBA4dR5y+1r70JNX/HPaWI+uHoEjBhiYRg6pXR3AzPU9XgNAYblEgB6pb
         TZOUXlBlZD41CIEDGVB9zoZoROZFQ1Lg8I0zBe8dalmsAqpQ44borkSpOsgGVmmRbVzI
         AGp9cVX3RCpifZqblRpUkm9VaPYvJ043/BLB00xq4Uiu/krE7QzdskGQvJvyZpKv9Hsn
         /O6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mHdg7ZAGw/S9rL1jLVYu4KEglhQVBa3kE+9qg01kLDU=;
        b=V/zohNHmaArYbNB+yat7SbOHDChCeXI2U4h6cE4+EZUnmzq27ahv08bHHa5Umdaj+o
         nTCo952d0LlzfcRMOKngjqD9z/etMWA3Iip4Pd3C6/ltzrxmj2kFLoOfmAyJyMr5le31
         331mG7CGOs3H2PgkBNJpislDN3buVHKV+jV+kQ6tT3Q4cSzC+bF/UG1K2DHkgTKgxTTP
         oCYVM9HQ+5P7AmPFHPx32jQ1XW8CYfL+w/ChyROUM67FWFJePpIhGY5vl/d+Trol/dHU
         y70FRqW8kFhe1cqKRBqnsIuDWCO4BxOowwqbvgVy89kyoabY7889E0tLOwtMAAoUJKGP
         gL5A==
X-Gm-Message-State: AOAM532im/gaj8KV3838mSYf4nkNheXkG805frmYamRKHw5tcU0zHgiC
        9ZAWgHwzvJjleSMeR/SbhahvcWAsXys=
X-Google-Smtp-Source: ABdhPJzKxBkrzyOs7RXrO1VIvMRJJzcj3jMGwFNlbqEuthPA+17ztNMBGXVB6n/zkyuHfWY96ZeCPQ==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr2179592plb.205.1598231012076;
        Sun, 23 Aug 2020 18:03:32 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id ml18sm7699823pjb.43.2020.08.23.18.03.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Aug 2020 18:03:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: LAPIC: Narrow down the kick target vCPU
Date:   Mon, 24 Aug 2020 09:03:16 +0800
Message-Id: <1598230996-17097-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch subject and changelog
 * open code kvm_set_pending_timer()

 arch/x86/kvm/lapic.c | 4 +++-
 arch/x86/kvm/x86.c   | 6 ------
 arch/x86/kvm/x86.h   | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 248095a..97f1dbf 100644
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
index 599d732..51b74d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1778,12 +1778,6 @@ static s64 get_kvmclock_base_ns(void)
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

