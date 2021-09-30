Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2683641E230
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347072AbhI3TZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 15:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346582AbhI3TZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 15:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633029819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zNOre0trKmNXxzVKIX9EN9wdmLQm4HURP5DLo5E2YLU=;
        b=R0wPB50uqdopIKENYQ8JRQX8FqrfG7ZO1Rs43Ek2xf6lghTK3iG7CaZ1FnYSm+yXlh3Qhz
        LjPR1aI3xIZSEKZceq14JCa8ojGZFX52xpt9HEOVgwlp5wLFqfpl6ycyeXTps23+o+vzsQ
        of1uuLuDAWY5cV/EyR7Cg2NvlViDtKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-wUqJRgtWPdmTb-Ww9-ZBDw-1; Thu, 30 Sep 2021 15:23:35 -0400
X-MC-Unique: wUqJRgtWPdmTb-Ww9-ZBDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06E3518D6A2C;
        Thu, 30 Sep 2021 19:23:33 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 870F36CA2E;
        Thu, 30 Sep 2021 19:23:31 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 108FF416D4AD; Thu, 30 Sep 2021 16:14:16 -0300 (-03)
Date:   Thu, 30 Sep 2021 16:14:16 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <20210930191416.GA19068@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-8-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 06:15:38PM +0000, Oliver Upton wrote:
> To date, VMM-directed TSC synchronization and migration has been a bit
> messy. KVM has some baked-in heuristics around TSC writes to infer if
> the VMM is attempting to synchronize. This is problematic, as it depends
> on host userspace writing to the guest's TSC within 1 second of the last
> write.
> 
> A much cleaner approach to configuring the guest's views of the TSC is to
> simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> and thus not subject to change depending on when the VMM actually
> reads/writes values from/to KVM. The VMM can then read the TSC once with
> KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> the guest is paused.
> 
> Cc: David Matlack <dmatlack@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>


> ---
>  Documentation/virt/kvm/devices/vcpu.rst |  57 ++++++++++++
>  arch/x86/include/asm/kvm_host.h         |   1 +
>  arch/x86/include/uapi/asm/kvm.h         |   4 +
>  arch/x86/kvm/x86.c                      | 110 ++++++++++++++++++++++++
>  4 files changed, 172 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 2acec3b9ef65..3b399d727c11 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -161,3 +161,60 @@ Specifies the base address of the stolen time structure for this VCPU. The
>  base address must be 64 byte aligned and exist within a valid guest memory
>  region. See Documentation/virt/kvm/arm/pvtime.rst for more information
>  including the layout of the stolen time structure.
> +
> +4. GROUP: KVM_VCPU_TSC_CTRL
> +===========================
> +
> +:Architectures: x86
> +
> +4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET
> +
> +:Parameters: 64-bit unsigned TSC offset
> +
> +Returns:
> +
> +	 ======= ======================================
> +	 -EFAULT Error reading/writing the provided
> +		 parameter address.
> +	 -ENXIO  Attribute not supported
> +	 ======= ======================================
> +
> +Specifies the guest's TSC offset relative to the host's TSC. The guest's
> +TSC is then derived by the following equation:
> +
> +  guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET
> +
> +This attribute is useful for the precise migration of a guest's TSC. The
> +following describes a possible algorithm to use for the migration of a
> +guest's TSC:
> +
> +From the source VMM process:
> +
> +1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0),
> +   kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0).
> +
> +2. Read the KVM_VCPU_TSC_OFFSET attribute for every vCPU to record the
> +   guest TSC offset (off_n).
> +
> +3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the
> +   guest's TSC (freq).
> +
> +From the destination VMM process:
> +
> +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock nanoseconds
> +   (k_0) and realtime nanoseconds (r_0) in their respective fields.
> +   Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
> +   structure. KVM will advance the VM's kvmclock to account for elapsed
> +   time since recording the clock values.
> +
> +5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_1) and
> +   kvmclock nanoseconds (k_1).
> +
> +6. Adjust the guest TSC offsets for every vCPU to account for (1) time
> +   elapsed since recording state and (2) difference in TSCs between the
> +   source and destination machine:
> +
> +   new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1

Hi Oliver,

This won't advance the TSC values themselves, right?
This (advancing the TSC values by the realtime elapsed time) would be
awesome because TSC clock_gettime() vdso is faster, and some
applications prefer to just read from TSC directly.
See "x86: kvmguest: use TSC clocksource if invariant TSC is exposed".

The advancement with this patchset only applies to kvmclock.

