Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B071C2CC
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 08:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfENGGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 02:06:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36878 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfENGGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 02:06:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so8525492pfi.4
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 23:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UrRUImMU/16S9UAMUsLS/q7MrwOXI/8T+fLWmLkbtpk=;
        b=cQxM4/0chR+C985qN3q14TJSSikOLPQqUpuR37SNGjCMNW7I4SwIC9ugrS2PjIeKDA
         xu9VgedpqyFLsmmcPlCX/9Gyd/lHPncrrOg6xsNJoDMBE9nnc1RXzmCRAHDE8djyCkMm
         NG/pKYbP6SF8aOqUOOAA7BiSOeUqvFWTbZaN6apKw83TBsBnh1CuTYePPJd4o1fSLC8o
         SIvs0WAoRjQBC/sKwi8PFTBoNOMZLAMCyP1v/UDu6kcFeeC1bQPWtrfH2XxGEsq7fWD0
         eMiBYqosKLCuuKCPJPxFWnQIPUcHxLEHRgG4li3+8AcHJXkJwD+x0fX3XzNGMAKHzXd5
         fsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UrRUImMU/16S9UAMUsLS/q7MrwOXI/8T+fLWmLkbtpk=;
        b=fTIEuYC4iy1EbHEnKeIF2niZ1iqpYjBJfDKYbnfJSwGGZjhTAnzxnHZ/7Cl38/jjVM
         0bP9DzxfNj5LgkkOsLVu1X1V72+MDpXu4DYOz+eO+RSkCHBKdrsW7Q4pryDJAa3YMyAG
         Cr6e3OJS2nm+aNR5LGEMyyx2eAB1T2ExvZrpAUiLNfOX05Fwz/xtoBn+FzpXz4GHLBmV
         t51HXa8E+sTAUIc2kXSF1TipWQ2XQnN2b6CRS1U4NLGTY3qMGb9Ja44FsfgmuIQes186
         VnbLLMgnLmFPrB7NZDCLllmzAsLHf1PLy/YL9fQm9oXOgx5we/36WaP6kJmsMed63I3P
         EMHw==
X-Gm-Message-State: APjAAAUFZE3mpnQK1Ly5rG0lB0Ltyn2iaIKmrwitnrhWJN7DijeFzxZi
        GUYej4kKevTLPRoYPFe3l52p0ft9
X-Google-Smtp-Source: APXvYqyln5zEc+3GWTHA6GymIAAfFqv+OL+uw6EJvSUs0EIPQ0z+P7AJ7eAmy0a5hXlJz0zthX18Sg==
X-Received: by 2002:a62:d044:: with SMTP id p65mr19008527pfg.37.1557814003379;
        Mon, 13 May 2019 23:06:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id a80sm41480296pfj.105.2019.05.13.23.06.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 May 2019 23:06:42 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] i386: Enable IA32_MISC_ENABLE MWAIT bit when exposing mwait/monitor
Date:   Tue, 14 May 2019 14:06:39 +0800
Message-Id: <1557813999-9175-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR 
IA32_MISC_ENABLE MWAIT bit and as userspace has control of them 
both, it is userspace's job to configure both bits to match on 
the initial setup.

Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 target/i386/cpu.c | 3 +++
 target/i386/cpu.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 722c551..40b6108 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4729,6 +4729,9 @@ static void x86_cpu_reset(CPUState *s)
 
     env->pat = 0x0007040600070406ULL;
     env->msr_ia32_misc_enable = MSR_IA32_MISC_ENABLE_DEFAULT;
+    if (enable_cpu_pm) {
+        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
+    }
 
     memset(env->dr, 0, sizeof(env->dr));
     env->dr[6] = DR6_FIXED_1;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0128910..b94c329 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -387,6 +387,7 @@ typedef enum X86Seg {
 #define MSR_IA32_MISC_ENABLE            0x1a0
 /* Indicates good rep/movs microcode on some processors: */
 #define MSR_IA32_MISC_ENABLE_DEFAULT    1
+#define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
 
 #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
 #define MSR_MTRRphysMask(reg)           (0x200 + 2 * (reg) + 1)
-- 
2.7.4

