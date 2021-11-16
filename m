Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3908B45294F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240622AbhKPFDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbhKPFD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:03:29 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4509C2CAF03;
        Mon, 15 Nov 2021 18:04:44 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id u74so38908247oie.8;
        Mon, 15 Nov 2021 18:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f1YjKGbPVpPYOPNMml3YP7uiAhWXIwrdCnHzJHi0OHQ=;
        b=qmwPAuTYSW2ppDqIctz8Bqk8qFrzONnfT4I8KGigX8vujQQLj2ciXBwmS0NV2Jv0y2
         3GHnVpBC4bYkWm8e2L144llSMZnCEXgOwJr6D6EyPDieY5m8AGhrTVYekUb7kmyfocHB
         35wAgi9mppfY6ObycpUm+s5/fOYXwP5s4QPZ7i8pJTZJhHD9uELeIQi09Eyqfyw8T56n
         lPDZKJlxe0ZW1IPruVWkuMJeyDn/EZH7tUzCDfSRQ0iR9+Q8uO7k2RfupiZ2oOP5MX6G
         MtAI1prv+R+rynebJnuMfpvavtlL3IpGORSfhFY3lLNzzt22UDCq6fC2OhepDHzoHv4X
         s2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f1YjKGbPVpPYOPNMml3YP7uiAhWXIwrdCnHzJHi0OHQ=;
        b=4nE5TeXgexOUJD9PHXbUaNIkZzU/xEi5Y3f4k9pW03nj7NXU/YntyIDA06i7a5lF0V
         WLTw7AFgtGgp0eqX1LwZSPA6yc8BiT6LQdF7qOW3CSHs1qpPBd1h7w2dgh5ATg8fFvmJ
         9QI5tZEU7QdSSKGrHURoyHgcNtFiOFFmmHAd6ESIzdmEow/ntUDhClURcPJj80hizGSC
         c366d8QhHqsXS7HqFrk2bu0mpIXPbMFqeOvayux5HBQ+be2vERGps8gZtWDar7DJAEuj
         AZdNCZzIOx9LINOuOJ2Kq6wXygjH3rq9MPuf7vT0Lhni49khB2xlV/wuoVMQOZvV/Gh7
         oPew==
X-Gm-Message-State: AOAM532JpfhO4M41kwJUlDUaGijuEoTTV4W4Ofd2EQNFAkX05U5kivlC
        YRrlJqo3SuUhyMxGegEicvr3408Lvu7OLF+6hAo=
X-Google-Smtp-Source: ABdhPJxE9fJo0G2IuFj6MnmxmZTPd2Rr6KaYdG4XWXiaul+QW/53GzsSkUbxMwHfUvsMQvadeM71HS96UV7/FhC5X0Q=
X-Received: by 2002:a05:6808:1919:: with SMTP id bf25mr3133612oib.33.1637028284200;
 Mon, 15 Nov 2021 18:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20211108095931.618865-1-huangkele@bytedance.com>
In-Reply-To: <20211108095931.618865-1-huangkele@bytedance.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 16 Nov 2021 10:04:33 +0800
Message-ID: <CANRm+CxoxaiTcQvm98xs1wmxAhq_u5s-PrkF8Lm2-ovVJeFhuw@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
To:     Kele Huang <huangkele@bytedance.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        zhenwei pi <pizhenwei@bytedance.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Nov 2021 at 20:48, Kele Huang <huangkele@bytedance.com> wrote:
>
> Currently, AVIC is disabled if x2apic feature is exposed to guest
> or in-kernel PIT is in re-injection mode.
>
> We can enable AVIC with options:
>
>   Kmod args:
>   modprobe kvm_amd avic=1 nested=0 npt=1
>   QEMU args:
>   ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
>
> When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
> can accelerate IPI operations for guest. However, the relationship
> between AVIC and PV_SEND_IPI feature is not sorted out.
>
> In logical, AVIC accelerates most of frequently IPI operations
> without VMM intervention, while the re-hooking of apic->send_IPI_xxx
> from PV_SEND_IPI feature masks out it. People can get confused
> if AVIC is enabled while getting lots of hypercall kvm_exits
> from IPI.
>
> In performance, benchmark tool
> https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
> shows below results:
>
>   Test env:
>   CPU: AMD EPYC 7742 64-Core Processor
>   2 vCPUs pinned 1:1
>   idle=poll
>
>   Test result (average ns per IPI of lots of running):
>   PV_SEND_IPI   : 1860
>   AVIC          : 1390
>
> Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
> do have some solid performance test results to this.
>
> This patch fixes this by masking out PV_SEND_IPI feature when
> AVIC is enabled in setting up of guest vCPUs' CPUID.

This is the second time in community you bytedance guys post patches
w/o evaluating ipi broadcast performance.
https://lore.kernel.org/all/CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com/T/#u

    Wanpeng
