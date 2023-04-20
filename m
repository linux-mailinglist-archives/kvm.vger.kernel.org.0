Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC806E8E40
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjDTJhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjDTJgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:36:39 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E80A49ED
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 02:36:11 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxrtqJB0FkvXEfAA--.37265S3;
        Thu, 20 Apr 2023 17:36:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxwOSGB0FkUfEwAA--.29752S6;
        Thu, 20 Apr 2023 17:36:09 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH RFC v1 04/10] target/loongarch: Implement kvm get/set registers
Date:   Thu, 20 Apr 2023 17:36:00 +0800
Message-Id: <20230420093606.3366969-5-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxwOSGB0FkUfEwAA--.29752S6
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvAXoW3KFW7trWfKr17uw1DWryrtFb_yoW8GFy7Wo
        Z8C3Wfua45Jw4FkFsru3ZrXFyYqr9Y93Z3Krn8XF4F93W7JrW5Jr1xG343tw42qF95XFy8
        A3W0qFn7XaykGrnxn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXasCq-sGcSsGvf
        J3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJU
        UUqI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64
        kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY
        1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCF
        FI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_WwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv
        8VWrMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
        0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRE6wZ7UUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_get/set_registers interfaces, many regs
can be get/set in the function, such as core regs, csr regs,
fpu regs, mp state, etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/kvm.c | 353 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 351 insertions(+), 2 deletions(-)

diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
index 7c11c20c39..74d499b675 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -39,13 +39,362 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
 
+static int kvm_loongarch_get_regs_core(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    struct kvm_regs regs;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    /* Get the current register set as KVM seems it */
+    ret = kvm_vcpu_ioctl(cs, KVM_GET_REGS, &regs);
+    if (ret < 0) {
+        return ret;
+    }
+
+    for (i = 0; i < 32; i++) {
+        env->gpr[i] = regs.gpr[i];
+    }
+
+    env->pc = regs.pc;
+    return ret;
+}
+
+static int kvm_loongarch_put_regs_core(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    struct kvm_regs regs;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    /* Set the registers based on QEMU's view of things */
+    for (i = 0; i < 32; i++) {
+        regs.gpr[i] = env->gpr[i];
+    }
+
+    regs.pc = env->pc;
+    ret = kvm_vcpu_ioctl(cs, KVM_SET_REGS, &regs);
+    return ret;
+}
+
+static inline int kvm_larch_getq(CPUState *cs, uint64_t reg_id,
+                                 uint64_t *addr)
+{
+    struct kvm_one_reg csrreg = {
+        .id = reg_id,
+        .addr = (uintptr_t)addr
+    };
+
+    return kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &csrreg);
+}
+static inline int kvm_larch_putq(CPUState *cs, uint64_t reg_id,
+                                 uint64_t *addr)
+{
+    struct kvm_one_reg csrreg = {
+        .id = reg_id,
+        .addr = (uintptr_t)addr
+    };
+
+    return kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &csrreg);
+}
+
+#define LOONGARCH_CSR_64(_R, _S)  \
+        (KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | (8 * (_R) + (_S)))
+
+#define KVM_IOC_CSRID(id) LOONGARCH_CSR_64(id, 0)
+
+#define KVM_GET_ONE_UREG64(cs, ret, regidx, addr)              \
+    ({                                                         \
+        err = kvm_larch_getq(cs, KVM_IOC_CSRID(regidx), addr); \
+        if (err < 0) {                                         \
+            ret = err;                                         \
+            DPRINTF("%s: Failed to get regidx 0x%x             \
+                    err:%d\n", __func__, regidx, err);         \
+        }                                                      \
+    })
+
+#define KVM_PUT_ONE_UREG64(cs, ret, regidx, addr)              \
+    ({                                                         \
+        err = kvm_larch_putq(cs, KVM_IOC_CSRID(regidx), addr); \
+        if (err < 0) {                                         \
+            ret = err;                                         \
+            DPRINTF("%s: Failed to put regidx 0x%x             \
+                    err:%d\n", __func__, regidx, err);         \
+        }                                                      \
+    })
+
+static int kvm_loongarch_get_csr(CPUState *cs)
+{
+    int err, ret = 0;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_CRMD, &env->CSR_CRMD);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRMD, &env->CSR_PRMD);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_EUEN, &env->CSR_EUEN);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_MISC, &env->CSR_MISC);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_ECFG, &env->CSR_ECFG);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_ESTAT, &env->CSR_ESTAT);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_ERA, &env->CSR_ERA);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_BADV, &env->CSR_BADV);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_BADI, &env->CSR_BADI);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_EENTRY, &env->CSR_EENTRY);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBIDX, &env->CSR_TLBIDX);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBEHI, &env->CSR_TLBEHI);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBELO0, &env->CSR_TLBELO0);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBELO1, &env->CSR_TLBELO1);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_ASID, &env->CSR_ASID);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGDL, &env->CSR_PGDL);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGDH, &env->CSR_PGDH);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGD, &env->CSR_PGD);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PWCL, &env->CSR_PWCL);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PWCH, &env->CSR_PWCH);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_STLBPS, &env->CSR_STLBPS);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_RVACFG, &env->CSR_RVACFG);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG1, &env->CSR_PRCFG1);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG2, &env->CSR_PRCFG2);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG3, &env->CSR_PRCFG3);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(0), &env->CSR_SAVE[0]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(1), &env->CSR_SAVE[1]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(2), &env->CSR_SAVE[2]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(3), &env->CSR_SAVE[3]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(4), &env->CSR_SAVE[4]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(5), &env->CSR_SAVE[5]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(6), &env->CSR_SAVE[6]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(7), &env->CSR_SAVE[7]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TID, &env->CSR_TID);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_CNTC, &env->CSR_CNTC);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TICLR, &env->CSR_TICLR);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_LLBCTL, &env->CSR_LLBCTL);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_IMPCTL1, &env->CSR_IMPCTL1);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_IMPCTL2, &env->CSR_IMPCTL2);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRENTRY, &env->CSR_TLBRENTRY);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRBADV, &env->CSR_TLBRBADV);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRERA, &env->CSR_TLBRERA);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRSAVE, &env->CSR_TLBRSAVE);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRELO0, &env->CSR_TLBRELO0);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRELO1, &env->CSR_TLBRELO1);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBREHI, &env->CSR_TLBREHI);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRPRMD, &env->CSR_TLBRPRMD);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(0), &env->CSR_DMW[0]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(1), &env->CSR_DMW[1]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(2), &env->CSR_DMW[2]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(3), &env->CSR_DMW[3]);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TVAL, &env->CSR_TVAL);
+    KVM_GET_ONE_UREG64(cs, ret, LOONGARCH_CSR_TCFG, &env->CSR_TCFG);
+
+    return ret;
+}
+
+static int kvm_loongarch_put_csr(CPUState *cs)
+{
+    int err, ret = 0;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_CRMD, &env->CSR_CRMD);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRMD, &env->CSR_PRMD);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_EUEN, &env->CSR_EUEN);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_MISC, &env->CSR_MISC);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_ECFG, &env->CSR_ECFG);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_ESTAT, &env->CSR_ESTAT);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_ERA, &env->CSR_ERA);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_BADV, &env->CSR_BADV);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_BADI, &env->CSR_BADI);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_EENTRY, &env->CSR_EENTRY);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBIDX, &env->CSR_TLBIDX);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBEHI, &env->CSR_TLBEHI);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBELO0, &env->CSR_TLBELO0);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBELO1, &env->CSR_TLBELO1);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_ASID, &env->CSR_ASID);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGDL, &env->CSR_PGDL);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGDH, &env->CSR_PGDH);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PGD, &env->CSR_PGD);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PWCL, &env->CSR_PWCL);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PWCH, &env->CSR_PWCH);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_STLBPS, &env->CSR_STLBPS);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_RVACFG, &env->CSR_RVACFG);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_CPUID, &env->CSR_CPUID);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG1, &env->CSR_PRCFG1);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG2, &env->CSR_PRCFG2);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_PRCFG3, &env->CSR_PRCFG3);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(0), &env->CSR_SAVE[0]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(1), &env->CSR_SAVE[1]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(2), &env->CSR_SAVE[2]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(3), &env->CSR_SAVE[3]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(4), &env->CSR_SAVE[4]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(5), &env->CSR_SAVE[5]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(6), &env->CSR_SAVE[6]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_SAVE(7), &env->CSR_SAVE[7]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TID, &env->CSR_TID);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_CNTC, &env->CSR_CNTC);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TICLR, &env->CSR_TICLR);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_LLBCTL, &env->CSR_LLBCTL);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_IMPCTL1, &env->CSR_IMPCTL1);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_IMPCTL2, &env->CSR_IMPCTL2);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRENTRY, &env->CSR_TLBRENTRY);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRBADV, &env->CSR_TLBRBADV);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRERA, &env->CSR_TLBRERA);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRSAVE, &env->CSR_TLBRSAVE);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRELO0, &env->CSR_TLBRELO0);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRELO1, &env->CSR_TLBRELO1);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBREHI, &env->CSR_TLBREHI);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TLBRPRMD, &env->CSR_TLBRPRMD);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(0), &env->CSR_DMW[0]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(1), &env->CSR_DMW[1]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(2), &env->CSR_DMW[2]);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_DMW(3), &env->CSR_DMW[3]);
+    /*
+     * timer cfg must be put at last since it is used to enable
+     * guest timer
+     */
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TVAL, &env->CSR_TVAL);
+    KVM_PUT_ONE_UREG64(cs, ret, LOONGARCH_CSR_TCFG, &env->CSR_TCFG);
+    return ret;
+}
+
+static int kvm_loongarch_get_regs_fp(CPUState *cs)
+{
+    int ret, i;
+    struct kvm_fpu fpu;
+
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    ret = kvm_vcpu_ioctl(cs, KVM_GET_FPU, &fpu);
+    if (ret < 0) {
+        DPRINTF("%s: Failed to get FPU (%d)\n", __func__, err);
+        return ret;
+    }
+
+    env->fcsr0 = fpu.fcsr;
+    for (i = 0; i < 32; i++) {
+        env->fpr[i] = fpu.fpr[i].val64[0];
+    }
+    for (i = 0; i < 8; i++) {
+        env->cf[i] = fpu.fcc & 0xFF;
+        fpu.fcc = fpu.fcc >> 8;
+    }
+
+    return ret;
+}
+
+static int kvm_loongarch_put_regs_fp(CPUState *cs)
+{
+    int ret, i;
+    struct kvm_fpu fpu;
+
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    fpu.fcsr = env->fcsr0;
+    fpu.fcc = 0;
+    for (i = 0; i < 32; i++) {
+        fpu.fpr[i].val64[0] = env->fpr[i];
+    }
+
+    for (i = 0; i < 8; i++) {
+        fpu.fcc |= env->cf[i] << (8 * i);
+    }
+
+    ret = kvm_vcpu_ioctl(cs, KVM_SET_FPU, &fpu);
+    if (ret < 0) {
+        DPRINTF("%s: Failed to put FPU (%d)\n", __func__, err);
+    }
+
+    return ret;
+}
+
+static int kvm_loongarch_get_mpstate(CPUState *cs)
+{
+    int ret = 0;
+    struct kvm_mp_state mp_state;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    if (cap_has_mp_state) {
+        ret = kvm_vcpu_ioctl(cs, KVM_GET_MP_STATE, &mp_state);
+        if (ret) {
+            fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n",
+                    __func__, ret, strerror(-ret));
+            return ret;
+        }
+        env->mp_state = mp_state.mp_state;
+    }
+
+    return ret;
+}
+
+static int kvm_loongarch_put_mpstate(CPUState *cs)
+{
+    int ret = 0;
+
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+
+    struct kvm_mp_state mp_state = {
+        .mp_state = env->mp_state
+    };
+
+    if (cap_has_mp_state) {
+        ret = kvm_vcpu_ioctl(cs, KVM_SET_MP_STATE, &mp_state);
+        if (ret) {
+            fprintf(stderr, "%s: failed to set MP_STATE %d/%s\n",
+                    __func__, ret, strerror(-ret));
+        }
+    }
+
+    return ret;
+}
+
 int kvm_arch_get_registers(CPUState *cs)
 {
-    return 0;
+    int ret;
+
+    ret = kvm_loongarch_get_regs_core(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_get_csr(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_get_regs_fp(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_get_mpstate(cs);
+
+    return ret;
 }
+
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    return 0;
+    int ret;
+
+    ret = kvm_loongarch_put_regs_core(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_put_csr(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_put_regs_fp(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_loongarch_put_mpstate(cs);
+
+    return ret;
 }
 
 int kvm_arch_init_vcpu(CPUState *cs)
-- 
2.31.1

