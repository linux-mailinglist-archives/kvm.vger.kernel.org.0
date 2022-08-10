Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3870F58E9DB
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiHJJmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 05:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiHJJmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 05:42:15 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC072BF1;
        Wed, 10 Aug 2022 02:42:13 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9870329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9870:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 243361EC0495;
        Wed, 10 Aug 2022 11:42:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660124528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Lg0bjIUF/mk/gAoLNHDftsiQImL/TihLBQ1unQ3ZWpQ=;
        b=AIj2iYxVK4108GPMfeeOPesMiFf/otTqH273QTt3qHw2Qen4RGdW80RP4idJ3ahNdb/3tf
        YgpmBsp1NHmAdSFu5+S+C3ycqyrXzkpWZXzbIGH+8yYmh5e6NTlQKMUiICNKbHL90GCpBi
        dsubLvV6cbhLbXTbgsBLObOWi8NOT0U=
Date:   Wed, 10 Aug 2022 11:42:04 +0200
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
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YvN9bKQ0XtUVJE7z@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 03:59:34AM +0000, Kalra, Ashish wrote:
> Actually SNP feature can be enabled globally, but SNP is activated on a per VM basis.
> 
> From the APM:
> The term SNP-enabled indicates that SEV-SNP is globally enabled in the SYSCFG 
> MSR. The term SNP-active indicates that SEV-SNP is enabled for a specific VM in the 
> SEV_FEATURES field of its VMSA

Aha, and I was wondering whether "globally" meant the RMP needs to cover
all physical memory but I guess that isn't the case:

"RMP-Covered: Checks that the target page is covered by the RMP. A page
is covered by the RMP if its corresponding RMP entry is below RMP_END.
Any page not covered by the RMP is considered a Hypervisor-Owned page."

> >You need to elaborate more here: a RMP fault can happen and then the
> >page can get unmapped? What is the exact scenario here?
>
> Yes, if the page gets unmapped while the RMP fault was being handled,
> will add more explanation here.

So what's the logic here to return 1, i.e., retry?

Why should a fault for a page that gets unmapped be retried? The fault
in that case should be ignored, IMO. It'll have the same effect to
return from do_user_addr_fault() there, without splitting but you need
to have a separate return value definition so that it is clear what
needs to happen. And that return value should be != 0 so that the
current check still works.

> Actually, the above computes an index into the RMP table.

What index in the RMP table?

> It is basically an index into the 4K page within the hugepage mapped
> in the RMP table or in other words an index into the RMP table entry
> for 4K page(s) corresponding to a hugepage.

So pte_index(address) and for 1G pages, pmd_index(address).

So no reinventing the wheel if we already have helpers for that.

> It is mainly a wrapper around__split_huge_pmd() for SNP use case where
> the host hugepage is split to be in sync with the RMP table.

I see what it is. And I'm saying this looks wrong. You're enforcing page
splitting to be a valid thing to do only for SEV machines. Why?

Why is

        if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
                return VM_FAULT_SIGBUS;

there at all?

This is generic code you're touching - not arch/x86/.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
