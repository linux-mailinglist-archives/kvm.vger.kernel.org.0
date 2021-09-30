Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F041E09A
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353070AbhI3SHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 14:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353104AbhI3SHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 14:07:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C0AC06176F
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 11:05:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n2so4596151plk.12
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 11:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YuOwAQkWjXznFXi6rLlMpeEj3pgnoZUS9VAR7tSyz6I=;
        b=YrTTbAhpXtued6yk9uC6PVSQ+GtYLJbkKmrVpJPwt3QklBL2b+uNE8TXilaT/DYofo
         5Ie58IWMhHlTNlQUvr7bSKpZ4Aa9nSPeW3uWcc/UuVk0lQbxlk3eJ11vqlcKtW19ePN7
         lchqwiACnk5e+wUAyBPi+5vGCjBm/OxlsGLpIycw3GkLAK09z9PlzZoJEmx1oQEM6dV1
         19E/sIT5irQ0E7EzW6WXQe0lQ1D3N+hdvAy2L6Bgmic7wWu17g+KtGSqKjf5bqbqS3w5
         XlqGr/D7HrR5xosTtqV7kalARiXpUXKIvqeCM3brW1ojq5kJl3g06KI6uzgAPbnqOKXS
         KkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YuOwAQkWjXznFXi6rLlMpeEj3pgnoZUS9VAR7tSyz6I=;
        b=prz2MNtOev4iNdzucPBbrlh228dnbptNnpDQ3F/6/GwlhGnB0oE7v8w58DxV9uZyyH
         J0GgJaql/g23qd6qIlJ746jxSZfsn0IJK109vCZUAhsQ3Rw32pCkZSJkDjXHLpUTCWD/
         ozuzdgYGR/Wu38qJHILlPBSlUAF1McdJ4SEJjZ53xb2VvRyhMfYa28QRovJk+G+qR17l
         Irc4uaRBqv+3Q8h/phLbE8XDyH2UlM6YwOs92KcwQwQkW86/Qr4X0oqpRGVMgveOY9LF
         Bt1tn/3e00rrYT6dn9OVxHLDbhtFfpjtPDRtJEpbDF043GKt7yVAq2oaJHW8t18AjwEJ
         r5kg==
X-Gm-Message-State: AOAM530TVXzhb4H086VIcQnh/68LjYyhsTPYRSBRyaEeq4PVhiDXZZF0
        +QKP55aoaknl0WvBVuV4eUTJbw==
X-Google-Smtp-Source: ABdhPJwHSsswlwCvX1kziArEs9ci87GuqE1qECOm/i/AFl04pgRGM/ROFtbputz8GVgxVVVUBnO7CA==
X-Received: by 2002:a17:902:868d:b0:13d:dfa7:f3f2 with SMTP id g13-20020a170902868d00b0013ddfa7f3f2mr5590566plo.30.1633025151825;
        Thu, 30 Sep 2021 11:05:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n66sm3845886pfd.21.2021.09.30.11.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 11:05:51 -0700 (PDT)
Date:   Thu, 30 Sep 2021 18:05:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <YVX8e6GdLhhkoZh3@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com>
 <875yusv3vm.wl-maz@kernel.org>
 <CALzav=cuzT=u6G0TCVZUfEgAKOCKTSCDE8x2v5qc-Gd_NL-pzg@mail.gmail.com>
 <87zgrurwgq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgrurwgq.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 00:22:12 +0100, David Matlack <dmatlack@google.com> wrote:
> > 
> > On Wed, Sep 22, 2021 at 11:53 AM Marc Zyngier <maz@kernel.org> wrote:
> > > And I'm all for adding these hooks where it matters as long as they
> > > are not considered ABI and don't appear in /sys/debug/tracing (in
> > > general, no userspace visibility).

On our side (GCP), we very much want these to be ABI so that upgrading the
kernel/KVM doesn't break the userspace collection of stats.

> > > The scheduler is a interesting example of this, as it exposes all sort
> > > of hooks for people to look under the hood. No user of the hook? No
> > > overhead, no additional memory used. I may have heard that Android
> > > makes heavy use of this.
> > >
> > > Because I'm pretty sure that whatever stat we expose, every cloud
> > > vendor will want their own variant, so we may just as well put the
> > > matter in their own hands.
> > 
> > I think this can be mitigated by requiring sufficient justification
> > when adding a new stat to KVM. There has to be a real use-case and it
> > has to be explained in the changelog. If a stat has a use-case for one
> > cloud provider, it will likely be useful to other cloud providers as
> > well.
> 
> My (limited) personal experience is significantly different. The
> diversity of setups make the set of relevant stats pretty hard to
> guess (there isn't much in common if you use KVM to strictly partition
> a system vs oversubscribing it).

To some extent that's true for GCP and x86[*].  I think our position can be
succinctly described as a shotgun approach; we don't know exactly which stats will
be useful when, so grab as many as we can within reason.  As mentioned earlier,
burning 8kb+ of stats per vCPU is perfectly ok for our use cases because it's more
or less negligible compared to the amount of memory assigned to VMs.

This is why I think we should explore an approach that allows for enabling/disabling
groups of stats at compile time. 

[*] For x86 specifically, I think it's a bit easier to predict which stats are
    useful because KVM x86 is responsible for a smaller set of functionality compared
    to arm64, e.g. nearly everything at the system/platform level is handled by
    userspace, and so there are natural exit points to userspace for many of the
    intersesting touch points.  The places where we need stats are where userspace
    doesn't have any visibility into what KVM is doing.

> > > I also wouldn't discount BPF as a possibility. You could perfectly
> > > have permanent BPF programs running from the moment you boot the
> > > system, and use that to generate your histograms. This isn't necessary
> > > a one off, debug only solution.
> > >
> > > > Logging is a similar story, e.g. using _ratelimited() printk to aid
> > > > debug works well when there are a very limited number of VMs and
> > > > there is a human that can react to arbitrary kernel messages, but
> > > > it's basically useless when there are 10s or 100s of VMs and taking
> > > > action on a kernel message requires a prior knowledge of the
> > > > message.
> > >
> > > I'm not sure logging is remotely the same. For a start, the kernel
> > > should not log anything unless something has oopsed (and yes, I still
> > > have some bits to clean on the arm64 side). I'm not even sure what you
> > > would want to log. I'd like to understand the need here, because I
> > > feel like I'm missing something.

I think we're generally on the same page: kernel logging bad.  x86 has historically
used printks to "alert" userspace to notable behavior, e.g. when KVM knowingly
emulates an instruction incorrectly, or when the guest crashes.  The incorrect
instruction emulation isn't all that interesting since we're well aware of KVM's
shortcomings, but guest crashes are an instance where "logging" _to userspace_ is
very desirable, e.g. so that we can identify trends that may be due to bugs in
the host, or to provide the customer with additional data to help them figure out
what's wrong on their end.

"logging" in quotes because it doesn't necessarily have to be traditional logging,
e.g. for the crash cases, KVM already exits to userspace so the "hook" is there,
what's lacking is a way for KVM to dump additional information about the crash.

I brought up logging here purely to highlight that KVM, at least on the x86 side,
lacks infrastructure for running at scale, likely because it hasn't been needed in
the past.

> > > > I'm certainly not expecting other people to solve our challenges,
> > > > and I fully appreciate that there are many KVM users that don't care
> > > > at all about scalability, but I'm hoping we can get the community at
> > > > large, and especially maintainers and reviewers, to also consider
> > > > at-scale use cases when designing, implementing, reviewing, etc...
> > >
> > > My take is that scalability has to go with flexibility. Anything that
> > > gets hardcoded will quickly become a burden: I definitely regret
> > > adding the current KVM trace points, as they don't show what I need,
> > > and I can't change them as they are ABI.
> > 
> > This brings up a good discussion topic: To what extent are the KVM
> > stats themselves an ABI? I don't think this is documented anywhere.
> > The API itself is completely dynamic and does not hardcode a list of
> > stats or metadata about them. Userspace has to read stats fd to see
> > what's there.
> > 
> > Fwiw we just deleted the lpages stat without any drama.
> 
> Maybe the new discoverable interface makes dropping some stats
> easier. But it still remains that what is useless for someone has the
> potential of being crucial for someone else. I wouldn't be surprised
> if someone would ask for this stat back once they upgrade to a recent
> host kernel, probably in a couple of years from now.

lpages is bad example, it wasn't deleted so much as it was replaced by stats for
each page size (4kb, 2mb, 1gb).

I don't think x86 has any (recent) examples of a stat being truly dropped (though
there definitely some that IMO are quite useless).
