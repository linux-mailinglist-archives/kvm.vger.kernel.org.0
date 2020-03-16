Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD532186FBE
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbgCPQOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52806 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732033AbgCPQOC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1weIqYNF3Fo5tV0WZvC7V944GYiMwvqowZHCwqs/e8=;
        b=PkrV0qAgHEoJV2yEPOQdVTFlpiYj/lct5DsrV3fIg6RDJzcPR83rQAJqqFjjdNDK2za7BU
        bYLdYNQCDLhE+WEYA6kD4WPnptRH0ZoRyjmEp1rtaTk/s5fo5pBgU4G+ZfH3Bt1uEgzujW
        MeIg+iLD5JC5h8QPHUXUYMfCo3k7RNI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-3qL5pODGMhC1F98C1trumg-1; Mon, 16 Mar 2020 12:07:00 -0400
X-MC-Unique: 3qL5pODGMhC1F98C1trumg-1
Received: by mail-wm1-f72.google.com with SMTP id f185so1010493wmf.8
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1weIqYNF3Fo5tV0WZvC7V944GYiMwvqowZHCwqs/e8=;
        b=XKJyOV0gIbTLDxgxR1AsCDv4rZAPw8BDXtEbO0xVHrB3JZSe8prFQJVtbO0QlEMhC4
         R5SfnWBX3963dDkgmgWrvlmpy9ZYi1+IAyGU77bFLE5kJ6noNEZ8f9lsUXvcCac+VwBw
         oZ8VkCaP7Rq/oprmQ/+9xbWz+/wzCYWQIDLF4XBxWzaq4L02uarsFPh752EWQLi5PWMv
         T/YTmEF1do4S28UZ547LHSZ7kcgUJvq887WIS/SeuWJbFVky3qf0mRdbZeDKkM35bf2S
         9juDyrn+mhujHll20JBAPS9iHRSpTHSZ091ZhPAqjn2H8z8C27rwLE+PSNeOjFtmw0eT
         QEEg==
X-Gm-Message-State: ANhLgQ2kMrMeBywdwKhCXixUWu488RB+Z5vtHnqHBfqYMxV+UzJ6uxPR
        IfrtdSuzoadXMbmI1TE0s/9w6U+0SRFt1uCnPUYmgo1H1JzGoVfFKyzMlrLzSnbb5KJbDwwZqLm
        D9MSVTpoqgKu6
X-Received: by 2002:a1c:6385:: with SMTP id x127mr28120924wmb.141.1584374819494;
        Mon, 16 Mar 2020 09:06:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsfX0n8OJNrHnrM7slMemare5ZJPKg4uT9S5KNvko7zVE1qXAD/IK5hEDswewh2HAjGFyl3Zg==
X-Received: by 2002:a1c:6385:: with SMTP id x127mr28120897wmb.141.1584374819229;
        Mon, 16 Mar 2020 09:06:59 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id y5sm166058wmi.34.2020.03.16.09.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:06:58 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 04/19] target/arm: Restric the Address Translate operations to TCG accel
Date:   Mon, 16 Mar 2020 17:06:19 +0100
Message-Id: <20200316160634.3386-5-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under KVM the ATS instruction will trap.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/helper.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 924deffd65..a5280c091b 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -3322,7 +3322,7 @@ static void par_write(CPUARMState *env, const ARMCPRegInfo *ri, uint64_t value)
     }
 }
 
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
 /* get_phys_addr() isn't present for user-mode-only targets */
 
 static CPAccessResult ats_access(CPUARMState *env, const ARMCPRegInfo *ri,
@@ -3631,7 +3631,7 @@ static void ats_write64(CPUARMState *env, const ARMCPRegInfo *ri,
 
     env->cp15.par_el[1] = do_ats_write(env, value, access_type, mmu_idx);
 }
-#endif
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
 
 static const ARMCPRegInfo vapa_cp_reginfo[] = {
     { .name = "PAR", .cp = 15, .crn = 7, .crm = 4, .opc1 = 0, .opc2 = 0,
@@ -3639,7 +3639,7 @@ static const ARMCPRegInfo vapa_cp_reginfo[] = {
       .bank_fieldoffsets = { offsetoflow32(CPUARMState, cp15.par_s),
                              offsetoflow32(CPUARMState, cp15.par_ns) },
       .writefn = par_write },
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
     /* This underdecoding is safe because the reginfo is NO_RAW. */
     { .name = "ATS", .cp = 15, .crn = 7, .crm = 8, .opc1 = 0, .opc2 = CP_ANY,
       .access = PL1_W, .accessfn = ats_access,
@@ -4880,7 +4880,8 @@ static const ARMCPRegInfo v8_cp_reginfo[] = {
       .opc0 = 1, .opc1 = 4, .crn = 8, .crm = 7, .opc2 = 6,
       .access = PL2_W, .type = ARM_CP_NO_RAW,
       .writefn = tlbi_aa64_alle1is_write },
-#ifndef CONFIG_USER_ONLY
+
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
     /* 64 bit address translation operations */
     { .name = "AT_S1E1R", .state = ARM_CP_STATE_AA64,
       .opc0 = 1, .opc1 = 0, .crn = 7, .crm = 8, .opc2 = 0,
@@ -4929,7 +4930,8 @@ static const ARMCPRegInfo v8_cp_reginfo[] = {
       .access = PL1_RW, .resetvalue = 0,
       .fieldoffset = offsetof(CPUARMState, cp15.par_el[1]),
       .writefn = par_write },
-#endif
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
+
     /* TLB invalidate last level of translation table walk */
     { .name = "TLBIMVALIS", .cp = 15, .opc1 = 0, .crn = 8, .crm = 3, .opc2 = 5,
       .type = ARM_CP_NO_RAW, .access = PL1_W, .accessfn = access_ttlb,
@@ -5536,7 +5538,7 @@ static const ARMCPRegInfo el2_cp_reginfo[] = {
       .opc0 = 1, .opc1 = 4, .crn = 8, .crm = 3, .opc2 = 5,
       .access = PL2_W, .type = ARM_CP_NO_RAW,
       .writefn = tlbi_aa64_vae2is_write },
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
     /* Unlike the other EL2-related AT operations, these must
      * UNDEF from EL3 if EL2 is not implemented, which is why we
      * define them here rather than with the rest of the AT ops.
@@ -6992,7 +6994,7 @@ static const ARMCPRegInfo vhe_reginfo[] = {
     REGINFO_SENTINEL
 };
 
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
 static const ARMCPRegInfo ats1e1_reginfo[] = {
     { .name = "AT_S1E1R", .state = ARM_CP_STATE_AA64,
       .opc0 = 1, .opc1 = 0, .crn = 7, .crm = 9, .opc2 = 0,
@@ -7894,14 +7896,14 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_pan, cpu)) {
         define_one_arm_cp_reg(cpu, &pan_reginfo);
     }
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
     if (cpu_isar_feature(aa64_ats1e1, cpu)) {
         define_arm_cp_regs(cpu, ats1e1_reginfo);
     }
     if (cpu_isar_feature(aa32_ats1e1, cpu)) {
         define_arm_cp_regs(cpu, ats1cp_reginfo);
     }
-#endif
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
     if (cpu_isar_feature(aa64_uao, cpu)) {
         define_one_arm_cp_reg(cpu, &uao_reginfo);
     }
-- 
2.21.1

