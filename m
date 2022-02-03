Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09014A7CE8
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348580AbiBCAde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbiBCAdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:33:33 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E974DC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:33:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so8481626pjq.0
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KJnqIw1SfOGtIs+5yjTG+Kdvf7r2JviEr5+l/sI/Ib0=;
        b=IaEbeeeL0D037bR6OtcgtGK+yPk02XVVKcQF7TMZu4tljNPVZms2L79dUeXq34Pv1Q
         3jQGo+JkweKkbhT0UtotEzzfOOg0lL3GfLVBxcOjMxOevD6VJFKm5iAsk44l5FoMqTaK
         M5utfc5FE+hoLSH5vt1f6AW4d+DkQ6cPP4bNjonTomdqgDPDLtYmlnq1jmkmMq939cDa
         QXtn2CqpTFuH8rrRSxcJTuk4umJZU/47SjPnP9vYJpbG6hMGTDXxQ0rMdlkjv8FBAG5Z
         s6drFLoIkYlUoUT/dCpt84DpyYF0Zwf3QhpJ1jaY4YKTaZfG188niRDbTxQZslekwpiZ
         4kmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KJnqIw1SfOGtIs+5yjTG+Kdvf7r2JviEr5+l/sI/Ib0=;
        b=be6pUcO2FFLHyUuXpMQiLLEpUKTfUjz1sBdcBUf3QKFz5EnYEkRhSbBzRiekfYHu7l
         c2yBo83azf3SokwXCyX4GifSHk8fxabrKwi3b9gsH2ZEyg3x59hJlD2V2tV73CgqR7/L
         YqSxxpPdKwUMGBMH9uFFZwBVQYsgXVbkHkctr5JYrhl8dGDacETnW6Gcp3ro4hMv4fW1
         jMInnAHnlmGcja3zKa3VHTzlA8Y5lWksngDFDnnOTZXDqaML7Hn1uCBFUnpRdrS8j2jg
         0mTOXizWMkSwLNhFlS16z0Ha/h8X84zcodPe5Ie1M8QO/r+ZMNrsR2kIn1iUfB+BUA4X
         AidQ==
X-Gm-Message-State: AOAM530mfOwsnzVJ1nHCy7ScOZz45RA0/hzX5z5KSu8WGuZxvAZCxJge
        DIBzkk+NA5Va0kmVEQxOdjaofw==
X-Google-Smtp-Source: ABdhPJxEhrgPf/fmH2trSzSYPv1qHP8n5lscyLO08iEXaAtvwwKfx09TgVt5VK4AW5QIi0mHDapjtw==
X-Received: by 2002:a17:903:1209:: with SMTP id l9mr33433012plh.124.1643848413211;
        Wed, 02 Feb 2022 16:33:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u37sm11289400pga.2.2022.02.02.16.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 16:33:32 -0800 (PST)
Date:   Thu, 3 Feb 2022 00:33:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
Message-ID: <Yfsi2dSZ6Ga3SnIh@google.com>
References: <20220202230433.2468479-1-oupton@google.com>
 <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Jim Mattson wrote:
> On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Ultimately, it is the responsibility of userspace to configure an
> > appropriate MSR value for the CPUID it provides its guest. However,
> > there are a few bits in VMX capability MSRs where KVM intervenes. The
> > "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> > IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> > are updated every time userspace sets the guest's CPUID. In so doing,
> > there is an imposed ordering between ioctls, that userspace must set MSR
> > values *after* setting the guest's CPUID.
> 
>  Do you mean *before*?

No, after, otherwise the CPUID updates will override the MSR updates.

MSR_IA32_FEAT_CTL has this same issue.  But that mess also highlights an issue
with this series: if userspace relies on KVM to do the updates, it will break the
existing ABI, e.g. I'm pretty sure older versions of QEMU rely on KVM to adjust
the MSRs.

I agree that KVM should keep its nose out of this stuff, especially since most
VMX controls are technically not architecturally tied to CPUID.  But we probably
need an opt-in from userspace to stop mucking with the MSRs.
