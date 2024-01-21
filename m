Return-Path: <kvm+bounces-6487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F3C835592
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45AB4B214C4
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0F036B04;
	Sun, 21 Jan 2024 11:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PlL2423n"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BE10785;
	Sun, 21 Jan 2024 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705837797; cv=none; b=rVy+zYxulJesvWirwDs1TH81+w5p5oh3/Lg9LasszWp7j35ldKcOwpeeeRmv44IdsChYY5hLo9xcw/1IvDo34RuhKJDbQiEybCWlysULhUIUO9T8hPI6+nHWeG7I4JBUYgIa19WMJuPnQpNoybrAn6tu6b92g95HVEyRKVDeejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705837797; c=relaxed/simple;
	bh=IX6gX22nuX3ITn82hOSV0I5xTJX8M50BDqDVYqjrdb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5xRrnZANXqNavfVQvLOggudW/OUfuRotO8XZrHvwQqITCITKuCllDgqd6kL8LKqw/6jUer7WSyaBMdtT+/NNAtB/GrGoxB4sBWQ9L+cyu0upThxVudt6mwkD+YVKYiWNrp3osbfkhsCV54i7iJTIwQBbVJD+5m5Pk+kJDmDCMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PlL2423n; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BA4F240E016C;
	Sun, 21 Jan 2024 11:49:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QufI0F2hHmPV; Sun, 21 Jan 2024 11:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705837783; bh=NjXjwG84zDH31kxmFiKAYsCtuTb3t8NMg29SPEaQwJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PlL2423nlQeFrtrBAT6D+YTiXUCjiejwKQmjF6Qt76EveRL7nDm5xV42nzDyPpmsB
	 U2pcNTFIG2xe0ub4ZvTru7rdlcY93m/hbBhlZhJRHqkFp05pSXS0/ZeNLnsE8ZRc31
	 XlHCJ/UlTUCCnYgKhdfFGLrZuQL4nHirdgTuLLP4IgF8oMbzvYhiEctbcenlaBnD+L
	 lDZ3y+Kzgxhhke3qG4kDW0dNHc9G3C0SYUgLleJ0NK0GmpXD4sK77WVflFcjixRuXh
	 inu4MhNGDyGsoa6cEpEfXMS6/wxWlTLxAHs5zDT24B8gBqOIMt9cfxmBAX1Ra/sM5c
	 flj1ELyoGmNx+HzY0XMJbQsik2QiItZS9wKXc1SzfmbL6SHkKAJ5YLQmVNOrDuNHvF
	 BolnUhyQiLdf8Av9StDVO5rCwzzssAP3k6bxiIHvQmvBFzH0QRvLF4Zj3Q/nw+anfS
	 UZGQyn18bC6Bynzp/7Nioxkw5MQeyx6AKNzcvoFL14jcrd8VQ8RV4NtTQTELdz0RVR
	 oBvGw1lsBFNa5PngqP0q5m1DE9+sXjwKl8Na+tvmY9XG42Jjs0ENcP2RoFrkeByMdJ
	 iI/s9uwHiDepyvvP7iSBtCvQATuGtkteWIWprDR7wpNfypyv74C7dTTXoALPlENo4q
	 NeXgzZVABJEBCQVA3nYxk4DQ=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2FEF540E0177;
	Sun, 21 Jan 2024 11:49:07 +0000 (UTC)
Date: Sun, 21 Jan 2024 12:49:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v1 21/26] crypto: ccp: Add panic notifier for SEV/SNP
 firmware shutdown on kdump
Message-ID: <20240121114900.GLZa0ErBHIqvook5zK@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-22-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-22-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:49AM -0600, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add a kdump safe version of sev_firmware_shutdown() registered as a
> crash_kexec_post_notifier, which is invoked during panic/crash to do
> SEV/SNP shutdown. This is required for transitioning all IOMMU pages
> to reclaim/hypervisor state, otherwise re-init of IOMMU pages during
> crashdump kernel boot fails and panics the crashdump kernel. This
> panic notifier runs in atomic context, hence it ensures not to
> acquire any locks/mutexes and polls for PSP command completion
> instead of depending on PSP command completion interrupt.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: remove use of "we" in comments]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Cleanups ontop, see if the below works too. Especially:

* I've zapped the WBINVD before the TMR pages are freed because
__sev_snp_shutdown_locked() will WBINVD anyway.

* The mutex_is_locked() check in snp_shutdown_on_panic() is silly
because the panic notifier runs on one CPU anyway.

Thx.

---

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 435ba9bc4510..27323203e593 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -227,6 +227,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
+void kdump_sev_callback(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -255,6 +256,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
+static inline void kdump_sev_callback(void) {  }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 23ede774d31b..64ae3a1e5c30 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -40,6 +40,7 @@
 #include <asm/intel_pt.h>
 #include <asm/crash.h>
 #include <asm/cmdline.h>
+#include <asm/sev.h>
 
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
@@ -59,12 +60,7 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_emergency_stop_pt();
 
-	/*
-	 * for SNP do wbinvd() on remote CPUs to
-	 * safely do SNP_SHUTDOWN on the local CPU.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		wbinvd();
+	kdump_sev_callback();
 
 	disable_local_APIC();
 }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c67285824e82..dbb2cc6b5666 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2262,3 +2262,13 @@ static int __init snp_init_platform_device(void)
 	return 0;
 }
 device_initcall(snp_init_platform_device);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the the local CPU.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		wbinvd();
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 598878e760bc..c342e5e54e45 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -161,7 +161,6 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
 
 			udelay(10);
 		}
-
 		return -ETIMEDOUT;
 	}
 
@@ -1654,7 +1653,7 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
-static int __sev_snp_shutdown_locked(int *error, bool in_panic)
+static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_shutdown_ex data;
@@ -1673,7 +1672,7 @@ static int __sev_snp_shutdown_locked(int *error, bool in_panic)
 	 * In that case, a wbinvd() is done on remote CPUs via the NMI
 	 * callback, so only a local wbinvd() is needed here.
 	 */
-	if (!in_panic)
+	if (!panic)
 		wbinvd_on_all_cpus();
 	else
 		wbinvd();
@@ -2199,26 +2198,13 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
-static void __sev_firmware_shutdown(struct sev_device *sev, bool in_panic)
+static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 {
 	int error;
 
 	__sev_platform_shutdown_locked(NULL);
 
 	if (sev_es_tmr) {
-		/*
-		 * The TMR area was encrypted, flush it from the cache
-		 *
-		 * If invoked during panic handling, local interrupts are
-		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
-		 * can't be used. In that case, wbinvd() is done on remote CPUs
-		 * via the NMI callback, so a local wbinvd() is sufficient here.
-		 */
-		if (!in_panic)
-			wbinvd_on_all_cpus();
-		else
-			wbinvd();
-
 		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
 					  get_order(sev_es_tmr_size),
 					  true);
@@ -2237,7 +2223,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool in_panic)
 		snp_range_list = NULL;
 	}
 
-	__sev_snp_shutdown_locked(&error, in_panic);
+	__sev_snp_shutdown_locked(&error, panic);
 }
 
 static void sev_firmware_shutdown(struct sev_device *sev)
@@ -2262,26 +2248,18 @@ void sev_dev_destroy(struct psp_device *psp)
 	psp_clear_sev_irq_handler(psp);
 }
 
-static int sev_snp_shutdown_on_panic(struct notifier_block *nb,
-				     unsigned long reason, void *arg)
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg)
 {
 	struct sev_device *sev = psp_master->sev_data;
 
-	/*
-	 * Panic callbacks are executed with all other CPUs stopped,
-	 * so don't wait for sev_cmd_mutex to be released since it
-	 * would block here forever.
-	 */
-	if (mutex_is_locked(&sev_cmd_mutex))
-		return NOTIFY_DONE;
-
 	__sev_firmware_shutdown(sev, true);
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block sev_snp_panic_notifier = {
-	.notifier_call = sev_snp_shutdown_on_panic,
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
 };
 
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
@@ -2322,7 +2300,7 @@ void sev_pci_init(void)
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	atomic_notifier_chain_register(&panic_notifier_list,
-				       &sev_snp_panic_notifier);
+				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2339,5 +2317,5 @@ void sev_pci_exit(void)
 	sev_firmware_shutdown(sev);
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &sev_snp_panic_notifier);
+					 &snp_panic_notifier);
 }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

