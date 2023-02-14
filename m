Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18656956F0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBNC5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjBNC5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:57:01 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 512021B30D;
        Mon, 13 Feb 2023 18:56:59 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxxth6+Opj1VcAAA--.368S3;
        Tue, 14 Feb 2023 10:56:58 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axeb1w+OpjmZwyAA--.28802S25;
        Tue, 14 Feb 2023 10:56:57 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v1 23/24] LoongArch: KVM: Implement probe virtualization when loongarch cpu init
Date:   Tue, 14 Feb 2023 10:56:47 +0800
Message-Id: <20230214025648.1898508-24-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axeb1w+OpjmZwyAA--.28802S25
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Zw1fCFWfZw1DJr47ZrW5KFg_yoW8tFy5pr
        W2vFW3trWUKr92ga93Gr1agrnxtFWkKa129F47tayfAr4Ut3W5Xwn3C34UCFs7Zw4xAryr
        Xrn7A3WvqF1DX3JanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement probe virtualization when loongarch cpu init, including guest
gid info, guest fpu info, etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kernel/cpu-probe.c | 53 +++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 3a3fce2d7..9c3483d9a 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -176,6 +176,57 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	}
 }
 
+static inline void cpu_probe_guestinfo(struct cpuinfo_loongarch *c)
+{
+	unsigned long guestinfo;
+
+	guestinfo = read_csr_gstat();
+	if (guestinfo & CSR_GSTAT_GIDBIT) {
+		c->options |= LOONGARCH_CPU_GUESTID;
+		write_csr_gstat(0);
+	}
+}
+
+static inline void cpu_probe_lvz(struct cpuinfo_loongarch *c)
+{
+	unsigned long gcfg, gprcfg1;
+
+	cpu_probe_guestinfo(c);
+
+	c->guest.options |= LOONGARCH_CPU_FPU;
+	c->guest.options_dyn |= LOONGARCH_CPU_FPU;
+	c->guest.options_dyn |= LOONGARCH_CPU_PMP;
+
+	c->guest.ases |= LOONGARCH_CPU_LSX;
+	c->guest.ases_dyn |= LOONGARCH_CPU_LSX;
+	gprcfg1 = read_gcsr_prcfg1();
+	c->guest.kscratch_mask = GENMASK((gprcfg1 & CSR_CONF1_KSNUM) - 1, 0);
+
+	gcfg = read_csr_gcfg();
+	if (gcfg & CSR_GCFG_MATP_GUEST)
+		c->guest_cfg |= BIT(0);
+	if (gcfg & CSR_GCFG_MATP_ROOT)
+		c->guest_cfg |= BIT(1);
+	if (gcfg & CSR_GCFG_MATP_NEST)
+		c->guest_cfg |= BIT(2);
+	if (gcfg & CSR_GCFG_SITP)
+		c->guest_cfg |= BIT(6);
+	if (gcfg & CSR_GCFG_TITP)
+		c->guest_cfg |= BIT(8);
+	if (gcfg & CSR_GCFG_TOEP)
+		c->guest_cfg |= BIT(10);
+	if (gcfg & CSR_GCFG_TOPP)
+		c->guest_cfg |= BIT(12);
+	if (gcfg & CSR_GCFG_TORUP)
+		c->guest_cfg |= BIT(14);
+	if (gcfg & CSR_GCFG_GCIP_ALL)
+		c->guest_cfg |= BIT(16);
+	if (gcfg & CSR_GCFG_GCIP_HIT)
+		c->guest_cfg |= BIT(17);
+	if (gcfg & CSR_GCFG_GCIP_SECURE)
+		c->guest_cfg |= BIT(18);
+}
+
 #define MAX_NAME_LEN	32
 #define VENDOR_OFFSET	0
 #define CPUNAME_OFFSET	9
@@ -289,6 +340,8 @@ void cpu_probe(void)
 	if (cpu == 0)
 		__ua_limit = ~((1ull << cpu_vabits) - 1);
 #endif
+	if (cpu_has_lvz)
+		cpu_probe_lvz(c);
 
 	cpu_report();
 }
-- 
2.31.1

