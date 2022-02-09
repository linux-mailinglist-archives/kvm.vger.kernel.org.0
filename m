Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E066C4AEBED
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 09:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240941AbiBIILZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 03:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241565AbiBIILC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 03:11:02 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E896C05CB84;
        Wed,  9 Feb 2022 00:10:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so2957394pfe.4;
        Wed, 09 Feb 2022 00:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=cfZp3UJZbXHdktLhCYrLYq4K/+PuFUiThbNb3DhKy/c=;
        b=obLXTKbKWU4xqyNei8uNwCxDAd5mbv1UTJweu7OIQGC/9PN1bW0txIJXdpsZVO+XnH
         zYE7hC4tCGiHQLQCjgKpq1i4PSA8gd0xfhKTYC9bzZ6EIr6s/o/1r9CnnaVsqHcuNhmC
         9pPwhD7qcjw8bxY2HKzimJWpxNUWJiIflv+S9U4kXbMK/JYAEl1nouxU1LgK0+07ehDw
         TpsRh80bI13KZPy1BAUOhWOGeu0koepuq2cXL+Nx+dAAnK4r3+dgK/Qd88NdXV08+AzP
         urHBpGpENvXuiIOgdUFUwgCFYszZ+sRSBuGRV+tlhsTY9Qagsm74nTG/qE3rfzgxlpgX
         pkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=cfZp3UJZbXHdktLhCYrLYq4K/+PuFUiThbNb3DhKy/c=;
        b=E1y+hMR2d/Ogex+rs7ikjUz6X0Ez984ATWYUrJ4tYch2AlsY9d8ArldME28qpbcIAX
         F4Epo7ID6/rAhQpSjcLUjPS8EuqMt9PZafLnoxDvw+czZkKRB49Pc1sRFBtveiN+JQcn
         uv/b3VkeQYdCn3jQQRNqZB+ruA/trKztq8mstiuZwePrN10eitgNKtsYYsl+4r03xCJj
         0AHKiUxm9Liq7E31yC0GIabsHZ01PzJDNRgmOA72axsvpDH8aEofv37vQBG2H2ajbthx
         46sSV5ozTH+snEY4voXzDZN8LA5FKcm6z0SHYf4ougZ7gDv+EpAQj+SM7OR/58WZ8VAa
         zLQw==
X-Gm-Message-State: AOAM5334nGKiqSJ4XqqifU2gP/4PG+oI6pMFgf7i6lc4MAMPENPsA7q2
        tcOf9nGUglX1OuT6Nj9qkVc=
X-Google-Smtp-Source: ABdhPJyUtsQKzh9+Gm+FAvsNcaGJiuwNcqH8T3oXvrxVddih+gd6SWMeJ4qmGnCf0vHDDrN+EMsszA==
X-Received: by 2002:a63:3804:: with SMTP id f4mr977278pga.454.1644394258845;
        Wed, 09 Feb 2022 00:10:58 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 123sm998800pgd.19.2022.02.09.00.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 00:10:58 -0800 (PST)
Message-ID: <2db2ebbe-e552-b974-fc77-870d958465ba@gmail.com>
Date:   Wed, 9 Feb 2022 16:10:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: KVM: x86: Reconsider the current approach of vPMU
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changed the subject to attract more attention.

On 3/2/2022 6:35 am, Jim Mattson wrote:
> On Wed, Feb 2, 2022 at 6:43 AM Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> Urgh... hate on kvm being a module again. We really need something like
>> EXPORT_SYMBOL_KVM() or something.
> 
> Perhaps we should reconsider the current approach of treating the
> guest as a client of the host perf subsystem via kvm as a proxy. There

The story of vPMU begins with the perf_event_create_kernel_counter()
interface which is a generic API in the kernel mode.

> are several drawbacks to the current approach:
> 1) If the guest actually sets the counter mask (and invert counter
> mask) or edge detect in the event selector, we ignore it, because we
> have no way of requesting that from perf.

We need more guest user cases and voices when it comes to vPMU
capabilities on a case-by-case basis (invert counter mask or edge detect).

KVM may set these bits before vm-entry if it does not affect the host.

> 2) If a system-wide pinned counter preempts one of kvm's thread-pinned
> counters, we have no way of letting the guest know, because the
> architectural specification doesn't allow counters to be suspended.

One such case is NMI watchdog. The truth is that KVM can check the status
of the event before vm-entry to know that the back-end counter has been
rescheduled to another perf user, but can't do anything about it.

I had drafted a vPMU notification patch set to synchronize the status of the
back-end counters to the guest, using the PV method with the help of vPMI.

I'm sceptical about this direction and the efficiency of the notification mechanism
I have designed but I do hope that others have better ideas and quality code.

The number of counters is relatively plenty, but it's a pain in the arse for LBR,
and I may post out a slow path with a high performance cost if you're interested in.

> 3) TDX is going to pull the rug out from under us anyway. When the TDX
> module usurps control of the PMU, any active host counters are going
> to stop counting. We are going to need a way of telling the host perf

I presume that performance counters data of TDX guest is isolated for host,
and host counters (from host perf agent) will not stop and keep counting
only for TDX guests in debug mode.

Off-topic, not all of the capabilities of the core-PMU can or should be
used by TDX guests (given that the behavior of firmware for PMU resource
is constantly changing and not even defined).

> subsystem what's happening, or other host perf clients are going to
> get bogus data.

I predict perf core will be patched to sense (via callback, KVM notifies perf,
smart perf_event running time or host stable TSC diff) and report this kind
of data holes from TDX, SGX, AMD-SEV in the report.

> 
> Given what's coming with TDX, I wonder if we should just bite the
> bullet and cede the PMU to the guest while it's running, even for
> non-TDX guests. That would solve (1) and (2) as well.

The idea of "cede the PMU to the guest" or "vPMU pass-through" is not really
new to us, there are two main obstacles: one is the isolation of NMI paths
(including GLOBAL_* MSRs, like STATUS); the other is avoiding guest sniffing
host data which is a perfect method for guest escape attackers.

At one time, we proposed to statically reserve counters from the host
perf view at guest startup, but this option was NAK-ed from PeterZ.

We may have a chance to reserve counters at the host startup
until we have a guest PMU more friendly hardware design. :D

I'd like to add one more vPMU discussion point: support for
heterogeneous VMX cores (run vPMU on the ADL or later).

The current capability of vPMU depends on which physical CPU
the KVM module is initialized on, and the current upstream
solution brings concerns in terms of vCPU compatibility and migration.

Thanks,
Like Xu
