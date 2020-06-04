Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253D31EE8A8
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgFDQfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgFDQfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 12:35:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E772063A;
        Thu,  4 Jun 2020 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591288540;
        bh=yh0pW6AQ26Q8fHNyEsW/NqFcwh9UdeeuT0YVHMhwgkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oz64bk3++bmjKdBSuwstw05YML612cdirg9gx/8mR6XeIO74cg1yCESj90ohJnnSv
         cDjuZ3NgvkxFiF6nuUmo0AN81ew532R2PhQsVHA85/U4gwsC8tsoSN0c9Q6Q6TEmnE
         pYa3JVNL1KSaYea21V1Ssgc3vDVvVHvl91cck04A=
Date:   Thu, 4 Jun 2020 17:35:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kernel-team@android.com, Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200604163532.GE3650@willie-the-truck>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200604161523.39962919@why>
 <20200604154835.GE30223@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200604154835.GE30223@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Thu, Jun 04, 2020 at 08:48:35AM -0700, Sean Christopherson wrote:
> On Thu, Jun 04, 2020 at 04:15:23PM +0100, Marc Zyngier wrote:
> > On Fri, 22 May 2020 15:51:58 +0300
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > == Background / Problem ==
> > > 
> > > There are a number of hardware features (MKTME, SEV) which protect guest
> > > memory from some unauthorized host access. The patchset proposes a purely
> > > software feature that mitigates some of the same host-side read-only
> > > attacks.
> > > 
> > > 
> > > == What does this set mitigate? ==
> > > 
> > >  - Host kernel ”accidental” access to guest data (think speculation)
> > > 
> > >  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
> > > 
> > >  - Host userspace access to guest data (compromised qemu)
> > > 
> > > == What does this set NOT mitigate? ==
> > > 
> > >  - Full host kernel compromise.  Kernel will just map the pages again.
> > > 
> > >  - Hardware attacks
> > 
> > Just as a heads up, we (the Android kernel team) are currently
> > involved in something pretty similar for KVM/arm64 in order to bring
> > some level of confidentiality to guests.
> > 
> > The main idea is to de-privilege the host kernel by wrapping it in its
> > own nested set of page tables which allows us to remove memory
> > allocated to guests on a per-page basis. The core hypervisor runs more
> > or less independently at its own privilege level. It still is KVM
> > though, as we don't intend to reinvent the wheel.
> > 
> > Will has written a much more lingo-heavy description here:
> > https://lore.kernel.org/kvmarm/20200327165935.GA8048@willie-the-truck/
> 
> Pardon my arm64 ignorance...

No, not at all!

> IIUC, in this mode, the host kernel runs at EL1?  And to switch to a guest
> it has to bounce through EL2, which is KVM, or at least a chunk of KVM?
> I assume the EL1->EL2->EL1 switch is done by trapping an exception of some
> form?

Yes, and this is actually the way that KVM works on some Arm CPUs today,
as the original virtualisation extensions in the Armv8 architecture do
not make it possible to run the kernel directly at EL2 (for example, there
is only one page-table base register). This was later addressed in the
architecture by the "Virtualisation Host Extensions (VHE)", and so KVM
supports both options.

With non-VHE today, there is a small amount of "world switch" code at
EL2 which is installed by the host kernel and provides a way to transition
between the host and the guest. If the host needs to do something at EL2
(e.g. privileged TLB invalidation), then it makes a hypercall (HVC instruction)
via the kvm_call_hyp() macro (and this ends up just being a function call
for VHE).

> If all of the above are "yes", does KVM already have the necessary logic to
> perform the EL1->EL2->EL1 switches, or is that being added as part of the
> de-privileging effort?

The logic is there as part of the non-VHE support code, but it's not great
from a security angle. For example, the guest stage-2 page-tables are still
allocated by the host, the host has complete access to guest and hypervisor
memory (including hypervisor text) and things like kvm_call_hyp() are a bit
of an open door. We're working on making the EL2 code more self contained,
so that after the host has initialised KVM, it can shut the door and the
hypervisor can install a stage-2 translation over the host, which limits its
access to hypervisor and guest memory. There will clearly be IOMMU work as
well to prevent DMA attacks.

Will
