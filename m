Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7E6B5308
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjCJVnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjCJVnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:15 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6578C13F192
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:53 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s20-20020a056a00179400b005c4d1dedc1fso3480888pfg.11
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fdbxG5GpH0K/7Izu0jZcu7behH1nknXGGfDqpmCDcTg=;
        b=XG0L8i7ah/Iu/HKllVebErQ6thJaZF1/Shz/kB1qXXDilVer49Tjj51tL+MniidrsR
         8XHkwnDIeVNF3OZSE2UE5rmWJyNLepxv6/huhfW3Kye//acGWg06Yhn+Z4tfqpTsDJfI
         TaulfprRLtbDI2a/A4m2FgQ2lr1Kh3AKNfbi+PbDjwBZuAsL87FLs1Fl8ig+QHg42jHf
         nK4MQeLvwOXRmBrabw4/bvy6lRp+Mwo8l9swQcrbCmNCqbTJlIVvX2TU5sXliYl48Wzr
         VmrqV694+LCash1PIsVSYG9g+jcdqvWJxnzlRXjVEHwS9i5/pDKJ+B95lI4YQTWHAbv/
         Z1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fdbxG5GpH0K/7Izu0jZcu7behH1nknXGGfDqpmCDcTg=;
        b=05/9Z5gfG3pKqtSRAe88DsbFE8aQj1Kv71NkvW/1nFz9g2ahL43+U8p/+prIO+Et0P
         8B+KirnOXkr5P9f2Gq7JW986Lbyn5ozdgppcGCWyl4mw/53QTfKWuAd9g6FijdSGAB68
         /inE3dPgh4lgfC8Vzu8lhPcZpDO25VgkfsCxkVZT1pOEWr3vfIrm4vISEQVxIHLDiJSE
         2V756xE7XNhXeldItgzli+iyHmlfk1G7KgaDgeKykdCcUlwSkhcZuSH48K6bffbvbgZz
         48bzfh+6hlOtfSZeOeEcAtlCg0zervVLhOkq48IzfCJcAMeuEVS6jZtctT5NJ9yqiyBt
         A5WA==
X-Gm-Message-State: AO0yUKW4bYZ+GkSDiLhdTCO7eGNBQcrrRIjZEqNCxNBAqDZDETL7IPsf
        gCOGnn9sl4LOliYHiSgEKbjeT2+X0Gw=
X-Google-Smtp-Source: AK7set9CLo4PKatBwdy6m0oPx6Rwt2QGsNA2RKyZIlnlw1wR4hg4/olHWzALmkcnVLkyUIIv0nbYhOHkGxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7356:0:b0:4fc:a80e:e6ec with SMTP id
 d22-20020a637356000000b004fca80ee6ecmr8808019pgn.5.1678484572922; Fri, 10 Mar
 2023 13:42:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:22 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-9-seanjc@google.com>
Subject: [PATCH v2 08/18] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Assert that IRQs are disabled when turning off virtualization in an
emergency.  KVM enables hardware via on_each_cpu(), i.e. could re-enable
hardware if a pending IPI were delivered after disabling virtualization.

Remove a misleading comment from emergency_reboot_disable_virtualization()
about "just" needing to guarantee the CPU is stable (see above).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index dd7def3d4144..f0d405bc718e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -561,6 +561,13 @@ void cpu_emergency_disable_virtualization(void)
 {
 	cpu_emergency_virt_cb *callback;
 
+	/*
+	 * IRQs must be disabled as KVM enables virtualization in hardware via
+	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
+	 * virtualization stays disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
 	rcu_read_lock();
 	callback = rcu_dereference(cpu_emergency_virt_callback);
 	if (callback)
@@ -570,7 +577,6 @@ void cpu_emergency_disable_virtualization(void)
 
 static void emergency_reboot_disable_virtualization(void)
 {
-	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
 	/*
-- 
2.40.0.rc1.284.g88254d51c5-goog

