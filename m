Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D517E3AB9
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 20:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504038AbfJXSOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 14:14:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:46110 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504015AbfJXSOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 14:14:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 11:14:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="399854248"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 24 Oct 2019 11:14:03 -0700
Date:   Thu, 24 Oct 2019 11:14:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191024181403.GD20633@linux.intel.com>
References: <20191023171435.46287-1-jmattson@google.com>
 <20191023182106.GB26295@linux.intel.com>
 <7e1fe902-65e3-5381-1ac8-b280f39a677d@google.com>
 <4d81887e-12d7-baaf-586b-b85020bd5eaf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d81887e-12d7-baaf-586b-b85020bd5eaf@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 12:08:29PM +0200, Paolo Bonzini wrote:
> On 24/10/19 04:59, Junaid Shahid wrote:
> > AFAICT the kvm->users_count is already 0 before kvm_arch_destroy_vm()
> > is called from kvm_destroy_vm() in the normal case.
> 
> Yes:
> 
>         if (refcount_dec_and_test(&kvm->users_count))
>                 kvm_destroy_vm(kvm);
> 
> where
> 
> | int atomic_inc_and_test(atomic_t *v);
> | int atomic_dec_and_test(atomic_t *v);
> |
> | These two routines increment and decrement by 1, respectively, the
> | given atomic counter.  They return a boolean indicating whether the
> | resulting counter value was zero or not.
> 
> > So there really
> > shouldn't be any arch that does a kvm_put_kvm() inside
> > kvm_arch_destroy_vm(). I think it might be better to keep the
> > kvm_arch_destroy_vm() call after the refcount_set() to be consistent
> > with the normal path.
> 
> I agree, so I am applying Jim's patch.

Junaid also pointed out that x86 will dereference a NULL kvm->memslots[].

> If anything, we may want to WARN if the refcount is not 1 before the
> refcount_set.

What about moving "refcount_set(&kvm->users_count, 1)" to right before the
VM is added to vm_list, i.e. after arch code and init'ing the mmu_notifier?
Along with a comment explaining the kvm_get_kvm() is illegal while the VM
is being created.

That'd eliminate the atmoic_set() in the error path, which is confusing,
at least for me.  It'd also obviate the need for an explicit WARN since
running with refcount debugging would immediately flag any arch that
tried to use kvm_get_kvm() during kvm_arch_create_vm().

Moving the refcount_set() could be done along with rearranging the memslots
and buses allocation/cleanup in a preparatory patch before adding the call
to kvm_arch_destroy_vm().
