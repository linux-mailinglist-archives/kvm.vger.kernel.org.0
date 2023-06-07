Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAD2725147
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbjFGA4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbjFGA4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:56:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7461A199A
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:56:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb3528ce5so9718340276.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099389; x=1688691389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqtEDAPCg3PtcRxPjnzxO3xegx/BjNmyDzr1+EL/qfI=;
        b=he1l32c/rGoI+AHks8np42sxdXuBvRf6WyMj6DgQlqG1MrkQ5WL3LJLPYk9u1juYY8
         FLYnb/Eiksk4AYSXFFoEi6L45dbAramG4ubJRrpIMaiC3U5loC2/GpvyKaDKWsLMoX3u
         p8SNXNVC2F2Bi0rZ2jhK/3Fgeym7yV3tDuznuzqRIwuOiSea81/2Vy1qnPPjslOQSRMZ
         0zsYNWjbcZtekdSzWjOEwoeXj0cawyOXXQ1rTpl0Ej6WSFi+gy6tbxfMAKEDSyraSE7Q
         SBEERBXVnrg/N7bkQxDQ0hXDY5vkUVXXz9CceEVedJYXiQg6zHmXdiW1oenyTlXevCPm
         ZbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099389; x=1688691389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqtEDAPCg3PtcRxPjnzxO3xegx/BjNmyDzr1+EL/qfI=;
        b=LlrmAPCgavAWGw/5vrn2/ObcDhUsoYQBVICROZATFZwxzdmB/Cty3kD3pb+S2i9ZuO
         AfnlXUqETO0TCJPJHs12sBEt5t6ACvBiYCcJ2qq0I1JxWH9ochlqSAaBsfhxmjxwMXk9
         qJ5VtMdQ9djMMcXqcYnXRRwsaAv8ivLpkd4o1GgArzRX+ULok16PzALyDrkHZFn9wUFL
         kSZ8um351M8IuC5QpOBQmsqoE8vBoT0i0P5NhGoDRyujuqQZIKWUNhcBODVKB8tbIIAv
         83MGCmOpHkx5g36GduV6gX+RCPvLd54YyMlFJ0OHcU+/sR900lQX9F/3c28kHbNcKKCX
         KZYw==
X-Gm-Message-State: AC+VfDwP1Qq/4OUkpA26/vb30WVmSw1pddfnSvlPBUdFjwcxryjYY+Q8
        BSrQhmxlOpM7mGnuQrOgjBwe2PrZj6k=
X-Google-Smtp-Source: ACHHUZ5ERD8JHJ/mENi7A4A1jnXVlCzkv+i1+DGi2+6lodC6zM66kJmbk7c2/9TIa20EZin9mSPuskOaUjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce46:0:b0:bad:99d:f086 with SMTP id
 x67-20020a25ce46000000b00bad099df086mr1350961ybe.10.1686099389766; Tue, 06
 Jun 2023 17:56:29 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:55:14 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168609790857.1417369.13152633386083458084.b4-ty@google.com>
Subject: Re: [PATCH v7 00/12] KVM: x86: Add AMD Guest PerfMonV2 PMU support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 02 Jun 2023 18:10:46 -0700, Sean Christopherson wrote:
> v7 of AMD PMU v2 support.  This includes the global_ovf_ctrl_mask =>
> global_status_mask rename that I *just* posted.  I really wanted to apply
> v6 and be done with this series, and so sent it out separately, but the
> code movement from pmu_intel.c to common x86 was too buggy to do in fixup.
> 
> Lightly tested (it's late, it's Friday).
> 
> [...]

Somewhat speculatively applied to kvm-x86 pmu.  I'd really like to get a thumbs
up that I didn't break anything, but I'm OOO later this week and want to get
this into linux-next before I go offline.  Holler if something is broken, this
is the only thing sitting in "pmu" so it should be easy to massage if necessary.

Thanks!

[01/12] KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask
        https://github.com/kvm-x86/linux/commit/53550b89220b
[02/12] KVM: x86/pmu: Move reprogram_counters() to pmu.h
        https://github.com/kvm-x86/linux/commit/8de18543dfe3
[03/12] KVM: x86/pmu: Reject userspace attempts to set reserved GLOBAL_STATUS bits
        https://github.com/kvm-x86/linux/commit/30dab5c0b65e
[04/12] KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and friends to common x86
        https://github.com/kvm-x86/linux/commit/c85cdc1cc1ea
[05/12] KVM: x86/pmu: Provide Intel PMU's pmc_is_enabled() as generic x86 code
        https://github.com/kvm-x86/linux/commit/13afa29ae489
[06/12] KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
        https://github.com/kvm-x86/linux/commit/6593039d33c1
[07/12] KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
        https://github.com/kvm-x86/linux/commit/6a08083f294c
[08/12] KVM: x86/pmu: Advertise PERFCTR_CORE iff the min nr of counters is met
        https://github.com/kvm-x86/linux/commit/d338d8789e64
[09/12] KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
        https://github.com/kvm-x86/linux/commit/1c2bf8a6b045
[10/12] KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
        https://github.com/kvm-x86/linux/commit/fe8d76c1a6f0
[11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
        https://github.com/kvm-x86/linux/commit/4a2771895ca6
[12/12] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
        https://github.com/kvm-x86/linux/commit/94cdeebd8211

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
