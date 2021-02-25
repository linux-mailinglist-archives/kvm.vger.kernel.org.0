Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA3325818
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhBYUyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhBYUuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:50:39 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEFEC061574
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:39 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id k4so5231070qvf.8
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YR3IY+WMIpueE9LEL4pIDCdHoqUGSZWq7L1hAAqFLng=;
        b=jBqducYQLQxfzHyUVhCuE4Vp0SKkakWZ+oC++eZkn8uS/jxPlOdEs+vMheTPU2AG6b
         ZhBKE4f+ZOgab6OIi4GQqzLQhpzVj6xdifdKaJYkPnLiiomQdqdbQtOJyyR3TrMi79if
         w/bDxpbZ5pW6fcHtwUYslyp0dHrVpTd47U+dCAviH4lk/h35kaheyvbO0F7T1yEQ2bOA
         kyPMvx0z8psbNcNo9cg6SH8dpjGLWIETgD/G5yStwjsI1G5aQHppW0kB4mZ5JuQaFPMZ
         nZRvLNAbwvuLcRTW8TWLoCeCWjMYDR/NWuzZI2MeDMhg0fgQEuaaNZyWsjVYUPGrSfOz
         9LPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YR3IY+WMIpueE9LEL4pIDCdHoqUGSZWq7L1hAAqFLng=;
        b=eAs2YP3CvqcrOIomJIoqwaSz2CrXO1Mx7s984tXN/ecBsaJOlJEXJe3WhnZC9ElL61
         JicaiPklh7fU1lrDN/Lzu7Ved/PMYLZsBRZlMn/unWVj8Q6c/yfzZf7Avj9oNkQLIDPk
         syVX0kCD9pXnKCLmt1xL7rDtqx4Sxfu0Mq5S9gD4gzVrdYLsqoUUmJ99o826rqvrxvSt
         yrz+IK95g1YdSHU8OdZqmOT7iEoordTr0VJnIEnAZc2MuaRjpsdnil7jdoZkqN9eHgXK
         BpPgrsMx9h7vRpl+Qgwp9oyLKZRbZmpp16KAikRRRX3jNlJ2wuC9fEpSAWe8F+qoxmtY
         vDVA==
X-Gm-Message-State: AOAM530yniTCV9jkpuCFi0MmoNm3kUKIQZFtiUmx/OmPCBD8J+JrKiDT
        wB/YPgX1+6xELCIktcp3HLI3PWOaZnU=
X-Google-Smtp-Source: ABdhPJxIKiq0H74ngKlInfkQTqzfMe0U08Nx04qQaqATl1OtRM8fhF4Hm8/8MLItTALiezdi7txUKtsYkFQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a0c:f0d3:: with SMTP id d19mr4680835qvl.15.1614286118575;
 Thu, 25 Feb 2021 12:48:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:40 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 15/24] KVM: x86/mmu: Move initial kvm_mmu_set_mask_ptes() call
 into MMU proper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_mmu_set_mask_ptes() into mmu.c as prep for future cleanup of the
mask initialization code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 arch/x86/kvm/x86.c     | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f92571b786a2..99d9c85a1820 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5796,6 +5796,10 @@ int kvm_mmu_module_init(void)
 
 	kvm_set_mmio_spte_mask();
 
+	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
+			PT_DIRTY_MASK, PT64_NX_MASK, 0,
+			PT_PRESENT_MASK, 0, sme_me_mask);
+
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, SLAB_ACCOUNT, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1b7bdf47e7e..5a27468c6afa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8024,9 +8024,6 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-			PT_DIRTY_MASK, PT64_NX_MASK, 0,
-			PT_PRESENT_MASK, 0, sme_me_mask);
 	kvm_timer_init();
 
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-- 
2.30.1.766.gb4fecdf3b7-goog

