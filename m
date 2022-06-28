Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4155F0E7
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiF1WJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiF1WJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:09:48 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7D9340E3
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f9-20020a636a09000000b00401b6bc63beso7287156pgc.23
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hqFBlBT797q6Bk+fNjYVKQU7mV5jV3ma9qnt5KK3uBo=;
        b=JEAq+g+yt98HJQFYcbZo11EgdQCrTknULQcgOojyYtX5/1qIJPFoMDpUb0JvS07kBs
         UBB0lOj3a7XuYN+RxZH7OqEQNbrIbIfwbCX+Napc1EFMPMrzrqRPrpv6TLBnEGIk4l6e
         D8NTKSe14qutuJxDTg6f/mJOdQOL1xHUrqnK3PlzvOfoI2lI6HUiSSkGIdpK0f7vh6H4
         6O9GKuEoHUyXKiAyRapcd/Jdby2QsOa/y878lIAO/AkXQnUJ/iuK6p0Jig+0f5ZboxYv
         e9Ap/B7iZODIQKB3o8NbA9y6v8baiPB6zs+62vjyZxY29inV33HeqiOuSq0QsRfR0U2q
         Gycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hqFBlBT797q6Bk+fNjYVKQU7mV5jV3ma9qnt5KK3uBo=;
        b=aPZ3c3CiV/Dv5mCkTsnUm7wi6xrPp9SLqSmwAjMEdA3d05Z8cyA06NZ6sMqbibUJFa
         8cO2yUm0SkgQmRh4iV46NBG1nFrnMpmaCIxXnGFCEwa0JPR69u93fvoQmQB4pcy7R9JH
         WlPU8Tnt7dEPFsmG8YHOKXk4L1zbPDXx2NXLnJqEj5zofjhojLFka0k/qJ+YvHS2atjk
         aAUfwSE+np4FNViTnAPzerjZLH62+bqsduNx6GTeti2rax+PxZx0EhPfzrVxHcyHLwgI
         q+U6UCKZ5w5yH2pbgsrCGQTKdBPuJbGtZmO0DJuWtVr9IWlCuYtW0cp7ldxJ5hdvL658
         FEcw==
X-Gm-Message-State: AJIora/ThvZh99SW1bGXm+gQF6IGsgkdeTmgi4CAHAXyx4WOmtQJ2qK+
        r9PyB3lqkdVbiffTJkETxK5yonFKlb87CZrd
X-Google-Smtp-Source: AGRyM1smcFnstKabQ4toVMOHujMO/7vgP/k20+XUxS7A/7XLJg4mWmkTw/RyJ8/gkqU1w7+Eoe95tXVR0LKZACoL
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:15d6:b0:525:3757:4b98 with
 SMTP id o22-20020a056a0015d600b0052537574b98mr6883216pfu.64.1656454186604;
 Tue, 28 Jun 2022 15:09:46 -0700 (PDT)
Date:   Tue, 28 Jun 2022 22:09:36 +0000
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
Message-Id: <20220628220938.3657876-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by KVM MMU.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to account pages used by KVM for page tables in memory
secondary pagetable stats. This function will be used by subsequent
patches in different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b40f8d68fbb1..032821d77e920 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.37.0.rc0.161.g10f37bed90-goog

