Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9B457C9BC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiGUL3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGUL3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:29:14 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F0129C9D;
        Thu, 21 Jul 2022 04:29:13 -0700 (PDT)
Received: from zn.tnic (p5de8e862.dip0.t-ipconnect.de [93.232.232.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D3DAC1EC0380;
        Thu, 21 Jul 2022 13:29:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658402947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Wd2DXG4EY+gV5zYMOQhIEqcD8PQY00hUt7HCgRibjL8=;
        b=dFXCVt/OHUd/noNwab4aCuTwdHKd3CdavlyVXQUVKSiS1+i6jsnv+RaBor6Eb0ibeEH8Ik
        ZW7eGQZ5aCAV385nZn2vqMYWTQQUDYh0ZpB0Vhc9p+44UKLkVTNN/r9xFHx2rSqY2Qcdbg
        csa52vVIX68AZfpxHkRUlE5KlvGx05g=
Date:   Thu, 21 Jul 2022 13:29:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD
Message-ID: <Ytk4fWCC3feXdAPW@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:02:18PM +0000, Ashish Kalra wrote:
> Subject: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD

That subject title needs to be made human readable.

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> SEV-SNP FW >= 1.51 requires that SYSCFG.MFMD must be set.

Because?

Also, commit message needs to be human-readable and not pseudocode.

> @@ -2325,6 +2346,9 @@ static __init int __snp_rmptable_init(void)
>  	/* Flush the caches to ensure that data is written before SNP is enabled. */
>  	wbinvd_on_all_cpus();
>  
> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +	on_each_cpu(mfdm_enable, NULL, 1);
> +
>  	/* Enable SNP on all CPUs. */
>  	on_each_cpu(snp_enable, NULL, 1);

No, not two IPI generating function calls - one and do everything in it.
I.e., what Marc said.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
