Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C73B3FF113
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbhIBQSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbhIBQSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:18:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC599C061760
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:17:16 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so1878630wme.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k2G3IfvTSVM9dAo9x5r9x/QXUgni24b97nAmsANOOiA=;
        b=M+D+zo4/zdtMjYh01av69Zx4I3VwXPivjqKNQQ+G3Cy3iOhT3mTPvnPzXtpAFBC7IC
         bwDY97okiaHzzYZk/Nr+HJhmQWDbqsmtfcbNHfDxcB+wW5LVOcMLHk2ke6LUzT0b2vAG
         YqHMZm6pCnZF4sDmb5j0t8leoEPE4luIBbr+2Y/AHejZSaAIPRgw6F1l+RvTfdeQZQ/w
         KmEHFk+ys6eIeCl+10CsGxJv2WVk1ePshB2QpZEYQ9Rs3vY5QE1eYEOqT+aIoXIw8PR9
         WNsdSSeclnt9XXMY/k06ObG6uMJqiNqm40/pEaPsmniXZMMe5CRy4fWye4vqLWV5kU8p
         n7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=k2G3IfvTSVM9dAo9x5r9x/QXUgni24b97nAmsANOOiA=;
        b=cL1ISwfy3LoMlqJ+0tAYVtGtlZY2Bd4yICCLcsj9qdr669nJ/Lg6ccEYsev90PnuX6
         IdSnYWXNnr8GsQQjGo+JfLAdpfc5uC3SX9DTcJysTRayRvkq5UskPOlvhpoveQKdvIUT
         DCqAm9cIi1c8M8Ssa6qGq8qMnhqhGk7se/xcPuWcFsXs4FPqBCMGLXFLZWSsbniFOV+s
         bIolgzB2KoP5KMdhejRWY5mc2vwDTedZ23/bR5AsdE7xkR3SvIvvVbXHQ20wXaDoF8rO
         HO76OExWyVQI0/2a8b+kZwOPSiPuuAUNZ7+/Gc8uf83mdHtyrWhGDEAPs8OQmZDihIZt
         EOCg==
X-Gm-Message-State: AOAM533XkK5JBf3gW20LKHm+mHpaJ3CftINHPv8DGt/GT64WZgm/z3oZ
        Q6axo9p2vutrPLcCehUTgeQ=
X-Google-Smtp-Source: ABdhPJxFmnMfDsCiejdGeBE1y8KakVIkNHc7YRKHEHHLvGEXylx3fbGc1JSSwIBZyxQGjwxS5CvgPg==
X-Received: by 2002:a05:600c:1d27:: with SMTP id l39mr3986130wms.146.1630599431932;
        Thu, 02 Sep 2021 09:17:11 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id c3sm2410025wrd.34.2021.09.02.09.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:17:11 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
Subject: [PATCH v3 14/30] target/i386: Restrict has_work() handler to sysemu and TCG
Date:   Thu,  2 Sep 2021 18:15:27 +0200
Message-Id: <20210902161543.417092-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict has_work() to TCG sysemu.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/i386/cpu.c         | 6 ------
 target/i386/tcg/tcg-cpu.c | 8 +++++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 04f59043804..b7417d29f44 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6548,11 +6548,6 @@ int x86_cpu_pending_interrupt(CPUState *cs, int interrupt_request)
     return 0;
 }
 
-static bool x86_cpu_has_work(CPUState *cs)
-{
-    return x86_cpu_pending_interrupt(cs, cs->interrupt_request) != 0;
-}
-
 static void x86_disas_set_info(CPUState *cs, disassemble_info *info)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -6757,7 +6752,6 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = x86_cpu_class_by_name;
     cc->parse_features = x86_cpu_parse_featurestr;
-    cc->has_work = x86_cpu_has_work;
     cc->dump_state = x86_cpu_dump_state;
     cc->set_pc = x86_cpu_set_pc;
     cc->gdb_read_register = x86_cpu_gdb_read_register;
diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
index fd86daf93d2..6cde53603ba 100644
--- a/target/i386/tcg/tcg-cpu.c
+++ b/target/i386/tcg/tcg-cpu.c
@@ -55,6 +55,11 @@ static void x86_cpu_synchronize_from_tb(CPUState *cs,
 }
 
 #ifndef CONFIG_USER_ONLY
+static bool x86_cpu_has_work(CPUState *cs)
+{
+    return x86_cpu_pending_interrupt(cs, cs->interrupt_request) != 0;
+}
+
 static bool x86_debug_check_breakpoint(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -63,7 +68,7 @@ static bool x86_debug_check_breakpoint(CPUState *cs)
     /* RF disables all architectural breakpoints. */
     return !(env->eflags & RF_MASK);
 }
-#endif
+#endif /* CONFIG_USER_ONLY */
 
 #include "hw/core/tcg-cpu-ops.h"
 
@@ -76,6 +81,7 @@ static const struct TCGCPUOps x86_tcg_ops = {
 #ifdef CONFIG_USER_ONLY
     .fake_user_exception = x86_cpu_do_interrupt,
 #else
+    .has_work = x86_cpu_has_work,
     .do_interrupt = x86_cpu_do_interrupt,
     .cpu_exec_interrupt = x86_cpu_exec_interrupt,
     .debug_excp_handler = breakpoint_handler,
-- 
2.31.1

