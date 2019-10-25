Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE31E567D
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 00:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfJYW3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 18:29:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:25993 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfJYW3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 18:29:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 15:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="201943372"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2019 15:29:11 -0700
Date:   Fri, 25 Oct 2019 15:29:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191025222911.GA24952@linux.intel.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
 <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
 <20191025144848.GA17290@linux.intel.com>
 <7fa85679-7325-4373-55a1-bb2cd274fec3@redhat.com>
 <20191025152201.GD17290@linux.intel.com>
 <637f0a19-e182-ed58-9fc2-0556a9a37be5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <637f0a19-e182-ed58-9fc2-0556a9a37be5@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 05:23:54PM +0200, Paolo Bonzini wrote:
> On 25/10/19 17:22, Sean Christopherson wrote:
> > On Fri, Oct 25, 2019 at 04:56:23PM +0200, Paolo Bonzini wrote:
> >> On 25/10/19 16:48, Sean Christopherson wrote:
> >>>> It seems to me that kvm_get_kvm() in 
> >>>> kvm_arch_init_vm() should be okay as long as it is balanced in 
> >>>> kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:
> >>> No, this will effectively leak the VM because you'll end up with a cyclical
> >>> reference to kvm_put_kvm(), i.e. users_count will never hit zero.
> >>>
> >>> void kvm_put_kvm(struct kvm *kvm)
> >>> {
> >>> 	if (refcount_dec_and_test(&kvm->users_count))
> >>> 		kvm_destroy_vm(kvm);
> >>> 		|
> >>> 		-> kvm_arch_destroy_vm()
> >>> 		   |
> >>> 		   -> kvm_put_kvm()
> >>> }
> >>
> >> There's two parts to this:
> >>
> >> - if kvm_arch_init_vm() calls kvm_get_kvm(), then kvm_arch_destroy_vm()
> >> won't be called until the corresponding kvm_put_kvm().
> >>
> >> - if the error case causes kvm_arch_destroy_vm() to be called early,
> >> however, that'd be okay and would not leak memory, as long as
> >> kvm_arch_destroy_vm() detects the situation and calls kvm_put_kvm() itself.
> >>
> >> One case could be where you have some kind of delayed work, where the
> >> callback does kvm_put_kvm.  You'd have to cancel the work item and call
> >> kvm_put_kvm in kvm_arch_destroy_vm, and you would go through that path
> >> if kvm_create_vm() fails after kvm_arch_init_vm().
> > 
> > But do we really want/need to allow handing out references to KVM during
> > kvm_arch_init_vm()?  AFAICT, it's not currently required by any arch.
> 
> Probably not, but the full code paths are long, so I don't see much
> value in outright forbidding it.  There are very few kvm_get_kvm() calls
> anyway in arch-dependent code, so it's easy to check that they're not
> causing reference cycles.

I wasn't thinking forbid it for all eternity, more like add a landmine to
force an arch to implement more robust handling in order to enable
kvm_get_kvm() during init_vm().
