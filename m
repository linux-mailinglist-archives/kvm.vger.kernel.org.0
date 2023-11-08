Return-Path: <kvm+bounces-1123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B916C7E4E8F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72C2228155F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB701EC4;
	Wed,  8 Nov 2023 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ogxh70b4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F27A4A
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:27:19 +0000 (UTC)
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [IPv6:2001:41d0:1004:224b::af])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2617195
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:27:18 -0800 (PST)
Date: Wed, 8 Nov 2023 01:27:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699406837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qE81o0GD7F0fBZc8J6Vqjr9RUqx87RrnSBX42jF+tBk=;
	b=Ogxh70b41FrW4G30LbRTY6Yf30alC9M2Voqa6/yzAkXmpnqXfWM0WprELRjKOyxYwDyDg3
	uDb78BtFxxvOPS8VXII5O/xynJwaWN1+KUa0NpFhbPIqn+H1hVN9ZuuLkAMU/uzkhJi0+L
	KQNnLG8wxtqJ6rgZtbQVTsUHn03MhC0=
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
Message-ID: <ZUrj8IK__59kHixL@linux.dev>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev>
 <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 07, 2023 at 01:34:34PM -0800, David Matlack wrote:
> On Tue, Nov 7, 2023 at 1:10 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> Thanks Oliver. Maybe I'm being dense but I'm still not understanding
> how VGIC and UFFD interact :). I understand that VGIC is unaware of
> UFFD, but fundamentally they must interact in some way during
> post-copy. Can you spell out the sequence of events?

Well it doesn't help that my abbreviated explanation glosses over some
details. So here's the verbose explanation, and I'm sure Marc will have
a set of corrections too :) I meant there's no _explicit_ interaction
between UFFD and the various bits of GIC that need to touch guest
memory.

The GIC redistributors contain a set of MMIO registers that are
accessible through the KVM_GET_DEVICE_ATTR and KVM_SET_DEVICE_ATTR
ioctls. Writes to these are reflected directly into the KVM
representation, no biggie there.

One of the registers (GICR_PENDBASER) is a pointer to guest memory,
containing a bitmap of pending LPIs managed by the redistributor. The
ITS takes this to the extreme, as it is effectively a bunch of page
tables for interrupts. All of this state actually lives in a KVM
representation, and is only flushed out to guest memory when explicitly
told to do so by userspace.

On the target, we reread all the info when rebuilding interrupt
translations when userspace calls KVM_DEV_ARM_ITS_RESTORE_TABLES. All of
these guest memory accesses go through kvm_read_guest() and I expect the
usual UFFD handling for non-present pages kicks in from there.

> >
> > If UFFD is off the table then it would appear there are two options:
> >
> >  - Instrument these ioctls to request pages not marked as present in the
> >    theorized KVM-owned demand paging interface
> >
> >  - Mandate that userspace has transferred all of the required VGIC / ITS
> >    pages before resuming on the target
> >
> > The former increases the maintenance burden of supporting post-copy
> > upstream and the latter *will* fail spectacularly. Ideally we use a
> > mechanism that doesn't require us to think about instrumenting
> > post-copy for every new widget that we will want to virtualize.
> >
> > > So in the short term we could provide a partial solution for
> > > HugeTLB-backed VMs (at least unblocking Google's use-case) and in the
> > > long-term there's line of sight of a unified solution.
> >
> > Who do we expect to look after the upstreamed short-term solution once
> > Google has moved on to something else?
> 
> Note, the proposed long-term solution you are replying to is an
> extension of the short-term solution, not something else.

Ack, I just feel rather strongly that the priority should be making
guest_memfd with whatever post-copy scheme we devise. Once we settle
on a UAPI that works for the new and shiny thing then it's easier to
rationalize applying the UAPI change to other memory backing types.

-- 
Thanks,
Oliver

