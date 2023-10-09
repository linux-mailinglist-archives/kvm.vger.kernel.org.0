Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1377BD60D
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345667AbjJIJCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345629AbjJIJCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:02:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91E95D8
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 02:02:16 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxLOuWwSNllz0wAA--.21671S3;
        Mon, 09 Oct 2023 17:02:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx_y+TwSNlDW4cAA--.59991S5;
        Mon, 09 Oct 2023 17:02:13 +0800 (CST)
From:   xianglai li <lixianglai@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>
Subject: [PATCH RFC v4 3/9] target/loongarch: Supplement vcpu env initial when vcpu reset
Date:   Mon,  9 Oct 2023 17:01:31 +0800
Message-Id: <9374877045c45abee710d476d46dd028f17cd84c.1696841645.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1696841645.git.lixianglai@loongson.cn>
References: <cover.1696841645.git.lixianglai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dx_y+TwSNlDW4cAA--.59991S5
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianrui Zhao <zhaotianrui@loongson.cn>

Supplement vcpu env initial when vcpu reset, including
init vcpu CSR_CPUID,CSR_TID to cpu->cpu_index. The two
regs will be used in kvm_get/set_csr_ioctl.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Marc-André Lureau" <marcandre.lureau@redhat.com>
Cc: "Daniel P. Berrangé" <berrange@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Song Gao <gaosong@loongson.cn>
Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: xianglai li <lixianglai@loongson.cn>
---
 target/loongarch/cpu.c | 2 ++
 target/loongarch/cpu.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 2bea7ca5d5..0d763d8a65 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -524,10 +524,12 @@ static void loongarch_cpu_reset_hold(Object *obj)
 
     env->CSR_ESTAT = env->CSR_ESTAT & (~MAKE_64BIT_MASK(0, 2));
     env->CSR_RVACFG = FIELD_DP64(env->CSR_RVACFG, CSR_RVACFG, RBITS, 0);
+    env->CSR_CPUID = cs->cpu_index;
     env->CSR_TCFG = FIELD_DP64(env->CSR_TCFG, CSR_TCFG, EN, 0);
     env->CSR_LLBCTL = FIELD_DP64(env->CSR_LLBCTL, CSR_LLBCTL, KLO, 0);
     env->CSR_TLBRERA = FIELD_DP64(env->CSR_TLBRERA, CSR_TLBRERA, ISTLBR, 0);
     env->CSR_MERRCTL = FIELD_DP64(env->CSR_MERRCTL, CSR_MERRCTL, ISMERR, 0);
+    env->CSR_TID = cs->cpu_index;
 
     env->CSR_PRCFG3 = FIELD_DP64(env->CSR_PRCFG3, CSR_PRCFG3, TLB_TYPE, 2);
     env->CSR_PRCFG3 = FIELD_DP64(env->CSR_PRCFG3, CSR_PRCFG3, MTLB_ENTRY, 63);
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 40e70a8119..e6a99c83ab 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -318,6 +318,7 @@ typedef struct CPUArchState {
     uint64_t CSR_PWCH;
     uint64_t CSR_STLBPS;
     uint64_t CSR_RVACFG;
+    uint64_t CSR_CPUID;
     uint64_t CSR_PRCFG1;
     uint64_t CSR_PRCFG2;
     uint64_t CSR_PRCFG3;
@@ -349,7 +350,6 @@ typedef struct CPUArchState {
     uint64_t CSR_DBG;
     uint64_t CSR_DERA;
     uint64_t CSR_DSAVE;
-    uint64_t CSR_CPUID;
 
 #ifndef CONFIG_USER_ONLY
     LoongArchTLB  tlb[LOONGARCH_TLB_MAX];
-- 
2.39.1

