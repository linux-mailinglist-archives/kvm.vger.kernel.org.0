Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AFB562649
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 00:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiF3Wyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 18:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3Wya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 18:54:30 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91275073B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 15:54:29 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c77-20020a624e50000000b00525277a389bso82418pfb.14
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 15:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WebuyqMaRdVDiAsm1cGnyZoz4d/N9gGcjuMcUR9A1n0=;
        b=Sns8ceZTSUv/xc8mK7XIZbD9KzCKK0JouXs7+dsbbLHe0ZxJQwqHNP/D7aQdCvFPYO
         qE2dWeOj5O9ndkB3CUyf38KpxVF/OHKekKDgpq66qcfgim+5VkihCoEp9Ig+NJiLroQ1
         QHmOZvTuhxTeFQjN4B22+JrMgUJYtv7jtIFcFQhAieyQ7v0hS98nci3dtWdlSy0TVzhs
         dOojxVlL4OGRDE1SXX+OPDAuZilHlxZ3zk/G7U0zEbr8k0kqg2DtGET/ODMNG36nscJf
         sTGai4CWLui9Ye9rW6REnDzbymrwgMDoG9vcDM0z4ZaexGn/os/XYnbK657q9sND6uap
         4w5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WebuyqMaRdVDiAsm1cGnyZoz4d/N9gGcjuMcUR9A1n0=;
        b=dY9kLAVdPBdkz0V+AIyZJIODdCPg8uL5S53xtQDVGxXyhNR6aHGK4GmW1nZgc88Z01
         Pr1+EG75iwfw29NSv9hMLG3M/r6Y9ly1m8ifZRXCVnWAfuhrLip2/Pb4j2yWBFCr3EfE
         Pa4dh+Xiyl/SfU5pbtA68Ks3lcRNAvKZ77f3KZNAc1BL0OEsFxYG5VMqbOqpG1RHrhpl
         Tt3tPYMGyX+5SaTBiBU2e3iHwL0yMlewFqs/KJRKVHTNaDIEmcx6xNBkL/37uUD68VqI
         VMTDjkmM5p+J1zg1x1w1UAa7fDLAOqsKM1eEP/A64DGBg/EWsgEK8Lr47svHbWkECmac
         E52g==
X-Gm-Message-State: AJIora9UoSkKmFaxDJypdAxGn/xBKZ6PMH9P9le5M2VTcSbXrsyMbn5X
        Q/eKBFWtS65fTwEdSSTqmLa2tIqW/8/8uEK2Bqo3AKVgCl19EvSkjlbi6xBmjbfSUtL4hgiDD8f
        hkA9Mw7Frl1xhZHl5al+zfLUi07dY3gjJLSmUBLZrGSBqKELBf+q0kAo2JyGGcZ0=
X-Google-Smtp-Source: AGRyM1u4Odx6izzykYw39wyL4eKTB5PJv+03gUlduL7W5dBTCHaxSo4tJ+Opw5LPCJP3gtocMFHa9u7LrsCBEg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4a4e:b0:1ec:beae:6f33 with SMTP
 id lb14-20020a17090b4a4e00b001ecbeae6f33mr14436801pjb.185.1656629669173; Thu,
 30 Jun 2022 15:54:29 -0700 (PDT)
Date:   Thu, 30 Jun 2022 15:54:24 -0700
Message-Id: <20220630225424.1389578-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2] KVM: VMX: Move VM-exit RSB stuffing out of line
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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
eIBRS. Move the RSB-stuffing code out of line to avoid the JMP on
modern CPUs.

Note that CPUs that are subject to SpectreRSB attacks need
RSB-stuffing on VM-exit whether or not RETPOLINE is in use as a
SpectreBTB mitigation. However, I am leaving the existing mitigation
strategy alone.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmenter.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 435c187927c4..ea5986b96004 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -76,7 +76,8 @@ SYM_FUNC_END(vmx_vmenter)
  */
 SYM_FUNC_START(vmx_vmexit)
 #ifdef CONFIG_RETPOLINE
-	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
+	ALTERNATIVE "RET", "", X86_FEATURE_RETPOLINE
+
 	/* Preserve guest's RAX, it's used to stuff the RSB. */
 	push %_ASM_AX
 
@@ -87,7 +88,6 @@ SYM_FUNC_START(vmx_vmexit)
 	or $1, %_ASM_AX
 
 	pop %_ASM_AX
-.Lvmexit_skip_rsb:
 #endif
 	RET
 SYM_FUNC_END(vmx_vmexit)
-- 
2.37.0.rc0.161.g10f37bed90-goog

