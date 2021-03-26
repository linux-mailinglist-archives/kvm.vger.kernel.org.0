Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D3B34AADE
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCZPEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:04:25 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45820 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhCZPD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 11:03:59 -0400
Received: from zn.tnic (p200300ec2f075f0023f9e598b0fb3457.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:23f9:e598:b0fb:3457])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9A35E1EC0513;
        Fri, 26 Mar 2021 16:03:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616771037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CfwXUBztMW0fzBsj6+U0+7zvJQvkrsJoWtLbREPN9mA=;
        b=eZ010qVh4ojil1n/Ws3cdVhKtkO6a0a3CadBH8JEkzlgW5vL1xfrYeaRe63ZxIXLYri8bX
        kkKQfUhdaaewsxoY4422rFZDudLyc3cN+tdgdr2raJGsx3K+eHQPgdoMJ4XdCrKqJRnQls
        uaaQAeGrI5b3D3fn21RuN24YGMF+hQk=
Date:   Fri, 26 Mar 2021 16:03:55 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     seanjc@google.com
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <20210326150320.GF25229@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:22:21PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
> without an associated enclave.  The intended and only known use case for
> raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
> moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.
> 
> SGX driver uses misc device /dev/sgx_enclave to support userspace to
> create enclave.  Each file descriptor from opening /dev/sgx_enclave
> represents an enclave.  Unlike SGX driver, KVM doesn't control how guest
> uses EPC, therefore EPC allocated to KVM guest is not associated to an
> enclave, and /dev/sgx_enclave is not suitable for allocating EPC for KVM
> guest.
> 
> Having separate device nodes for SGX driver and KVM virtual EPC also
> allows separate permission control for running host SGX enclaves and
> KVM SGX guests.

Hmm, just a question on the big picture here - that might've popped up
already:

So baremetal uses /dev/sgx_enclave and KVM uses /dev/sgx_vepc. Who's
deciding which of the two has priority?

Let's say all guests start using enclaves and baremetal cannot start any
new ones anymore due to no more memory. Are we ok with that?

What if baremetal creates a big fat enclave and starves guests all of a
sudden. Are we ok with that either?

In general, having two disjoint things give out SGX resources separately
sounds like trouble to me.

IOW, why don't all virt allocations go through /dev/sgx_enclave too, so
that you can have a single place to control all resource allocations?

> To use /dev/sgx_vepc to allocate a virtual EPC instance with particular
> size, the userspace hypervisor opens /dev/sgx_vepc, and uses mmap()
> with the intended size to get an address range of virtual EPC.  Then
> it may use the address range to create one KVM memory slot as virtual
> EPC for guest.
> 
> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_vepc rather than in KVM. Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see,

Good one. :-)

> and so on and so forth.

> The virtual EPC pages allocated to guests are currently not reclaimable.
> Reclaiming EPC page used by enclave requires a special reclaim mechanism
> separate from normal page reclaim, and that mechanism is not supported
> for virutal EPC pages.  Due to the complications of handling reclaim
> conflicts between guest and host, reclaiming virtual EPC pages is
> significantly more complex than basic support for SGX virtualization.

What happens if someone in the future wants to change that? Someone
needs to write patches or there's a more fundamental stopper issue
involved?

As always, I might be missing something but that doesn't stop me from
being devil's advocate. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
