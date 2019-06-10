Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2773AED2
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 07:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbfFJF5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 01:57:21 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41249 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387667AbfFJF5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 01:57:21 -0400
Received: by mail-oi1-f193.google.com with SMTP id g7so2210575oia.8;
        Sun, 09 Jun 2019 22:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oiOwKSP/ccDns3j0mEFKcTsM+cS+Anm8rfm4zUSLz4c=;
        b=mvi4ka6fEstHc5jivxug7RZ1YQBuPCCCS+NWYISGkZTEWTnZjsQSncSls8F0TBJN6w
         Czhx2hIX9F2yw9/TwS93vrA7Dj6shBxW2OBSnV7rJ4ZkmBgZK8GHuACUhQpbzfC4w5C9
         liQuw64oPnXpreoymw88KdlprGb+38plttb7MZz7Qq/4KLdTTOetbeUN6+oKJk6E7guF
         QuyI2AfoFKsXboxFM1XfMFOOzluhrveGhVxTsRatMoP6KvKQF0QEWTRgqgNZRIVvCFXk
         b47CePJsJHk+ihnjgsMg18ga//oizYuNYLxgd9eufNjWuvdnAt1liECPTzsXA+La1+dj
         54Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oiOwKSP/ccDns3j0mEFKcTsM+cS+Anm8rfm4zUSLz4c=;
        b=URutBlsA9jIM8aWqejSQ1M+6WM2AYmsDMe7KrHWwrSa79axdqV9kBb+tYorNVseOIe
         ZW8mnUR12vfUoOC0qZRdn+9N7ku9ycVaXWH5PQsPJX2edO+W+ITSM1dmiRlVQBTdCxGn
         4GjuotLn4BzjqOS3nhFcRl8UsfN543cS1r4JrzaQb8W6FtH5c1TomHE+r3K2wndCPLKM
         mWnD9DkkjvCuVuW9IQQy0xDy585eBf5q6vnc0h9hoxueKU8A3NWf38Rt4ckG5+5de9af
         00s9jZ3cb6GVQpduycmu5vOzqBAXMJPPdp70yq7Y+BtqAVXHq8X2R1UTL5jt/hNrCwpY
         1omA==
X-Gm-Message-State: APjAAAU0aRHfJjVujvKXyv2fBbggkb6GoEcLG5VM8q0DgWNsv5oOmVkm
        uq3TVzfor+Ki62i7PQLnxqW6nQ16x4eiVeyAjnkEnQ==
X-Google-Smtp-Source: APXvYqxiUNi45JzeMrTmD6aCbVkG3rpaG7jQ2l1DGBIeqNs9IZrt+V4OkCDFIIi+4FeWw4bN+N/M7OWAlVDSdi+C2qA=
X-Received: by 2002:aca:e0d6:: with SMTP id x205mr10698237oig.47.1560146240240;
 Sun, 09 Jun 2019 22:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 Jun 2019 13:58:06 +0800
Message-ID: <CANRm+CwMPcKKwjvG9BridvuSXQNXDZQVJnWY-RNQNZ75vQC0Bg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, :)
On Thu, 30 May 2019 at 09:05, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> yield if any of the IPI target vCPUs was preempted. 17% performance
> increasement of ebizzy benchmark can be observed in an over-subscribe
> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> IPI-many since call-function is not easy to be trigged by userspace
> workload).
>
> v2 -> v3:
>  * add bounds-check on dest_id
>
> v1 -> v2:
>  * check map is not NULL
>  * check map->phys_map[dest_id] is not NULL
>  * make kvm_sched_yield static
>  * change dest_id to unsinged long
>
> Wanpeng Li (3):
>   KVM: X86: Yield to IPI target if necessary
>   KVM: X86: Implement PV sched yield hypercall
>   KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
>
>  Documentation/virtual/kvm/cpuid.txt      |  4 ++++
>  Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h     |  1 +
>  arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
>  arch/x86/kvm/cpuid.c                     |  3 ++-
>  arch/x86/kvm/x86.c                       | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/kvm_para.h            |  1 +
>  7 files changed, 66 insertions(+), 1 deletion(-)
>
> --
> 2.7.4
>
