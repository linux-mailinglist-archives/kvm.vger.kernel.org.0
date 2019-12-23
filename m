Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F912924C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 08:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfLWHje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 02:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfLWHje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 02:39:34 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA23F21775
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 07:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577086773;
        bh=6kUmueKMHGyL/V40p0iccrdydhRADXHFNXNJZT4clQg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R9u5zjk9qts4seFUPL9TdvFghNsWHhCmG2jxgFKh5OocM5d2hhOz58MCNW3P/kfDz
         gKdYfr19ohh0f2/WZUd1Ak523yP9hqGWXwgPszQQJvEFyIVdOqzl6NXL87cmVWVpsz
         7gNgOQNRVMEbAUZbOGy/xyAexl+IcUNZh48VdaVk=
Received: by mail-wr1-f43.google.com with SMTP id w15so2984871wru.4
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2019 23:39:32 -0800 (PST)
X-Gm-Message-State: APjAAAUzZbX17BuGIHa48HidyXjRw52VtdeAzJVCuMp+P1LxACBnnjg0
        n+akYY/M6C+ktTL5OIU0TkEtgyT5JVKX/Zc2IsbjeA==
X-Google-Smtp-Source: APXvYqxZuwX9Kfu1iZ+8NG85u+DEwBb56J2/HAP0R9IPLLT1GVXHQzneFCto1L5SUZFpzh5wj48K2Jwhrb0XcI5fkqk=
X-Received: by 2002:adf:eb09:: with SMTP id s9mr29780361wrn.61.1577086771187;
 Sun, 22 Dec 2019 23:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20191220192701.23415-1-john.s.andersen@intel.com> <20191220192701.23415-3-john.s.andersen@intel.com>
In-Reply-To: <20191220192701.23415-3-john.s.andersen@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 22 Dec 2019 23:39:19 -0800
X-Gmail-Original-Message-ID: <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
Message-ID: <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
Subject: Re: [RESEND RFC 2/2] X86: Use KVM CR pin MSRs
To:     John Andersen <john.s.andersen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 11:27 AM John Andersen
<john.s.andersen@intel.com> wrote:
>
> Strengthen existing control register pinning when running
> paravirtualized under KVM. Check which bits KVM supports pinning for
> each control register and only pin supported bits which are already
> pinned via the existing native protection. Write to KVM CR0 and CR4
> pinned MSRs to enable pinning.
>
> Initiate KVM assisted pinning directly following the setup of native
> pinning on boot CPU. For non-boot CPUs initiate paravirtualized pinning
> on CPU identification.
>
> Identification of non-boot CPUs takes place after the boot CPU has setup
> native CR pinning. Therefore, non-boot CPUs access pinned bits setup by
> the boot CPU and request that those be pinned. All CPUs request
> paravirtualized pinning of the same bits which are already pinned
> natively.
>
> Guests using the kexec system call currently do not support
> paravirtualized control register pinning. This is due to early boot
> code writing known good values to control registers, these values do
> not contain the protected bits. This is due to CPU feature
> identification being done at a later time, when the kernel properly
> checks if it can enable protections.

Is hibernation supported?  How about suspend-to-RAM?

FWIW, I think that handling these details through Kconfig is the wrong
choice.  Distribution kernels should enable this, and they're not
going to turn off kexec.  Arguably kexec should be made to work --
there is no fundamental reason that kexec should need to fiddle with
CR0.WP, for example.  But a boot option could also work as a
short-term option.
