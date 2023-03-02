Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64CF6A8927
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCBTJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCBTJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:12 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A61B265AF
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:54 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j2so117145wrh.9
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbnWOXh4ZExL9KJ5IqauLpuFcCfssFumF9ny95ox2i8=;
        b=IPI+6Gk7NYKXNZza05A834y6TpN8DALtHsZetaiTaxMlqJmMqUfqEWijlq7+vj+GZU
         T4sTwET7CEM0Ksqjf8q9uWmPjCMFogW6HfCic9FuCGZAsCc9vYNfJ09m3CIBzt1lhNMu
         mW35GsGmBrUNTqCqT/LByr1cOumN1O9v9jHOe0Xp7urTyaTpW3yrs1I7ExnPRg3hoppv
         68AC9nvaklylPBBkUSjNThhscvVbQFRit+YWGCe+U5bqbNE838b0cxUA6VoDi2RsjcVt
         h76y+TstjC5Kp07+PUCXJP2gbzVDGslt6hZUyRcsBzLvS8ApKyeVt9vTxTjng939Qw5u
         RWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbnWOXh4ZExL9KJ5IqauLpuFcCfssFumF9ny95ox2i8=;
        b=MJpqxs1wRXurLPDKu4nukRhfm5spARioKVNp6+4RyTPIlTfnDTZVBe/KseitwSKi3e
         DHu5MbXQkA8h9wuEllxwpaFhFREeguM85nRRWQ56hNDyKbQk9gPEZzOZptgK3jecD126
         f5v8nDyIfwBqYiBKn+kVUqndQaQjzwNlZoHD5To83iPVlcO2TApUtD4irBnvqDm5WUxC
         iQlunVUrCUKAcT6IWqaEWoXXAOyP8UpFfayzOC/o53OfVf5831HWaVWslinOBRRROHBd
         7bdT8qIoz2oLvtqLkPXu50yF63Zr3EdPBxFBUscWqwdGAzp5xNc/zXghBGpzTts5X2vs
         FtEw==
X-Gm-Message-State: AO0yUKXBehG9W6iTGshH7uT5MD3fHsrpGRKahEajEYAIQjKXLdHEIIFn
        Sx7qysV0iF5j+s+x9l+rIoz+OA==
X-Google-Smtp-Source: AK7set+sgWnQU7C1557YTr26sjJJG7QJkrJhRZa4q9qR+57x/VqQHBAAVOWgrFutk1LRjL326N5Fuw==
X-Received: by 2002:adf:f483:0:b0:2c7:d7ca:4c89 with SMTP id l3-20020adff483000000b002c7d7ca4c89mr8552024wro.58.1677784133103;
        Thu, 02 Mar 2023 11:08:53 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n1-20020adffe01000000b002c4084d3472sm141397wrr.58.2023.03.02.11.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:52 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4781C1FFC1;
        Thu,  2 Mar 2023 19:08:48 +0000 (GMT)
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
Subject: [PATCH v4 12/26] gdbstub: rationalise signal mapping in softmmu
Date:   Thu,  2 Mar 2023 19:08:32 +0000
Message-Id: <20230302190846.2593720-13-alex.bennee@linaro.org>
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

We don't really need a table for mapping two symbols.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/softmmu.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index a6c196ade6..6796761fd9 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -506,20 +506,14 @@ enum {
     TARGET_SIGTRAP = 5
 };
 
-static int gdb_signal_table[] = {
-    -1,
-    -1,
-    TARGET_SIGINT,
-    -1,
-    -1,
-    TARGET_SIGTRAP
-};
-
 int gdb_signal_to_target(int sig)
 {
-    if (sig < ARRAY_SIZE(gdb_signal_table)) {
-        return gdb_signal_table[sig];
-    } else {
+    switch (sig) {
+    case 2:
+        return TARGET_SIGINT;
+    case 5:
+        return TARGET_SIGTRAP;
+    default:
         return -1;
     }
 }
-- 
2.39.2

