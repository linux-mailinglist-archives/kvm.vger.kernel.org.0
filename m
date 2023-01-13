Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3A66964C
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 13:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjAMMCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 07:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240754AbjAMMBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 07:01:18 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1DE81C17;
        Fri, 13 Jan 2023 03:53:31 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j17so32809724lfr.3;
        Fri, 13 Jan 2023 03:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtiX1MPUU3xjYgjAsMNGq42sTYnq8xHpYo9BJSHp4k8=;
        b=BX8CXrpBFJvzDERUTJuMVIxkEEHm2IM7WNVlL4ObxG9A51Z/ZnnAn1vfZ+LgCoTwp/
         K5bYSOB8n13iuBuH8jKOTK05543pTPIDpuBagbIG0LTHmt7d1UL7sS8/GrWdvVKwylq7
         WQPIcss+aRg2tSaS7+cXBLGZZnD7X/v1ls8csZCOUheQI3mXqFDn5+GF+WPIYUOL+6DQ
         Hl41F3jsGyHTEcLDriSFvwxOVnO21Ae5Kz5/ryR0hTjMBX8QlgpIxKiREEQyUOZp9ibc
         T1l7mUK5r3VrnbMpKNaR8b2evEqDyR+jmkmMFjYt/HxK6fTnBYJnxNtRgPKQnrm5Hkic
         Z2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AtiX1MPUU3xjYgjAsMNGq42sTYnq8xHpYo9BJSHp4k8=;
        b=zyx8LRWDlMOz/Srj2yiORPS6WC2GYmo+gX3k+vLjWpfMhE6Z0R9GeVXv8YQMgTQdP3
         G8g5X9x4YYLNsidViOKmrTCSrN905lyJ6xikiFjgX9krsckACFNhJRLVP/J2AbUIkXb1
         hykbq3PvSe5rQBFvLJcBaO3435wPxKwzqsLQeOE3iApIndHHGeY/0pSJ2alJWxHRvhWE
         Ngjr6k4o2bhBSXfdCquN3D0q0hl0+kRksAxgooCbE0gMUUkrsrmkmxft7znik8vegItd
         lFQXvS+GNzyLmxTcnXRPZyNVDlDBXgIuDynkTbySIl3gZPGgZZXl+b2DQnBBDTtR5k1h
         aeog==
X-Gm-Message-State: AFqh2kqWXGcJw8o4PpmCDmcAf2JwOdVRgmX8TOGTxSqTrY6Ptfn0sEwp
        cFhqcWitz1dJgV0twj1F5hdpaEZ69KE=
X-Google-Smtp-Source: AMrXdXsZ1F9bblhuirHvy2W4VcZSVy9Pi3dctnf9JSubfOsxDIYGFPCqtMWNp89X1kue2ejLWQR/nw==
X-Received: by 2002:a05:6512:25a1:b0:4d0:e044:f865 with SMTP id bf33-20020a05651225a100b004d0e044f865mr126707lfb.6.1673610809788;
        Fri, 13 Jan 2023 03:53:29 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id w29-20020a0565120b1d00b004b6e9530900sm3771085lfu.110.2023.01.13.03.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 03:53:29 -0800 (PST)
Date:   Fri, 13 Jan 2023 13:53:26 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <bp@alien8.de>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>,
        <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
        David Rientjes <rientjes@google.com>, <stable@kernel.org>
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation
 support
Message-ID: <20230113135326.00006f06@gmail.com>
In-Reply-To: <20230112084139.12615-1-nikunj@amd.com>
References: <20230112084139.12615-1-nikunj@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 14:11:39 +0530
Nikunj A Dadhania <nikunj@amd.com> wrote:

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
> [2] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 

The link of [2] is broken. Better update it.

> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: David Rientjes <rientjes@google.com>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> ---
> 
> Changes:
> v4:
> * Update comments and indentation
> * Reuse GHCB MSR Protocol reason set
> * Invalidate ghcb page before using
> * GHCB protocol NAE termination event is available after version 2,
>   verify ghcb version before using the termination event.
> 
> v3:
> * Use GHCB protocol NAE termination event SEV-SNP feature(s)
>   not supported along with SW_EXITINFO2 containing mask of the
>   unsupported features. Need handling of this event on the HV.
> * Add the SNP features check initialize_identity_maps() when the
>   boot GHCB page can be initialized and used.
> * Fixed sphinx warnings in documentation
> 
> v2:
> * Updated Documentation/x86/amd-memory-encryption.rst
> * Address review feedback from Boris/Tom
> 
> v1:
> * Dropped _ENABLED from the feature bits
> * Use approprate macro/function names and move closer to the function
> where it is used.
> * More details added to the commit message and comments
> * Fixed compilation issue
> ---
>  Documentation/x86/amd-memory-encryption.rst | 36 ++++++++++++
>  arch/x86/boot/compressed/head_64.S          |  9 +++
>  arch/x86/boot/compressed/misc.h             |  1 +
>  arch/x86/boot/compressed/sev.c              | 62 +++++++++++++++++++++
>  arch/x86/include/asm/msr-index.h            | 20 +++++++
>  arch/x86/include/uapi/asm/svm.h             |  6 ++
>  arch/x86/kernel/sev-shared.c                |  5 ++
>  7 files changed, 139 insertions(+)
> 
> diff --git a/Documentation/x86/amd-memory-encryption.rst
> b/Documentation/x86/amd-memory-encryption.rst index
> a1940ebe7be5..b3adc39d7735 100644 ---
> a/Documentation/x86/amd-memory-encryption.rst +++
> b/Documentation/x86/amd-memory-encryption.rst @@ -95,3 +95,39 @@ by
> supplying mem_encrypt=on on the kernel command line.  However, if BIOS
> does not enable SME, then Linux will not be able to activate memory
> encryption, even if configured to do so by default or the mem_encrypt=on
> command line parameter is specified. +
> +Secure Nested Paging (SNP)
> +==========================
> +
> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be
> enabled +by the hypervisor for security enhancements. Some of these
> features need +guest side implementation to function correctly. The
> below table lists the +expected guest behavior with various possible
> scenarios of guest/hypervisor +SNP feature support.
> +
"guest needs implementation" seems a little bit confusing. I suppose it 
means the feature is mandatory for the guest. If so, on the second row 
guest can boot without it. Some explanation? 
> ++-----------------+---------------+---------------+------------------+
> +| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
> +| by the HV       | implementation| implementation| behaviour        |
> ++=================+===============+===============+==================+
> +|      No         |      No       |      No       |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      No         |      Yes      |      No       |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      No         |      Yes      |      Yes      |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      No       |      No       | Boot with        |
> +|                 |               |               | feature enabled  |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      Yes      |      No       | Graceful boot    |
> +|                 |               |               | failure          |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      Yes      |      Yes      | Boot with        |
> +|                 |               |               | feature enabled  |
> ++-----------------+---------------+---------------+------------------+
> +
> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> +
> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf

Probably update the link here as well.

> diff --git a/arch/x86/boot/compressed/head_64.S
> b/arch/x86/boot/compressed/head_64.S index a75712991df3..551d583fac9c
> 100644 --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -557,6 +557,15 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>  	/* Pass boot_params to initialize_identity_maps() */
>  	movq	(%rsp), %rdi
>  	call	initialize_identity_maps
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/*
> +	 * Now that the required page table mappings are established
> and a
> +	 * GHCB can be used, check for SNP guest/HV feature
> compatibility.
> +	 */
> +	call	snp_check_features
> +#endif
> +
>  	popq	%rsi
>  
>  /*
> diff --git a/arch/x86/boot/compressed/misc.h
> b/arch/x86/boot/compressed/misc.h index 62208ec04ca4..593415e22614 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -126,6 +126,7 @@ static inline void console_init(void)
>  
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  void sev_enable(struct boot_params *bp);
> +void snp_check_features(void);
>  void sev_es_shutdown_ghcb(void);
>  extern bool sev_es_check_ghcb_fault(unsigned long address);
>  void snp_set_page_private(unsigned long paddr);
> diff --git a/arch/x86/boot/compressed/sev.c
> b/arch/x86/boot/compressed/sev.c index c93930d5ccbd..40c5f8bc733d 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,68 @@ static void enforce_vmpl0(void)
>  		sev_es_terminate(SEV_TERM_SET_LINUX,
> GHCB_TERM_NOT_VMPL0); }
>  
> +/*
> + * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
> + * guest side implementation for proper functioning of the guest. If any
> + * of these features are enabled in the hypervisor but are lacking guest
> + * side implementation, the behavior of the guest will be undefined. The
> + * guest could fail in non-obvious way making it difficult to debug.
> + *
> + * As the behavior of reserved feature bits is unknown to be on the
> + * safe side add them to the required features mask.
> + */
> +#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |
> 		\
> +				 MSR_AMD64_SNP_REFLECT_VC |
> 	\
> +				 MSR_AMD64_SNP_RESTRICTED_INJ |
> 	\
> +				 MSR_AMD64_SNP_ALT_INJ |
> \
> +				 MSR_AMD64_SNP_DEBUG_SWAP |
> 	\
> +				 MSR_AMD64_SNP_VMPL_SSS |
> 	\
> +				 MSR_AMD64_SNP_SECURE_TSC |
> 	\
> +				 MSR_AMD64_SNP_VMGEXIT_PARAM |
> 	\
> +				 MSR_AMD64_SNP_VMSA_REG_PROTECTION
> |	\
> +				 MSR_AMD64_SNP_RESERVED_BIT13 |
> 	\
> +				 MSR_AMD64_SNP_RESERVED_BIT15 |
> 	\
> +				 MSR_AMD64_SNP_RESERVED_MASK)
> + > +/*
> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
> + * by the guest kernel. As and when a new feature is implemented in the
> + * guest kernel, a corresponding bit should be added to the mask.
> + */
> +#define SNP_FEATURES_PRESENT (0)
> +
> +void snp_check_features(void)
> +{
> +	u64 unsupported_features;
> +
> +	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
> +		return;
> +
> +	/*
> +	 * Terminate the boot if hypervisor has enabled any feature
> +	 * lacking guest side implementation.
> +	 */
> +	unsupported_features = sev_status & SNP_FEATURES_IMPL_REQ &
> ~SNP_FEATURES_PRESENT;
> +	if (unsupported_features) {
> +		if (sev_es_get_ghcb_version() < 2 ||
> +		    (!boot_ghcb && !early_setup_ghcb()))
> +			sev_es_terminate(SEV_TERM_SET_GEN,
> GHCB_SNP_UNSUPPORTED); +

===
> +		u64 exit_info_1 =
> SVM_VMGEXIT_TERM_REASON(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED); +
> +		vc_ghcb_invalidate(boot_ghcb);
> +		ghcb_set_sw_exit_code(boot_ghcb,
> SVM_VMGEXIT_TERM_REQUEST);
> +		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
> +		ghcb_set_sw_exit_info_2(boot_ghcb,
> unsupported_features); +
> +		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
> +		VMGEXIT();
> +
> +		while (true)
> +			asm volatile("hlt\n" : : : "memory");
===

This seems another approach to terminate the guest which can bring extra
reason info compared to sev_es_terminate(). It would be better to wrap
the above snippet into a function and call it here.

> +	}
> +}
> +
>  void sev_enable(struct boot_params *bp)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> diff --git a/arch/x86/include/asm/msr-index.h
> b/arch/x86/include/asm/msr-index.h index 37ff47552bcb..d3fe82c5d6b6
> 100644 --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -566,6 +566,26 @@
>  #define MSR_AMD64_SEV_ES_ENABLED
> BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT) #define
> MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT) 
> +/* SNP feature bits enabled by the hypervisor */
> +#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> +#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
> +#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
> +#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
> +#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
> +#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
> +#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
> +#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
> +#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
> +#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
> +#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
> +
> +/* SNP feature bits reserved for future use. */
> +#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
> +#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
> +#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
> +
>  #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>  
>  /* AMD Collaborative Processor Performance Control MSRs */
> diff --git a/arch/x86/include/uapi/asm/svm.h
> b/arch/x86/include/uapi/asm/svm.h index f69c168391aa..a04fe07eb9a8 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -116,6 +116,12 @@
>  #define SVM_VMGEXIT_AP_CREATE			1
>  #define SVM_VMGEXIT_AP_DESTROY			2
>  #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> +	/* SW_EXITINFO1[3:0] */					\
> +	(((((u64)reason_set) &  0xf)) |				\
                               ^
One extra space before 0xf should be removed.

> +	/* SW_EXITINFO1[11:4] */				\
> +	((((u64)reason_code) & 0xff) << 4))
>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
>  /* Exit code reserved for hypervisor/software use */
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 3a5b0c9c4fcc..38ec3386984a 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -158,6 +158,11 @@ static bool sev_es_negotiate_protocol(void)
>  	return true;
>  }
>  
> +static u16 sev_es_get_ghcb_version(void)
> +{
> +	return ghcb_version;
> +}
> +
>  static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
>  {
>  	ghcb->save.sw_exit_code = 0;

