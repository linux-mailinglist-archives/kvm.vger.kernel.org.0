Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50D95FCA5D
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJLSRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJLSRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D33AE237
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s13-20020a170902ea0d00b00183243c7a0fso4816075plg.3
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/LJ+bYPOjVmy5bXWpTx2anrdUeoNGY754k8mkXwTdk=;
        b=K7ewdJSMaryouSIQqqXh+tEwQj0DP7qWAXEcN0vWUDuNPNdsMGpffpcR6dlydV12Lr
         9+2ckE7nczJUyTO++zxeaEGSc/WBLOlI62yv0lHon3PaTpfT5G7zj4Pmy661k4HXvobB
         4ti4CMZQAbov6LiocNpv/9tlu6O7EahHIPCwXo1oGQlL8fiFGCX8qMhu2a4WHQjmHikP
         VWg50NzQ4N7btUZv6sh/k0vbA93kiFzN8eV0l2IFarjziZc2bvjjX+gM3BmDRmeWkBkq
         8NZxJYvvdXaCe9FhD8o6YDn5CVZMFLt5Hb6lqJisMCc+59aY8IEY0DyVXqf8tPY9NZPZ
         tlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/LJ+bYPOjVmy5bXWpTx2anrdUeoNGY754k8mkXwTdk=;
        b=ZNHgOMh1iiCifmKobdJwUlGdZH1JQsrvfG0xFVdPRfzRJhAorqOUnvJSxpbQc9Hjyz
         CcbHJF2paehZMZsLAVTr2KJguNSJGitwS0ooGapjj6x+GrLmZuLHz71qYtIKckvMrIHu
         Zmv8nBvD2wIvcWr1gBQ5vCMlfR0mYbUpJl/U1d7BzN9pWV/teLk8G624br9w0SxjAQ1b
         SPuiTZ4lgGAs+MBGdLy97qT4xq0QPDSq5m3lkt6Q1eA8Z5emthwIgtPww2jPHeeb1Pfq
         ds6lj4AzmOk9s48U3LuTQGhce09G3+ZxNOPDFCQ38BWM2snc1/SnPkOLCkCsUPTA4SR5
         SCSw==
X-Gm-Message-State: ACrzQf1rmejHwPOf8KZHn6vwLthw0oc0L3KNj4MLijoc+7u8kviRkYY9
        WYweoDOUR1L4dPvbkOfReRA1mvBAs/U=
X-Google-Smtp-Source: AMsMyM6aUnnCS0syZQAS1W2pUNJGA7rl+aN7n8C9LHWe129DVcZ/WhCwQpElYJ7gd9Pzkd5+llP8oCAuTS0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40d:b0:17f:7ef6:57cd with SMTP id
 k13-20020a170902c40d00b0017f7ef657cdmr30715748plk.151.1665598634380; Wed, 12
 Oct 2022 11:17:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:55 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-5-seanjc@google.com>
Subject: [PATCH v4 04/11] KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
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

From: David Matlack <dmatlack@google.com>

Handle error PFNs in kvm_faultin_pfn() rather than relying on the caller
to invoke handle_abnormal_pfn() after kvm_faultin_pfn().
Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
to make it more consistent with is_error_pfn().

This commit moves KVM closer to being able to drop
handle_abnormal_pfn(), which will reduce the amount of duplicate code in
the various page fault handlers.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 72c3dc1884f6..6417a909181c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3155,7 +3155,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
@@ -3176,10 +3176,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
-	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
-
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
@@ -4201,10 +4197,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	int ret;
+
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	return __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault);
+	if (ret != RET_PF_CONTINUE)
+		return ret;
+
+	if (unlikely(is_error_pfn(fault->pfn)))
+		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+
+	return RET_PF_CONTINUE;
 }
 
 /*
-- 
2.38.0.rc1.362.ged0d419d3c-goog

