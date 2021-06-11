Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83023A4235
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhFKMpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 08:45:15 -0400
Received: from foss.arm.com ([217.140.110.172]:57362 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhFKMpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 08:45:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4245DD6E;
        Fri, 11 Jun 2021 05:43:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95AE53F73D;
        Fri, 11 Jun 2021 05:43:15 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
To:     Fuad Tabba <tabba@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
References: <20210608141141.997398-1-tabba@google.com>
Message-ID: <e32d28f3-4ba6-4b5d-a5a2-7362a4010583@arm.com>
Date:   Fri, 11 Jun 2021 13:44:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 6/8/21 3:11 PM, Fuad Tabba wrote:
> Hi,
>
> This patch series adds support for restricting CPU features for protected VMs
> in KVM [1].
>
> Various feature configurations are allowed in KVM/arm64. Supporting all
> these features in pKVM is difficult, as it either involves moving much of
> the handling code to EL2, which adds bloat and results in a less verifiable
> trusted code base. Or it involves leaving the code handling at EL1, which
> risks having an untrusted host kernel feeding wrong information to the EL2
> and to the protected guests.
>
> This series attempts to mitigate this by reducing the configuration space,
> providing a reduced amount of feature support at EL2 with the least amount of
> compromise of protected guests' capabilities.
>
> This is done by restricting CPU features exposed to protected guests through
> feature registers. These restrictions are enforced by trapping register
> accesses as well as instructions associated with these features, and injecting
> an undefined exception into the guest if it attempts to use a restricted
> feature.
>
> The features being restricted (only for protected VMs in protected mode) are
> the following:
> - Debug, Trace, and DoubleLock
> - Performance Monitoring (PMU)
> - Statistical Profiling (SPE)
> - Scalable Vector Extension (SVE)
> - Memory Partitioning and Monitoring (MPAM)
> - Activity Monitoring (AMU)
> - Memory Tagging (MTE)
> - Limited Ordering Regions (LOR)
> - AArch32 State
> - Generic Interrupt Controller (GIC) (depending on rVIC support)
> - Nested Virtualization (NV)
> - Reliability, Availability, and Serviceability (RAS) above V1
> - Implementation-defined Features
>
> This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> ABI [1]. You can find the applied series here [2].

Since this is implementing the kernel side of an RFC userspace ABI, I'm going to
treat the series as an RFC also and not go into the individual patches.

What strikes me as odd is the fact that, as far as I can tell, you're duplicating
part of the kvm/sys_regs.c and kvm/handle_exit.c functionality in the nvhe code.
Why was this approach chosen instead of reusing the existing functions and adding
extra code to handle the protected VM case?

Another example of this is detecting when a host dropped to 32bit EL0, the comment
says that you don't trust the host to make the check. What exactly do you trust
the host to do at what point? I don't see this explained anywhere, it's possible
I've missed it.

I also think that registers that mostly don't change during the lifetime of the VM
(HCR_EL2, CPTR_EL2, MDCR_EL2) can be set by host when the VM becomes protected,
instead of fiddling with them at each world switch. Was there a particular reason
for changing them in __activate_traps_pvm() or was this just an implementation choice?

Thanks,

Alex

> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
>
> For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> https://www.youtube.com/watch?v=edqJSzsDRxk
>
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
