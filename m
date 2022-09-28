Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A025EEA4E
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiI1Xx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI1Xx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:53:57 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C540410B598
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:53:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m1-20020a056a00080100b00543ffc4cfe0so8092918pfk.5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=8q9CyG61El4v+mVMBzcJd8HOQHJbi0j0M8RnaIqWnFQ=;
        b=QhRZZhPENaTUZ7VRoPVonJuO7TSzfjzViIjW3MJfFTPAZu0UYfK7dVBC5PLYW5qz4f
         x0Dlq4YDv4gROk2lB3OQJMj+WiRE9+nTpu850iYpICVY+jPXbyzWorywyE3/GOp2v59j
         pHezFyLPUjDXH+GNszaayaRVhDfCoupbXgWZuEgVIGneSigVMq/BTNovumfJ9v+R1F7J
         xbwti8mUUadMu+MLgo0sPYAjNErx2DMbdcNc03vMlevrFbXv3QgcvblxafzOAgksPp4L
         ArQV6JJ+fKzAXNXNmhNTHsgAoUHkvBMzCy9jpiWAEuIYn4b3X8uLKyyo2HWALU7ypaPH
         3cGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=8q9CyG61El4v+mVMBzcJd8HOQHJbi0j0M8RnaIqWnFQ=;
        b=BXT+wYLzoNPyka3RRSEdTkFHBot+q570UsfZZrpF/SSGLeFAlOrlChFhyAaz9ZUUwD
         WYrr4RTLVZyYtTCPrjDwXwwWw3eIAxs7kUT9wcdnw4i83tPliwHgt1bYf4vDsXqDASPi
         VVnJgRSqi2s/3HLSNKo0/Xqx2ACegima8yw05D8/YEjvvGZHlpek4F2rZXOVqsRJ8iqT
         LpjcqScONnTwa2OFTj2ib7lbd3XcgFHwm/kjkI3MTKWR/zrLUmIbs/7bjgyugVfKnnH5
         xArmgvDoWlhYTYopDvv6nJAlr5/9hMozg0sF0c5jYnnraipRonhOzbgaS4tpOVkg7Jky
         8OLw==
X-Gm-Message-State: ACrzQf0FyLzHBAI2GgUN6hmEU/KSOdtnpZaHFLTtoBUEDoNASEfOVjTs
        PJWAMeZJPMoSuoHFYa6EyiRLp9P7j2ENDoooFWHGbsURhDb66c97vB14gdwzVDRHh6aMJsqLxGx
        NUS4sGoxUDYJ8k/xTR5Krm7WyEtcjKTxAcwWII1mHvhtf6m9LDrEQ29ADQV4GuWI=
X-Google-Smtp-Source: AMsMyM511NFxW2ysdiMoMkEG9yd0Is8tmdPUDgzZLBHDVXZp6sSg83B7yrwtEvWvepbMYmi4pFKC+3a4ucmxDQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:ceca:b0:177:fa1f:4abc with SMTP
 id d10-20020a170902ceca00b00177fa1f4abcmr487237plg.99.1664409236260; Wed, 28
 Sep 2022 16:53:56 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:53:50 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928235351.1668844-1-jmattson@google.com>
Subject: [PATCH 1/2] KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

At this point in time, most guests (in the default, out-of-the-box
configuration) are likely to use IA32_SPEC_CTRL.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..ffe552a82044 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -858,7 +858,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	 * to change it directly without causing a vmexit.  In that case read
 	 * it after vmexit and store it in vmx->spec_ctrl.
 	 */
-	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
+	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
 	return flags;
-- 
2.37.3.998.g577e59143f-goog

