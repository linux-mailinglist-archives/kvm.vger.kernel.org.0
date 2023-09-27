Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939AC7AF901
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjI0EGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjI0EFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:05:33 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CF58CE3;
        Tue, 26 Sep 2023 20:10:16 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxlPARnRNlnBctAA--.21056S3;
        Wed, 27 Sep 2023 11:10:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S23;
        Wed, 27 Sep 2023 11:10:08 +0800 (CST)
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
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 21/25] LoongArch: KVM: Implement kvm exception vectors
Date:   Wed, 27 Sep 2023 11:09:55 +0800
Message-Id: <20230927030959.3629941-22-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S23
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
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

Implement kvm exception vectors, using kvm_fault_tables array to save
the handle function pointers and it is used when vcpu handle guest exit.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index e855ab9099..ce8de3fa47 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -658,3 +658,39 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 
 	return RESUME_GUEST;
 }
+
+/*
+ * LoongArch KVM callback handling for unimplemented guest exiting
+ */
+static int kvm_fault_ni(struct kvm_vcpu *vcpu)
+{
+	unsigned int ecode, inst;
+	unsigned long estat, badv;
+
+	/* Fetch the instruction */
+	inst = vcpu->arch.badi;
+	badv = vcpu->arch.badv;
+	estat = vcpu->arch.host_estat;
+	ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+	kvm_err("ECode: %d PC=%#lx Inst=0x%08x BadVaddr=%#lx ESTAT=%#lx\n",
+			ecode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
+	kvm_arch_vcpu_dump_regs(vcpu);
+	kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+
+	return RESUME_GUEST;
+}
+
+static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
+	[0 ... EXCCODE_INT_START - 1]	= kvm_fault_ni,
+	[EXCCODE_TLBI]			= kvm_handle_read_fault,
+	[EXCCODE_TLBL]			= kvm_handle_read_fault,
+	[EXCCODE_TLBS]			= kvm_handle_write_fault,
+	[EXCCODE_TLBM]			= kvm_handle_write_fault,
+	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
+	[EXCCODE_GSPR]			= kvm_handle_gspr,
+};
+
+int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
+{
+	return kvm_fault_tables[fault](vcpu);
+}
-- 
2.39.3

