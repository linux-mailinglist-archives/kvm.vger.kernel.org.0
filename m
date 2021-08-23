Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80003F4748
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 11:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhHWJVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 05:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbhHWJVV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 05:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629710438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UtAEqeyBqbSFYigKt8w7VTyGnIid+CLRdUJj46/gmrk=;
        b=J4BlAfaVrvOFQ/8fNnqwSFRXCv/zoB0z5wnm2S/b7zc9f92i8hgrsVnQsHvl9ueJO7dAWT
        aqJwPjC2cABK50jVVqPuCX9+bmgGMWm0U0pUDD90PCL4kygst0Vu25JEVAZ3FHkrXvmNlr
        fBxaBXeGrpp0vm/1MydrBhdBwy1fxKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-gzQuf8cxOGW6neBVWjRpYA-1; Mon, 23 Aug 2021 05:20:37 -0400
X-MC-Unique: gzQuf8cxOGW6neBVWjRpYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 768BA107ACF5;
        Mon, 23 Aug 2021 09:20:35 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 353C860BF1;
        Mon, 23 Aug 2021 09:20:28 +0000 (UTC)
Message-ID: <c10faf24c11fc86074945ca535572a8c5926dcf9.camel@redhat.com>
Subject: Re: [PATCH v3 0/3] SVM 5-level page table support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Date:   Mon, 23 Aug 2021 12:20:27 +0300
In-Reply-To: <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
         <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-08-19 at 18:43 +0200, Paolo Bonzini wrote:
> On 18/08/21 18:55, Wei Huang wrote:
> > This patch set adds 5-level page table support for AMD SVM. When the
> > 5-level page table is enabled on host OS, the nested page table for guest
> > VMs will use the same format as host OS (i.e. 5-level NPT). These patches
> > were tested with various combination of different settings and test cases
> > (nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)
> > 
> > v2->v3:
> >   * Change the way of building root_hpa by following the existing flow (Sean)
> > 
> > v1->v2:
> >   * Remove v1's arch-specific get_tdp_level() and add a new parameter,
> >     tdp_forced_root_level, to allow forced TDP level (Sean)
> >   * Add additional comment on tdp_root table chaining trick and change the
> >     PML root table allocation code (Sean)
> >   * Revise Patch 1's commit msg (Sean and Jim)
> > 
> > Thanks,
> > -Wei
> > 
> > Wei Huang (3):
> >    KVM: x86: Allow CPU to force vendor-specific TDP level
> >    KVM: x86: Handle the case of 5-level shadow page table
> >    KVM: SVM: Add 5-level page table support for SVM
> > 
> >   arch/x86/include/asm/kvm_host.h |  6 ++--
> >   arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++-----------
> >   arch/x86/kvm/svm/svm.c          | 13 ++++----
> >   arch/x86/kvm/vmx/vmx.c          |  3 +-
> >   4 files changed, 49 insertions(+), 29 deletions(-)
> > 
> 
> Queued, thanks, with NULL initializations according to Tom's review.
> 
> Paolo
> 

Hi,
Yesterday while testing my SMM patches, I noticed a minor issue: 
It seems that this patchset breaks my 32 bit nested VM testcase with NPT=0.

This hack makes it work again for me (I don't yet use TDP mmu).

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index caa3f9aee7d1..c25e0d40a620 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3562,7 +3562,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
            mmu->shadow_root_level < PT64_ROOT_4LEVEL)
                return 0;
 
-       if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
+       if (mmu->pae_root && mmu->pml4_root)
                return 0;
 
        /*



Best regards,
	Maxim Levitsky

