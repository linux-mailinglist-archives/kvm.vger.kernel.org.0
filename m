Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95056A2456
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBXWhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXWhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:06 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E239C1B2EC
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id cn3-20020a056a00340300b0059085684b50so216266pfb.16
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gRkJBMOndTLZbS4/GkF1P4PXXbe+UidCifZljAhOCuA=;
        b=EQaIjSaYjwFlxKvNPcw2R48Z/QuxQ2sLAWlLrWGUIcptmIdhmujiM1aTfX04EVjvha
         4s2ozoIK1BVNPYVDHcOU0mtWasPTALmD1I+IqT282Yi+029zWIrlKxfA3rmD3UV06/pU
         qtGkiA3qvIy8AkktCvtbOhsgwHHfyEd+LeegtU+VixEkKkNojs2JIzbVeZSY6yOJuOEM
         ygQmMSLexdISCpNxDKbDZNxgwtTnO9lwnrJ+sIoM1VeOBsXvaisTZl1ViRrdMkQLR7BV
         qVc8bePbsj/QAZiK3Sog2amEV/kmJrilI4ZFSkSdXrGFpm7SWxE5L1TvfY2g1FrKB0ek
         9i4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gRkJBMOndTLZbS4/GkF1P4PXXbe+UidCifZljAhOCuA=;
        b=OJSgXw/bNx9vN2SCTzl20m3wbXdws7dq0Lr23zChayYJJ3ioC+4XWmjyybzg0Li1w7
         6DmV8x4CjiemVhyBYaWv2L+89kfw1CGnnrEXyiWAFR3EBK+TzDi1lr3NRrk+S7E6dklk
         PQnaYOJZ73eR1I1q/3d/61Fp4+DmOiR24qIAwZ/CASGZ0jPgO//P3CaUC4oPPIjP9LD8
         hIczfBDcZ6aBsPwxuZB4vXkBLtW0qorYG984sR6CvxEY1Z6Qlq0yPVU5nLtk/nFG52Wc
         nbsHflZU+0VHSQ9SPQ5fKoG9+gXCS1N2KgK6TO5Nj5X5+mwOfehL7lhuR8PtKayGMtF5
         Fe6g==
X-Gm-Message-State: AO0yUKWTN0uQ2sjRiCVC9lFFRldrpVESuEVxTf5d5B/uMpwFYtHcwvxi
        02HiZPctX3XL3O/S8ETdyNS5QS/fj9sYJfhvpY6bT5qCCgRdZ2xxu9Bbm2OnrLtWd6VtFCtn9Uk
        /+iIOnOcE69VpZ9M6QJPN2PA83iIbey0ntegeqF3NPaCVssQloAx+eCIHeihlhSNrWS0T
X-Google-Smtp-Source: AK7set9G90aySxCt9j1SbrEtRJ/rE1R+VFpfYiPxBKckIuXKGN8qdjPrDYjlI7dfNXSnfZcO6n/5LmX9Wg+IAdXg
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:f3c9:b0:237:2062:919e with SMTP
 id ha9-20020a17090af3c900b002372062919emr2277061pjb.8.1677278220125; Fri, 24
 Feb 2023 14:37:00 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:35:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-1-aaronlewis@google.com>
Subject: [PATCH v3 0/8] Clean up the supported xfeatures
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure the supported xfeatures, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0),
for MPX, AVX-512, and AMX are in a valid state and follow the rules
outlined in the SDM vol 1, section 13.3 ENABLING THE XSAVE FEATURE SET
AND XSAVE-ENABLED FEATURES.  While those rules apply to the enabled
xfeatures, i.e. XCR0, use them to set the supported xfeatures.  That way
if they are used by userspace or a guest to set the enabled xfeatures,
they won't cause a #GP.  

A test is then added to verify the supported xfeatures are in this
sanitied state.

v2 -> v3:
 - Sanitize the supported XCR0 in XSAVES2 [Sean]
 - Split AVX-512 into 2 commits [Sean]
 - Added XFEATURE_MASK_FP to selftests [Sean]
 - Reworked XCR0 test to split up architectural and kvm rules [Sean]

Aaron Lewis (8):
  KVM: x86: Add kvm_permitted_xcr0()
  KVM: x86: Clear all supported MPX xfeatures if they are not all set
  KVM: x86: Clear all supported AVX-512 xfeatures if they are not all set
  KVM: x86: Clear AVX-512 xfeatures if SSE or AVX is clear
  KVM: x86: Clear all supported AMX xfeatures if they are not all set
  KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
  KVM: selftests: Add XFEATURE masks to common code
  KVM: selftests: Add XCR0 Test

 arch/x86/kvm/cpuid.c                          |  27 +++-
 arch/x86/kvm/cpuid.h                          |   1 +
 arch/x86/kvm/x86.c                            |   4 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  52 +++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c |  46 ++-----
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 128 ++++++++++++++++++
 7 files changed, 220 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

-- 
2.39.2.637.g21b0678d19-goog

