Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC162759CD6
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjGSRyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 13:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGSRyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 13:54:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2645C1FC1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:54:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5707177ff8aso64378487b3.2
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689789244; x=1690394044;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0kxZ4Z80lUcSFdp3GgQl/jQwBGNAtEogOtDD6DT+le8=;
        b=NdNKIYqEldjUUQV4h+XNM1ILmBpma9z9AEdBtYn1qcrFOenwJmBXrHw6mTbkprQj8p
         r+YtkbikqlLfJdQZIoTiQv/TZpBxRXEg0gSoK35Ky48bcLRFCn0Qj0DsnXRublL7LccU
         VbZhu6d+zj+n5OuXYLNNjo3SaPP6NC8/yNGWRhVbEHVJlHuLX5Gsll/rQ8aLyHWCbZUs
         /8pD6jrn0k0jGKj8o91kas/Vof7SZ7T7M6Y8JVFS9L6EnZODlq5wuOfEPi4IxaVWx6IY
         g0cXiBg3AzBUjksD04dElZ9FVrB9vd1h8Wu2ap7UEulstmwA86OoTJopktyhvQXeMD9s
         GkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689789244; x=1690394044;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0kxZ4Z80lUcSFdp3GgQl/jQwBGNAtEogOtDD6DT+le8=;
        b=LIC9xQgup/l8fkmUtWoTtWwcwaIfZMsc1/VeEsxNceSjiDbsuz2+5PWhFSFPf75XFq
         YZilsf8yjl0xlyatuUUp6FJwWU2QQbFOTnRfmpRFLfzfeTsFyYNbyJHZHqL90PjweDGR
         DtEAZ/DWKVAxAiEj8mS3RslO/XWFES+X04LqnElAZGkcv0Q/jm3BeP6DShtpUYG7dA89
         pP0ZKNRNsci/S0+TrbH7+6xUGyBoJn4+ZXAc+ER+1WsCZGGSs8vG+p9ReB58x+AkGHJC
         ghC9Pg5y+RiqcQVNvI4klS5zaQ0VvOGfFubVPXCS5EyfS8ZUELASlOcDxYnXSvmWNpeX
         qdOw==
X-Gm-Message-State: ABy/qLbxriLZDMwCmY/l+oz9jaHBJkgWRlK6n1lL9onMTtZXetScy8u6
        C2aRfPtfBKki+oWlJJNl5MC8nqdw4HcP
X-Google-Smtp-Source: APBJJlHzC655GgaoeeexqmchzYWVTbKP9Ygbn4QXSHn76tJOWPJ5nIAjVrvG3mrJnq+Ot9jVn2qgg1kU3KfD
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:d00a:0:b0:56d:502:9eb0 with SMTP id
 v10-20020a81d00a000000b0056d05029eb0mr34446ywi.6.1689789244409; Wed, 19 Jul
 2023 10:54:04 -0700 (PDT)
Date:   Wed, 19 Jul 2023 17:54:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230719175400.647154-1-rananta@google.com>
Subject: [PATCH] KVM: arm64: Fix CPUHP logic for protected KVM
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

For protected kvm, the CPU hotplug 'down' logic currently brings
down the timer and vGIC, essentially disabling interrupts. However,
because of how the 'kvm_arm_hardware_enabled' flag is designed, it
never re-enables them back on the CPU hotplug 'up' path. Hence,
clean up the logic to maintain the CPU hotplug up/down symmetry.

Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..010ebfa69650 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
-
 	_kvm_arch_hardware_enable(NULL);
 
-	if (!was_enabled) {
-		kvm_vgic_cpu_up();
-		kvm_timer_cpu_up();
-	}
+	kvm_vgic_cpu_up();
+	kvm_timer_cpu_up();
 
 	return 0;
 }
@@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		kvm_timer_cpu_down();
-		kvm_vgic_cpu_down();
-	}
+	kvm_timer_cpu_down();
+	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);
-- 
2.41.0.487.g6d72f3e995-goog

