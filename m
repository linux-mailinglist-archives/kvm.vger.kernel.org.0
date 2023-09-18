Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9430B7A4A4C
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241619AbjIRM6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242019AbjIRM6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:23 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6958612E
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-577a98f78b2so3157575a12.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041865; x=1695646665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nchzl7R+mDstAf3Tjjho9VJFca/R8akTk4Ves9kU+EU=;
        b=oC05btqyBDqFMwj1+aAMTg7bUziGiQYx7G3R1A0lCkfGnQBbx/X2JCgNMakkY5/G1h
         DOLYfRRipOfW2UIdJVFlLO3PYbcbcZenyipLO6/qRX5bLtZjqVM1OcQdKcmqr6kmTxh4
         0TiEezgsnqYTZK1p+RCfscMSzkMOTjqaBPKYyVS+tzCxWhyripIWru9fvWNov6RutVO0
         vfYjx/bdQOIFlJ05lKHeckzfw+R7xL0ws7bokKae9dP8smukAcIfQt/bbvB/QQVf0k4n
         d6ce/I8R2EehJaOVTSyd//sf0dMkWbH4KgyAM8tQxApbLQZ93tT8RZAyFhplh2v4arfk
         3IgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041865; x=1695646665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nchzl7R+mDstAf3Tjjho9VJFca/R8akTk4Ves9kU+EU=;
        b=XCH6Gm38I9lFBI7MXTLTpG4zew46x30U2O5Q6SRPmuLxIj32/Sth3X4kMMd8skv6Eq
         8HUzorffxsWxBloud7cjlokkY/fkhmYlh73mxQAKej8GD71pW9BWqXFNt8y4YMxxWWCK
         6Y3zdOnWl0tB27OWxLURNKiwz/KYwIlm2AvqQwcZU1NhPpptomWtfmurUPLRRBmE7Dnr
         hsbpMuL3OCoQchk9u/G8NMUgNcVSPPK/C0aeC9njVHZuGRZvZZ2BY8C1DVBQUyfeKOMN
         BzzaAYe/ee5c84IskJnQXDAoc0Qlzk0AhBdJAh567ssPeAeut8wTu/Z5/IO2KTap8yiy
         do1Q==
X-Gm-Message-State: AOJu0YzbWeD257aCvqeZf1tVSrRHfbhpu1Sl3myc/AtGat1JyB6O1ZEv
        bApmLYsvxgC2oKaCOZFhM7204w==
X-Google-Smtp-Source: AGHT+IF+DaQKeM1DuAHm6zosNcmC3cnXFLIpxw4sHg+jw3tG3jYZAii4snb+3kI1Of6wO/FAybWr3w==
X-Received: by 2002:a17:90a:f3d4:b0:26d:54de:b0d6 with SMTP id ha20-20020a17090af3d400b0026d54deb0d6mr5920620pjb.20.1695041864619;
        Mon, 18 Sep 2023 05:57:44 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:57:44 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 1/6] Sync-up header with Linux-6.5 for KVM RISC-V
Date:   Mon, 18 Sep 2023 18:27:25 +0530
Message-Id: <20230918125730.1371985-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up Linux headers to get latest KVM RISC-V headers having
V, Svnapot, and AIA support.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm.h     |  6 ++-
 riscv/include/asm/kvm.h | 81 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 737318b..f089ab2 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1190,6 +1190,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
+#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1442,6 +1444,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_RISCV_AIA,
+#define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1613,7 +1617,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
 #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
 /*
- * vcpu version available with KVM_ENABLE_CAP
+ * vcpu version available with KVM_CAP_ENABLE_CAP
  * vm version available with KVM_CAP_ENABLE_CAP_VM
  */
 #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index f92790c..930fdc4 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -15,6 +15,7 @@
 #include <asm/bitsperlong.h>
 #include <asm/ptrace.h>
 
+#define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -121,6 +122,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_V,
+	KVM_RISCV_ISA_EXT_SVNAPOT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -203,6 +206,84 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
 		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
 
+/* V extension registers are mapped as type 9 */
+#define KVM_REG_RISCV_VECTOR		(0x09 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
+		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_VECTOR_REG(n)	\
+		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
+
+/* Device Control API: RISC-V AIA */
+#define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_APLIC_SIZE		0x4000
+#define KVM_DEV_RISCV_APLIC_MAX_HARTS		0x4000
+#define KVM_DEV_RISCV_IMSIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_IMSIC_SIZE		0x1000
+
+#define KVM_DEV_RISCV_AIA_GRP_CONFIG		0
+#define KVM_DEV_RISCV_AIA_CONFIG_MODE		0
+#define KVM_DEV_RISCV_AIA_CONFIG_IDS		1
+#define KVM_DEV_RISCV_AIA_CONFIG_SRCS		2
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS	3
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT	4
+#define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS	5
+#define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS	6
+
+/*
+ * Modes of RISC-V AIA device:
+ * 1) EMUL (aka Emulation): Trap-n-emulate IMSIC
+ * 2) HWACCEL (aka HW Acceleration): Virtualize IMSIC using IMSIC guest files
+ * 3) AUTO (aka Automatic): Virtualize IMSIC using IMSIC guest files whenever
+ *    available otherwise fallback to trap-n-emulation
+ */
+#define KVM_DEV_RISCV_AIA_MODE_EMUL		0
+#define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
+#define KVM_DEV_RISCV_AIA_MODE_AUTO		2
+
+#define KVM_DEV_RISCV_AIA_IDS_MIN		63
+#define KVM_DEV_RISCV_AIA_IDS_MAX		2048
+#define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
+#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
+#define KVM_DEV_RISCV_AIA_HART_BITS_MAX		16
+#define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX	8
+
+#define KVM_DEV_RISCV_AIA_GRP_ADDR		1
+#define KVM_DEV_RISCV_AIA_ADDR_APLIC		0
+#define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)	(1 + (__vcpu))
+#define KVM_DEV_RISCV_AIA_ADDR_MAX		\
+		(1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
+
+#define KVM_DEV_RISCV_AIA_GRP_CTRL		2
+#define KVM_DEV_RISCV_AIA_CTRL_INIT		0
+
+/*
+ * The device attribute type contains the memory mapped offset of the
+ * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
+ */
+#define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+
+/*
+ * The lower 12-bits of the device attribute type contains the iselect
+ * value of the IMSIC register (range 0x70-0xFF) whereas the higher order
+ * bits contains the VCPU id.
+ */
+#define KVM_DEV_RISCV_AIA_GRP_IMSIC		4
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS	12
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK	\
+		((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
+#define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel)	\
+		(((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
+		 ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)	\
+		((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)	\
+		((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
+
+/* One single KVM irqchip, ie. the AIA */
+#define KVM_NR_IRQCHIPS			1
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
-- 
2.34.1

