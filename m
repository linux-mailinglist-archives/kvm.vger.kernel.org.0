Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F760735C2B
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjFSQ14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 12:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjFSQ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 12:27:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466461A6;
        Mon, 19 Jun 2023 09:27:53 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 411341EC008F;
        Mon, 19 Jun 2023 18:27:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687192071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6e+4J0KSePLpz6FTC4NhR5KUsm5UJTEw2Lw9R3X5YHA=;
        b=AlSKdpxsOZ+nS/CPQc7yj9aY9ErEjrZRdMhJMlo0KWzMCXA8lu4hemnsr6Wk7EMTplJHdz
        BrTTJbeWTiku5J954tWCM/j0/eX5IZ1NIuoRbFFSgP7WkYjyrGFakYVLkbJVCrarHUsxZM
        8IVBvwxFHZaNX4SRuyz59DyFrFL8dTI=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5Q4p30cZ_o3g; Mon, 19 Jun 2023 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687192068; bh=6e+4J0KSePLpz6FTC4NhR5KUsm5UJTEw2Lw9R3X5YHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T6CSex4pxxOUGcnUlWnR/Xo2F33N52ScuPqHkNW2AML76+OE1kyvEBc+bkQgzkv2Z
         abCEhuwSxKm9DahUqUbwWWiHDz03B0y3jWZ7kKfcBHjBurfOCcLSzdw/ErxosX//jT
         a6HCRZRcH0mhHJnXWcw4vo+mEIV4b0MuGHfzWU7ok4kEkrz6vzEIepFN2rYUuRRVic
         9jQ0qHSyPlhjWGps9I3y2nYRoowminmkxMEKEGnK9wOZ1iQ4gOs4oHJqIg+XfAVPQs
         18K3t6C5ezyd5ELZNBjTU1xnbeym37NDckXjBSulQ29B3bZGmKSwyfqbrWPpMjIoGF
         me90GDFrVhvefpvCqhiF7VnHeC6I+eILSCoDXIAETTmckx1L+5TGd8jvp/ErOPykkM
         pZFJhq7lpbKrJBg/69gqJ7Cvfk5hqxsuO3B//fF3eOknNI1u2yFz1WCF6pFXHVCJQp
         Ocr6W3eQLJwDL8rxcUn9rINdGR11Nu9OQYNQWLdo1ZnlNEb5Y3Azw3z02Uio6aOfQE
         SxGsaAcFNM+5159nfIj1gOkUm8M5aPJC75dCUsuHv7g0LqrM9x2dss0CIjPwI4sSOI
         efmolVR3UXyphRlvCUhM7BwZuIewQCqrCKwn3nTW5K0dPSD0E6hWixJTCtyvwEG2CP
         CMwbzzeMPkwPSGtYazpqAVag=
Received: from zn.tnic (p200300Ea971dc5B2329C23fffEa6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c5b2:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B07E340E0034;
        Mon, 19 Jun 2023 16:27:08 +0000 (UTC)
Date:   Mon, 19 Jun 2023 18:27:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230619162703.GRZJCB10+Xg8fn8XLx@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-5-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:12PM -0500, Michael Roth wrote:
> This will be used to determine whether or not an #NPF should be serviced
> using a normal page vs. a guarded/gmem one.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 +++++++
>  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b3bd24f2a390..c26f76641121 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1445,6 +1445,13 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	/*
> +	 * When set, used to determine whether a fault should be treated as
	   ^^^^^^^^

And when not set? Invalid?

I guess so, judging by the code below.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
