Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F886599A7
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiL3PUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 10:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiL3PUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 10:20:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1665F140A8;
        Fri, 30 Dec 2022 07:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBEF8B81A94;
        Fri, 30 Dec 2022 15:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DB5C433D2;
        Fri, 30 Dec 2022 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672413613;
        bh=mEIlsiCgiRPca7MIEp0cdGq/tH1/+rGW8cuwJMfMUf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCZxNJ8xqKIPIJ+QzzzJsJR394Fy8eD+SyWyhwuthJnpMbOqI03lzjQlKaZrPnhtS
         Ex1DArvhBsu807BjZBxNYrsfhTEwNm6gPc+An3kcRaLoEkMB6M19c4DMQj+b8KtvoC
         AAs1inzY1AJFjgVryP/yF34N+gMVaJfGmsqP5raUF0AICJPo8GNlmJr72nTldohUta
         0sYmdo5g0HompG0016vu/uyg1CDUgQFGjKM7tgoYjIlbtY4C//M+9klpIcSf8bHC0f
         rZpiXp1bcEAcktV+pJeryrhe6rOAEcE9v748PNKLwKhLMS6tukBOdDyABD1ieJFwnO
         /fvcjwbaC5ogQ==
Date:   Fri, 30 Dec 2022 17:19:49 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Roth <michael.roth@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <Y68BlcnT0vrpcwf5@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic>
 <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6DEv4QuvIfwWlCW@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 09:08:31PM +0100, Borislav Petkov wrote:
> On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
> > We implemented this approach for v7, but it causes a fairly significant
> > performance regression, particularly for the case for npages > 1 which
> > this change was meant to optimize.
> > 
> > I still need to dig in a big but I'm guessing it's related to flushing
> > behavior.
> 
> Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> 
> Don't you need to flush when you modify the direct map?
> 
> > It would however be nice to have a set_direct_map_default_noflush()
> > variant that accepted a 'npages' argument, since it would be more
> > performant here and also would potentially allow for restoring the 2M
> > direct mapping in some cases. Will look into this more for v8.
> 
> set_pages_direct_map_default_noflush()
>
> I guess.
> 
> Although the name is a mouthful so I wouldn't mind having those
> shortened.

I had a patch that just adds numpages parameter:

https://lore.kernel.org/lkml/20201123095432.5860-4-rppt@kernel.org/

The set_direct_map*() are not too widely used, so it's not a big deal to
update all callers.
 
> In any case, as long as that helper is properly defined and documented,
> I don't mind.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

-- 
Sincerely yours,
Mike.
