Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12F7A131F
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjIOBuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjIOBuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:07 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D5E02708;
        Thu, 14 Sep 2023 18:50:02 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxbetFuANl2P4nAA--.9231S3;
        Fri, 15 Sep 2023 09:49:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S13;
        Fri, 15 Sep 2023 09:49:57 +0800 (CST)
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
Subject: [PATCH v21 11/29] LoongArch: KVM: Implement fpu related operations for vcpu
Date:   Fri, 15 Sep 2023 09:49:31 +0800
Message-Id: <20230915014949.1222777-12-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S13
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch fpu related interface for vcpu, such as get fpu, set
fpu, own fpu and lose fpu, etc.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 6b1b2a058b..b8af4a200c 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -276,6 +276,66 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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

