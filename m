Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40746A8948
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCBTO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCBTOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:24 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3711714A
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso2569541wmb.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mDcBmWouGnqGshBynFnpTf0FCw+Ej8aBvk380H3UuI=;
        b=BXhYzlIz4j2CWr7staJK2ZrwQKbpSJoV8+CqliJorOBQviI6qlvhy8hs/bRlc8iHzK
         2d8waRQy+vebFK4XDNLRiTHY+tdbnJ0FfASQMOZ+rjY+pRu+vEGgpgdlfuMb6DjhEMgS
         FK/nNatkJbpwbdhWrWI9tnYRH/dysVdyKNVqA8dGn+DwgFSM096dN388OZGadt3S6ruA
         WhRe13FdZYLXrr/2thq3+du5LceKbDMJH+6IhHD+TADiQE96sHjcfg68vOyYSVhD4z0s
         xxOEaxrH9bCsCQb3ZwQrPf01mEXK5fll2XGLUysUcP+9SuD6i8rvmaCgJ0SDXqX5IQ4J
         mCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mDcBmWouGnqGshBynFnpTf0FCw+Ej8aBvk380H3UuI=;
        b=dIf6c6ajMXUjvro7o8pRwOHott0WawCeDY8OaUdTgaM3CcMIBkU9J/nME4ym715FWp
         fAJmZU+obtfqOEYi2mon15K8Fqk8oms8OxKRuQMAjwuBfqn33S5tVJ/EPVWMk2NAZi4u
         +O+AqxpO3So8p0aY7FsS4+JtkC1mAzIy0aGWgiGfXhk7I+RQfEgfy6g3ljRE+rjd2kPT
         ALXDNb7PoU3Uu7KmsGxvz+M5qbiIMk2U5wqxL3JLz0xVS8S99igDL/yu4topZZrVF8P3
         N8usO0SEL/cXSFpMCCZMoO2H8CEy910QRt7lc8X1UFuTtQnmfGHdEkO4KIIWf3tCjrjY
         JamA==
X-Gm-Message-State: AO0yUKVByWJ4dl5AHZdx52zHRo3pf6ToqLqHMlEYjcwrFdYYPbgKvg9q
        nmREmQtGyU5NLylv5AeXqZAdzg==
X-Google-Smtp-Source: AK7set9YxIWJrYn/MpIzDLybLevwDttFD09ikLI3/HBK8ztypWUCRjSint/bPii24PauHRFn4AZCgw==
X-Received: by 2002:a05:600c:198e:b0:3eb:6878:5523 with SMTP id t14-20020a05600c198e00b003eb68785523mr250882wmq.12.1677784461721;
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k5-20020adfe8c5000000b002c56179d39esm162354wrn.44.2023.03.02.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:20 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0A81B1FFBB;
        Thu,  2 Mar 2023 19:08:49 +0000 (GMT)
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
Subject: [PATCH v4 18/26] gdbstub: fix address type of gdb_set_cpu_pc
Date:   Thu,  2 Mar 2023 19:08:38 +0000
Message-Id: <20230302190846.2593720-19-alex.bennee@linaro.org>
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

The underlying call uses vaddr and the comms API uses unsigned long
long which will always fit. We don't need to deal in target_ulong
here.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/gdbstub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 7301466ff5..b8aead03bd 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -535,7 +535,7 @@ static void gdb_process_breakpoint_remove_all(GDBProcess *p)
 }
 
 
-static void gdb_set_cpu_pc(target_ulong pc)
+static void gdb_set_cpu_pc(vaddr pc)
 {
     CPUState *cpu = gdbserver_state.c_cpu;
 
@@ -1290,7 +1290,7 @@ static void handle_file_io(GArray *params, void *user_ctx)
 static void handle_step(GArray *params, void *user_ctx)
 {
     if (params->len) {
-        gdb_set_cpu_pc((target_ulong)get_param(params, 0)->val_ull);
+        gdb_set_cpu_pc(get_param(params, 0)->val_ull);
     }
 
     cpu_single_step(gdbserver_state.c_cpu, gdbserver_state.sstep_flags);
-- 
2.39.2

