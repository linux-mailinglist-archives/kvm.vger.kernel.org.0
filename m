Return-Path: <kvm+bounces-1083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA357E4A58
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1421C20CF8
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9FF3C6B5;
	Tue,  7 Nov 2023 21:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VCorqgMs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADE4321BB
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 21:10:48 +0000 (UTC)
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F58711F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 13:10:47 -0800 (PST)
Date: Tue, 7 Nov 2023 21:10:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699391445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Wam5uJ/giI5sPmJbt/lLRc8JhACqZV9mmqdqDS/oEI=;
	b=VCorqgMsut843PLsDqSsbrfede5+xOgI9SV/8u8tDf3EWMMmi+fofoL2fbhRV8qNa8CDGM
	UGgjO4Sks4rEiPOVOzf2e4bmCUS2uRbEh6EgyPNyTzLcJItckIkzFZ9kU1BlL7CGMcWLHE
	Gkilv5g28cvuMJ7uXHZibPGfUlEl1AI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUqn0OwtNR19PDve@linux.dev>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 07, 2023 at 12:04:21PM -0800, David Matlack wrote:
> On Tue, Nov 7, 2023 at 8:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:

[...]

> >  My
> > gut feeling even without reading everything was (and it was confirmed
> > after): I am open to merging some specific features that close holes in
> > the userfaultfd API, but in general I like the unification between
> > guest, userspace *and kernel* accesses that userfaultfd brings. The fact
> > that it includes VGIC on Arm is a cherry on top. :)
> 
> Can you explain how VGIC interacts with UFFD? I'd like to understand
> if/how that could work with a KVM-specific solution.

The VGIC implementation is completely unaware of the existence of UFFD,
which is rather elegant.

There is no ioctl that allows userspace to directly get/set the VGIC
state. Instead, when userspace wants to migrate a VM it needs to flush
the cached state out of KVM's representation into guest memory. I would
expect the VMM to do this right before collecting the final dirty
bitmap.

If UFFD is off the table then it would appear there are two options:

 - Instrument these ioctls to request pages not marked as present in the
   theorized KVM-owned demand paging interface

 - Mandate that userspace has transferred all of the required VGIC / ITS
   pages before resuming on the target

The former increases the maintenance burden of supporting post-copy
upstream and the latter *will* fail spectacularly. Ideally we use a
mechanism that doesn't require us to think about instrumenting
post-copy for every new widget that we will want to virtualize.

> So in the short term we could provide a partial solution for
> HugeTLB-backed VMs (at least unblocking Google's use-case) and in the
> long-term there's line of sight of a unified solution.

Who do we expect to look after the upstreamed short-term solution once
Google has moved on to something else?

-- 
Thanks,
Oliver

