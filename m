Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE999508740
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378212AbiDTLqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378229AbiDTLqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:46:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A1641FB8;
        Wed, 20 Apr 2022 04:43:33 -0700 (PDT)
Received: from zn.tnic (p200300ea971b58ed329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:58ed:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0CFE1EC0541;
        Wed, 20 Apr 2022 13:43:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650455007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=D02fg5PRJ7T6on5vTY4I4lUZGPcWpgl1scmYIfqq34s=;
        b=jN7vlGyGcEDOULLrwbWTk8dJPYkmAoVDh2Uc4hNxUZdFrjbcLXAEm04BsDEzgV8pG8txDr
        fqmMgtwIPWOlcG8rWE9UGtQma3jR82+tpEnIwQ2CM79Qc1GIcz+C2dqg5qQ3SPCjJLEGNP
        ku5ws9DNJb/cOT4ysofDOx/Iq4lmB7I=
Date:   Wed, 20 Apr 2022 13:43:22 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
Message-ID: <Yl/x2kpQeKylIyPb@zn.tnic>
References: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 03:53:52PM -0500, Babu Moger wrote:
> The TSC_AUX Virtualization feature allows AMD SEV-ES guests to securely use
> TSC_AUX (auxiliary time stamp counter data) MSR in RDTSCP and RDPID
> instructions.
> 
> The TSC_AUX MSR is typically initialized to APIC ID or another unique
> identifier so that software can quickly associate returned TSC value
> with the logical processor.
> 
> Add the feature bit and also include it in the kvm for detection.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> ---
> v2:
> Fixed the text(commented by Boris).
> Added Acked-by from Boris.
> 
> v1:
> https://lore.kernel.org/kvm/164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu/
> 
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  arch/x86/kvm/cpuid.c               |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 73e643ae94b6..1bc66a17a95a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -405,6 +405,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */

I forgot from the last time: nothing is going to use that bit in
userspace so make that

#define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */

please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
