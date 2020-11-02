Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F164F2A3029
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgKBQnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgKBQnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:43:43 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626FC0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 08:43:42 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c9so8513428wml.5
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 08:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+d818YUCcbVlR/JysJp1RAmAEoaBLjpuG8D8U7SqKQ=;
        b=1Hqt4xIZOLZwyC8O6kYf7k/TFdaN+YLxie4zOSb3Kfz619j9++lDs8+YyskxeHCuVX
         YQpy8FXElZEO13ZXFGmJqPlntw0YuvD6V1gIIHIb62HTf4JyqtmezUJAKXR5JsfPEJ6A
         3cMVkS9NWl1B78Ci3com5rTqA7Izg1vIYtKgZ0R/R/qr+hMJPfu6md2WRoQqYwMWs0ED
         i0ly/SkwfL222dQS6QWV6njxuIfo49TJG8B/xEebzssMx6+2Jn5iaGpcZLwQQjEkACOQ
         IRYAkl/D8ZuWQP3s/mcDVdH490+5d2qhPW1Vio6rY4Va5z6vCeLaJVYm/tKvSW1GB+JL
         y3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+d818YUCcbVlR/JysJp1RAmAEoaBLjpuG8D8U7SqKQ=;
        b=VXzvIX0Yeij+GL9DFkEzeM3eZXYQHlR9bZgR6NE4RcVcx45KMG20N6hjVfcyVM/1vl
         aF4zZDDMr9jUiJ/d59AyWH9tzggMkTuo8gd9xGf08uWLon9S01v47VszxJHuXtQUesBv
         TMs4MshgtsopthjvKqFOysUBRKK1PnNAsdEEaxQ2TZQ5MopwvoF9trKiueAbx/C2RPfi
         6j4kOz8iGcN0omtt77RG/M7g8MZSez4SAL8gL/FMFVObdtAcerRLgN0uxziajuwy0ru6
         cQuhCcyp+F+NWpx+mnTaOkhp+uu3WhPG23t2H1/atrEAnE9AFoR8UndKD/PjcZ10zU+m
         9RAA==
X-Gm-Message-State: AOAM531vHikD+SIo+6n8jYtfPAuG5SVoYVpb/Or0nsByyIHLKSeesAcs
        Jqm67HPPJlaBKYcDRIwKzCA6sXipjsSU8wrTfpEeRA==
X-Google-Smtp-Source: ABdhPJxjeUxDOHDsKgP6AlKH+uqmmUrG2sadDyDN0C4gxRiCaUwNX+0kUmVfTFyDwxdxAfnUxRbbn9lNLGN9VAuwcUc=
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr2496715wmg.49.1604335421664;
 Mon, 02 Nov 2020 08:43:41 -0800 (PST)
MIME-Version: 1.0
References: <20201102061445.191638-1-tao3.xu@intel.com>
In-Reply-To: <20201102061445.191638-1-tao3.xu@intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 2 Nov 2020 08:43:30 -0800
Message-ID: <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Tao Xu <tao3.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>
> There are some cases that malicious virtual machines can cause CPU stuck
> (event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window obviously means no events,
> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
> hardware CPU can't be used by host or other VM.
>
> To resolve those cases, it can enable a notify VM exit if no
> event window occur in VMX non-root mode for a specified amount of
> time (notify window).
>
> Expose a module param for setting notify window, default setting it to
> the time as 1/10 of periodic tick, and user can set it to 0 to disable
> this feature.
>
> TODO:
> 1. The appropriate value of notify window.
> 2. Another patch to disable interception of #DB and #AC when notify
> VM-Exiting is enabled.

Whoa there.

A VM control that says "hey, CPU, if you messed up and livelocked for
a long time, please break out of the loop" is not a substitute for
fixing the livelocks.  So I don't think you get do disable
interception of #DB and #AC.  I also think you should print a loud
warning and have some intelligent handling when this new exit
triggers.

> +static int handle_notify(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> +
> +       /*
> +        * Notify VM exit happened while executing iret from NMI,
> +        * "blocked by NMI" bit has to be set before next VM entry.
> +        */
> +       if (exit_qualification & NOTIFY_VM_CONTEXT_VALID) {
> +               if (enable_vnmi &&
> +                   (exit_qualification & INTR_INFO_UNBLOCK_NMI))
> +                       vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> +                                     GUEST_INTR_STATE_NMI);

This needs actual documentation in the SDM or at least ISE please.
