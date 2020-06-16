Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734FD1FBBFE
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgFPQln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbgFPQlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 12:41:42 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B779BC061573
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:41:41 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so2319940iog.0
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgiLLSBGA223H5TAhCSj/hgR01Hlhe8S8Wf2/KW6kvo=;
        b=Dz34/32BNL3fRPgXVmyh382Ts453LNFzg6pWaO+lG/7y4IpLrZO5cPJnUBQf7MGm8q
         h6CmPHJdU/VT6XT0rIr8qzcjDt1xxlMY7tjFC6DoqY8/LsKYOxwVWoQ+PGOCFWibXpPH
         quMmgd8Ji43xjSOhfreGqrpRVaLoCYL+X3HNf50ItsxFtVUzE2c/Ntn2TNJ1RpV1GnfB
         Unml7k5oEVJke9b3uoEjSAnB/bbYE+QppQuYhuFQAjVLWwnDUAEORP2amD26AtEkSJBR
         ggv8hPI8wroyHcprg7iOQTAKokcfRYnCcEMdWBCVqxQJ4uE1A3Pe3sdceMo/C/sb/Q1n
         z+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgiLLSBGA223H5TAhCSj/hgR01Hlhe8S8Wf2/KW6kvo=;
        b=E64L3Z4F2ltdAQ3f864y4VPzeX0Yz2AMnAOqj/3RA4dHITwBW+ysGPEr7z2TVpGQzh
         kcQ3gXxiBMmqVj0f1mT1ftGUFjsT8ky19k864Vr3ZMu7969xMZHvmTvOlpem/fxfuGI1
         qeTdew2ZPFgDv1or8dIaDVS5JB5yq9LPH9K93NY1pCsqdKEUzqz+AOf1zQgiC4aIBvwq
         gUsPwqyxpKblxT3SWUtfy4ib35uaGxcTlBKkTamrZujz4nrayf2Ty7lR5oL2AgjBzP8x
         F4Qir4D147hREOObrcC4cE6fVBMKso50Ys9lJpqHiXT1MR8zAYKVGOzT/iEicWlQE+df
         MnuA==
X-Gm-Message-State: AOAM531qekWBR5ri3Xg0JzDsnRKZUTVZKeQZ+Dj2unNzdgVM3IQycYUw
        9psOeOhL4nsgsXBRX61CIEuw0wTmorgtgdHmvMU6duDtZDA=
X-Google-Smtp-Source: ABdhPJwJJwzHoE6NPuipPgyqZfWjjpU4O9UdIax1EBMqoQKVk3er+lO+1smvpiFw2laMT0nQM2ojwIg9x8UY+CLCpiY=
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr4061778iow.70.1592325700791;
 Tue, 16 Jun 2020 09:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200616073307.16440-1-xiaoyao.li@intel.com> <20200616082042.GE26491@linux.intel.com>
In-Reply-To: <20200616082042.GE26491@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 Jun 2020 09:41:30 -0700
Message-ID: <CALMp9eQLTgUBhZCEj3iY6z0tuWxKQJU=uwndFSHW=uqscoAR8g@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix MSR range of APIC registers in X2APIC mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 1:20 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 16, 2020 at 03:33:07PM +0800, Xiaoyao Li wrote:
> > Only MSR address range 0x800 through 0x8ff is architecturally reserved
> > and dedicated for accessing APIC registers in x2APIC mode.
> >
> > Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
>
> And perhaps more importantly, there are real MSRs that are overlapped,
> e.g. MSR_IA32_TME_ACTIVATE.  This probably warrants a Cc to stable; as you
> found out the hard way, this breaks ignore_msrs.
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Excellent find!

Reviewed-by: Jim Mattson <jmattson@google.com>
