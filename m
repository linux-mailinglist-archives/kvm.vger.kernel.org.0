Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923C7607876
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 15:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiJUNbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 09:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJUNbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 09:31:42 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9312639CC
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:31:37 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b18so3633035ljr.13
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDUhBcAfNoGdnxG5oszokQRes8Xbrb0tEctEqEYIWVM=;
        b=IMju6rHpngmVNILCsj80Ahm46IPzd0gix6kSxPd4dMjE0kWkNqedCVZv+cgD0IpnnS
         /xAxQTGvl8vN7TgGx44fb20K4rVUA84my6D4N7rR3/hL//yQfqIZ54uYhQfR0zSNot8C
         K+SK8f1EdT5RQ1sOCQtfHWCnMU9deTxF8pAvNEm9Ewp9A8psMH7PyWOY3rruGPab2ai4
         MMEQarEJTKasY1diSn4lTWJN03oCH3y6AQCWu2eg77yPDeZ1Tep4HzaKHKEO5jp6mjRq
         JXserd7++TqzHJ7tetmnPsyys0CjgTdtqm7AX357lZ1dHPoVJnt6DeEX11l8QtQT307s
         DrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDUhBcAfNoGdnxG5oszokQRes8Xbrb0tEctEqEYIWVM=;
        b=sQ4fdbov3V9K6Z9HdNDcCDKX1PkLudUGVWK8d2QMuU3RnvL/RxaBEwVqojOCkYb4Sy
         GHbGeEz5ot9jlHwed/snE4GuW4LUSX7uVXDDjZCn1O2AFjk8Sx7w7BGbmEshK7UMtotd
         /5CNEFBma3rf/WGMWKRV6BTsnzEgXM00W6pLeUhQnAIcGcqgk6T0VIcov3AgGkdD6D2J
         J3Lm4y97bD3AOeuxmZyWqiX1ykzelRugspOHaPpjZHlAnRqpuvcOKICXJF5FcPFcjRNc
         HCyl+aymN2aSkmmpGCVWvMvWyxdAwMI2nKehe+sEawMH8RwMU/NCu+YhfIg++St7mc9U
         K6aQ==
X-Gm-Message-State: ACrzQf1M4uCJRdOctB9ti/iK5nVxfX5O+UrBmAbpXedomSdA4cJS957Z
        N91jHgKuLC3UQdRoeNpxM5saU14UG6Damg==
X-Google-Smtp-Source: AMsMyM7Cab67O7Xo8wIiYLjy4ST4Hi30g+dhv00fXCsMdf0yAfBgZXTR51cIpIBBWCMiops/vGtkDg==
X-Received: by 2002:a2e:b16b:0:b0:26e:9408:8301 with SMTP id a11-20020a2eb16b000000b0026e94088301mr6777593ljm.523.1666359095793;
        Fri, 21 Oct 2022 06:31:35 -0700 (PDT)
Received: from [10.43.111.113] ([83.142.187.86])
        by smtp.gmail.com with ESMTPSA id s5-20020a05651c048500b0026fd3f18ac6sm3410029ljc.33.2022.10.21.06.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 06:31:35 -0700 (PDT)
Message-ID: <eaa50a4f-d0af-0aa6-8431-f83e772545f1@semihalf.com>
Date:   Fri, 21 Oct 2022 15:31:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 0/2] KVM: x86/ioapic: Fix oneshot interrupts forwarding
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        "Dong, Eddie" <eddie.dong@intel.com>
References: <20220818202701.3314045-1-dmy@semihalf.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <20220818202701.3314045-1-dmy@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo, Marc, Eric and others,

Did you have a chance to take a look at this v3 patchset?

Just to remind the context: this patchset implements a solution I
proposed in [1], only that it doesn't introduce the additional "pending
oneshot" state (which was Marc's concern in [2]): I realized that this
extra state is not really needed, as we can just unconditionally notify
the resamplefd once again at unmask, with the same end result.

[1] https://lore.kernel.org/kvm/72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com/
[2] https://lore.kernel.org/kvm/87o7wrug0w.wl-maz@kernel.org/

On 8/18/22 22:26, Dmytro Maluka wrote:
> KVM irqfd based emulation of level-triggered interrupts doesn't work
> quite correctly in some cases, particularly in the case of interrupts
> that are handled in a Linux guest as oneshot interrupts (IRQF_ONESHOT).
> Such an interrupt is acked to the device in its threaded irq handler,
> i.e. later than it is acked to the interrupt controller (EOI at the end
> of hardirq), not earlier.
> 
> Linux keeps such interrupt masked until its threaded handler finishes,
> to prevent the EOI from re-asserting an unacknowledged interrupt.
> However, with KVM + vfio (or whatever is listening on the resamplefd)
> we always notify resamplefd at the EOI, so vfio prematurely unmasks the
> host physical IRQ, thus a new physical interrupt is fired in the host.
> This extra interrupt in the host is not a problem per se. The problem is
> that it is unconditionally queued for injection into the guest, so the
> guest sees an extra bogus interrupt. [*]
> 
> There are observed at least 2 user-visible issues caused by those
> extra erroneous interrupts for a oneshot irq in the guest:
> 
> 1. System suspend aborted due to a pending wakeup interrupt from
>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>    every time the touchpad is touched.
> 
> The core issue here is that by the time when the guest unmasks the IRQ,
> the physical IRQ line is no longer asserted (since the guest has
> acked the interrupt to the device in the meantime), yet we
> unconditionally inject the interrupt queued into the guest by the
> previous resampling. So to fix the issue, we need a way to detect that
> the IRQ is no longer pending, and cancel the queued interrupt in this
> case.
> 
> With IOAPIC we are not able to probe the physical IRQ line state
> directly (at least not if the underlying physical interrupt controller
> is an IOAPIC too), so in this patch series we use irqfd resampler for
> that. Namely, instead of injecting the queued interrupt, we just notify
> the resampler that this interrupt is done. If the IRQ line is actually
> already deasserted, we are done. If it is still asserted, a new
> interrupt will be shortly triggered through irqfd and injected into the
> guest.
> 
> In the case if there is no irqfd resampler registered for this IRQ, we
> cannot fix the issue, so we keep the existing behavior: immediately
> unconditionally inject the queued interrupt.
> 
> This patch series fixes the issue for x86 IOAPIC only. In the long run,
> we can fix it for other irqchips and other architectures too, possibly
> taking advantage of reading the physical state of the IRQ line, which is
> possible with some other irqchips (e.g. with arm64 GIC, maybe even with
> the legacy x86 PIC).
> 
> [*] In this description we assume that the interrupt is a physical host
>     interrupt forwarded to the guest e.g. by vfio. Potentially the same
>     issue may occur also with a purely virtual interrupt from an
>     emulated device, e.g. if the guest handles this interrupt, again, as
>     a oneshot interrupt.
> 
> 
> v3:
>   - Completely reworked: instead of postponing resamplefd notify until
>     unmask (to avoid extra interrupts in the host), resample the pending
>     status at unmask to avoid erroneous propagation of those extra
>     interrupts to the guest.
>     Thanks to Marc Zyngier for helping to identify the core issue, which
>     resulted in a simpler and probably more sensible implementation
>     (even though Marc's concern about presenting inaccurate pending
>     status to the guest is a non-issue in the case of IOAPIC, since
>     IOAPIC doesn't present this information anyway).
> 
> v2:
>   - Fixed compilation failure on non-x86: mask_notifier_list moved from
>     x86 "struct kvm_arch" to generic "struct kvm".
>   - kvm_fire_mask_notifiers() also moved from x86 to generic code, even
>     though it is not called on other architectures for now.
>   - Instead of kvm_irq_is_masked() implemented
>     kvm_register_and_fire_irq_mask_notifier() to fix potential race
>     when reading the initial IRQ mask state.
>   - Renamed for clarity:
>       - irqfd_resampler_mask() -> irqfd_resampler_mask_notify()
>       - kvm_irq_has_notifier() -> kvm_irq_has_ack_notifier()
>       - resampler->notifier -> resampler->ack_notifier
>   - Reorganized code in irqfd_resampler_ack() and
>     irqfd_resampler_mask_notify() to make it easier to follow.
>   - Don't follow unwanted "return type on separate line" style for
>     irqfd_resampler_mask_notify().
> 
> Dmytro Maluka (2):
>   KVM: irqfd: Make resampler_list an RCU list
>   KVM: x86/ioapic: Resample the pending state of an IRQ when unmasking
> 
>  arch/x86/kvm/ioapic.c     | 36 ++++++++++++++++++++++++++++--
>  include/linux/kvm_host.h  |  9 ++++++++
>  include/linux/kvm_irqfd.h |  2 +-
>  virt/kvm/eventfd.c        | 47 ++++++++++++++++++++++++++++++++-------
>  4 files changed, 83 insertions(+), 11 deletions(-)
> 
