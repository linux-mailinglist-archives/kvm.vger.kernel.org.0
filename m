Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3194C9243
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiCAR4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiCAR4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:56:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6A41F8A
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:55:52 -0800 (PST)
Date:   Tue, 1 Mar 2022 18:55:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646157351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=jyUZX0TxdYWboAv1JRiIec9LSGMYbPj2AQm2aBVceRg=;
        b=VA7/xc6jVTH92MRS7EPnz7U+Z4oXxXgBGVYNrHE5rkcRAWuo2Nz+l6OOmNdAaXeNcItodx
        LaLvI+Fw4KUi0ZFzbERzCKrIqa5E97zUjTK25hp5vnOkUimArPADDKIRL2bdyWVZntR3mc
        eFHRtZW2OjMGQ3wa4ubz3z1s+A42QbNRwfBMXFAQeVDAS2/No6SS77MP2PZrgw+xZfl9UW
        IaSIwe6i2oJaKJIlchtFKtmcgMYHposFldTkkzACNNi5RynfhhslMCYy+DtIkKwRFv3KSf
        zTJHQLJobsSIQyLVKpjbMhkhQHF4me9CpQT1y+7y85aDaY3iIbTVVRMXqmPukg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646157351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=jyUZX0TxdYWboAv1JRiIec9LSGMYbPj2AQm2aBVceRg=;
        b=W8HTPH5qO7H/acugRD5kyXXkSZgTs5lXaKAFWfd5nUnDkpyvt7j6eIcaDgu8f3EtXqpf77
        Vua/L6j78CIz9nBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH] x86: kvm Require const tsc for RT
Message-ID: <Yh5eJSG19S2sjZfy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 6 Nov 2011 12:26:18 +0100

Non constant TSC is a nightmare on bare metal already, but with
virtualization it becomes a complete disaster because the workarounds
are horrible latency wise. That's also a preliminary for running RT in
a guest on top of a RT host.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82a9dcd8c67fe..54d2090d04e7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8826,6 +8826,12 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		pr_err("RT requires X86_FEATURE_CONSTANT_TSC\n");
+		r = -EOPNOTSUPP;
+		goto out;
+	}
+
 	r = -ENOMEM;
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
-- 
2.35.1

