Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFFA79D5FA
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbjILQP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 12:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjILQP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 12:15:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA8410D
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 09:15:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7e81a07ea3so5625061276.2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 09:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694535323; x=1695140123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J4cYw5IPScCbBIBQLEMtcScQA2dnbp2DfUfUQiEYgc4=;
        b=1MmDPyYv2dsBneuZehtOCGmYZDje36EbYCHw+OhxK8zOgJlfUEXpasVS5Kn6xUdeuq
         FbgZh1qSomPbLnYyymBnxpSAd1/KsiYbWJfIqGeCGmnImWJ8DotgahEN+ci4tbAZmy/N
         GaT2WOgb8PCYYxKq4UW97QoDtwFUiq/l0MiOyeenlBxVr4TIm+nTIQ3NfATdC2HShSK8
         nphDHCnaaP32C/1LcNPQ1+1GwJqyOIYHCF5K3AggPLO0b8ve3gGjbRLxFlPLQb/o+TWx
         H9fQk4kpHizRlZ1oLWuk2WFJSoNqm/+pJDnBTDyq0OJBmCPWi/SyVP8lo0yD09dzlo2D
         dwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694535323; x=1695140123;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J4cYw5IPScCbBIBQLEMtcScQA2dnbp2DfUfUQiEYgc4=;
        b=FXOcttIs6UOEfG7GTzE3Ja1lHRpa3CAtbtbsKCB+UXB48iRPb1Cu3wwggUTgO38pv+
         9hb7mbKbe2pAo/EWVX8hg1LRqkvyCJrAiH33e2vJjp1m21/L72YV2c0W9Wg3+xSVIN9o
         uJINQEARC8DE1D4lM/LeLGezw1Y8guH63oGo0huMiVFRL5VE2TFFx32SI54YsgQ5Nqmo
         kmFIztqKWzAcv+B06Wqb2oybN38BcZk6tAbiOWSLn2zssB96mrUjlXhx80MFRwD6jbE0
         +O0OSv/dOEUuJCR1ddFWEkCiuqBKFK0WjMt1UiyhbwGeCa0SLUN05SxvmGq+iKDYMh03
         GTIA==
X-Gm-Message-State: AOJu0YxGNb6yuXFdRtk/01BXjt9OKy4CFCB75LeVUXfjHMrQ4wIi+RV3
        oQjU27S8I5wXN9777dDg0fkzLPU6pQ==
X-Google-Smtp-Source: AGHT+IFhLsWmMTy9DdyhHCb/6TCeOCi858SESAMq3siI8kdI+HJGlgTMxtCITUHnFtdTorokH1eV78N3BA==
X-Received: from hshan17.roam.corp.google.com ([2620:15c:211:201:2a7f:c6c4:6e3:ac5c])
 (user=hshan job=sendgmr) by 2002:a05:6902:168e:b0:d7f:2cb6:7d8c with SMTP id
 bx14-20020a056902168e00b00d7f2cb67d8cmr298656ybb.13.1694535323376; Tue, 12
 Sep 2023 09:15:23 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:15:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912161518.199484-1-hshan@google.com>
Subject: [PATCH] KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
From:   Haitao Shan <hshan@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Haitao Shan <hshan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This issue exists in kernel version 6.3-rc1 or above. The issue is
introduced by the commit 8e6ed96cdd50 ("KVM: x86: fire timer when it is
migrated and expired, and in oneshot mode"). The issue occurs on Intel
platform which APIC virtualization and posted interrupt processing.

The issue is first discovered when running the Android Emulator which
is based on QEMU 2.12. I can reproduce the issue with QEMU 8.0.4 in
Debian 12.

With the above commit, the timer gets fired immediately inside the
KVM_SET_LAPIC call when loading the snapshot. On such Intel platforms,
this eventually leads to setting the corresponding PIR bit. However,
the whole PIR bits get cleared later in the same KVM_SET_LAPIC call.
Missing lapic timer interrupt freeze the guest kernel.

Signed-off-by: Haitao Shan <hshan@google.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a983a16163b1..6f73406b875a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2977,14 +2977,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
-	__start_apic_timer(apic, APIC_TMCCT);
-	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
 		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	}
+	__start_apic_timer(apic, APIC_TMCCT);
+	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
 		kvm_rtc_eoi_tracking_restore_one(vcpu);
-- 
2.42.0.283.g2d96d420d3-goog

