Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D1A3C7968
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhGMWM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhGMWM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:12:56 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC39C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z13-20020a170903408db0290129a6155d3cso87400plc.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NOH8R+qMC89oot0SC/08ymQAilQcWzou/O8p8abaSjA=;
        b=ErxesmfmeNt52qNZrPLa3igMDfD7mRSPnET/yqD6LS614zIwRYAaur2UP9x/TLGwyL
         OttLjx6vckVAEk9Qt+37/H0McAideQcyUiGfaum3lso37yyw4ayLx7HdRklFq+AoaAhO
         ykmOzOHtXd44p/g+7ZcGVfD40fi4R/YnwFcB40vtJ96zNRBG+5odCDyYwHzGUm6fP1yj
         oh8KoDiDmSxq1BXk/Djhepf/3FELsjtFCnKPhrzrSrXm9293zt5xobZh9VnoXhczVp24
         HGE/CI7v1Ur4Nl2rRCMWjAjNatI2p70CH7SKisrR8l25J98YQ0mv7VYtbL1tss41t+7S
         3JBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NOH8R+qMC89oot0SC/08ymQAilQcWzou/O8p8abaSjA=;
        b=jF2rPVeb5oP1KnzqrfjnyPxodvsvOR82gN/cY8S4wshpTdf2SeAxFBc2pL4IbtqyaA
         T9Ljegh4MlZW/oI3Feee40boK55PoDy57GI+Pwlr4CxUdXwgdusDy1Sp0nWUNqCgdRFp
         +0yCT3MGqgD4sfQEx9BZEwmj2EwBMaCvnZzsgSLRY3e6v7iTk/P27FyVxqik/Vm/Eql2
         aBOhS0MPGap7In6r7laXVR97rhgO166RzzxoC2mBU/2lZAwPxECQFUVifuRlXM04ggmd
         QbM2Wb67wly0Gnr/i36EtqS8LG9ePFlCcioPapZKaXMh9zDddxQzXQt/XHOFyQvvAHIT
         nV6w==
X-Gm-Message-State: AOAM531d+pRtMe4+bW8Nwf7toez8kgwrtm4mjEyUn2qe6JXFn3s7b6tO
        VmgbyKkIan7TIr2wgqksHfF4Qmbq6AcwzEA85F6dZmQE4KGlO3p5c9ystxn8RFAJgxt0NMr7Oin
        pRpbLv6+RCM/CpMyoEcSAOVHZ4LXCiaBcjHJfDCA61L6yMFwHQuu9uUu13aUwE/k=
X-Google-Smtp-Source: ABdhPJy3vpihhlg1lleHDRSun1HfD08fj57Oqbw6YeA1/tOa0FiOUyDLIa4Tt6leggULOOmAR2cXExWygRPKVw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:7ac1:0:b029:329:77f5:8ffa with SMTP
 id v184-20020a627ac10000b029032977f58ffamr6800269pfc.36.1626214204693; Tue,
 13 Jul 2021 15:10:04 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:09:53 +0000
In-Reply-To: <20210713220957.3493520-1-dmatlack@google.com>
Message-Id: <20210713220957.3493520-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 2/6] KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enum values have to be exported to userspace since the formatting is not
done in the kernel. Without doing this perf maps RET_PF_FIXED and
RET_PF_SPURIOUS to 0, which results in incorrect output:

  $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
  $ perf script | head -1
   [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1

Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.

Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 3 +++
 arch/x86/kvm/mmu/mmutrace.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 35567293c1fd..626cb848dab4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -140,6 +140,9 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
  * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ *
+ * Any names added to this enum should be exported to userspace for use in
+ * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
  */
 enum {
 	RET_PF_RETRY = 0,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index efbad33a0645..2924a4081a19 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -54,6 +54,12 @@
 	{ PFERR_RSVD_MASK, "RSVD" },	\
 	{ PFERR_FETCH_MASK, "F" }
 
+TRACE_DEFINE_ENUM(RET_PF_RETRY);
+TRACE_DEFINE_ENUM(RET_PF_EMULATE);
+TRACE_DEFINE_ENUM(RET_PF_INVALID);
+TRACE_DEFINE_ENUM(RET_PF_FIXED);
+TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
+
 /*
  * A pagetable walk has started
  */
-- 
2.32.0.93.g670b81a890-goog

