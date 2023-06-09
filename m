Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2263729476
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 11:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241281AbjFIJO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 05:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbjFIJOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 05:14:05 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E24F95587;
        Fri,  9 Jun 2023 02:09:45 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Ax3eoU7IJk9fwAAA--.2994S3;
        Fri, 09 Jun 2023 17:08:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxFOQQ7IJkzHQKAA--.31790S5;
        Fri, 09 Jun 2023 17:08:35 +0800 (CST)
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
Subject: [PATCH v13 03/30] LoongArch: KVM: Implement kvm hardware enable, disable interface
Date:   Fri,  9 Jun 2023 17:08:05 +0800
Message-Id: <20230609090832.2131037-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxFOQQ7IJkzHQKAA--.31790S5
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

Implement kvm hardware enable, disable interface, setting
the guest config register to enable virtualization features
when called the interface.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/main.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f98c1619725f..5ebae1ea7565 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -195,6 +195,70 @@ static void _kvm_init_gcsr_flag(void)
 	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
 }
 
+void kvm_init_vmcs(struct kvm *kvm)
+{
+	kvm->arch.vmcs = vmcs;
+}
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
+#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+int kvm_arch_hardware_enable(void)
+{
+	unsigned long env, gcfg = 0;
+
+	env = read_csr_gcfg();
+	/* First init gtlbc, gcfg, gstat, gintc. All guest use the same config */
+	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
+	write_csr_gcfg(0);
+	write_csr_gstat(0);
+	write_csr_gintc(0);
+
+	/*
+	 * Enable virtualization features granting guest direct control of
+	 * certain features:
+	 * GCI=2:       Trap on init or unimplement cache instruction.
+	 * TORU=0:      Trap on Root Unimplement.
+	 * CACTRL=1:    Root control cache.
+	 * TOP=0:       Trap on Previlege.
+	 * TOE=0:       Trap on Exception.
+	 * TIT=0:       Trap on Timer.
+	 */
+	if (env & CSR_GCFG_GCIP_ALL)
+		gcfg |= CSR_GCFG_GCI_SECURE;
+	if (env & CSR_GCFG_MATC_ROOT)
+		gcfg |= CSR_GCFG_MATC_ROOT;
+
+	gcfg |= CSR_GCFG_TIT;
+	write_csr_gcfg(gcfg);
+
+	kvm_flush_tlb_all();
+
+	/* Enable using TGID  */
+	set_csr_gtlbc(CSR_GTLBC_USETGID);
+	kvm_debug("gtlbc:%llx gintc:%llx gstat:%llx gcfg:%llx",
+			read_csr_gtlbc(), read_csr_gintc(),
+			read_csr_gstat(), read_csr_gcfg());
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
+	write_csr_gcfg(0);
+	write_csr_gstat(0);
+	write_csr_gintc(0);
+
+	/* Flush any remaining guest TLB entries */
+	kvm_flush_tlb_all();
+}
+#endif
+
 static int kvm_loongarch_env_init(void)
 {
 	struct kvm_context *context;
-- 
2.39.1

