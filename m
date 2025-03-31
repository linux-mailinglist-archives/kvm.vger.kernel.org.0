Return-Path: <kvm+bounces-42246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED8A76242
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7365166106
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0021F2BB5;
	Mon, 31 Mar 2025 08:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dojm+Dpg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3111EEA37;
	Mon, 31 Mar 2025 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409469; cv=none; b=jmwj7KwBbR6y8vW+5gS34JYDZP+mm1jJhC1JaMjMz/MwspO0uaBS8SEJvksBbX6YrTOj9TxEYS1CTpxmhJwWxBPdYh97RHvLM6cUOILPUN4MYUQ2xIqv5A+LvUBzeT0aSaRAIQdQq932TWZAJ2MbebhKPrOpBGbHP3lO3KcYf5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409469; c=relaxed/simple;
	bh=AoEHiNomUXTLBsZt4rMkNOk4470R/zK+4XLCkfKkmCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z34d4oU7uiIok76wbKfTssq31WUaLC+M0ipzWiDwuIyjh6Xc0a0KouhBXxv77XjTx65cXY3kLPaZs8ErM4GbwwOExF1aj92eGMLFdFCjilBfFf8ZjUn3gc335SAWzF/2ouYfgCTG+/D8dU6+VuhTXJtAdXOiZHdVkO/WGiAfnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dojm+Dpg; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp053171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp053171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409390;
	bh=S3swNgI99EyAKvvqMZiCU9IrqVA5GQts4Tvl6BiIxb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dojm+DpgfYvbJxe4bv9ERf6lObdkKGws+H++OPxcP81M9c542DdQA77cLignnUuwF
	 E0OyDovwZjUMlVfVuV/OGBGyfcYMnrDHCs4DbWXSLge6Hw07JbhQ3e4+A4YufL5+Vf
	 KAcevYltBLXe8AzQ5l74EGDn8RcUVpT9sw3r7Q1O3VLmXW/ZMyQIqONrrgqJyt3R6Y
	 hmw39rO0oJ0Tyqs5MFI9ajtUWEagdP4qRYRQ54wbuw8Vdoma5mWmh+l7VI4ay0q41q
	 +p194X/jk0oM3oQCUzLC8VAVfkXKe7oge/M/8qV3o6il81Z3+5gOJ9d1cP9haH6+35
	 Xkyjs8fsNRJGA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 05/15] x86/msr: Replace wrmsr(msr, low, 0) with wrmsrl(msr, value)
Date: Mon, 31 Mar 2025 01:22:41 -0700
Message-ID: <20250331082251.3171276-6-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/hyperv/hv_apic.c                 |  6 +++---
 arch/x86/include/asm/apic.h               |  2 +-
 arch/x86/include/asm/switch_to.h          |  2 +-
 arch/x86/kernel/cpu/amd.c                 |  2 +-
 arch/x86/kernel/cpu/common.c              |  8 ++++----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  4 ++--
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 arch/x86/kernel/cpu/umwait.c              |  4 ++--
 arch/x86/kernel/kvm.c                     |  2 +-
 drivers/ata/pata_cs5535.c                 | 12 ++++++------
 drivers/ata/pata_cs5536.c                 |  6 +++---
 drivers/cpufreq/acpi-cpufreq.c            |  2 +-
 drivers/cpufreq/e_powersaver.c            |  2 +-
 drivers/cpufreq/powernow-k6.c             |  8 ++++----
 14 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index 6d91ac5f9836..284e16fe359b 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -75,10 +75,10 @@ static void hv_apic_write(u32 reg, u32 val)
 {
 	switch (reg) {
 	case APIC_EOI:
-		wrmsr(HV_X64_MSR_EOI, val, 0);
+		wrmsrl(HV_X64_MSR_EOI, val);
 		break;
 	case APIC_TASKPRI:
-		wrmsr(HV_X64_MSR_TPR, val, 0);
+		wrmsrl(HV_X64_MSR_TPR, val);
 		break;
 	default:
 		native_apic_mem_write(reg, val);
@@ -92,7 +92,7 @@ static void hv_apic_eoi_write(void)
 	if (hvp && (xchg(&hvp->apic_assist, 0) & 0x1))
 		return;
 
-	wrmsr(HV_X64_MSR_EOI, APIC_EOI_ACK, 0);
+	wrmsrl(HV_X64_MSR_EOI, APIC_EOI_ACK);
 }
 
 static bool cpu_is_self(int cpu)
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3345a819c859..003b2cd2266b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -209,7 +209,7 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 	    reg == APIC_LVR)
 		return;
 
-	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
+	wrmsrl(APIC_BASE_MSR + (reg >> 4), v);
 }
 
 static inline void native_apic_msr_eoi(void)
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 75248546403d..525896a18028 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -59,7 +59,7 @@ static inline void refresh_sysenter_cs(struct thread_struct *thread)
 		return;
 
 	this_cpu_write(cpu_tss_rw.x86_tss.ss1, thread->sysenter_cs);
-	wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
+	wrmsrl(MSR_IA32_SYSENTER_CS, thread->sysenter_cs);
 }
 #endif
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 79569f72b8ee..2f70cd525043 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1200,7 +1200,7 @@ void amd_set_dr_addr_mask(unsigned long mask, unsigned int dr)
 	if (per_cpu(amd_dr_addr_mask, cpu)[dr] == mask)
 		return;
 
-	wrmsr(amd_msr_dr_addr_masks[dr], mask, 0);
+	wrmsrl(amd_msr_dr_addr_masks[dr], mask);
 	per_cpu(amd_dr_addr_mask, cpu)[dr] = mask;
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a268db71d944..9b53f92df21c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1982,9 +1982,9 @@ void enable_sep_cpu(void)
 	 */
 
 	tss->x86_tss.ss1 = __KERNEL_CS;
-	wrmsr(MSR_IA32_SYSENTER_CS, tss->x86_tss.ss1, 0);
-	wrmsr(MSR_IA32_SYSENTER_ESP, (unsigned long)(cpu_entry_stack(cpu) + 1), 0);
-	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long)entry_SYSENTER_32, 0);
+	wrmsrl(MSR_IA32_SYSENTER_CS, tss->x86_tss.ss1);
+	wrmsrl(MSR_IA32_SYSENTER_ESP, (unsigned long)(cpu_entry_stack(cpu) + 1));
+	wrmsrl(MSR_IA32_SYSENTER_EIP, (unsigned long)entry_SYSENTER_32);
 
 	put_cpu();
 }
@@ -2198,7 +2198,7 @@ static inline void setup_getcpu(int cpu)
 	struct desc_struct d = { };
 
 	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
-		wrmsr(MSR_TSC_AUX, cpudata, 0);
+		wrmsrl(MSR_TSC_AUX, cpudata);
 
 	/* Store CPU and node number in limit. */
 	d.limit0 = cpudata;
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 675fd9f93e33..44a9ac87b7be 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -903,7 +903,7 @@ int resctrl_arch_measure_cycles_lat_fn(void *_plr)
 	 * Disable hardware prefetchers.
 	 */
 	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
-	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
+	wrmsrl(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 	mem_r = READ_ONCE(plr->kmem);
 	/*
 	 * Dummy execute of the time measurement to load the needed
@@ -999,7 +999,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * Disable hardware prefetchers.
 	 */
 	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
-	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
+	wrmsrl(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 
 	/* Initialize rest of local variables */
 	/*
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index c6274d40b217..e5a4c283c924 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1697,7 +1697,7 @@ void resctrl_arch_mon_event_config_write(void *_config_info)
 		pr_warn_once("Invalid event id %d\n", config_info->evtid);
 		return;
 	}
-	wrmsr(MSR_IA32_EVT_CFG_BASE + index, config_info->mon_config, 0);
+	wrmsrl(MSR_IA32_EVT_CFG_BASE + index, config_info->mon_config);
 }
 
 static void mbm_config_write_domain(struct rdt_resource *r,
diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index 2293efd6ffa6..0f5d5d9f3352 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -33,7 +33,7 @@ static DEFINE_MUTEX(umwait_lock);
 static void umwait_update_control_msr(void * unused)
 {
 	lockdep_assert_irqs_disabled();
-	wrmsr(MSR_IA32_UMWAIT_CONTROL, READ_ONCE(umwait_control_cached), 0);
+	wrmsrl(MSR_IA32_UMWAIT_CONTROL, READ_ONCE(umwait_control_cached));
 }
 
 /*
@@ -71,7 +71,7 @@ static int umwait_cpu_offline(unsigned int cpu)
 	 * the original control MSR value in umwait_init(). So there
 	 * is no race condition here.
 	 */
-	wrmsr(MSR_IA32_UMWAIT_CONTROL, orig_umwait_control_cached, 0);
+	wrmsrl(MSR_IA32_UMWAIT_CONTROL, orig_umwait_control_cached);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3be9b3342c67..1b74aa64a1bc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -399,7 +399,7 @@ static void kvm_disable_steal_time(void)
 	if (!has_steal_clock)
 		return;
 
-	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
+	wrmsrl(MSR_KVM_STEAL_TIME, 0);
 }
 
 static u64 kvm_steal_clock(int cpu)
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index d793fc441b46..b0ebd0fe31ed 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -102,16 +102,16 @@ static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		cmdmode = min(mode, pairmode);
 		/* Write the other drive timing register if it changed */
 		if (cmdmode < pairmode)
-			wrmsr(ATAC_CH0D0_PIO + 2 * pair->devno,
-				pio_cmd_timings[cmdmode] << 16 | pio_timings[pairmode], 0);
+			wrmsrl(ATAC_CH0D0_PIO + 2 * pair->devno,
+				pio_cmd_timings[cmdmode] << 16 | pio_timings[pairmode]);
 	}
 	/* Write the drive timing register */
-	wrmsr(ATAC_CH0D0_PIO + 2 * adev->devno,
-		pio_cmd_timings[cmdmode] << 16 | pio_timings[mode], 0);
+	wrmsrl(ATAC_CH0D0_PIO + 2 * adev->devno,
+		pio_cmd_timings[cmdmode] << 16 | pio_timings[mode]);
 
 	/* Set the PIO "format 1" bit in the DMA timing register */
 	rdmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, dummy);
-	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg | 0x80000000UL, 0);
+	wrmsrl(ATAC_CH0D0_DMA + 2 * adev->devno, reg | 0x80000000UL);
 }
 
 /**
@@ -138,7 +138,7 @@ static void cs5535_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		reg |= udma_timings[mode - XFER_UDMA_0];
 	else
 		reg |= mwdma_timings[mode - XFER_MW_DMA_0];
-	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, 0);
+	wrmsrl(ATAC_CH0D0_DMA + 2 * adev->devno, reg);
 }
 
 static const struct scsi_host_template cs5535_sht = {
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index b811efd2cc34..0578f3046b51 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -34,9 +34,9 @@ module_param_named(msr, use_msr, int, 0644);
 MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
 #else
 #undef rdmsr	/* avoid accidental MSR usage on, e.g. x86-64 */
-#undef wrmsr
+#undef wrmsrl
 #define rdmsr(x, y, z) do { } while (0)
-#define wrmsr(x, y, z) do { } while (0)
+#define wrmsrl(x, y) do { } while (0)
 #define use_msr 0
 #endif
 
@@ -98,7 +98,7 @@ static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 static int cs5536_write(struct pci_dev *pdev, int reg, int val)
 {
 	if (unlikely(use_msr)) {
-		wrmsr(MSR_IDE_CFG + reg, val, 0);
+		wrmsrl(MSR_IDE_CFG + reg, val);
 		return 0;
 	}
 
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 924314cdeebc..937c07f0839f 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -271,7 +271,7 @@ static u32 cpu_freq_read_amd(struct acpi_pct_register *not_used)
 
 static void cpu_freq_write_amd(struct acpi_pct_register *not_used, u32 val)
 {
-	wrmsr(MSR_AMD_PERF_CTL, val, 0);
+	wrmsrl(MSR_AMD_PERF_CTL, val);
 }
 
 static u32 cpu_freq_read_io(struct acpi_pct_register *reg)
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index d23a97ba6478..08bf293eb4bb 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -123,7 +123,7 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 		}
 	}
 	/* Set new multiplier and voltage */
-	wrmsr(MSR_IA32_PERF_CTL, dest_state & 0xffff, 0);
+	wrmsrl(MSR_IA32_PERF_CTL, dest_state & 0xffff);
 	/* Wait until transition end */
 	i = 0;
 	do {
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 99d2244e03b0..d22a0b981797 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -88,10 +88,10 @@ static int powernow_k6_get_cpu_multiplier(void)
 	local_irq_disable();
 
 	msrval = POWERNOW_IOPORT + 0x1;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
+	wrmsrl(MSR_K6_EPMR, msrval); /* enable the PowerNow port */
 	invalue = inl(POWERNOW_IOPORT + 0x8);
 	msrval = POWERNOW_IOPORT + 0x0;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
+	wrmsrl(MSR_K6_EPMR, msrval); /* disable it again */
 
 	local_irq_enable();
 
@@ -118,13 +118,13 @@ static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
 	outvalue = (1<<12) | (1<<10) | (1<<9) | (index_to_register[best_i]<<5);
 
 	msrval = POWERNOW_IOPORT + 0x1;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
+	wrmsrl(MSR_K6_EPMR, msrval); /* enable the PowerNow port */
 	invalue = inl(POWERNOW_IOPORT + 0x8);
 	invalue = invalue & 0x1f;
 	outvalue = outvalue | invalue;
 	outl(outvalue, (POWERNOW_IOPORT + 0x8));
 	msrval = POWERNOW_IOPORT + 0x0;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
+	wrmsrl(MSR_K6_EPMR, msrval); /* disable it again */
 
 	write_cr0(cr0);
 	local_irq_enable();
-- 
2.49.0


