Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1E253F214
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiFFWVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 18:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiFFWVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 18:21:12 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BC06D871
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 15:21:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso3160346pgc.8
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 15:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZKvJKacIZPpFbnd53bS1EL2rZ1vkQiMgyn6fonmD758=;
        b=Zr9Q8V4nfUck7UMPiqqnChLoKCpFiU004y5VHpcxyH5mWHlhwIzYxUURvWJBq4dUhI
         PEflFN4+yWiPedkxFNguL6KLVrX7tdllycYtTzVDtLTM5fSldbL5YGtSdvQhicV/VqNC
         W9LyO1FZ89oe3glk7cppYh1QOUL7GWHvzV40mkYxY6Ot8nmOdZ1BmyJNi7r9lWo5/W5N
         bMn6eQ26xiiSsDdv1sGuFTHXiFY4OC6CrIrPysYNh3IdjDsmHyydvK25MNicujeQ5HDt
         CqB1bPPFGYC0qLNs/TbMrK22nRwsnULJfjNvc7HFOqj+269yjI72P9tp9IKYvoEk/5A9
         jikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZKvJKacIZPpFbnd53bS1EL2rZ1vkQiMgyn6fonmD758=;
        b=i0mmwKRzYUzwEq3vPRt+sfEyk+0281HcoIpxImlHIwKnRZr7REJxdIQ2e17EeUtdT2
         URCu9IlZFS/e3KGWx4jQJgbiEIzsKTvcChyGkkyIWEW2M3KhiWKRQcVxB7o59K5O5zdx
         tf6ENOTsUd+QTG8PMKzROT2LOO8pDCzA+KDCwejnhIwEk9nQED0W/nahb28Aw224YTuj
         6zEgVVb7aaW+K4UzRz9OHxn5SZbSvnZDXoeqO2AC+Dpxo1i7TS0WNqi8lRGnegwhaXJ1
         6ZvRQNl8rZceGCZt+atLeiV8aVa+6AhDWuaOAIz35Ry1eJYy+uhYD8FBLZSdKgaFh4th
         ySBw==
X-Gm-Message-State: AOAM532oQr9Bf3HQtRX8P7rfbHM1GvVfEoJlGxtOODcJJmpOJA46eOvd
        iUZbLrR2ikIifIULjxGcxMNWK+PkcE6a301z
X-Google-Smtp-Source: ABdhPJydFOJZXIlcEjQkgSriWABs0ECYT0csN/ZfxbgjEAFbaZOYZU1KL+PBDU3VaJNjamZ58gakzobgmymrjjXn
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:1650:b0:1e4:cff1:5a86 with SMTP
 id il16-20020a17090b165000b001e4cff15a86mr28806822pjb.30.1654554070851; Mon,
 06 Jun 2022 15:21:10 -0700 (PDT)
Date:   Mon,  6 Jun 2022 22:20:56 +0000
In-Reply-To: <20220606222058.86688-1-yosryahmed@google.com>
Message-Id: <20220606222058.86688-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 2/4] KVM: mmu: add a helper to account memory used by KVM MMU.
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
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
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

Add a helper to account pages used by KVM for page tables in secondary
pagetable stats. This function will be used by subsequent patches in
different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 883e86ec8e8c4..645585f3a4bed 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2246,6 +2246,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If nr > 1, we assume virt is the address of the first page of a block of
+ * pages that were allocated together (i.e accounted together).
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
2.36.1.255.ge46751e96f-goog

