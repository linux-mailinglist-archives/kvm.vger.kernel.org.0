Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD70A124DFD
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLRQkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 11:40:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:30982 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbfLRQkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 11:40:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 08:39:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="205898318"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Dec 2019 08:39:59 -0800
Date:   Wed, 18 Dec 2019 08:39:59 -0800
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
Message-ID: <20191218163958.GC25201@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-20-sean.j.christopherson@intel.com>
 <f962fafb-3956-746f-d077-3dbcefaae7c8@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f962fafb-3956-746f-d077-3dbcefaae7c8@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 12:39:43PM +0100, Christian Borntraeger wrote:
> 
> On 17.12.19 21:40, Sean Christopherson wrote:
> > Add a KVM selftest to test moving the base gfn of a userspace memory
> > region.  The test is primarily targeted at x86 to verify its memslot
> > metadata is correctly updated, but also provides basic functionality
> > coverage on other architectures.
> > +static void *vcpu_worker(void *data)
> > +{
> > +	struct kvm_vm *vm = data;
> > +	struct kvm_run *run;
> > +	struct ucall uc;
> > +	uint64_t cmd;
> > +
> > +	/*
> > +	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
> > +	 * which will occur if the guest attempts to access a memslot while it
> > +	 * is being moved.
> > +	 */
> > +	run = vcpu_state(vm, VCPU_ID);
> > +	do {
> > +		vcpu_run(vm, VCPU_ID);
> > +	} while (run->exit_reason == KVM_EXIT_MMIO);
> > +
> > +	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> > +		    "Unexpected exit reason = %d", run->exit_reason);
> 
> 
> This will also not work for s390. Maybe just make this test x86 specific for now?

Doh, that's obvious in hindsight.  I think the basic premise is also
broken on arm64 as it returns -EFAULT on is_error_noslot_pfn(pfn).  So
yeah, x86 only for now :-(
