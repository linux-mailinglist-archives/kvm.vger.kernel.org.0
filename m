Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7F5715333
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 03:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjE3BxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 21:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjE3Bwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 21:52:55 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1874B12D;
        Mon, 29 May 2023 18:52:35 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dx_+vhVnVk2WoCAA--.5416S3;
        Tue, 30 May 2023 09:52:33 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxQbTYVnVkQNZ_AA--.12077S27;
        Tue, 30 May 2023 09:52:32 +0800 (CST)
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
Subject: [PATCH v12 25/31] LoongArch: KVM: Implement handle fpu exception
Date:   Tue, 30 May 2023 09:52:17 +0800
Message-Id: <20230530015223.147755-26-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230530015223.147755-1-zhaotianrui@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxQbTYVnVkQNZ_AA--.12077S27
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7trWDZrW7uw1UtrW8JFWDArb_yoW8JFW8pF
        WfAwnYkr48Wry7ta9Iy3ZFqrsxArWkKry7Wr9Fk345Zw4Ut3s5XF48KrWvgFy5Kr1rXa1S
        qr13KF98uF1UJ3DanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bx8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement handle fpu exception, using kvm_own_fpu to enable fpu for
guest.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 1237ceb06d0c..10f9922a7e76 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -631,3 +631,29 @@ static int _kvm_handle_read_fault(struct kvm_vcpu *vcpu)
 {
 	return _kvm_handle_mmu_fault(vcpu, false);
 }
+
+/**
+ * _kvm_handle_fpu_disabled() - Guest used fpu however it is disabled at host
+ * @vcpu:	Virtual CPU context.
+ *
+ * Handle when the guest attempts to use fpu which hasn't been allowed
+ * by the root context.
+ */
+static int _kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	/*
+	 * If guest FPU not present, the FPU operation should have been
+	 * treated as a reserved instruction!
+	 * If FPU already in use, we shouldn't get this at all.
+	 */
+	if (WARN_ON(vcpu->arch.aux_inuse & KVM_LARCH_FPU)) {
+		kvm_err("%s internal error\n", __func__);
+		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		return RESUME_HOST;
+	}
+
+	kvm_own_fpu(vcpu);
+	return RESUME_GUEST;
+}
-- 
2.39.1

