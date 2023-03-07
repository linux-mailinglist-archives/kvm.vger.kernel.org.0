Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613A96AD5DA
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCGDqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCGDqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E722D4FAB3
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:10 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w192-20020a25dfc9000000b009fe14931caaso12761325ybg.7
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBDy+pBnHpjEjOCFqtKXk+f++U9hV1b2BXNfwFPUaag=;
        b=H7twHRZ0Fi9DJ14Zy8DaC/l7qXIcrc7PT56MNE+bCMUTxeLv8I65uGeWLj8QpdNvJ+
         zemUHTJ78+a3AzjBsLhyfqnnBx76e88kG1KI22k5JrTGuTd11HiyHM/DvRR3Nn8sAGky
         Qt2vuEg8ydatRajyCAdtzbeAkC0sxkHdqPeUdUhL/127nV6LIMjzDsqPPDKH4kk0Pk4x
         mDIy8miFlHg0JMsyW5O95OfLarVmBLAKEAr3oyWrScx/Jw6z0WDIdVWOAnRBmxjDAfl8
         mACzfVldnROI2cE2YPdRTbc5TQuSyzOSxLeyQo7KeoI0fFt7zTFIktknzUoVeE32JQ9d
         K6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBDy+pBnHpjEjOCFqtKXk+f++U9hV1b2BXNfwFPUaag=;
        b=hCYDw52cu8L7fjBAhx28fEWwRL3wm/+OM5+g+gkbBoSFPLHiZb8/27TRmZAB17MVXK
         MuE6SNhh8eW2/2hTOM9SxpH8uceDIPAvkqEWZQ3iUr9StNAbDCSWKn8zt8TuFFz9YlcU
         oNnRklPgAHzmhyJPaei7m/TtUQ+L0m92+X7NJkNTzbfRb7VD+dMmfaj+xXqcCKWTz5QM
         qBM5XRO1s4Cy2UdyHH0TutpWAyvKl0GmjmhUqfs+jDCCymIEiI8HpwbeSbuxPsOOjzAU
         Nn+v0a8HnbYJ5IuW+b8vJ+57Jabp5ZBOyCpYiD1Q1WeQBBjK5yDAsOZ7CPvLp1PMpydp
         ACVw==
X-Gm-Message-State: AO0yUKXROR9IsRizeEt7IoEP8UKG3iETprt5euqiOTWoTLUZMUrV1Xlw
        SOyoG+SWvzjuMkxo9oO0FQXmcrvbKskx4w==
X-Google-Smtp-Source: AK7set8nUDspX8xTjKFw9UYAbj4P+7S+kz0/D8p5Y20QEe03+fM7j9/RdaMzpeW987uC+6YHWSiaUyuxg3HoCA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:40e:0:b0:ac2:ffe:9cc9 with SMTP id
 m14-20020a5b040e000000b00ac20ffe9cc9mr7832529ybp.3.1678160769764; Mon, 06 Mar
 2023 19:46:09 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:50 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-8-ricarkol@google.com>
Subject: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..c6fa634f236d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -990,6 +990,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..897b000787be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4596,7 +4596,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

