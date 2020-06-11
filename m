Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1B1F6B28
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgFKPgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 11:36:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:57442 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgFKPgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 11:36:06 -0400
IronPort-SDR: kRaucVPWJf5Yhbrs8q+ld/yUa0tEMR+stgW6FHL2yotklPIrYwlwxwXjVbR89v0M2LgyYfk1E0
 NrpH04E9RsAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 08:36:06 -0700
IronPort-SDR: dYUJwDTJHD9iP5wZvrIQO72rSowvuZXykZd4QOOytru91ojrVYKu2OqZys7+erBiefwxfBOBCz
 3TOrzMzfZ2Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="314844159"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2020 08:36:04 -0700
Date:   Thu, 11 Jun 2020 08:35:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: Cleanup kvm_setup_async_pf()
Message-ID: <20200611153557.GE29918@linux.intel.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610181453.GC18790@linux.intel.com>
 <87sgf29f77.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgf29f77.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 10:31:08AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> >
> > I'd also be in favor of changing the return type to a boolean.  I think
> > you alluded to it earlier, the current semantics are quite confusing as they
> > invert the normal "return 0 on success".
> 
> Yes, will do a follow-up.
> 
> KVM/x86 code has an intertwined mix of:
> - normal 'int' functions ('0 on success')
> - bool functions ('true'/'1' on success)
> - 'int' exit handlers ('1'/'0' on success depending if exit to userspace
>   was required)
> - ...
> 
> I think we can try to standardize this to:
> - 'int' when error is propagated outside of KVM (userspace, other kernel
>   subsystem,...)
> - 'bool' when the function is internal to KVM and the result is binary
>  ('is_exit_required()', 'was_pf_injected()', 'will_have_another_beer()',
>  ...)
> - 'enum' for the rest.
> And, if there's a good reason for making an exception, require a
> comment. (leaving aside everything returning a pointer, of course as
> these are self-explanatory -- unless it's 'void *' :-))

Agreed for 'bool' case, but 'int' versus 'enum' is less straightforward as
there are a huge number of functions that _may_ propagate an error outside
of KVM, including all of the exit handlers.  As Paolo point out[*], it'd
be quite easy to end up with a mixture of enum/#define and 0/1 code, which
would be an even bigger mess than what we have today.  There are
undoubtedly cases that could be converted to an enum, but they're probably
few and far between as it requires total encapsulation, e.g. the emulator.

[*] https://lkml.kernel.org/r/3d827e8b-a04e-0a93-4bb4-e0e9d59036da@redhat.com
