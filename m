Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A067E715337
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 03:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjE3BxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 21:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjE3BxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 21:53:02 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6268513E;
        Mon, 29 May 2023 18:52:37 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Bxy_LjVnVk9GoCAA--.5582S3;
        Tue, 30 May 2023 09:52:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxQbTYVnVkQNZ_AA--.12077S30;
        Tue, 30 May 2023 09:52:34 +0800 (CST)
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
Subject: [PATCH v12 28/31] LoongArch: KVM: Implement probe virtualization when LoongArch cpu init
Date:   Tue, 30 May 2023 09:52:20 +0800
Message-Id: <20230530015223.147755-29-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230530015223.147755-1-zhaotianrui@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxQbTYVnVkQNZ_AA--.12077S30
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7WFWxGrW5Kw47tr17uF43Awb_yoW8uFWxpr
        WayrW3trWUKFn2ga93Gr1agrnxtFWkta129F47JayfAr4Uta15Xwn3u34UCFn7Zw4Iyryr
        Xrn7A3Z2qF1DX3JanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement probe virtualization when LoongArch cpu init, including guest
gid info, guest fpu info, etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kernel/cpu-probe.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 5adf0f736c6d..d6f7e7cbb2ed 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -181,6 +181,55 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
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
+	unsigned long gcfg;
+
+	cpu_probe_guestinfo(c);
+
+	c->guest.options |= LOONGARCH_CPU_FPU;
+	c->guest.options_dyn |= LOONGARCH_CPU_FPU;
+	c->guest.options_dyn |= LOONGARCH_CPU_PMP;
+
+	c->guest.options |= LOONGARCH_CPU_LSX;
+	c->guest.options_dyn |= LOONGARCH_CPU_LSX;
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
@@ -294,6 +343,8 @@ void cpu_probe(void)
 	if (cpu == 0)
 		__ua_limit = ~((1ull << cpu_vabits) - 1);
 #endif
+	if (cpu_has_lvz)
+		cpu_probe_lvz(c);
 
 	cpu_report();
 }
-- 
2.39.1

