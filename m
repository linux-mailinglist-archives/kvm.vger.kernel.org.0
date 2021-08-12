Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43653EA006
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhHLH7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 03:59:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232348AbhHLH7H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 03:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628755122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tlfrPfiZTqMaUkly1NPeqbR74SfEh3dRA53YXjnlEvY=;
        b=WaGt4CLlG0iX3E6GCG89O6WN04Gr+MRjRvJN5NGQoiirX0k3bPpL5f2mQesEVbhBDERVfa
        1I3t0V1v6czVM6uemB0J8Hx2BmS/cGky0cda/IMZho5/H8Jf3pRZaOgc0tZanpYGA8fpIH
        xuLfA8zmU89RNsf7id0xsMvJ6rW970k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-NIudjmZeOYGWt2NyQF9yUw-1; Thu, 12 Aug 2021 03:58:41 -0400
X-MC-Unique: NIudjmZeOYGWt2NyQF9yUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C738799E0;
        Thu, 12 Aug 2021 07:58:40 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8B9C3AB2;
        Thu, 12 Aug 2021 07:58:38 +0000 (UTC)
Message-ID: <3ad0f6db188c4483cb597036bdaca90a2e9adc74.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits
 tests (new one on the way)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Date:   Thu, 12 Aug 2021 10:58:37 +0300
In-Reply-To: <YNTESd1rtU6RDDP0@google.com>
References: <20210622210047.3691840-1-seanjc@google.com>
         <20210622210047.3691840-6-seanjc@google.com>
         <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
         <YNTESd1rtU6RDDP0@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-06-24 at 17:43 +0000, Sean Christopherson wrote:
> On Thu, Jun 24, 2021, Paolo Bonzini wrote:
> > On 22/06/21 23:00, Sean Christopherson wrote:
> > > Remove two of nSVM's NPT reserved bits test, a soon-to-be-added test will
> > > provide a superset of their functionality, e.g. the current tests are
> > > limited in the sense that they test a single entry and a single bit,
> > > e.g. don't test conditionally-reserved bits.
> > > 
> > > The npt_rsvd test in particular is quite nasty as it subtly relies on
> > > EFER.NX=1; dropping the test will allow cleaning up the EFER.NX weirdness
> > > (it's forced for_all_  tests, presumably to get the desired PFEC.FETCH=1
> > > for this one test).
> > > 
> > > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > > ---
> > >   x86/svm_tests.c | 45 ---------------------------------------------
> > >   1 file changed, 45 deletions(-)
> > 
> > This exposes a KVM bug, reproducible with
> > 
> > 	./x86/run x86/svm.flat -smp 2 -cpu max,+svm -m 4g \
> > 		-append 'npt_rw npt_rw_pfwalk'
> 
> Any chance you're running against an older KVM version?  The test passes if I
> run against a build with my MMU pile on top of kvm/queue, but fails on a random
> older KVM.
> 
> Side topic, these tests all fail to invalidate TLB entries after modifying PTEs.
> I suspect they work in part because KVM flushes and syncs on all nested SVM
> transitions...

I also now tried to reproduce and the test passes.

Best regards,
	Maxim Levitsky

> 
> > While running npt_rw_pfwalk, the #NPF gets an incorrect EXITINFO2
> > (address for the NPF location; on my machine it gets 0xbfede6f0 instead of
> > 0xbfede000).  The same tests work with QEMU from git.
> > 
> > I didn't quite finish analyzing it, but my current theory is
> > that KVM receives a pagewalk NPF for a *different* page walk that is caused
> > by read-only page tables; then it finds that the page walk to 0xbfede6f0
> > *does fail* (after all the correct and wrong EXITINFO2 belong to the same pfn)
> > and therefore injects it anyway.  This theory is because the 0x6f0 offset in
> > the page table corresponds to the 0xde000 part of the faulting address.
> > Maxim will look into it while I'm away.
> > 
> > Paolo
> > 


