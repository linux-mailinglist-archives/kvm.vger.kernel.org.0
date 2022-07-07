Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B156A63A
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiGGOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiGGOya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:54:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEF2F395
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:53:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y9so5654285pff.12
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WpHsot62A1gxRtl/GwHVpqtU/9pvy/riu/S/EvqjSyI=;
        b=Tr+JEW+ZEJKGKjheUXFYk1x2N+wl+60t3vWoFftJlnngVr5Fn8nG/d/DAFcSbs43W2
         /VG1G2R+hotACgnJtCU8uZizBmJnDagJkQgQHnuXttm8t+3FxEBK4+yF49vDQCNID/t4
         Wy8b36vc1qtdBmA/pC8w6AQJmap0P0ga50OlDxZ/ENzSCraCmR9qdFJBA5g4HspWcZ08
         Wq3e+F+hW28ezbmPPzcUMbku6kijzfLAArAV2XmwQaJ8/kubSOKHefcYtXzHJ4ncvLfF
         NN8ydnb6UQg87FrvYETD0a7THG40DVM0N3yfyrxxK9reogFpPAlJ603vcK3KnQruxwiX
         ouZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WpHsot62A1gxRtl/GwHVpqtU/9pvy/riu/S/EvqjSyI=;
        b=jsmqExzKLfBR+1N7zAQ3wMvoWGsYJj4DzED+13dzr4lGXEYtcDVklcbsMyjH3xrtzG
         k8gWLrz1qWrFTtRLRU4y63uHp4HsnkFjx4qi8Eazj3RN4MVDKi10Jkff/kPwFa1WA3U0
         MqC0qt+mQG2dZNw4uG4u+9nyBMyEkUmNFkGqIbvffV/vohx5TdLuZGU7D/U5ViM+znWN
         wLJKEEkfH91SKKDVRe6f2tsaNJ2Jb+kT8rKXLanFSg2IUx2Cika/4GT00BdFu14q10SD
         a3uy/OnfEjJ65RMpidgbArYkKl378hnB6eW2uOyVW/0oMRkOpxvnZ7e5AXgg4JW2N1yC
         0U7w==
X-Gm-Message-State: AJIora/heXVhk1d6Ao5gxsuDxiJpZu4yWQcF3JFy5xepyT8b1oPou+9c
        FJq6S8MHqvg8vr2kXRNuzg7fNg==
X-Google-Smtp-Source: AGRyM1udvP3EHnOxHavdQ9dg0S+DvvpOEeaXRNKFmeLh8kDulADIUcXvLlMeJora4NRhq2LMa6dnug==
X-Received: by 2002:aa7:9a11:0:b0:525:2412:920a with SMTP id w17-20020aa79a11000000b005252412920amr54805086pfj.66.1657205620353;
        Thu, 07 Jul 2022 07:53:40 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([223.226.40.162])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7951a000000b0052535e7c489sm27144231pfp.114.2022.07.07.07.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:53:39 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 5/5] RISC-V: KVM: Add support for Svpbmt inside Guest/VM
Date:   Thu,  7 Jul 2022 20:22:48 +0530
Message-Id: <20220707145248.458771-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707145248.458771-1-apatel@ventanamicro.com>
References: <20220707145248.458771-1-apatel@ventanamicro.com>
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

The Guest/VM can use Svpbmt in VS-stage page tables when allowed by the
Hypervisor using the henvcfg.PBMTE bit.

We add Svpbmt support for the KVM Guest/VM which can be enabled/disabled
by the KVM user-space (QEMU/KVMTOOL) using the ISA extension ONE_REG
interface.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h      | 16 ++++++++++++++++
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu.c             | 16 ++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 6d85655e7edf..17516afc389a 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -156,6 +156,18 @@
 				 (_AC(1, UL) << IRQ_S_TIMER) | \
 				 (_AC(1, UL) << IRQ_S_EXT))
 
+/* xENVCFG flags */
+#define ENVCFG_STCE			(_AC(1, ULL) << 63)
+#define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
+#define ENVCFG_CBZE			(_AC(1, UL) << 7)
+#define ENVCFG_CBCFE			(_AC(1, UL) << 6)
+#define ENVCFG_CBIE_SHIFT		4
+#define ENVCFG_CBIE			(_AC(0x3, UL) << ENVCFG_CBIE_SHIFT)
+#define ENVCFG_CBIE_ILL			_AC(0x0, UL)
+#define ENVCFG_CBIE_FLUSH		_AC(0x1, UL)
+#define ENVCFG_CBIE_INV			_AC(0x3, UL)
+#define ENVCFG_FIOM			_AC(0x1, UL)
+
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
@@ -252,7 +264,9 @@
 #define CSR_HTIMEDELTA		0x605
 #define CSR_HCOUNTEREN		0x606
 #define CSR_HGEIE		0x607
+#define CSR_HENVCFG		0x60a
 #define CSR_HTIMEDELTAH		0x615
+#define CSR_HENVCFGH		0x61a
 #define CSR_HTVAL		0x643
 #define CSR_HIP			0x644
 #define CSR_HVIP		0x645
@@ -264,6 +278,8 @@
 #define CSR_MISA		0x301
 #define CSR_MIE			0x304
 #define CSR_MTVEC		0x305
+#define CSR_MENVCFG		0x30a
+#define CSR_MENVCFGH		0x31a
 #define CSR_MSCRATCH		0x340
 #define CSR_MEPC		0x341
 #define CSR_MCAUSE		0x342
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 6119368ba6d5..24b2a6e27698 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -96,6 +96,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_H,
 	KVM_RISCV_ISA_EXT_I,
 	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6dd9cf729614..b7a433c54d0f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -51,6 +51,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	RISCV_ISA_EXT_h,
 	RISCV_ISA_EXT_i,
 	RISCV_ISA_EXT_m,
+	RISCV_ISA_EXT_SVPBMT,
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -777,6 +778,19 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
+{
+	u64 henvcfg = 0;
+
+	if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SVPBMT))
+		henvcfg |= ENVCFG_PBMTE;
+
+	csr_write(CSR_HENVCFG, henvcfg);
+#ifdef CONFIG_32BIT
+	csr_write(CSR_HENVCFGH, henvcfg >> 32);
+#endif
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
@@ -791,6 +805,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	csr_write(CSR_HVIP, csr->hvip);
 	csr_write(CSR_VSATP, csr->vsatp);
 
+	kvm_riscv_vcpu_update_config(vcpu->arch.isa);
+
 	kvm_riscv_gstage_update_hgatp(vcpu);
 
 	kvm_riscv_vcpu_timer_restore(vcpu);
-- 
2.34.1

