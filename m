Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041AB672C7A
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 00:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjARXV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 18:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjARXV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 18:21:28 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A112445BD1;
        Wed, 18 Jan 2023 15:21:26 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 059F01EC04E2;
        Thu, 19 Jan 2023 00:21:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674084084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sHCQ9JqgrydpDy5w93tkrituRj0Mq8lklnsbarVyv3E=;
        b=rwaa2rPs2cYmtHfvu0lh5Aks2sr8XGbv42GeoaMWHEjpQXIGMtzEvME22LyV95nMju3HWd
        Nj1WPkW9AxnRGN38ENfrwsGYv/F91X2Cc72TvjgTRau7GVoki+m1FMAWD6ofckq+Vt5yD/
        3tuWoidWkcfz9/LJEq0/LEth3ahuJQs=
Date:   Thu, 19 Jan 2023 00:21:19 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, zhi.wang.linux@gmail.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
Subject: Re: [PATCH v7] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y8h+7yb7lq/HCWdB@zn.tnic>
References: <20230118061943.534309-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118061943.534309-1-nikunj@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 11:49:43AM +0530, Nikunj A Dadhania wrote:
> The hypervisor can enable various new features (SEV_FEATURES[1:63])
> and start the SNP guest. Some of these features need guest side
> implementation. If any of these features are enabled without guest
> side implementation, the behavior of the SNP guest will be undefined.
> The SNP guest boot may fail in a non-obvious way making it difficult
> to debug.
> 
> Instead of allowing the guest to continue and have it fail randomly
> later, detect this early and fail gracefully.
> 
> SEV_STATUS MSR indicates features which the hypervisor has enabled.
> While booting, SNP guests should ascertain that all the enabled
> features have guest side implementation. In case any feature is not
> implemented in the guest, the guest terminates booting with GHCB
> protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
> SW_EXITINFO2 with mask of unsupported features that the hypervisor
> can easily report to the user.
> 
> More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR
> 
> [1] https://developer.amd.com/wp-content/resources/56421.pdf
>     4.1.13 Termination Request
> 
> [2] https://www.amd.com/system/files/TechDocs/40332.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: David Rientjes <rientjes@google.com>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Ok, did some massaging. See whether I've fat-fingered something:

---

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Wed, 18 Jan 2023 11:49:43 +0530
Subject: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support

The hypervisor can enable various new features (SEV_FEATURES[1:63]) and start a
SNP guest. Some of these features need guest side implementation. If any of
these features are enabled without it, the behavior of the SNP guest will be
undefined.  It may fail booting in a non-obvious way making it difficult to
debug.

Instead of allowing the guest to continue and have it fail randomly later,
detect this early and fail gracefully.

The SEV_STATUS MSR indicates features which the hypervisor has enabled.  While
booting, SNP guests should ascertain that all the enabled features have guest
side implementation. In case a feature is not implemented in the guest, the
guest terminates booting with GHCB protocol Non-Automatic Exit(NAE) termination
request event, see "SEV-ES Guest-Hypervisor Communication Block Standardization"
document (currently at https://developer.amd.com/wp-content/resources/56421.pdf),
section "Termination Request".

Populate SW_EXITINFO2 with mask of unsupported features that the hypervisor can
easily report to the user.

More details in the AMD64 APM Vol 2, Section "SEV_STATUS MSR".

  [ bp:
    - Massage.
    - Move snp_check_features() call to C code.
    Note: the CC:stable@ aspect here is to be able to protect older, stable
    kernels when running on newer hypervisors. Or not "running" but fail
    reliably and in a well-defined manner instead of randomly. ]

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230118061943.534309-1-nikunj@amd.com
---
 Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++
 arch/x86/boot/compressed/ident_map_64.c     |  6 ++
 arch/x86/boot/compressed/misc.h             |  2 +
 arch/x86/boot/compressed/sev.c              | 70 +++++++++++++++++++++
 arch/x86/include/asm/msr-index.h            | 20 ++++++
 arch/x86/include/uapi/asm/svm.h             |  6 ++
 6 files changed, 140 insertions(+)

diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
index a1940ebe7be5..934310ce7258 100644
--- a/Documentation/x86/amd-memory-encryption.rst
+++ b/Documentation/x86/amd-memory-encryption.rst
@@ -95,3 +95,39 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
 not enable SME, then Linux will not be able to activate memory encryption, even
 if configured to do so by default or the mem_encrypt=on command line parameter
 is specified.
+
+Secure Nested Paging (SNP)
+==========================
+
+SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
+by the hypervisor for security enhancements. Some of these features need
+guest side implementation to function correctly. The below table lists the
+expected guest behavior with various possible scenarios of guest/hypervisor
+SNP feature support.
+
++-----------------+---------------+---------------+------------------+
+| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
+| by the HV       | implementation| implementation| behaviour        |
++=================+===============+===============+==================+
+|      No         |      No       |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      No       |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      No         |      Yes      |      Yes      |     Boot         |
+|                 |               |               |                  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      No       |      No       | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      No       | Graceful boot    |
+|                 |               |               | failure          |
++-----------------+---------------+---------------+------------------+
+|      Yes        |      Yes      |      Yes      | Boot with        |
+|                 |               |               | feature enabled  |
++-----------------+---------------+---------------+------------------+
+
+More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
+
+[1] https://www.amd.com/system/files/TechDocs/40332.pdf
diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index d4a314cc50d6..321a5011042d 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -180,6 +180,12 @@ void initialize_identity_maps(void *rmode)
 
 	/* Load the new page-table. */
 	write_cr3(top_level_pgt);
+
+	/*
+	 * Now that the required page table mappings are established and a
+	 * GHCB can be used, check for SNP guest/HV feature compatibility.
+	 */
+	snp_check_features();
 }
 
 static pte_t *split_large_pmd(struct x86_mapping_info *info,
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 62208ec04ca4..20118fb7c53b 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -126,6 +126,7 @@ static inline void console_init(void)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void sev_enable(struct boot_params *bp);
+void snp_check_features(void);
 void sev_es_shutdown_ghcb(void);
 extern bool sev_es_check_ghcb_fault(unsigned long address);
 void snp_set_page_private(unsigned long paddr);
@@ -143,6 +144,7 @@ static inline void sev_enable(struct boot_params *bp)
 	if (bp)
 		bp->cc_blob_address = 0;
 }
+static inline void snp_check_features(void) { }
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..d63ad8f99f83 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -208,6 +208,23 @@ void sev_es_shutdown_ghcb(void)
 		error("Can't unmap GHCB page");
 }
 
+static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
+					     unsigned int reason, u64 exit_info_2)
+{
+	u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(set, reason);
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_TERM_REQUEST);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	while (true)
+		asm volatile("hlt\n" : : : "memory");
+}
+
 bool sev_es_check_ghcb_fault(unsigned long address)
 {
 	/* Check whether the fault was on the GHCB page */
@@ -270,6 +287,59 @@ static void enforce_vmpl0(void)
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
 }
 
+/*
+ * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
+ * guest side implementation for proper functioning of the guest. If any
+ * of these features are enabled in the hypervisor but are lacking guest
+ * side implementation, the behavior of the guest will be undefined. The
+ * guest could fail in non-obvious way making it difficult to debug.
+ *
+ * As the behavior of reserved feature bits is unknown to be on the
+ * safe side add them to the required features mask.
+ */
+#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
+				 MSR_AMD64_SNP_REFLECT_VC |		\
+				 MSR_AMD64_SNP_RESTRICTED_INJ |		\
+				 MSR_AMD64_SNP_ALT_INJ |		\
+				 MSR_AMD64_SNP_DEBUG_SWAP |		\
+				 MSR_AMD64_SNP_VMPL_SSS |		\
+				 MSR_AMD64_SNP_SECURE_TSC |		\
+				 MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
+				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_RESERVED_MASK)
+
+/*
+ * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
+ * by the guest kernel. As and when a new feature is implemented in the
+ * guest kernel, a corresponding bit should be added to the mask.
+ */
+#define SNP_FEATURES_PRESENT (0)
+
+void snp_check_features(void)
+{
+	u64 unsupported;
+
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
+		return;
+
+	/*
+	 * Terminate the boot if hypervisor has enabled any feature lacking
+	 * guest side implementation. Pass on the unsupported features mask through
+	 * EXIT_INFO_2 of the GHCB protocol so that those features can be reported
+	 * as part of the guest boot failure.
+	 */
+	unsupported = sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
+	if (unsupported) {
+		if (ghcb_version < 2 || (!boot_ghcb && !early_setup_ghcb()))
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
+		sev_es_ghcb_terminate(boot_ghcb, SEV_TERM_SET_GEN,
+				      GHCB_SNP_UNSUPPORTED, unsupported);
+	}
+}
+
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index cb3d0f6e6ac2..b78336599247 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -575,6 +575,26 @@
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
 
+/* SNP feature bits enabled by the hypervisor */
+#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
+#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
+#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
+#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
+#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
+#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
+#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
+#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
+#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
+#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
+#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
+#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
+#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
+
+/* SNP feature bits reserved for future use. */
+#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
+#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
+#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
+
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
 /* AMD Collaborative Processor Performance Control MSRs */
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f69c168391aa..80e1df482337 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,12 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
+#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
+#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
+	/* SW_EXITINFO1[3:0] */					\
+	(((((u64)reason_set) & 0xf)) |				\
+	/* SW_EXITINFO1[11:4] */				\
+	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 /* Exit code reserved for hypervisor/software use */
-- 
2.35.1


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
