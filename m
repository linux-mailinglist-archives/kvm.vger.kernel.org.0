Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F623457B63
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhKTEyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbhKTEyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:32 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BF1C061756
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j204-20020a2523d5000000b005c21574c704so18828504ybj.13
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/oTaTNiB/LMk2r2BJ6BITqZh/xo7HcDPFHBzIC0aTcA=;
        b=WPlmQ7dQuJ1uI7rACN8ZUhfdEkZLX56UEjuNndMAQ3iodLsdQcL9W/dj6HIkAGfGWg
         gE/UXDx3nWZbpHuu/aKvd0BGF8Y4CZ2BlEA7MiIfyuqECWbUdflK4LGxOxWqxQvvKpQ6
         EQVb4iBn2Gx3tRIGBPzUvT7iWhRa1w8r3TgtlS/UWtpXedFuOfvUyhfyme3M40LIJZob
         TXrNtbo+dAE6JJVTciDHWD8Ic0AGa1fsGvhWwui5iozvPpNxdk/iGU+uO8LziEPfCEd1
         NkCtk3cMnlS1TSIOGe3/yzyzoPQknV+KE2gPFW6CCG1Eo5s9Tbqb93RJDQtnxPXJ5rYV
         3fpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/oTaTNiB/LMk2r2BJ6BITqZh/xo7HcDPFHBzIC0aTcA=;
        b=v5z0OPAAQb5f/ifAEPJ7gWX9qe/RHszYQGy6PL2D3s4bIryquostAgJ44TJ+Hfu9Al
         apRUtdy4YsSWlfP9MHkzkYEFSrXbxMWnCKB3Vyn+i2w7LtfqzURTGibl/lKp6SIH5hPu
         YgK1lfJDGvSA1YQ5lqhJwG+gGY4USz3ri0GTNGr+iwpzrYKO7srbPUi1iQ5XiCzi4XEY
         U/kUfplGhqsdDdygDs2rWEMy59VoHHIqp2HgO3jtUYZ9pJdNqwL/KvuFaf3DLPArV3cI
         OWcGZVgvouFRZq2wOkR5jSjl24VoWdh/l3PRDaYF9YiiXa8Ej2SGxdYuOrFSQcFShB6G
         hOhw==
X-Gm-Message-State: AOAM5304xe2GyYXy5g3fXT8rM0hj/m5+GlaRwG/tbN+8pbtTRinjQoaZ
        toX1amYKF6NLCXpy7JKquxh+LZ1JvCA=
X-Google-Smtp-Source: ABdhPJzgMlxyALCEHUJnE+SUDIlZ0c3NP8y3yVfZGng2q/E/Do8yiX9PzEsWyaZAw1I4pV2C4IaOmjDRQYw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:d4d5:: with SMTP id m204mr47930487ybf.418.1637383856477;
 Fri, 19 Nov 2021 20:50:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:19 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 01/28] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU
 notifier unmapping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the yield-safe variant of the TDP MMU iterator when handling an
unmapping event from the MMU notifier, as most occurences of the event
allow yielding.

Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 377a96718a2e..a29ebff1cfa0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush |= zap_gfn_range(kvm, root, range->start, range->end,
 				       range->may_block, flush, false);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

