Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC948DCD9
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 18:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiAMRVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 12:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiAMRVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 12:21:24 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A64CC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 09:21:24 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x20so437854pgk.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 09:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbtEGzJF4Pri1PYcfPX7asBEf22RcTqncsyblqc+OvY=;
        b=Sl9FnTulo3H/YWpf/aLfhSezCJjNzfPIcyIfQnWaI/T+ls4BqPWyqk0HJpiNM9kBV3
         yGWtR900nHAhsuqatRtea8l3DKjGXWlo8s5kuMoFNZ7F9GpaNNS4XkSbvkXTqsrf2Zt2
         APxjvu6wgUo4v3/0Ed+fzz74FUPs60sq9kEb5Q6U4T6Wfw2sHFVn2yOiqSEIvjuhjNo4
         kuPwFSKBgU+46N6R3bu0BV7BPQos4gfZusOXH4QF94O+R0NhEUt2Q27T1c7bwrI8vByj
         u1niyPmODAf23UyQipBFWfpwwWDFqW/fDcCcLJAKR6WcuHkeCsBMoMFkcTlmmC0+SUbj
         kR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbtEGzJF4Pri1PYcfPX7asBEf22RcTqncsyblqc+OvY=;
        b=d8kHvNhz2rcotJ52CriYdTSxvcd0MiNazHNJUm7NqwNSLtnamk0+/hOiaur+zjCGpN
         mzNS1YlJ4jORZHtc61cQBlY+YdL5WUg+c3Urc1FUqpUeZ7erCD4eWS/aDN+wnYBr/rIY
         qU32B8fiXll4d2XsoH2dr123IDHv8dFE07x/1qoGXVFzib6JiiPEdxDJ//M+OzljQZBW
         jh8hEUSFBLBYvilRsGDXYxFH1KJroYYWZGn3eKRLgiClVrRSL2LO+g7k+bi4MFwFWxC9
         kbmIjByxAsmaUCzO3bDj2R48UYGKbxHfCNo9MXgLMPoH6+DbDs6+SACBrZbAsMly2dtV
         rEDQ==
X-Gm-Message-State: AOAM533PFt9TjgCy2I+cZkgJIpB8X1iAcTy3TG5rmdfwvPS8th+5IftY
        N8lbQcqVeHyo7qgeNyj0KqYHsQ==
X-Google-Smtp-Source: ABdhPJwscB6iGP0ZkbE0k3eKaRnQ7Ca7BDedLEYyrWxbsoa7id33e6ZYFRtTIaHRtcelXaAQ3lqEHA==
X-Received: by 2002:a62:178a:0:b0:4c0:25a5:d389 with SMTP id 132-20020a62178a000000b004c025a5d389mr5156670pfx.1.1642094483546;
        Thu, 13 Jan 2022 09:21:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pi15sm3309892pjb.43.2022.01.13.09.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 09:21:22 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YeBfj89mIf8SezfD@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
> > Perhaps it would help if you explained *why* you are doing this. It
> > sounds like you are either trying to protect against a malicious
> > userspace, or you are trying to keep userspace from doing something
> > stupid. In general, kvm only enforces constraints that are necessary
> > to protect the host. If that's what you're doing, I don't understand
> > why live migration doesn't provide an end-run around your protections.
> It's mainly to safeguard the guests. With respect to migration, KVM
> and the userspace are collectively playing a role here. It's up to the
> userspace to ensure that the registers are configured the same across
> migrations and KVM ensures that the userspace doesn't modify the
> registers after KVM_RUN so that they don't see features turned OFF/ON
> during execution. I'm not sure if it falls into the definition of
> protecting the host. Do you see a value in adding this extra
> protection from KVM?

Short answer: probably not?

There is precedent for disallowing userspace from doing stupid things, but that's
either for KVM's protection (as Jim pointed out), or because KVM can't honor the
change, e.g. x86 is currently in the process of disallowing most CPUID changes
after KVM_RUN because KVM itself consumes the CPUID information and KVM doesn't
support updating some of it's own internal state (because removing features like
GB hugepage support is nonsensical and would require a large pile of complicated,
messy code).

Restricing CPUID changes does offer some "protection" to the guest, but that's
not the goal.  E.g. KVM won't detect CPUID misconfiguration in the migration
case, and trying to do so is a fool's errand.

If restricting updates in the arm64 is necessary to ensure KVM provides sane
behavior, then it could be justified.  But if it's purely a sanity check on
behalf of the guest, then it's not justified.
