Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998E3268805
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgINJML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgINJMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 05:12:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2952AC06174A;
        Mon, 14 Sep 2020 02:12:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f2so9007966pgd.3;
        Mon, 14 Sep 2020 02:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNPaexwdRbC0vdnnc/ZlaorxWPNe3E9MlyDWCDU1qxc=;
        b=g15SUR4A1W9BYX5FF7LdjklB1QMIvQfgK962p7cJsg6EnMw4sN8VPquCRp2x6eFwM1
         chg8YGuNp76jd8NWwlBZh//AU5X8UO4cJTAlFT/NngZVrgQfcHjayRGXcUlM/IMLZO5g
         hC2yS56YupjW34QAAd8DCZ3lAeElYOCm4VUvcDbTLPJ69aXkaYoewC/PFdGTvlgBl0Bm
         QtLDUJpMPKn+AyDapstA2yWKNVi+efx5LjPRvIaX21StEz2J96DXAH1lV444DIEaxhz6
         koVGBzDXxbpwNSg6Oemv56kiju0RxPw3AXRa4GN4SJqJgEKV6PB+pzpR2T9yzdhQTf1Y
         VNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNPaexwdRbC0vdnnc/ZlaorxWPNe3E9MlyDWCDU1qxc=;
        b=ZHnTGP2AyzQuZgLpspKNWt7A6A/SwIWanJtA486grebPjbRb32eU9PMCyqzqd9tJd/
         KQSW6V2T7bdCS8nNATOPBe7ifgfQbROXnHpeyhi3/ol2zcQodsNSt4lJNDoeq+pPY1AK
         To2vhZjJOrvYW7IzzD5DoWuI8mjaPjDGAfx4DmmG4lZqt2Mu0LyS0GmdtaWiIqvBxOUE
         noFRhakPnvlDoBl/4SiNSKNOoSjMFhQIAC62lIzvYeReNlKBVs7NMov3lUClbRtt23O5
         C9kvIICNdXwO0SO6boplAFu4Z9qzuu50TBJbxsbFWASt7NMipbfPvzOUVeJazDWmah+5
         ESLw==
X-Gm-Message-State: AOAM5331MeE1GqP8wkL9lHB6qM9MkAq8xMcHR1QZrAudMBrb0gl+U4GV
        RSN8YvX2Sce2ouJFnvvkWcAg59MR+cqt
X-Google-Smtp-Source: ABdhPJwDswq9ClQszcetLtcvrdOXh5MPugFPoy6/mH75vcuJfuxAQxPW2X2rt3RArOel2TjhEg90Xw==
X-Received: by 2002:a63:5f8b:: with SMTP id t133mr10581594pgb.238.1600074726186;
        Mon, 14 Sep 2020 02:12:06 -0700 (PDT)
Received: from LiHaiwei.tencent.com ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id m13sm8765179pjl.45.2020.09.14.02.12.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 02:12:05 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, lihaiwei@tencent.com
Subject: [PATCH 2/2] KVM: Check if __pv_cpu_mask was allocated instead of assigning ops too late
Date:   Mon, 14 Sep 2020 17:11:48 +0800
Message-Id: <20200914091148.95654-3-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
References: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Without this patch, kvm_flush_tlb_others is not called. We can always check
if __pv_cpu_mask was allocated and revert back to the architectural path if
not.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kernel/kvm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7e8be0421720..3c6c516d9828 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -553,7 +553,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	pr_info("setup PV IPIs\n");
 }
 
@@ -619,6 +618,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	struct kvm_steal_time *src;
 	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
+	if (unlikely(!flushmask)) {
+		native_flush_tlb_others(cpumask, info);
+		return;
+	}
+
 	cpumask_copy(flushmask, cpumask);
 	/*
 	 * We have to call flush only on online vCPUs. And
@@ -652,6 +656,7 @@ static void __init kvm_guest_init(void)
 	}
 
 	if (pv_tlb_flush_supported()) {
+		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}
@@ -800,7 +805,6 @@ static __init int kvm_alloc_cpumask(void)
 #if defined(CONFIG_SMP)
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 #endif
-	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 	return 0;
 
 zalloc_cpumask_fail:
-- 
2.18.4

