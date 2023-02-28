Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A35B6A5356
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 08:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjB1HBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 02:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1HBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 02:01:03 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A29CD5273;
        Mon, 27 Feb 2023 23:01:00 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxJPSrpv1jLmAGAA--.6373S3;
        Tue, 28 Feb 2023 15:00:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxc+Wppv1jPG9AAA--.15462S5;
        Tue, 28 Feb 2023 15:00:58 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v3 03/29] LoongArch: KVM: Implement kvm hardware enable, disable interface
Date:   Tue, 28 Feb 2023 15:00:30 +0800
Message-Id: <20230228070057.3687180-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230228070057.3687180-1-zhaotianrui@loongson.cn>
References: <20230228070057.3687180-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxc+Wppv1jPG9AAA--.15462S5
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Ar4DJrWxKFW5ZF43JrWDArb_yoW8tFWfpr
        WUAay5ArW5Jr1SgasxJ3Zxtry3WrWvgayxXa12ya45ZF4j9F4rXF95Kr9rJFyjgay8JF1S
        v3ySyFyYgF1DAwUanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bckFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 arch/loongarch/kvm/main.c | 63 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f72634ea2027..214d1e9e24eb 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -13,6 +13,69 @@ static struct kvm_context __percpu *vmcs;
 struct kvm_world_switch *kvm_loongarch_ops;
 unsigned long vpid_mask;
 
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
+	unsigned long gcfg = 0;
+
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
+	if (cpu_has_gcip_all)
+		gcfg |= CSR_GCFG_GCI_SECURE;
+	if (cpu_has_matc_root)
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
2.31.1

