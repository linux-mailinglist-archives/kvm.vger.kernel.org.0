Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D866A8924
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCBTJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCBTJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835D731E36
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:52 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j2so117067wrh.9
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhv1r+37cIdO73Hx2ePtuQOU7s/kw+X5fYnQSMO6fRk=;
        b=fv7CdPJTK9CJaeTbeeSsek2LKFF9kpjrFZaRix6juRaohfp3SLvfs3Ggy602Up+h22
         rM2xGkf/oXZa4xPJz1dMsS/9nSu4BO2fUaLutGMQQZBJacAaysZ9yjQaij8vg+rbctxQ
         Q5MnIaXHSg9UzOK0B53f4LSbOxoFhEJqE/JrC9ChRXQiO2ZQZ+9DU+Xq0CMEbWfA2HBB
         Kxe50BtD8Df5BZeNZ2RrVKItDRm/fhDLrIk6vt0R20H34+d4SvBadDANJHcqLzxkCqCV
         kc70xW8lcrMlG6QToYS7BYHHbJOq+m1tQBnEwCkuHs+ArsDP3CmduWv/bJKuT+1ibyy2
         VQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhv1r+37cIdO73Hx2ePtuQOU7s/kw+X5fYnQSMO6fRk=;
        b=d01FWDcJc0I/0zJbnEr5YRdZEPrlMwmlGsaEUVo0jKU0Y+8hIuqJF8Xv51d1EtLPee
         T79yJKLWiPdG/3Zjvt/bHkz3xxyM3Bpv880+wu+bqll3gKtYNX7Yyx7i0X/K/PMHUNnt
         rMDT48FDlyss00BuoENhB8mEQkHFKuQdmIAoO9e9ZuGfCbmQdG/f71c70m/ptaPu72nL
         75EiukjQ7S0UecVFHpYMEhvP1GaaBV8/uB5Zew4QvlXHcOQVL/fAlItPc9LMTDSu5j28
         9DaByCCQ/St1ZoUHJHSkqgI3E8tPD8WGWsTnfuf4CJPPHocmjxOpAxL1NKbYuoi8iHT9
         ioLg==
X-Gm-Message-State: AO0yUKX2n9SFUPhVdWdMy/FtomFMFRZC85SP9k5w9ml1LS75KwZ6/xLA
        ZVB2hEjmo3+nteZnd2Suh+EFJQ==
X-Google-Smtp-Source: AK7set+LEp66kxPk8JP5WMjaKbMYNiQxBVToigX4wmvxYtjwSkY7GbDiNpyXd9Ln+qPbqAZZcuMcIA==
X-Received: by 2002:a5d:604b:0:b0:2c7:faf:af32 with SMTP id j11-20020a5d604b000000b002c70fafaf32mr7953987wrt.14.1677784131052;
        Thu, 02 Mar 2023 11:08:51 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d4944000000b002c56013c07fsm114369wrs.109.2023.03.02.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:48 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 941401FFB7;
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
Subject: [PATCH v4 08/26] gdbstub: move fromhex/tohex routines to internals
Date:   Thu,  2 Mar 2023 19:08:28 +0000
Message-Id: <20230302190846.2593720-9-alex.bennee@linaro.org>
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

These will be needed from multiple places in the code. They are
declared as inline so move to the header and fix up to modern coding
style.

The only other place that messes with hex stuff at the moment is the
URI handling in utils but that would be more code churn so leave for
now.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/internals.h | 27 +++++++++++++++++++++++++++
 gdbstub/gdbstub.c   | 20 --------------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 32daaf73a3..b4620f99c4 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -57,6 +57,33 @@ typedef struct GDBState {
     int supported_sstep_flags;
 } GDBState;
 
+
+/*
+ * Inline utility function, convert from int to hex and back
+ */
+
+static inline int fromhex(int v)
+{
+    if (v >= '0' && v <= '9') {
+        return v - '0';
+    } else if (v >= 'A' && v <= 'F') {
+        return v - 'A' + 10;
+    } else if (v >= 'a' && v <= 'f') {
+        return v - 'a' + 10;
+    } else {
+        return 0;
+    }
+}
+
+static inline int tohex(int v)
+{
+    if (v < 10) {
+        return v + '0';
+    } else {
+        return v - 10 + 'a';
+    }
+}
+
 /*
  * Break/Watch point support - there is an implementation for softmmu
  * and user mode.
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index abb1777e73..ba46ed73b3 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -546,26 +546,6 @@ static void put_buffer(const uint8_t *buf, int len)
 #endif
 }
 
-static inline int fromhex(int v)
-{
-    if (v >= '0' && v <= '9')
-        return v - '0';
-    else if (v >= 'A' && v <= 'F')
-        return v - 'A' + 10;
-    else if (v >= 'a' && v <= 'f')
-        return v - 'a' + 10;
-    else
-        return 0;
-}
-
-static inline int tohex(int v)
-{
-    if (v < 10)
-        return v + '0';
-    else
-        return v - 10 + 'a';
-}
-
 /* writes 2*len+1 bytes in buf */
 static void memtohex(GString *buf, const uint8_t *mem, int len)
 {
-- 
2.39.2

