Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281F36D8D54
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbjDFCL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjDFCL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:11:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0647559F9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:11:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j62-20020a638b41000000b005142ec64642so1209078pge.19
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680747077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA3lDPjhvFiBmDOPalF3zTKr7ivZUHMdU3+5uyp30dE=;
        b=c4yhP+kcITRix0pLhRDCVxeDdsbODPWLUNNHm6zQMthv1cGSbFQ0B920lnJmq/yrwY
         tcbSjR7i/tx6yNkWH23MrNqIiAoDeM90g+6gzC7vgDS3osKZ1V9uvkxSGaAiP9SggbBb
         D+3B0dCDfbINn8ZYoyXzRBobqDHEFmoXlt1Bj03Eg/13CeqOmIi4i94CbAc1RNJmH4+5
         levi5QuubBNxyT5dHckxJ/3ttFNevDBaTPBkyVZz05EJWwEZlIrRHCJR4ybO22zqsiN/
         srvIxLB1GacQMbLVoHZlFvcdA46YtSdf/B43KDhtBNuOMjH91jJCxJI/sz5DEXvsvVVm
         WYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680747077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA3lDPjhvFiBmDOPalF3zTKr7ivZUHMdU3+5uyp30dE=;
        b=Gtey0hdPYHDtL/4QJ63NTokeXyWorN2dOR8+nrUycX6pJN21dKQKahnGhdUH+rFdHO
         vg04VD6AhQ9QbyzDh1bhnA7UWH6uvuN//1ODSBhfFssyGLEE2MhvqZEzETI1vWPRZQiC
         JpNwNzthZONFbGUVwgW0w+pajwrqiStlicB93VeNs1D/v5umkNMkiLhB8U6GXGjoagBM
         haA5nsZEJ4rm5eg1/4ptI5a+YZzi55JWP0MZuzEXkcyv6zS0oJ82Qd7GfSAdTxgvKTrc
         t3Qk7T/3sGOxc05058n1mxTKmXJM/GdzSrhTU/lkJccSO/ndvX4+i0vG6+WVqLoZyoJt
         cRhQ==
X-Gm-Message-State: AAQBX9d8rU/q+2dpcKvDbwn/sQ+18uy8mzD9Cprki8/aiZN834FTJj1E
        YwlW6NCXZJ87hKBWvVNNQ/5sfXAGUto=
X-Google-Smtp-Source: AKy350YQNoeyjuiw/AyREIM4++ZkWIFNChwNjKlAdjOablfO8xRFKpoF20bHqQMtXpbhoR0ERBFYKEgtH2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8887:0:b0:62d:ccc4:2e03 with SMTP id
 z7-20020aa78887000000b0062dccc42e03mr4651560pfe.4.1680747076880; Wed, 05 Apr
 2023 19:11:16 -0700 (PDT)
Date:   Wed,  5 Apr 2023 19:11:06 -0700
In-Reply-To: <20230128001427.2548858-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230128001427.2548858-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073931597.699581.10258108748120088305.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs
 are available
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

On Sat, 28 Jan 2023 00:14:27 +0000, Sean Christopherson wrote:
> Disallow enabling LBR support if the CPU supports architectural LBRs.
> Traditional LBR support is absent on CPU models that have architectural
> LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
> non-existent MSRs if userspace enables LBRs for the guest.
> 
> 

Applied to kvm-x86 pmu, with a Fixes tag.

[1/1] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
      https://github.com/kvm-x86/linux/commit/098f4c061ea1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
