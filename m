Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BC63F5017
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 20:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhHWSHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 14:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhHWSHm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 14:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629742019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YwpCsG2ZbMV2oZWqFVoHV4FWr2+W3wXxfcqVtmyjw0=;
        b=Pne8IjU75RtJ9dTzzVQXsGCryInqSagf5Cd67gBd3eGQQ4hWcz6CdjkZc4bRaWcm2HeUvq
        1MG0iNd6whiSwdtJlfsciFHUoqk0TdqK4oCQKjQ2ewoguPksxtmBzcaLjjXYs4OCTWTyQE
        cKvnKdumRn0YOdNCjq3zSQSFy777GJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-H03xb_XWPxSGYDyVwqnD_A-1; Mon, 23 Aug 2021 14:06:58 -0400
X-MC-Unique: H03xb_XWPxSGYDyVwqnD_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FD521008061;
        Mon, 23 Aug 2021 18:06:56 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC0810016FC;
        Mon, 23 Aug 2021 18:06:52 +0000 (UTC)
Message-ID: <9d982f1a5e3b57780445aadd08fcb5315f72cab9.camel@redhat.com>
Subject: Re: [PATCH v3 0/3] SVM 5-level page table support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Date:   Mon, 23 Aug 2021 21:06:51 +0300
In-Reply-To: <20210823151549.rkkrktvtpu6yapmd@weiserver.amd.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
         <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
         <c10faf24c11fc86074945ca535572a8c5926dcf9.camel@redhat.com>
         <20210823151549.rkkrktvtpu6yapmd@weiserver.amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-23 at 10:15 -0500, Wei Huang wrote:
> On 08/23 12:20, Maxim Levitsky wrote:
> > On Thu, 2021-08-19 at 18:43 +0200, Paolo Bonzini wrote:
> > > On 18/08/21 18:55, Wei Huang wrote:
> > > > This patch set adds 5-level page table support for AMD SVM. When the
> > > > 5-level page table is enabled on host OS, the nested page table for guest
> > > > VMs will use the same format as host OS (i.e. 5-level NPT). These patches
> > > > were tested with various combination of different settings and test cases
> > > > (nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)
> > > > 
> > > > v2->v3:
> > > >   * Change the way of building root_hpa by following the existing flow (Sean)
> > > > 
> > > > v1->v2:
> > > >   * Remove v1's arch-specific get_tdp_level() and add a new parameter,
> > > >     tdp_forced_root_level, to allow forced TDP level (Sean)
> > > >   * Add additional comment on tdp_root table chaining trick and change the
> > > >     PML root table allocation code (Sean)
> > > >   * Revise Patch 1's commit msg (Sean and Jim)
> > > > 
> > > > Thanks,
> > > > -Wei
> > > > 
> > > > Wei Huang (3):
> > > >    KVM: x86: Allow CPU to force vendor-specific TDP level
> > > >    KVM: x86: Handle the case of 5-level shadow page table
> > > >    KVM: SVM: Add 5-level page table support for SVM
> > > > 
> > > >   arch/x86/include/asm/kvm_host.h |  6 ++--
> > > >   arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++-----------
> > > >   arch/x86/kvm/svm/svm.c          | 13 ++++----
> > > >   arch/x86/kvm/vmx/vmx.c          |  3 +-
> > > >   4 files changed, 49 insertions(+), 29 deletions(-)
> > > > 
> > > 
> > > Queued, thanks, with NULL initializations according to Tom's review.
> > > 
> > > Paolo
> > > 
> > 
> > Hi,
> > Yesterday while testing my SMM patches, I noticed a minor issue: 
> > It seems that this patchset breaks my 32 bit nested VM testcase with NPT=0.
> > 
> 
> Could you elaborate the detailed setup? NPT=0 for KVM running on L1?
> Which VM is 32bit - L1 or L2?

NPT=0, L1 and L2 were 32 bit PAE VMs. The test was done to see how well
this setup deals with SMM mode entry/exits with SMM generated by L1 guest,
and see if I have any PDPTR related shenanigans.

I disabled the TDP MMU for now, although in this setup it won't be used anyway.

BIOS was seabios, patched to use PAE itself during bootm, as well in SMM.
(from https://mail.coreboot.org/pipermail/seabios/2015-September/009788.html, patch applied by hand)

Failure was immediate without my hack - L1 died as soon as L2 was started due to an assert in
this code.


Best regards,
	Maxim Levitsky
> 
> Thanks,
> -Wei
> 
> > This hack makes it work again for me (I don't yet use TDP mmu).
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index caa3f9aee7d1..c25e0d40a620 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3562,7 +3562,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
> >             mmu->shadow_root_level < PT64_ROOT_4LEVEL)
> >                 return 0;
> >  
> > -       if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
> > +       if (mmu->pae_root && mmu->pml4_root)
> >                 return 0;
> >  
> >         /*
> > 
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 


