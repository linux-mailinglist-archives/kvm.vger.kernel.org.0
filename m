Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C26A8921
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCBTJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCBTJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41DF6A71
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:51 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id h11so137816wrm.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffhXR90TVSQnNHTvhKRNefIM4mYQZlD8n+lh28Il+5U=;
        b=JfTTt2YCfJVrPhi7siSMIrk9/oCHPtVzmIfNVnF2IKJ8ahWHpRsGUoaBwl7kBHskWy
         ZBhVBc49Zrfxr4MxIFZ/OjBJk52s7AkdqTyyyzmyVYh75Y8DyxcsiXmyw87UlsRxHXBn
         ppuVfhF+k+oR2X9HsQjWeLR/EF9ROr9KmOpYZ3OAWOynwlakrimJT4Kj9EqpqbUtLzAq
         YqywemGGb1zVogr2CjiVSxiPOfE7Pgi6fEXKGGq6tzy09zWYrTNH11f9pVDWscdu8WTo
         tuJKh+x+AcB2LZOmV3hBDTY/CDqtlSxyaX8LhcLwvqL1wC9zssntvu+95Vf9EdFte8Yw
         b7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffhXR90TVSQnNHTvhKRNefIM4mYQZlD8n+lh28Il+5U=;
        b=z9FPd1OYyvv3jnSRX1Z418DfuhexJarVh5+ezFd+Y+P9CE/TTEniKiklF5VIkUXCdv
         BsW1kp987KrxeFJYHf1SRJi/iwtNp9Qwdmu0oYrN2SrwMp2dAg5QtbCakH/GJMH8s2EH
         w2qCT0FXZmBEqmsxENbRb5ZnxparOESpBS3vRd8I//fF3OBV1LUhvv28XaNoFjUFOU9W
         6ZvjIl65sVAoXbeSO0CWpDmtBJ3PnM/Q+VdLY+YR7oAVilOsb3HVOh51f4fvg2YzLQu9
         uUGdX9VNp3WbTmaUFcHaH64f/OptIRLHCeh64SSzsyqW4jCs4mXfctZD1+TW9DGWgJ3b
         Ahzw==
X-Gm-Message-State: AO0yUKWzNlehUcZtnHvFDXEQW03mtPd1PbKpZ8nFIyewEBX5Y/JJzCMq
        pw/5LfiBvrsMMJt8JgvaDMushQ==
X-Google-Smtp-Source: AK7set+zt5nNBDnpxALDca4/tHaihplVbBGjp2gAIRRccOGPEVHSHVyfgHbc6nz6I5XxJoxKe8LvkQ==
X-Received: by 2002:adf:e98e:0:b0:2c5:9c7a:866 with SMTP id h14-20020adfe98e000000b002c59c7a0866mr7862710wrm.51.1677784129988;
        Thu, 02 Mar 2023 11:08:49 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id f9-20020adfdb49000000b002c59c6abc10sm115801wrj.115.2023.03.02.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:48 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 3E7901FFBE;
        Thu,  2 Mar 2023 19:08:47 +0000 (GMT)
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
Subject: [PATCH v4 06/26] gdbstub: move GDBState to shared internals header
Date:   Thu,  2 Mar 2023 19:08:26 +0000
Message-Id: <20230302190846.2593720-7-alex.bennee@linaro.org>
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

We are about to split softmmu and user mode helpers into different
files. To facilitate this we will need to share access to the GDBState
between those files.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - as we split user/system state earlier we can remove the #define hack
---
 gdbstub/internals.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 gdbstub/gdbstub.c   | 42 -------------------------------------
 2 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 7df0e11c47..32daaf73a3 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -11,6 +11,56 @@
 
 #include "exec/cpu-common.h"
 
+#define MAX_PACKET_LENGTH 4096
+
+/*
+ * Shared structures and definitions
+ */
+
+typedef struct GDBProcess {
+    uint32_t pid;
+    bool attached;
+
+    char target_xml[1024];
+} GDBProcess;
+
+enum RSState {
+    RS_INACTIVE,
+    RS_IDLE,
+    RS_GETLINE,
+    RS_GETLINE_ESC,
+    RS_GETLINE_RLE,
+    RS_CHKSUM1,
+    RS_CHKSUM2,
+};
+
+typedef struct GDBState {
+    bool init;       /* have we been initialised? */
+    CPUState *c_cpu; /* current CPU for step/continue ops */
+    CPUState *g_cpu; /* current CPU for other ops */
+    CPUState *query_cpu; /* for q{f|s}ThreadInfo */
+    enum RSState state; /* parsing state */
+    char line_buf[MAX_PACKET_LENGTH];
+    int line_buf_index;
+    int line_sum; /* running checksum */
+    int line_csum; /* checksum at the end of the packet */
+    GByteArray *last_packet;
+    int signal;
+    bool multiprocess;
+    GDBProcess *processes;
+    int process_num;
+    char syscall_buf[256];
+    gdb_syscall_complete_cb current_syscall_cb;
+    GString *str_buf;
+    GByteArray *mem_buf;
+    int sstep_flags;
+    int supported_sstep_flags;
+} GDBState;
+
+/*
+ * Break/Watch point support - there is an implementation for softmmu
+ * and user mode.
+ */
 bool gdb_supports_guest_debug(void);
 int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len);
 int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len);
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 1e6f8978b5..ef506faa8e 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -41,8 +41,6 @@
 #include "hw/boards.h"
 #endif
 
-#define MAX_PACKET_LENGTH 4096
-
 #include "qemu/sockets.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
@@ -325,23 +323,6 @@ typedef struct GDBRegisterState {
     struct GDBRegisterState *next;
 } GDBRegisterState;
 
-typedef struct GDBProcess {
-    uint32_t pid;
-    bool attached;
-
-    char target_xml[1024];
-} GDBProcess;
-
-enum RSState {
-    RS_INACTIVE,
-    RS_IDLE,
-    RS_GETLINE,
-    RS_GETLINE_ESC,
-    RS_GETLINE_RLE,
-    RS_CHKSUM1,
-    RS_CHKSUM2,
-};
-
 #ifdef CONFIG_USER_ONLY
 typedef struct {
     int fd;
@@ -357,29 +338,6 @@ typedef struct {
 static GDBSystemState gdbserver_system_state;
 #endif
 
-typedef struct GDBState {
-    bool init;       /* have we been initialised? */
-    CPUState *c_cpu; /* current CPU for step/continue ops */
-    CPUState *g_cpu; /* current CPU for other ops */
-    CPUState *query_cpu; /* for q{f|s}ThreadInfo */
-    enum RSState state; /* parsing state */
-    char line_buf[MAX_PACKET_LENGTH];
-    int line_buf_index;
-    int line_sum; /* running checksum */
-    int line_csum; /* checksum at the end of the packet */
-    GByteArray *last_packet;
-    int signal;
-    bool multiprocess;
-    GDBProcess *processes;
-    int process_num;
-    char syscall_buf[256];
-    gdb_syscall_complete_cb current_syscall_cb;
-    GString *str_buf;
-    GByteArray *mem_buf;
-    int sstep_flags;
-    int supported_sstep_flags;
-} GDBState;
-
 static GDBState gdbserver_state;
 
 static void init_gdbserver_state(void)
-- 
2.39.2

