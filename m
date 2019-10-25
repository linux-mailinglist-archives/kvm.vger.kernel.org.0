Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F6AE5004
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 17:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440654AbfJYPWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 11:22:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:29060 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731562AbfJYPWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 11:22:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 08:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="188950331"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 25 Oct 2019 08:22:01 -0700
Date:   Fri, 25 Oct 2019 08:22:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191025152201.GD17290@linux.intel.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
 <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
 <20191025144848.GA17290@linux.intel.com>
 <7fa85679-7325-4373-55a1-bb2cd274fec3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fa85679-7325-4373-55a1-bb2cd274fec3@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 04:56:23PM +0200, Paolo Bonzini wrote:
> On 25/10/19 16:48, Sean Christopherson wrote:
> >> It seems to me that kvm_get_kvm() in 
> >> kvm_arch_init_vm() should be okay as long as it is balanced in 
> >> kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:
> > No, this will effectively leak the VM because you'll end up with a cyclical
> > reference to kvm_put_kvm(), i.e. users_count will never hit zero.
> > 
> > void kvm_put_kvm(struct kvm *kvm)
> > {
> > 	if (refcount_dec_and_test(&kvm->users_count))
> > 		kvm_destroy_vm(kvm);
> > 		|
> > 		-> kvm_arch_destroy_vm()
> > 		   |
> > 		   -> kvm_put_kvm()
> > }
> 
> There's two parts to this:
> 
> - if kvm_arch_init_vm() calls kvm_get_kvm(), then kvm_arch_destroy_vm()
> won't be called until the corresponding kvm_put_kvm().
> 
> - if the error case causes kvm_arch_destroy_vm() to be called early,
> however, that'd be okay and would not leak memory, as long as
> kvm_arch_destroy_vm() detects the situation and calls kvm_put_kvm() itself.
> 
> One case could be where you have some kind of delayed work, where the
> callback does kvm_put_kvm.  You'd have to cancel the work item and call
> kvm_put_kvm in kvm_arch_destroy_vm, and you would go through that path
> if kvm_create_vm() fails after kvm_arch_init_vm().

But do we really want/need to allow handing out references to KVM during
kvm_arch_init_vm()?  AFAICT, it's not currently required by any arch.

If an actual use case comes along then we can move refcount_set() back,
but with the requirement that the arch/user provide a mechanism to
handle the reference with respect to kvm_arch_destroy_vm().  As opposed
to the current behavior, which allows an arch to naively do get()/put()
in init_vm()/destroy_vm() without any hint that what they're doing is
broken.
