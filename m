Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2974E3519
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiCUXv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiCUXvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:51:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818E01EA2AF
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o15-20020a17090aac0f00b001c6595a43dbso331623pjq.4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HTko+mjwSCY8/8jCHYIzXlXkhpUJFcRy2EV5oJp9m3Q=;
        b=I22SNpJTSp7u2DkXDp+DZcXecT0aJNWQsYrggepx4bKXKn5jFK8VNlPisgR9wW+gZi
         sypyACQIoThc8e16NmgO60qt1r5TdXaq4OBmHDr0wcQbVn8Ixvjf84zb0XZHVNOjcBqN
         L07M7jQJ3Dmzbwwr8ienEAHrv2B7U3dwrascuPvMrO3R+s2U10dHS0H0k/WRZu4aDo4Z
         xqqkSP7Mfc1F3HoUP89S8h+v7/104N7SfBKCakhJXwea8h7EaYHxn6B5fjTh+JEgAF/E
         CIDd/hyZ2/pOhkrneK9nUuF4MxB9VfkIxSMd4+4YS+yVFstDLqD2CXAcR0U71vwoPaxJ
         vcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HTko+mjwSCY8/8jCHYIzXlXkhpUJFcRy2EV5oJp9m3Q=;
        b=0x1LnRC2Jf/nzwwh8zK0Tot81l4WGC0J3aSDsm3D1uHIqHH+kbqD+T49UXJVxdzY9T
         GkgEBMOP2Bf1BUJdCiaDs/vee8a4AA8sw39kV1kca04+cEFECa4SmiXyj+k/rIydGAId
         JBM0AiJskIt0wm8UbDrPhcvTdtYTdkU47sWVMVNDbtvN2yUJ04ffkZt7OMMZ2gDcZBhG
         ybt+gHMIHi9/5pMH+H3A6auRR88Mwot2Rl89Dec9CkoMfq6XNjLkztqwIQAWcuUMM3dP
         +m+fov9eGD7DM0JyAMAVRdR+kpOsOBbKzXJBDERoNCwzEHI7mt2Peh2poqn1a7jI4t+0
         QF9w==
X-Gm-Message-State: AOAM530HOXiaEuHXAvbKgljGsZBi0zVKp3DnnbunXYFvJ/SUWD06gHkG
        u0g5TA5MWWk503bZFJVpHVXb+H/z/h4C
X-Google-Smtp-Source: ABdhPJwFjw1Jalvb5hnttuiMTpyg11w5RmyTkRJZ7KAWW+wsSDGUQYl/Em4/xpRB5TScQjoOEihWnCIvol4p
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP
 id f15-20020a056a00238f00b004f778b12f6bmr26325911pfc.17.1647906549813; Mon,
 21 Mar 2022 16:49:09 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:40 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 07/11] KVM: x86/MMU: Factor out updating NX hugepages state
 for a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the code to update the NX hugepages state for an individual
VM. This will be expanded in future commits to allow per-VM control of
Nx hugepages.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..1b59b56642f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6195,6 +6195,15 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
+static int kvm_update_nx_huge_pages(struct kvm *kvm)
+{
+	mutex_lock(&kvm->slots_lock);
+	kvm_mmu_zap_all_fast(kvm);
+	mutex_unlock(&kvm->slots_lock);
+
+	wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+}
+
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 {
 	bool old_val = nx_huge_pages;
@@ -6217,13 +6226,8 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 		mutex_lock(&kvm_lock);
 
-		list_for_each_entry(kvm, &vm_list, vm_list) {
-			mutex_lock(&kvm->slots_lock);
-			kvm_mmu_zap_all_fast(kvm);
-			mutex_unlock(&kvm->slots_lock);
-
-			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
-		}
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			kvm_set_nx_huge_pages(kvm);
 		mutex_unlock(&kvm_lock);
 	}
 
-- 
2.35.1.894.gb6a874cedc-goog

