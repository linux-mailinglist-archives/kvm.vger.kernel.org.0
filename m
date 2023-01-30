Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12C5680595
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 06:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbjA3F0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 00:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjA3F0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 00:26:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD811B562
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 21:26:07 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so3408116pjb.3
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 21:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abPSnJ0qv/HtIbkQ/vHjvIngKoYVy2ykGn7xdx2ilGQ=;
        b=L4XOuSnAQ7emyELz/pa59zwrXSfRDQ2Jj97bcn9ceG0qRT3A3x3oV0xi6K6b6OdYfJ
         BFL3g6sm0gmGmLk+wKqCN2+eyDCDkq6dtJPst6j70AL1Zom6DzfR8vxGfAnJlhNm4qSx
         AXGuTWD3vxQdF3B7OYhgEuKOOtfRJFLLqi1yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abPSnJ0qv/HtIbkQ/vHjvIngKoYVy2ykGn7xdx2ilGQ=;
        b=uP0a1A+t4LOSiXtn7BHdokbE86d7+7qkh0X9JThErKe9dud4LmlQ27sRSDrlXDKglI
         fcswmSk3nmPePVbsS2SFU3iwnHaOxWdsOaHPrxVEhBV6aSJNP2IgtpmSFZNu2uDW4dFu
         KHWzd3uych6DVm4rSSSMczfOprN8SpH66x9ILKOda5RQsX+jBsExAfKxXXOdhFYc09qG
         HREZ/QuAwOGz7mAv8uH5oGqXMbj3smhSJ1OoCapdP01rjoGhlhZv8qYH00JkzL7pLYGM
         9+Fjag0CWbCycpZF5ix3/oS1bjSuaEjl25iVcbbczS0oad9A6GyzmvT1OmeF2FiXEphS
         erOw==
X-Gm-Message-State: AO0yUKVHq7qIW4WsTdcbrgfAXFBf87UYxvBAJ0PbXBCpU40+FmeCanac
        dbDwSmS8Tp6Hp/IPopTdi3FSVKD7XYocEO5V
X-Google-Smtp-Source: AK7set/J85qx/tkKLqmFXicwMirou4KQJvFb8Y0criYYiN9RQH6TDnqnu1sUOsYrVkGaY6nq/6CfSw==
X-Received: by 2002:a17:902:ecc1:b0:196:3e2c:4741 with SMTP id a1-20020a170902ecc100b001963e2c4741mr18360112plh.12.1675056366681;
        Sun, 29 Jan 2023 21:26:06 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:d32b:fdeb:5b29:c9c])
        by smtp.gmail.com with UTF8SMTPSA id n12-20020a1709026a8c00b0019603cb63d4sm6677372plk.280.2023.01.29.21.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 21:26:06 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 4/3] KVM: x86/xen: Make runstate cache gpcs share a lock
Date:   Mon, 30 Jan 2023 14:25:19 +0900
Message-Id: <20230130052519.416881-1-stevensd@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <2d421cb18dfa1b88e5025f2f9b94e146c0858960.camel@infradead.org>
References: <2d421cb18dfa1b88e5025f2f9b94e146c0858960.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Simplify locking in the case where the guest's runstate_info is split
across two pages by sharing a single lock for the two gpcs.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
I tested this patch with xen_shinfo_test as suggested, and it still
passes. I agree that it makes sense to do this as a seperate patch. For
the bot reported issue, looks like I forgot to build with lockdep
enabled. I'll fix the issue with that patch in the next revision of the
series, so that there aren't any commits which don't build.

 arch/x86/kvm/xen.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index fa8ab23271d3..9251f88a4e0d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -310,24 +310,10 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 			update_bit = ((void *)(&rs_times[1])) - 1;
 	} else {
 		/*
-		 * The guest's runstate_info is split across two pages and we
-		 * need to hold and validate both GPCs simultaneously. We can
-		 * declare a lock ordering GPC1 > GPC2 because nothing else
-		 * takes them more than one at a time. Set a subclass on the
-		 * gpc1 lock to make lockdep shut up about it.
+		 * The GPCs for both pages which comprise the guest's
+		 * runstate_info share a lock, and it's already locked.
 		 */
-		lock_set_subclass(gpc1->lock.dep_map, 1, _THIS_IP_);
-		if (atomic) {
-			if (!read_trylock(gpc2->lock)) {
-				read_unlock_irqrestore(gpc1->lock, flags);
-				return;
-			}
-		} else {
-			read_lock(gpc2->lock);
-		}
-
 		if (!kvm_gpc_check(gpc2, user_len2)) {
-			read_unlock(gpc2->lock);
 			read_unlock_irqrestore(gpc1->lock, flags);
 
 			/* When invoked from kvm_sched_out() we cannot sleep */
@@ -427,9 +413,6 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		smp_wmb();
 	}
 
-	if (user_len2)
-		read_unlock(gpc2->lock);
-
 	read_unlock_irqrestore(gpc1->lock, flags);
 
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
@@ -2056,8 +2039,8 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
 		     KVM_HOST_USES_PFN);
-	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm, NULL,
-		     KVM_HOST_USES_PFN);
+	kvm_gpc_init_with_lock(&vcpu->arch.xen.runstate2_cache, vcpu->kvm, NULL,
+			       KVM_HOST_USES_PFN, vcpu->arch.xen.runstate_cache.lock);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
 		     KVM_HOST_USES_PFN);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm, NULL,
-- 
2.39.1.456.gfc5497dd1b-goog

