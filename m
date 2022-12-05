Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038F8642A67
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiLEOa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiLEOa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:30:56 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0981312D35;
        Mon,  5 Dec 2022 06:30:54 -0800 (PST)
Received: from zn.tnic (p200300ea9733e72f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e72f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 47DDA1EC0683;
        Mon,  5 Dec 2022 15:30:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670250653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mCvoVmANaqFCfeNL/KIQfm5zobESL7rhCjORLpCoF7Q=;
        b=XrCpcAnIdyvj87eWa7t/R274wQz+6+AQ0UPfwIRkjzo95WYpW1VngA3nNC3WbITVTyGfeK
        sOgycY/F+Yo73lLaCSpQ3jpIY167+MTtQBOnlmseaNLQskJZKbSmAk9PY/DOLHWfv352Ao
        Moe1nktE2y2Zvx49iqgRqC5TXn9eZ7A=
Date:   Mon, 5 Dec 2022 15:30:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y44Amf9MJIIi4Ric@zn.tnic>
References: <20221201100423.7117-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201100423.7117-1-nikunj@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 03:34:23PM +0530, Nikunj A Dadhania wrote:
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
> SEV_STATUS MSR indicates features which hypervisor has enabled. While
> booting, SNP guests should ascertain that all the enabled features
> have guest side implementation. In case any feature is not implemented
> in the guest, the guest terminates booting with SNP feature
> unsupported exit code.
> 
> The below table lists the expected guest behavior with various
> possible scenarios of guest/hypervisor SNP feature support.
> 
> +---------------+---------------+---------------+---------------+
> |Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
> |     by HV     |implementation |implementation |   behavior    |
> +---------------+---------------+---------------+---------------+
> |      No       |      No       |      No       |     Boot      |
> |               |               |               |               |
> +---------------+---------------+---------------+---------------+
> |      No       |      Yes      |      No       |     Boot      |
> |               |               |               |               |
> +---------------+---------------+---------------+---------------+
> |      No       |      Yes      |      Yes      |     Boot      |
> |               |               |               |               |
> +---------------+---------------+---------------+---------------+
> |      Yes      |      No       |      No       |   Boot with   |
> |               |               |               |feature enabled|
> +---------------+---------------+---------------+---------------+
> |      Yes      |      Yes      |      No       | Graceful Boot |
> |               |               |               |    Failure    |
> +---------------+---------------+---------------+---------------+
> |      Yes      |      Yes      |      Yes      |   Boot with   |
> |               |               |               |feature enabled|
> +---------------+---------------+---------------+---------------+

I like this table and I wouldn't want for it to go under in some commit
message which is not that easy to retrieve so I'm thinking you should
add it along with some blurb to

  Documentation/x86/amd-memory-encryption.rst

instead where it belongs.

> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c93930d5ccbd..571eb2576475 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,50 @@ static void enforce_vmpl0(void)
>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>  }
>  
> +/*
> + * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
> + * will need guest side implementation for proper functioning of the guest.
> + * If any of these features are enabled without guest side implementation,

"... are enabled in the hypervisor ... "

> + * the behavior of the guest will be undefined. The guest may fail in
> + * non-obvious way making it difficult to debug.
> + *
> + * SNP reserved feature bits may or may not need guest side implementation.

Yah, get rid of that PPR formulation. If you see the verb "may" always
run away. :-)

> + * As the behavior of reserved feature bits are unknown, to be on the safer
> + * side add them to the NEED_GUEST_IMPLEMENTATION mask.

Yah, that makes sense - you want to protect those for future use. Ack.

> + */
> +#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\

SNP_FEATURES_REQUIRED

Simpler and shorter.

> +						MSR_AMD64_SNP_REFLECT_VC |		\
> +						MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +						MSR_AMD64_SNP_ALT_INJ |			\
> +						MSR_AMD64_SNP_DEBUG_SWAP |		\
> +						MSR_AMD64_SNP_VMPL_SSS |		\
> +						MSR_AMD64_SNP_SECURE_TSC |		\
> +						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +						MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +						MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +						MSR_AMD64_SNP_RESERVED_MASK)
> +
> +/*
> + * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
> + * implemented by the guest kernel. As and when a new feature is implemented
> + * in the guest kernel, a corresponding bit should be added to the mask.

And there's no way we won't notice that we've forgotten to do so because
it'll terminate with the proper error code.

> + */
> +#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)

SNP_FEATURES_PRESENT

And so I've done a couple of changes ontop, here's a diff as it explains
a lot better what I mean.

Have a look and let me know if something's wrong.

Thx.

---
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 10272835dfe9..f023d37e2c41 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -271,48 +271,35 @@ static void enforce_vmpl0(void)
 }
 
 /*
- * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
- * will need guest side implementation for proper functioning of the guest.
- * If any of these features are enabled without guest side implementation,
- * the behavior of the guest will be undefined. The guest may fail in
- * non-obvious way making it difficult to debug.
- *
- * SNP reserved feature bits may or may not need guest side implementation.
- * As the behavior of reserved feature bits are unknown, to be on the safer
- * side add them to the NEED_GUEST_IMPLEMENTATION mask.
- */
-#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
-						MSR_AMD64_SNP_REFLECT_VC |		\
-						MSR_AMD64_SNP_RESTRICTED_INJ |		\
-						MSR_AMD64_SNP_ALT_INJ |			\
-						MSR_AMD64_SNP_DEBUG_SWAP |		\
-						MSR_AMD64_SNP_VMPL_SSS |		\
-						MSR_AMD64_SNP_SECURE_TSC |		\
-						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
-						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
-						MSR_AMD64_SNP_RESERVED_BIT13 |		\
-						MSR_AMD64_SNP_RESERVED_BIT15 |		\
-						MSR_AMD64_SNP_RESERVED_MASK)
 
-/*
- * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
- * implemented by the guest kernel. As and when a new feature is implemented
- * in the guest kernel, a corresponding bit should be added to the mask.
+ * SNP_FEATURES_REQUIRED is the mask of SNP features that will need
+ * guest side implementation for proper functioning of the guest. If any
+ * of these features are enabled in the hypervisor but are lacking guest
+ * side implementation, the behavior of the guest will be undefined. The
+ * guest could fail in non-obvious way making it difficult to debug.
+ *
+ * As the behavior of reserved feature bits is unknown to be on the
+ * safe side add them to the required features mask.
  */
-#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
+#define SNP_FEATURES_REQUIRED		(MSR_AMD64_SNP_VTOM |			\
+					MSR_AMD64_SNP_REFLECT_VC |		\
+					MSR_AMD64_SNP_RESTRICTED_INJ |		\
+					MSR_AMD64_SNP_ALT_INJ |			\
+					MSR_AMD64_SNP_DEBUG_SWAP |		\
+					MSR_AMD64_SNP_VMPL_SSS |		\
+					MSR_AMD64_SNP_SECURE_TSC |		\
+					MSR_AMD64_SNP_VMGEXIT_PARAM |		\
+					MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
+					MSR_AMD64_SNP_RESERVED_BIT13 |		\
+					MSR_AMD64_SNP_RESERVED_BIT15 |		\
+					MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
- * The hypervisor can enable various features flags (in SEV_FEATURES[1:63]) and
- * start the SNP guest. Certain SNP features need guest side implementation.
- * Check if the SNP guest has implementation for those features.
+ * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
+ * by the guest kernel. As and when a new feature is implemented in the
+ * guest kernel, a corresponding bit should be added to the mask.
  */
-static bool snp_guest_has_features_implemented(void)
-{
-	u64 guest_features_not_implemented = SNP_FEATURES_NEED_GUEST_IMPLEMENTATION &
-		~SNP_FEATURES_HAS_GUEST_IMPLEMENTATION;
-
-	return !(sev_status & guest_features_not_implemented);
-}
+#define SNP_FEATURES_PRESENT (0)
 
 void sev_enable(struct boot_params *bp)
 {
@@ -383,7 +370,7 @@ void sev_enable(struct boot_params *bp)
 		 * Terminate the boot if hypervisor has enabled any feature
 		 * missing guest side implementation.
 		 */
-		if (!snp_guest_has_features_implemented())
+		if (sev_status & SNP_FEATURES_REQUIRED & ~SNP_FEATURES_PRESENT)
 			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
 
 		enforce_vmpl0();

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
