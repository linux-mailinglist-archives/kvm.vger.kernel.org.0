Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DB73FF8E3
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 04:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345804AbhICCiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 22:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhICCiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 22:38:19 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56D6C061575;
        Thu,  2 Sep 2021 19:37:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q68so4088274pga.9;
        Thu, 02 Sep 2021 19:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=pvnZY5mm0UezB8MEgdPnD0hyXPavTNaGp7d3rKDossE=;
        b=XjBHgaPSRhh4Qj4iqSij3ueZOupdr6ICtQz/6Qfvdu3xWkGTFpm1R73SBevbBmWf3P
         2L/IimBwYBPCSF0MdefLxHUDlCgmb0+PX4WT+ot/iNWlEGaQnN/uCiEPtyUC+eG1xGAU
         P9WBFrs2DqStp6X6XThYTnbi0OYEl4VJLcbyZkKFLysfb7R+6+mi/crubBUUUA+JwfAo
         yi8sr/xihXcvun6zq9RLW6LmpEFQx3RjvUMyEdJ+Jjonvp7NYItqn+lF7XO8ADPIuJz3
         wQ8et50mBL9y/zdw0hlot+u+KQZwfRVmDeS1sp4lmEx6MZyThhRQlcbKHy3VBH3EQm+0
         DF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pvnZY5mm0UezB8MEgdPnD0hyXPavTNaGp7d3rKDossE=;
        b=Cx7rlOqLhybOJK9kjDri1QSu0y/ZMhDlWYUfjiS8zBWGxuHLgc7ZpB3pEVh46LT30y
         lu3SY9fExPozmvMVZaWnh7fXLU+rRaUiuuzRSJN1TyekZEfyA9tzTERzEdxrk+1I6yFa
         iLC7ZnSfpcytIGg/HIAw1JBi7Mbsr3+4wSrlTb+huN19StrdVp3+DMBmjWGcF77vMgAB
         gWLc3MjRY/ac8Eq7aniwttlVZ+ZE+WZJz35k61mgwJhPz1oSdSnKQ44aZGgi3/ubD48q
         RSCq4xkhFt4W3xSlyOCALq1Ov/bZt/9wyerNdxbIxUqP1VXHmzdFjtn5/ohWi0+IUf8M
         yPlg==
X-Gm-Message-State: AOAM532B53eUrDNmB2IaKiYksvxkMVxiYLyHaCCC4Aj1ABVw2MpivrLK
        CzqAADv/Y7+eOGQO9w/ib6U=
X-Google-Smtp-Source: ABdhPJzh7/+jToUiHx+YFZS64mSgUJA4U0bW2LOQWhLlqs5FkH878j5T4xbtD9Vg8NR/DcufUAo1Vw==
X-Received: by 2002:a62:7d84:0:b029:3b8:49bb:4c3f with SMTP id y126-20020a627d840000b02903b849bb4c3fmr1225262pfc.49.1630636640451;
        Thu, 02 Sep 2021 19:37:20 -0700 (PDT)
Received: from localhost.localdomain ([162.14.19.95])
        by smtp.gmail.com with ESMTPSA id q126sm3452214pfc.156.2021.09.02.19.37.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Sep 2021 19:37:19 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH v2] KVM: x86: Handle SRCU initialization failure during page track init
Date:   Fri,  3 Sep 2021 10:37:06 +0800
Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

Check the return of init_srcu_struct(), which can fail due to OOM, when
initializing the page track mechanism.  Lack of checking leads to a NULL
pointer deref found by a modified syzkaller.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reported-by: TCS Robot <tcs_robot@tencent.com>

---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 arch/x86/kvm/x86.c                    | 6 +++++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 8766adb..9cd9230 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index a9e2e02..859800f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -170,13 +170,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
 	cleanup_srcu_struct(&head->track_srcu);
 }
 
-void kvm_page_track_init(struct kvm *kvm)
+int kvm_page_track_init(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
 
 	head = &kvm->arch.track_notifier_head;
-	init_srcu_struct(&head->track_srcu);
 	INIT_HLIST_HEAD(&head->track_notifier_list);
+	return init_srcu_struct(&head->track_srcu);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1..9a122af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11143,6 +11143,8 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
+	int ret;
+
 	if (type)
 		return -EINVAL;
 
@@ -11178,7 +11180,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
+	ret = kvm_page_track_init(kvm);
+	if (ret)
+		return ret;
 	kvm_mmu_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
-- 
1.8.3.1

