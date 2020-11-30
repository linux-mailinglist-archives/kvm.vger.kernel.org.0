Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846DC2C89FF
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgK3QzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 11:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgK3QzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 11:55:15 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2ADA207F7
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606755275;
        bh=xKjPWiR+gY9KXoWm0aX1KhLNswrvDKRDlo9bp5YXtCk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ndxg+hCQk/Sj/KPi4tI4cXPYaxWHRfFwCYYNoYYOB6hxuSmCMEP2NOpNxW1ZEzLKf
         gzcrmfHMBHUpnErnTsSP54i292jiBs6L4M/k3GaaCqbLvszpgDr7ZKNX24FniqI+Hg
         JgJy2iB0YA53q7hKOptl5/Qk1vCK0tmSLbfQp94o=
Received: by mail-wm1-f45.google.com with SMTP id f190so22982037wme.1
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 08:54:34 -0800 (PST)
X-Gm-Message-State: AOAM531BOC9cds8Kw1HXy6ELhu8IgTpFBZhRvcG67UYmd3P7VprMKZwe
        8PLZSEcIjLGov74Na3N/wgRZULT7HzTPRA3d3hRHKA==
X-Google-Smtp-Source: ABdhPJxvQRXAXTceQEJTk6eeenanqlUfupxFXmGtTKuBJRp7BePCnRp4Qgf0q/CJ2FQvEGbVK5BGZlC2FWzoi5XyQb0=
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr6905343wmd.49.1606755272947;
 Mon, 30 Nov 2020 08:54:32 -0800 (PST)
MIME-Version: 1.0
References: <20201130133559.233242-1-mlevitsk@redhat.com>
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 30 Nov 2020 08:54:19 -0800
X-Gmail-Original-Message-ID: <CALCETrVr2bM4yJTVpQULN+EYVQJuWGCvjX0SMFsCRy6BwqZc0w@mail.gmail.com>
Message-ID: <CALCETrVr2bM4yJTVpQULN+EYVQJuWGCvjX0SMFsCRy6BwqZc0w@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30, 2020 at 5:36 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> Hi!
>
> This is the first version of the work to make TSC migration more accurate,
> as was defined by Paulo at:
> https://www.spinics.net/lists/kvm/msg225525.html
>
> I have a few thoughts about the kvm masterclock synchronization,
> which relate to the Paulo's proposal that I implemented.
>
> The idea of masterclock is that when the host TSC is synchronized
> (or as kernel call it, stable), and the guest TSC is synchronized as well,
> then we can base the kvmclock, on the same pair of
> (host time in nsec, host tsc value), for all vCPUs.
>
> This makes the random error in calculation of this value invariant
> across vCPUS, and allows the guest to do kvmclock calculation in userspace
> (vDSO) since kvmclock parameters are vCPU invariant.
>
> To ensure that the guest tsc is synchronized we currently track host/guest tsc
> writes, and enable the master clock only when roughly the same guest's TSC value
> was written across all vCPUs.
>
> Recently this was disabled by Paulo and I agree with this, because I think
> that we indeed should only make the guest TSC synchronized by default
> (including new hotplugged vCPUs) and not do any tsc synchronization beyond that.
> (Trying to guess when the guest syncs the TSC can cause more harm that good).
>
> Besides, Linux guests don't sync the TSC via IA32_TSC write,
> but rather use IA32_TSC_ADJUST which currently doesn't participate
> in the tsc sync heruistics.
> And as far as I know, Linux guest is the primary (only?) user of the kvmclock.
>
> I *do think* however that we should redefine KVM_CLOCK_TSC_STABLE
> in the documentation to state that it only guarantees invariance if the guest
> doesn't mess with its own TSC.
>
> Also I think we should consider enabling the X86_FEATURE_TSC_RELIABLE
> in the guest kernel, when kvm is detected to avoid the guest even from trying
> to sync TSC on newly hotplugged vCPUs.
>
> (The guest doesn't end up touching TSC_ADJUST usually, but it still might
> in some cases due to scheduling of guest vCPUs)
>
> (X86_FEATURE_TSC_RELIABLE short circuits tsc synchronization on CPU hotplug,
> and TSC clocksource watchdog, and the later we might want to keep).

If you're going to change the guest behavior to be more trusting of
the host, I think
the host should probably signal this to the guest using a new bit.
