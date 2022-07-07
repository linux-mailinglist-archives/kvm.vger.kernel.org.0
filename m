Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8600256AD59
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiGGVUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiGGVUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:20:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF9313A8
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:20:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j23-20020a17090a061700b001e89529d397so16036pjj.6
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BBFmGU1nVfnK3NtNeL4ozwzOy2EDVHt49vendq7WHnU=;
        b=Ps1mpoUoY6GpJNYoCedDQanNr0iCKxvMEkODmARVO8pKB0NmfK8gK9Uq1bSPNwEhCe
         Xp94l+hOLq1qvLeOiEeWPf9E//Z+bun6dcmZ/6UAY0kDlVYywzdlEKnI36HhVm/zDJ/4
         PI1N9dyOZvEChATb7A8MlyctBDqiVH/ad0GlmOtDWk22Jp+jzGB70hMlar/jDKZgqtc+
         OvUvOHYoGVL4NMHQXHn9pD0b1/b6pMX9NEUMYzqpSn2C1kmfy25rpKZRs4TaitSLNdty
         ZSi0Lbqn311yTdiz0bsqUIMyGz1JwGSvW3UVHlFWI50hGwu49KE+7QjsGpl3QNMoFzWc
         L25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BBFmGU1nVfnK3NtNeL4ozwzOy2EDVHt49vendq7WHnU=;
        b=5Lsjc/rOr73sq69sXzin2NFAjy2tWN95Jsafb7kFbo9k+E4xhIGzxiAu23ZuvFqsF6
         +ow79h/EU9zsZ1Iih327AEsGuBs4LZCFNqxpRfHXqAHXHJRkeguSfvEO612yIsxzjT3a
         HMUWrQOYos+DLofKWVYRJ1pHe3fBAhahKi2dTI8Dp48cJrxe9ZVQ6CCyoHEr74iktbgv
         yJ8eYFRg9qzOj6DjYt/dMEDH7rnXjuPQ/iGrJZFXJGEaImMgWbfgbsQU9hqIQW4inD6e
         2w7JMf5fvsNbI9XZptmWUgGRa+04nPMgyRt51BqIUhO8dadQbuze7x6AF0doc6bdeIvB
         uAAw==
X-Gm-Message-State: AJIora/GApZK6ASyVs5Q5QESQjj5RYlC8h1oou9ATyTmi0J1ZE11bOcp
        HgVnHvw212YIwhvFDUDXJfrzsp4vQ9QrMJlRp9Bq71k7KsZnU1GDX6lrWXwVobQS+i7u7+3kLp4
        1HkY2B5Y71f8VMy3jRvfRQ1aS1CLLZB90Or1Rmw8rcQwgEQHkle0k5wwBi7MNTKY=
X-Google-Smtp-Source: AGRyM1uLYC2GVWEMgMcjMvIZrBDYBGUVjba6Oz8ykbaPeqHu1eGYSo1pPMGXWOSBFIkiy5phONJAx6KpuZ8yuw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1687:b0:518:6c6b:6a9a with SMTP
 id k7-20020a056a00168700b005186c6b6a9amr55402601pfc.81.1657228851998; Thu, 07
 Jul 2022 14:20:51 -0700 (PDT)
Date:   Thu,  7 Jul 2022 14:20:49 -0700
Message-Id: <20220707212049.3833395-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v3] KVM: VMX: Avoid a JMP over the RSB-stuffing sequence
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
eIBRS. Instead of jumping over the RSB-stuffing sequence on modern
CPUs, just return immediately.

Note that CPUs that are subject to SpectreRSB attacks need
RSB-stuffing on VM-exit whether or not RETPOLINE is in use as a
SpectreBTB mitigation. However, I am leaving the existing mitigation
strategy alone.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 v1 -> v2: Simplified the control flow
 v2 -> v3: Updated the shortlog and commit message to match v2

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

