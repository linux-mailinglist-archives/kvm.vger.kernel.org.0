Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A3B7C45A9
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344207AbjJJXq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjJJXqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:46:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6593
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:46:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-565ece76be4so5378438a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696981612; x=1697586412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5FmO3Xs5F7J7ASiRfJaJgxvmEtofMuf8cd3H6Jj8Oxc=;
        b=sw830k0PL3NMYXRUkHKbfE/Z2t1LjO27Wf0iFri2H5m5fuSKAPh4vXHBjbx1PNzKf+
         KbuhM7Q3ehefFVTpfxhyjWSjQe9U/B7Hep6jVlWAIjIxlMbYE8vZN+cpmJBlvQRDwZjs
         KTpn+KLaz+fJXjs+dUtU/s61qRqDODT+Ldi2GLj6sSchi4Zky6YoLgtn28sPeRPFFTRb
         sIXyY8cOujCColNNZmgAqQOt5QKT4Jwp4nzjLVILDOOxd9yNGohjJOdDb1YsBP6MXRYQ
         DJoAXKDMfXGlKbnI+6XgRiUBTMxAzHC5wMYFld1RuIs/mTEA5CiQtf+E5luV+SWKIgum
         dJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696981612; x=1697586412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5FmO3Xs5F7J7ASiRfJaJgxvmEtofMuf8cd3H6Jj8Oxc=;
        b=Mp8KZaiagT0Ueqp574/0Yc5wYzvOQcHRvTYHCiN3vJF7q7RTJKLOxElOUplTdKt0bL
         IkRuBtRn/R8q6PDla40MG50SgJ3rCGlRsYR/V4VKa22AfM2JjKA+NrhdmVqbx3JFdCo/
         VEzvLFxU4S42hAaHFi9XN+kXUnikRjXMyXsjOuotu0iJ96e1GvMaJbREBk8KV77rmVFd
         /N5AnbGX6gFczhwaX6/csz7C0QjtvFn1A/KV9gNl6lnS08DDs0bfICdsn4d/cazOg1QO
         Mgr9CzI6UG2T3LUzQ+/jt7Y88VdGgKucfh3zHyp7iZ7kZHE0r6x2dX15OF3ji78dZ+z8
         MAbw==
X-Gm-Message-State: AOJu0YxqFhL9WG3PQSHXYXZvMv9M2OdTdLNSTzeB7epNcfHlZ5jSya6J
        1ei+OyO/GxKyuCA7s9JaURZ21ghfI6I=
X-Google-Smtp-Source: AGHT+IEiuH6Qk2FcGVWo/cQAMWRwWWbALoP0091veyMYm/roMpYJGE9BPIxeRJHBqMbF2wCkC3373CK3UMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2955:0:b0:578:eaab:6770 with SMTP id
 bu21-20020a632955000000b00578eaab6770mr313470pgb.0.1696981612064; Tue, 10 Oct
 2023 16:46:52 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:46:50 -0700
In-Reply-To: <20231010072359.0df918e9@kernel.org>
Mime-Version: 1.0
References: <20231006205415.3501535-1-kuba@kernel.org> <ZSQ7z8gqIemJQXI6@google.com>
 <20231009110613.2405ff47@kernel.org> <ZSRVoYbCuDXc7aR7@google.com>
 <20231009144944.17c8eba3@kernel.org> <87sf6i6gzh.fsf@intel.com> <20231010072359.0df918e9@kernel.org>
Message-ID: <ZSXiapPMIPj3ko41@google.com>
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
From:   Sean Christopherson <seanjc@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, Jakub Kicinski wrote:
> On Tue, 10 Oct 2023 11:04:18 +0300 Jani Nikula wrote:
> > > If you do invest in build testing automation, why can't your automation
> > > count warnings rather than depend on WERROR? I don't understand.  
> > 
> > Because having both CI and the subsystem/driver developers enable a
> > local WERROR actually works in keeping the subsystem/driver clean of
> > warnings.
> > 
> > For i915, we also enable W=1 warnings and kernel-doc -Werror with it,
> > keeping all of them warning clean. I don't much appreciate calling that
> > anti-social.
> 
> Anti-social is not the right word, that's fair.
> 
> Werror makes your life easier while increasing the blast radius 
> of your mistakes. So you're trading off your convenience for risk
> of breakage to others. Note that you can fix issues locally very
> quickly and move on. Others have to wait to get your patches thru
> Linus.
> 
> > >> I disagree.  WERROR simply doesn't provide the same coverage.  E.g. it can't be
> > >> enabled for i386 without tuning FRAME_WARN, which (a) won't be at all obvious to
> > >> the average contributor and (b) increasing FRAME_WARN effectively reduces the
> > >> test coverage of KVM i386.
> > >> 
> > >> For KVM x86, I want the rules for contributing to be clearly documented, and as
> > >> simple as possible.  I don't see a sane way to achieve that with WERROR=y.  
> > 
> > The DRM_I915_WERROR config depends on EXPERT and !COMPILE_TEST, and to
> > my knowledge this has never caused issues outside of i915 developers and
> > CI.
> 
> Ack, I think you do it right. I was trying to establish a precedent
> so that we can delete these as soon as they cause an issue, not sooner.

So isn't the underlying problem simply that KVM_WERROR is enabled by default for
some configurations?  If that's the case, then my proposal to make KVM_WERROR
always off by default, and "depends on KVM && EXPERT && !KASAN", would make this
go away, no?
