Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34FD45B416
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 07:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhKXGDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 01:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbhKXGDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 01:03:46 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018B9C061574;
        Tue, 23 Nov 2021 22:00:37 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id m15so1157020pgu.11;
        Tue, 23 Nov 2021 22:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=OuG6Dcru5xJdxaep/9HwArVKmO5jy/e5OafxYbkdspc=;
        b=c7fDY59tF11DmqhKPhYtptf6fwu3mX3P3bUqUuhRmlvDjvUFRwWV51VvS9c5jBzchu
         xipWUblGN9DUkucd+k1wJgenwnpN8Rf3h7PmOLlz3c+RjjO8xSVGqK5T67ZTYOJu+rf8
         Efgcn3pg8wdfId/TiNxqvAOIpK6gR5OsHs3zPPbhPGkasi6k/DrslGHNyWDZm3gcbzIl
         mjbELS3xev+oTq3n4UrKnkApePYAWypEohFApG5/zh+R0PnQJtiX9s/nA6wK9DxN/N+A
         4T9OSRBLj2sIqyzhLAsa5FDjnOdVTUHWJmnGkXovsk84KUUn/Zscwe4iwRzusAQA8hj/
         gKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OuG6Dcru5xJdxaep/9HwArVKmO5jy/e5OafxYbkdspc=;
        b=Kn6AIuPD/kFguqR+hzOUyOzyXuIQ1S6EQD4cKgpVTCWxcbrf3grWdyD59DVQnPsXif
         g0LbB4NhtQgcMG5M6jdluoBekpUr7EKASQAGLQjwJKO5yfBV9egIMtNywEeGZza6q4s3
         RLSJX1pq3Sbnqkv4FhX3h0UIuGuizw2zLDlY/UCP2Juxzzg54/C1vJfK683mYV0yqbE2
         D36iOxTkCb4l6EZrSTizoBx0bVZLnPmiFc4sPQ2ABdRaOZx71Ba8pJvsMkpzE0mDQit1
         wLkpxtDlWkHWJ93RYemPi93c6/LyWT5M3jKE+NbPRc/dQynCLK2F0JcD3beOvRnGa98q
         iCrg==
X-Gm-Message-State: AOAM533pM+QVIG7fsnBVJHGPRpjG2kSCsmwRfZrMQLmcdOpgKvxsJKMC
        1zMI33k4hCubW8Ywe4UrJbGAYT1QSuw=
X-Google-Smtp-Source: ABdhPJw8EG+NFrl07hkhFpagDnM4ahw3ypYp4PllZRtykYNMAs5uNRfwZLE4YuA5aTMjyv+yBNHzLQ==
X-Received: by 2002:aa7:811a:0:b0:44c:b9ef:f618 with SMTP id b26-20020aa7811a000000b0044cb9eff618mr3411148pfi.9.1637733636327;
        Tue, 23 Nov 2021 22:00:36 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id i76sm10288474pgd.69.2021.11.23.22.00.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Nov 2021 22:00:35 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Subject: [PATCH] KVM: LAPIC: To keep the vCPUs in non-root mode for timer-pi
Date:   Tue, 23 Nov 2021 21:59:45 -0800
Message-Id: <1637733585-47113-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt) 
mentioned that the host admin should well tune the guest setup, so that vCPUs 
are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root 
mode. However, we may isolate pCPUs for other purpose like DPDK or we can make 
some guests isolated and others not, Let's add the checking kvm_mwait_in_guest() 
to kvm_can_post_timer_interrupt() since we can't benefit from timer posted-interrupt 
w/o keeping the vCPUs in non-root mode.

Reported-by: Aili Yao <yaoaili@kingsoft.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..8257566d44c7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops.set_hv_timer
-	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
-		    kvm_can_post_timer_interrupt(vcpu));
+	       && !kvm_mwait_in_guest(vcpu->kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
 
-- 
2.25.1

