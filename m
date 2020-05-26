Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03E1CB70A
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 20:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgEHSWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 14:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgEHSWw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 14:22:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DC8C061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 11:22:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w15so3057812ybp.16
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 11:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=36cGNYe6ShNCgmX+2LiEk2mbNEtHey09nCarODUPKds=;
        b=FxsJIw9Nqt2of5gMxoaFw1W5hQiw5NOsyI94lqgC266bKDNILq19UgSG5w7PXgRrbE
         tEnk/LbN8OeWhjwpNc3yIX06DHU3sX6I2Z6qayc2vyGJItJmHiv9Aw+67amIEZKFoEtI
         nLqj/LPIDOfTuflYf8wkrXz+YzA+NP9Lxq+KFL2UwshmYHeqUA97Qdzrgk8lN03yFNNI
         yRfLGzrUGvnWMf3zG/6CgdxABRGaZERY2CqLmrgb+FVZ8uM8VPR0a49PWW3gzC0rrfBD
         70/ixtsW+4oHQDTfIW8regY68iFqpFaraMprEo+4jwC7Cc5Mkf4zD3ahYoo734Bbcq4v
         AgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=36cGNYe6ShNCgmX+2LiEk2mbNEtHey09nCarODUPKds=;
        b=OT5HydHilwubTwNC/g70RDWy8v7V78fQlctEZMSsMNY2QwXWh+dX6+gBKpMFsseupo
         0Pz1b9BuJq9x6aZdi7wJe4Z7HrxnF4nKrGCMlO5m/yfYB/RnH2UqbGzTnlr7w5Azrtau
         VSE5Tf5bX/9iu2L+22KaH0ynq+J2H9w1LBlz3vJ5qLcoYFBlZrOvI/S0RKVGlzTUZRE9
         CxY4vWR4cMm3khAmHbUAYQCr08/quGSmtCNoXubc/vOAz11couBGllnuySbHgKjiqcml
         G6sTKsTNvNsRX4XKN+I0KJGCuvENpv15nxZkQcaXZ0C10hLJvMOiDe+B2dvdMxgZEH89
         lhyw==
X-Gm-Message-State: AGi0Pubcab+CwrcMtnaw7+DK97fIGFCEWIwtjriQ8EsBQ/zJiYaXvPQl
        +yNlL++5mJJhwRoqsmlst41q8qH/i8umXg==
X-Google-Smtp-Source: APiQypKHnac9ibG0+zijqvOKATCu+FaUpuVnT1jlsq4K4eTgwmg4aYoNgIvp73R9IMCdQXmZuESLz5iLNgpzhw==
X-Received: by 2002:a25:b9c5:: with SMTP id y5mr6305255ybj.421.1588962171430;
 Fri, 08 May 2020 11:22:51 -0700 (PDT)
Date:   Fri,  8 May 2020 11:22:40 -0700
Message-Id: <20200508182240.68440-1-jcargill@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH] kvm: add halt-polling cpu usage stats
From:   Jon Cargille <jcargill@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Two new stats for exposing halt-polling cpu usage:
halt_poll_success_ns
halt_poll_fail_ns

Thus sum of these 2 stats is the total cpu time spent polling. "success"
means the VCPU polled until a virtual interrupt was delivered. "fail"
means the VCPU had to schedule out (either because the maximum poll time
was reached or it needed to yield the CPU).

To avoid touching every arch's kvm_vcpu_stat struct, only update and
export halt-polling cpu usage stats if we're on x86.

Exporting cpu usage as a u64 and in nanoseconds means we will overflow at
~500 years, which seems reasonably large.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jon Cargille <jcargill@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              |  2 ++
 virt/kvm/kvm_main.c             | 20 +++++++++++++++++---
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a239a297be33..3287159ab15b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1032,6 +1032,8 @@ struct kvm_vcpu_stat {
 	u64 irq_injections;
 	u64 nmi_injections;
 	u64 req_event;
+	u64 halt_poll_success_ns;
+	u64 halt_poll_fail_ns;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c0b77ac8dc6..9736d91ce877 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,6 +217,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("nmi_injections", nmi_injections),
 	VCPU_STAT("req_event", req_event),
 	VCPU_STAT("l1d_flush", l1d_flush),
+	VCPU_STAT( "halt_poll_success_ns", halt_poll_success_ns),
+	VCPU_STAT( "halt_poll_fail_ns", halt_poll_fail_ns),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pte_updated", mmu_pte_updated),
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33e1eee96f75..348b4a6bde53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2664,19 +2664,30 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static inline void
+update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
+{
+#ifdef CONFIG_X86
+	if (waited)
+		vcpu->stat.halt_poll_fail_ns += poll_ns;
+	else
+		vcpu->stat.halt_poll_success_ns += poll_ns;
+#endif
+}
+
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
-	ktime_t start, cur;
+	ktime_t start, cur, poll_end;
 	DECLARE_SWAITQUEUE(wait);
 	bool waited = false;
 	u64 block_ns;
 
 	kvm_arch_vcpu_blocking(vcpu);
 
-	start = cur = ktime_get();
+	start = cur = poll_end = ktime_get();
 	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
@@ -2692,7 +2703,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 					++vcpu->stat.halt_poll_invalid;
 				goto out;
 			}
-			cur = ktime_get();
+			poll_end = cur = ktime_get();
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
@@ -2712,6 +2723,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
+	update_halt_poll_stats(
+		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+
 	if (!kvm_arch_no_poll(vcpu)) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
-- 
2.26.2.303.gf8c07b1a785-goog

