Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3D587C2A
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiHBMRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiHBMRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:17:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F81A37FB9;
        Tue,  2 Aug 2022 05:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D562CE1F99;
        Tue,  2 Aug 2022 12:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08593C433D7;
        Tue,  2 Aug 2022 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659442650;
        bh=aoB8YWzdBDmGKGBxKm6c1o5Otej58zAzHjLmdSPKrwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GpynhOW9nS7iP76+1DnmpYAuigIA0PrRY55U09E1CUsKnXTbdaZNKw55/9b/zKVa/
         /4HcXLYq9eegAhmXLFUvy4U+NMKB51rmkr9UKRm31CP0EVoN4AzJjTyGO8Cw5mCx+n
         jzVgyDNW1JNBrn3+E0t18jrgl3Rix8N1N3cLpC3Q5tijlxDz55cUS7UREEc65UJlVe
         aErZKnXlaSEdbLboiePPsoFgttSY3YPAGw45XeO63a3pbvEMC2EoYxohw7s0JJtsAe
         RDvO0XoyAT/0b5oNZOoe7CE8pOPPzMxUA4PdbNi7WARpJJvWFdCfwMplC3z9TBODZ+
         /x1jj4AxfNPVg==
Date:   Tue, 2 Aug 2022 15:17:27 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
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
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <YukV1/FAZS0iXr5V@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6ruxMazN3NmWHsemDNQj6Uj0PhCVeaxw2unCxU=YZFRWw@mail.gmail.com>
 <SN6PR12MB276722570164ECD120BA4D628EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB276722570164ECD120BA4D628EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 08:17:15PM +0000, Kalra, Ashish wrote:
> [Public]
> 
> Hello Peter,
> 
> >> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, 
> >> +bool locked) {
> >> +       struct sev_data_snp_page_reclaim data;
> >> +       int ret, err, i, n = 0;
> >> +
> >> +       for (i = 0; i < npages; i++) {
> 
> >What about setting |n| here too, also the other increments.
> 
> >for (i = 0, n = 0; i < npages; i++, n++, pfn++)
> 
> Yes that is simpler.
> 
> >> +               memset(&data, 0, sizeof(data));
> >> +               data.paddr = pfn << PAGE_SHIFT;
> >> +
> >> +               if (locked)
> >> +                       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> >> +               else
> >> +                       ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, 
> >> + &data, &err);
> 
> > Can we change `sev_cmd_mutex` to some sort of nesting lock type? That could clean up this if (locked) code.
> 
> > +static inline int rmp_make_firmware(unsigned long pfn, int level) {
> > +       return rmp_make_private(pfn, 0, level, 0, true); }
> > +
> > +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> > +                            bool need_reclaim)
> 
> >This function can do a lot and when I read the call sites its hard to see what its doing since we have a combination of arguments which tell us what behavior is happening, some of which are not valid (ex: to_fw == true and need_reclaim == true is an >invalid argument combination).
> 
> to_fw is used to make a firmware page and need_reclaim is for freeing the firmware page, so they are going to be mutually exclusive. 
> 
> I actually can connect with it quite logically with the callers :
> snp_alloc_firmware_pages will call with to_fw = true and need_reclaim = false
> and snp_free_firmware_pages will do the opposite, to_fw = false and need_reclaim = true.
> 
> That seems straightforward to look at.
> 
> >Also this for loop over |npages| is duplicated from snp_reclaim_pages(). One improvement here is that on the current
> >snp_reclaim_pages() if we fail to reclaim a page we assume we cannot reclaim the next pages, this may cause us to snp_leak_pages() more pages than we actually need too.
> 
> Yes that is true.
> 
> >What about something like this?
> 
> >static snp_leak_page(u64 pfn, enum pg_level level) {
> >   memory_failure(pfn, 0);
> >   dump_rmpentry(pfn);
> >}
> 
> >static int snp_reclaim_page(u64 pfn, enum pg_level level) {
> >  int ret;
> >  struct sev_data_snp_page_reclaim data;
> 
> >  ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> >  if (ret)
> >    goto cleanup;
> 
> >  ret = rmp_make_shared(pfn, level);
> >  if (ret)
> >    goto cleanup;
> 
> > return 0;
> 
> >cleanup:
> >    snp_leak_page(pfn, level)
> >}
> 
> >typedef int (*rmp_state_change_func) (u64 pfn, enum pg_level level);
> 
> >static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, rmp_state_change_func state_change, rmp_state_change_func cleanup) {
> >  struct sev_data_snp_page_reclaim data;
> >  int ret, err, i, n = 0;
> 
> >  for (i = 0, n = 0; i < npages; i++, n++, pfn++) {
> >    ret = state_change(pfn, PG_LEVEL_4K)
> >    if (ret)
> >      goto cleanup;
> >  }
> 
> >  return 0;
> 
> > cleanup:
> >  for (; i>= 0; i--, n--, pfn--) {
> >    cleanup(pfn, PG_LEVEL_4K);
> >  }
> 
> >  return ret;
> >}
> 
> >Then inside of __snp_alloc_firmware_pages():
> 
> >snp_set_rmp_state(paddr, npages, rmp_make_firmware, snp_reclaim_page);
> 
> >And inside of __snp_free_firmware_pages():
> 
> >snp_set_rmp_state(paddr, npages, snp_reclaim_page, snp_leak_page);
> 
> >Just a suggestion feel free to ignore. The readability comment could be addressed much less invasively by just making separate functions for each valid combination of arguments here. Like snp_set_rmp_fw_state(), snp_set_rmp_shared_state(),
> >snp_set_rmp_release_state() or something.
> 
> >> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int 
> >> +order, bool locked) {
> >> +       unsigned long npages = 1ul << order, paddr;
> >> +       struct sev_device *sev;
> >> +       struct page *page;
> >> +
> >> +       if (!psp_master || !psp_master->sev_data)
> >> +               return NULL;
> >> +
> >> +       page = alloc_pages(gfp_mask, order);
> >> +       if (!page)
> >> +               return NULL;
> >> +
> >> +       /* If SEV-SNP is initialized then add the page in RMP table. */
> >> +       sev = psp_master->sev_data;
> >> +       if (!sev->snp_inited)
> >> +               return page;
> >> +
> >> +       paddr = __pa((unsigned long)page_address(page));
> >> +       if (snp_set_rmp_state(paddr, npages, true, locked, false))
> >> +               return NULL;
> 
> >So what about the case where snp_set_rmp_state() fails but we were able to reclaim all the pages? Should we be able to signal that to callers so that we could free |page| here? But given this is an error path already maybe we can optimize this in a >follow up series.
> 
> Yes, we should actually tie in to snp_reclaim_pages() success or failure here in the case we were able to successfully unroll some or all of the firmware state change.
> 
> > +
> > +       return page;
> > +}
> > +
> > +void *snp_alloc_firmware_page(gfp_t gfp_mask) {
> > +       struct page *page;
> > +
> > +       page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> > +
> > +       return page ? page_address(page) : NULL; } 
> > +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> > +
> > +static void __snp_free_firmware_pages(struct page *page, int order, 
> > +bool locked) {
> > +       unsigned long paddr, npages = 1ul << order;
> > +
> > +       if (!page)
> > +               return;
> > +
> > +       paddr = __pa((unsigned long)page_address(page));
> > +       if (snp_set_rmp_state(paddr, npages, false, locked, true))
> > +               return;
> 
> > Here we may be able to free some of |page| depending how where inside of snp_set_rmp_state() we failed. But again given this is an error path already maybe we can optimize this in a follow up series.
> 
> Yes, we probably should be able to free some of the page(s) depending on how many page(s) got reclaimed in snp_set_rmp_state().
> But these reclamation failures may not be very common, so any failure is indicative of a bigger issue, it might be the case when there is a single page reclamation error it might happen with all the subsequent
> pages and so follow a simple recovery procedure, then handling a more complex recovery for a chunk of pages being reclaimed and another chunk not. 

Silent ignore is stil a bad idea. I.e. at minimum would
make sense to print a warning to klog.

> 
> Thanks,
> Ashish

BR, Jarkko
