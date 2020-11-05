Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD75C2A73EE
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbgKEAoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 19:44:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:4818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgKEAoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 19:44:15 -0500
IronPort-SDR: E/yl1KWu99AJhmuK11okOZwocRJT8m2Bhb9UI/Tm/CMDil39wWMHXtl81WT1ub1zJ2DS+pU2Nt
 2ymNmCUz4wiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="166718789"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="166718789"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 16:44:13 -0800
IronPort-SDR: NLV7HZm3qe0XtnQbHs/tSNUQ882x4e/i7jpzAtBOFKgWnmvwKBC4JtVXZqanF6JvpP2AJvawhy
 /m2ac+xfbPbg==
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="337062680"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 16:44:13 -0800
Date:   Wed, 4 Nov 2020 16:44:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Add macro for hugepage GFN mask
Message-ID: <20201105004412.GA24605@linux.intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
 <80038ae1-d603-dc22-1997-1ad7da0a936d@redhat.com>
 <20201028152948.GA7584@linux.intel.com>
 <e3d68b2b-2af6-04ce-c5f6-47786d9a15bb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3d68b2b-2af6-04ce-c5f6-47786d9a15bb@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 08:08:48AM +0100, Paolo Bonzini wrote:
> On 28/10/20 16:29, Sean Christopherson wrote:
> > The naming and usage also aligns with the kernel, which defines PAGE, PMD and
> > PUD masks, and has near identical usage patterns.
> > 
> >   #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
> >   #define PAGE_MASK               (~(PAGE_SIZE-1))
> > 
> >   #define PMD_PAGE_SIZE           (_AC(1, UL) << PMD_SHIFT)
> >   #define PMD_PAGE_MASK           (~(PMD_PAGE_SIZE-1))
> > 
> >   #define PUD_PAGE_SIZE           (_AC(1, UL) << PUD_SHIFT)
> >   #define PUD_PAGE_MASK           (~(PUD_PAGE_SIZE-1))
> 
> Well, PAGE_MASK is also one of my pet peeves for Linux.  At least I am
> consistent. :)
> 
> >> and of course if you're debugging it you have to
> >> look closer and check if it's really "x & -y" or "x & ~y", but at least
> >> in normal cursory code reading that's how it works for me.
> > 
> > IMO, "x & -y" has a higher barrier to entry, especially when the kernel's page
> > masks uses "x & ~(y - 1))".  But, my opinion is definitely colored by my
> > inability to read two's-complement on the fly.
> 
> Fair enough.  What about having instead
> 
> #define KVM_HPAGE_GFN_BASE(gfn, level)  \
>    (x & ~(KVM_PAGES_PER_HPAGE(gfn) - 1))
> #define KVM_HPAGE_GFN_INDEX(gfn, level)  \
>    (x & (KVM_PAGES_PER_HPAGE(gfn) - 1))
> 
> ?

Hmm, not awful?  What about OFFSET instead of INDEX, to pair with page offset?
I don't particularly love either one, but I can't think of anything better.
