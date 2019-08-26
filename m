Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29E29CBAE
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 10:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbfHZIiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 04:38:09 -0400
Received: from foss.arm.com ([217.140.110.172]:54706 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbfHZIiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 04:38:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FDA528;
        Mon, 26 Aug 2019 01:38:08 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6E3B3F59C;
        Mon, 26 Aug 2019 01:38:07 -0700 (PDT)
Date:   Mon, 26 Aug 2019 10:38:06 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
        kvm <kvm@vger.kernel.org>
Subject: Re: KVM works on RPi4
Message-ID: <20190826083806.GA12352@e113682-lin.lund.arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why>
 <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jan,

On Sun, Jun 30, 2019 at 12:18:59PM +0200, Jan Kiszka wrote:
> On 30.06.19 11:34, Jan Kiszka wrote:
> >On 30.06.19 00:42, Marc Zyngier wrote:
> >>On Sat, 29 Jun 2019 19:09:37 +0200
> >>Jan Kiszka <jan.kiszka@web.de> wrote:
> >>>However, as the Raspberry kernel is not yet ready for 64-bit (and
> >>>upstream is not in sight), I had to use legacy 32-bit mode. And there we
> >>>stumble over the core detection. This little patch made it work, though:
> >>>
> >>>diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> >>>index 2b8de885b2bf..01606aad73cc 100644
> >>>--- a/arch/arm/kvm/guest.c
> >>>+++ b/arch/arm/kvm/guest.c
> >>>@@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
> >>>      case ARM_CPU_PART_CORTEX_A7:
> >>>          return KVM_ARM_TARGET_CORTEX_A7;
> >>>      case ARM_CPU_PART_CORTEX_A15:
> >>>+    case ARM_CPU_PART_CORTEX_A72:
> >>>          return KVM_ARM_TARGET_CORTEX_A15;
> >>>      default:
> >>>          return -EINVAL;
> >>>
> >>>That raises the question if this is hack or a valid change and if there
> >>>is general interest in mapping 64-bit cores on 32-bit if they happen to
> >>>run in 32-bit mode.
> >>
> >>The real thing to do here would be to move to a generic target, much
> >>like we did on the 64bit side. Could you investigate that instead? It
> >>would also allow KVM to be used on other 32bit cores such as
> >>A12/A17/A32.
> >
> >You mean something like KVM_ARM_TARGET_GENERIC_V8? Need to study that...
> >
> 
> Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates, I
> found nothing so far:
> 
> kvm_reset_vcpu:
>         switch (vcpu->arch.target) {
>         case KVM_ARM_TARGET_CORTEX_A7:
>         case KVM_ARM_TARGET_CORTEX_A15:
>                 reset_regs = &cortexa_regs_reset;
>                 vcpu->arch.midr = read_cpuid_id();
>                 break;
> 
> And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just with some
> symbols renamed.
> 
> What's the purpose of all that? Planned for something bigger but never
> implemented? From that perspective, there seems to be no need to arch.target and
> kvm_coproc_target_table at all.
> 

There was some speculation involved here, and we needed to figure out
how we would deal with implementation defined behavior, so we built this
support for each type of CPU etc.

In reality, most CPUs that we support are pretty similar and that's why
we did the generic CPU type instead.  In practice, there might be a more
light-weight appraoch to handling the minor differences between CPU
implementations than what we have here.


Thanks,

    Christoffer
