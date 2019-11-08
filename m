Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7FF4589
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 12:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKHLTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 06:19:23 -0500
Received: from foss.arm.com ([217.140.110.172]:40838 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfKHLTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 06:19:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8ADA631B;
        Fri,  8 Nov 2019 03:19:22 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DEB53F719;
        Fri,  8 Nov 2019 03:19:21 -0800 (PST)
Date:   Fri, 8 Nov 2019 12:19:20 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        sean.j.christopherson@intel.com, borntraeger@de.ibm.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Memory regions and VMAs across architectures
Message-ID: <20191108111920.GD17608@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I had a look at our relatively complicated logic in
kvm_arch_prepare_memory_region(), and was wondering if there was room to
unify some of this handling between architectures.

(If you haven't seen our implementation, you can find it in
virt/kvm/arm/mmu.c, and it has lovely ASCII art!)

I then had a look at the x86 code, but that doesn't actually do anything
when creating memory regions, which makes me wonder why the arhitectures
differ in this aspect.

The reason we added the logic that we have for arm/arm64 is that we
don't really want to take faults for I/O accesses.  I'm not actually
sure if this is a corretness thing, or an optimization effort, and the
original commit message doesn't really explain.  Ard, you wrote that
code, do you recall the details?

In any case, what we do is to check for each VMA backing a memslot, we
check if the memslot flags and vma flags are a reasonable match, and we
try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
However, there are some things which are not clear to me:

First, what prevents user space from messing around with the VMAs after
kvm_arch_prepare_memory_region() completes?  If nothing, then what is
the value of the cheks we perform wrt. to VMAs?

Second, why would arm/arm64 need special handling for I/O mappings
compared to other architectures, and how is this dealt with for
x86/s390/power/... ?


Thanks,

    Christoffer
