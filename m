Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA97F21AE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 23:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfKFW1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 17:27:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:26990 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfKFW1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 17:27:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 14:27:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="353613712"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 06 Nov 2019 14:27:07 -0800
Date:   Wed, 6 Nov 2019 14:27:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
Message-ID: <20191106222707.GB21617@linux.intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
 <686b499e-7700-228e-3602-8e0979177acb@amazon.com>
 <20191106005806.GK23297@linux.intel.com>
 <3d827e8b-a04e-0a93-4bb4-e0e9d59036da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d827e8b-a04e-0a93-4bb4-e0e9d59036da@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 01:17:40PM +0100, Paolo Bonzini wrote:
> On 06/11/19 01:58, Sean Christopherson wrote:
> >> enum kvm_return {
> >>     KVM_RET_USER_EXIT = 0,
> >>     KVM_RET_GUEST = 1,
> >> };
> >>
> >> and then consistently use them as return values? That way anyone who has not
> >> worked on kvm before can still make sense of the code.
> > Hmm, I think it'd make more sense to use #define instead of enum to
> > hopefully make it clear that they aren't the *only* values that can be
> > returned.  That'd also prevent anyone from changing the return types from
> > 'int' to 'enum kvm_return', which IMO would hurt readability overall.
> > 
> > And maybe KVM_EXIT_TO_USERSPACE and KVM_RETURN_TO_GUEST?
> 
> That would be quite some work.  Right now there is some consistency
> between all of:
> 
> - x86_emulate_instruction and its callers
> 
> - vcpu->arch.complete_userspace_io
> 
> - vcpu_enter_guest/vcpu_block
> 
> - kvm_x86_ops->handle_exit
> 
> so it would be very easy to end up with a half-int-half-enum state that
> is more confusing than before...
 
Ya, my thought was to update the obvious cases, essentially the ones you
listed above, to use the define.  So almost intentionally end up in a
half-n-half state, at least in the short term, the thought being that the
extra annotation would do more harm than good.  But there's really no way
to determine whether or not it would actually be a net positive without
writing the code...

> I'm more worried about cases where we have functions returning either 0
> or -errno, but 0 lets you enter the guest.  I'm not sure if the only one
> is kvm_mmu_reload or there are others.

There are lots of those, e.g. basically all of the helpers for nested
consistency checks.
