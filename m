Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388E41B6B9
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbhI1Szh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:55:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhI1Szf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 14:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632855235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BW3DcANbaIeRGt53kKhrZ73VLTbnr1HV+49+aFBS5+U=;
        b=CuwEGvmcDgKE1EpgT1ry3isYV502sc8I8AiVNK6eJQZrUfrQY4AB/8U+LQrB4X7SBOVrwG
        aZyLlsyLfEQh5o71Rdvb7ujj1F7JH8hUox06niUgLz3EqYDT14bz5KO8eIvjkE4+tS34L9
        0Ooz9y0iclNG+nCA/XVp4lrcQjS8vmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-igZCvVubPYCdQeZRJCG22g-1; Tue, 28 Sep 2021 14:53:52 -0400
X-MC-Unique: igZCvVubPYCdQeZRJCG22g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDA36100C660;
        Tue, 28 Sep 2021 18:53:49 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A54C19D9D;
        Tue, 28 Sep 2021 18:53:48 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 82048416CE49; Tue, 28 Sep 2021 15:53:43 -0300 (-03)
Date:   Tue, 28 Sep 2021 15:53:43 -0300
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
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Message-ID: <20210928185343.GA97247@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-5-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 06:15:35PM +0000, Oliver Upton wrote:
> Handling the migration of TSCs correctly is difficult, in part because
> Linux does not provide userspace with the ability to retrieve a (TSC,
> realtime) clock pair for a single instant in time. In lieu of a more
> convenient facility, KVM can report similar information in the kvm_clock
> structure.
> 
> Provide userspace with a host TSC & realtime pair iff the realtime clock
> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
> realtime value, advance the KVM clock by the amount of elapsed time. Do
> not step the KVM clock backwards, though, as it is a monotonic
> oscillator.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++-------
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/x86.c              | 36 +++++++++++++++++++++-------
>  include/uapi/linux/kvm.h        |  7 +++++-
>  4 files changed, 70 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a6729c8cf063..d0b9c986cf6c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -993,20 +993,34 @@ such as migration.
>  When KVM_CAP_ADJUST_CLOCK is passed to KVM_CHECK_EXTENSION, it returns the
>  set of bits that KVM can return in struct kvm_clock_data's flag member.
>  
> -The only flag defined now is KVM_CLOCK_TSC_STABLE.  If set, the returned
> -value is the exact kvmclock value seen by all VCPUs at the instant
> -when KVM_GET_CLOCK was called.  If clear, the returned value is simply
> -CLOCK_MONOTONIC plus a constant offset; the offset can be modified
> -with KVM_SET_CLOCK.  KVM will try to make all VCPUs follow this clock,
> -but the exact value read by each VCPU could differ, because the host
> -TSC is not stable.
> +FLAGS:
> +
> +KVM_CLOCK_TSC_STABLE.  If set, the returned value is the exact kvmclock
> +value seen by all VCPUs at the instant when KVM_GET_CLOCK was called.
> +If clear, the returned value is simply CLOCK_MONOTONIC plus a constant
> +offset; the offset can be modified with KVM_SET_CLOCK.  KVM will try
> +to make all VCPUs follow this clock, but the exact value read by each
> +VCPU could differ, because the host TSC is not stable.
> +
> +KVM_CLOCK_REALTIME.  If set, the `realtime` field in the kvm_clock_data
> +structure is populated with the value of the host's real time
> +clocksource at the instant when KVM_GET_CLOCK was called. If clear,
> +the `realtime` field does not contain a value.
> +
> +KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
> +structure is populated with the value of the host's timestamp counter (TSC)
> +at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
> +does not contain a value.

If the host TSCs are not stable, then KVM_CLOCK_HOST_TSC bit (and
host_tsc field) are ambiguous. Shouldnt exposing them be conditional on 
stable TSC for the host ?

