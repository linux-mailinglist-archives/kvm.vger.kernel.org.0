Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664714FBFD5
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347623AbiDKPJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242472AbiDKPJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:09:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC9E626D
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:07:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bg24so3135060pjb.1
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPdu8Eiipa0SimY9s3UtwwUyWmEESIKixwaOvVsXgGk=;
        b=fPoN4PzXw5Nx0S16GH9zAA+N8qLMX77QH+IQL+Zro+uR5vWA6DYNpt+eA/Uykb4APB
         WvP+K888IGg5bWeBYo6xzTQUKqqbVBwoJjbblyalY/8FU2uumMLDW8eZA4DNwiGrkcYp
         iq7Vxnwr81oH96Y2xMlPpU+ssf9D9N8k900dgevGPB1KYn8kjhx0falLkyj/lzxmvgoc
         i3gBzCLTJeK+qdWEh1ISMXL+z3Vq3FFQM5qu3fYLKHoQ5zj4BCfAcZGDIFUvQT4VerGo
         54eAV4pI3R1ZM+kOS04YHmgAPR16sp8rrRKH1sxuY+UWhexKq7ksyNxSGhPNLKglRrxP
         ZKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPdu8Eiipa0SimY9s3UtwwUyWmEESIKixwaOvVsXgGk=;
        b=oKm/3b45cRKIbBQagKzMnE5Qg8GqfHTNUQkx71kvtKNCnM8BU1BmtuA+GxLtWe3X0b
         5gDBMIOz8qKJl5fWRJ7BhlR9hjotKTodpzVol9gCrfdO+/hTrBj/n7bsHnxd3Tagn4+a
         WFLp7GQhLJn18WNyzf8zIfHbui1Xy0407y4GM3Np9wuJ9kMt0yeVafzqQ0rmmfXHakez
         Qhb4U3gOH0ZFgwnyJpoTqU6dQSLIb5h1MD9Y+3qHeqld2Ir/nmo7alyNAhI4s1PvCAhz
         QFQdywQloUrUR8AncGM5QZ5nFHmUuDbvVv4eF+3H/vtZQR7wnfrn/x92keWcAZSx8uSI
         89eg==
X-Gm-Message-State: AOAM530NE2CNH42nmkz661I4nUOkFj31qjeDXw8jpOxO6+UILJu194zQ
        vjAd+F2VY6Y8pRivAxGNyyJLqA==
X-Google-Smtp-Source: ABdhPJwWxloJ5ZjN13tMopqeMsu31rcmrfB0Bx9G2376e9G0Y6ZGn5Fd+LcgqDo3n2MDJMXUzAYw6A==
X-Received: by 2002:a17:90a:7004:b0:1cb:55d6:9f23 with SMTP id f4-20020a17090a700400b001cb55d69f23mr16547316pjk.187.1649689622903;
        Mon, 11 Apr 2022 08:07:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm22743924pfo.175.2022.04.11.08.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:07:02 -0700 (PDT)
Date:   Mon, 11 Apr 2022 15:06:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>, Peter Gonda <pgonda@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>, maz@kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YlREEillLRjevKA2@google.com>
References: <20220407210233.782250-1-pgonda@google.com>
 <Yk+kNqJjzoJ9TWVH@google.com>
 <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
 <YlBqYcXFiwur3zmo@google.com>
 <20220411091213.GA2120@willie-the-truck>
 <YlQ0LZyAgjGr7qX7@e121798.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlQ0LZyAgjGr7qX7@e121798.cambridge.arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Alexandru Elisei wrote:
> Hi,
>
> On Mon, Apr 11, 2022 at 10:12:13AM +0100, Will Deacon wrote:
> > Hi Sean,
> >
> > Cheers for the heads-up.
> >
> > [+Marc and Alex as this looks similar to [1]]
> >
> > On Fri, Apr 08, 2022 at 05:01:21PM +0000, Sean Christopherson wrote:
> > > system_event.flags is broken (at least on x86) due to the prior 'type' field not
> > > being propery padded, e.g. userspace will read/write garbage if the userspace
> > > and kernel compilers pad structs differently.
> > >
> > >           struct {
> > >                   __u32 type;
> > >                   __u64 flags;
> > >           } system_event;
> >
> > On arm64, I think the compiler is required to put the padding between type
> > and flags so that both the struct and 'flags' are 64-bit aligned [2]. Does
> > x86 not offer any guarantees on the overall structure alignment?
>
> This is also my understanding. The "Procedure Call Standard for the Arm
> 64-bit Architecture" [1] has these rules for structs (called "aggregates"):

AFAIK, all x86 compilers will pad structures accordingly, but a 32-bit userspace
running against a 64-bit kernel will have different alignment requirements, i.e.
won't pad, and x86 supports CONFIG_KVM_COMPAT=y.  And I have no idea what x86's
bizarre x32 ABI does.

> > > Our plan to unhose this is to change the struct as follows and use bit 31 in the
> > > 'type' to indicate that ndata+data are valid.
> > >
> > >           struct {
> > >                         __u32 type;
> > >                   __u32 ndata;
> > >                   __u64 data[16];
> > >                 } system_event;
> > >
> > > Any objection to updating your architectures to use a helper to set the bit and
> > > populate ndata+data accordingly?  It'll require a userspace update, but v5.18
> > > hasn't officially released yet so it's not kinda sort not ABI breakage.
> >
> > It's a bit annoying, as we're using the current structure in Android 13 :/
> > Obviously, if there's no choice then upstream shouldn't worry, but it means
> > we'll have to carry a delta in crosvm. Specifically, the new 'ndata' field
> > is going to be unusable for us because it coincides with the padding.

Yeah, it'd be unusuable for existing types.  One idea is that we could define the
ABI to be that the RESET and SHUTDOWN types have an implicit ndata=1 on arm64 and
RISC-V.  That would allow keeping the flags interpretation and so long as crosvm
doesn't do something stupid like compile with "pragma pack" (does clang even support
that?), there's no delta necessary for Android.

> Just a thought, but wouldn't such a drastical change be better implemented
> as a new exit_reason and a new associated struct?

Maybe?  I wasn't aware that arm64/RISC-V picked up usage of "flags" when I
suggested this, but I'm not sure it would have changed anything.  We could add
SYSTEM_EVENT2 or whatever, but since there's no official usage of flags, it seems
a bit gratutious.
