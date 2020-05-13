Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD881D0B27
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbgEMIra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbgEMIr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:47:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A222C061A0C;
        Wed, 13 May 2020 01:47:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so4880241pgn.5;
        Wed, 13 May 2020 01:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vRhFagZlT2luYjUHfnWLVdGl2wrwJA4QO12x8IMZKSs=;
        b=U9rKBOcbrPsJjY+B/L1RdjcPzR6IDJb7wpaLtJjhAIzFWhFrkZmstsx92npUUrW0j/
         I8i4m+koNtKJpaIBm906VL75fFnXkx6MT1CLtvXGJDHhBRLs2loJTPCzlrJl4hD0hr7y
         5MOMxFaFJFJclcCVzYRFgHohXBYEadTJLnS59t6iQfdwlavaPak1iHzGNsZWavlwXFxT
         C7N+AcS2DakHKp/GbNwDi6fo+kBGF5YHinU92/n2nfXGyzo9RaXARKpDJAje3GTdGTgn
         38Hbgg6dFIcfZyhPXW5IpDiGiuD2agnibzwzqtDFQArFaoU0d5M6YZmXefpp9lYwIhd4
         JrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=vRhFagZlT2luYjUHfnWLVdGl2wrwJA4QO12x8IMZKSs=;
        b=LM9fwx3Q6F/WixCrKlEsY0EPwiwhgMINCNJWIlL14/jsjP4n+X9uV5VO5/6rKY6uqk
         cg9y21/m1PbqsrxM+znCPawVSaCe/VbR+BSnu8I/G26Ppm2/ODKlga9SpzgeNMMkHjqQ
         UG7hQuaJXj8i+OblbkzJTActosOGqZYIAC+H9YFmNBGJEW6zE/2uColAR1TaP2x6zNov
         ZnY0CdVZauZ+i0qLm57RtX4S328ou3IX1kVAassf4LXD5Z42SJYT8Y0O1mHRc83goHO6
         gGW8fa/uBoatS8WIKncKVuBWDLmpwpnIY/BENdmnJPX0bdVqY0y2EWuIDYs9R6xplX6W
         EeDA==
X-Gm-Message-State: AOAM530tgPM7ENFKV+G/VDyVHft7p7QOFhobOJ78axmU9bBawtyQyq6h
        UKTIgISg7A6+1fhbG9FjLhE=
X-Google-Smtp-Source: ABdhPJwrxQUDgM3vTH7y3CtSrH9pQTobIl4exQUw95zbRHZ4I8ShXKegS/joTPL1D66KJUWFbHvJGg==
X-Received: by 2002:a63:1f43:: with SMTP id q3mr7490386pgm.386.1589359647741;
        Wed, 13 May 2020 01:47:27 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.47.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:47:27 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 12/15] KVM: MIPS: Add CONFIG6 and DIAG registers emulation
Date:   Wed, 13 May 2020 16:42:43 +0800
Message-Id: <1589359366-1669-13-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 has CONFIG6 and DIAG registers which need to be emulated.
CONFIG6 is mostly used to enable/disable FTLB and SFB, while DIAG is
mostly used to flush BTB, ITLB, DTLB, VTLB and FTLB.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h |  7 +++++
 arch/mips/include/asm/mipsregs.h |  7 +++++
 arch/mips/kvm/tlb.c              | 41 ++++++++++++++++++++++++++
 arch/mips/kvm/vz.c               | 62 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 3fd2f1c..30b5e33 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -68,9 +68,11 @@
 #define KVM_REG_MIPS_CP0_CONFIG3	MIPS_CP0_32(16, 3)
 #define KVM_REG_MIPS_CP0_CONFIG4	MIPS_CP0_32(16, 4)
 #define KVM_REG_MIPS_CP0_CONFIG5	MIPS_CP0_32(16, 5)
+#define KVM_REG_MIPS_CP0_CONFIG6	MIPS_CP0_32(16, 6)
 #define KVM_REG_MIPS_CP0_CONFIG7	MIPS_CP0_32(16, 7)
 #define KVM_REG_MIPS_CP0_MAARI		MIPS_CP0_64(17, 2)
 #define KVM_REG_MIPS_CP0_XCONTEXT	MIPS_CP0_64(20, 0)
+#define KVM_REG_MIPS_CP0_DIAG		MIPS_CP0_32(22, 0)
 #define KVM_REG_MIPS_CP0_ERROREPC	MIPS_CP0_64(30, 0)
 #define KVM_REG_MIPS_CP0_KSCRATCH1	MIPS_CP0_64(31, 2)
 #define KVM_REG_MIPS_CP0_KSCRATCH2	MIPS_CP0_64(31, 3)
@@ -256,6 +258,7 @@ struct mips_coproc {
 #define MIPS_CP0_WATCH_LO	18
 #define MIPS_CP0_WATCH_HI	19
 #define MIPS_CP0_TLB_XCONTEXT	20
+#define MIPS_CP0_DIAG		22
 #define MIPS_CP0_ECC		26
 #define MIPS_CP0_CACHE_ERR	27
 #define MIPS_CP0_TAG_LO		28
@@ -927,6 +930,10 @@ void kvm_vz_save_guesttlb(struct kvm_mips_tlb *buf, unsigned int index,
 			  unsigned int count);
 void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned int index,
 			  unsigned int count);
+#ifdef CONFIG_CPU_LOONGSON64
+void kvm_loongson_clear_guest_vtlb(void);
+void kvm_loongson_clear_guest_ftlb(void);
+#endif
 #endif
 
 void kvm_mips_suspend_mm(int cpu);
diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 796fe47..ce40fbf 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -674,6 +674,9 @@
 #define MIPS_CONF5_CV		(_ULCAST_(1) << 29)
 #define MIPS_CONF5_K		(_ULCAST_(1) << 30)
 
+#define MIPS_CONF6_INTIMER	(_ULCAST_(1) << 6)
+#define MIPS_CONF6_EXTIMER	(_ULCAST_(1) << 7)
+#define MIPS_CONF6_SFBEN	(_ULCAST_(1) << 8)
 #define MIPS_CONF6_SYND		(_ULCAST_(1) << 13)
 /* proAptiv FTLB on/off bit */
 #define MIPS_CONF6_FTLBEN	(_ULCAST_(1) << 15)
@@ -993,6 +996,8 @@
 /* Disable Branch Return Cache */
 #define R10K_DIAG_D_BRC		(_ULCAST_(1) << 22)
 
+/* Flush BTB */
+#define LOONGSON_DIAG_BTB	(_ULCAST_(1) << 1)
 /* Flush ITLB */
 #define LOONGSON_DIAG_ITLB	(_ULCAST_(1) << 2)
 /* Flush DTLB */
@@ -2825,7 +2830,9 @@ __BUILD_SET_C0(status)
 __BUILD_SET_C0(cause)
 __BUILD_SET_C0(config)
 __BUILD_SET_C0(config5)
+__BUILD_SET_C0(config6)
 __BUILD_SET_C0(config7)
+__BUILD_SET_C0(diag)
 __BUILD_SET_C0(intcontrol)
 __BUILD_SET_C0(intctl)
 __BUILD_SET_C0(srsmap)
diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
index 7cd9216..1418715 100644
--- a/arch/mips/kvm/tlb.c
+++ b/arch/mips/kvm/tlb.c
@@ -20,6 +20,7 @@
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
+#include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -622,6 +623,46 @@ void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned int index,
 }
 EXPORT_SYMBOL_GPL(kvm_vz_load_guesttlb);
 
+#ifdef CONFIG_CPU_LOONGSON64
+void kvm_loongson_clear_guest_vtlb(void)
+{
+	int idx = read_gc0_index();
+
+	/* Set root GuestID for root probe and write of guest TLB entry */
+	set_root_gid_to_guest_gid();
+
+	write_gc0_index(0);
+	guest_tlbinvf();
+	write_gc0_index(idx);
+
+	clear_root_gid();
+	set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
+}
+EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_vtlb);
+
+void kvm_loongson_clear_guest_ftlb(void)
+{
+	int i;
+	int idx = read_gc0_index();
+
+	/* Set root GuestID for root probe and write of guest TLB entry */
+	set_root_gid_to_guest_gid();
+
+	for (i = current_cpu_data.tlbsizevtlb;
+	     i < (current_cpu_data.tlbsizevtlb +
+		     current_cpu_data.tlbsizeftlbsets);
+	     i++) {
+		write_gc0_index(i);
+		guest_tlbinvf();
+	}
+	write_gc0_index(idx);
+
+	clear_root_gid();
+	set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
+}
+EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_ftlb);
+#endif
+
 #endif
 
 /**
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 72a62f1..73701c3 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -127,6 +127,11 @@ static inline unsigned int kvm_vz_config5_guest_wrmask(struct kvm_vcpu *vcpu)
 	return mask;
 }
 
+static inline unsigned int kvm_vz_config6_guest_wrmask(struct kvm_vcpu *vcpu)
+{
+	return MIPS_CONF6_INTIMER | MIPS_CONF6_EXTIMER | MIPS_CONF6_SYND;
+}
+
 /*
  * VZ optionally allows these additional Config bits to be written by root:
  * Config:	M, [MT]
@@ -181,6 +186,12 @@ static inline unsigned int kvm_vz_config5_user_wrmask(struct kvm_vcpu *vcpu)
 	return kvm_vz_config5_guest_wrmask(vcpu) | MIPS_CONF5_MRP;
 }
 
+static inline unsigned int kvm_vz_config6_user_wrmask(struct kvm_vcpu *vcpu)
+{
+	return kvm_vz_config6_guest_wrmask(vcpu) |
+		MIPS_CONF6_SFBEN | MIPS_CONF6_FTLBEN | MIPS_CONF6_FTLBDIS;
+}
+
 static gpa_t kvm_vz_gva_to_gpa_cb(gva_t gva)
 {
 	/* VZ guest has already converted gva to gpa */
@@ -930,7 +941,8 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
 				    (sel == 2 ||	/* SRSCtl */
 				     sel == 3)) ||	/* SRSMap */
 				   (rd == MIPS_CP0_CONFIG &&
-				    (sel == 7)) ||	/* Config7 */
+				    (sel == 6 ||	/* Config6 */
+				     sel == 7)) ||	/* Config7 */
 				   (rd == MIPS_CP0_LLADDR &&
 				    (sel == 2) &&	/* MAARI */
 				    cpu_guest_has_maar &&
@@ -938,6 +950,11 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
 				   (rd == MIPS_CP0_ERRCTL &&
 				    (sel == 0))) {	/* ErrCtl */
 				val = cop0->reg[rd][sel];
+#ifdef CONFIG_CPU_LOONGSON64
+			} else if (rd == MIPS_CP0_DIAG &&
+				   (sel == 0)) {	/* Diag */
+				val = cop0->reg[rd][sel];
+#endif
 			} else {
 				val = 0;
 				er = EMULATE_FAIL;
@@ -1000,9 +1017,40 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
 				   cpu_guest_has_maar &&
 				   !cpu_guest_has_dyn_maar) {
 				kvm_write_maari(vcpu, val);
+			} else if (rd == MIPS_CP0_CONFIG &&
+				   (sel == 6)) {
+				cop0->reg[rd][sel] = (int)val;
 			} else if (rd == MIPS_CP0_ERRCTL &&
 				   (sel == 0)) {	/* ErrCtl */
 				/* ignore the written value */
+#ifdef CONFIG_CPU_LOONGSON64
+			} else if (rd == MIPS_CP0_DIAG &&
+				   (sel == 0)) {	/* Diag */
+				unsigned long flags;
+
+				local_irq_save(flags);
+				if (val & LOONGSON_DIAG_BTB) {
+					/* Flush BTB */
+					set_c0_diag(LOONGSON_DIAG_BTB);
+				}
+				if (val & LOONGSON_DIAG_ITLB) {
+					/* Flush ITLB */
+					set_c0_diag(LOONGSON_DIAG_ITLB);
+				}
+				if (val & LOONGSON_DIAG_DTLB) {
+					/* Flush DTLB */
+					set_c0_diag(LOONGSON_DIAG_DTLB);
+				}
+				if (val & LOONGSON_DIAG_VTLB) {
+					/* Flush VTLB */
+					kvm_loongson_clear_guest_vtlb();
+				}
+				if (val & LOONGSON_DIAG_FTLB) {
+					/* Flush FTLB */
+					kvm_loongson_clear_guest_ftlb();
+				}
+				local_irq_restore(flags);
+#endif
 			} else {
 				er = EMULATE_FAIL;
 			}
@@ -1692,6 +1740,7 @@ static u64 kvm_vz_get_one_regs[] = {
 	KVM_REG_MIPS_CP0_CONFIG3,
 	KVM_REG_MIPS_CP0_CONFIG4,
 	KVM_REG_MIPS_CP0_CONFIG5,
+	KVM_REG_MIPS_CP0_CONFIG6,
 #ifdef CONFIG_64BIT
 	KVM_REG_MIPS_CP0_XCONTEXT,
 #endif
@@ -2019,6 +2068,9 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		*v = read_gc0_config5();
 		break;
+	case KVM_REG_MIPS_CP0_CONFIG6:
+		*v = kvm_read_sw_gc0_config6(cop0);
+		break;
 	case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
 		if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
 			return -EINVAL;
@@ -2288,6 +2340,14 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 			write_gc0_config5(v);
 		}
 		break;
+	case KVM_REG_MIPS_CP0_CONFIG6:
+		cur = kvm_read_sw_gc0_config6(cop0);
+		change = (cur ^ v) & kvm_vz_config6_user_wrmask(vcpu);
+		if (change) {
+			v = cur ^ change;
+			kvm_write_sw_gc0_config6(cop0, (int)v);
+		}
+		break;
 	case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
 		if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
 			return -EINVAL;
-- 
2.7.0

