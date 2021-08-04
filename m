Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1170B3E0537
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhHDQFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 12:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhHDQFA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 12:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628093087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3O2576qOeG/KxiCs4mB3F/2T/4gY12tj33y3mkUIHQ=;
        b=aNvkJE2ng5vdEVpt4qkk0sNfYbK6NH5eOapT/f0WnEhjYO4Y4fyD+z89330gyZEDLcMiEt
        q6cYSxJuzSZcuUEAi6F8iUu+YQ9HhFtiSbaAmHJ8qS/93Nfwj2CS1zv2pBPhuC+IzKGAqQ
        M341hZlVWvjcNctB0tr+6WtUQ8w+xrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-ejKJihQcMM-sMHyvYKU0Zw-1; Wed, 04 Aug 2021 12:04:46 -0400
X-MC-Unique: ejKJihQcMM-sMHyvYKU0Zw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9B84107ACF5;
        Wed,  4 Aug 2021 16:04:44 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F206610DF;
        Wed,  4 Aug 2021 16:04:21 +0000 (UTC)
Message-ID: <01fd4da9eb886282fc00477abbff53ce6fd0ec12.camel@redhat.com>
Subject: Re: Possible minor CPU bug on Zen2 in regard to using very high GPA
 in a VM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Gilbert <dgilbert@redhat.com>,
        David Matlack <dmatlack@google.com>
Date:   Wed, 04 Aug 2021 19:04:20 +0300
In-Reply-To: <YQq1SVV9DKaZDhLp@google.com>
References: <f8071f73869de34961ea1a35177fc778bb99d4b7.camel@redhat.com>
         <YQq1SVV9DKaZDhLp@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-04 at 15:42 +0000, Sean Christopherson wrote:
> On Wed, Aug 04, 2021, Maxim Levitsky wrote:
> > Hi!
> >  
> > I recently triaged a series of failures that I am seeing on both of my AMD machines in the kvm selftests.
> > 
> > One test failed due to a trivial typo, to which I had sent a fix, but most of the other tests failed
> > due to what I now suspect to be a very minor but still a CPU bug.
> >  
> > All of the failing tests except two tests that timeout (and I haven't yet triaged them),
> > use the perf_test_util.c library.
> > All of these fail with SHUTDOWN exit reason.
> > 
> > After a relatively recent commit ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()"),
> > vm_get_max_gfn() was fixed to return the maximum GFN that the guest can use.
> > For default VM type this value is obtained from 'vm->pa_bit's which is in turn obtained
> > from guest's cpuid in kvm_get_cpu_address_width function.
> >  
> > It is 48 on both my AMD machines (3970X and 4650U) and also on remote EPYC 7302P machine.
> > (all of them are Zen2 machines)
> >  
> > My 3970X has SME enabled by BIOS, while my 4650U doesn't have it enabled.
> > The 7302P also has SME enabled.
> > SEV was obviously not enabled for the test.
> > NPT was enabled.
> >  
> > It appears that if the guest uses any GPA above 0xFFFCFFFFF000 in its guest paging tables, 
> > then it gets #PF with reserved bits error code.
> 
> LOL, I encountered this joy a few weeks back.  There's a magic Hyper-Transport
> region at the top of memory that is reserved, even for GPAs.  You and I say
> "CPU BUG!!!", AMD says "working as intended" ;-)
> 
> https://lkml.kernel.org/r/20210625020354.431829-2-seanjc@google.com
> 

Cool!


It this documented anywhere? I guess KVM selftests tests can't read MSRs,
so even if this is exposed to a MSR, that would be useless.

Is it related to 'External Access Protection' stuff in the AMD's manual?

I guess I can at least do something like that in the unit tests:
"If max physical bits == 48 and machine == AMD then max GPA = 0xFFFCFFFFF000".

I'll prepare a patch for this if you agree.

Or I can fix the unit test to not allocate from the very top of the GPA space.
Dropping one bit from max physical address is enough to workaround this.

What do you think?

Best regards,
	Maxim Levitsky

