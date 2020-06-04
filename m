Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3811EECC0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 23:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFDVD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 17:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgFDVDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 17:03:25 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7615BC08C5C1
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 14:03:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p20so7906562iop.11
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 14:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xVcHrfKW+EZLK5WlvWHRmcrAcLbjRGuWUSEv5Qrs1B4=;
        b=SGe6Nt4I1FoJ2ANC8HuzMuezUuGCeu8KucBq8Rf8YAAzjJ4WCCfTCSJDkBTI5MPby7
         olZ3xVaPwehMaSwNyhEU+fpeczpSyIA/hDSC4zLF4GWwLB3nX1siy6Wfqyd5oCZb4tex
         /ziFT9YowW6F6ToyhHZje6eivMjWP1rVKYNzqA84rhlVKpwXUMNxWPgqCfoqSNITOn2i
         0I9nKK0BsJ/fBdtLlHabEsaKunPvKpO8EMC4np1uz2KMOMhc2Rs+fke+5WTlS/fjh4sx
         Mbdx3TTMQ0C+YfPvnrV8GrZ/GJyAoITjJ53BYhYBfzVa7qKrxy5vdZLXzA2PhbQkrv86
         8vsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xVcHrfKW+EZLK5WlvWHRmcrAcLbjRGuWUSEv5Qrs1B4=;
        b=OSlYFQsN3RX//45Os3AB8dS+0fmsY/5n2eyeOcKTUnvSLP8WhJ62AY6+eqdx7is/ag
         2WvK+i5jbmYW5qquAeb+OQxTolRyfLQjBKSu2NUkmNHO+AU0HgBZ7VvR+NKcXJN8ExZY
         jqFWXzKZwcZNQJWdK9xmZI5dX4yPyQtigZVd9pVtbuiJuZ6PR++z/nSde7J+XAv2YPLy
         RADYjqwNJgbU3fVR+YglGGRT4mu6DB4kspdB4OKJBup2iLdSZCDfAaSsdpiDtmiM1/Aa
         8jelM1Xp/tPQUMg1P1xFRADdbejbAaS16MXK7TaDaF3lwHw6cfgfGbw4s3g614y8G8At
         6iuQ==
X-Gm-Message-State: AOAM532MPtUPu0CYNzVnUSq8StzejN18P2i5m+/ylSbIHBnnBnckUo4p
        18lxNQOzD0yu0SF3NA62aB/mNTjP3dHYKRhS4A17Ng==
X-Google-Smtp-Source: ABdhPJydaD55JsS0MoPoYnaMrMN3IUQdB136AuNz0druLAaVYc+jwbiq3WE0o9kEigoUYDae316q2Oi5uZR3js1Jn6s=
X-Received: by 2002:a02:390b:: with SMTP id l11mr6074699jaa.54.1591304603645;
 Thu, 04 Jun 2020 14:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200604161523.39962919@why> <20200604154835.GE30223@linux.intel.com>
 <20200604163532.GE3650@willie-the-truck> <6DBAB6A4-A1F9-40E9-B81B-74182DDCF939@intel.com>
In-Reply-To: <6DBAB6A4-A1F9-40E9-B81B-74182DDCF939@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Jun 2020 14:03:12 -0700
Message-ID: <CALMp9eRN-zkvmkYQ0a600SyLA_0ymznBG8jmriTsYMcXkK77Qg@mail.gmail.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
To:     "Nakajima, Jun" <jun.nakajima@intel.com>
Cc:     Will Deacon <will@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "kernel-team@android.com" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 12:09 PM Nakajima, Jun <jun.nakajima@intel.com> wrot=
e:

> We (Intel virtualization team) are also working on a similar thing, proto=
typing to meet such requirements, i..e "some level of confidentiality to gu=
ests=E2=80=9D. Linux/KVM is the host, and the Kirill=E2=80=99s patches are =
helpful when removing the mappings from the host to achieve memory isolatio=
n of a guest. But, it=E2=80=99s not easy to prove there are no other mappin=
gs.
>
> To raise the level of security, our idea is to de-privilege the host kern=
el just to enforce memory isolation using EPT (Extended Page Table) that vi=
rtualizes guest (the host kernel in this case) physical memory; almost ever=
ything is passthrough. And the EPT for the host kernel excludes the memory =
for the guest(s) that has confidential info. So, the host kernel shouldn=E2=
=80=99t cause VM exits as long as it=E2=80=99s behaving well (CPUID still c=
auses a VM exit, though).

You're Intel. Can't you just change the CPUID intercept from required
to optional? It seems like this should be in the realm of a small
microcode patch.
