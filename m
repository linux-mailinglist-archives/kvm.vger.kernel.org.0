Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9436579556
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 10:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiGSIii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 04:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGSIi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 04:38:26 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7141E22BDA;
        Tue, 19 Jul 2022 01:38:25 -0700 (PDT)
Received: from zn.tnic (p200300ea97297609329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7609:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B99D01EC02AD;
        Tue, 19 Jul 2022 10:38:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658219898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qVMCC53jDfsDETOjkARWAskhQ1CcMUI8NvGtWsmKYHI=;
        b=PmlHZUI4lxShJLTZsEoznLLyjf5YaLiBFEK8h4S9Aif/LfXnDcgEVpN4FmM6Lxqp/ohOYB
        laxHZIMUJXM2IqCEvNZBgnsop4md9/gV1ladEsq0ETS3H4rKmBve+cfawWbbCewgs+DkpW
        Z0sa8anUvVc3/0nEGFuF+6ge3F4OoRA=
Date:   Tue, 19 Jul 2022 10:38:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <YtZtcHYGFLC4i9dn@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
 <YtPeF0r69UbwNTMJ@zn.tnic>
 <SN6PR12MB27674548A8C8ACF5E53C0DB78E8F9@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27674548A8C8ACF5E53C0DB78E8F9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 03:56:25AM +0000, Kalra, Ashish wrote:
> > That section number will change over time - if you want to refer to
> > some section just use its title so that people can at least grep for
> > the relevant text.
>
> This will all go into sev.c, instead of the header file, as this is
> non-architectural and per-processor and the structure won't be exposed
> to the rest of the kernel. The above PPR reference and potentially in
> future an architectural method of reading the RMP table entries will
> be moved into it.

I fail to see how this addresses my comment... All I'm saying is, the
"section 2.1.4.2" number will change so don't quote it in the text but
quote the section *name* instead.

> I believe that with kexec and after issuing the shutdown command,
> the RMP table needs to be fully initialized, so we should be
> re-initializing the RMP table to zero here.

And yet you're doing:

        /*
         * Check if SEV-SNP is already enabled, this can happen if we are coming from
         * kexec boot.
         */
        rdmsrl(MSR_AMD64_SYSCFG, val);
        if (val & MSR_AMD64_SYSCFG_SNP_EN)
                goto skip_enable;		<-------- skip zeroing


So which is it?

> Yes, IOMMU is enforced for SNP to ensure that HV cannot program DMA
> directly into guest private memory. In case of SNP, the IOMMU makes
> sure that the page(s) used for DMA are HV owned.

Yes, now put that in the comment above the

	fs_initcall(snp_rmptable_init);

line.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
