Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC549414DC6
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhIVQLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 12:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhIVQLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 12:11:21 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B8AC061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:09:50 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id u8so3543878vsp.1
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y71TE4uaFkkTCgI01yco6eKbyLn5X7egv/SHBqUCbDo=;
        b=Fp/svNRP11jh2RubcRL/Oc5832VjhwFnu+3VYEPFZpoUrp6FXwgf1FTjEPy+r804Q7
         s4wZd9opxkvaMwWLrEqKHDLVVgvxKog9BQZEVYERP208JtmrYUDflBcm9CeUnT539XVY
         6Tza5j1HEKMC8ezxC2K4WYRan/BUBy5wEdjbldIyB9k4YGA6y20qQlfIN8oAEmfqCXSp
         P+a50/IeOvLuBpy9+nnYCFtLQSlTMrXupzHEWIyyjVoCQXw6IxMF9hjgcz7TqXNTfyJW
         cwLNpkKiswqF3h6yXa78a6Vg124snU6YXOmO3ccHHKhtVMfZw9eAROHxjp6LFJTUnpIm
         6x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y71TE4uaFkkTCgI01yco6eKbyLn5X7egv/SHBqUCbDo=;
        b=xfnxeMBIYAVFMU+gRxQzJOoIbqVFcxt+iqsrwyqkAQI2rSCjcWhb9Ssxzt+H3exjw1
         9k8ypZAibyVfdTsYXkc4kMKDOaEeJjXg/tCXKdLraaObvA+wOHmFBJHU/RxaffIqkh9R
         WVyFuU+XczFF+a+/o8a7U9q/R5uvLTSLvkDjmHNQbognZm6GfEEE1GOCPkC+eZXl8W4o
         knBujh3w6df912ZaEQZUUCmtDU1JdAL2NAT8r7fjtos+y3MN4iLFtvQx8IOkylrdS2k1
         ydyMGIwoSCKXF1CKpznvhq0gNyHAgHXfFLUh1Pz55AVISmYbjgkuoTiNC0DLcra8R+zb
         1dow==
X-Gm-Message-State: AOAM5327RoNaLediw6+zBNzB4LGQDjjUv2Ew2Ypovb3+ToymP8KLF015
        oQdBx8vsmx8qxBFzWBip9kAHNMvD8/E1kRqvDRzwqQ==
X-Google-Smtp-Source: ABdhPJznyi7GhP02meVTv0+DMN8SZQNTAeHvGStQfXfgJg4o8a31GfYpx1CXw7Kxs7dzh7LBST/hYW3FOzdLEJAMlFI=
X-Received: by 2002:a05:6102:819:: with SMTP id g25mr85488vsb.21.1632326989748;
 Wed, 22 Sep 2021 09:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com> <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
In-Reply-To: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 22 Sep 2021 09:09:37 -0700
Message-ID: <CAAdAUtgrwswfX=YDgNSSOVZDQ8n91LdpL5V_80+NL2Gu9X2Vfw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Paolo,

On Wed, Sep 22, 2021 at 8:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/09/21 13:22, Marc Zyngier wrote:
> > Frankly, this is a job for BPF and the tracing subsystem, not for some
> > hardcoded syndrome accounting. It would allow to extract meaningful
> > information, prevent bloat, and crucially make it optional. Even empty
> > trace points like the ones used in the scheduler would be infinitely
> > better than this (load your own module that hooks into these trace
> > points, expose the data you want, any way you want).
>
> I agree.  I had left out for later the similar series you had for x86,
> but I felt the same as Marc; even just counting the number of
> occurrences of each exit reason is a nontrivial amount of memory to
> spend on each vCPU.
>
> Paolo
>
Thanks for the feedback about this. It is actually kind of what I
expected. The correct way is to add valuable h/w exit reasons which
have been verified useful for debugging and monitoring purposes
instead of exposing all of them blindly.
Will have an internal discussion about the historical reason why those
are needed in the first place and to see if the reason still exists.

Jing
