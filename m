Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48B7AF970
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjI0EeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjI0EdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:33:17 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD0A0121;
        Tue, 26 Sep 2023 20:10:04 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxLOsKnRNl3hYtAA--.15390S3;
        Wed, 27 Sep 2023 11:10:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S5;
        Wed, 27 Sep 2023 11:10:02 +0800 (CST)
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
Subject: [PATCH v22 03/25] LoongArch: KVM: Implement kvm hardware enable, disable interface
Date:   Wed, 27 Sep 2023 11:09:37 +0800
Message-Id: <20230927030959.3629941-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S5
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

Implement kvm hardware enable, disable interface, setting the
guest config register to enable virtualization features when called
the interface.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/main.c | 62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 267c0505ea..1c1d519950 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -249,6 +249,68 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
 	change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
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
+int kvm_arch_hardware_enable(void)
+{
+	unsigned long env, gcfg = 0;
+
+	env = read_csr_gcfg();
+
+	/* First init gcfg, gstat, gintc, gtlbc. All guest use the same config */
+	write_csr_gcfg(0);
+	write_csr_gstat(0);
+	write_csr_gintc(0);
+	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
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
+	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
+		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	write_csr_gcfg(0);
+	write_csr_gstat(0);
+	write_csr_gintc(0);
+	clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
+
+	/* Flush any remaining guest TLB entries */
+	kvm_flush_tlb_all();
+}
+
 static int kvm_loongarch_env_init(void)
 {
 	int cpu, order;
-- 
2.39.3

