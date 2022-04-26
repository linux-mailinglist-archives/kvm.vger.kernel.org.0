Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6689250F435
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345044AbiDZIfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345279AbiDZIe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 04:34:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48FB73065;
        Tue, 26 Apr 2022 01:26:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i24so17305091pfa.7;
        Tue, 26 Apr 2022 01:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=yhLyL+XNsxkwpVleNlagUYPk4ikrWSVwJ5iKvEtm9r4=;
        b=QhrHokc1cqTSaM8Bm+BwVpjH81YmWkQrBRqiM+8OSkSDQlbidv8n9aGyRD16LTp05s
         3WChyLlV3VO9IPi13CJKMhT05wEYckITk4L7Xghehtq7K/BS+BiP09vHFsi82wxpXF51
         cnYzW9J7jWDyDd4NNG9GV4d4G16Er+IhZM+saPSpFcNO3B2T1kKbarnCdmpSiTl75D3w
         uCu43xKe8ggtAvbg/t0TF+w4PEchRrPd4iiXPJefmSup2qnzNkxiXwWYD27F8miIR70s
         dTrXz2rFYhLpRm73qjMHmgmOKI5Py9I+fjIY7ZDTvt7sj7Ob7807i7XbyOvTg1YhTVg5
         cZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yhLyL+XNsxkwpVleNlagUYPk4ikrWSVwJ5iKvEtm9r4=;
        b=G/koMKj7p+r1r5mBySzqVe96txAtguoz15oNbt35xn9jrA3UG9kCDtqLMnIMsSyc3K
         BVDAITq9JskNgYahWTrxeSgEjps3nLU3Aa7DGDQ9eg0IxDArT0rTg7a/eER3aUMNvEny
         a18q5juj49WTtJSA5E8aSxxLPtQT8CE6JsPmwaRnfyrgjnL+aWe4olATxOFc6Ogwr2D4
         +1yLDGE5U1esNSEplRbI8H+0qy390WJnAT1d9Iw/YtHO3K6ISuNft8usBZE3EZyrdacT
         ZAwVcUqG1VCzRR/qerFFFgFHQ8QUsaefHSeSavMgSWZuzzExXs8ZvIyl1Y1hLxiPeqj5
         roDA==
X-Gm-Message-State: AOAM533NNn7n+oKdCI2xz9ZkeMKdAkwgYexUXFCej1HVk4SuzfhDjwif
        MLZC1juYxMbCDGNyUth0xi9zNVnltr8=
X-Google-Smtp-Source: ABdhPJz+74lK30qT8FEbdkFdhMy6GpRLV2X22ikbl7jvT9J2uD4jEhIbrQcWPhnJvO2yG0B2407JDw==
X-Received: by 2002:a05:6a00:894:b0:4fe:25d7:f59e with SMTP id q20-20020a056a00089400b004fe25d7f59emr23477482pfj.58.1650961617115;
        Tue, 26 Apr 2022 01:26:57 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.googlemail.com with ESMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm12024832pgp.3.2022.04.26.01.26.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Apr 2022 01:26:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Fix advance timer expiration delta trace
Date:   Tue, 26 Apr 2022 01:25:51 -0700
Message-Id: <1650961551-38390-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The advance timer expiration delta trace is moved after guest_exit_irqoff()
since it can avoid to violate RCU extended quiescent state when moving 
wait_lapic_expire() just before vmentry. Now kvm can enter a guest multiple 
times since IPI/Timer fastpath, snapshot the delta multiple times before 
vmentry and trace it one time after vmexit is not accurately this time. 
Commit 87fa7f3e98a1 (x86/kvm: Move context tracking where it belongs) moves 
rcu state updates more closer around vmentry/vmexit, we will not violate RCU 
any more. Let's fix it by keeping the advance timer expiration delta trace 
in __kvm_wait_lapic_epire() and dropping advance_expire_delta.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 arch/x86/kvm/lapic.h | 1 -
 arch/x86/kvm/x86.c   | 8 --------
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..a4e9eb329e42 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1648,10 +1648,10 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
+	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
 
 	if (lapic_timer_advance_dynamic) {
-		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
+		adjust_lapic_timer_advance(vcpu, guest_tsc - tsc_deadline);
 		/*
 		 * If the timer fired early, reread the TSC to account for the
 		 * overhead of the above adjustment to avoid waiting longer
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4e4f8a22754f..65bb2a8cf145 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -38,7 +38,6 @@ struct kvm_timer {
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
 	u32 timer_advance_ns;
-	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6ab19afc638..5fa465b268d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10248,14 +10248,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	guest_timing_exit_irqoff();
 
-	if (lapic_in_kernel(vcpu)) {
-		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
-		if (delta != S64_MIN) {
-			trace_kvm_wait_lapic_expire(vcpu->vcpu_id, delta);
-			vcpu->arch.apic->lapic_timer.advance_expire_delta = S64_MIN;
-		}
-	}
-
 	local_irq_enable();
 	preempt_enable();
 
-- 
2.25.1

