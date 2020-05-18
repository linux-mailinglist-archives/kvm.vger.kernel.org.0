Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2C1D723C
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 09:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgERHup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 03:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgERHup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 03:50:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D6C20787;
        Mon, 18 May 2020 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589788245;
        bh=lqHej4TeaH/h0N1U2FkK0BZnCpJw7cuBwYsE1+Z+y/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LnqTXJ6Xz9beUnIik6bXpG/2hpaTRmYbocdh91cTI0NjQ6MO3VllE9fT0qW/g6uLS
         xtGr1V+cqVk3tN/5qbWYSM6UOuOiSZ0xliYoUeLXOGX4VG3eSOVWBveH5ouY1UhxBF
         6AgF/Wen5TNtdYHkLq6rn987ul1SmmgIrE4jCP0I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jaaXr-00DBDP-48; Mon, 18 May 2020 08:50:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 18 May 2020 08:50:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Anastassios Nanos <ananos@nubificus.co.uk>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <cover.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ananos@nubificus.co.uk, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-18 07:58, Anastassios Nanos wrote:
> To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
> QEMU, or some other kind of VM monitor in user-space to host the vCPU
> threads, I/O threads and various other book-keeping/management 
> mechanisms.
> This is perfectly fine for a large number of reasons and use cases: for
> instance, running generic VMs, running general purpose Operating 
> systems
> that need some kind of emulation for legacy boot/hardware etc.
> 
> What if we wanted to execute a small piece of code as a guest instance,
> without the involvement of user-space? The KVM functions are already 
> doing
> what they should: VM and vCPU setup is already part of the kernel, the 
> only
> missing piece is memory handling.
> 
> With these series, (a) we expose to the Linux Kernel the bare minimum 
> KVM
> API functions in order to spawn a guest instance without the 
> intervention
> of user-space; and (b) we tweak the memory handling code of KVM-related
> functions to account for another kind of guest, spawned in 
> kernel-space.
> 
> PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces 
> the
> changes in the KVM memory handling code for x86_64 and aarch64.
> 
> An example of use is provided based on kvmtest.c
> [https://lwn.net/Articles/658512/] at
> https://github.com/cloudkernels/kvmmtest

You don't explain *why* we would want this. What is the overhead of 
having
a userspace if your guest doesn't need any userspace handling? The 
kvmtest
example indeed shows that the KVM userspace API is usable  without any 
form
of emulation, hence has almost no cost.

Without a clear description of the advantages of your solution, as well
as a full featured in-tree use case, I find it pretty hard to support 
this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
