Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DDC49B39E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359685AbiAYMPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444637AbiAYMLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 07:11:01 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2AAC0613E4;
        Tue, 25 Jan 2022 04:09:49 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id e9so18126828pgb.3;
        Tue, 25 Jan 2022 04:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=gz5QosXuuikQvaYvAabGfLU0Wh+nilVLn99jf+63zBE=;
        b=aJSWF3wejABTFVsm1kEpebFPzWHq/Z3MZfCaMWcKBTkhLhQxqDSfPlUb1Ob9Ul41O3
         YGk31Jp4JeuQqbKUwVGQtIbOZdh4Xla6WVv5+4FWziSh8fyu8xQzygT4pwMQfC9Bunr2
         e977MW3h8i1E9KP/ExsIv4Y1nOkjXcFmmgICegTi2gPkPphhG/7DttFuwmBo17kRWG/I
         qT3b04qpg1hl+8XOubDvtK9d84M7B2mhDRc0LZjBLCbS7qtMMcSgwvGIkBUFdZ9t7sz2
         RRS+q0koQqd5caBgwko9+sSVhOnplvh0NjoXeoa0uxth611ic/fQgafsi6uM54bHRW9m
         U9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gz5QosXuuikQvaYvAabGfLU0Wh+nilVLn99jf+63zBE=;
        b=LHkUwidCyt/WcyOGMJe1W3LnuMRRSsgILFflgGTvCuO9Qkka9FyPHaYDdBCs4Ptkdh
         /B3i79LrXot087DFR/DkB1UVy+tmRjGENeAVz6sHbtKplIuj7buJ0xi5+nef0Vyl9KA4
         gY5hr/kaam3Y7bP9ztrZnRTzmOMlUGEjwxHKaWo0GzoPP0p3N5WMjfVLR0tGkeWFyGgG
         9uq3ccfN408+uRAxJ9QjZ7SkIfC86iLHcnyt/ue8o+S+RGxkzxAu1SGNPjQTgc8e4tgg
         8LkCmHOGq5eI15ik/DdFAbMYT+zY7eYZ4Byw+01LCF7Aa4IsS/eG6/UDYGu2trPTIR8m
         epbw==
X-Gm-Message-State: AOAM532r3S+P0ctJf8iR6LpmwosYtJKFunNZAhZBAuyejlD334WBK+S1
        olNi9u6NFtWw0JXFJLFMWT2dL3BqcPJTDA==
X-Google-Smtp-Source: ABdhPJwPCGl41ps+jjyFeVExACj5l/DSCsoTsEAXk9yP/DESw4vmkFpObKcPD2EBkESmO0Q2qkZo4g==
X-Received: by 2002:a63:754d:: with SMTP id f13mr15222276pgn.268.1643112588789;
        Tue, 25 Jan 2022 04:09:48 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id x66sm8355386pfb.36.2022.01.25.04.09.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 04:09:48 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Subject: [PATCH RESEND v2] KVM: LAPIC: Enable timer posted-interrupt when mwait/hlt is advertised
Date:   Tue, 25 Jan 2022 04:08:58 -0800
Message-Id: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
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
some guests isolated and others not, we may lose vmx preemption timer/timer fastpath 
due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt() 
is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt 
interrupt. vmx preemption timer/timer fastpath can continue to work if both of them 
are not advertised.

Reported-by: Aili Yao <yaoaili@kingsoft.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * also check kvm_hlt_in_guest since sometime mwait is disabled on host

 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc3..fdb7c81 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
-- 
2.7.4

