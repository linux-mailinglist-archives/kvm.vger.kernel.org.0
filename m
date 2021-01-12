Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750D92F25EB
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbhALB71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbhALB70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 20:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1450B23A58;
        Tue, 12 Jan 2021 01:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610416725;
        bh=XIx30JQJmLtaC373rjHbFS0FMoCsRCbu0pn0e/xQap8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PYbJTI+x99tEs7zPlQPbepSX6ENzfSeQyqa6EF+KfOPAT17Hh0lWwGqeODC9TRLVT
         jirWjMR6V3Vvp8YtlcmogyL1cA2MxE/NI52HE1diE5JAiPOoGpMHTj+31Z4K+hT+Ra
         flZXh21zCBRn25xiXaGi51NItIoMB3o13n9biCo66zcZHNVWygF6Ld/sugnTkRFktg
         FR83spJTun16aWjh4WuCl4Cax+bawoJF3sjhkZzatU2SEQ1nIWoYI715iVjvMFfibs
         xjptJ6sCnL7SQ5Dy6w9ALviRvCo4R9iDJPUiT2KWNupXX7XtvU6ekRMd9p8//TI6id
         OgcLoQ0ojMmEA==
Date:   Tue, 12 Jan 2021 03:58:38 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-ID: <X/0CTuHCT8jeAoXl@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
 <X/ya0XnsQn4xb/1L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/ya0XnsQn4xb/1L@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021 at 10:37:05AM -0800, Sean Christopherson wrote:
> On Mon, Jan 11, 2021, Jarkko Sakkinen wrote:
> > On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> > >     just another memory backend for guests.
> > 
> > Why this an advantage? No objection, just a question.
> 
> There are zero KVM changes required to support exposing EPC to a guest.  KVM's
> MMU is completely ignorant of what physical backing is used for any given host
> virtual address.  KVM has to be aware of various VM_* flags, e.g. VM_PFNMAP and
> VM_IO, but that code is arch agnostic and is quite isolated.

Right, thanks for explanation.

> > >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> > >     does not have to export any symbols, changes to reclaim flows don't
> > >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> > >     get aired out for the world to see, and so on and so forth.
> > 
> > No comments to this before understanding code changes better.
> > 
> > > The virtual EPC allocated to guests is currently not reclaimable, due to
> > > reclaiming EPC from KVM guests is not currently supported. Due to the
> > > complications of handling reclaim conflicts between guest and host, KVM
> > > EPC oversubscription, which allows total virtual EPC size greater than
> > > physical EPC by being able to reclaiming guests' EPC, is significantly more
> > > complex than basic support for SGX virtualization.
> > 
> > I think it should be really in the center of the patch set description that
> > this patch set implements segmentation of EPC, not oversubscription. It should
> > be clear immediately. It's a core part of knowing "what I'm looking at".
> 
> Technically, it doesn't implement EPC segmentation of EPC.  It implements
> non-reclaimable EPC allocation.  Even that is somewhat untrue as the EPC can be
> forcefully reclaimed, but doing so will destroy the guest contents.

In SGX case, that isn't actually as a bad as a policy in high stress
situations as with "normal" applications.  Runtimes must expect
dissappearance of the enclave at any point of time anyway...

> Userspace can oversubscribe the EPC to KVM guests, but it would need to kill,
> migrate, or pause one or more VMs if the pool of physical EPC were exhausted.

Right.

> 
> > > - Support SGX virtualization without SGX Launch Control unlocked mode
> > > 
> > > Although SGX driver requires SGX Launch Control unlocked mode to work, SGX
> > > virtualization doesn't, since how enclave is created is completely controlled
> > > by guest SGX software, which is not necessarily linux. Therefore, this series
> > > allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,
> > > or is not present at all. The reason is the goal of SGX virtualization, or
> > > virtualization in general, is to expose hardware feature to guest, but not to
> > > make assumption how guest will use it. Therefore, KVM should support SGX guest
> > > as long as hardware is able to, to have chance to support more potential use
> > > cases in cloud environment.
> > 
> > AFAIK the convergence point with the FLC was, and is that Linux never enables
> > SGX with locked MSRs.
> > 
> > And I don't understand, if it is not fine to allow locked SGX for a *process*,
> > why is it fine for a *virtual machine*? They have a lot same.
> 
> Because it's a completely different OS/kernel.  If the user has a kernel that
> supports locked SGX, then so be it.  There's no novel circumvention of the
> kernel policy, e.g. the user could simply boot the non-upstream kernel directly,
> and running an upstream kernel in the guest will not cause the kernel to support
> SGX.
> 
> There are any number of things that are allowed in a KVM guest that are not
> allowed in a bare metal process.

I buy this.

> > I cannot remember out of top of my head, could the Intel SHA256 be read when
> > booted with unlocked MSRs. If that is the case, then you can still support
> > guests with that configuration.
> 
> No, it's not guaranteed to be readable as firmware could have already changed
> the values in the MSRs.

Right.

> > Context-dependent guidelines tend to also trash code big time. Also, for the
> > sake of a sane kernel code base, I would consider only supporting unlocked
> > MSRs.
> 
> It's one line of a code to teach the kernel driver not to load if the MSRs are
> locked.  And IMO, that one line of code is a net positive as it makes it clear
> in the driver itself that it chooses not support locked MSRs, even if SGX itself
> is fully enabled.

Yup, I think this clears my concerns, thank you.

/Jarkko
