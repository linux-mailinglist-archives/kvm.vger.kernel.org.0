Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944ED3499E9
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 20:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhCYTBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 15:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhCYTBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 15:01:07 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D1C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:01:07 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so2975101ote.6
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AI97Rhm27oAU3pmFsCMuigo8bpgh9hq0vsPD+IRPTRU=;
        b=QXo8oH3MYTNT4rHdFRGcVXVXnhWiLnCltyYBMzah6O71VDtJ09gsf+SNL6QLdAM91K
         oo9cud6mBP2PZVWOiDgrvpLZ1qBO/BgudiLi4Q9l75Wi+I5iRNSDlxNvfeq1t0zgRl7A
         Ff2lKSnYxLSVLTxUQWCEYB/gvoAPpy7KCbPAZ5FA2U0bKhchH2xrF90yZiypXbnEsZAC
         4GbPl87QjZcyv9Y3ZG8dTXDqSTO9cxPiEbyTctaCu1YNISymPSYFmyfnqhBkZeKLqyJY
         ZMQEvmodSre9UQi4cs+eBySnvs2sKjUYEh2hdX0cYHtNsdQ4HXGN8mSBZvXYvoiaN5nU
         AL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AI97Rhm27oAU3pmFsCMuigo8bpgh9hq0vsPD+IRPTRU=;
        b=fZPiGdYoh5cTpVzJqAIcWrfdJJwP2K90YbDELBgO0uYNJd37dapfGjhw6iORwsOUd0
         QGc0EfpfhevUdR22aQTntwe7AAd18ImVtBUF4OOyYCJgRGlV4dLnchQPIEisIk7xojOg
         2jcTErI61OXBBlQ6IufzCl8vDLITjiaaIaBCnzpMbI1ixyCkpQpd/pGwYwQovZXRysnj
         aR2vzLIPFNcoVqzTsuNtYv8Wg73Gd6Dii/pzpEEKASUEqK9P8PAv1/ECmUc0iS6mUO4J
         pu4hDkT14gpOiVQebB2fMHSn2Px6BJzNwGZGMWGmED08lt3CNQ5bkpW2IIbKOWbjXTCO
         LUYg==
X-Gm-Message-State: AOAM5301rcrpIhwYLt9hGdDFwVdCu2u2H6ycs8vBgeJ/y811/zASCZUv
        CjI95Itn+5F6DsazV7dWYwDsHBBN/TGyIVpgzwOmnkZVews=
X-Google-Smtp-Source: ABdhPJzhZDWXqHKmULvSmy2BZTEnkNCkFZZT2m6rxr8crGJ3fbDBBScpn9MgSa3ym+7HsxFAxEwjLmjQuWqXm8RGJUo=
X-Received: by 2002:a05:6830:1694:: with SMTP id k20mr1208716otr.241.1616698866340;
 Thu, 25 Mar 2021 12:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com> <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com> <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic> <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic> <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils> <20210325095619.GC31322@zn.tnic>
 <20210325102959.GD31322@zn.tnic> <alpine.LSU.2.11.2103250929110.10977@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2103250929110.10977@eggly.anvils>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 25 Mar 2021 12:00:55 -0700
Message-ID: <CALMp9eRvFRhGRvc5OzqJ1fMWuOVokM0NPiXLi6V8jvEaWp9QEA@mail.gmail.com>
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
To:     Hugh Dickins <hughd@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 9:33 AM Hugh Dickins <hughd@google.com> wrote:
>
> On Thu, 25 Mar 2021, Borislav Petkov wrote:
>
> > Ok,
> >
> > I tried to be as specific as possible in the commit message so that we
> > don't forget. Please lemme know if I've missed something.
> >
> > Babu, Jim, I'd appreciate it if you ran this to confirm.
Tested-by: Jim Mattson <jmattson@google.com>
