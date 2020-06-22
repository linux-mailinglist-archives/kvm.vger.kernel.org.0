Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7920409F
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgFVTk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 15:40:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:9154 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgFVTk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 15:40:57 -0400
IronPort-SDR: bDFNHcrkkwTVLHcqJAVsIhF+D5EQz8IBOT+h3PIExNcPygWH8I0b57hHUyvT+qLL63ao6JeFLI
 jpB+FhXvdFAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="141358938"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="141358938"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 12:40:56 -0700
IronPort-SDR: O2b/9H8givv7m7N6NdtbF7yIVm6rD/0I5UzGQRLHIHJLsztvgSIXbC7QNG8I+x4aNniWrNxrWX
 DnQr+RzAI2QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264595386"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 12:40:55 -0700
Date:   Mon, 22 Jun 2020 12:40:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 10/21] KVM: x86/mmu: Make __GFP_ZERO a property of the
 memory cache
Message-ID: <20200622194055.GC6151@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-11-sean.j.christopherson@intel.com>
 <CANgfPd9_BR_2NThfEs8faDxWeooZ6OeF2HAB5mUmted5sHwDPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9_BR_2NThfEs8faDxWeooZ6OeF2HAB5mUmted5sHwDPg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 11:57:32AM -0700, Ben Gardon wrote:
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/mmu/mmu.c          | 7 ++++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index e7a427547557..fb99e6776e27 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
> >   */
> >  struct kvm_mmu_memory_cache {
> >         int nobjs;
> > +       gfp_t gfp_zero;
> This would make more sense to me if it could be used for general extra
> gfp flags and was called gfp_flags or something, or it was a boolean
> that was later translated into the flag being set. Storing the
> gfp_zero flag here is a little counter-intuitive. Probably not worth
> changing unless you're sending out a v2 for some other reason.

Ideally, this would be a generic gfp_flags field, but that's basically a
non-starter for patch 5, which uses GFP_ATOMIC for the "oh crap the cache
is empty" error handling.  Allowing arbitrary flags would be a mess.

I went with storing a full gfp_t because that produces more optimal code.
This isn't a super critical path and it's only a few cycles, but it seems
worthwhile given the frequency with which this code will be called, and
since this happens under mmu_lock.


348             gfp_flags |= mc->gfp_zero;
   0x00000000000058ab <+59>:    mov    0x4(%rbx),%eax
   0x00000000000058ae <+62>:    or     $0x400cc0,%eax

versus

349                     gfp_flags |= __GFP_ZERO;
   0x00000000000058a7 <+55>:    cmpb   $0x1,0x4(%rbx)
   0x00000000000058ab <+59>:    mov    0x8(%rbx),%rdi <-- unrelated interleaved code
   0x00000000000058af <+63>:    sbb    %eax,%eax
   0x00000000000058b1 <+65>:    xor    %al,%al
   0x00000000000058b3 <+67>:    add    $0x400dc0,%eax

