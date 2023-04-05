Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E9E6D719D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbjDEApZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbjDEApY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8A21709
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j3-20020a17090a94c300b0024018f0656cso10751152pjw.2
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655523;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yr/0bqvdRlJJapuJ2d3ftTVbp9EO1JmQOBdaKr9lPBU=;
        b=d0MupX+URvilqybd49E3iMgN/IuNtrfkMX0C6+qK2FNexNrf3FjmJ/D8uOziC0g5pd
         xqx6gHPbj/jwxEcjjCnVJVWMBXqM+lUG5rQY8oiOXYsOyW9XVlcM1rhysY91dBHf4+ye
         F/OJU8dWi+Cb2lrDLeLH/4OBO/OsJee4wg/RA+G+LcBECYGzrhnHQmh4YyVnqBoXcOaP
         h0rA2wWJKRUzyh33Ob1gq3qtoZ27MOmS3UoD3ta7XSvK2FlQKcoyn15CfWA+TL3LzjbB
         Cq6OzXKyAD09KXOtpuiPNqcB0xoVITGLgIhP7cljkGTDqA8ovpBRzK9CGEobU46UIdTm
         pnIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655523;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yr/0bqvdRlJJapuJ2d3ftTVbp9EO1JmQOBdaKr9lPBU=;
        b=ehBdF20Iqk8VGtIJLsqAqlBw4Sz+jKNP5mc7gE0B8Lb9e9m7+Y+eNfcS7y5pu9ZtJJ
         Ees0+upsZTyzgppb1+q2iozeZlXoSaOo6mXGG8UyeaxNJpgiI2HtiephaYrk7F2/fp34
         +uLD3fvzFBQic9GulhSBzYu0K26ctzMeBYruQyP6VgUXdj/yj+piDILXf+kMCCRQPIH2
         KM5EIZjHikaCsUj2TrKF6tdVejgxxbSFTJIWFggIBBcWivO6rFCnmkMvPHQnsOj01PXY
         XmekSd+6rFtOnGXpv5KFQVW9vVnEFj/OiGTMtR2IaN0IOM7OIArZtMZ5Sl+RzAnjP0nT
         xnIA==
X-Gm-Message-State: AAQBX9eUtuWbvRFfEtwYzMt8O4BVIw2Vh7nrQZDYw2I3RWbumxSFnS1B
        ZF0VTZPG1605catEV4R9EmylIN7JYrY=
X-Google-Smtp-Source: AKy350YHPl/UVSGKbPleRCsCUX/E5n1H5NldE5e9wb1c6WaB602hP5rprr4a9fFnVNVSlqzkgUuBxRrIG4g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e9a:b0:625:dac0:5263 with SMTP id
 fd26-20020a056a002e9a00b00625dac05263mr2356256pfb.0.1680655523046; Tue, 04
 Apr 2023 17:45:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-1-seanjc@google.com>
Subject: [PATCH v4 0/6] KVM: x86: Fix unpermitted XTILE CPUID reporting
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v4 of Aaron's "Clean up the supported xfeatures" series.

Fix a bug where KVM treats/reports XTILE_CFG as supported without
XTILE_DATA being supported if userspace queries the supported CPUID but
doesn't request access to AMX, a.k.a. XTILE_DATA.  If userspace reflects
that CPUID info back into KVM, the resulting VM may use it verbatim and
attempt to shove bad data into XCR0: XTILE_CFG and XTILE_DATA must be
set/cleared as a pair in XCR0, despite being enumerated separately.

This is effectively compile-tested only on my end.

v4:
 - Apply the massaging _only to the XTILE case.
 - Add a build-time assertion to trigger a failure if a new dynamic
   XFeature comes along without updating kvm_get_filtered_xcr0().

v3: https://lore.kernel.org/all/20230224223607.1580880-1-aaronlewis@google.com

Aaron Lewis (4):
  KVM: x86: Add a helper to handle filtering of unpermitted XCR0
    features
  KVM: selftests: Move XGETBV and XSETBV helpers to common code
  KVM: selftests: Add all known XFEATURE masks to common code
  KVM: selftests: Add test to verify KVM's supported XCR0

Sean Christopherson (2):
  KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
  KVM: selftests: Rework dynamic XFeature helper to take mask, not bit

 arch/x86/kvm/cpuid.c                          |   2 +-
 arch/x86/kvm/x86.c                            |   4 +-
 arch/x86/kvm/x86.h                            |  29 ++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  69 +++++++--
 .../selftests/kvm/lib/x86_64/processor.c      |  17 ++-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  62 +++-----
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 132 ++++++++++++++++++
 8 files changed, 251 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c


base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 
2.40.0.348.gf938b09366-goog

