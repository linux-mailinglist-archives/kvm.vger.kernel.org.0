Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA09487EA2
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiAGVz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 16:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiAGVz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 16:55:27 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E1BC061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 13:55:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id oa15so5332463pjb.4
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 13:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZIAHdwN6aVuhOtNHtulMsqMxfzts5FiRx/1oW6foGcg=;
        b=aswxzkyYIemRGYNZbxtTJ+II2Ws+FGFNEglp6DjMh2vndMV6NotrX33V8p8HsjEb8M
         RQYGxnkJNaeGR8YU6j503IWqHsja6wnCcuXVj6zlOiYpjbc3IYfgUTZTysdSNpJa4Qra
         kuhohAKUJh6SxrmAKTlJzJP8sjBg5ofa0KT6Le2bpRimyB5uBn6/gIrYPSS9g99dX9TB
         OCQAn29FymDJQG3JQKdZeYdVYZNfLNUzx0Nz0Pa2sGokzcyUwvzQHJxEHRLXfsSa/Mq7
         zBfrIbDhTaetR6T3FtjeBdIdAqDFBGKKY8R+IdDkbD9k4ym43ust2SbTlRYidKQLCHiC
         txQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZIAHdwN6aVuhOtNHtulMsqMxfzts5FiRx/1oW6foGcg=;
        b=Nv3fiul6KI8K74SOzAEFFxSs1oOU4MXK6ajUWR/+2R2bQajKy2xws5lbSATpgLHEXu
         knttDGEXTSMwhNkHL9hZHAeKn/LveKtRoHEu2igALntv96YrLEegVQc9I6WFNoV2Wr4s
         lMVCVgKbB3tZCq2mOnlwK5LZnaHAV8/dKgrqYafFmSYM7Z8kWXcIWaN5OatvCeVI0+jP
         kJgF3KRPl62d4jwp7z8+IQXcQYdCGLVFlX4mvJ+bS5TTEfySP9gj7DCsDMefog5XwBgH
         BFGtUku+r5dQ9klxg56oGrC+BPBsxnEzvZTk5xA/SVrGHUVyamRyxkyX83Yi4Tv6adqV
         hp6Q==
X-Gm-Message-State: AOAM531ZZFsh2W99phUwoEU3MKGNhDfrZMwBHBIwQ6FfYC81nFaQdsyP
        bn21MOIcIAuqBRz7gnYznIOuaQ==
X-Google-Smtp-Source: ABdhPJylOgzDMrNkOFKlWvyX1TMN5P422vGLLdTiI0AjjEP8pJEFnTB0KsqT/0zut59WAfg6EktFtA==
X-Received: by 2002:a17:90b:3a92:: with SMTP id om18mr17534522pjb.159.1641592526237;
        Fri, 07 Jan 2022 13:55:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id my5sm7564027pjb.5.2022.01.07.13.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 13:55:25 -0800 (PST)
Date:   Fri, 7 Jan 2022 21:55:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vihas Mak <makvihas@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: move the can_unsync and prefetch checks
 outside of the loop
Message-ID: <Ydi2yTVpPGR9Qb+F@google.com>
References: <20220107082554.32897-1-makvihas@gmail.com>
 <8886415d-f02d-7451-fa8d-4df340182dbc@redhat.com>
 <CAH1kMwSNhQMVLany4u+1tOZpa3KFr93OcwJGhnWN66gKWimaZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH1kMwSNhQMVLany4u+1tOZpa3KFr93OcwJGhnWN66gKWimaZA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 08, 2022, Vihas Mak wrote:
> On Fri, Jan 07, 2022, Sean Christopherson wrote:
> >> NAK, this change is functionally wrong.  The checks are inside the loop because
> >> the flow fails if and only if there is at least one indirect, valid shadow pages
> >> at the target gfn.  The @prefetch check is even more restrictive as it bails if
> >> there is at least one indirect, valid, synchronized shadow page.
> >> The can_unsync check could be "optimized" to
> >>
> >>       if (!can_unsync && kvm_gfn_has_indirect_valid_sp())
> >>
> >> but identifying whether or not there's a valid SP requires walking the list of
> >> shadow pages for the gfn, so it's simpler to just handle the check in the loop.
> >> And "optimized" in quotes because both checks will be well-predicted single-uop
> >> macrofused TEST+Jcc on modern CPUs, whereas walking the list twice would be
> >> relatively expensive if there are shadow pages for the gfn.
> 
> 
> So this change isn't safe. I will look into the optimization suggested
> by Sean. Sorry for this patch.

Heh, I wasn't actually suggesting we do the "optimization".  I was pointing out
what the code would look like _if_ we wanted to move the checks out of the loop,
but I do not actually think we should make any changes, quite the opposite.  The
theoretical worst case if there no indirect valid SPs, but lots of direct and/or
invalid SPs is far worse than burning a few uops per loop.

The compiler is smart enough to handle the checks out of line, and I'm sure there
are other optimizations being made as well.  In other words, odds are very good
that trying to optimize the code will do more harm than good.
