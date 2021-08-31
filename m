Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA913FCEC0
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhHaUqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 16:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241077AbhHaUqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 16:46:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60A2C061760
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 13:45:15 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m26so324369pff.3
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 13:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+llZ11pd43hnvJFo4X2CKlMRkdRmFso1OEbzXFynZI=;
        b=Kc0EAAbqn118B0qHHW5UMPWmgjaHRq+XXR/XWPDy1tCs/qckkDpLhqI27UA17Y2sTO
         dN6oVJ3fjFs+ahh1MrqaSOdHPqUIg9IJfftjyasUX4Nn4IFgecw60UCY6V7CzCpY90al
         llfo5GOTEym5r0xaZtqfJmQqGNWT//E3c2uhEenSEK+MK8608Dc9RR2iT0z7tqL9OYIp
         OMEPz1yBGWPkk53O1oLotcsvPMPLlk1cCO3KAew977UQ19YCk4gkCBB8vxiYfITePooX
         f3gSUbgRZe0RSeoJX8S9auyLDipswgmI2l2gUI8cmkm/bJvbCa7GsxF17ky1tWox0mIE
         VsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+llZ11pd43hnvJFo4X2CKlMRkdRmFso1OEbzXFynZI=;
        b=dvxun5PJsTYHfpl8CrWsbS7ERAVW/+sxiXo4h5mEn5quOtSRKcc87jXGYArQ3sAiU/
         0jXqGP8cYeFk5FhVKpfKVnZMrL7oSxFsWxeXsssrSl1o+Ui+tptraYKNe7lgxVNR33wI
         B6kCyOol5210cKH31Uu7Y2VcYuMoAciBnlyeG/KVEFP+EJ7PlgySafj3Fm7wbQ7GeucK
         MznxWr1zl65MTFLdG7Ob1x1ooxm0ctgr7tLUT/OOXhI4jJrfXwdGZgLTFDGspFmWa5kN
         ft/GkCLXuYmiQhNLe05OZ5h8PpkQdmNA43JbVKl15mTdHDq6qkeoXjlw4XZ3kPTZuDOi
         GXeg==
X-Gm-Message-State: AOAM532IAGTdGCcvo1yTYYuFfnQ2Jr0w9MpxIUZ1jJi6y7PfBYE5FzD8
        iH/6duLG7hbajz5FtN0s+4OiYw==
X-Google-Smtp-Source: ABdhPJxKFiU735GQhGSqTT8sTEH141+rPPmKuXknxEDVqYkZWpoRHMrjd5Tl3gckoxmc3jgAnBmZAA==
X-Received: by 2002:a05:6a00:10cb:b029:3c6:8cc9:5098 with SMTP id d11-20020a056a0010cbb02903c68cc95098mr30667314pfu.41.1630442714947;
        Tue, 31 Aug 2021 13:45:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 141sm22280263pgf.46.2021.08.31.13.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 13:45:14 -0700 (PDT)
Date:   Tue, 31 Aug 2021 20:45:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <YS6U1u/p+nOXVEfS@google.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <40af9d25-c854-8846-fdab-13fe70b3b279@kernel.org>
 <cfe75e39-5927-c02a-b8bc-4de026bb7b3b@redhat.com>
 <73319f3c-6f5e-4f39-a678-7be5fddd55f2@www.fastmail.com>
 <YSlnJpWh8fdpddTA@google.com>
 <949e6d95-266d-0234-3b86-6bd3c5267333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <949e6d95-266d-0234-3b86-6bd3c5267333@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021, David Hildenbrand wrote:
> On 28.08.21 00:28, Sean Christopherson wrote:
> > On Fri, Aug 27, 2021, Andy Lutomirski wrote:
> > > 
> > > On Thu, Aug 26, 2021, at 2:26 PM, David Hildenbrand wrote:
> > > > On 26.08.21 19:05, Andy Lutomirski wrote:
> > > 
> > > > > Oof.  That's quite a requirement.  What's the point of the VMA once all
> > > > > this is done?
> > > > 
> > > > You can keep using things like mbind(), madvise(), ... and the GUP code
> > > > with a special flag might mostly just do what you want. You won't have
> > > > to reinvent too many wheels on the page fault logic side at least.
> > 
> > Ya, Kirill's RFC more or less proved a special GUP flag would indeed Just Work.
> > However, the KVM page fault side of things would require only a handful of small
> > changes to send private memslots down a different path.  Compared to the rest of
> > the enabling, it's quite minor.
> > 
> > The counter to that is other KVM architectures would need to learn how to use the
> > new APIs, though I suspect that there will be a fair bit of arch enabling regardless
> > of what route we take.
> > 
> > > You can keep calling the functions.  The implementations working is a
> > > different story: you can't just unmap (pte_numa-style or otherwise) a private
> > > guest page to quiesce it, move it with memcpy(), and then fault it back in.
> > 
> > Ya, I brought this up in my earlier reply.  Even the initial implementation (without
> > real NUMA support) would likely be painful, e.g. the KVM TDX RFC/PoC adds dedicated
> > logic in KVM to handle the case where NUMA balancing zaps a _pinned_ page and then
> > KVM fault in the same pfn.  It's not thaaat ugly, but it's arguably more invasive
> > to KVM's page fault flows than a new fd-based private memslot scheme.
> 
> I might have a different mindset, but less code churn doesn't necessarily
> translate to "better approach".

I wasn't referring to code churn.  By "invasive" I mean number of touchpoints in
KVM as well as the nature of the touchpoints.  E.g. poking into how KVM uses
available bits in its shadow PTEs and adding multiple checks through KVM's page
fault handler, versus two callbacks to get the PFN and page size.

> I'm certainly not pushing for what I proposed (it's a rough, broken sketch).
> I'm much rather trying to come up with alternatives that try solving the
> same issue, handling the identified requirements.
> 
> I have a gut feeling that the list of requirements might not be complete
> yet. For example, I wonder if we have to protect against user space
> replacing private pages by shared pages or punishing random holes into the
> encrypted memory fd.

Replacing a private page with a shared page for a given GFN is very much a
requirement as it's expected behavior for all VMM+guests when converting guest
memory between shared and private.

Punching holes is a sort of optional requirement.  It's a "requirement" in that
it's allowed if the backing store supports such a behavior, optional in that
support wouldn't be strictly necessary and/or could come with constraints.  The
expected use case is that host userspace would punch a hole to free unreachable
private memory, e.g. after the corresponding GFN(s) is converted to shared, so
that it doesn't consume 2x memory for the guest.
