Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A001252CD
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 21:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfLRUKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 15:10:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:9870 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfLRUKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 15:10:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 12:10:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="218256493"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 18 Dec 2019 12:10:02 -0800
Date:   Wed, 18 Dec 2019 12:10:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: Re: [RFC PATCH] KVM: x86: Disallow KVM_SET_CPUID{2} if the vCPU is
 in guest mode
Message-ID: <20191218201002.GE25201@linux.intel.com>
References: <20191218174255.30773-1-sean.j.christopherson@intel.com>
 <CALMp9eR-ssCUT_6oZntZ=-5SEN7Y8q-HnraKW=WDHuAn9gYZfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR-ssCUT_6oZntZ=-5SEN7Y8q-HnraKW=WDHuAn9gYZfQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 11:38:43AM -0800, Jim Mattson wrote:
> On Wed, Dec 18, 2019 at 9:42 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Reject KVM_SET_CPUID{2} with -EBUSY if the vCPU is in guest mode (L2) to
> > avoid complications and potentially undesirable KVM behavior.  Allowing
> > userspace to change a guest's capabilities while L2 is active would at
> > best result in unexpected behavior in the guest (L1 or L2), and at worst
> > induce bad KVM behavior by breaking fundamental assumptions regarding
> > transitions between L0, L1 and L2.
> 
> This seems a bit contrived. As long as we're breaking the ABI, can we
> disallow changes to CPUID once the vCPU has been powered on?

I can at least concoct scenarios where changing CPUID after KVM_RUN
provides value, e.g. effectively creating a new VM/vCPU without destroying
the kernel's underlying data structures and without putting the file
descriptors, for performance (especially if KVM avoids its hardware on/off
paths) or sandboxing (process has access to a VM fd, but not /dev/kvm).

A truly contrived, but technically architecturally accurate, scenario would
be modeling SGX interaction with the machine check architecutre.  Per the
SDM, #MCs or clearing bits in IA32_MCi_CTL disable SGX, which is reflected
in CPUID:

  Any machine check exception (#MC) that occurs after Intel SGX is first
  enables causes Intel SGX to be disabled, (CPUID.SGX_Leaf.0:EAX[SGX1] == 0)
  It cannot be enabled until after the next reset.

  Any act of clearing bits from '1 to '0 in any of the IA32_MCi_CTL register
  may disable Intel SGX (set CPUID.SGX_Leaf.0:EAX[SGX1] to 0) until the next
  reset.

I doubt a userspace VMM would actively model that behavior, but it's at
least theoretically possible.  Yes, it would technically be possible for
SGX to be disabled while L2 is active, but I don't think it's unreasonable
to require userspace to first force the vCPU out of L2.
