Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9620F70B3C1
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 05:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjEVDYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 23:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjEVDY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 23:24:28 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A85D7E46;
        Sun, 21 May 2023 20:21:37 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxyOmV3WpkQMsKAA--.18762S3;
        Mon, 22 May 2023 11:12:21 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMiR3WpkJIFuAA--.54000S13;
        Mon, 22 May 2023 11:12:21 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v11 11/31] LoongArch: KVM: Implement fpu related operations for vcpu
Date:   Mon, 22 May 2023 11:11:57 +0800
Message-Id: <20230522031217.956464-12-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230522031217.956464-1-zhaotianrui@loongson.cn>
References: <20230522031217.956464-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxMMiR3WpkJIFuAA--.54000S13
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7AF45CryDuFWruw4DKw1Dtrb_yoW8ur1kpF
        W7Ar98X3yrG3WxK3yaqr1jvr1av3ykKr1xXa47Xry3Ar1UtryrZr4vkrW2vF98Jw1fZFyI
        yF1fGF45CFyDAwUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch fpu related interface for vcpu, such as get fpu, set
fpu, own fpu and lose fpu, etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 5a88f815c412..60213f7f7bac 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -244,6 +244,66 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	int i = 0;
+
+	/* no need vcpu_load and vcpu_put */
+	fpu->fcsr = vcpu->arch.fpu.fcsr;
+	fpu->fcc = vcpu->arch.fpu.fcc;
+	for (i = 0; i < NUM_FPU_REGS; i++)
+		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], FPU_REG_WIDTH / 64);
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	int i = 0;
+
+	/* no need vcpu_load and vcpu_put */
+	vcpu->arch.fpu.fcsr = fpu->fcsr;
+	vcpu->arch.fpu.fcc = fpu->fcc;
+	for (i = 0; i < NUM_FPU_REGS; i++)
+		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], FPU_REG_WIDTH / 64);
+
+	return 0;
+}
+
+/* Enable FPU for guest and restore context */
+void kvm_own_fpu(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+
+	/*
+	 * Enable FPU for guest
+	 */
+	set_csr_euen(CSR_EUEN_FPEN);
+
+	kvm_restore_fpu(&vcpu->arch.fpu);
+	vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
+	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
+
+	preempt_enable();
+}
+
+/* Save and disable FPU */
+void kvm_lose_fpu(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+
+	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
+		kvm_save_fpu(&vcpu->arch.fpu);
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
+		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
+
+		/* Disable FPU */
+		clear_csr_euen(CSR_EUEN_FPEN);
+	}
+
+	preempt_enable();
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
-- 
2.39.1

