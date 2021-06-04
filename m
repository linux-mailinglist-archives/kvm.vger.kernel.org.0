Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658F039BE50
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFDRSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhFDRSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D0F613F9;
        Fri,  4 Jun 2021 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622827010;
        bh=xwMM+2G/mmCpLqX14QgttleAlbZ6mPunUvzw1rIgCFY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bARl4IhZVIFB42SHv69WoBjsmdnDpkVNDrAOuTC72KTseADE8m0I8viIsrFpkJqFH
         eu55Lww2tBSmnjWAwa8ZQ+qj981URrrG6A1NrLW4mIPRtFeDOP2tiIKNTH4WkU4/iR
         6FerihuNYfudlF66fz/QJDI8jezs1roZ1gHPyi69QZFfikyFYIyVGwFnZvnbJSwXrX
         zzpbL6b644Dl7gtMAeFSSL7Xl7Z5dO8Q5YHlM7V/n9El8e+ckckVqELGhB2HX2/KLY
         I8TBeX0VEaq/hy5ZTfnNlP1Bcl2Z9bhaYhTN+5RYdszw2qaWRPvB++gDDksbb8d6X7
         4NYltEWJ7mvcQ==
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com> <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com> <20210521123148.a3t4uh4iezm6ax47@box>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <b367e721-d613-c171-20e7-fe9ea096e411@kernel.org>
Date:   Fri, 4 Jun 2021 10:16:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521123148.a3t4uh4iezm6ax47@box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/21 5:31 AM, Kirill A. Shutemov wrote:
> Hi Sean,
> 
> The core patch of the approach we've discussed before is below. It
> introduce a new page type with the required semantics.
> 
> The full patchset can be found here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-guest-only
> 
> but only the patch below is relevant for TDX. QEMU patch is attached.
> 
> CONFIG_HAVE_KVM_PROTECTED_MEMORY has to be changed to what is appropriate
> for TDX and FOLL_GUEST has to be used in hva_to_pfn_slow() when running
> TDX guest.
> 
> When page get inserted into private sept we must make sure it is
> PageGuest() or SIGBUS otherwise. Inserting PageGuest() into shared is
> fine, but the page will not be accessible from userspace.

I may have missed a detail, and I think Sean almost said this, but:

I don't think that a single bit like this is sufficient.  A KVM host can
contain more than one TDX guest, and, to reliably avoid machine checks,
I think we need to make sure that secure pages are only ever mapped into
the guest to which they belong, as well as to the right GPA.  If a KVM
user host process creates a PageGuest page, what stops it from being
mapped into two different guests?  The refcount?

After contemplating this a bit, I have a somewhat different suggestion,
at least for TDX.  In TDX, a guest logically has two entirely separate
physical address spaces: the secure address space and the shared address
space.  They are managed separately, they have different contents, etc.
Normally one would expect a given numerical address (with the secure
selector bit masked off) to only exist in one of the two spaces, but
nothing in the architecture fundamentally requires this.  And switching
a page between the secure and shared states is a heavyweight operation.

So what if KVM actually treated them completely separately?  The secure
address space doesn't have any of the complex properties that the shared
address space has.  There are no paravirt pages there, no KSM pages
there, no forked pages there, no MAP_ANONYMOUS pages there, no MMIO
pages there, etc.  There could be a KVM API to allocate and deallocate a
secure page, and that would be it.

This could be inefficient if a guest does a bunch of MapGPA calls and
makes the shared address space highly sparse.  That could potentially be
mitigated by allowing a (shared) user memory region to come with a
bitmap of which pages are actually mapped.  Pages in the unmapped areas
are holes, and KVM won't look through to the QEMU page tables.

Does this make any sense?  It would completely eliminate all this
PageGuest stuff -- a secure page would be backed by a *kernel*
allocation (potentially a pageable allocation a la tmpfs if TDX ever
learns how to swap, but that's no currently possible nor would it be
user visible), so the kernel can straightforwardly guarantee that user
pagetables will not contain references to secure pages and that GUP will
not be called on them.

I'm not sure how this would map to SEV.  Certainly, with some degree of
host vs guest cooperation, SEV could work the same way, and the
migration support is pushing SEV in that direction.
