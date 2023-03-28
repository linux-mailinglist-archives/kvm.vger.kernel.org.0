Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751096CBF30
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjC1McH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjC1Mbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:50 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F95C9010;
        Tue, 28 Mar 2023 05:31:32 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxxtge3iJkqhkTAA--.29154S3;
        Tue, 28 Mar 2023 20:31:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S28;
        Tue, 28 Mar 2023 20:31:26 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 26/29] LoongArch: KVM: Implement kvm exception vector
Date:   Tue, 28 Mar 2023 20:31:16 +0800
Message-Id: <20230328123119.3649361-27-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S28
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Kw15tF1UurWUKF17uF4UJwb_yoW8ZFW8pF
        yfA34Yyr48W342ya4akw1vgF13AayxKr17WrW7G345uw4jqryrtrWkK397JF43KryrZF1x
        JFZ8tFn8uF4UG37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm exception vector, using _kvm_fault_tables array to save
the handle function pointer and it is used when vcpu handle exit.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index fc2152e09..1f95189f6 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -651,3 +651,51 @@ static int _kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 	kvm_own_fpu(vcpu);
 	return RESUME_GUEST;
 }
+
+/*
+ * Loongarch KVM callback handling for not implemented guest exiting
+ */
+static int _kvm_fault_ni(struct kvm_vcpu *vcpu)
+{
+	unsigned long estat, badv;
+	unsigned int exccode, inst;
+
+	/*
+	 *  Fetch the instruction.
+	 */
+	badv = vcpu->arch.badv;
+	estat = vcpu->arch.host_estat;
+	exccode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+	inst = vcpu->arch.badi;
+	kvm_err("Exccode: %d PC=%#lx inst=0x%08x BadVaddr=%#lx estat=%#llx\n",
+			exccode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
+	kvm_arch_vcpu_dump_regs(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+
+	return RESUME_HOST;
+}
+
+static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
+	[EXCCODE_TLBL]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBI]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBNR]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBNX]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBS]		= _kvm_handle_write_fault,
+	[EXCCODE_TLBM]		= _kvm_handle_write_fault,
+	[EXCCODE_FPDIS]		= _kvm_handle_fpu_disabled,
+	[EXCCODE_GSPR]		= _kvm_handle_gspr,
+};
+
+int _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
+{
+	return _kvm_fault_tables[fault](vcpu);
+}
+
+void _kvm_init_fault(void)
+{
+	int i;
+
+	for (i = 0; i < EXCCODE_INT_START; i++)
+		if (!_kvm_fault_tables[i])
+			_kvm_fault_tables[i] = _kvm_fault_ni;
+}
-- 
2.31.1

