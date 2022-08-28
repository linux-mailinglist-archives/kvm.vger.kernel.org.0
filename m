Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5FA5A3B68
	for <lists+kvm@lfdr.de>; Sun, 28 Aug 2022 06:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiH1ESO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 00:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH1ESN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 00:18:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4643CBE0;
        Sat, 27 Aug 2022 21:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14947B80AB0;
        Sun, 28 Aug 2022 04:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A00DC433D6;
        Sun, 28 Aug 2022 04:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661660289;
        bh=b1DxuemUuHqOzbSQHotO5yGNBJEyQ9fNAcJWznoBnHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmqpvICagbOYzuUK7zRSHuKWYR4Q6wHz8Z9BkMNnSLOBbT3S9p5jf0P52D7k/ZA34
         bP6vV99xNBskD3SnyAx9kgBAXl7RZWs0v8z8zyi4DZ49GSquJa1D52Nop6T5IsWn9b
         50PJkZjDYXCr5OT1/m3MiZSXOT4WN1QSb+9RZEawAlQPjul2E9aPJSWl0qAp/0zVP0
         TLRINEII6KF7d2AcAPgWVRhqFhnirzGoVeJ73gOpnN7pybKLs78LO5I1El23pKyXGq
         jPA+f4DkI4LJcocNVCzvyeTM7yQdnYM+rQTA8bHrXCWMPlN69lDOPDJAvOETpgzis/
         8N8bc3zBd4WMw==
Date:   Sun, 28 Aug 2022 07:18:02 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Message-ID: <YwrseptOq4tFPylD@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
 <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6qorwbAXaPaCaSm0SC9o2uQ9ZQzB6s1kBkvAv2D4tkUug@mail.gmail.com>
 <YwbQKeDRQF0XGWo7@kernel.org>
 <YwbQtaaCkBwezpB+@kernel.org>
 <SN6PR12MB27678E2944605E11B37267CC8E759@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27678E2944605E11B37267CC8E759@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 06:54:16PM +0000, Kalra, Ashish wrote:
> [AMD Official Use Only - General]
> 
> Hello Jarkko,
> 
> >> 
> >> It really should be, in order to have any practical use:
> >> 
> >> 	if (no_iommu) {
> >> 		pr_err("SEV-SNP: IOMMU is disabled.\n");
> >> 		return false;
> >> 	}
> >> 
> >> 	if (iommu_default_passthrough()) {
> >> 		pr_err("SEV-SNP: IOMMU is configured in passthrough mode.\n");
> >> 		return false;
> >> 	}
> >> 
> >> The comment is *completely* redundant, it absolutely does not serve 
> >> any sane purpose. It just tells what the code already clearly stating.
> >> 
> >> The combo error message on the other hand leaves you to the question 
> >> "which one was it", and for that reason combining the checks leaves 
> >> you to a louse debugging experience.
> 
> >Also, are those really *errors*? That implies that there is something wrong.
> 
> >Since you can have a legit configuration, IMHO they should be either warn or info. What do you think?
> 
> >They are definitely not errors
> 
> Yes, they can be warn or info, but as I mentioned above this patch is now part of IOMMU + SNP series,
> so these comments are now relevant for that.

Yeah, warn/info/error is less relevant than the
second point I was making.

It's a good idea to spit out two instead of one
to make best of spitting out anything in the first
place :-) That way you make no mistake interpreting
what does the log message connect to, which can
sometimes make a difference while debugging a
kernel issue.

BR, Jarkko
