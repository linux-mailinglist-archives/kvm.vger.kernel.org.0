Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90E6592BB1
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbiHOKOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242580AbiHOKNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:13:55 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37E5240B0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso13989679pjq.4
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=VXhIbdDVpbL7eX47teNq1sjIk/AZB5LvuaakL+oANsY=;
        b=JzeccsXtC0kBS7yDvb28aPAO4JK5+UAVXD1Pp4TmH5at36Sjheu6QdpDRS08ETjHXq
         QtgVddjtFSFfP0UzBMrVDR6il37ATrh7ScIYq+2U4Ks7gGdT7RVFCgJc2dzlBVtZ3RsW
         r4IwFFCu8KnLA/oO5Sc0WmO/TIg8QBIgRdmy9Fp9sJu9hOOt07NiWyIhTyn2tSJ6yNtq
         HuVmIcUaxcygiiG5aIAr+119+IWy2/w6mImZhMq1pQIqmgIIT1v18RzBnzYvzs2B6SuO
         u5WqQmpjqLmnCGM5bAsZud6wD3dPRU3qkg93TucMYCZQ+2DAiVL35LH9tUNBflsRJhq2
         iEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=VXhIbdDVpbL7eX47teNq1sjIk/AZB5LvuaakL+oANsY=;
        b=V6mF1/okisNCuZpGXKByDnf1RPf+PKkZ6+W3o9hb0wZkgtVsYYDgLclucro48eUD4W
         69pJYT7AEmyQNpbf2YJsgp1ChyzJ6Dr1m04cKWuT3OzzJcuWBIYZcQ8YzpydmgVOxaQ9
         QGwl6Kh8B0B7IBdBvaFWITjx3JMCiU5h/NYLoZdlyhDHXSpwZmj18iM8RAWv7lY1ik0f
         NAhTPx28dbUpqTL8xdQTHcfD933P7Z+OxPhH2HqPSkvbCNS4FzbvF4veZ5Xftd67AL0C
         PuzjQpOWhhc2POhJiR2fINo5vmHDqCsK3ge+0iSDwqT0TivWu4SOMxpi4FtnyAeX9YT4
         CevA==
X-Gm-Message-State: ACgBeo13w6s0sjLX6SgK5FjbJMr9NCmIbVnuntKz316GO/0s4wgelCcl
        ZjClu5P7obgCeM2rfQHo1EQs3Q==
X-Google-Smtp-Source: AA6agR47syRSgDsLFYK+NKxvui9TGCPoYu2L8PgL7+tUNczw1rcrOefDZLdQSxJX8Nr6xgkG/f1a1A==
X-Received: by 2002:a17:902:d2c3:b0:16e:ea56:7840 with SMTP id n3-20020a170902d2c300b0016eea567840mr16264488plc.142.1660558423515;
        Mon, 15 Aug 2022 03:13:43 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:42 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 2/5] riscv: Append ISA extensions to the device tree
Date:   Mon, 15 Aug 2022 15:43:22 +0530
Message-Id: <20220815101325.477694-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

The riscv,isa DT property only contains single letter base extensions
until now. However, there are also multi-letter extensions which were
ratified recently. Add a mechanism to append those extension details
to the device tree so that guest can leverage those.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                      | 30 ++++++++++++++++++++++++++++++
 riscv/include/kvm/kvm-cpu-arch.h | 11 +++++++++++
 riscv/kvm-cpu.c                  | 11 -----------
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index de15bfe..1818cf7 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -9,6 +9,16 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 
+#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
+					     id, KVM_REG_SIZE_ULONG)
+struct isa_ext_info {
+	const char *name;
+	unsigned long ext_id;
+};
+
+struct isa_ext_info isa_info_arr[] = {
+};
+
 static void dump_fdt(const char *dtb_file, void *fdt)
 {
 	int count, fd;
@@ -31,6 +41,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 {
 	int cpu, pos, i, index, valid_isa_len;
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
+	int arr_sz = ARRAY_SIZE(isa_info_arr);
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -42,6 +53,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		char cpu_name[CPU_NAME_MAX_LEN];
 		char cpu_isa[CPU_ISA_MAX_LEN];
 		struct kvm_cpu *vcpu = kvm->cpus[cpu];
+		struct kvm_one_reg reg;
+		unsigned long isa_ext_out = 0;
 
 		snprintf(cpu_name, CPU_NAME_MAX_LEN, "cpu@%x", cpu);
 
@@ -53,6 +66,23 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			if (vcpu->riscv_isa & (1 << (index)))
 				cpu_isa[pos++] = 'a' + index;
 		}
+
+		for (i = 0; i < arr_sz; i++) {
+			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
+			reg.addr = (unsigned long)&isa_ext_out;
+			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+				continue;
+			if (!isa_ext_out)
+				/* This extension is not available in hardware */
+				continue;
+
+			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
+				pr_warning("Insufficient space to append ISA exension\n");
+				break;
+			}
+			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN, "_%s",
+					isa_info_arr[i].name);
+		}
 		cpu_isa[pos] = '\0';
 
 		_FDT(fdt_begin_node(fdt, cpu_name));
diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index 78fcd01..4b3e602 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -7,6 +7,17 @@
 
 #include "kvm/kvm.h"
 
+static inline __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+{
+	return KVM_REG_RISCV | type | idx | size;
+}
+
+#if __riscv_xlen == 64
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
+#else
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
+#endif
+
 struct kvm_cpu {
 	pthread_t	thread;
 
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index df90c7b..a17b957 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -18,17 +18,6 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
-static __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
-{
-	return KVM_REG_RISCV | type | idx | size;
-}
-
-#if __riscv_xlen == 64
-#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
-#else
-#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
-#endif
-
 #define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
 					     KVM_REG_RISCV_CONFIG_REG(name), \
 					     KVM_REG_SIZE_ULONG)
-- 
2.34.1

