Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420BF1796F5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbgCDRrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:47:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:61415 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgCDRrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:47:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 09:47:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="441083663"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 04 Mar 2020 09:47:12 -0800
Date:   Wed, 4 Mar 2020 09:47:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Peter Feiner <pfeiner@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: Nested virtualization and software page walks in the L1
 hypervsior
Message-ID: <20200304174713.GE21662@linux.intel.com>
References: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
 <CAM3pwhEXonbu-He1KD52ggEHHKVWok4Bac-4Woq7FvYL9pHykA@mail.gmail.com>
 <20200304161912.GC21662@linux.intel.com>
 <CALMp9eQepf7TgC3upv1u+zrygXZWQmJcU7Eq=ODTqiYicKXFLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQepf7TgC3upv1u+zrygXZWQmJcU7Eq=ODTqiYicKXFLA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 09:13:40AM -0800, Jim Mattson wrote:
> On Wed, Mar 4, 2020 at 8:19 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Mar 03, 2020 at 04:22:57PM -0800, Peter Feiner wrote:
> > > On Sat, Feb 29, 2020 at 2:31 PM Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > Peter Feiner asked me an intriguing question the other day. If you
> > > > have a hypervisor that walks  its guest's x86 page tables in software
> > > > during emulation, how can you make that software page walk behave
> > > > exactly like a hardware page walk? In particular, when the hypervisor
> > > > is running as an L1 guest, how is it possible to write the software
> > > > page walk so that accesses to L2's x86 page tables are treated as
> > > > reads if L0 isn't using EPT A/D bits, but they're treated as writes if
> > > > L0 is using EPT A/D bits? (Paravirtualization is not allowed.)
> > > >
> > > > It seems to me that this behavior isn't virtualizable. Am I wrong?
> > >
> > > Jim, I thought about this some more after talking to you. I think it's
> > > entirely moot what L0 sees so long as L1 and L2 work correctly. So,
> > > the question becomes, is there anything that L0 could possibly rely on
> > > this behavior for? My first thought was dirty tracking, but that's not
> > > a problem because *writes* to the L2 x86 page tables' A/D bits will
> > > still be intercepted by L0. The missing D bit on a guest page that
> > > doesn't actually change doesn't matter :-)
> >
> > Ya.  The hardware behavior of setting the Dirty bit is effectively a
> > spurious update.  Not emulating that behavior is arguably a good thing :-).
> >
> > Presumably, the EPT walks are overzealous in treating IA32 page walks as
> > writes to allow for simpler hardware implementations, e.g. the mechanism to
> > handle A/D bit updates doesn't need to handle the case where setting an A/D
> > bit in an IA32 page walk would also trigger an D bit update for the
> > associated EPT walk.
> 
> I was actually more concerned about the EPT permissions aspect. With
> EPT A/D bits enabled, a non-writable EPT page can't be used for a
> hardware page walk, but it can be used for a software page walk. Maybe
> that's neither here nor there.

Ah, I see.  L1 and L2 are two different EPT contexts.  Assuming a normal
scenario where the memslot itself is writable, the fact that KVM has made
an EPT entry for L2 read-only, e.g. for dirty logging, is completely
irrelevant when KVM is running L1.  From L1's perspective, the memory is
still writable.

So the statement really becomes "L1 can walk shadow page tables in a
read-only memslot that will be unusable for L2 if L0 has EPT A/D bits
enabled".  Key word being "walk", since L1 can't create/modify the page
tables.

Theoretically you could concoct a scenario where enabling EPT A/D would
break nested virtualization, but it'd require that L1 use prebuilt page
tables for L2.  The only remotely sane way I could see that working is if
the page tables were built while the memslot was writable and then the
memslot was converted to read-only, e.g. through a paravirt hardening
feature, or if the page tables were created by L0 userspace, e.g. the page
tables came from an asset associated with L1 that is exposed to L1 as a
read-only memslot.  Either way, L0 would be involved and would hopefully be
smart enough to know it shouldn't enable EPT A/D bits.
