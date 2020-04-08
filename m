Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7971A244E
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgDHOt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 10:49:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgDHOt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 10:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=N8ykcQQ3SOpdB5xsAT3pwV11DGg8xQH7SevAPGdtwTg=; b=YOq7ZrDsmTyGEBcCI6BSDKkjsL
        I0uT/nJsD58Z+VHPMPAHi0wRyC61w6xXBMjcZFL/2mAsz2fbtr2mmjek7SrHTS63SneNCwGwzHyPL
        S6MegKRHQ/nk/fGNaJ8Yz3jQF01jD37BeyYMXiT7eN6emnX4N2gqwsKwlbXITRiIhFb2j8OdeEA6i
        EFM6XQ1O24xEkXwi2ZPKN/MNkvCJD42WZQ91uLBB3Kz9N8eWpkQrZbjuPLmlGMfjS+qjHTXkSzn8v
        TUIi2+UWQ5UwjS0BvK/up5CVJDBsoMmz8NqwVB+LGs7/FnCAsL8VncXNigzzuY1EjQvss6OMnwXmk
        pkaGs/vw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMC0r-00044L-OE; Wed, 08 Apr 2020 14:49:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4BFC5305FB6;
        Wed,  8 Apr 2020 16:49:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3E3F52BA90A66; Wed,  8 Apr 2020 16:49:07 +0200 (CEST)
Date:   Wed, 8 Apr 2020 16:49:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 00/26] Runtime paravirt patching
Message-ID: <20200408144907.GL20730@hirez.programming.kicks-ass.net>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408120856.GY20713@hirez.programming.kicks-ass.net>
 <bcf8206d-5a41-4e6b-1832-75ba1d6367e4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bcf8206d-5a41-4e6b-1832-75ba1d6367e4@suse.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 08, 2020 at 03:33:52PM +0200, Jürgen Groß wrote:
> On 08.04.20 14:08, Peter Zijlstra wrote:
> > On Tue, Apr 07, 2020 at 10:02:57PM -0700, Ankur Arora wrote:
> > > Mechanism: the patching itself is done using stop_machine(). That is
> > > not ideal -- text_poke_stop_machine() was replaced with INT3+emulation
> > > via text_poke_bp(), but I'm using this to address two issues:
> > >   1) emulation in text_poke() can only easily handle a small set
> > >   of instructions and this is problematic for inlined pv-ops (and see
> > >   a possible alternatives use-case below.)
> > >   2) paravirt patching might have inter-dependendent ops (ex.
> > >   lock.queued_lock_slowpath, lock.queued_lock_unlock are paired and
> > >   need to be updated atomically.)
> > 
> > And then you hope that the spinlock state transfers.. That is that both
> > implementations agree what an unlocked spinlock looks like.
> > 
> > Suppose the native one was a ticket spinlock, where unlocked means 'head
> > == tail' while the paravirt one is a test-and-set spinlock, where
> > unlocked means 'val == 0'.
> > 
> > That just happens to not be the case now, but it was for a fair while.
> 
> Sure? This would mean that before spinlock-pvops are being set no lock
> is allowed to be used in the kernel, because this would block the boot
> time transition of the lock variant to use.

Hurm.. true. I suppose I completely forgot how paravirt spinlocks looked
before it got rewritten.

> Another problem I'm seeing is that runtime pvops patching would rely on
> the fact that stop_machine() isn't guarded by a spinlock.

It can't be, stop_machine() relies on scheduling. But yes, that another
variation of 'stuff uses spinlocks'.
