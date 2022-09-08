Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100875B1614
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 09:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiIHH5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiIHH5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 03:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4295A96742;
        Thu,  8 Sep 2022 00:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793E461BB0;
        Thu,  8 Sep 2022 07:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4A3C433D6;
        Thu,  8 Sep 2022 07:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662623866;
        bh=14RGdwf+G17sAtxszOYpeygph7MCRQUU6OID7/uHLEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPrrL/kCuuWnPdI/Y2fRRysK/5YEA9EgtLZ8+whFBuVwMBS4ai28EmGc5qFMLZwlY
         jCabc715nObJb6976nr2r1J/pmu5q5DxoqJZQYxA4TAVxthDV5qGuExz00aAIrHlph
         ciE1tjg1Pc4jdrjJ3w2jf17oRFtOk4fWI4ISa7EA3wyW6Woh443tnUdHZvWelReYNS
         qdsCSzN0Dhn3pjRLB5LrSRtL/EpiC83jxD6oe+05AxtQqbnhfdHOpXqnP3qjJNvKKK
         XQrIXGmmx2TQipDNrEpSMTyFFDoV0vSEsvg+OxXPvJaBuvxhzRZpKaeDDqU+PdTelg
         zh/9kRH44pQEg==
Date:   Thu, 8 Sep 2022 10:57:40 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Marc Orr <marcorr@google.com>, Borislav Petkov <bp@alien8.de>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YxmgdMMiTe8HoWqs@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <YxcgAk7AHWZVnSCJ@kernel.org>
 <CAA03e5FgiLoixmqpKtfNOXM_0P5Y7LQzr3_oQe+2Z=GJ6kw32g@mail.gmail.com>
 <SN6PR12MB2767ABA4CEFE4591F87968AD8E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <Yxdq1yQw9f54aw4+@kernel.org>
 <Yxmd6ItV05ynoFar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yxmd6ItV05ynoFar@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 10:46:51AM +0300, Jarkko Sakkinen wrote:
> On Tue, Sep 06, 2022 at 06:44:23PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 06, 2022 at 02:17:15PM +0000, Kalra, Ashish wrote:
> > > [AMD Official Use Only - General]
> > > 
> > > >> On Tue, Aug 09, 2022 at 06:55:43PM +0200, Borislav Petkov wrote:
> > > >> > On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> > > >> > > +   pfn = pte_pfn(*pte);
> > > >> > > +
> > > >> > > +   /* If its large page then calculte the fault pfn */
> > > >> > > +   if (level > PG_LEVEL_4K) {
> > > >> > > +           unsigned long mask;
> > > >> > > +
> > > >> > > +           mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> > > >> > > +           pfn |= (address >> PAGE_SHIFT) & mask;
> > > >> >
> > > >> > Oh boy, this is unnecessarily complicated. Isn't this
> > > >> >
> > > >> >       pfn |= pud_index(address);
> > > >> >
> > > >> > or
> > > >> >       pfn |= pmd_index(address);
> > > >>
> > > >> I played with this a bit and ended up with
> > > >>
> > > >>         pfn = pte_pfn(*pte) | PFN_DOWN(address & page_level_mask(level 
> > > >> - 1));
> > > >>
> > > >> Unless I got something terribly wrong, this should do the same (see 
> > > >> the attached patch) as the existing calculations.
> > > 
> > > >Actually, I don't think they're the same. I think Jarkko's version is correct. Specifically:
> > > >- For level = PG_LEVEL_2M they're the same.
> > > >- For level = PG_LEVEL_1G:
> > > >The current code calculates a garbage mask:
> > > >mask = pages_per_hpage(level) - pages_per_hpage(level - 1); translates to:
> > > >>> hex(262144 - 512)
> > > >'0x3fe00'
> > > 
> > > No actually this is not a garbage mask, as I explained in earlier responses we need to capture the address bits 
> > > to get to the correct 4K index into the RMP table.
> > > Therefore, for level = PG_LEVEL_1G:
> > > mask = pages_per_hpage(level) - pages_per_hpage(level - 1) => 0x3fe00 (which is the correct mask).
> > > 
> > > >But I believe Jarkko's version calculates the correct mask (below), incorporating all 18 offset bits into the 1G page.
> > > >>> hex(262144 -1)
> > > >'0x3ffff'
> > > 
> > > We can get this simply by doing (page_per_hpage(level)-1), but as I mentioned above this is not what we need.
> > 
> > I think you're correct, so I'll retry:
> > 
> > (address / PAGE_SIZE) & (pages_per_hpage(level) - pages_per_hpage(level - 1)) =
> > 
> > (address / PAGE_SIZE) & ((page_level_size(level) / PAGE_SIZE) - (page_level_size(level - 1) / PAGE_SIZE)) =
> > 
> > [ factor out 1 / PAGE_SIZE ]
> > 
> > (address & (page_level_size(level) - page_level_size(level - 1))) / PAGE_SIZE  =
> > 
> > [ Substitute with PFN_DOWN() ] 
> > 
> > PFN_DOWN(address & (page_level_size(level) - page_level_size(level - 1)))
> > 
> > So you can just:
> > 
> > pfn = pte_pfn(*pte) | PFN_DOWN(address & (page_level_size(level) - page_level_size(level - 1)));
> > 
> > Which is IMHO way better still what it is now because no branching
> > and no ad-hoc helpers (the current is essentially just page_level_size
> > wrapper).
> 
> I created a small test program:
> 
> $ cat test.c
> #include <stdio.h>
> int main(void)
> {
>         unsigned long arr[] = {0x8, 0x1000, 0x200000, 0x40000000, 0x8000000000};
>         int i;
> 
>         for (i = 1; i < sizeof(arr)/sizeof(unsigned long); i++) {
>                 printf("%048b\n", arr[i] - arr[i - 1]);
>                 printf("%048b\n", (arr[i] - 1) ^ (arr[i - 1] - 1));
>         }
> }
> 
> kultaheltta in linux on  host-snp-v7 [?]
> $ gcc -o test test.c
> 
> kultaheltta in linux on  host-snp-v7 [?]
> $ ./test
> 000000000000000000000000000000000000111111111000
> 000000000000000000000000000000000000111111111000
> 000000000000000000000000000111111111000000000000
> 000000000000000000000000000111111111000000000000
> 000000000000000000111111111000000000000000000000
> 000000000000000000111111111000000000000000000000
> 000000000000000011000000000000000000000000000000
> 000000000000000011000000000000000000000000000000
> 
> So the operation could be described as:
> 
>         pfn = PFN_DOWN(address & (~page_level_mask(level) ^ ~page_level_mask(level - 1)));
> 
> Which IMHO already documents itself quite well: index
> with the granularity of PGD by removing bits used for
> PGD's below it.

I mean:

       pfn =  pte_pfn(*pte) | PFN_DOWN(address & (~page_level_mask(level) ^ ~page_level_mask(level - 1)));

Note that PG_LEVEL_4K check is unnecessary as the result
will be zero after PFN_DOWN().

BR, Jarkko
