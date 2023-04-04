Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80E6D70DE
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbjDDXo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDDXo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:44:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5027C40C8
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:44:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j3-20020a17090a94c300b0024018f0656cso10706360pjw.2
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ibOdHcie65TOdaYolqKBeOIOCBN2xnK/lxtHiVLKRg=;
        b=D0cbfF5463oQYavXBGOPAoU03JWXCv7oA1d9vmwTWLNpGay36PYBPczThyXy+dW4Nm
         5GYungSxRRZI7NWFDx4C98Mw11+GGdk1PaOb7SXExT054gGmTNBXDjhc7ueFcPU/C21u
         Gxu4V7hbV2RWAAaBa7x0XblZU77DqA0yIRuQMv1kRaZK/TVv4dNou9wkvO2sLahvG3oU
         R9mvDfKdJHeKevkb7ZmrGxtDQKh/pQlunDmx9Rdu5swZ/dxWunViYpzpE/Q3JJQAtCx1
         dleYKHRJp9vBz7jewfRxi4e3tCDgtFRvb+GLW6zKC1U+u3kLJULub2/GLeWF9X0cZHLq
         uTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ibOdHcie65TOdaYolqKBeOIOCBN2xnK/lxtHiVLKRg=;
        b=m2UbTtB8HVHjnSjG9L/Zz6c7/4UAIO7dtr/7jcG+oDIFdkbO9NL2O1T7TQaDXYGarU
         SDB8qBffS18Zf0GrdSsA4nJYhbU7OImmkMvXiLtUizqbtdVxEBqpjKksqJUfIYx2YmXn
         n3KCVuzgnmjBMVUoO+4XE4SJyTX2yH47vJeSbJm4MYv3DdG1L11dBItL2fC4fSd4SPEh
         HOXJnN3Pde8diGo7mMU+kyYIl1Nk6i/GCn83OdlQXFASu3cr7ioaC9cqPiyT4T4nQtN2
         8X1P0b/WB86X0XhT+GLLAKwGnsYeaTb5Qze5GpNf50qq2m4Y0fZ3KgZosfVxYID0bc6C
         Ytfw==
X-Gm-Message-State: AAQBX9fn0xKFEBeUB0AVIUR4+0ntCNppUAS2tWWWKabrvq1mFG8pFODw
        jzsCT/rSEILjtKrVbXBfHJ/67M++0F8=
X-Google-Smtp-Source: AKy350YLVlIy62AHHlHk9c8dIx6+nA/udfMbMlrAGOP5kad5hVmc86bqJBDmiDyKgkfAvnqrVeLhIgRP9a4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:18a9:b0:625:659e:65c with SMTP id
 x41-20020a056a0018a900b00625659e065cmr2259311pfh.1.1680651896738; Tue, 04 Apr
 2023 16:44:56 -0700 (PDT)
Date:   Tue,  4 Apr 2023 16:44:36 -0700
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168063705710.272549.18361161670199891767.b4-ty@google.com>
Subject: Re: [PATCH v4 00/13] KVM: x86/mmu: Optimize clear dirty log
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Mar 2023 15:00:08 -0700, Sean Christopherson wrote:
> This is a massaged version of Vipin's series to optimize clearing dirty
> state in the TDP MMU.  It's basically the same as v3, just spread out over
> more patches.  The only meaningful difference in the end is that
> clear_dirty_gfn_range() also gets similar treatment in handling Dirty vs.
> Writable logic.
> 
> Vipin, I'm still planning on applying this for 6.4, but the changes ended
> up being a wee bit bigger than I'm comfortable making on the fly, thus the
> formal posting.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[01/13] KVM: x86/mmu: Add a helper function to check if an SPTE needs atomic write
        https://github.com/kvm-x86/linux/commit/41e07665f1a6
[02/13] KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot
        https://github.com/kvm-x86/linux/commit/5982a5392663
[03/13] KVM: x86/mmu: Consolidate Dirty vs. Writable clearing logic in TDP MMU
        https://github.com/kvm-x86/linux/commit/697c89bed94e
[04/13] KVM: x86/mmu: Atomically clear SPTE dirty state in the clear-dirty-log flow
        https://github.com/kvm-x86/linux/commit/89c313f20c1e
[05/13] KVM: x86/mmu: Drop access tracking checks when clearing TDP MMU dirty bits
        https://github.com/kvm-x86/linux/commit/cf05e8c7325e
[06/13] KVM: x86/mmu: Bypass __handle_changed_spte() when clearing TDP MMU dirty bits
        https://github.com/kvm-x86/linux/commit/1e0f42985ffa
[07/13] KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
        https://github.com/kvm-x86/linux/commit/e73008705d0c
[08/13] KVM: x86/mmu: Clear only A-bit (if enabled) when aging TDP MMU SPTEs
        https://github.com/kvm-x86/linux/commit/7ee131e3a3c3
[09/13] KVM: x86/mmu: Drop unnecessary dirty log checks when aging TDP MMU SPTEs
        https://github.com/kvm-x86/linux/commit/6141df067d04
[10/13] KVM: x86/mmu: Bypass __handle_changed_spte() when aging TDP MMU SPTEs
        https://github.com/kvm-x86/linux/commit/891f11596068
[11/13] KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
        https://github.com/kvm-x86/linux/commit/0b7cc2547d53
[12/13] KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
        https://github.com/kvm-x86/linux/commit/1f9973456e80
[13/13] KVM: x86/mmu: Merge all handle_changed_pte*() functions
        https://github.com/kvm-x86/linux/commit/40fa907e5a69

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
