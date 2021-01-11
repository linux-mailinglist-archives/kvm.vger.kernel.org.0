Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2072F1D20
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388909AbhAKRwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732707AbhAKRwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:52:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFBEB20738;
        Mon, 11 Jan 2021 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610387489;
        bh=8E4duo7rAAD3EKJEt5iXgLikA/b0GqHzaYL97VVfMlc=;
        h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
        b=WJ3DICcg5+ffpar6Pt9zsLZwuUq1L6rmx/zJYA+PxUzgJ4wlAWP9yAiaejc1HtUQu
         g+zR7lXRO6A8W87XnnZ+HPuSxWFak0PSuotpwKstgJWmo2IfOl/UJl+rIMjKDr5Toq
         q5XFmVVDjZs6h8rDI4sPboNpRjM3CcQvrJIJHk1u9DiUFWPx0KUTDHg3Zq+7JJeVNc
         /1Sdsq0Oo0QAwyUy1BwrRFsyHNjw0sTfhaYqHCwca37s0kaSyUJkMMua45Sg9IX691
         5EWqBqqMNgxSevKtKFOrmioNY+2C5yZVglEzxNmAo3uC/luK8/5ZLHMFb5KlbYRix+
         s96CLT+s3951A==
Message-ID: <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 11 Jan 2021 19:20:48 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.3 (by Flathub.org) 
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> --- Disclaimer ---
> 
> These patches were originally written by Sean Christopherson while at Intel.
> Now that Sean has left Intel, I (Kai) have taken over getting them upstream.
> This series needs more review before it can be merged.  It is being posted
> publicly and under RFC so Sean and others can review it. Maintainers are safe
> ignoring it for now.
> 
> ------------------
> 
> Hi all,
> 
> This series adds KVM SGX virtualization support. The first 12 patches starting
> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Please help to review this series. Also I'd like to hear what is the proper
> way to merge this series, since it contains change to both x86/SGX and KVM
> subsystem. Any feedback is highly appreciated. And please let me know if I
> forgot to CC anyone, or anyone wants to be removed from CC. Thanks in advance!
> 
> This series is based against latest tip tree's x86/sgx branch. You can also get
> the code from tip branch of kvm-sgx repo on github:
> 
>         https://github.com/intel/kvm-sgx.git tip
> 
> It also requires Qemu changes to create VM with SGX support. You can find Qemu
> repo here:
> 
>         https://github.com/intel/qemu-sgx.git next
> 
> Please refer to README.md of above qemu-sgx repo for detail on how to create
> guest with SGX support. At meantime, for your quick reference you can use below
> command to create SGX guest:
> 
>         #qemu-system-x86_64 -smp 4 -m 2G -drive file=<your_vm_image>,if=virtio \
>                 -cpu host,+sgx_provisionkey \
>                 -sgx-epc id=epc1,memdev=mem1 \
>                 -object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> Please note that the SGX relevant part is:
> 
>                 -cpu host,+sgx_provisionkey \
>                 -sgx-epc id=epc1,memdev=mem1 \
>                 -object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> And you can change other parameters of your qemu command based on your needs.

Thanks a lot documenting these snippets to the cover letter. I dig these
up from lore once my environment is working.

I'm setting up Arch based test environment with the eye on this patch set
and generic Linux keyring patches:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/arch.git/

Still have some minor bits to adjust before I can start deploying it for SGX
testing. For this patch set I'll use two instances of it.

> =========
> KVM SGX virtualization Overview
> 
> - Virtual EPC
> 
> "Virtual EPC" is the EPC section exposed by KVM to guest so SGX software in
> guest can discover it and use it to create SGX enclaves. KVM exposes SGX to 

Virtual EPC is a representation of an EPC section. And there is no "the".

> guest via CPUID, and exposes one or more "virtual EPC" sections for guest.
> The size of "virtual EPC" is passed as Qemu parameter when creating the
> guest, and the base address is calcualted internally according to guest's
> configuration.
> 
> To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> and how virtual EPC is used by guest is compeletely controlled by guest's SGX
> software.

I think that /dev/sgx_vepc would be a clear enough name for the device. This
text has now a bit confusing "terminology" related to this.

In some places virtual EPC is quotes, and in other places it is not. I think
that you could consistently an abbervation vEPC (without quotations):

"
vEPC
====

Virtual EPC, shortened as vEPC, is a representation of ...
"

> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:

Maybe you could remove "raw" from the text.

>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.

Why this an advantage? No objection, just a question.

>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.

No comments to this before understanding code changes better.

> The virtual EPC allocated to guests is currently not reclaimable, due to
> reclaiming EPC from KVM guests is not currently supported. Due to the
> complications of handling reclaim conflicts between guest and host, KVM
> EPC oversubscription, which allows total virtual EPC size greater than
> physical EPC by being able to reclaiming guests' EPC, is significantly more
> complex than basic support for SGX virtualization.

I think it should be really in the center of the patch set description that
this patch set implements segmentation of EPC, not oversubscription. It should
be clear immediately. It's a core part of knowing "what I'm looking at".

> - Support SGX virtualization without SGX Launch Control unlocked mode
> 
> Although SGX driver requires SGX Launch Control unlocked mode to work, SGX
> virtualization doesn't, since how enclave is created is completely controlled
> by guest SGX software, which is not necessarily linux. Therefore, this series
> allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,
> or is not present at all. The reason is the goal of SGX virtualization, or
> virtualization in general, is to expose hardware feature to guest, but not to
> make assumption how guest will use it. Therefore, KVM should support SGX guest
> as long as hardware is able to, to have chance to support more potential use
> cases in cloud environment.

AFAIK the convergence point with the FLC was, and is that Linux never enables
SGX with locked MSRs.

And I don't understand, if it is not fine to allow locked SGX for a *process*,
why is it fine for a *virtual machine*? They have a lot same.

I cannot remember out of top of my head, could the Intel SHA256 be read when
booted with unlocked MSRs. If that is the case, then you can still support
guests with that configuration.

Context-dependent guidelines tend to also trash code big time. Also, for the
sake of a sane kernel code base, I would consider only supporting unlocked
MSRs.

/Jarkko


