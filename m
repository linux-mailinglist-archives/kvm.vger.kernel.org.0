Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637681918E7
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgCXSVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:21:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:33976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbgCXSVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:21:05 -0400
IronPort-SDR: YQ3IlUFAH0UZqrqfbHRQFKDbyJPAoPvGXPiPAD5m7KxpOAgbGtqmui7L6Ir88TyoRaoHDXx9Uj
 Q7HOy6mgj47w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 11:20:50 -0700
IronPort-SDR: y/USM2b3SPl0LjjMZJcqAmjb2PYOuW/QAtqFht1aEDTm2RWTprcUGxDRQvFy8adhtqpy78sfUX
 6Y7gyFMhw+XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="246803473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 24 Mar 2020 11:20:48 -0700
Date:   Tue, 24 Mar 2020 11:20:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v4 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
Message-ID: <20200324182048.GF5998@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-20-sean.j.christopherson@intel.com>
 <f962fafb-3956-746f-d077-3dbcefaae7c8@de.ibm.com>
 <20191218163958.GC25201@linux.intel.com>
 <78b21097-52e4-b851-fc78-da3442fd0904@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78b21097-52e4-b851-fc78-da3442fd0904@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 10:43:07AM +0100, Christian Borntraeger wrote:
> 
> On 18.12.19 17:39, Sean Christopherson wrote:
> > On Wed, Dec 18, 2019 at 12:39:43PM +0100, Christian Borntraeger wrote:
> >>
> I started looking into this what it would cost to implement this on s390.
> s390 is also returning EFAULT if no memory slot is available.
> 
> According to the doc this is not documented at all. So this part of the test
>         vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
>         vm_vcpu_add(vm, VCPU_ID);
>         /* Fails with ENOSPC because the MMU can't create pages (no slots). */
>         TEST_ASSERT(_vcpu_run(vm, VCPU_ID) == -1 && errno == ENOSPC,
>                     "Unexpected error code = %d", errno);
>         kvm_vm_free(vm);
> 
> is actually just testing that the implementation for x86 does not change the error
> from ENOSPC to something else.

It's even worse than that.  There error isn't directly due to no having
a memslots, it occurs because the limit on number of pages in the MMU is
zero.  On x86, that limit is automatically derived from the total size of
memslots.

The selftest could add an explicit ioctl() call to manually override the
number of allowed MMU pages, but that didn't seem any cleaner as it'd still
rely on undocumented internal KVM behavior.

TL;DR: I'm not a huge fan of the code either.

> The question is: do we want to document the error for the "no memslot" case
> and then change all existing platforms?

At first blush, I like the idea of adding an explicit check in KVM_RUN to
return an error if there isn't at least one usable memslot.  But, it'd be a
little weird/kludgy on x86/VMX due to the existence of "private" memslots,
i.e. the check should really fire on "no public memslots".  At that point,
I'm not sure whether the well defined errno would be worth the extra code.
