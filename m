Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80711FD49B
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFQSc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 14:32:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:15632 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgFQSc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 14:32:26 -0400
IronPort-SDR: Heq0lZ+rxMLq9CxHv+wzrNZP4U2cdoVMZWPHOWXU5rDq5OHfJfwGpg8VttknL3Y9zhSL8od0O0
 eAPZNC9D3khg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 11:32:25 -0700
IronPort-SDR: adYkGQfP2UnElRGEJLNSZmQJe7CJIILLyFWQpU15MypxbLdC39GAC5XqxiTXYHKphCK9d65QcH
 xoqbO0CZBa7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="309568526"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 17 Jun 2020 11:32:24 -0700
Date:   Wed, 17 Jun 2020 11:32:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com,
        miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: Add capability to be able to report async pf
 error to guest
Message-ID: <20200617183224.GK26818@linux.intel.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-3-vgoyal@redhat.com>
 <87lfklhm58.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfklhm58.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 03:12:03PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > As of now asynchronous page fault mecahanism assumes host will always be
> > successful in resolving page fault. So there are only two states, that
> > is page is not present and page is ready.
> >
> > If a page is backed by a file and that file has been truncated (as
> > can be the case with virtio-fs), then page fault handler on host returns
> > -EFAULT.
> >
> > As of now async page fault logic does not look at error code (-EFAULT)
> > returned by get_user_pages_remote() and returns PAGE_READY to guest.
> > Guest tries to access page and page fault happnes again. And this
> > gets kvm into an infinite loop. (Killing host process gets kvm out of
> > this loop though).

Isn't this already fixed by patch 1/3 "kvm,x86: Force sync fault if previous
attempts failed"?  If it isn't, it should be, i.e. we should fix KVM before
adding what are effectively optimizations on top.   And, it's not clear that
the optimizations are necessary, e.g. I assume the virtio-fs truncation
scenario is relatively uncommon, i.e. not performance sensitive?

> >
> > This patch adds another state to async page fault logic which allows
> > host to return error to guest. Once guest knows that async page fault
> > can't be resolved, it can send SIGBUS to host process (if user space

I assume this is supposed to be "it can send SIGBUS to guest process"?
Otherwise none of this makes sense (to me).

> > was accessing the page in question).

Allowing the guest to opt-in to intercepting host page allocation failures
feels wrong, and fragile.  KVM can't possibly know whether an allocation
failure is something that should be forwarded to the guest, as KVM doesn't
know the physical backing for any given hva/gfn, e.g. the error could be
due to a physical device failure or a configuration issue.  Relying on the
async #PF mechanism to prevent allocation failures from crashing the guest
is fragile because there is no guarantee that a #PF can be async.

IMO, the virtio-fs truncation use case should first be addressed in a way
that requires explicit userspace intervention, e.g. by enhancing
kvm_handle_bad_page() to provide the necessary information to userspace so
that userspace can reflect select errors into the guest.  The reflection
could piggyback whatever vector is used by async page faults (#PF or #VE),
but would not be an async page fault per se.  If an async #PF happens to
encounter an allocation failure, it would naturally fall back to the
synchronous path (provided by patch 1/3) and the synchronous path would
automagically handle the error as above.

In other words, I think the guest should be able to enable "error handling"
support without first enabling async #PF.  From a functional perspective it
probably won't change a whole lot, but it would hopefully force us to
concoct an overall "paravirt page fault" design as opposed to simply async
#PF v2.
