Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017DF6D8D51
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbjDFCLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbjDFCLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:11:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBD086B8
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:10:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c08fa9387so14296607b3.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680747042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2PHUT0rQsRCKl98D+ei396qKcAOaUvEzjxhev9/awz0=;
        b=tG6XzHdVJ71432eVdUP25+YnEnG9FdFeMcfwzTdv3Y2BXOWH98naheBieeLZMHi12A
         dtVg5SDuXm38W0zBrRcC4xm5H5+wH2yr7sSCyTg+v4hC+acIK+Y7W94PkPiqg5m/80hz
         2FekSGlKN2AYHzcEHvSU8dFcR4c2jzTQytnkXov54YQ8LJZ8qPJGiU477L+FJHichHT6
         BiYwaMoO/jrtcAYfaf2ERFnPt9SAtGYk2KuYzhoQyrB+gB/c1KdSncN2BTF5wiOBfJir
         KZqb2I3PsY96+RslsobuMd0bFSgZyrhsrIJEXo5N1/8lhaQFKbhtOs8Z3IIBS8+zgco9
         +SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680747042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2PHUT0rQsRCKl98D+ei396qKcAOaUvEzjxhev9/awz0=;
        b=0yKgDC3gGuzA9iX77fSk4lYeWy9TCJU/ifPFzCwETNarYw2CKQH5HWpAs7BHWaDUAK
         QV6YF+z3To7Oh79yK5eeRK0rUO40bnXA/0Ex6OkQTQDKI9HdmdU9ZMVRIANPVTX7Iul3
         y/VZ9uQ/dq9is4sc18FG4GeTr4YsgbEZz4kjHNLr5ulj3IMD0lmbp2dlSnUbWLdXTThj
         AnFAdM/BjfuZz27AgBsqokJP6B4O6Q/DGsqGFJLfAGPVtTOc9AbzPmIfe2bpouqYB7So
         l9TgycDpYc3TjWvsv2GEQwRguvuGnrV+lXYKmtUW8yKXeQwsB3+bpCk1uY5EtKL8ajJG
         O+XA==
X-Gm-Message-State: AAQBX9df7y/GgJ2yAyrRxnGH6/QG1+WuDbfOZa5fbUa5r1s8QroGbaDY
        JdGTQDk925y5jkvWDyXT2R4mzm3U4Dk=
X-Google-Smtp-Source: AKy350Y6k6o7U9FrH44tNPlEbBY0HkYDjSLlTUf2GNOfKXF/lpZaHHdIa32elSoxoFDRAR4E3MVR256PQ4o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab67:0:b0:b75:e15a:a91b with SMTP id
 u94-20020a25ab67000000b00b75e15aa91bmr1008780ybi.6.1680747042683; Wed, 05 Apr
 2023 19:10:42 -0700 (PDT)
Date:   Wed, 5 Apr 2023 19:10:40 -0700
In-Reply-To: <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com> <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
Message-ID: <ZC4qF90l77m3X1Ir@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Huang, Kai wrote:
> On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > *** WARNING *** ABI breakage.
> > 
> > Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> > for SGX enclaves.  Past me didn't understand the roles and responsibilities
> > between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> > being helpful by having KVM adjust the entries.
> 
> Actually I am not clear about this topic.
> 
> So the rule is KVM should never adjust CPUID entries passed from userspace?

Yes, except for true runtime entries where a CPUID leaf is dynamic based on other
CPU state, e.g. CR4 bits, MISC_ENABLES in the MONITOR/MWAIT case, etc.

> What if the userspace passed the incorrect CPUID entries?  Should KVM sanitize
> those CPUID entries to ensure there's no insane configuration?  My concern is if
> we allow guest to be created with insane CPUID configurations, the guest can be
> confused and behaviour unexpectedly.

It is userspace's responsibility to provide a sane, correct setup.  The one
exception is that KVM rejects KVM_SET_CPUID{2} if userspace attempts to define an
unsupported virtual address width, the argument being that a malicious userspace
could attack KVM by coercing KVM into stuff a non-canonical address into e.g. a
VMCS field.

The reason for KVM punting to userspace is that it's all but impossible to define
what is/isn't sane.  A really good example would be an alternative we (Google)
considered for the "smaller MAXPHYADDR" fiasco, the underlying problem being that
migrating a vCPU with MAXPHYADDR=46 to a system with MAXPHYADDR=52 will incorrectly
miss reserved bit #PFs.

Rather than teach KVM to try and deal with smaller MAXPHYADDRs, an idea we considered
was to instead enumerate guest.MAXPHYADDR=52 on platforms with host.MAXPHYADDR=46 in
anticipation of eventual migration.  So long as userspace doesn't actually enumerate
memslots in the illegal address space, KVM would be able to treat such accesses as
emulated MMIO, and would only need to intercept #PF(RSVD).

Circling back to "what's sane", enumerating guest.MAXPHYADDR > host.MAXPHYADDR
definitely qualifies as insane since it really can't work correctly, but in our
opinion it was far superior to running with allow_smaller_maxphyaddr=true.

And sane is not the same thing as architecturally legal.  AMX is a good example
of this.  It's _technically_ legal to enumerate support for XFEATURE_TILE_CFG but
not XFEATURE_TILE_DATA in CPUID, but illegal to actually try to enable TILE_CFG
in XCR0 without also enabling TILE_DATA.  KVM should arguably reject CPUID configs
with TILE_CFG but not TILE_DATA, and vice versa, but then KVM is rejecting a 100%
architecturally valid, if insane, CPUID configuration.  Ditto for nearly all of
the VMX control bits versus their CPUID counterparts.

And sometimes there are good reasons to run a VM with a truly insane configuration,
e.g. for testing purposes.

TL;DR: trying to enforce "sane" CPUID/feature configuration is a gigantic can of worms.
