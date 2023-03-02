Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF906A891D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCBTJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCBTJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:08 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459A21A969
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:49 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e13so113419wro.10
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+nP4isH1Rrpm6PqB1T+HNbs6D4vVCidZRr16ayiLa8=;
        b=C8aZU5/+SOu04bkd57XceuBmV7tZOD+f1/mF7iOMVtDvuDNscWG36vSMh9/QEXfPid
         /IY3FeU3A5JOhNMGE0wMEbdjydW1l82q/Sa4HYhjfbBlOxjY7t1KKnPZwr6aksBFlnvs
         luzv4y4KuE/Ldlt+ZSpgu7eRI9RiWJWQhA5UoogKN8ZMfYG6DaG3tdC0m7df+U96SdET
         ywPwEa1b7fvO41l9nOFINl8fAq9jlyaWai3/n8okkGmfi9G3B33cqzPDXwVsh/N/Post
         xv/NFiTil6yZPXCWn1+YvSRmNLaaCG2li3J1WX2FF05ooIezAcbgstJzstRMSawW/jQW
         Y0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+nP4isH1Rrpm6PqB1T+HNbs6D4vVCidZRr16ayiLa8=;
        b=fd61C4WNSaYQbBgVv6+llHrX+votFVFTfriNGL/V7m1TuHt+7hMD49LJ92rvBXO2+x
         OeBEDWB7jZ5RC77vNE455DW0udS/xE/VSJeFt4YunZbmSLbdefFfaMjCkayGV9ldIDiC
         TXiSn34xeLx9gEAow7c40kyXobVySd7QzSIzXGfTuSGPR/oMMWBQ5kufwGUT6CuEFzfM
         boAhYafUaoZLA9bK9JdszR4mqi0kKRnVnwURmcwVMhpJNZ8jlihvMm+VUmyjSyf0rylR
         Y8uw0IxlZyjgmNFWWqxyCGC3ftV8IYBnrAZHZbfNBK/AxpvJu8qIAyfS9aacHzFkua2+
         iWpA==
X-Gm-Message-State: AO0yUKUbFGN5t38rOZl6n/1jqoJyjBm2b/JkddvF7APFuVelrd1jlrkE
        PdksJ/ROClFYccoc1ZNAj1kAow==
X-Google-Smtp-Source: AK7set+ta6+3ud/gF0jnyTLJkaZ5IY9mbR9X5ZMEfl1uB1UaNOrlAHGNvqkoHumDtiNkldmP643lkg==
X-Received: by 2002:a5d:4d52:0:b0:2ca:8ae5:ea2 with SMTP id a18-20020a5d4d52000000b002ca8ae50ea2mr8364567wru.40.1677784127722;
        Thu, 02 Mar 2023 11:08:47 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t16-20020a05600001d000b002c558869934sm132379wrx.81.2023.03.02.11.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:47 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id ADBDB1FFB8;
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
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Bin Meng <bmeng.cn@gmail.com>
Subject: [PATCH v4 01/26] gdbstub/internals.h: clean up include guard
Date:   Thu,  2 Mar 2023 19:08:21 +0000
Message-Id: <20230302190846.2593720-2-alex.bennee@linaro.org>
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

Use something more specific to avoid name clashes.

Reviewed-by: Bin Meng <bmeng.cn@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/internals.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index b23999f951..7df0e11c47 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -6,8 +6,8 @@
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
-#ifndef _INTERNALS_H_
-#define _INTERNALS_H_
+#ifndef GDBSTUB_INTERNALS_H
+#define GDBSTUB_INTERNALS_H
 
 #include "exec/cpu-common.h"
 
@@ -16,4 +16,4 @@ int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len);
 int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len);
 void gdb_breakpoint_remove_all(CPUState *cs);
 
-#endif /* _INTERNALS_H_ */
+#endif /* GDBSTUB_INTERNALS_H */
-- 
2.39.2

