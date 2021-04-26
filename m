Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CA36B3EE
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhDZNRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233638AbhDZNRA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 09:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619442977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q1QoYvHAS2PJHcD4J9inVUs2O0h3REMpAF4YKOpBDCU=;
        b=CJmtbfDHSk3gguxWUaV/WSxd3lfXJGlqcKP76cFDmdTkhf9ugR7yS5ncRtNglkJdbjW/lk
        Wzk+7NgkVG9GZC9XAxeoIFrSnQNbJnmrL1Hv6SFFrMDJLFgWEwhkl45iOV/wIBd7bvoDkM
        fsVvzGyfIrg+aPGwXjVWf8IviN/iHwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-d0pn2xLjOviwd4szRfX5vw-1; Mon, 26 Apr 2021 09:16:13 -0400
X-MC-Unique: d0pn2xLjOviwd4szRfX5vw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7C50343A8;
        Mon, 26 Apr 2021 13:16:10 +0000 (UTC)
Received: from starship (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615C71002EE6;
        Mon, 26 Apr 2021 13:15:54 +0000 (UTC)
Message-ID: <0cfc93405443bed335981ffd5cc07272ffb0ce3a.camel@redhat.com>
Subject: Re: [RFC PATCH 0/6] x86/kvm: Virtual suspend time injection support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Hikaru Nishida <hikalium@chromium.org>, kvm@vger.kernel.org
Cc:     suleiman@google.com, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date:   Mon, 26 Apr 2021 16:15:52 +0300
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-26 at 18:06 +0900, Hikaru Nishida wrote:
> Hi,
> 
> This patch series adds virtual suspend time injection support to KVM.
> 
> Before this change, if the host goes into suspended state while the
> guest is running, the guest will experience a time jump after the host's
> resume. This can confuse some services in the guest since they can't
> detect if the system went into suspend or not by comparing
> CLOCK_BOOTTIME and CLOCK_MONOTONIC.
> 
> To solve this problem, we wanted to add a way to adjust the guest clocks
> without actually suspending the guests. However, there was no way to
> modify a gap between CLOCK_BOOTTIME and CLOCK_MONOTONIC without actually
> suspending the guests. Therefore, this series introduce a new struct
> called kvm_host_suspend_time to share the suspend time between host and
> guest and a mechanism to inject a suspend time to the guest while
> keeping
> monotonicity of the clocks.
> 
> Could you take a look and let me know how we can improve the patches if
> they are doing something wrong?
> 
> Thanks,
> 
> Hikaru Nishida
> 

I haven't yet looked at that, but in my experience when I suspend the host
with VMs running, after resume all my VMs complain something about TSC watchdog
and stop using it. The TSC is stable/synchornized, but after resume it does
reset to 0 on all CPUs.

I use INVTSC flag for all my VMs.
I haven't investigated this futher yet.

Just my 0.2 cents.

Best regards,
	Maxim Levitsky

> 
> 
> Hikaru Nishida (6):
>   x86/kvm: Reserve KVM_FEATURE_HOST_SUSPEND_TIME and
>     MSR_KVM_HOST_SUSPEND_TIME
>   x86/kvm: Add a struct and constants for virtual suspend time injection
>   x86/kvm: Add CONFIG_KVM_VIRT_SUSPEND_TIMING
>   x86/kvm: Add a host side support for virtual suspend time injection
>   x86/kvm: Add CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
>   x86/kvm: Add a guest side support for virtual suspend time injection
> 
>  Documentation/virt/kvm/cpuid.rst     |  3 +
>  Documentation/virt/kvm/msr.rst       | 29 +++++++++
>  arch/x86/Kconfig                     | 13 ++++
>  arch/x86/include/asm/kvm_host.h      |  5 ++
>  arch/x86/include/asm/kvm_para.h      |  9 +++
>  arch/x86/include/uapi/asm/kvm_para.h |  6 ++
>  arch/x86/kernel/kvmclock.c           | 25 ++++++++
>  arch/x86/kvm/Kconfig                 | 13 ++++
>  arch/x86/kvm/cpuid.c                 |  4 ++
>  arch/x86/kvm/x86.c                   | 89 +++++++++++++++++++++++++++-
>  include/linux/kvm_host.h             |  7 +++
>  include/linux/timekeeper_internal.h  |  4 ++
>  kernel/time/timekeeping.c            | 31 ++++++++++
>  13 files changed, 237 insertions(+), 1 deletion(-)
> 


