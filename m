Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829EC99916
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389901AbfHVQYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 12:24:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:7457 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389888AbfHVQYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 12:24:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:24:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="181437997"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 22 Aug 2019 09:24:49 -0700
Date:   Thu, 22 Aug 2019 09:24:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
Message-ID: <20190822162449.GF25467@linux.intel.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-5-steven.price@arm.com>
 <20190822152854.GE25467@linux.intel.com>
 <e2abc69b-74c2-64ef-e270-43d93513eaae@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2abc69b-74c2-64ef-e270-43d93513eaae@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 04:46:10PM +0100, Steven Price wrote:
> On 22/08/2019 16:28, Sean Christopherson wrote:
> > On Wed, Aug 21, 2019 at 04:36:50PM +0100, Steven Price wrote:
> >> kvm_put_guest() is analogous to put_user() - it writes a single value to
> >> the guest physical address. The implementation is built upon put_user()
> >> and so it has the same single copy atomic properties.
> > 
> > What you mean by "single copy atomic"?  I.e. what guarantees does
> > put_user() provide that __copy_to_user() does not?
> 
> Single-copy atomicity is defined by the Arm architecture[1] and I'm not
> going to try to go into the full details here, so this is a summary.
> 
> For the sake of this feature what we care about is that the value
> written/read cannot be "torn". In other words if there is a read (in
> this case from another VCPU) that is racing with the write then the read
> will either get the old value or the new value. It cannot return a
> mixture. (This is of course assuming that the read is using a
> single-copy atomic safe method).

Thanks for the explanation.  I assumed that's what you were referring to,
but wanted to double check.
 
> __copy_to_user() is implemented as a memcpy() and as such cannot provide
> single-copy atomicity in the general case (the buffer could easily be
> bigger than the architecture can guarantee).
> 
> put_user() on the other hand is implemented (on arm64) as an explicit
> store instruction and therefore is guaranteed by the architecture to be
> single-copy atomic (i.e. another CPU cannot see a half-written value).

I don't think kvm_put_guest() belongs in generic code, at least not with
the current changelog explanation about it providing single-copy atomic
semantics.  AFAICT, the single-copy thing is very much an arm64
implementation detail, e.g. the vast majority of 32-bit architectures,
including x86, do not provide any guarantees, and x86-64 generates more
or less the same code for put_user() and __copy_to_user() for 8-byte and
smaller accesses.

As an alternative to kvm_put_guest() entirely, is it an option to change
arm64's raw_copy_to_user() to redirect to __put_user() for sizes that are
constant at compile time and can be handled by __put_user()?  That would
allow using kvm_write_guest() to update stolen time, albeit with
arguably an even bigger dependency on the uaccess implementation details.
