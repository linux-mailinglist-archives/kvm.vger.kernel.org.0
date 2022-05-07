Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5251E2A1
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356161AbiEGAMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 20:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiEGAMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 20:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B0712C0;
        Fri,  6 May 2022 17:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A16A5B838E9;
        Sat,  7 May 2022 00:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B2CC385A9;
        Sat,  7 May 2022 00:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651882145;
        bh=4OY1Jefu1fmvLep2ds+yxr6CVewFp8hot+dWnzUVFG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7dSDibsel04jR/SHxPWg1pPi58vZhk+CAelMN3OSjvBhzwEFmKNOELd2kaylFI/0
         RtQhYMw3qzfVS+hgNXR+pGQUVwwj0QLDlgPQyPvj1Eo4khB5EnknS1EbhEooXPaLD7
         BVOL5ldKY362l3P5AnAXuwUOA1Iy222EJPrYBpREAqGZCSPheN2Yu3GnZ3b1ypywIo
         7g4qtxcAxBwMLz8cUV4ssdKjv3hlPiJOMqcR524fz4Qx/F7p+hL1mTR8Vf54ikYnrj
         LwEkuoYmAuYaoi65U9EEmI5SkLW+thforZjVHEOP3uryV2X0/N1S0OG5i5abRN5Og8
         fH1TKuU/4IT7w==
Date:   Fri, 6 May 2022 20:09:01 -0400
From:   Mike Rapoport <rppt@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Message-ID: <YnW4nTub1BYUF15W@kernel.org>
References: <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
 <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
 <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
 <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
 <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
 <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
 <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 05, 2022 at 06:51:20AM -0700, Dan Williams wrote:
> [ add Mike ]
> 
> On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> [..]
> >
> > Hi Dave,
> >
> > Sorry to ping (trying to close this).
> >
> > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > that no one should just use some random backend to run TD.
> 
> The platform will already do this, right? I don't understand why this
> is trying to take proactive action versus documenting the error
> conditions and steps someone needs to take to avoid unconvertible
> memory. There is already the CONFIG_HMEM_REPORTING that describes
> relative performance properties between initiators and targets, it
> seems fitting to also add security properties between initiators and
> targets so someone can enumerate the numa-mempolicy that avoids
> unconvertible memory.
> 
> No, special casing in hotplug code paths needed.
> 
> >
> > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > from memblock anyway (w/o those from memory hotplug).
> >
> > And I also think it makes more sense to introduce 'tdx_memblock' and
> > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > blocks we gathered based on memblock during boot.  This is also more flexible to
> > support other TDX memory from other sources such as CLX memory in the future.
> >
> > Please let me know if you have any objection?  Thanks!
> 
> It's already the case that x86 maintains sideband structures to
> preserve memory after exiting the early memblock code. Mike, correct
> me if I am wrong, but adding more is less desirable than just keeping
> the memblock around?

TBH, I didn't read the entire thread yet, but at the first glance, keeping
memblock around is much more preferable that adding yet another { .start,
.end, .flags } data structure. To keep memblock after boot all is needed is
something like

	select ARCH_KEEP_MEMBLOCK if INTEL_TDX_HOST

I'll take a closer look next week on the entire series, maybe I'm missing
some details.

-- 
Sincerely yours,
Mike.
