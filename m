Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5211EB70
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 21:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfLMUBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 15:01:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:62763 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbfLMUBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 15:01:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 12:01:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="208563026"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2019 12:01:51 -0800
Date:   Fri, 13 Dec 2019 12:01:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
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
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 00/15] KVM: Dynamically size memslot arrays
Message-ID: <20191213200151.GF31552@linux.intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191203221433.GK19877@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203221433.GK19877@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:14:33PM -0800, Sean Christopherson wrote:
> On Thu, Oct 24, 2019 at 04:07:29PM -0700, Sean Christopherson wrote:
> > The end goal of this series is to dynamically size the memslot array so
> > that KVM allocates memory based on the number of memslots in use, as
> > opposed to unconditionally allocating memory for the maximum number of
> > memslots.  On x86, each memslot consumes 88 bytes, and so with 2 address
> > spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
> > E.g. given a VM that uses a total of 30 memslots, dynamic sizing reduces
> > the memory footprint from 90k to ~2.6k bytes.
> > 
> > The changes required to support dynamic sizing are relatively small,
> > e.g. are essentially contained in patches 14/15 and 15/15.  Patches 1-13
> > clean up the memslot code, which has gotten quite crusty, especially
> > __kvm_set_memory_region().  The clean up is likely not strictly necessary
> > to switch to dynamic sizing, but I didn't have a remotely reasonable
> > level of confidence in the correctness of the dynamic sizing without first
> > doing the clean up.
> > 
> > Christoffer, I added your Tested-by to the patches that I was confident
> > would be fully tested based on the desription of what you tested.  Let me
> > know if you disagree with any of 'em.
> > 
> > v3:
> >   - Fix build errors on PPC and MIPS due to missed params during
> >     refactoring [kbuild test robot].
> >   - Rename the helpers for update_memslots() and add comments describing
> >     the new algorithm and how it interacts with searching [Paolo].
> >   - Remove the unnecessary and obnoxious warning regarding memslots being
> >     a flexible array [Paolo].
> >   - Fix typos in the changelog of patch 09/15 [Christoffer].
> >   - Collect tags [Christoffer].
> > 
> > v2:
> >   - Split "Drop kvm_arch_create_memslot()" into three patches to move
> >     minor functional changes to standalone patches [Janosch].
> >   - Rebase to latest kvm/queue (f0574a1cea5b, "KVM: x86: fix ...")
> >   - Collect an Acked-by and a Reviewed-by
> 
> Paolo, do you want me to rebase this to the latest kvm/queue?

Ping.

Applies cleanly on the current kvm/queue and nothing caught fire in
testing (though I only re-tested the series as a whole).
