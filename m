Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68ED1794E3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbgCDQTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 11:19:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:25026 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgCDQTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 11:19:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 08:19:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="439182749"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2020 08:19:12 -0800
Date:   Wed, 4 Mar 2020 08:19:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Feiner <pfeiner@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: Nested virtualization and software page walks in the L1
 hypervsior
Message-ID: <20200304161912.GC21662@linux.intel.com>
References: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
 <CAM3pwhEXonbu-He1KD52ggEHHKVWok4Bac-4Woq7FvYL9pHykA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM3pwhEXonbu-He1KD52ggEHHKVWok4Bac-4Woq7FvYL9pHykA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 04:22:57PM -0800, Peter Feiner wrote:
> On Sat, Feb 29, 2020 at 2:31 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > Peter Feiner asked me an intriguing question the other day. If you
> > have a hypervisor that walks  its guest's x86 page tables in software
> > during emulation, how can you make that software page walk behave
> > exactly like a hardware page walk? In particular, when the hypervisor
> > is running as an L1 guest, how is it possible to write the software
> > page walk so that accesses to L2's x86 page tables are treated as
> > reads if L0 isn't using EPT A/D bits, but they're treated as writes if
> > L0 is using EPT A/D bits? (Paravirtualization is not allowed.)
> >
> > It seems to me that this behavior isn't virtualizable. Am I wrong?
> 
> Jim, I thought about this some more after talking to you. I think it's
> entirely moot what L0 sees so long as L1 and L2 work correctly. So,
> the question becomes, is there anything that L0 could possibly rely on
> this behavior for? My first thought was dirty tracking, but that's not
> a problem because *writes* to the L2 x86 page tables' A/D bits will
> still be intercepted by L0. The missing D bit on a guest page that
> doesn't actually change doesn't matter :-)

Ya.  The hardware behavior of setting the Dirty bit is effectively a
spurious update.  Not emulating that behavior is arguably a good thing :-).

Presumably, the EPT walks are overzealous in treating IA32 page walks as
writes to allow for simpler hardware implementations, e.g. the mechanism to
handle A/D bit updates doesn't need to handle the case where setting an A/D
bit in an IA32 page walk would also trigger an D bit update for the
associated EPT walk.
