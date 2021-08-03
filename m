Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6908D3DE7AE
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 09:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhHCH7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 03:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbhHCH7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 03:59:35 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2617C061764
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 00:59:24 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id s14-20020ac8528e0000b029025f76cabdfcso12512957qtn.15
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 00:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Fxd607RMBzP4aoVO0IekhXmHo+nn/xa9qFfPGrfYJnk=;
        b=YymPx+mWp1zUbGTLO5o8137nsca5qm9tyeMBp6mwVCeFmc2hPAVp6FRtc/ojTVbd0e
         bTJkElcc0C6ssNMxn8f1pPJx08ZJTZNOWD/QHci2jOnYQ4C9P5J7xnODtAwpF77xNzB0
         TIdSAXiFgg300g+h+io9WAoNmjFXP4l1QYqCB/m42HWP5vCrPXgQNK44A+jsjNegQwFn
         4CWG/kdVsURaNsXjonrIEsrPpzfl2ad18OFY+e7omyKmYqhWJ5HeVPhW68yaZszdfgDo
         Hjd9A6DbB51Z4zL+7X+KAJITtV5AeBVr74YqKV56/qV1Tr/RpFvnsxvLGKEV5ZUQ6aTL
         8PEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Fxd607RMBzP4aoVO0IekhXmHo+nn/xa9qFfPGrfYJnk=;
        b=JtNNf6sOHKRwppvE6ahILlt/RpjT/8S/wLbVe25hZR+2oNbuQC/9wUng9PzRaIK2+l
         xCGY8apKoeEsKWNdp6xXrpFWcB2p+qJzvNeB8IhsQ++ZBAr4uPZilMmEOxGH7aO+dIfE
         yoHcRHzaSYX0WSmHGD3z3P/JKoe2P2dlrIm0m2adkB98VtzCcviziVjLYylkCtTy07Wd
         vBb3YTSqVNCT3TTfhXZ8/HGe5ylTBouBuCpth9U+G9fkokkCVwJUu+Ma3rZFMnuMB7DU
         M67ux/Twjje0ifrJwy5zjL8H68Qs5W2EJ/b3UzvnaHfqg3YJGq6ilUaZq+JJ9h+SFa5w
         E6Bg==
X-Gm-Message-State: AOAM530kp2YdJQPlia51+V9BJHJKRPCnr8F0DckpLcsqrsTFKbDCvYw4
        0bqzBaheBKkfce+aixrD7peNEJd+/5xR4w==
X-Google-Smtp-Source: ABdhPJysqvn+LjS2ao5Iec7fgO+cxbswRHEKmAV0xZsBvKypSr1bKig1Z1zbBeJ2hUtpYyWnPao0H7Tj6P3tAQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:7e55:6c56:df0d:f664])
 (user=suleiman job=sendgmr) by 2002:a05:6214:332:: with SMTP id
 j18mr20391348qvu.21.1627977564134; Tue, 03 Aug 2021 00:59:24 -0700 (PDT)
Date:   Tue,  3 Aug 2021 16:59:14 +0900
Message-Id: <20210803075914.3070477-1-suleiman@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH] kvm,x86: Use the refined tsc rate for the guest tsc.
From:   Suleiman Souhlal <suleiman@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     ssouhlal@freebsd.org, hikalium@chromium.org,
        senozhatsky@chromium.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior to this change, the initial tsc rate used by kvm would be
the unrefined rate, instead of the refined rate that is derived
later at boot and used for timekeeping. This can cause time to
advance at different rates between the host and the guest.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4116567f3d44..1e59bb326c10 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2199,6 +2199,7 @@ static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
 #endif
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
+static DEFINE_PER_CPU(bool, cpu_tsc_khz_changed);
 static unsigned long max_tsc_khz;
 
 static u32 adjust_tsc_khz(u32 khz, s32 ppm)
@@ -2906,6 +2907,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
 	}
+	/*
+	 * Use the refined tsc_khz instead of the tsc_khz at boot (which was
+	 * not refined yet when we got it), if the tsc frequency hasn't changed.
+	 * If the frequency does change, it does not get refined any further,
+	 * so it is safe to use the one gotten from the notifiers.
+	 */
+	if (!__this_cpu_read(cpu_tsc_khz_changed))
+		tgt_tsc_khz = tsc_khz;
 	if (!use_master_clock) {
 		host_tsc = rdtsc();
 		kernel_ns = get_kvmclock_base_ns();
@@ -8086,6 +8095,8 @@ static void tsc_khz_changed(void *data)
 		khz = freq->new;
 	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		khz = cpufreq_quick_get(raw_smp_processor_id());
+	if (khz)
+		__this_cpu_write(cpu_tsc_khz_changed, true);
 	if (!khz)
 		khz = tsc_khz;
 	__this_cpu_write(cpu_tsc_khz, khz);
-- 
2.32.0.554.ge1b32706d8-goog

