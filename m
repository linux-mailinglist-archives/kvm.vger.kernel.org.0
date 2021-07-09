Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5923C274E
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhGIQLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGIQLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 12:11:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B07CC0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 09:08:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id a2so10415669pgi.6
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 09:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1dWQ88WIQ5IstqaeE3j8DLdXDLPGrHCJiGz4Qh7PYMo=;
        b=Zp85bicnHRb/fW+g5H1Toa/2HMOF4NGgUYu2mej9QYu8TsBbD1BR3dBnpNx7kveneJ
         02xkx5hS3wnbmF03TidqUjrWGVXkR7F0b8ByrjLxoLdJaSc78RK9+N/mXD/OvJ8NCVoM
         9AoIVnIs6NAgnibrzUvOtFezcfKHQLoBd19fKnMH05s4a8/h2Eq/DNTXFU7BfZVtzBZL
         F3JKyj1lT0U2pvyYnWw8FptoUzq0sAatVWpZo0pqxuXM3PFNIeo4Ya0+zaU7XLy67LaN
         /JbEa/Ts0lzc3VHAHFXn6H5Azf+v2+mIdLRPhgrDYVWuoVdYwGotr67F29YZgFYkiVwm
         Cqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1dWQ88WIQ5IstqaeE3j8DLdXDLPGrHCJiGz4Qh7PYMo=;
        b=gJYWhIwn91Yflbb4zeTZs8Y/LFX9kK12F54OEWCbETFsBeENX0yb+ifFxx5rRaL13f
         pC8Ko9WNYLR4UErP/3uwFVjsEHvjFi/fDErcNcMcVG8nfAuOq7c7IN/q17jeGw9KYRja
         pHPo2MoBMk8NmoDniFfTT9wK6eVprcTpQzXJAZs8L7pEz2XltOcZeGWU5C4qG495Tssz
         58yP6VJ1+IhW2bP+amiUQWVHrkCkVZE1oQia/wugscSgY6Udkzx7b3uSzcAzKVQWmpqV
         GZVsqmsuHKL4CuZL6OjvVPxejWgWbT2e0oKLDu7yEznK/11A3m126yllLsuMeLmV34SK
         4p2w==
X-Gm-Message-State: AOAM530h0E/9gbzSQWoO9mq1v28z26HWPKjvxTxRHRIwHGGPeFuK33H+
        vidBf/faV+cp1vquxBxPfgPHog==
X-Google-Smtp-Source: ABdhPJwe0NwkcU86y/qh/DSvobHnOef/XrbaKIMj2PN9WnGn8LqxuTM8bfDZHUN/osucDOuVM4nQvA==
X-Received: by 2002:a63:2d02:: with SMTP id t2mr23416547pgt.114.1625846916318;
        Fri, 09 Jul 2021 09:08:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x10sm7336215pfd.175.2021.07.09.09.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 09:08:35 -0700 (PDT)
Date:   Fri, 9 Jul 2021 16:08:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     David Edmondson <dme@dme.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space on
 emulation failure
Message-ID: <YOh0gNxRJ67Lbo7g@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY2pLoXQ8ePXu0W@google.com>
 <m28s2g51q3.fsf@dme.org>
 <YOdGGuk2trw0h95x@google.com>
 <m2y2ag36od.fsf@dme.org>
 <YOdhhcjXEHUaMIFc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOdhhcjXEHUaMIFc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021, David Matlack wrote:
> On Thu, Jul 08, 2021 at 09:13:38PM +0100, David Edmondson wrote:
> > On Thursday, 2021-07-08 at 18:38:18 UTC, David Matlack wrote:
> > > On Thu, Jul 08, 2021 at 03:17:40PM +0100, David Edmondson wrote:
> > >> I can't cite an example of where this has definitively led in a
> > >> direction that helped solve a problem, but we do sometimes see emulation
> > >> failures reported in situations where we are not able to reproduce the
> > >> failures on demand and the existing information provided at the time of
> > >> failure is either insufficient or suspect.
> > >> 
> > >> Given that, I'm left casting about for data that can be made available
> > >> to assist in postmortem analysis of the failures.
> > >
> > > Understood, thanks for the context. My only concern would be that
> > > userspace APIs are difficult to change once they exist.
> > 
> > Agreed.
> > 
> > > If it turns out knowing the exit reason does not help with debugging
> > > emulation failures we'd still be stuck with exporting it on every
> > > emulation failure.

I can think of multiple cases where knowing why KVM emulated in the first place
would be helpful, e.g. a failure on EPT misconfig (MMIO) exit could be a simple
"drat, KVM doesn't handle SSE instructions", whereas a failure on a descriptor
table exit (for UMIP emulation) would be a completely different mess.
