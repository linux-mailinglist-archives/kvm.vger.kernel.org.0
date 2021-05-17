Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D8386BFD
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhEQVLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 17:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhEQVLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 17:11:16 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B922CC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:09:59 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso6772311otg.9
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZXzjBpH060TfKgMV9HO0m8wzb9qvufrOy43GekKpBE=;
        b=lN9NeEUfBymi0o2lR4Ua/80CWwV31dvX214knq50RE/TO3WySZBgTp7S6P5U+S7Hvt
         cLxtn9ma3zNCo1GUBpsmKpOV9z2hF0gohRXHWm21qFqfAszExVSwD4JfazV+qqGlLAfM
         AvKK9qlK+7ZK/btlgJowVpzwXEnl4FKFy9fgSCGqegUPkDiI0gvvcNKEEa9vSBNjjOtm
         eDmI6YPCopJ9m6ycsQl+b3QqXcpR7iB4PEn5wSoKHcGJ7Sid7YqFuV5hSQWYOmBm+C6i
         cTpEG5KqCrFhVQmPGM/EvN/htrD3AH7+CjNsUOYXtaGboa/E8UW8ewal4qwHsihn5A+9
         5CRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZXzjBpH060TfKgMV9HO0m8wzb9qvufrOy43GekKpBE=;
        b=rCLw5uiz3Geow6ZTKwzqf+Vybb4tIblWQ/Itj1oQe+FIKO92CmS2zkqJQt4GQ4rkMO
         5iPl2AOeeEy789u+302b3BZ7huUOtec2sXrDT0mlbqbSoqXFHbZPSiLZ6zgxenuP/TOO
         qaNAi8gkybUABYvEdssCdJzojCLY+8aPhzY9mn2Vm4OVqH8NvxeCiD5dG80DMNXCoTdR
         7BTv2uLOuBbCXydnfUXJuErDb9cRyF4qU4qzojxdfdpcGY6EtMv5OyZctrgsAuoUDI6p
         jTRDEWnqMf+7z9O+ydAKZ/nAmpuTON0RffZI/Rmoc6/y8tK0UqKrSVO1scYkvGR1/Wqz
         u5Lg==
X-Gm-Message-State: AOAM531II+udOAlOrIkSHzhLjEB6PpjUaxPOHJfSu1QaqncXUo6PoL8L
        xYWJ85xKzZB3ISSNYdPwQl+gWWK9NlOsVA+uGt21qw==
X-Google-Smtp-Source: ABdhPJzCtz9+pKYwBMywqbxQMNIJfAkl+K2uIU4c1CF9GO6gB43CovzGojxgyJeoMeL4pJc+oQZod4znOdqV6FFiTMk=
X-Received: by 2002:a9d:131:: with SMTP id 46mr1241877otu.241.1621285798917;
 Mon, 17 May 2021 14:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210513113710.1740398-1-vkuznets@redhat.com> <20210513113710.1740398-2-vkuznets@redhat.com>
 <YKLaKV5Z+x30iNG9@google.com>
In-Reply-To: <YKLaKV5Z+x30iNG9@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 17 May 2021 14:09:47 -0700
Message-ID: <CALMp9eSR3tAZx3iW4_aVRWtFvVma-NYC979SDG5z3MG-F4M5dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Invert APICv/AVIC enablement check
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 2:03 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, May 13, 2021, Vitaly Kuznetsov wrote:
> > Currently, APICv/AVIC enablement is global ('enable_apicv' module parameter
> > for Intel, 'avic' module parameter for AMD) but there's no way to check
> > it from vendor-neutral code. Add 'apicv_supported()' to kvm_x86_ops and
> > invert kvm_apicv_init() (which now doesn't need to be called from arch-
> > specific code).
>
> Rather than add a new hook, just move the variable to x86.c, and export it so
> that VMX and SVM can give it different module names.  The only hiccup is that
> avic is off by default, but I don't see why that can't be changed.

See https://www.spinics.net/lists/kvm/msg208722.html.
