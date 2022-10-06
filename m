Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFBA5F5D6F
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJFADW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJFADU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C89832BB9
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id h1-20020a62b401000000b0056161cd284fso190552pfn.16
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IhY9vucrkor49I71IpqJ03K3yiVNV0ac/5M4Ac7yZ08=;
        b=HTX52T215o5gjd0vibNKgCp3S1F2RS99LZ1I/5GOvxUfcvq0STNjgJoXkosy1dA5be
         PTXvq+ODSgWtjyipG69HfkZ3JB4acMSUIespy2Ke65T8RIan3wxshBA3jtPohcAFtT0y
         9Nefz08fyxpMPv48XtISSrzv81VLe3c24xK+HbBt40NHLP4DNQqw4ZQP107nU2GErm6j
         BB7oqgdrD2tqGX/m7b4XhUWMJQexg79JAbsY3PBy7s+WC0XEtbiP4BmZgaJzR11HHBu0
         8zi1SrMhZy6R7g3n1vAH7GQ6rkdXn9r5nnaJWsmPFc2LtaP1aeryRdO3/cg2AllnQ74e
         rK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IhY9vucrkor49I71IpqJ03K3yiVNV0ac/5M4Ac7yZ08=;
        b=dGvJ7tD/r+GoGpPD0EWcZNebVo5Rfsc0o42xGRjoTZNwTltt/TkNbFtL8XohtFmIZf
         pXnq+HLq8WzkII99yeBAq13BnAtdgX3lUTomZQ32KZrkEurBqqG5YBjfAJRrEvK+lQ2c
         tm/REXZDpDyQGIep7N0wkkOrtZvdlVr47HJgRSRTgAMJNyvp2ngXTCb8sFSNbbZlkCRE
         Udlzosj7ovBGFLo8J/MefsqqPNXrceMRTbHAHyixqMJyX8kc7NKEUcN9PCSjlANFH1qB
         x7rs6dDemugQC4j9kAnE2yjeNcI3siDL0Sf5YAjBX0+kGWvfuRH7s3NNIUj/B9hgs6GB
         Wmog==
X-Gm-Message-State: ACrzQf2jDdpupIihIsiev9hlu6xNrpCw0JY+Wd5zmPzSljDf461WijJj
        cj1Me6Pvki+IP+0YyvIHu2eF6m7PyDY=
X-Google-Smtp-Source: AMsMyM5ZhowdA1UfcDz0lnUYeQbEC6PPQwe9rGh6n8tafk+dBxXku5crZMiLBpmLqaiiCa08vofWpzZ34Go=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8a88:b0:17f:8642:7c9a with SMTP id
 p8-20020a1709028a8800b0017f86427c9amr1889292plo.13.1665014597897; Wed, 05 Oct
 2022 17:03:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-1-seanjc@google.com>
Subject: [PATCH v5 0/8] KVM: x86: Intel LBR related perf cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PeterZ, I dropped your ACK from v4 because the perf patches were completely
broken.

Fix a bug where KVM incorrectly advertises PMU_CAP_LBR_FMT to userspace if
perf has disabled LBRs, e.g. because probing one or more LBR MSRs during
setup hit a #GP.

The non-KVM patch cleans up a KVM-specific perf API to fix a benign bug
where KVM ignores the error return from the API.

The remaining patches clean up KVM's PERF_CAPABILITIES mess, which makes
everything far more complex than it needs to be by 

v5:
 - Drop perf patches that removed stubs.  The stubs are sadly necessary
   when CPU_SUP_INTEL=n && KVM_INTEL={m,y}, which is possible due to
   KVM_INTEL effectively depending on INTEL || CENTAUR || ZHAOXIN.
   [hint provided by kernel test robot].
 - Add a patch to ignore guest CPUID on host userspace MSR writes.
 - Add supported PERF_CAPABILITIES to kvm_caps to simplify code for all
   parties.

v4
 - https://lore.kernel.org/all/20220901173258.925729-1-seanjc@google.com:
 - Make vmx_get_perf_capabilities() non-inline to avoid references to
   x86_perf_get_lbr() when CPU_SUP_INTEL=n. [kernel test robot]

v3:
 - https://lore.kernel.org/all/20220831000051.4015031-1-seanjc@google.com
 - Drop patches for bug #1 (already merged).
 - Drop misguided "clean up the capability check" patch. [Like]

v2:
 - https://lore.kernel.org/all/20220803192658.860033-1-seanjc@google.com
 - Add patches to fix bug #2. [Like]
 - Add a patch to clean up the capability check.
 - Tweak the changelog for the PMU refresh bug fix to call out that
   KVM should disallow changing feature MSRs after KVM_RUN. [Like]

v1: https://lore.kernel.org/all/20220727233424.2968356-1-seanjc@google.com

Sean Christopherson (8):
  perf/x86/core: Zero @lbr instead of returning -1 in x86_perf_get_lbr()
    stub
  KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
  KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
  KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL
  KVM: x86: Track supported PERF_CAPABILITIES in kvm_caps
  KVM: x86: Init vcpu->arch.perf_capabilities in common x86 code
  KVM: x86: Handle PERF_CAPABILITIES in common x86's
    kvm_get_msr_feature()
  KVM: x86: Directly query supported PERF_CAPABILITIES for WRMSR checks

 arch/x86/events/intel/lbr.c       |  6 +---
 arch/x86/include/asm/perf_event.h |  6 ++--
 arch/x86/kvm/svm/svm.c            |  3 +-
 arch/x86/kvm/vmx/capabilities.h   | 37 ----------------------
 arch/x86/kvm/vmx/pmu_intel.c      |  1 -
 arch/x86/kvm/vmx/vmx.c            | 51 +++++++++++++++++++++++--------
 arch/x86/kvm/x86.c                | 14 ++++-----
 arch/x86/kvm/x86.h                |  1 +
 8 files changed, 52 insertions(+), 67 deletions(-)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.0.rc1.362.ged0d419d3c-goog

