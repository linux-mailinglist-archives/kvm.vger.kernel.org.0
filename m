Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3540602DF9
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiJROKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiJROJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:09:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC7924BFD
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k9so13508303pll.11
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mi3OAs84SzVBPhryxf2ZsSZ37TjM6IJmsjgpojTEKnM=;
        b=ea2VyPaevGOuNcc9XN5oBXqCdIxVdzh3HulObLalOaK18xQ5BGToy8ZdTMjE7CX+lW
         WWOJ6zom4emXHhj2L/w/h/IKCe0YHShrva+t8QFYeWg6+fNqAtCTTlcqX2e04o2iJBn+
         a1ymN+x4CAQlwSYyXe/mwamYNsyL5sxl0e//d88oJjyiJOHxzpFleZvzYcMU+tSoiJLY
         SnDQGOt4C9sB8El4gWrgj5x5erEaOT+Prq7nUnOVXhVl29eF7ago2EpPSL2XYJ9Weg9c
         VC9BED7C7BmemQeJCqOZ3o8W2r201oNXRPce2UUsHCX0oSeCX1s4yT7J4gXi03+Ad93z
         jbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mi3OAs84SzVBPhryxf2ZsSZ37TjM6IJmsjgpojTEKnM=;
        b=amdnJJcLuHRN3+xDB7ytC07mEzuQOjdSU0+Ycl8qWUp0Zl8Tv2peFcXG+fOxb4gETa
         8vTET9qfiQHfx0m12zjK9dAc2ryMAWPPVOR1ObfmmUk66J1dN71YFhhN/qsv3jOiouPa
         5Hxc4ZmVMlSPi0SoQlVF8p1kOSuCNOjnvIZsFufDn1nQrDvvyujjvGm9f6XVosNcV5Kf
         GLwlvzyqN3pF6cDsQ0i1YUO+Lz1Zn2SuxL+EO03BDQhN9YwAgvYfLuWTkNXkTbh/3jwO
         l7FVLVmsTbOnkwgQBsLgMTi3bb7dW6q8HnDi7zz9vNnZLSQ3mclKdTVvYfIQDlvGynQR
         NaFw==
X-Gm-Message-State: ACrzQf1FEXNUdYvODDfz36FZ1d8PVDngBJ+U7yQDaibN1IKwd0lLNh0N
        qrHfuC3GHMlmUEPPVfZt6YN6ow==
X-Google-Smtp-Source: AMsMyM45WVWO8hcChugqdDf8Q8WxPdJUKNE3dnIWHgszCH6BwMey/owW3t6zGZv685a1AmzVTV60aA==
X-Received: by 2002:a17:903:1250:b0:185:40c6:3c2c with SMTP id u16-20020a170903125000b0018540c63c2cmr3436236plh.64.1666102188179;
        Tue, 18 Oct 2022 07:09:48 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:47 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH kvmtool 4/6] riscv: Move reg encoding helpers to kvm-cpu-arch.h
Date:   Tue, 18 Oct 2022 19:38:52 +0530
Message-Id: <20221018140854.69846-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <ajones@ventanamicro.com>

We'll need one of these helpers in the next patch in another file.
Let's proactively move them all now, since others may some day also
be useful.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                      |  2 --
 riscv/include/kvm/kvm-cpu-arch.h | 19 +++++++++++++++++++
 riscv/kvm-cpu.c                  | 16 ----------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index ef0bc47..8d6da11 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -9,8 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 
-#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
-					     id, KVM_REG_SIZE_ULONG)
 struct isa_ext_info {
 	const char *name;
 	unsigned long ext_id;
diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index 4b3e602..e014839 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -18,6 +18,25 @@ static inline __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
 #define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
 #endif
 
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+					     KVM_REG_RISCV_CONFIG_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
+					     id, KVM_REG_SIZE_ULONG)
+
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+					     KVM_REG_RISCV_CORE_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+					     KVM_REG_RISCV_CSR_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+					     KVM_REG_RISCV_TIMER_REG(name), \
+					     KVM_REG_SIZE_U64)
+
 struct kvm_cpu {
 	pthread_t	thread;
 
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index a17b957..f98bd7a 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -18,22 +18,6 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
-#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
-					     KVM_REG_RISCV_CONFIG_REG(name), \
-					     KVM_REG_SIZE_ULONG)
-
-#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
-					     KVM_REG_RISCV_CORE_REG(name), \
-					     KVM_REG_SIZE_ULONG)
-
-#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
-					     KVM_REG_RISCV_CSR_REG(name), \
-					     KVM_REG_SIZE_ULONG)
-
-#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
-					     KVM_REG_RISCV_TIMER_REG(name), \
-					     KVM_REG_SIZE_U64)
-
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_cpu *vcpu;
-- 
2.34.1

