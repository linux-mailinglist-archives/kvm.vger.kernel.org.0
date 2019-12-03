Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE691104AF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfLCTBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 14:01:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:27633 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfLCTBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 14:01:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 11:01:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,274,1571727600"; 
   d="scan'208";a="235986737"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2019 11:01:26 -0800
Date:   Tue, 3 Dec 2019 11:01:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 01/15] KVM: Move running VCPU from ARM to common code
Message-ID: <20191203190126.GC19877@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129213505.18472-2-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 29, 2019 at 04:34:51PM -0500, Peter Xu wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> For ring-based dirty log tracking, it will be more efficient to account
> writes during schedule-out or schedule-in to the currently running VCPU.
> We would like to do it even if the write doesn't use the current VCPU's
> address space, as is the case for cached writes (see commit 4e335d9e7ddb,
> "Revert "KVM: Support vCPU-based gfn->hva cache"", 2017-05-02).
> 
> Therefore, add a mechanism to track the currently-loaded kvm_vcpu struct.
> There is already something similar in KVM/ARM; one important difference
> is that kvm_arch_vcpu_{load,put} have two callers in virt/kvm/kvm_main.c:
> we have to update both the architecture-independent vcpu_{load,put} and
> the preempt notifiers.
> 
> Another change made in the process is to allow using kvm_get_running_vcpu()
> in preemptible code.  This is allowed because preempt notifiers ensure
> that the value does not change even after the VCPU thread is migrated.

In case it was clear, I strongly dislike adding kvm_get_running_vcpu().
IMO, it's a unnecessary hack.  The proper change to ensure a valid vCPU is
seen by mark_page_dirty_in_ring() when there is a current vCPU is to
plumb the vCPU down through the various call stacks.  Looking up the call
stacks for mark_page_dirty() and mark_page_dirty_in_slot(), they all
originate with a vcpu->kvm within a few functions, except for the rare
case where the write is coming from a non-vcpu ioctl(), in which case
there is no current vCPU.

The proper change is obviously much bigger in scope and would require
touching gobs of arch specific code, but IMO the end result would be worth
the effort.  E.g. there's a decent chance it would reduce the API between
common KVM and arch specific code by eliminating the exports of variants
that take "struct kvm *" instead of "struct kvm_vcpu *".
