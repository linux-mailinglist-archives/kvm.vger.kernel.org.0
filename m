Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89F6956F8
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjBNC5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjBNC44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:56:56 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F2618A94;
        Mon, 13 Feb 2023 18:56:54 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxWNl0+OpjP1cAAA--.850S3;
        Tue, 14 Feb 2023 10:56:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axeb1w+OpjmZwyAA--.28802S7;
        Tue, 14 Feb 2023 10:56:51 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v1 05/24] LoongArch: KVM: Implement vcpu ENABLE_CAP, CHECK_EXTENSION ioctl interface
Date:   Tue, 14 Feb 2023 10:56:29 +0800
Message-Id: <20230214025648.1898508-6-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axeb1w+OpjmZwyAA--.28802S7
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7WF17ArW5CryDGr1kGryxGrg_yoW8WFykpF
        47A34Fqr4rJ3yIgwn3tws3ur1aqr4kKr4xZFZrX3y5AF12kry5KF4F9rZrJFW5Ja1rWF1I
        q3WFqF1Y9Fs8Z37anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
        kF7I0E14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch vcpu KVM_ENABLE_CAP, KVM_CHECK_EXTENSION ioctl
interface.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index a18864284..dd803f26d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -415,6 +415,29 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
+				     struct kvm_enable_cap *cap)
+{
+	int r = 0;
+
+	if (!kvm_vm_ioctl_check_extension(vcpu->kvm, cap->cap))
+		return -EINVAL;
+	if (cap->flags)
+		return -EINVAL;
+	if (cap->args[0])
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_LOONGARCH_FPU:
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -438,6 +461,29 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			r = _kvm_get_reg(vcpu, &reg);
 		break;
 	}
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap cap;
+
+		r = -EFAULT;
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			break;
+		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
+		break;
+	}
+	case KVM_CHECK_EXTENSION: {
+		unsigned int ext;
+
+		if (copy_from_user(&ext, argp, sizeof(ext)))
+			return -EFAULT;
+		switch (ext) {
+		case KVM_CAP_LOONGARCH_FPU:
+			r = !!cpu_has_fpu;
+			break;
+		default:
+			break;
+		}
+		break;
+	}
 	case KVM_GET_CSRS: {
 		r = kvm_csr_io(vcpu, argp, _kvm_getcsr);
 		break;
-- 
2.31.1

