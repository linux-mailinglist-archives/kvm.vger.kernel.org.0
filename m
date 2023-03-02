Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A536A8949
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCBTO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCBTOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:24 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C717CF4
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:23 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bx12so122165wrb.11
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0nGJS3TcjePwhHIbOnspKgR49rDlBrdUVNx8YN4xopU=;
        b=c2dzS+/vMLVsojBfKJnEcMJI5C2OOz7g80CJOtOK2sGwGB9UfyRI7b66Zc3u8JAhr7
         tIZZPqcIjCZvniFrH7r32uHBud/Fiy3m+p3k1gSDIc7mNt4vR2EtGC98sXXRCyQ9/eFf
         dbKQSelNgujobyuQ0AWo8bW92pn2l31Rwwal9LQSpNcak4fTZ5REKqUQucip7T1sFwkn
         jp1BWroal/WWkMEdYmfJTGtzy/UaYpvygzL9MStYCAe3AOAXLZWIH9ffXLWwdttZ24cE
         Q6nwksCyebBOzkoFpUPoUagwvZJGbH9Xd+gPS4Xv75+1OqDBCDSY7vfRTF7oUfXm3m3B
         qgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nGJS3TcjePwhHIbOnspKgR49rDlBrdUVNx8YN4xopU=;
        b=6DXGmOfIoz9B10UZHTWGo+TlGqfrmlAIR72sWupQhqdIaBIj7ONdTD628R7OGWia5v
         YBvt+x/eG6TO41yJxy5v81jl2F7dePLhWvAPXDJhiBis6L6C7jyzMNXN8HJWKcWJ7k/f
         tY2vH33vGyFU8fdhtg8CrpFi91QdCxNw89JEnbY7xWG1l+8lbWiNznv0eZUJJBZOW9aW
         AHBVp30xoYQAXZI+kGevf/qMnnX4huJ6laE+TRPVnshqJBKX3FocijlCuBQpLiT8ld/w
         JVDBVFgj+lmNLlNc+cUWU+RMijjy5o43cNHhWbG3oNQ18nUtNazFGmGp3ZVud6u7EGF8
         LbIA==
X-Gm-Message-State: AO0yUKWM4p0Miky/dvRv68EOZUjguj5BuY7s2TscpeJoRxQWJB8K9IFr
        4IhqlbgDnrSFXmGkRntUwN04qw==
X-Google-Smtp-Source: AK7set+Q70UxKdpfAWTcqp8rXJI6MlAyYRt6imddI390dRCuIlRX5/AkaY1nmZEit+fxPIc10A9txA==
X-Received: by 2002:a05:6000:108c:b0:242:1809:7e17 with SMTP id y12-20020a056000108c00b0024218097e17mr8349240wrw.6.1677784462023;
        Thu, 02 Mar 2023 11:14:22 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p1-20020a5d4581000000b002c55551e6e9sm132841wrq.108.2023.03.02.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 169191FFBF;
        Thu,  2 Mar 2023 19:08:50 +0000 (GMT)
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
Subject: [PATCH v4 22/26] gdbstub: only compile gdbstub twice for whole build
Date:   Thu,  2 Mar 2023 19:08:42 +0000
Message-Id: <20230302190846.2593720-23-alex.bennee@linaro.org>
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

Now we have removed any target specific bits from the core gdbstub
code we only need to build it twice. We have to jump a few meson hoops
to manually define the CONFIG_USER_ONLY symbol but it seems to work.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - also include user and softmmu bits in the library
v4
  - include genh for config-poison.h
---
 gdbstub/gdbstub.c   |  4 +---
 gdbstub/meson.build | 30 ++++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index e264ed04e7..d9e9bf9294 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -39,9 +39,7 @@
 
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
-#include "exec/exec-all.h"
 #include "exec/replay-core.h"
-#include "exec/tb-flush.h"
 #include "exec/hwaddr.h"
 
 #include "internals.h"
@@ -1612,7 +1610,7 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
         .cmd_startswith = 1,
         .schema = "s:l,l0"
     },
-#if defined(CONFIG_USER_ONLY) && defined(CONFIG_LINUX_USER)
+#if defined(CONFIG_USER_ONLY) && defined(CONFIG_LINUX)
     {
         .handler = gdb_handle_query_xfer_auxv,
         .cmd = "Xfer:auxv:read::",
diff --git a/gdbstub/meson.build b/gdbstub/meson.build
index c876222b9c..d679c7ab86 100644
--- a/gdbstub/meson.build
+++ b/gdbstub/meson.build
@@ -4,13 +4,35 @@
 # types such as hwaddr.
 #
 
-specific_ss.add(files('gdbstub.c'))
+# We need to build the core gdb code via a library to be able to tweak
+# cflags so:
+
+gdb_user_ss = ss.source_set()
+gdb_softmmu_ss = ss.source_set()
+
+# We build two versions of gdbstub, one for each mode
+gdb_user_ss.add(files('gdbstub.c', 'user.c'))
+gdb_softmmu_ss.add(files('gdbstub.c', 'softmmu.c'))
+
+gdb_user_ss = gdb_user_ss.apply(config_host, strict: false)
+gdb_softmmu_ss = gdb_softmmu_ss.apply(config_host, strict: false)
+
+libgdb_user = static_library('gdb_user',
+                             gdb_user_ss.sources() + genh,
+                             name_suffix: 'fa',
+                             c_args: '-DCONFIG_USER_ONLY')
+
+libgdb_softmmu = static_library('gdb_softmmu',
+                                gdb_softmmu_ss.sources() + genh,
+                                name_suffix: 'fa')
+
+gdb_user = declare_dependency(link_whole: libgdb_user)
+user_ss.add(gdb_user)
+gdb_softmmu = declare_dependency(link_whole: libgdb_softmmu)
+softmmu_ss.add(gdb_softmmu)
 
 # These have to built to the target ABI
 specific_ss.add(files('syscalls.c'))
 
-softmmu_ss.add(files('softmmu.c'))
-user_ss.add(files('user.c'))
-
 # The user-target is specialised by the guest
 specific_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user-target.c'))
-- 
2.39.2

