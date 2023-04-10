Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54EA6DCE14
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjDJXaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 19:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDJXaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 19:30:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F081FC1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2467736a1e0so250257a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681169411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENQIX3T8ZFxG064pag52+qn+mmKF1BPSsOyPJOmvcNs=;
        b=Czw325as9KxJkiOXwRGf1MHXpktzXb9uTyUZJqC1AGiYWHseNVrs7HU/KFBjdZ6zhJ
         9QDAatCngZSY40OjjgN01R3m3MTIvDztDBWbk4Hwqwo/oPjicJL0OsLpUw9e3Sxu1ILw
         oXuj8v9cunaddpUW/5LLkJrLyCCEBgcq9PdqD4jPZnJomoHDobsIKoHb/fBdcaHyBJu+
         IvB7K5pxmExyhrFoLfad/vmnTtIMvpzNB8a2Su+716q8vQLzWoWZI3F/mtf7QtSgKjxI
         gsCUJcQgzbKd6fFgrd5cW7fRZcV7rq0PpFuAQfmM54kf55+7AMwrMeFdcC/e/YoK5ekc
         sLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENQIX3T8ZFxG064pag52+qn+mmKF1BPSsOyPJOmvcNs=;
        b=uFMQANb0oySNPzQk4M/MgbkfWboRrWJ1dgSHXcoY6evk0uF4HvQBiFZ5JxqcY1ycRB
         uTm81WhSbXrJ57sNch1+Ur9viaeV2J9Bazy54srNRU4n+2ILgtUuxo9mT/rMKNBjvhnZ
         QxejerjWGqcGRBAHvSNXr/Xor2zSoyAMHH5tNrgSUlpUahYmMfdqR7JExQOl/pfqEJ0c
         zUsuoGhIU0l9masO018Ya5b9RN3kEwDaWcKW/k1+PgPqAtP3aNqGZQdzSthG2UJAMgq7
         Zl3eVohuF1CIY6aKUcHkV4u4Sg4wBAs+fKPPTZDr0Zp3TI6S1vy47oS1k7PU9QsoAfyu
         9HfA==
X-Gm-Message-State: AAQBX9fmrdvnTAcNizp959zx3iI8Q83jhOO4bA13aC3lt2aMyKXAQgmP
        VAZza+dahQrobHNZkATNJCP4ECLVC5Q=
X-Google-Smtp-Source: AKy350buzQo5a4U0s/1iFh5Jy5w1bYnWDFcsS4fZn3p3m6B7LGO1KvmpEM51aSFJFbs6bbFHxQQvuRZUm+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1383:b0:622:b78d:f393 with SMTP id
 t3-20020a056a00138300b00622b78df393mr4175521pfg.2.1681169411306; Mon, 10 Apr
 2023 16:30:11 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:30:09 -0700
In-Reply-To: <a1ed2308-b521-14c0-a118-19c1afffd1d6@grsecurity.net>
Mime-Version: 1.0
References: <20230405002608.418442-1-seanjc@google.com> <a1ed2308-b521-14c0-a118-19c1afffd1d6@grsecurity.net>
Message-ID: <ZDScAeHJKrZK7KAp@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Refresh CR0.WP prior to checking for
 emulated permission faults
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Apr 05, 2023, Mathias Krause wrote:
> On 05.04.23 02:26, Sean Christopherson wrote:
> > If CR0.WP may be guest-owned, i.e. TDP is enabled, refresh the MMU's
> > snapshot of the guest's CR0.WP prior to checking for permission faults
> > when emulating a guest memory access.  If the guest toggles only CR0.WP
> > and triggers emulation of a supervisor write, e.g. when KVM is emulating
> > UMIP, KVM may consume a stale CR0.WP, i.e. use stale protection bits
> > metadata.
> 
> This reads a little awkward for a non-native speaker.

Heh, I don't think being a non-native English speaker has anything to do with it
being awkward, I also found it confusing when I reread it :-)

I rewrote the changelog to the below when applying.  Holler if it's still weird,
I can easily fixup and force push the changelog.

Thanks!

    Refresh the MMU's snapshot of the vCPU's CR0.WP prior to checking for
    permission faults when emulating a guest memory access and CR0.WP may be
    guest owned.  If the guest toggles only CR0.WP and triggers emulation of
    a supervisor write, e.g. when KVM is emulating UMIP, KVM may consume a
    stale CR0.WP, i.e. use stale protection bits metadata.
    
    Note, KVM passes through CR0.WP if and only if EPT is enabled as CR0.WP
    is part of the MMU role for legacy shadow paging, and SVM (NPT) doesn't
    support per-bit interception controls for CR0.  Don't bother checking for
    EPT vs. NPT as the "old == new" check will always be true under NPT, i.e.
    the only cost is the read of vcpu->arch.cr4 (SVM unconditionally grabs CR0
    from the VMCB on VM-Exit).
