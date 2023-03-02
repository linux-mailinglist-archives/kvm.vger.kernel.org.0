Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71F76A891F
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCBTJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCBTJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577752E0D7
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:50 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v16so191128wrn.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpN9HZmBiUU2swb5foi3aRB2Xz7IiTbLS73Qjjs5Gno=;
        b=X6ZpukbXB7ZQFc1ZKHqIcOrN4oUK5G/8vtg+7hvGOx4U57/FqhUHa5xkh0ATKgmuAz
         bVpNTe20/S+d5VqJiweBYfKEYdadM1ook/Q194p9EbRxNm5CXT+Y9eGQ5qzxY5MSDCFV
         QBYYyfW/1y6yV5SjCj3PGhaiWVrru80L5WWqRcyfyIbWfZW8cjCZdoEpy3ZUFrXAr5J0
         Nq8sm2b6TPMo4q8nuUZ7v/o+QGqmDNn6C/dThABzyzE6qr5dE/WPmq9xUdGb99Uv35QL
         /44TeseRvDIZWTOQ/hCTTRPI0HCC/CaNYOPAK9iJcnmLlyz+TU/GwELecI8eQwqAosOF
         PAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vpN9HZmBiUU2swb5foi3aRB2Xz7IiTbLS73Qjjs5Gno=;
        b=saArQLCuJOZqv/gW2d1EV/FEEGo3bPWGTYfDThqDUuTjY265PYFHQiJb4X75PCCnEl
         FmvQ0SwAtku/AmmZRBhzDnnK/lpw10WkeEJlO3BTfHhRuzLoMv7PPqNLltavoc7LGBis
         9b6bpKQH09wyWxVlD/rWyjQuflkumbGj0M21AP1QziigkEDabInyw5Z2yYH4dhHYU2lP
         15qwkjy6+ygObEzfawe0mQj1B43LjZua0ju37mob5lxOCeOPusO1H+DcfIsu+52hT3dn
         Zow5nHk4LguD0Lawi3QbLrZovm4gAJJqVxAeO5Xhm3WnevspUNeaxVFIMFPRlSHPHYDl
         PAsQ==
X-Gm-Message-State: AO0yUKWpIXq3nEWy1RYXOkeJHUK8qF4yXOi1hUlFKu+dnDR8G1iYl+mc
        7DOHNDEfvXzByEqQRsN4kUl5Kw==
X-Google-Smtp-Source: AK7set/v7x1LqejxyJQY3tLZfGvFHQz1CzgOGP8zxK8uPbd5BSOymIpa0zLlvGeYomEwHDqsj8k0Jg==
X-Received: by 2002:a5d:4e86:0:b0:2c7:fc61:1676 with SMTP id e6-20020a5d4e86000000b002c7fc611676mr8634371wru.7.1677784128871;
        Thu, 02 Mar 2023 11:08:48 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x8-20020a1c7c08000000b003eb2e33f327sm6700116wmc.2.2023.03.02.11.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:47 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E33201FFBB;
        Thu,  2 Mar 2023 19:08:46 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 03/26] gdbstub: Make syscall_complete/[gs]et_reg target-agnostic typedefs
Date:   Thu,  2 Mar 2023 19:08:23 +0000
Message-Id: <20230302190846.2593720-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Prototypes using gdb_syscall_complete_cb() or gdb_?et_reg_cb()
don't depend on "cpu.h", thus are not target-specific.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20221214143659.62133-1-philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index f667014888..1636fb3841 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -71,9 +71,6 @@ struct gdb_timeval {
   uint64_t tv_usec;   /* microsecond */
 } QEMU_PACKED;
 
-#ifdef NEED_CPU_H
-#include "cpu.h"
-
 typedef void (*gdb_syscall_complete_cb)(CPUState *cpu, uint64_t ret, int err);
 
 /**
@@ -126,6 +123,7 @@ int gdb_handlesig(CPUState *, int);
 void gdb_signalled(CPUArchState *, int);
 void gdbserver_fork(CPUState *);
 #endif
+
 /* Get or set a register.  Returns the size of the register.  */
 typedef int (*gdb_get_reg_cb)(CPUArchState *env, GByteArray *buf, int reg);
 typedef int (*gdb_set_reg_cb)(CPUArchState *env, uint8_t *buf, int reg);
@@ -133,6 +131,9 @@ void gdb_register_coprocessor(CPUState *cpu,
                               gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
                               int num_regs, const char *xml, int g_pos);
 
+#ifdef NEED_CPU_H
+#include "cpu.h"
+
 /*
  * The GDB remote protocol transfers values in target byte order. As
  * the gdbstub may be batching up several register values we always
-- 
2.39.2

