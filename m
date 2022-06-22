Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2B556E5B
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348705AbiFVWYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 18:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbiFVWYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 18:24:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EBF313B5
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 15:24:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ob5-20020a17090b390500b001e2f03294a7so309284pjb.8
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 15:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=30jsQB6r9SH89+qEcW55eWWerJsxGlQ46k/YmZxOvtA=;
        b=pFWs9R9tjlumKiGnMN11PzWVszA/w/G866XXD+8iuqTIxA9ur4Nv/vXyCtiBLHe5Gz
         pUQ4eYY0GFMRTGVYalK3tjFO3edRWkGpf3pBzShC47KE2A46ouA9aW3YnL4skjRzWUGC
         ACT3t51k5VTCCKVEbsZtDZHxwo17wCGqD/1aajETLeRkX/OHipNLWo3zkx2ahzFRMPYj
         fUlSV1Ie8hN3lgiQqBaFk7VwZl/z8gt+6rzrOStQ1Ffy9QAReNWoVmTbdyaXAwc+JHnI
         Bydlh4psLHzoKTdEHHry1Usm3826U5YYjD7uKHt09evpBY2MLXdVuMa2s/Xvk6GoJ7tJ
         5KqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=30jsQB6r9SH89+qEcW55eWWerJsxGlQ46k/YmZxOvtA=;
        b=0eJK6fXkpH9bdDNDlItDrblfY/vU7RmJNra+LV0eO4JZgWnkq8L/wHZFQEQ/7FYy7z
         MI3RP5unIbDZ0pCfZhv/IUxHHbHkm0n37o3Ht5uwyNtx92K8Rta+24SyBqpF7cd4cm7k
         LMzJrYnLc3A7hRA+S6EgJmrX1vaVy6eixPa5aUN1D4s1EBo/5hO7C6Iz6WTmYuglaq9e
         HKeeKiSQGPEgdVgPoVxf71Az5J57UxBbXs4ezmlsIknp18/F9RPT15yl135ectHK6RhD
         3E1eeuTMnWaPrLgvaiv8EKmWe1qSjuBfMzn9Iv2htUozjDvp+N4gbnrdJLVMXi/PLIyk
         BsMQ==
X-Gm-Message-State: AJIora+Jd5mR1uLzX/5fVU2CGFAQ+Nz1rrqVxY4uK87IXya5D6HUHemT
        9ELK+TrC5Znws7CH1pqdGwjI0hkidfA9lWcH3g8/WCyF9sk6lyGgPx4LNTtTwvdHYjEE3jfdYs+
        emEAXNnLjFcI9ugV46zxnx7bwvsij1l790bnTcpKHhAs/WOoPwFev72pC8P1pKZs=
X-Google-Smtp-Source: AGRyM1skcm88bRi+b1Hnv2UZ6f2Okmm3AZMKGtUmjieLNPwrC3nuaQ/jP5cGhBHv3RaAu/aOR5Ldxgh9m9vf3Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:4a97:b0:1ea:fa24:467c with SMTP
 id f23-20020a17090a4a9700b001eafa24467cmr61178pjh.1.1655936651731; Wed, 22
 Jun 2022 15:24:11 -0700 (PDT)
Date:   Wed, 22 Jun 2022 15:24:08 -0700
Message-Id: <20220622222408.518889-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH] KVM: VMX: Move VM-exit RSB stuffing out of line
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
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

RSB-stuffing after VM-exit is only needed for legacy CPUs without
eIBRS. Move the RSB-stuffing code out of line.

Preserve the non-sensical correlation of RSB-stuffing with retpoline.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmenter.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 435c187927c4..39009a4c86bd 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -76,7 +76,12 @@ SYM_FUNC_END(vmx_vmenter)
  */
 SYM_FUNC_START(vmx_vmexit)
 #ifdef CONFIG_RETPOLINE
-	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
+	ALTERNATIVE "", "jmp .Lvmexit_stuff_rsb", X86_FEATURE_RETPOLINE
+#endif
+.Lvmexit_return:
+	RET
+#ifdef CONFIG_RETPOLINE
+.Lvmexit_stuff_rsb:
 	/* Preserve guest's RAX, it's used to stuff the RSB. */
 	push %_ASM_AX
 
@@ -87,9 +92,8 @@ SYM_FUNC_START(vmx_vmexit)
 	or $1, %_ASM_AX
 
 	pop %_ASM_AX
-.Lvmexit_skip_rsb:
+	jmp .Lvmexit_return
 #endif
-	RET
 SYM_FUNC_END(vmx_vmexit)
 
 /**
-- 
2.37.0.rc0.104.g0611611a94-goog

