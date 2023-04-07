Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA56DA762
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbjDGCFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbjDGCFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:05:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D7DCA0A
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 19:03:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p10-20020a170902e74a00b001a510a3eb8eso598569plf.0
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 19:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680832976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C1sxOT2Xcvlxzmlv1gNQ9J83zd4sjkR8KsgEzEvfrdY=;
        b=qOvysYcKS+rU7SCW90gKmr7bC/NGeLM2p1eEKx+FZ4mEcrEG/c9cOesBTeA6E0GqQJ
         e8gDZysKdNQdbMVZxmBsPMoISL3rVqHfwFn1uO2JMzwqGeEoa3r8pJWpn5vpCP/Mmxyo
         Zr/b1vw+en5ipMTcSqGxyV5C7kVI1+xwV6kzyziwd+hNVtHwaRCRcu0Mi5gp0SlPkJyZ
         6SFqRG+ArHUZ8T4zETanLgJx/W6xVUd4gHNrfq2tcTyGKrwT5sGdK53oHyeQY4fJN2ZB
         qSzRKbcgFB8Fxb6Og1OmSt6QOz7A0fX7I4r51tunJ4+phxTEBRzJgciUIkPzJW0bKLmi
         cw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680832976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C1sxOT2Xcvlxzmlv1gNQ9J83zd4sjkR8KsgEzEvfrdY=;
        b=xaoqjXDBP87zEwNI8O3GHYNEpfl7z7dX/73PGbn22HFJPoGit7RVvnLDYK3/iQY4kH
         /+wRUtrnfivO7bPe0FjOC3awBIOsfXQQYZ7vrX01WB/B+lUIKzknLBYZRhtii1v9Kc6v
         le8aHVC0ka5tNkxDJoDYx0D6wOKUMpzM7Kt7qEIUWft8CmZ4j/abGIIlWt2ER3U3r+Ie
         Irrj8tYPYJ504SOcnLxVqjcy9ihxhzs85SqJzfzrDDLE6gijfyvVwe221+YNDv0qnA9S
         vncStC8y+qRyb+/WgEymsdt5nD2CPsJhKHLf45lJ0yqdN2373zKIn7Aw8OS4cwlRWPjP
         voUg==
X-Gm-Message-State: AAQBX9eLhuvI2fzoBG4BFn+j1txnO+Q547kGhPmZiEEFS6ouZG6Xdh+H
        OfXkt0Y47OEmDgnFgYJI5DPWac/RxFY=
X-Google-Smtp-Source: AKy350Yb+UQnUzfXVqd5h6f6I4prDXokgE7zXP97ghLKirugHiKwzqKCZ/4MTD+wCc0CgxcPWi8poqK4Fv4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d34c:b0:237:2516:f76a with SMTP id
 i12-20020a17090ad34c00b002372516f76amr186158pjx.2.1680832976214; Thu, 06 Apr
 2023 19:02:56 -0700 (PDT)
Date:   Thu,  6 Apr 2023 19:02:29 -0700
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168081836093.832365.5917577091304366853.b4-ty@google.com>
Subject: Re: [PATCH v3 00/21] KVM: x86: Disallow writes to feature MSRs post-KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

On Fri, 10 Mar 2023 16:45:57 -0800, Sean Christopherson wrote:
> Give feature MSRs that same treatment as CPUID and disallow changing said
> MSRs after KVM_RUN.  Fix a tangentially related bug in the vPMU where KVM
> leaves the vLBRs enabled after userspace disables the guest's entire vPMU.
> 
> The bulk of this series is a rework of the vmx_pmu_caps_test, a.k.a.
> the PERF_CAPABILITIES selftests, to expand its coverage.  In addition to
> verifying that KVM rejects changes after KVM_RUN, verify other bits beyond
> full-width writes and the LBR format.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[01/21] KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple lists
        https://github.com/kvm-x86/linux/commit/b1932c5c19dd
[02/21] KVM: x86: Add a helper to query whether or not a vCPU has ever run
        https://github.com/kvm-x86/linux/commit/fb3146b4dc3b
[03/21] KVM: x86: Add macros to track first...last VMX feature MSRs
        https://github.com/kvm-x86/linux/commit/5757f5b95622
[04/21] KVM: x86: Generate set of VMX feature MSRs using first/last definitions
        https://github.com/kvm-x86/linux/commit/9eb6ba31db27
[05/21] KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after KVM_RUN
        https://github.com/kvm-x86/linux/commit/e4d86fb910df
[06/21] KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
        https://github.com/kvm-x86/linux/commit/0094f62c7eaa
[07/21] KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU has run
        https://github.com/kvm-x86/linux/commit/3a6de51a437f
[08/21] KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
        https://github.com/kvm-x86/linux/commit/957d0f70e97b
[09/21] KVM: selftests: Move 0/initial value PERF_CAPS checks to dedicated sub-test
        https://github.com/kvm-x86/linux/commit/710fb612672e
[10/21] KVM: selftests: Assert that full-width PMC writes are supported if PDCM=1
        https://github.com/kvm-x86/linux/commit/b1b705627cb3
[11/21] KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
        https://github.com/kvm-x86/linux/commit/22234c2495ea
[12/21] KVM: selftests: Verify KVM preserves userspace writes to "durable" MSRs
        https://github.com/kvm-x86/linux/commit/f138258565d1
[13/21] KVM: selftests: Drop now-redundant checks on PERF_CAPABILITIES writes
        https://github.com/kvm-x86/linux/commit/69713940d2b4
[14/21] KVM: selftests: Test all fungible features in PERF_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/37f4e79c43e5
[15/21] KVM: selftests: Test all immutable non-format bits in PERF_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/a2a34d148e75
[16/21] KVM: selftests: Expand negative testing of guest writes to PERF_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/baa36dac6ca8
[17/21] KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/81fd92411264
[18/21] KVM: selftests: Drop "all done!" printf() from PERF_CAPABILITIES test
        https://github.com/kvm-x86/linux/commit/bc7bb0082960
[19/21] KVM: selftests: Refactor LBR_FMT test to avoid use of separate macro
        https://github.com/kvm-x86/linux/commit/8ac2f774b9ea
[20/21] KVM: selftests: Add negative testcase for PEBS format in PERF_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/8b95b4155523
[21/21] KVM: selftests: Verify LBRs are disabled if vPMU is disabled
        https://github.com/kvm-x86/linux/commit/d8f992e9fde8

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
