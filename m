Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5FD5856EB
	for <lists+kvm@lfdr.de>; Sat, 30 Jul 2022 00:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiG2Wnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 18:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2Wnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 18:43:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822918C5A1
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 15:43:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m123-20020a253f81000000b0066ff6484995so4812827yba.22
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 15:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OeZZWvdh82N6iL4lq+61htCI+mNsngRP+8WrJM8iYKA=;
        b=ghgA8pxOghYMZvBzAKNHKfpBY4akXFzFR5QlBQu0h9LhKDiY6OIFHE0Yv3cVVk5PL+
         BPqvIEeIsgZhmgHEdXvIAA84nIX1mSjtTKygIO6EaUEzXMr5nHvu/e7llCTV60EMJ2ix
         2sUmSH0y4GJAvhlm1CGaPey4SqVUOH/OjG7+xknJpYP8/gFRJoMm2h6mRDX+8YqJzFOS
         T4toJPZl9EM/0+Dlrzppy7Y89WhhqftkrJa1m+jrN7NwfD+qMAZV9P6UuX6p9zT30jna
         vQlF7ienYdfFMiPkiyMyMoq81v7blPIFSVfbD1LJZEtUb/xvv6j7Xvv7gKpxr6/USNla
         yXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OeZZWvdh82N6iL4lq+61htCI+mNsngRP+8WrJM8iYKA=;
        b=k/nkl+A53gbfO2SLZnZJWd10/yYI2lIECYi3lk93ELB9zipvNcMWQbOA20Ete922Gk
         Jh9QCpP6e4Y3UH/30moJCZtKWWyPwg9TbXlhL1R4BRLzdZoMe9sLO4fKBybYjtPcHMAO
         M2SN8AiAUZA9DwD1YVRw0nPqHVosA9hwfqoz3GvrGt1UuWASJTXYuzj7CaS3UiSZ+Q2w
         0ih4P2u55Bl6InFqDRMu8UtDbf7RUk0LzGImbPsCJpPtcnefwNs8QuJEcsQo66slORyR
         KHaxc8YQZBKnpWF4Ug3ShpIuj04rTsk/rBskuPoJKiRx3RhVWeSdYQWZNkmljG+JErrg
         4H1g==
X-Gm-Message-State: ACgBeo32qsrd6WYVYPdfZUlGsrHYolNcQAje9b2h6ubw4ekFZ7Mn4K+o
        Vc5cT491wvBGbsb0N6AB/eTX0hEWV08Te2avArJA73PqKBj7/FQx+ME/gYLeUU/gGN3yLP2Z6wo
        CFzX2Ax2Da74pJyYh3kJi5cVQFJ7a1zB3EibRf3RjJec+8P4tqFp/ux0XNNL0
X-Google-Smtp-Source: AA6agR5Dvj+M0eXvxsog++oluj+Q1gQm5EvLJ32ev8pf6Gm0gYLhLCJXSyGt9tsZtIKsKyTUrD+NQXrQT27j
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:ae07:7e0e:8132:a470])
 (user=junaids job=sendgmr) by 2002:a25:80d3:0:b0:66f:5da5:204f with SMTP id
 c19-20020a2580d3000000b0066f5da5204fmr4353399ybm.30.1659134613718; Fri, 29
 Jul 2022 15:43:33 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:43:29 -0700
Message-Id: <20220729224329.323378-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH v2] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, dmatlack@google.com, jmattson@google.com
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

If vm_init() fails [which can happen, for instance, if a memory
allocation fails during avic_vm_init()], we need to cleanup some
state in order to avoid resource leaks.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
v2:
- Moved the vm_init() call earlier in kvm_arch_init_vm()

 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f389691d8c04..547e55d6b662 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12029,6 +12029,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_page_track;
 
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto out_uninit_mmu;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
@@ -12064,8 +12068,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
-	return static_call(kvm_x86_vm_init)(kvm);
+	return 0;
 
+out_uninit_mmu:
+	kvm_mmu_uninit_vm(kvm);
 out_page_track:
 	kvm_page_track_cleanup(kvm);
 out:

base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
-- 
2.37.1.455.g008518b4e5-goog

