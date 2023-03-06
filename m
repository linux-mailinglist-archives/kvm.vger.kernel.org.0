Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF66ACC00
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjCFSIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 13:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjCFSHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 13:07:34 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAF436474
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 10:07:05 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e1-20020a17090301c100b0019cd429f407so6287313plh.17
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 10:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678126024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JA2EgeVYcyNXZR8/KWzNk5f1zFVex1Q8EEVzCLntUOA=;
        b=rXu2UX2MOZP+K3v2/DxFczkA+dm8M/6zxin+DO5Kb0/VO32jJNZrPL8XX3I1DPQpM2
         j6/g2xBCW/fkHFXIqUtuWpuODX8Fek9Usf9NX99lLmb2bJ1Dh67HXGdzPSr3y4TiGtto
         73c5nMk+VpndALe3Ho3j7m4idk6qVeIw24gCvlQSI7JjdKbaHT/6zJ2w+CSklhBdJVVm
         Qu6l3lcvX7qhopT3pII/kqRmie6i+hWvSDajaUugvttH+zyxLnA/W8f+BeH5EBaODmIv
         MS3ep1cgJS1GhCFxpvakPdEXO0fkD2HDLZu3lif0bWkK2aqYA75/WyePlDmpu2LCMNgu
         JwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678126024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JA2EgeVYcyNXZR8/KWzNk5f1zFVex1Q8EEVzCLntUOA=;
        b=xj3Rmkw3YyQvXz7VlRoG/7RIHfOSIa+sU2FsBre4ee+dzXinddLcfjWss+GMcpRsnn
         bnoVfR0TTQKgSMyNqlYrSHZv4jVODlishIbK8C/1y2oaLLV/I9xvpfd87r2eLqbVpSgA
         zgH6z2Sj7WJ7m+g09juPM38mSWlOMzM7qIYQ97LWCMtUvimnUDOdS/0hm0Pi3EuHrHhy
         YVsktbrDebYVAuwpY+ATmuODJKZorVGcXldnkOoFQ6X/qBauEbxdCdwnoeN9Vb28g4jf
         LUh4EgScPiS4sn/QJQvK8VoPGvtQuzWSg8Qx/zY6GVFYLyLo+s7RHS/vvPr77satOeeo
         ohYA==
X-Gm-Message-State: AO0yUKUWeyZPKiCoJEyUfjJdPXOv5WDZFPSh2EOyV8MYOhe5e//CRLsv
        5vxSbTpUl0COjBS/g4VC10wyWlhTzMc=
X-Google-Smtp-Source: AK7set/wZSLfN5IYkXdKkBDVF3PBR8UcsgLP68t/Rsa/CD2eXmsoy++FKZDj/g278452ffHBdZtch+0ohks=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bd81:b0:19a:b98f:46a0 with SMTP id
 q1-20020a170902bd8100b0019ab98f46a0mr6811419pls.0.1678126024254; Mon, 06 Mar
 2023 10:07:04 -0800 (PST)
Date:   Mon, 6 Mar 2023 10:07:02 -0800
In-Reply-To: <d26b0ae9-bc72-3cfd-4428-d7760524c218@grsecurity.net>
Mime-Version: 1.0
References: <20230201194604.11135-1-minipli@grsecurity.net> <d26b0ae9-bc72-3cfd-4428-d7760524c218@grsecurity.net>
Message-ID: <ZAYrxvX3gGhHZ4/A@google.com>
Subject: Re: [PATCH v3 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
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

On Mon, Mar 06, 2023, Mathias Krause wrote:
> On 01.02.23 20:45, Mathias Krause wrote:
> > Mathias Krause (5):
> >   KVM: VMX: Avoid retpoline call for control register caused exits
> >   KVM: x86: Do not unload MMU roots when only toggling CR0.WP
> >   KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
> >   KVM: x86/mmu: Fix comment typo
> >   KVM: VMX: Make CR0.WP a guest owned bit
> > 
> > Paolo Bonzini (1):
> >   KVM: x86/mmu: Avoid indirect call for get_cr3
> > 
> >  arch/x86/kvm/kvm_cache_regs.h   |  3 ++-
> >  arch/x86/kvm/mmu/mmu.c          | 31 ++++++++++++++++++++-----------
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
> >  arch/x86/kvm/mmu/spte.c         |  2 +-
> >  arch/x86/kvm/pmu.c              |  4 ++--
> >  arch/x86/kvm/vmx/capabilities.h |  1 +
> >  arch/x86/kvm/vmx/nested.c       |  4 ++--
> >  arch/x86/kvm/vmx/vmx.c          | 15 ++++++++++++---
> >  arch/x86/kvm/vmx/vmx.h          |  8 ++++++++
> >  arch/x86/kvm/x86.c              |  9 +++++++++
> >  10 files changed, 58 insertions(+), 21 deletions(-)
> 
> Ping!
> 
> Anything I can do to help getting this series reviewed and hopefully merged?

I'm slowly getting there...

https://lore.kernel.org/kvm/Y%2Fk+n6HqfLNmmmtM@google.com
