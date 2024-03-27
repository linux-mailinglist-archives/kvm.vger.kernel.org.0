Return-Path: <kvm+bounces-12881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C86E088E9B0
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE971F33D1C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0731134419;
	Wed, 27 Mar 2024 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="U2FxG29B"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2FD131730;
	Wed, 27 Mar 2024 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554272; cv=none; b=iKS0zm/kB9/VekjfkWtrNVS4bFDjGmVjjR88KML9lW5HY7XrqY/rZf7Z/bjNe8b46J1fcuHPocR11mUGJ4PRO/ZbXa2i000Qrh7mtZhTCo8h4NVc4JPY4UhOHwm7hbLue90V9otK9iuG0jaDdADyxWDtETxapnYcUZwe4OTTH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554272; c=relaxed/simple;
	bh=Wx0ozuSqCZdhKVcTLTPlAfKFUjCzYb/1CBAldxIQAtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt/aUtN87dhpN1yamQ0RHqfL9k7hxlh6u36KkqrOcbdbQWh1o0NO/MMvY3NUQ83L/Zh1JSNVpHv3ik/bQNTvYElCEosgB7GkJMY+0EHtnsKK+miZXP0JtURImfPf+RKp0nSEROUvUaGrAYwX2HLgtvnhIJSPenZFlG2zIjz/Fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=U2FxG29B reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 42CD940E00B2;
	Wed, 27 Mar 2024 15:44:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id omt3RGbrf7jW; Wed, 27 Mar 2024 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554257; bh=+dUCHK6EmPQVx3RpLkLvAlHJ4HZZHk3L6k/wPzC3lHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2FxG29B0c/3uTEneZkK9xvQMo+dYLHTLzVpjEs2/ZYgFDHb/GaKHOjR3KzfMV27B
	 doKKMlm+zjRm6+IbHlCmxU6bP8MCYGi5LysLnwl2Atz4FtVN5GLgT4nbpM2syavueH
	 kd6+ad7pvuxKEITLYhPHhD1xcok2BAnNDIYCKBxT8ixtMFuErkwsTQFVstAgWpYjFJ
	 02iKk46RRvPJsqanI9gBcuiV5f1tAfbzKDv0VG4jGtMEdyMkSYcQXqYaODPQk8gX6D
	 cRzIO1aZ3bPu0xMW0iDRIAHVbMw/I9LxQiYD3Bpe+Kos5NIXagQZa97C8ESrMAmucv
	 05IEHJN8AYu6ltZ7ZWey8Qm+KC7xPYNg/ZYXzBba+n55GmpBxHYJM4quhsE39uIDtA
	 /YEB4+Bd+0or7ZEgXEl7cpckjoKUQVnFv6UGbON/G/IXsmIT1RYW7vcuiDrv4v08Ow
	 MrqstGL7R6zGhe/p2Vb1OVG6F+VzA/qIigybooDr0Dd97LD6cxrJlzSLvXJud+pRiO
	 SeIU0xvZz/461oGeiYajJmi+gFwHzJ0uPBcKV+Vsz2S9NujoNE8vj57Lvyt+inThlc
	 vEJj1fFOtoAKeso0/yUvho8fQ9kDscMXsf1oCnB4hWR/rEMpJcu7Wka/2k0zuf+u9i
	 f5trhH80yg01txbiVBGBf8Qs=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AC41540E02A7;
	Wed, 27 Mar 2024 15:44:10 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with cc_platform_*()
Date: Wed, 27 Mar 2024 16:43:17 +0100
Message-ID: <20240327154317.29909-6-bp@alien8.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327154317.29909-1-bp@alien8.de>
References: <20240327154317.29909-1-bp@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The host SNP worthiness can determined later, after alternatives have
been patched, in snp_rmptable_init() depending on cmdline options like
iommu=3Dpt which is incompatible with SNP, for example.

Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
have a special flag for that control.

Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.

Move kdump_sev_callback() to its rightfull place, while at it.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/sev.h         |  4 ++--
 arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
 arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
 arch/x86/kernel/sev.c              | 10 --------
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
 drivers/crypto/ccp/sev-dev.c       |  2 +-
 drivers/iommu/amd/init.c           |  4 +++-
 8 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9477b4053bce..780182cda3ab 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -228,7 +228,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp=
_req_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
-void kdump_sev_callback(void);
 void sev_show_status(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
@@ -258,7 +257,6 @@ static inline int snp_issue_guest_request(u64 exit_co=
de, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end)=
 { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
-static inline void kdump_sev_callback(void) { }
 static inline void sev_show_status(void) { }
 #endif
=20
@@ -270,6 +268,7 @@ int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bo=
ol immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
+void kdump_sev_callback(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *leve=
l) { return -ENODEV; }
@@ -282,6 +281,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, =
enum pg_level level, u32 as
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return=
 -ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void kdump_sev_callback(void) { }
 #endif
=20
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6d8677e80ddb..9bf17c9c29da 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -345,6 +345,28 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
=20
+static void bsp_determine_snp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+	cc_vendor =3D CC_VENDOR_AMD;
+
+	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
+		/*
+		 * RMP table entry format is not architectural and is defined by the
+		 * per-processor PPR. Restrict SNP support on the known CPU models
+		 * for which the RMP table entry format is currently defined for.
+		 */
+		if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
+		    c->x86 >=3D 0x19 && snp_probe_rmptable_info()) {
+			cc_platform_set(CC_ATTR_HOST_SEV_SNP);
+		} else {
+			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+			cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+		}
+	}
+#endif
+}
+
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
@@ -452,21 +474,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		break;
 	}
=20
-	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
-		/*
-		 * RMP table entry format is not architectural and it can vary by proc=
essor
-		 * and is defined by the per-processor PPR. Restrict SNP support on th=
e
-		 * known CPU model and family for which the RMP table entry format is
-		 * currently defined for.
-		 */
-		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
-		    !boot_cpu_has(X86_FEATURE_ZEN5))
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-		else if (!snp_probe_rmptable_info())
-			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
-	}
-
+	bsp_determine_snp(c);
 	return;
=20
 warn:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtr=
r/generic.c
index 422a4ddc2ab7..7b29ebda024f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -108,7 +108,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >=3D 0x0f)))
 		return;
=20
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
=20
 	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b59b09c2f284..1e1a3c3bd1e8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2287,16 +2287,6 @@ static int __init snp_init_platform_device(void)
 }
 device_initcall(snp_init_platform_device);
=20
-void kdump_sev_callback(void)
-{
-	/*
-	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
-	 * safely do SNP_SHUTDOWN on the local CPU.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		wbinvd();
-}
-
 void sev_show_status(void)
 {
 	int i;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ae0ac12382b9..3d310b473e05 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3174,7 +3174,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *v=
cpu)
 	unsigned long pfn;
 	struct page *p;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
=20
 	/*
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cffe1157a90a..ab0e8448bb6e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -77,7 +77,7 @@ static int __mfd_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -98,7 +98,7 @@ static int __snp_enable(unsigned int cpu)
 {
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	rdmsrl(MSR_AMD64_SYSCFG, val);
@@ -174,11 +174,11 @@ static int __init snp_rmptable_init(void)
 	u64 rmptable_size;
 	u64 val;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
=20
 	if (!amd_iommu_snp_en)
-		return 0;
+		goto nosnp;
=20
 	if (!probed_rmp_size)
 		goto nosnp;
@@ -225,7 +225,7 @@ static int __init snp_rmptable_init(void)
 	return 0;
=20
 nosnp:
-	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
+	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 	return -ENOSYS;
 }
=20
@@ -246,7 +246,7 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn=
, int *level)
 {
 	struct rmpentry *large_entry, *entry;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return ERR_PTR(-ENODEV);
=20
 	entry =3D get_rmpentry(pfn);
@@ -363,7 +363,7 @@ int psmash(u64 pfn)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	if (!pfn_valid(pfn))
@@ -472,7 +472,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state=
)
 	unsigned long paddr =3D pfn << PAGE_SHIFT;
 	int ret, level;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	level =3D RMP_TO_PG_LEVEL(state->pagesize);
@@ -558,3 +558,13 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
 EXPORT_SYMBOL_GPL(snp_leak_pages);
+
+void kdump_sev_callback(void)
+{
+	/*
+	 * Do wbinvd() on remote CPUs when SNP is enabled in order to
+	 * safely do SNP_SHUTDOWN on the local CPU.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		wbinvd();
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f44efbb89c34..2102377f727b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1090,7 +1090,7 @@ static int __sev_snp_init_locked(int *error)
 	void *arg =3D &data;
 	int cmd, rc =3D 0;
=20
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
=20
 	sev =3D psp->sev_data;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e7a44929f0da..33228c1c8980 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3228,7 +3228,7 @@ static bool __init detect_ivrs(void)
 static void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 	/*
 	 * The SNP support requires that IOMMU must be enabled, and is
@@ -3236,12 +3236,14 @@ static void iommu_snp_enable(void)
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
 		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP can=
not be supported.\n");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
 	amd_iommu_snp_en =3D check_feature(FEATURE_SNP);
 	if (!amd_iommu_snp_en) {
 		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n=
");
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 		return;
 	}
=20
--=20
2.43.0


