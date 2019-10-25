Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A3BE4F83
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 16:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395388AbfJYOsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 10:48:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:12049 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395385AbfJYOsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 10:48:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 07:48:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="197445114"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 25 Oct 2019 07:48:49 -0700
Date:   Fri, 25 Oct 2019 07:48:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191025144848.GA17290@linux.intel.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
 <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 01:37:56PM +0200, Paolo Bonzini wrote:
> On 25/10/19 01:29, Sean Christopherson wrote:
> > On Thu, Oct 24, 2019 at 04:03:27PM -0700, Jim Mattson wrote:
> >> From: John Sperbeck <jsperbeck@google.com>
> >>
> >> In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
> >> then fail later in the function, we need to call kvm_arch_destroy_vm()
> >> so that it can do any necessary cleanup (like freeing memory).
> >>
> >> Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
> >>
> >> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> >> Signed-off-by: Jim Mattson <jmattson@google.com>
> >> Reviewed-by: Junaid Shahid <junaids@google.com>
> >> ---
> >>  virt/kvm/kvm_main.c | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Sorry for the back and forth on this---I actually preferred the version 
> that did not move refcount_set.  It seems to me that kvm_get_kvm() in 
> kvm_arch_init_vm() should be okay as long as it is balanced in 
> kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:

No, this will effectively leak the VM because you'll end up with a cyclical
reference to kvm_put_kvm(), i.e. users_count will never hit zero.

void kvm_put_kvm(struct kvm *kvm)
{
	if (refcount_dec_and_test(&kvm->users_count))
		kvm_destroy_vm(kvm);
		|
		-> kvm_arch_destroy_vm()
		   |
		   -> kvm_put_kvm()
}
