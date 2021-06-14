Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576173A5BAB
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 04:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhFNC4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 22:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbhFNC4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 22:56:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E4C061767
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 19:54:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y135-20020a25dc8d0000b029054716974cceso13130494ybe.12
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 19:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gzcujzb1Uifa75Eif0yISfQ+wRzbBYK6+2W5LGv+r68=;
        b=NhPgkx/hdoNil81s0ijqVruF8AtG8oQLdEQJSsNSM115D7xgYqQn+g5f+4mZKvh2E8
         TMBrBK2GdkG3UC72lYIbpjdkPWJxIG807NWjbO0Vwus8jVE9MysdMH5xJJB+40pSnLfg
         6rfpUwxGyV/SRm+F4NyRZoRRWHpxobxtKCWjBz6FHNWu3Nwb27JaW+6Q1pM91fG3uZbO
         0hcszRM6S5XvWiEtu1uzp4NrIsYW1xla3XEa8oBJSE6tKdPaExI5gWSWeVNlNFAQQgpz
         xm9mPv33erZbu7KXLJu97opyJ10n8mPTVAviMf1n6NaV/s5AwxRVTKTAf7ZEhZkLwGLB
         TuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gzcujzb1Uifa75Eif0yISfQ+wRzbBYK6+2W5LGv+r68=;
        b=FlP3mFjl5Wh7WCLFuqM/Z2glEqyV/PB+ccW6dpLBI0EIbjBd/AqEr9OcCDfILsCC2W
         eeuNOwxAQRjuDakgVrgjZGyeFrQpXViLh2fUac2Q0Dy7bLwBRBAhx3kHnnboa7z29/JO
         Fh5wOqZ2RK9BUBDqI0/PDJYY70yxvk+tDcGZ2yKNieScizz5LrQEFB20Zqox4UITg6nm
         1uxpBI8nIJyH8XTITVLjHvLqaXNx60LM9N23sellFnzG36dGfnwzzxE+U+6V01bpCc1k
         p9fRm4hNT5Jg6QiFTQAQWddlmNOiyOF70jOw+ffpkJoqg2hq/pGOnapS2696gIjSGEiy
         ttPw==
X-Gm-Message-State: AOAM533Elz9ZZwTuoJaKa8gjIdI1qLzkYsp3EuWIn45k+8mT4QyUbwqq
        GJl82iXxddafDspIlddJ+7yW4ahArsTmIv1pMAj42B+eNhi4DX/vmthTXSM/5TmXa88eiKgZHT1
        SZ5eMwrFPeJ1mrpsj83n6jeaesaldSPdgEBGxbBZfdLnf8GVz42npI+wwYV3Ou4yaFSELM54=
X-Google-Smtp-Source: ABdhPJyJxcgzla/tUVPUPpsGVXG+XvGj0+UuxrO+6J4sd53jdVDAnzcpK7nesiO45wVyqVqnQDtzmgWQDEnrOD1wBw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:b74d:: with SMTP id
 e13mr21157111ybm.372.1623639237566; Sun, 13 Jun 2021 19:53:57 -0700 (PDT)
Date:   Mon, 14 Jun 2021 02:53:48 +0000
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
Message-Id: <20210614025351.365284-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add static check to make sure the number of stats descriptors equals
the number of stats defined in vm/vcpu stats structures.
Add offset field in stats descriptor to let us define stats
descriptors freely, don't have to be in the same order as
stats in vm/vcpu stats structures.
Also fix some missing/mismatched stats from previous patch.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/guest.c    |  16 +--
 arch/mips/kvm/mips.c      |  60 ++++++------
 arch/powerpc/kvm/book3s.c |  68 +++++++------
 arch/powerpc/kvm/booke.c  |  54 ++++++-----
 arch/s390/kvm/kvm-s390.c  | 199 +++++++++++++++++++-------------------
 arch/x86/kvm/x86.c        |  73 +++++++-------
 include/linux/kvm_host.h  | 151 ++++++++++++++++++-----------
 include/uapi/linux/kvm.h  |   4 +-
 8 files changed, 342 insertions(+), 283 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 7048603f4b26..99842e29c2de 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -31,6 +31,8 @@
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -44,13 +46,15 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("hvc_exit_stat"),
-	STATS_DESC_COUNTER("wfe_exit_stat"),
-	STATS_DESC_COUNTER("wfi_exit_stat"),
-	STATS_DESC_COUNTER("mmio_exit_user"),
-	STATS_DESC_COUNTER("mmio_exit_kernel"),
-	STATS_DESC_COUNTER("exits")
+	STATS_DESC_COUNTER(VCPU, hvc_exit_stat),
+	STATS_DESC_COUNTER(VCPU, wfe_exit_stat),
+	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, exits)
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8fc70539a83b..67404f0947aa 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -41,6 +41,8 @@
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -54,38 +56,38 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("wait_exits"),
-	STATS_DESC_COUNTER("cache_exits"),
-	STATS_DESC_COUNTER("signal_exits"),
-	STATS_DESC_COUNTER("int_exits"),
-	STATS_DESC_COUNTER("cop_unusable_exits"),
-	STATS_DESC_COUNTER("tlbmod_exits"),
-	STATS_DESC_COUNTER("tlbmiss_ld_exits"),
-	STATS_DESC_COUNTER("tlbmiss_st_exits"),
-	STATS_DESC_COUNTER("addrerr_st_exits"),
-	STATS_DESC_COUNTER("addrerr_ld_exits"),
-	STATS_DESC_COUNTER("syscall_exits"),
-	STATS_DESC_COUNTER("resvd_inst_exits"),
-	STATS_DESC_COUNTER("break_inst_exits"),
-	STATS_DESC_COUNTER("trap_inst_exits"),
-	STATS_DESC_COUNTER("msa_fpe_exits"),
-	STATS_DESC_COUNTER("fpe_exits"),
-	STATS_DESC_COUNTER("msa_disabled_exits"),
-	STATS_DESC_COUNTER("flush_dcache_exits"),
-#ifdef CONFIG_KVM_MIPS_VZ
-	STATS_DESC_COUNTER("vz_gpsi_exits"),
-	STATS_DESC_COUNTER("vz_gsfc_exits"),
-	STATS_DESC_COUNTER("vz_hc_exits"),
-	STATS_DESC_COUNTER("vz_grr_exits"),
-	STATS_DESC_COUNTER("vz_gva_exits"),
-	STATS_DESC_COUNTER("vz_ghfc_exits"),
-	STATS_DESC_COUNTER("vz_gpa_exits"),
-	STATS_DESC_COUNTER("vz_resvd_exits"),
+	STATS_DESC_COUNTER(VCPU, wait_exits),
+	STATS_DESC_COUNTER(VCPU, cache_exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, int_exits),
+	STATS_DESC_COUNTER(VCPU, cop_unusable_exits),
+	STATS_DESC_COUNTER(VCPU, tlbmod_exits),
+	STATS_DESC_COUNTER(VCPU, tlbmiss_ld_exits),
+	STATS_DESC_COUNTER(VCPU, tlbmiss_st_exits),
+	STATS_DESC_COUNTER(VCPU, addrerr_st_exits),
+	STATS_DESC_COUNTER(VCPU, addrerr_ld_exits),
+	STATS_DESC_COUNTER(VCPU, syscall_exits),
+	STATS_DESC_COUNTER(VCPU, resvd_inst_exits),
+	STATS_DESC_COUNTER(VCPU, break_inst_exits),
+	STATS_DESC_COUNTER(VCPU, trap_inst_exits),
+	STATS_DESC_COUNTER(VCPU, msa_fpe_exits),
+	STATS_DESC_COUNTER(VCPU, fpe_exits),
+	STATS_DESC_COUNTER(VCPU, msa_disabled_exits),
+	STATS_DESC_COUNTER(VCPU, flush_dcache_exits),
+	STATS_DESC_COUNTER(VCPU, vz_gpsi_exits),
+	STATS_DESC_COUNTER(VCPU, vz_gsfc_exits),
+	STATS_DESC_COUNTER(VCPU, vz_hc_exits),
+	STATS_DESC_COUNTER(VCPU, vz_grr_exits),
+	STATS_DESC_COUNTER(VCPU, vz_gva_exits),
+	STATS_DESC_COUNTER(VCPU, vz_ghfc_exits),
+	STATS_DESC_COUNTER(VCPU, vz_gpa_exits),
+	STATS_DESC_COUNTER(VCPU, vz_resvd_exits),
 #ifdef CONFIG_CPU_LOONGSON64
-	STATS_DESC_COUNTER("vz_cpucfg_exits"),
-#endif
+	STATS_DESC_COUNTER(VCPU, vz_cpucfg_exits),
 #endif
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index eff5a96aa638..15436484e521 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -40,9 +40,11 @@
 
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
-	STATS_DESC_ICOUNTER("num_2M_pages"),
-	STATS_DESC_ICOUNTER("num_1G_pages")
+	STATS_DESC_ICOUNTER(VM, num_2M_pages),
+	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -56,37 +58,39 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("sum_exits"),
-	STATS_DESC_COUNTER("mmio_exits"),
-	STATS_DESC_COUNTER("signal_exits"),
-	STATS_DESC_COUNTER("light_exits"),
-	STATS_DESC_COUNTER("itlb_real_miss_exits"),
-	STATS_DESC_COUNTER("itlb_virt_miss_exits"),
-	STATS_DESC_COUNTER("dtlb_real_miss_exits"),
-	STATS_DESC_COUNTER("dtlb_virt_miss_exits"),
-	STATS_DESC_COUNTER("syscall_exits"),
-	STATS_DESC_COUNTER("isi_exits"),
-	STATS_DESC_COUNTER("dsi_exits"),
-	STATS_DESC_COUNTER("emulated_inst_exits"),
-	STATS_DESC_COUNTER("dec_exits"),
-	STATS_DESC_COUNTER("ext_intr_exits"),
-	STATS_DESC_TIME_NSEC("halt_wait_ns"),
-	STATS_DESC_COUNTER("halt_successful_wait"),
-	STATS_DESC_COUNTER("dbell_exits"),
-	STATS_DESC_COUNTER("gdbell_exits"),
-	STATS_DESC_COUNTER("ld"),
-	STATS_DESC_COUNTER("st"),
-	STATS_DESC_COUNTER("pf_storage"),
-	STATS_DESC_COUNTER("pf_instruc"),
-	STATS_DESC_COUNTER("sp_storage"),
-	STATS_DESC_COUNTER("sp_instruc"),
-	STATS_DESC_COUNTER("queue_intr"),
-	STATS_DESC_COUNTER("ld_slow"),
-	STATS_DESC_COUNTER("st_slow"),
-	STATS_DESC_COUNTER("pthru_all"),
-	STATS_DESC_COUNTER("pthru_host"),
-	STATS_DESC_COUNTER("pthru_bad_aff")
+	STATS_DESC_COUNTER(VCPU, sum_exits),
+	STATS_DESC_COUNTER(VCPU, mmio_exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, light_exits),
+	STATS_DESC_COUNTER(VCPU, itlb_real_miss_exits),
+	STATS_DESC_COUNTER(VCPU, itlb_virt_miss_exits),
+	STATS_DESC_COUNTER(VCPU, dtlb_real_miss_exits),
+	STATS_DESC_COUNTER(VCPU, dtlb_virt_miss_exits),
+	STATS_DESC_COUNTER(VCPU, syscall_exits),
+	STATS_DESC_COUNTER(VCPU, isi_exits),
+	STATS_DESC_COUNTER(VCPU, dsi_exits),
+	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
+	STATS_DESC_COUNTER(VCPU, dec_exits),
+	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
+	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
+	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
+	STATS_DESC_COUNTER(VCPU, dbell_exits),
+	STATS_DESC_COUNTER(VCPU, gdbell_exits),
+	STATS_DESC_COUNTER(VCPU, ld),
+	STATS_DESC_COUNTER(VCPU, st),
+	STATS_DESC_COUNTER(VCPU, pf_storage),
+	STATS_DESC_COUNTER(VCPU, pf_instruc),
+	STATS_DESC_COUNTER(VCPU, sp_storage),
+	STATS_DESC_COUNTER(VCPU, sp_instruc),
+	STATS_DESC_COUNTER(VCPU, queue_intr),
+	STATS_DESC_COUNTER(VCPU, ld_slow),
+	STATS_DESC_COUNTER(VCPU, st_slow),
+	STATS_DESC_COUNTER(VCPU, pthru_all),
+	STATS_DESC_COUNTER(VCPU, pthru_host),
+	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 5b0c4dff4f10..fbc9b7b6af57 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -38,9 +38,11 @@ unsigned long kvmppc_booke_handlers;
 
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
-	STATS_DESC_ICOUNTER("num_2M_pages"),
-	STATS_DESC_ICOUNTER("num_1G_pages")
+	STATS_DESC_ICOUNTER(VM, num_2M_pages),
+	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -54,30 +56,32 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("sum_exits"),
-	STATS_DESC_COUNTER("mmio_exits"),
-	STATS_DESC_COUNTER("signal_exits"),
-	STATS_DESC_COUNTER("light_exits"),
-	STATS_DESC_COUNTER("itlb_real_miss_exits"),
-	STATS_DESC_COUNTER("itlb_virt_miss_exits"),
-	STATS_DESC_COUNTER("dtlb_real_miss_exits"),
-	STATS_DESC_COUNTER("dtlb_virt_miss_exits"),
-	STATS_DESC_COUNTER("syscall_exits"),
-	STATS_DESC_COUNTER("isi_exits"),
-	STATS_DESC_COUNTER("dsi_exits"),
-	STATS_DESC_COUNTER("emulated_inst_exits"),
-	STATS_DESC_COUNTER("dec_exits"),
-	STATS_DESC_COUNTER("ext_intr_exits"),
-	STATS_DESC_TIME_NSEC("halt_wait_ns"),
-	STATS_DESC_COUNTER("halt_successful_wait"),
-	STATS_DESC_COUNTER("dbell_exits"),
-	STATS_DESC_COUNTER("gdbell_exits"),
-	STATS_DESC_COUNTER("ld"),
-	STATS_DESC_COUNTER("st"),
-	STATS_DESC_COUNTER("pthru_all"),
-	STATS_DESC_COUNTER("pthru_host"),
-	STATS_DESC_COUNTER("pthru_bad_aff")
+	STATS_DESC_COUNTER(VCPU, sum_exits),
+	STATS_DESC_COUNTER(VCPU, mmio_exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, light_exits),
+	STATS_DESC_COUNTER(VCPU, itlb_real_miss_exits),
+	STATS_DESC_COUNTER(VCPU, itlb_virt_miss_exits),
+	STATS_DESC_COUNTER(VCPU, dtlb_real_miss_exits),
+	STATS_DESC_COUNTER(VCPU, dtlb_virt_miss_exits),
+	STATS_DESC_COUNTER(VCPU, syscall_exits),
+	STATS_DESC_COUNTER(VCPU, isi_exits),
+	STATS_DESC_COUNTER(VCPU, dsi_exits),
+	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
+	STATS_DESC_COUNTER(VCPU, dec_exits),
+	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
+	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
+	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
+	STATS_DESC_COUNTER(VCPU, dbell_exits),
+	STATS_DESC_COUNTER(VCPU, gdbell_exits),
+	STATS_DESC_COUNTER(VCPU, ld),
+	STATS_DESC_COUNTER(VCPU, st),
+	STATS_DESC_COUNTER(VCPU, pthru_all),
+	STATS_DESC_COUNTER(VCPU, pthru_host),
+	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 522a6ac2e347..b5ca41e04fa5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -60,12 +60,14 @@
 
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
-	STATS_DESC_COUNTER("inject_io"),
-	STATS_DESC_COUNTER("inject_float_mchk"),
-	STATS_DESC_COUNTER("inject_pfault_done"),
-	STATS_DESC_COUNTER("inject_service_signal"),
-	STATS_DESC_COUNTER("inject_virtio")
+	STATS_DESC_COUNTR(VM, inject_io),
+	STATS_DESC_COUNTR(VM, inject_float_mchk),
+	STATS_DESC_COUNTR(VM, inject_pfault_done),
+	STATS_DESC_COUNTR(VM, inject_service_signal),
+	STATS_DESC_COUNTR(VM, inject_virtio)
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -79,99 +81,102 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("exit_userspace"),
-	STATS_DESC_COUNTER("exit_null"),
-	STATS_DESC_COUNTER("exit_external_request"),
-	STATS_DESC_COUNTER("exit_io_request"),
-	STATS_DESC_COUNTER("exit_external_interrupt"),
-	STATS_DESC_COUNTER("exit_stop_request"),
-	STATS_DESC_COUNTER("exit_validity"),
-	STATS_DESC_COUNTER("exit_instruction"),
-	STATS_DESC_COUNTER("exit_pei"),
-	STATS_DESC_COUNTER("halt_no_poll_steal"),
-	STATS_DESC_COUNTER("instruction_lctl"),
-	STATS_DESC_COUNTER("instruction_lctlg"),
-	STATS_DESC_COUNTER("instruction_stctl"),
-	STATS_DESC_COUNTER("instruction_stctg"),
-	STATS_DESC_COUNTER("exit_program_interruption"),
-	STATS_DESC_COUNTER("exit_instr_and_program"),
-	STATS_DESC_COUNTER("exit_operation_exception"),
-	STATS_DESC_COUNTER("deliver_ckc"),
-	STATS_DESC_COUNTER("deliver_cputm"),
-	STATS_DESC_COUNTER("deliver_external_call"),
-	STATS_DESC_COUNTER("deliver_emergency_signal"),
-	STATS_DESC_COUNTER("deliver_service_signal"),
-	STATS_DESC_COUNTER("deliver_virtio"),
-	STATS_DESC_COUNTER("deliver_stop_signal"),
-	STATS_DESC_COUNTER("deliver_prefix_signal"),
-	STATS_DESC_COUNTER("deliver_restart_signal"),
-	STATS_DESC_COUNTER("deliver_program"),
-	STATS_DESC_COUNTER("deliver_io"),
-	STATS_DESC_COUNTER("deliver_machine_check"),
-	STATS_DESC_COUNTER("exit_wait_state"),
-	STATS_DESC_COUNTER("inject_ckc"),
-	STATS_DESC_COUNTER("inject_cputm"),
-	STATS_DESC_COUNTER("inject_external_call"),
-	STATS_DESC_COUNTER("inject_emergency_signal"),
-	STATS_DESC_COUNTER("inject_mchk"),
-	STATS_DESC_COUNTER("inject_pfault_init"),
-	STATS_DESC_COUNTER("inject_program"),
-	STATS_DESC_COUNTER("inject_restart"),
-	STATS_DESC_COUNTER("inject_set_prefix"),
-	STATS_DESC_COUNTER("inject_stop_signal"),
-	STATS_DESC_COUNTER("instruction_epsw"),
-	STATS_DESC_COUNTER("instruction_gs"),
-	STATS_DESC_COUNTER("instruction_io_other"),
-	STATS_DESC_COUNTER("instruction_lpsw"),
-	STATS_DESC_COUNTER("instruction_lpswe"),
-	STATS_DESC_COUNTER("instruction_pfmf"),
-	STATS_DESC_COUNTER("instruction_ptff"),
-	STATS_DESC_COUNTER("instruction_sck"),
-	STATS_DESC_COUNTER("instruction_sckpf"),
-	STATS_DESC_COUNTER("instruction_stidp"),
-	STATS_DESC_COUNTER("instruction_spx"),
-	STATS_DESC_COUNTER("instruction_stpx"),
-	STATS_DESC_COUNTER("instruction_stap"),
-	STATS_DESC_COUNTER("instruction_iske"),
-	STATS_DESC_COUNTER("instruction_ri"),
-	STATS_DESC_COUNTER("instruction_rrbe"),
-	STATS_DESC_COUNTER("instruction_sske"),
-	STATS_DESC_COUNTER("instruction_ipte_interlock"),
-	STATS_DESC_COUNTER("instruction_stsi"),
-	STATS_DESC_COUNTER("instruction_stfl"),
-	STATS_DESC_COUNTER("instruction_tb"),
-	STATS_DESC_COUNTER("instruction_tpi"),
-	STATS_DESC_COUNTER("instruction_tprot"),
-	STATS_DESC_COUNTER("instruction_tsch"),
-	STATS_DESC_COUNTER("instruction_sie"),
-	STATS_DESC_COUNTER("instruction_essa"),
-	STATS_DESC_COUNTER("instruction_sthyi"),
-	STATS_DESC_COUNTER("instruction_sigp_sense"),
-	STATS_DESC_COUNTER("instruction_sigp_sense_running"),
-	STATS_DESC_COUNTER("instruction_sigp_external_call"),
-	STATS_DESC_COUNTER("instruction_sigp_emergency"),
-	STATS_DESC_COUNTER("instruction_sigp_cond_emergency"),
-	STATS_DESC_COUNTER("instruction_sigp_start"),
-	STATS_DESC_COUNTER("instruction_sigp_stop"),
-	STATS_DESC_COUNTER("instruction_sigp_stop_store_status"),
-	STATS_DESC_COUNTER("instruction_sigp_store_status"),
-	STATS_DESC_COUNTER("instruction_sigp_store_adtl_status"),
-	STATS_DESC_COUNTER("instruction_sigp_arch"),
-	STATS_DESC_COUNTER("instruction_sigp_prefix"),
-	STATS_DESC_COUNTER("instruction_sigp_restart"),
-	STATS_DESC_COUNTER("instruction_sigp_init_cpu_reset"),
-	STATS_DESC_COUNTER("instruction_sigp_cpu_reset"),
-	STATS_DESC_COUNTER("instruction_sigp_unknown"),
-	STATS_DESC_COUNTER("diagnose_10"),
-	STATS_DESC_COUNTER("diagnose_44"),
-	STATS_DESC_COUNTER("diagnose_9c"),
-	STATS_DESC_COUNTER("diagnose_9c_ignored"),
-	STATS_DESC_COUNTER("diagnose_258"),
-	STATS_DESC_COUNTER("diagnose_308"),
-	STATS_DESC_COUNTER("diagnose_500"),
-	STATS_DESC_COUNTER("diagnose_other"),
-	STATS_DESC_COUNTER("pfault_sync")
+	STATS_DESC_COUNTER(VCPU, exit_userspace),
+	STATS_DESC_COUNTER(VCPU, exit_null),
+	STATS_DESC_COUNTER(VCPU, exit_external_request),
+	STATS_DESC_COUNTER(VCPU, exit_io_request),
+	STATS_DESC_COUNTER(VCPU, exit_external_interrupt),
+	STATS_DESC_COUNTER(VCPU, exit_stop_request),
+	STATS_DESC_COUNTER(VCPU, exit_validity),
+	STATS_DESC_COUNTER(VCPU, exit_instruction),
+	STATS_DESC_COUNTER(VCPU, exit_pei),
+	STATS_DESC_COUNTER(VCPU, halt_no_poll_steal),
+	STATS_DESC_COUNTER(VCPU, instruction_lctl),
+	STATS_DESC_COUNTER(VCPU, instruction_lctlg),
+	STATS_DESC_COUNTER(VCPU, instruction_stctl),
+	STATS_DESC_COUNTER(VCPU, instruction_stctg),
+	STATS_DESC_COUNTER(VCPU, exit_program_interruption),
+	STATS_DESC_COUNTER(VCPU, exit_instr_and_program),
+	STATS_DESC_COUNTER(VCPU, exit_operation_exception),
+	STATS_DESC_COUNTER(VCPU, deliver_ckc),
+	STATS_DESC_COUNTER(VCPU, deliver_cputm),
+	STATS_DESC_COUNTER(VCPU, deliver_external_call),
+	STATS_DESC_COUNTER(VCPU, deliver_emergency_signal),
+	STATS_DESC_COUNTER(VCPU, deliver_service_signal),
+	STATS_DESC_COUNTER(VCPU, deliver_virtio),
+	STATS_DESC_COUNTER(VCPU, deliver_stop_signal),
+	STATS_DESC_COUNTER(VCPU, deliver_prefix_signal),
+	STATS_DESC_COUNTER(VCPU, deliver_restart_signal),
+	STATS_DESC_COUNTER(VCPU, deliver_program),
+	STATS_DESC_COUNTER(VCPU, deliver_io),
+	STATS_DESC_COUNTER(VCPU, deliver_machine_check),
+	STATS_DESC_COUNTER(VCPU, exit_wait_state),
+	STATS_DESC_COUNTER(VCPU, inject_ckc),
+	STATS_DESC_COUNTER(VCPU, inject_cputm),
+	STATS_DESC_COUNTER(VCPU, inject_external_call),
+	STATS_DESC_COUNTER(VCPU, inject_emergency_signal),
+	STATS_DESC_COUNTER(VCPU, inject_mchk),
+	STATS_DESC_COUNTER(VCPU, inject_pfault_init),
+	STATS_DESC_COUNTER(VCPU, inject_program),
+	STATS_DESC_COUNTER(VCPU, inject_restart),
+	STATS_DESC_COUNTER(VCPU, inject_set_prefix),
+	STATS_DESC_COUNTER(VCPU, inject_stop_signal),
+	STATS_DESC_COUNTER(VCPU, instruction_epsw),
+	STATS_DESC_COUNTER(VCPU, instruction_gs),
+	STATS_DESC_COUNTER(VCPU, instruction_io_other),
+	STATS_DESC_COUNTER(VCPU, instruction_lpsw),
+	STATS_DESC_COUNTER(VCPU, instruction_lpswe),
+	STATS_DESC_COUNTER(VCPU, instruction_pfmf),
+	STATS_DESC_COUNTER(VCPU, instruction_ptff),
+	STATS_DESC_COUNTER(VCPU, instruction_sck),
+	STATS_DESC_COUNTER(VCPU, instruction_sckpf),
+	STATS_DESC_COUNTER(VCPU, instruction_stidp),
+	STATS_DESC_COUNTER(VCPU, instruction_spx),
+	STATS_DESC_COUNTER(VCPU, instruction_stpx),
+	STATS_DESC_COUNTER(VCPU, instruction_stap),
+	STATS_DESC_COUNTER(VCPU, instruction_iske),
+	STATS_DESC_COUNTER(VCPU, instruction_ri),
+	STATS_DESC_COUNTER(VCPU, instruction_rrbe),
+	STATS_DESC_COUNTER(VCPU, instruction_sske),
+	STATS_DESC_COUNTER(VCPU, instruction_ipte_interlock),
+	STATS_DESC_COUNTER(VCPU, instruction_stsi),
+	STATS_DESC_COUNTER(VCPU, instruction_stfl),
+	STATS_DESC_COUNTER(VCPU, instruction_tb),
+	STATS_DESC_COUNTER(VCPU, instruction_tpi),
+	STATS_DESC_COUNTER(VCPU, instruction_tprot),
+	STATS_DESC_COUNTER(VCPU, instruction_tsch),
+	STATS_DESC_COUNTER(VCPU, instruction_sie),
+	STATS_DESC_COUNTER(VCPU, instruction_essa),
+	STATS_DESC_COUNTER(VCPU, instruction_sthyi),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_sense),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_sense_running),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_external_call),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_emergency),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_cond_emergency),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_start),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_stop),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_stop_store_status),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_store_status),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_store_adtl_status),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_arch),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_prefix),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_restart),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_init_cpu_reset),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_cpu_reset),
+	STATS_DESC_COUNTER(VCPU, instruction_sigp_unknown),
+	STATS_DESC_COUNTER(VCPU, diagnose_10),
+	STATS_DESC_COUNTER(VCPU, diagnose_44),
+	STATS_DESC_COUNTER(VCPU, diagnose_9c),
+	STATS_DESC_COUNTER(VCPU, diagnose_9c_ignored),
+	STATS_DESC_COUNTER(VCPU, diagnose_9c_forward),
+	STATS_DESC_COUNTER(VCPU, diagnose_258),
+	STATS_DESC_COUNTER(VCPU, diagnose_308),
+	STATS_DESC_COUNTER(VCPU, diagnose_500),
+	STATS_DESC_COUNTER(VCPU, diagnose_other),
+	STATS_DESC_COUNTER(VCPU, pfault_sync)
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acc28473dec7..84438573b529 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -225,17 +225,19 @@ EXPORT_SYMBOL_GPL(supported_xss);
 
 struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
-	STATS_DESC_COUNTER("mmu_shadow_zapped"),
-	STATS_DESC_COUNTER("mmu_pte_write"),
-	STATS_DESC_COUNTER("mmu_pde_zapped"),
-	STATS_DESC_COUNTER("mmu_flooded"),
-	STATS_DESC_COUNTER("mmu_recycled"),
-	STATS_DESC_COUNTER("mmu_cache_miss"),
-	STATS_DESC_ICOUNTER("mmu_unsync"),
-	STATS_DESC_ICOUNTER("largepages"),
-	STATS_DESC_ICOUNTER("nx_largepages_splits"),
-	STATS_DESC_ICOUNTER("max_mmu_page_hash_collisions")
+	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
+	STATS_DESC_COUNTER(VM, mmu_pte_write),
+	STATS_DESC_COUNTER(VM, mmu_pde_zapped),
+	STATS_DESC_COUNTER(VM, mmu_flooded),
+	STATS_DESC_COUNTER(VM, mmu_recycled),
+	STATS_DESC_COUNTER(VM, mmu_cache_miss),
+	STATS_DESC_ICOUNTER(VM, mmu_unsync),
+	STATS_DESC_ICOUNTER(VM, lpages),
+	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
+	STATS_DESC_ICOUNTER(VM, max_mmu_page_hash_collisions)
 };
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vm_stats_header = {
 	{
@@ -249,30 +251,35 @@ struct _kvm_stats_header kvm_vm_stats_header = {
 
 struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER("pf_fixed"),
-	STATS_DESC_COUNTER("pf_guest"),
-	STATS_DESC_COUNTER("tlb_flush"),
-	STATS_DESC_COUNTER("invlpg"),
-	STATS_DESC_COUNTER("exits"),
-	STATS_DESC_COUNTER("io_exits"),
-	STATS_DESC_COUNTER("mmio_exits"),
-	STATS_DESC_COUNTER("signal_exits"),
-	STATS_DESC_COUNTER("irq_window_exits"),
-	STATS_DESC_COUNTER("nmi_window_exits"),
-	STATS_DESC_COUNTER("l1d_flush"),
-	STATS_DESC_COUNTER("halt_exits"),
-	STATS_DESC_COUNTER("request_irq_exits"),
-	STATS_DESC_COUNTER("irq_exits"),
-	STATS_DESC_COUNTER("host_state_reload"),
-	STATS_DESC_COUNTER("fpu_reload"),
-	STATS_DESC_COUNTER("insn_emulation"),
-	STATS_DESC_COUNTER("insn_emulation_fail"),
-	STATS_DESC_COUNTER("hypercalls"),
-	STATS_DESC_COUNTER("irq_injections"),
-	STATS_DESC_COUNTER("nmi_injections"),
-	STATS_DESC_COUNTER("req_event"),
-	STATS_DESC_COUNTER("nested_run")
+	STATS_DESC_COUNTER(VCPU, pf_fixed),
+	STATS_DESC_COUNTER(VCPU, pf_guest),
+	STATS_DESC_COUNTER(VCPU, tlb_flush),
+	STATS_DESC_COUNTER(VCPU, invlpg),
+	STATS_DESC_COUNTER(VCPU, exits),
+	STATS_DESC_COUNTER(VCPU, io_exits),
+	STATS_DESC_COUNTER(VCPU, mmio_exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, irq_window_exits),
+	STATS_DESC_COUNTER(VCPU, nmi_window_exits),
+	STATS_DESC_COUNTER(VCPU, l1d_flush),
+	STATS_DESC_COUNTER(VCPU, halt_exits),
+	STATS_DESC_COUNTER(VCPU, request_irq_exits),
+	STATS_DESC_COUNTER(VCPU, irq_exits),
+	STATS_DESC_COUNTER(VCPU, host_state_reload),
+	STATS_DESC_COUNTER(VCPU, fpu_reload),
+	STATS_DESC_COUNTER(VCPU, insn_emulation),
+	STATS_DESC_COUNTER(VCPU, insn_emulation_fail),
+	STATS_DESC_COUNTER(VCPU, hypercalls),
+	STATS_DESC_COUNTER(VCPU, irq_injections),
+	STATS_DESC_COUNTER(VCPU, nmi_injections),
+	STATS_DESC_COUNTER(VCPU, req_event),
+	STATS_DESC_COUNTER(VCPU, nested_run),
+	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
+	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
+	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 struct _kvm_stats_header kvm_vcpu_stats_header = {
 	{
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5e77f32abef5..692af9177c9f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
 	{ n, offsetof(struct kvm_vcpu, stat.generic.x),			       \
 	  KVM_STAT_VCPU, ## __VA_ARGS__ }
 
-#define STATS_DESC(stat, type, unit, base, exp)			       \
+#define STATS_DESC_COMMON(type, unit, base, exp)			       \
+	.flags = type | unit | base |					       \
+	    BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |		       \
+	    BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |		       \
+	    BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),		       \
+	.exponent = exp,						       \
+	.size = 1
+
+#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
 	{								       \
 		{							       \
-			.flags = type | unit | base |			       \
-			    BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
-			    BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
-			    BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
-			.exponent = exp,				       \
-			.size = 1					       \
+			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
 		},							       \
-		.name = stat,						       \
+		.name = #stat,						       \
 	}
-#define STATS_DESC_CUMULATIVE(name, unit, base, exponent)		       \
-	STATS_DESC(name, KVM_STATS_TYPE_CUMULATIVE, unit, base, exponent)
-#define STATS_DESC_INSTANT(name, unit, base, exponent)			       \
-	STATS_DESC(name, KVM_STATS_TYPE_INSTANT, unit, base, exponent)
+#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+	{								       \
+		{							       \
+			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
+		},							       \
+		.name = #stat,						       \
+	}
+#define VM_STATS_DESC(stat, type, unit, base, exp)			       \
+	{								       \
+		{							       \
+			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			.offset = offsetof(struct kvm_vm_stat, stat)	       \
+		},							       \
+		.name = #stat,						       \
+	}
+#define VCPU_STATS_DESC(stat, type, unit, base, exp)			       \
+	{								       \
+		{							       \
+			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
+		},							       \
+		.name = #stat,						       \
+	}
+/* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
+#define STATS_DESC(SCOPE, stat, type, unit, base, exp)			       \
+	SCOPE##_STATS_DESC(stat, type, unit, base, exp)
+
+#define STATS_DESC_CUMULATIVE(SCOPE, name, unit, base, exponent)	       \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE,		       \
+		      unit, base, exponent)
+#define STATS_DESC_INSTANT(SCOPE, name, unit, base, exponent)		       \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT, unit, base, exponent)  \
 
 /* Cumulative counter */
-#define STATS_DESC_COUNTER(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_COUNTER(SCOPE, name)					       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Instantaneous counter */
-#define STATS_DESC_ICOUNTER(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_NONE,			       \
+#define STATS_DESC_ICOUNTER(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Cumulative clock cycles */
-#define STATS_DESC_CYCLE(name)						       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_CYCLES,		       \
+#define STATS_DESC_CYCLE(SCOPE, name)					       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_CYCLES,	       \
 		KVM_STATS_BASE_POW10, 0)
 /* Instantaneous clock cycles */
-#define STATS_DESC_ICYCLE(name)						       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_CYCLES,			       \
+#define STATS_DESC_ICYCLE(SCOPE, name)					       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_CYCLES,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Cumulative memory size in Byte */
-#define STATS_DESC_SIZE_BYTE(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_BYTES,		       \
+#define STATS_DESC_SIZE_BYTE(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_BYTES,	       \
 		KVM_STATS_BASE_POW2, 0)
 /* Cumulative memory size in KiByte */
-#define STATS_DESC_SIZE_KBYTE(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_BYTES,		       \
+#define STATS_DESC_SIZE_KBYTE(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_BYTES,	       \
 		KVM_STATS_BASE_POW2, 10)
 /* Cumulative memory size in MiByte */
-#define STATS_DESC_SIZE_MBYTE(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_BYTES,		       \
+#define STATS_DESC_SIZE_MBYTE(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_BYTES,	       \
 		KVM_STATS_BASE_POW2, 20)
 /* Cumulative memory size in GiByte */
-#define STATS_DESC_SIZE_GBYTE(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_BYTES,		       \
+#define STATS_DESC_SIZE_GBYTE(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_BYTES,	       \
 		KVM_STATS_BASE_POW2, 30)
 
 /* Instantaneous memory size in Byte */
-#define STATS_DESC_ISIZE_BYTE(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_BYTES,			       \
+#define STATS_DESC_ISIZE_BYTE(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BYTES,		       \
 		KVM_STATS_BASE_POW2, 0)
 /* Instantaneous memory size in KiByte */
-#define STATS_DESC_ISIZE_KBYTE(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_BYTES,			       \
+#define STATS_DESC_ISIZE_KBYTE(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BYTES,		       \
 		KVM_STATS_BASE_POW2, 10)
 /* Instantaneous memory size in MiByte */
-#define STATS_DESC_ISIZE_MBYTE(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_BYTES,			       \
+#define STATS_DESC_ISIZE_MBYTE(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BYTES,		       \
 		KVM_STATS_BASE_POW2, 20)
 /* Instantaneous memory size in GiByte */
-#define STATS_DESC_ISIZE_GBYTE(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_BYTES,			       \
+#define STATS_DESC_ISIZE_GBYTE(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BYTES,		       \
 		KVM_STATS_BASE_POW2, 30)
 
 /* Cumulative time in second */
-#define STATS_DESC_TIME_SEC(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_TIME_SEC(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, 0)
 /* Cumulative time in millisecond */
-#define STATS_DESC_TIME_MSEC(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_TIME_MSEC(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -3)
 /* Cumulative time in microsecond */
-#define STATS_DESC_TIME_USEC(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_TIME_USEC(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -6)
 /* Cumulative time in nanosecond */
-#define STATS_DESC_TIME_NSEC(name)					       \
-	STATS_DESC_CUMULATIVE(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
 
 /* Instantaneous time in second */
-#define STATS_DESC_ITIME_SEC(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_ITIME_SEC(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_SECONDS,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Instantaneous time in millisecond */
-#define STATS_DESC_ITIME_MSEC(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_ITIME_MSEC(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_SECONDS,		       \
 		KVM_STATS_BASE_POW10, -3)
 /* Instantaneous time in microsecond */
-#define STATS_DESC_ITIME_USEC(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_ITIME_USEC(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_SECONDS,		       \
 		KVM_STATS_BASE_POW10, -6)
 /* Instantaneous time in nanosecond */
-#define STATS_DESC_ITIME_NSEC(name)					       \
-	STATS_DESC_INSTANT(name, KVM_STATS_UNIT_SECONDS,		       \
+#define STATS_DESC_ITIME_NSEC(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_SECONDS,		       \
 		KVM_STATS_BASE_POW10, -9)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER("remote_tlb_flush")
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
-	STATS_DESC_COUNTER("halt_successful_poll"),			       \
-	STATS_DESC_COUNTER("halt_attempted_poll"),			       \
-	STATS_DESC_COUNTER("halt_poll_invalid"),			       \
-	STATS_DESC_COUNTER("halt_wakeup"),				       \
-	STATS_DESC_TIME_NSEC("halt_poll_success_ns"),			       \
-	STATS_DESC_TIME_NSEC("halt_poll_fail_ns")
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_attempted_poll),		       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
 
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index df69a7abbb33..d6e97b577d01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1940,8 +1940,8 @@ struct kvm_stats_desc {
 	__u32 flags;
 	__s16 exponent;
 	__u16 size;
-	__u32 unused1;
-	__u32 unused2;
+	__u32 offset;
+	__u32 unused;
 	char name[0];
 };
 
-- 
2.32.0.272.g935e593368-goog

