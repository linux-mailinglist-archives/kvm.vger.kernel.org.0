Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37B27181
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 23:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfEVVSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 17:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbfEVVSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 17:18:05 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9878B2173E;
        Wed, 22 May 2019 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558559883;
        bh=vm5TFptU4z16aOaq6WyJVuLQG+smQSsecNHc6EdO2EQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cWBMS3PZhojaDwCxM24fm9eZtn2egLd4rKSnhyyfFkuHkE9NM/B7vOwsCfa4hFLGr
         uBaSKoEy87eBUtvEQ4U3tKU9B0eI9hYynsiUeYbH9IeamI/gPYa5UnGJ8MDzTEXSLm
         uv2bfg9jqE4iHSK1DBHm1Bj5munpo/iw6Bx190H4=
Date:   Wed, 22 May 2019 14:18:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] mm/gup: continue VM_FAULT_RETRY processing event for
 pre-faults
Message-Id: <20190522141803.c6714f96f57612caaac5d19b@linux-foundation.org>
In-Reply-To: <20190522203828.GC18865@rapoport-lnx>
References: <1557844195-18882-1-git-send-email-rppt@linux.ibm.com>
        <20190522122113.a2edc8aba32f0fad189bae21@linux-foundation.org>
        <20190522203828.GC18865@rapoport-lnx>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 May 2019 23:38:29 +0300 Mike Rapoport <rppt@linux.ibm.com> wrote:

> (added kvm)
> 
> On Wed, May 22, 2019 at 12:21:13PM -0700, Andrew Morton wrote:
> > On Tue, 14 May 2019 17:29:55 +0300 Mike Rapoport <rppt@linux.ibm.com> wrote:
> > 
> > > When get_user_pages*() is called with pages = NULL, the processing of
> > > VM_FAULT_RETRY terminates early without actually retrying to fault-in all
> > > the pages.
> > > 
> > > If the pages in the requested range belong to a VMA that has userfaultfd
> > > registered, handle_userfault() returns VM_FAULT_RETRY *after* user space
> > > has populated the page, but for the gup pre-fault case there's no actual
> > > retry and the caller will get no pages although they are present.
> > > 
> > > This issue was uncovered when running post-copy memory restore in CRIU
> > > after commit d9c9ce34ed5c ("x86/fpu: Fault-in user stack if
> > > copy_fpstate_to_sigframe() fails").
> > > 
> > > After this change, the copying of FPU state to the sigframe switched from
> > > copy_to_user() variants which caused a real page fault to get_user_pages()
> > > with pages parameter set to NULL.
> > 
> > You're saying that argument buf_fx in copy_fpstate_to_sigframe() is NULL?
> 
> Apparently I haven't explained well. The 'pages' parameter in the call to
> get_user_pages_unlocked() is NULL.

Doh.

> > If so was that expected by the (now cc'ed) developers of
> > d9c9ce34ed5c8923 ("x86/fpu: Fault-in user stack if
> > copy_fpstate_to_sigframe() fails")?
> > 
> > It seems rather odd.  copy_fpregs_to_sigframe() doesn't look like it's
> > expecting a NULL argument.
> > 
> > Also, I wonder if copy_fpstate_to_sigframe() would be better using
> > fault_in_pages_writeable() rather than get_user_pages_unlocked().  That
> > seems like it operates at a more suitable level and I guess it will fix
> > this issue also.
> 
> If I understand correctly, one of the points of d9c9ce34ed5c8923 ("x86/fpu:
> Fault-in user stack if copy_fpstate_to_sigframe() fails") was to to avoid
> page faults, hence the use of get_user_pages().
> 
> With fault_in_pages_writeable() there might be a page fault, unless I've
> completely mistaken.
> 
> Unrelated to copy_fpstate_to_sigframe(), the issue could happen if any call
> to get_user_pages() with pages parameter set to NULL tries to access
> userfaultfd-managed memory. Currently, there are 4 in tree users:
> 
> arch/x86/kernel/fpu/signal.c:198:8-31:  -> gup with !pages
> arch/x86/mm/mpx.c:423:11-25:  -> gup with !pages
> virt/kvm/async_pf.c:90:1-22:  -> gup with !pages
> virt/kvm/kvm_main.c:1437:6-20:  -> gup with !pages

OK.

> I don't know if anybody is using mpx with uffd and anyway mpx seems to go
> away.
> 
> As for KVM, I think that post-copy live migration of L2 guest might trigger
> that as well. Not sure though, I'm not really familiar with KVM code.
>  
> > > In post-copy mode of CRIU, the destination memory is managed with
> > > userfaultfd and lack of the retry for pre-fault case in get_user_pages()
> > > causes a crash of the restored process.
> > > 
> > > Making the pre-fault behavior of get_user_pages() the same as the "normal"
> > > one fixes the issue.
> > 
> > Should this be backported into -stable trees?
> 
> I think that it depends on whether KVM affected by this or not.
> 

How do we determine this?

I guess it doesn't matter much.
