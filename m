Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595C17AF530
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 22:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjIZU3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 16:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbjIZU3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 16:29:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFB6120
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:29:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2775642edfcso6158983a91.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695760178; x=1696364978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m/X8tLTjtjB3zMNV0glwuPqbMP/KUOmrfpl18E6ncEQ=;
        b=F9KVq8iGQKR4tIqAutdWYEHZuqPPxOlwuiIGCJwnznybeEEXquVi2/qBneTmX0PQk9
         TfLdYuLY8y85Cp8uLJpdSkDYN41waPuDXo/swEquqhBCa2tH2LEsRtxkk8q0r0Ovg+yw
         5npTnlb9OTNfmGLdZI+g6HVbCbmeDO4NxzaRcrTcFfTOgVraDENnNfawCY3qzTWW4OzX
         Q/kP51ZVDuqm22suS25XpKGDtOh4N8+/tXXphRrufj3PLnpYbdPO2XhcdLzNIMqHCI0Q
         OFcYskufvSA+JtPMmVHgedOB/FeRHNdZvj97zQED2NX2kgzcjpFfH4ii0561GKjUlxre
         y3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695760178; x=1696364978;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m/X8tLTjtjB3zMNV0glwuPqbMP/KUOmrfpl18E6ncEQ=;
        b=MES9JRXnQX7FkdnyUIAF7ehLHhmTAvegpkLPQ6f1RhedfFuO9htDjXw3STW6FA7Ypm
         2/YVl38ilvjvrLB2VDo8j1+Xdv9vheiKkt5LXr6u+PJCbvwGI7Ach4/auxTzkoRvneqV
         YRFrRA/I5iiYFpGDXnSrFjkGc8qgUht+zaBAU557g6TGykZuBS6YGDt7SDa2qEb+2nVO
         AuTuYX40oUyqjB2C9uP8UegOXOP3oXFSctTCs/YDLP7TSFcvxDHf2AJzJJNEGmIVCf4w
         jwJ/+Ge5mMXQ3eJse9CjCAF0mMjo585lv3W5y0oqWqkkKMzm32cZC7borb2vpZVQ3yhk
         Qb4w==
X-Gm-Message-State: AOJu0YwRAcAqaY5UoNO56jLb0Q/9U316xhWg9xctqLQnKFe4f24ZPnr2
        HogrGYM57OBS+dSKN3nOwjD8xMzQOMc=
X-Google-Smtp-Source: AGHT+IG+Dh9HlOdZvvXu4dZ2EHXuxcykdQiDN2/YSBv3amFlBAjDEi47ZoYDVzGtagSoDCHXj4GFOc/xSho=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74f:b0:1bd:dcdf:6179 with SMTP id
 p15-20020a170902e74f00b001bddcdf6179mr104882plf.2.1695760177767; Tue, 26 Sep
 2023 13:29:37 -0700 (PDT)
Date:   Tue, 26 Sep 2023 13:29:36 -0700
In-Reply-To: <21C2A5D8-66D9-4EF0-A416-4B1049C91E83@infradead.org>
Mime-Version: 1.0
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <CABgObfZgYXaXqP=6s53=+mYWvOnbgYJiCRct-0ob444sK9SvGw@mail.gmail.com>
 <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org>
 <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com> <d3e0c3e9-4994-4808-a8df-3d23487ff9c4@amazon.de>
 <CABgObfZb4CvzpnSJxz9saw8PJeo1Y2=0uB9y4_K+Cu9P9FpF6g@mail.gmail.com> <21C2A5D8-66D9-4EF0-A416-4B1049C91E83@infradead.org>
Message-ID: <ZRM_MHBpePiAQ__1@google.com>
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else yield
 on MWAIT
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.de>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        Fred Griffoul <fgriffo@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, David Woodhouse wrote:
>=20
>=20
> On 26 September 2023 19:20:24 CEST, Paolo Bonzini <pbonzini@redhat.com> w=
rote:
> >On Sat, Sep 23, 2023 at 6:44=E2=80=AFPM Alexander Graf <graf@amazon.de> =
wrote:
> >> On 23.09.23 11:24, Paolo Bonzini wrote:
> >> > Why do you need it?  You can just use KVM_RUN to go to sleep, and if=
 you
> >> > get another job you kick out the vCPU with pthread_kill.  (I also di=
dn't
> >> > get the VSM reference).
> >>
> >> With the original VSM patches, we used to make a vCPU aware of the fac=
t
> >> that it can morph into one of many VTLs. That approach turned out to b=
e
> >> insanely intrusive and fragile and so we're currently reimplementing
> >> everything as VTLs as vCPUs. That allows us to move the majority of VS=
M
> >> functionality to user space. Everything we've seen so far looks as if
> >> there is no real performance loss with that approach.
> >
> >Yes, that was also what I remember, sharing the FPU somehow while
> >having separate vCPU file descriptors.
> >
> >> One small problem with that is that now user space is responsible for
> >> switching between VTLs: It determines which VTL is currently running a=
nd
> >> leaves all others (read: all other vCPUs) as stopped. That means if yo=
u
> >> are running happily in KVM_RUN in VTL0 and VTL1 gets an interrupt, use=
r
> >> space needs to stop VTL0 and unpause VTL1 until it triggers VTL_RETURN
> >> at which point VTL1 stops execution and VTL0 runs again.
> >
> >That's with IPIs in VTL1, right? I understand now. My idea was, since
> >we need a link from VTL1 to VTL0 for the FPU, to use the same link to
> >trigger a vmexit to userspace if source VTL > destination VTL. I am
> >not sure how you would handle the case where the destination vCPU is
> >not running; probably by detecting the IPI when VTL0 restarts on the
> >destination vCPU?
> >
> >In any case, making vCPUs poll()-able is sensible.
>=20
> Thinking about this a bit more, even for HLT it probably isn't just as si=
mple
> as checking for mp_state changes. If there's a REQ_EVENT outstanding for
> something like a timer delivery, that won't get handled and the IRQ actua=
lly
> delivered to the local APIC until the vCPU is actually *run*, will it?

I haven't been following this conversation, just reacting to seeing "HLT" a=
nd
"mp_state", which is a bit of a mess:

https://lore.kernel.org/all/ZMgIQ5m1jMSAogT4@google.com
