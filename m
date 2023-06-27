Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5799C74069A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 00:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjF0WpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 18:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0WpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 18:45:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A00269F
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 15:45:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b80c19b3e2so12616285ad.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 15:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687905913; x=1690497913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qQl7WxhCDcJMe6QTdlAGh4IXmTTWyixOnnvB+eyw+fQ=;
        b=mcnfKrfFS5X5dXTkSHwka9NxwdbPhR2fwJhoetdaaPdDRv3X3x7UxugYngfRtoXZ0m
         wa5d2ei3qq/U3rsE5CUP2ZrTgpmFwPEGmiBJRZ9v/j2yhE9OHXXZi3rZinXe4RkSE75U
         XMV+UxEpRvXjN/XAxStB2ZmmFkhDcPUcq5bVVt5Au+3WcRpyRT8jrGU6pz6+VvDqrzCY
         X8mRPUPIn82qA9B/2zZ2twReqldHIOw8zL/QbNUPmwb4aLZwfl2MOI9TBCovCOkTW56X
         ZAZduiLdbuOpLQSdu71hge6YLTPeMvM4+rSz+kxtf1PzXMLIDlMo+E3d/TG9sM6UHzZS
         R6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905913; x=1690497913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQl7WxhCDcJMe6QTdlAGh4IXmTTWyixOnnvB+eyw+fQ=;
        b=d9vB7EY0oHytbkBJt5SYfTuH/ss5ih7Fc7w9Xp7ZsVoxIhEbLv740YN4g18Fm476Se
         2Hovrk1rtUUyAwVDxDD6T2mZAQbtAHuBpop2KGUrW0XKodcWV+U58wmE7/YvzPtNZ6l6
         GFvYu2UEu24CxScGt98Bm+mtbwNpjq/sm9BNuXIJ8g9RCxhcpXK68ImV20d6SfTW1jTV
         Zp13ahturU4NKSOWLIPqn2PSnNXPGMBGuEc3VzJ/Ch4JSKrc7DVvq1bsKsmjhFjC11Km
         yjjjStF8GIUIw/zCdcPytt75xnD/Z5UFGjgem/AgdVDtYb87u1/zGmEz2ZdW7Z6WK1WT
         Iy1Q==
X-Gm-Message-State: AC+VfDwuZuE/dfHWH8pZCjBBVmaqXaFNPitMo0nEy5NJoZhXIpi0oaze
        yQNq57v8Cm8QF0jEwmekdGu0yNBU0YQ=
X-Google-Smtp-Source: ACHHUZ5xQRT54Q3fsm5S2VBg5oxUqBZFQOwEvhmR3gix9ccCGfGpmR1ksoUMpjO5/Z/UmQ1y636i7aos+wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:64d:b0:1b5:32f2:5a7 with SMTP id
 kh13-20020a170903064d00b001b532f205a7mr703788plb.13.1687905913091; Tue, 27
 Jun 2023 15:45:13 -0700 (PDT)
Date:   Tue, 27 Jun 2023 15:45:11 -0700
In-Reply-To: <ZJspu3uS2mirF+4k@google.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com> <20230601142309.6307-4-guang.zeng@intel.com>
 <ZJspu3uS2mirF+4k@google.com>
Message-ID: <ZJtmdxrr2cC+gpVO@google.com>
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Sean Christopherson wrote:
> > +	/*
> > +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
> > +	 * accesses a system data structure. For implicit accesses to system
> > +	 * data structure, the processor acts as if RFLAGS.AC is clear.
> > +	 */
> > +	if (access & PFERR_IMPLICIT_ACCESS) {
> 
> Please don't use PFERR_IMPLICIT_ACCESS, just extend the new flags.  This is
> obviously not coming from a page fault.  PFERR_IMPLICIT_ACCESS really shouldn't
> exist, but at least there was reasonable justification for adding it (changing
> all of the paths that lead to permission_fault() would have require a massive
> overhaul).
> 
> ***HOWEVER***
> 
> I think the entire approach of hooking __linearize() may be a mistake, and LASS
> should instead be implemented in a wrapper of ->gva_to_gpa().  The two calls to
> __linearize() that are escaped with SKIPLASS are escaped *because* they don't
> actually access memory (branch targets and INVLPG), and so if LASS is enforced
> only when ->gva_to_gpa() is invoked, all of these new flags go away because the
> cases that ignore LASS are naturally handled.
> 
> That should also make it unnecessary to add one-off checks since e.g. kvm_handle_invpcid()
> will hit kvm_read_guest_virt() and thus ->gva_to_gpa(), i.e. we won't end up playing
> an ongoing game of whack-a-mole.

Drat, that won't work, at least not without quite a few more changes.

  1. kvm_{read,write,fetch}_guest_virt() are effectively defined to work with a
    fully resolve linear address, i.e. callers assume failure means #PF

  2. Similar to (1), segment information isn't available, i.e. KVM wouldn't know
     when to inject #SS instead of #GP

And IIUC, LASS violations are higher priority than instruction specific alignment
checks, e.g. on CMPXCHG16B.  

And looking at LAM, that untagging needs to be done before the canonical checks,
which means that we'll need at least X86EMUL_F_INVLPG.

So my idea of shoving this into a ->gva_to_gpa() wrapper won't work well.  Bummer.
