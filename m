Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6320D6DBEE4
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDIGaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDIGaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CB658F
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54c23fab905so69822237b3.14
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021817; x=1683613817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ft5inxy0lJvedl+lPTjf7i3whkyMGzHS4NcUWxPl25Y=;
        b=QV7wzIU5pCtht+TkpvyOKA/ql54F5l/+2fagC3lddXH27BxlHiXuW/gG7zO5iVMQgi
         iTCsuDMFi/upLr0XubVqPWLAYt0YXJOncS2Habgixny/UvIiwLJdPOAdBl/IlRGTw4aR
         9AjS8dUUAP8FOR8o/bvK58RnrRbsYNrr6PPm1JitfQ8Xd7UDMlpuno0/zyJkWaNab6Fv
         WeT/p+2VP9XESL0Cqq6WLxiDuL6ecmZGINKAGSn/PCzYl2LAs+0RjJZVBC958rnhZ/jS
         bU2rgQAZNG0sETQG+i/xXDrWRo23sxMb9Yytu+RMFXJ8qbtLwPT1MtEZ4Vxj1dI6gsYl
         k71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021817; x=1683613817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ft5inxy0lJvedl+lPTjf7i3whkyMGzHS4NcUWxPl25Y=;
        b=4wQ9HfhbeoW54dAzCY9sWw7iIcPfifNa/Q5Dx8x6n09bbKOCgSDmObR0vzg0SoZMDS
         gzi1HM6FmzKLNQoJQXsr1GAAGwR8PQ4fVHGS1cFC3kgBi4uiOFIpEZ/KsVribuwN7c1k
         H4dq63BrrrGsFDB+13gpFRiMu/HS/olX+qVguAhGpMwE3mIgFTAuQU+S04QEvHfs+MZn
         nuY2F51T5baDZmG3pj7T+ahAGhAyvEtmXInsEDZIdzKr2Yto5XtsjWS9krNbtFPwNgmN
         uG3M+YoEbFAbY63xnBy8wVYE/8zP5hCJti9FKLDtRCrzeFEkxdrTEY9WqW2AQokjRurm
         XmtQ==
X-Gm-Message-State: AAQBX9c7ahpWgly/rqJJmJxWuTaod0BSKF31PTY1a5HJk0glHw3xyT1b
        Cy3fMvsZFgL/yt4RpnjvalBzGDgcRlqkDQ==
X-Google-Smtp-Source: AKy350bL5vb7HvZVGmm/f6AMNzePowoZYI1Dyh1rBEB9ygsfZ74CWgH3j3bf/PvtU11XBlL3GA068hTaFrv/PQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7e47:0:b0:541:8ce6:b9ad with SMTP id
 p7-20020a817e47000000b005418ce6b9admr3979422ywn.2.1681021817250; Sat, 08 Apr
 2023 23:30:17 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:55 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-9-ricarkol@google.com>
Subject: [PATCH v7 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0ec..c6fa634f236d9 100644
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
index d255964ec331e..897b000787beb 100644
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
2.40.0.577.gac1e443424-goog

