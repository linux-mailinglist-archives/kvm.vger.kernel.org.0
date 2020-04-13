Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27C1A6778
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgDMOEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 10:04:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730249AbgDMOEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 10:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586786637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=DMxjnALOO+13jpd4EXyv1/+VreDyJBNjIrO01oQGGFU=;
        b=LllGleyit1IfVZMQ5DZY2OMkI+OxhklPPVCjm0deGUj2wOvNS5HY5jrzJBM3e5jF2mOy77
        vciUMD9DbzgWgDxB+CTvTMvl2Kl/SDAuQT3t9ZUOlCmboXHOLMqrSrwYjyYl2jizwM8eys
        YHjWE/NMhbfTmktYWoCnnvuKY6Pk9+w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-ZXP2HYP1Mhm5fnZOPYe3cQ-1; Mon, 13 Apr 2020 10:03:56 -0400
X-MC-Unique: ZXP2HYP1Mhm5fnZOPYe3cQ-1
Received: by mail-wm1-f71.google.com with SMTP id y1so2706183wmj.3
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 07:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DMxjnALOO+13jpd4EXyv1/+VreDyJBNjIrO01oQGGFU=;
        b=ma7vtKHcOiJfLqUKhciKyflrcNCoMuWnXJ0tBduro08Q4PnZOU2B/GCt/R0NyFWVmw
         01OD4qaWt5YlgTBZqjveNLbzO88Ek1vb1jFp68uGrOVrhvYBgYa86E2TKSHrkO11zf6O
         2tzP0OxIhMrpapgjEnd5HRxebqG8SbzpmheAeWFoiBTLoEOd/N49ODS7t6rF989Q+IdX
         W4WVvBnSYPrLlCwAw9qhfcaenrmco9wcVTJDV82riQuzDHInSewZd+PW7dTLUnevXcOY
         nG1RY6LsYIPJdRxp+ARTVEgdQ28E7PHDrAwLvlIMSVFOYAYPQVOXrc33ZfaR3xoVIC1Q
         N2NQ==
X-Gm-Message-State: AGi0PubO4P6Y82stuE2O/dWeTIJazIsYm2cdZ3GGDiY8nHPWSV68wbdf
        Sle2mtK8X/6XLd6RbCSqHpeusX+v9YO2owv2MIp0elFlp7+MzPujFyxE7cT8HwrgKSx1IaGxOf4
        l9UzVkrVTaoL1
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr18660289wrs.265.1586786634646;
        Mon, 13 Apr 2020 07:03:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypLRZJuELUsSHD7peAwU3uRWTiihVpgUEtD1l8rr9Jo5lHrC+5Swh69bNDnIpYlTippwc8wt9Q==
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr18660255wrs.265.1586786634361;
        Mon, 13 Apr 2020 07:03:54 -0700 (PDT)
Received: from emanuele-MacBookPro.redhat.com ([194.230.155.239])
        by smtp.gmail.com with ESMTPSA id j10sm11726263wmi.18.2020.04.13.07.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 07:03:53 -0700 (PDT)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a single place
Date:   Mon, 13 Apr 2020 16:03:32 +0200
Message-Id: <20200413140332.22896-1-eesposit@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
files, each used by a different architecure to initialize the debugfs
entries for statistics. Since they all have the same purpose, they can be
unified in a single common definition in include/linux/kvm_host.h

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/arm64/kvm/guest.c    | 23 +++++++--------
 arch/mips/kvm/mips.c      | 61 +++++++++++++++++++--------------------
 arch/powerpc/kvm/book3s.c |  3 --
 arch/powerpc/kvm/booke.c  |  3 --
 arch/s390/kvm/kvm-s390.c  |  3 --
 arch/x86/kvm/x86.c        |  3 --
 include/linux/kvm_host.h  |  3 ++
 7 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 23ebe51410f0..3e3aee8b37c0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -29,20 +29,17 @@
 
 #include "trace.h"
 
-#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
-#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT(halt_successful_poll),
-	VCPU_STAT(halt_attempted_poll),
-	VCPU_STAT(halt_poll_invalid),
-	VCPU_STAT(halt_wakeup),
-	VCPU_STAT(hvc_exit_stat),
-	VCPU_STAT(wfe_exit_stat),
-	VCPU_STAT(wfi_exit_stat),
-	VCPU_STAT(mmio_exit_user),
-	VCPU_STAT(mmio_exit_kernel),
-	VCPU_STAT(exits),
+	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
+	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
+	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
+	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
+	{ "hvc_exit_stat", VCPU_STAT(hvc_exit_stat) },
+	{ "wfe_exit_stat", VCPU_STAT(wfe_exit_stat) },
+	{ "wfi_exit_stat", VCPU_STAT(wfi_exit_stat) },
+	{ "mmio_exit_user", VCPU_STAT(mmio_exit_user) },
+	{ "mmio_exit_kernel", VCPU_STAT(mmio_exit_kernel) },
+	{ "exits", VCPU_STAT(exits) },
 	{ NULL }
 };
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8f05dd0a0f4e..f14b93d02f02 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -39,40 +39,39 @@
 #define VECTORSPACING 0x100	/* for EI/VI mode */
 #endif
 
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x)
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	{ "wait",	  VCPU_STAT(wait_exits),	 KVM_STAT_VCPU },
-	{ "cache",	  VCPU_STAT(cache_exits),	 KVM_STAT_VCPU },
-	{ "signal",	  VCPU_STAT(signal_exits),	 KVM_STAT_VCPU },
-	{ "interrupt",	  VCPU_STAT(int_exits),		 KVM_STAT_VCPU },
-	{ "cop_unusable", VCPU_STAT(cop_unusable_exits), KVM_STAT_VCPU },
-	{ "tlbmod",	  VCPU_STAT(tlbmod_exits),	 KVM_STAT_VCPU },
-	{ "tlbmiss_ld",	  VCPU_STAT(tlbmiss_ld_exits),	 KVM_STAT_VCPU },
-	{ "tlbmiss_st",	  VCPU_STAT(tlbmiss_st_exits),	 KVM_STAT_VCPU },
-	{ "addrerr_st",	  VCPU_STAT(addrerr_st_exits),	 KVM_STAT_VCPU },
-	{ "addrerr_ld",	  VCPU_STAT(addrerr_ld_exits),	 KVM_STAT_VCPU },
-	{ "syscall",	  VCPU_STAT(syscall_exits),	 KVM_STAT_VCPU },
-	{ "resvd_inst",	  VCPU_STAT(resvd_inst_exits),	 KVM_STAT_VCPU },
-	{ "break_inst",	  VCPU_STAT(break_inst_exits),	 KVM_STAT_VCPU },
-	{ "trap_inst",	  VCPU_STAT(trap_inst_exits),	 KVM_STAT_VCPU },
-	{ "msa_fpe",	  VCPU_STAT(msa_fpe_exits),	 KVM_STAT_VCPU },
-	{ "fpe",	  VCPU_STAT(fpe_exits),		 KVM_STAT_VCPU },
-	{ "msa_disabled", VCPU_STAT(msa_disabled_exits), KVM_STAT_VCPU },
-	{ "flush_dcache", VCPU_STAT(flush_dcache_exits), KVM_STAT_VCPU },
+	{ "wait",	  VCPU_STAT(wait_exits) },
+	{ "cache",	  VCPU_STAT(cache_exits) },
+	{ "signal",	  VCPU_STAT(signal_exits) },
+	{ "interrupt",	  VCPU_STAT(int_exits) },
+	{ "cop_unusable", VCPU_STAT(cop_unusable_exits) },
+	{ "tlbmod",	  VCPU_STAT(tlbmod_exits) },
+	{ "tlbmiss_ld",	  VCPU_STAT(tlbmiss_ld_exits) },
+	{ "tlbmiss_st",	  VCPU_STAT(tlbmiss_st_exits) },
+	{ "addrerr_st",	  VCPU_STAT(addrerr_st_exits) },
+	{ "addrerr_ld",	  VCPU_STAT(addrerr_ld_exits) },
+	{ "syscall",	  VCPU_STAT(syscall_exits) },
+	{ "resvd_inst",	  VCPU_STAT(resvd_inst_exits) },
+	{ "break_inst",	  VCPU_STAT(break_inst_exits) },
+	{ "trap_inst",	  VCPU_STAT(trap_inst_exits) },
+	{ "msa_fpe",	  VCPU_STAT(msa_fpe_exits) },
+	{ "fpe",	  VCPU_STAT(fpe_exits) },
+	{ "msa_disabled", VCPU_STAT(msa_disabled_exits) },
+	{ "flush_dcache", VCPU_STAT(flush_dcache_exits) },
 #ifdef CONFIG_KVM_MIPS_VZ
-	{ "vz_gpsi",	  VCPU_STAT(vz_gpsi_exits),	 KVM_STAT_VCPU },
-	{ "vz_gsfc",	  VCPU_STAT(vz_gsfc_exits),	 KVM_STAT_VCPU },
-	{ "vz_hc",	  VCPU_STAT(vz_hc_exits),	 KVM_STAT_VCPU },
-	{ "vz_grr",	  VCPU_STAT(vz_grr_exits),	 KVM_STAT_VCPU },
-	{ "vz_gva",	  VCPU_STAT(vz_gva_exits),	 KVM_STAT_VCPU },
-	{ "vz_ghfc",	  VCPU_STAT(vz_ghfc_exits),	 KVM_STAT_VCPU },
-	{ "vz_gpa",	  VCPU_STAT(vz_gpa_exits),	 KVM_STAT_VCPU },
-	{ "vz_resvd",	  VCPU_STAT(vz_resvd_exits),	 KVM_STAT_VCPU },
+	{ "vz_gpsi",	  VCPU_STAT(vz_gpsi_exits) },
+	{ "vz_gsfc",	  VCPU_STAT(vz_gsfc_exits) },
+	{ "vz_hc",	  VCPU_STAT(vz_hc_exits) },
+	{ "vz_grr",	  VCPU_STAT(vz_grr_exits) },
+	{ "vz_gva",	  VCPU_STAT(vz_gva_exits) },
+	{ "vz_ghfc",	  VCPU_STAT(vz_ghfc_exits) },
+	{ "vz_gpa",	  VCPU_STAT(vz_gpa_exits) },
+	{ "vz_resvd",	  VCPU_STAT(vz_resvd_exits) },
 #endif
-	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll), KVM_STAT_VCPU },
-	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll), KVM_STAT_VCPU },
-	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid), KVM_STAT_VCPU },
-	{ "halt_wakeup",  VCPU_STAT(halt_wakeup),	 KVM_STAT_VCPU },
+	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
+	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
+	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
+	{ "halt_wakeup",  VCPU_STAT(halt_wakeup) },
 	{NULL}
 };
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 5690a1f9b976..55cb728ba06e 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -36,9 +36,6 @@
 #include "book3s.h"
 #include "trace.h"
 
-#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
-#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
-
 /* #define EXIT_DEBUG */
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 6c18ea88fd25..fb8fa7060804 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -35,9 +35,6 @@
 
 unsigned long kvmppc_booke_handlers;
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmio",       VCPU_STAT(mmio_exits) },
 	{ "sig",        VCPU_STAT(signal_exits) },
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 19a81024fe16..1a7bf8759750 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -57,9 +57,6 @@
 #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
 			   (KVM_MAX_VCPUS + LOCAL_IRQS))
 
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "userspace_handled", VCPU_STAT(exit_userspace) },
 	{ "exit_null", VCPU_STAT(exit_null) },
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b562dea..fb035d304004 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -97,9 +97,6 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
-#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
-#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
-
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d58beb65454..e02d38c7fff1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1130,6 +1130,9 @@ struct kvm_stats_debugfs_item {
 #define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
 	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
 
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
+
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
-- 
2.17.1

