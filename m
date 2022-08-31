Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1525A87FB
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiHaVSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 17:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiHaVS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 17:18:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DBEDDB65
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 14:18:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3328a211611so211261847b3.5
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 14:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=HQoamibmfiE7nHkPok6wkO/VrN3C9PG9bTmDWvCccbk=;
        b=RM73ZeGV2Mc9trz/Y+eYzIsek+lL/FJPh0dfjJiMsD4be0IeN/45OOfjp2UtKkYxic
         O0Sxih6/wtCvmnSMixTlF9y6oy3HW61up/wkroQyNEfgkxPbjaFghlGqejhuneShNAWy
         SiERD6130vTyZKJBy3zfvNjSnERooNVyWeHn1GyiK9zQOdYNgZ+JpZ9G+iIMBz3djU/Z
         u61LXYV7/iofEIviig+Dq4zqdQYQHH/uz/d1V/fdIm8Gm5I8+jtYpNiRUkMnCL6LnjGQ
         DW3tGpe5Vp9ALSQA5wwZ4W7/yoPKIAj84M7vZuWTO1AfWEBvohQtOJH4agT0CNPMZHWD
         +rtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=HQoamibmfiE7nHkPok6wkO/VrN3C9PG9bTmDWvCccbk=;
        b=J7KROD9K/je4Fv0cRy3SCTI98olAcSd3YWFG7HxQI3ysrYWwLgLocdcWrYNbS/bcOO
         yBDPmHchFoPemCYhh9qP6AjVc8ATLIL84Ds8v009Fvi7NENvUF4R7g3xTOFjFXsZbJmf
         GdEPriCI7yGfflrXY1EL2UTge0bC6zeOOfBVDBkJz3aKrEp9HTZsl5gt0uaPXp4HGTbF
         y9p1HHCBJvaI44dHx2zZeuUW1qNkgZ9w4oxxhOsQ3rcES4VF4fq9XKOB1MpHQkUVMIRM
         8bDTJHJyrRgXBYPGlyUDYuqF6T+h94yyKRMpDEgtBqYWRMQtKegKMfc3joWMgdpNMu2k
         sMtw==
X-Gm-Message-State: ACgBeo0sa2I/enRp310XrIXSYTCOuVEh5B5wx5yC72g28WsycVXqzk1Q
        YRw73tiRFvsMQul+1PC+5v5ZHFCPVHxfVg==
X-Google-Smtp-Source: AA6agR6jr60mo5mSxkMIToL0MvcfQG1tk+RIJvxs7V7tT8sGusQzxjuz8oqDdBcMfbEUr7EmLw1o88hgKYolWw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:9d8d:0:b0:676:a71d:edad with SMTP id
 v13-20020a259d8d000000b00676a71dedadmr16453866ybp.94.1661980703428; Wed, 31
 Aug 2022 14:18:23 -0700 (PDT)
Date:   Wed, 31 Aug 2022 14:18:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831211810.2575536-1-jmattson@google.com>
Subject: [PATCH v2] x86/cpufeatures: Add macros for Intel's new fast rep
 string features
From:   Jim Mattson <jmattson@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org
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

KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
are already cached in word 12. Give the bits X86_FEATURE names, so
that they can be easily referenced. Hide these bits from
/proc/cpuinfo, since the host kernel makes no use of them at present.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 v1 -> v2: Hide from /proc/cpuinfo [Dave Hansen]

 arch/x86/include/asm/cpufeatures.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ef4775c6db01..454f0faa8e90 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -308,6 +308,9 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
+#define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
+#define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
+#define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
-- 
2.37.2.672.g94769d06f0-goog

