Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46805A6199
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 08:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfICGh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 02:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfICGh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 02:37:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A54827E422;
        Tue,  3 Sep 2019 06:37:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B68EA1001284;
        Tue,  3 Sep 2019 06:37:23 +0000 (UTC)
Date:   Tue, 3 Sep 2019 08:37:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 02/16] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20190903063721.hzyz7kshwoqnuj5l@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-3-git-send-email-alexandru.elisei@arm.com>
 <20190828144522.qkmckjcmrdayfq7r@kamzik.brq.redhat.com>
 <a2da5efd-b466-3fc2-f8a3-eb9a852f2fdc@arm.com>
 <1ed80409-aaf2-162f-b84a-3c9d88cd8bc8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ed80409-aaf2-162f-b84a-3c9d88cd8bc8@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 03 Sep 2019 06:37:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 02, 2019 at 03:55:48PM +0100, Alexandru Elisei wrote:
> On 8/28/19 4:14 PM, Alexandru Elisei wrote:
> 
> > On 8/28/19 3:45 PM, Andrew Jones wrote:
> >> On Wed, Aug 28, 2019 at 02:38:17PM +0100, Alexandru Elisei wrote:
> >>> The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
> >>> done by setting the entry point for the CPU_ON call to the physical address
> >>> of the C function cpu_psci_cpu_die.
> >>>
> >>> The compiler is well within its rights to use the stack when generating
> >>> code for cpu_psci_cpu_die.  However, because no stack initialization has
> >>> been done, the stack pointer is zero, as set by KVM when creating the VCPU.
> >>> This causes a data abort without a change in exception level. The VBAR_EL1
> >>> register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
> >>> and we end up trying to fetch instructions from address 0x200.
> >>>
> >>> At this point, a stage 2 instruction abort is generated which is taken to
> >>> KVM. KVM interprets this as an instruction fetch from an I/O region, and
> >>> injects a prefetch abort into the guest. Prefetch abort is a synchronous
> >>> exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
> >>> which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
> >>> abort while fetching the instruction to service the said abort.
> >>>
> >>> cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
> >>> provide an assembly implementation for the function which will serve as the
> >>> entry point for CPU_ON.
> >>>
> >>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>> ---
> >>>  arm/cstart.S   | 7 +++++++
> >>>  arm/cstart64.S | 7 +++++++
> >>>  arm/psci.c     | 5 +++--
> >>>  3 files changed, 17 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arm/cstart.S b/arm/cstart.S
> >>> index 114726feab82..5d4fe4b1570b 100644
> >>> --- a/arm/cstart.S
> >>> +++ b/arm/cstart.S
> >>> @@ -7,6 +7,7 @@
> >>>   */
> >>>  #define __ASSEMBLY__
> >>>  #include <auxinfo.h>
> >>> +#include <linux/psci.h>
> >>>  #include <asm/thread_info.h>
> >>>  #include <asm/asm-offsets.h>
> >>>  #include <asm/ptrace.h>
> >>> @@ -138,6 +139,12 @@ secondary_entry:
> >>>  	blx	r0
> >>>  	b	do_idle
> >>>  
> >>> +.global asm_cpu_psci_cpu_die
> >>> +asm_cpu_psci_cpu_die:
> >>> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> >>> +	hvc	#0
> >>> +	b	halt
> >> Shouldn't we load PSCI_POWER_STATE_TYPE_POWER_DOWN into r1 and
> >> zero out r2 and r3, as cpu_psci_cpu_die() does? And maybe we
> >> should just do a 'b .' here instead of 'b halt' in order to
> >> avoid confusion as to how we ended up in halt(), if the psci
> >> invocation were to ever fail.
> > Not really, I'm not really sure where the extra parameter in cpu_psci_cpu_die
> > comes from. I have looked at ARM DEN 0022D, section 5.1.3, and the CPU_OFFcall
> > has exactly one parameter, the function id. I've also looked at how KVM handles
> > this call, and it doesn't use anything else other than the function id. Please
> > correct me if I missed something.
> 
> Did some digging, apparently the power state parameter was required for the very
> first version of PSCI. ARM DEN 0022D states that it has been removed in PSCIv0.2:
> 
> "7.3 Changes in PSCIv0.2 from first proposal
> 
> [..]
> 
> Removed power_state parameter for CPU_OFF."
> 
> The kvm-unit-tests implementation of psci uses fixed function ids (as opposed to
> first psci version, where the ids were taken from the DT), so I think that we
> can drop the PSCI_POWER_STATE_TYPE_POWER_DOWN parameter in cpu_psci_cpu_die
> altogether. What do you think?

Sounds good to me. Thanks for the digging.

drew

> 
> Thanks,
> Alex
> > As for zero'ing the extra registers, this is not part of the SMC calling
> > convention, this is just something that the C code for psci does. The SMC
> > calling convention states that registers 0-3 will be modified after the call, so
> > having 4 arguments to the psci_invoke function will tell the compiler to
> > save/restore the registers in the caller.
> >
> > As for doing 'b .' instead of branching to halt, that's a good idea, I'll do
> > that. But it will only be useful if the last CPU_OFF call fails.
> >
> > Thanks,
> > Alex
