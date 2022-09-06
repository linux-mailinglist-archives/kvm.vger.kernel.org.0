Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F015E5AE56D
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 12:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbiIFKd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 06:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiIFKd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 06:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DBC491E5;
        Tue,  6 Sep 2022 03:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F93BB81630;
        Tue,  6 Sep 2022 10:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FCCC433D6;
        Tue,  6 Sep 2022 10:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662460433;
        bh=BEJTgw4/cLVo9r6M19N464M5+kcpcrF4AMd4GiRbV/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPswdJgwvV05BMK6oF8t3uLF7VdIDhGrQrsKJJMjF64jMPPiij8laSTbRLgqIiIG0
         8JwHxhZJKbLSseRW+gA8aBCZxVh5+OY4MlS8dBE8++1qDg2Wdd1C/Gba4p4d38KxTb
         AzLYNqwIQNDXYIP+hD0CCHg5zEC9FHK+8mUws+r4hV4YT4aY4Yk9d4VnNY9l9AuVO7
         AI0Ad+uVDitGcCAXjMU+FlC437rP+ds4rKBlXCVjnPP5uRKFxqJBixvnb9PCoOa+sW
         FnVvegFB93d5PF6ldKrHYjfzccHyaL4fTmx8moc5rYWwXg3ugRNp0UYTYGX1p0pS8v
         oaZXCrDylcdzQ==
Date:   Tue, 6 Sep 2022 13:33:49 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YxciDTgONtzwiiYo@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <YxcgAk7AHWZVnSCJ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxcgAk7AHWZVnSCJ@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 01:25:10PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 09, 2022 at 06:55:43PM +0200, Borislav Petkov wrote:
> > On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> > > +	pfn = pte_pfn(*pte);
> > > +
> > > +	/* If its large page then calculte the fault pfn */
> > > +	if (level > PG_LEVEL_4K) {
> > > +		unsigned long mask;
> > > +
> > > +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> > > +		pfn |= (address >> PAGE_SHIFT) & mask;
> > 
> > Oh boy, this is unnecessarily complicated. Isn't this
> > 
> > 	pfn |= pud_index(address);
> > 
> > or
> > 	pfn |= pmd_index(address);
> 
> I played with this a bit and ended up with
> 
>         pfn = pte_pfn(*pte) | PFN_DOWN(address & page_level_mask(level - 1));
> 
> Unless I got something terribly wrong, this should do the
> same (see the attached patch) as the existing calculations.

IMHO a better name for this function would be do_user_rmp_addr_fault() as
it is more consistent with the existing function names.

BR, Jarkko
