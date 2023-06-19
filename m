Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0F4734DF5
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjFSIea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjFSIdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:33:24 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16A6E106;
        Mon, 19 Jun 2023 01:33:22 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Bxa+rHEpBkP8wGAA--.13978S3;
        Mon, 19 Jun 2023 16:33:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxC8q3EpBkAgsgAA--.15169S27;
        Mon, 19 Jun 2023 16:33:11 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        tangyouling@loongson.cn
Subject: [PATCH v14 25/30] LoongArch: KVM: Implement handle fpu exception
Date:   Mon, 19 Jun 2023 16:32:50 +0800
Message-Id: <20230619083255.3841777-26-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230619083255.3841777-1-zhaotianrui@loongson.cn>
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxC8q3EpBkAgsgAA--.15169S27
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
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

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 36a838607218..17e94ecec140 100644
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

