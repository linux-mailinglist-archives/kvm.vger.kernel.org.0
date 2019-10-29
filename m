Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD7E8B85
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 16:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbfJ2PLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 11:11:31 -0400
Received: from smtp.lucina.net ([62.176.169.44]:33901 "EHLO smtp.lucina.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389623AbfJ2PLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 11:11:31 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2019 11:11:30 EDT
Received: from nodbug.lucina.net (78-141-76-187.dynamic.orange.sk [78.141.76.187])
        by smtp.lucina.net (Postfix) with ESMTPSA id 2D02A122804;
        Tue, 29 Oct 2019 16:03:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucina.net;
        s=dkim-201811; t=1572361384;
        bh=FhHnmn5HJQmLjdUIBlMzJMkmm1HvWMYg05aykYpacL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qyttz5WOLZlYszv1/a9wA5NoFOKYaDxLG7XCB5ZhM8glh8S6THwqoGjVXUO4u4Vum
         Q+rF1cCqkTNy82NGfnXfI6PxtETEw6MseELKnb5282N611DX4gPfSatWxrJHUKQzt/
         RRYq3gvOaTLUBoc3hdjUu84feyVbDxrCWlDGim3B5T10If/JV3iQlUQcrGXfVcWZfp
         e0CsDYUJvsg1QmyzyXdOmwVXsf5aTN5JYXgiuTKGMv3tHWbe9AiA5BldXye+lGFPhK
         7d+UpMFjdX24MV0o7Kryk0Tiwn18SdBAG1Ae7HSjXTBCl01RKHUkfW0wsND4X+1FBV
         cDj3WMv+r9Nfw==
Received: by nodbug.lucina.net (Postfix, from userid 1000)
        id 0C0E22684367; Tue, 29 Oct 2019 16:03:04 +0100 (CET)
Date:   Tue, 29 Oct 2019 16:03:04 +0100
From:   Martin Lucina <martin@lucina.net>
To:     Reto Buerki <reet@codelabs.ch>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] KVM: x86: nVMX GUEST_CR3 bug fix, and then some...
Message-ID: <20191029150304.GA29542@nodbug.lucina.net>
Mail-Followup-To: Reto Buerki <reet@codelabs.ch>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <8414d3e8-9a68-e817-de5a-3e9ca6dc85bb@codelabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8414d3e8-9a68-e817-de5a-3e9ca6dc85bb@codelabs.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Cc:s trimmed)

Hi,

On Monday, 30.09.2019 at 12:42, Reto Buerki wrote:
> On 9/27/19 11:45 PM, Sean Christopherson wrote:
> > *sigh*
> > 
> > v2 was shaping up to be a trivial update, until I started working on
> > Vitaly's suggestion to add a helper to test for register availability.
> > 
> > The primary purpose of this series is to fix a CR3 corruption in L2
> > reported by Reto Buerki when running with HLT interception disabled in L1.
> > On a nested VM-Enter that puts L2 into HLT, KVM never actually enters L2
> > and instead mimics HLT interception by canceling the nested run and
> > pretending that VM-Enter to L2 completed and then exited on HLT (which
> > KVM intercepted).  Because KVM never actually runs L2, KVM skips the
> > pending MMU update for L2 and so leaves a stale value in vmcs02.GUEST_CR3.
> > If the next wake event for L2 triggers a nested VM-Exit, KVM will refresh
> > vmcs12->guest_cr3 from vmcs02.GUEST_CR3 and consume the stale value.
> > 
> > Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
> > VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
> > update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
> > nested code fully responsible for vmcs02.GUEST_CR3.
> > 
> > Patch 02/08 is a minor optimization to skip the GUEST_CR3 update if
> > vmcs01 is already up-to-date.
> > 
> > Patches 03 and beyond are Vitaly's fault ;-).
> > 
> > Patches 03 and 04 are tangentially related cleanup to vmx_set_rflags()
> > that was discovered when working through the avail/dirty testing code.
> > Ideally they'd be sent as a separate series, but they conflict with the
> > avail/dirty helper changes and are themselves minor and straightforward.
> > 
> > Patches 05 and 06 clean up the register caching code so that there is a
> > single enum for all registers which use avail/dirty tracking.  While not
> > a true prerequisite for the avail/dirty helpers, the cleanup allows the
> > new helpers to take an 'enum kvm_reg' instead of a less helpful 'int reg'.
> > 
> > Patch 07 is the helpers themselves, as suggested by Vitaly.
> > 
> > Patch 08 is a truly optional change to ditch decache_cr3() in favor of
> > handling CR3 via cache_reg() like any other avail/dirty register.
> > 
> > 
> > Note, I collected the Reviewed-by and Tested-by tags for patches 01 and 02
> > even though I inverted the boolean from 'skip_cr3' to 'update_guest_cr3'.
> > Please drop the tags if that constitutes a non-trivial functional change.
> > 
> > v2:
> >   - Invert skip_cr3 to update_guest_cr3.  [Liran]
> >   - Reword the changelog and comment to be more explicit in detailing
> >     how/when KVM will process a nested VM-Enter without runnin L2.  [Liran]
> >   - Added Reviewed-by and Tested-by tags.
> >   - Add a comment in vmx_set_cr3() to explicitly state that nested
> >     VM-Enter is responsible for loading vmcs02.GUEST_CR3.  [Jim]
> >   - All of the loveliness in patches 03-08. [Vitaly]
> > 
> > Sean Christopherson (8):
> >   KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
> >   KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
> >   KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
> >   KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
> >   KVM: x86: Add WARNs to detect out-of-bounds register indices
> >   KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
> >   KVM: x86: Add helpers to test/mark reg availability and dirtiness
> >   KVM: x86: Fold decache_cr3() into cache_reg()
> > 
> >  arch/x86/include/asm/kvm_host.h |  5 +-
> >  arch/x86/kvm/kvm_cache_regs.h   | 67 +++++++++++++++++------
> >  arch/x86/kvm/svm.c              |  5 --
> >  arch/x86/kvm/vmx/nested.c       | 14 ++++-
> >  arch/x86/kvm/vmx/vmx.c          | 94 ++++++++++++++++++---------------
> >  arch/x86/kvm/x86.c              | 13 ++---
> >  arch/x86/kvm/x86.h              |  6 +--
> >  7 files changed, 123 insertions(+), 81 deletions(-)
> 
> Series:
> Tested-by: Reto Buerki <reet@codelabs.ch>

Any chance of this series making it into 5.4? Unless I'm looking in the
wrong place, I don't see the changes in either kvm.git or Linus' tree.

Thanks,

Martin
