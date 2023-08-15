Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1E77D463
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbjHOUib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbjHOUiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:38:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF832116
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584139b6b03so74757037b3.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131844; x=1692736644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3dK+siegY/lcPBE26gvMNEY42khfxilV1mO9bjQlHqg=;
        b=OrZw6nNj8f0nsd/1qt+U0X1Xd3xCQvB44YKCUfK0QTrigF+dnhpT9lKet46Dffuves
         aYULYfbfoOYrRNYDyhuBdMYE2xQJqGJ9XTeJnsdvpg0n/TABpQc40EGXuyB8Ly4JxnhS
         r3QIzpAjBGxlouYEZIyurPp852JBt4V5T7yRbKK0NM3Fs0ov+U4qX4xd5YUpTRBNKe2k
         e/E5UfgslO1jzpZQDdb2d1qLhko/KtPuLD+E8maPcv6ajRkrQumIeb9DDOu4AxAXv5bb
         Yjss0thyeIARTiUj6Unqxd3DbEm2reCrdesIRgz+Z6xmWFQXBup4AJAt+bRelShLGCVl
         cE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131844; x=1692736644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3dK+siegY/lcPBE26gvMNEY42khfxilV1mO9bjQlHqg=;
        b=ILdmbnnapVGDTYvJ2ifL+DFSEv0w4kzahyfQl9oPbuLROtx0ZbDPXo2NzpBwEK5A/0
         uwN00u3tl3yAP6xuswK9rMXye8gt8r/xrnaxraE3UPkfJlUjSnSy+7VxXNZkVdnR2VI6
         NtBzZTmOaeOXx2BwVw4iZCCKjPe2QLMmZd5K8L6cujav1cCBETLaCLEGv0/uA1+6437R
         5LtgPHyyiF29pECc5dY2vDcavF4BRLI/pruFGaQjiLKUJLEAnuHLFbJlbf6dxLJAvpAi
         D1MYmZMfXHQIKm6Fcecz0PRgsVmTZpNAiL50YkNh9FDrIh3AHvi/iAmiZ0TpX+eIthWV
         iyMg==
X-Gm-Message-State: AOJu0Yxl2zXJMosygDt5jjwweo9PQUzlGB9aSkt+aRaSwJj1khB8HXA5
        oUNeSR4kE87SCAIdSLTrhJdEMORFZho=
X-Google-Smtp-Source: AGHT+IGVmxZgnM/94vT7V9EdxdBjzJvfoob+eub2qtcm+uyZa4akRj6gZeoxuKQTUpT74MB8wuzHWXJ3x8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b725:0:b0:579:e07c:2798 with SMTP id
 v37-20020a81b725000000b00579e07c2798mr183717ywh.2.1692131844699; Tue, 15 Aug
 2023 13:37:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:53 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-16-seanjc@google.com>
Subject: [PATCH v3 15/15] KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM has a framework for caching guest CPUID feature flags, add
a "rule" that IRQs must be enabled when doing guest CPUID lookups, and
enforce the rule via a lockdep assertion.  CPUID lookups are slow, and
within KVM, IRQs are only ever disabled in hot paths, e.g. the core run
loop, fast page fault handling, etc.  I.e. querying guest CPUID with IRQs
disabled, especially in the run loop, should be avoided.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 67e9f79fe059..e961e9a05847 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include "linux/lockdep.h"
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
@@ -84,6 +85,18 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	struct kvm_cpuid_entry2 *e;
 	int i;
 
+	/*
+	 * KVM has a semi-arbitrary rule that querying the guest's CPUID model
+	 * with IRQs disabled is disallowed.  The CPUID model can legitimately
+	 * have over one hundred entries, i.e. the lookup is slow, and IRQs are
+	 * typically disabled in KVM only when KVM is in a performance critical
+	 * path, e.g. the core VM-Enter/VM-Exit run loop.  Nothing will break
+	 * if this rule is violated, this assertion is purely to flag potential
+	 * performance issues.  If this fires, consider moving the lookup out
+	 * of the hotpath, e.g. by caching information during CPUID updates.
+	 */
+	lockdep_assert_irqs_enabled();
+
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-- 
2.41.0.694.ge786442a9b-goog

