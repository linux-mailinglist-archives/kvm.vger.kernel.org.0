Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14CA699CC0
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjBPTAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 14:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjBPTAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 14:00:32 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BC8528AD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 11:00:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a9-20020a25af09000000b0083fa6f15c2fso2851403ybh.16
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 11:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OVUZP7Oz3CFc4JyohlORGNb1nw+7ac5bsRAnU7jTVQc=;
        b=fd1vpUIOY4Ej0D1KIhOBDgWuEqrsLE2sKeEYigwQHzeJA9qh8b7gszfl8HV3+uDUKq
         t/W/DMpaIXhpNdnwCN6zP04Y5zHC66xtuO73mSTdXxRpHG1NCoDkByqLRj8yW/+AdWCe
         3PrBk8KCSVQFqoW5JoytLTAzmZ0cU/0ff5zabP4gZjQGfB4Jm8JDs35dDEO8X8a+cmTl
         hfA5N3vDsyrubwTUPGt+u926hSZ6Uw6CWNufyqpiU4s0Dtx65reJ0Edg2hI4A8zM65kE
         OEOUmgH5HqTuLeNLrVE41hmtDv1SzsmPiVEWyedmdXXypJMn4OG2yb7a6PVie9NlKhv6
         Hk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OVUZP7Oz3CFc4JyohlORGNb1nw+7ac5bsRAnU7jTVQc=;
        b=424ep50LcXyEwH/B1FutMQzSrX/XPxw1OumBQVGh10hKjDTbDgH0aaZUyAOS9VFg81
         pBkwgmz1JohaQFgWXTzZphz5B7fgrnutgLrRsidy3oSP1DAwH/hbZRCK6f4oVkr+x6Wz
         r2r8UhC3MOldpjQ9+BXTbcHDYIOrVVXJ8mOPpbhHD+HE4ZLJG1Q6ANleRg0pbwgrDsu/
         zOfYGL2WDG2hx8RBlow04FObhNB3M2xxn+pJDqelE5fqUooeWtF+dkSZR7j89aGxN0lG
         EN6mq5ZDr0l2CHNgBSV4mSU5upnRfKuY910nOfcjsFTCDO9E6XGgusKroRwxrT1GPdg5
         bqMw==
X-Gm-Message-State: AO0yUKWtZMnCBj1FVBR3QKa4a6xiZbmDSIF4mZ6X6BLut4GF+DkF/i+F
        dv/piw7RTxTr0yiggnehVM/YUn5qu9w=
X-Google-Smtp-Source: AK7set+jlDbQwiCgCNHnVqazKactcZBXLvvVCaSsCv1D4UHy4+Eegb6+4wWhUhIZAInclQsN/BK/y1cQzEI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b403:0:b0:527:65b4:48e9 with SMTP id
 h3-20020a81b403000000b0052765b448e9mr916676ywi.59.1676574015117; Thu, 16 Feb
 2023 11:00:15 -0800 (PST)
Date:   Thu, 16 Feb 2023 11:00:13 -0800
In-Reply-To: <c34b8753-d70b-3d0f-f3b1-c89264642291@redhat.com>
Mime-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
 <Y+5zaeJxKr6hzp4w@google.com> <c34b8753-d70b-3d0f-f3b1-c89264642291@redhat.com>
Message-ID: <Y+59PX7V9qEzpuJh@google.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Gonda <pgonda@google.com>, Sagi Shahar <sagis@google.com>,
        kvm@vger.kernel.org, Erdem Aktas <erdemaktas@google.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, Paolo Bonzini wrote:
> On 2/16/23 19:18, Sean Christopherson wrote:
> > Depending on why the source VM needs to be cleaned up, one thought would be add
> > a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
> > allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
> > mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
> > and memslots, zap all SPTEs, etc...
> 
> If we have to write the code we might as well do it directly at context-move
> time, couldn't we?  I like the idea of minimizing the memory cost of the
> zombie VM.

I thought about that too, but I assume the teardown latency would be non-trivial,
especially if KVM aggressively purges state.  The VMM can't resume the VM until
it knows the migration has completed, so immediately doing the cleanup would impact
the VM's blackout time.

My other thought was to automatically do the cleanup, but to do so asynchronously.
I actually don't know why I discarded that idea.  I think I got distracted and
forgot to circle back.  That might be something we could do for any and all
bugged/dead VMs.
