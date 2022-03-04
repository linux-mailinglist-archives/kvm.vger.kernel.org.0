Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C58F4CD218
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbiCDKLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiCDKLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:11:30 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA021A9077
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:10:43 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id j9-20020a9d7d89000000b005ad5525ba09so6993646otn.10
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XojJYJYeQDYoRY8aa2UcwmJ2lrn8MPbZj4By1hOwJJ8=;
        b=sTvGpjvMN8kEMh5GEbSQjFMeNHe/cAlCgeH1wQgYfDjW3tvaoU+tWM5Ok6tsgANdZU
         rWJJ8pKMQ0clUqOqoH9VWE9OhzffRkOI6ph+qv23fYZLsOCw1tV/hKWZb5+Qu63vkQg7
         R1qea9JmRrEaQkydbhI1SYYpjPPCvTPU6Fa+KWN8MZZcfDqFYFu1nHPHo+iA5K4apL6g
         wNvvNHKFpR70EgcJxHBCRRimf8kHz1Gcudx4voE5JeZSMXQ9xdA0vBWpMp+31SIJLTk1
         HYQU04VTH0psWVeCjvYOaMUoocs6lImwSLXYytSEYMytRSxp5fK9qDr9dsYWMC8e56fU
         pJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XojJYJYeQDYoRY8aa2UcwmJ2lrn8MPbZj4By1hOwJJ8=;
        b=IQUDH049n/a7DTDBVsYylJchJFeMoPPdhb7hu9hp5JcG+ls9UroO+JpZDwf5IcrGB6
         JfstlA8GzXCLucwMenafwPI1XdzJZk6pmte0d8lzJaJy6R+/hUnNjGepaWmQXx45bHsP
         kIdGF3D5PobDk7Mf2W6Tbg9c3tChOxjxvUBEEI0hVdCb0oL6FRLM/1bnQAazujJ3Z7Rn
         2NZQD90pp90uPal6915u5X3mg9kzIzS2l0K3zL4Oe5dAyDQBbvD917tLXDbhMYAmAP1k
         stgkzttODgB7SOxihpVDXJquw3LAhRocgUAteKpbQqRA4r9UCQIqo4mjSmSH2qXDCZtu
         wFiA==
X-Gm-Message-State: AOAM533BEBRTnEEGSdKiH6qlWQmcAmees4pE2wx50KcbTDMw0mWWXhrd
        cmlpOifLI2JxZQI6Yt0X0hhwnDu0L3OLEg==
X-Google-Smtp-Source: ABdhPJyh30ifafJvsK4GHm0W9wIMw8q/pQ6mJ6vEHJx2t/RYcYce3dcdGa3pxg+Nv2X1rK4b5sLhUw==
X-Received: by 2002:a05:6830:1db0:b0:5af:22a6:e97d with SMTP id z16-20020a0568301db000b005af22a6e97dmr22166095oti.288.1646388642760;
        Fri, 04 Mar 2022 02:10:42 -0800 (PST)
Received: from rivos-atish.. (adsl-70-228-75-190.dsl.akrnoh.ameritech.net. [70.228.75.190])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm2358769oih.9.2022.03.04.02.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:10:42 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [RFC PATCH kvmtool 2/3] riscv: Append ISA extensions to the device tree
Date:   Fri,  4 Mar 2022 02:10:22 -0800
Message-Id: <20220304101023.764631-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304101023.764631-1-atishp@rivosinc.com>
References: <20220304101023.764631-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The riscv,isa DT property only contains single letter base extensions
until now. However, there are also multi-letter extensions which were
ratified recently. Add a mechanism to append those extension details
to the device tree so that guest can leverage those.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 riscv/fdt.c                      | 31 +++++++++++++++++++++++++++++++
 riscv/include/kvm/kvm-cpu-arch.h |  5 +++++
 riscv/kvm-cpu.c                  |  5 -----
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index de15bfe37b58..2e69bd219fe5 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -9,6 +9,17 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 
+#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
+					     id, \
+					     KVM_REG_SIZE_U64)
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
@@ -31,6 +42,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 {
 	int cpu, pos, i, index, valid_isa_len;
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
+	int arr_sz = ARRAY_SIZE(isa_info_arr);
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -42,6 +54,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		char cpu_name[CPU_NAME_MAX_LEN];
 		char cpu_isa[CPU_ISA_MAX_LEN];
 		struct kvm_cpu *vcpu = kvm->cpus[cpu];
+		struct kvm_one_reg reg;
+		unsigned long isa_ext_out = 0;
 
 		snprintf(cpu_name, CPU_NAME_MAX_LEN, "cpu@%x", cpu);
 
@@ -53,6 +67,23 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			if (vcpu->riscv_isa & (1 << (index)))
 				cpu_isa[pos++] = 'a' + index;
 		}
+
+		for (i = 0; i < arr_sz; i++) {
+			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
+			reg.addr = (unsigned long)&isa_ext_out;
+			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+				die("KVM_GET_ONE_REG failed (isa_ext)");
+			if (!isa_ext_out)
+			/* This extension is not available in hardware */
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
index 78fcd018c737..416fd05e9943 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -7,6 +7,11 @@
 
 #include "kvm/kvm.h"
 
+static inline __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+{
+	return KVM_REG_RISCV | type | idx | size;
+}
+
 struct kvm_cpu {
 	pthread_t	thread;
 
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index df90c7b9f21a..7a26fd17cf5b 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -18,11 +18,6 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
-static __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
-{
-	return KVM_REG_RISCV | type | idx | size;
-}
-
 #if __riscv_xlen == 64
 #define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
 #else
-- 
2.30.2

