Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB98260520F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJSVg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 17:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJSVg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 17:36:28 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FED185425
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a11-20020a056a001d0b00b005635c581a24so10130542pfx.17
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PnSH3vVxwGsS8m9ew2l67OjK+KiDAxDYc+tAVIHDXKg=;
        b=g0gs/QDJIxkhakjNOqrC+nDFoxufGA36nL55/bcChRjV4hrdMrWSGAFYxOryneZcT5
         4nlMH6E0IacDdi+UhdePFkLpBP/HLa5rFAA9pvx+8YFEFM7v4hzIvSke/mcjt+kKw3lN
         OneR6PiGFzwnXCE7L61Gp4Qdx72AXnwI7a6rt7pwIJJFL4SLL2T/Z7PSus1VBrcpcupS
         hBww/CFwMQYiSedZqA1xBMl5Y3YGmNb/+0AgRvmcI5xDFqCHO+HKt2QTDbc8Ar0Y+weq
         +63fz3E4jx+9NTVIAtJSEYxLCL87bJf1wNdErrkN/KpW8e3KpNdDgSjfqYEOq1oa9QZS
         L5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PnSH3vVxwGsS8m9ew2l67OjK+KiDAxDYc+tAVIHDXKg=;
        b=cr9GlIN4UaFeJiFmoEhyk70bF40bLj7kr2+Zt3aKqdR0Gi0h3V2ffnGiQd759j5ulR
         x0uLI7gbecRCF+lBKBj2s4UqDaen3lXU/an07FjpRxUcNX23EIPF5uefO9XLoukmX/Rp
         mL35QboSX0lG1WhjVHBgUx6qtenEH+pHe0EUatw/nh0e2xYXWxx989Mh1pV0fSeaCJQd
         V3HrcqZnozedMItqCofSqiXY/7uu9qgAgFcOe/5UZK6+UBCBBBaWvu/XCIgBsIXATYGa
         xYi75JCZHqUIMBRHgMDTOwWnIQRW32J/UiCZciwxmk3Rzub1dpLaSui2kSAY+aczAQUA
         aqOA==
X-Gm-Message-State: ACrzQf2b4uc8gNz/lr7FadfVjgPxBqaYXublmyMiC5vuYnQw/Rmiu/uu
        rtQvAYQBMMLvmDWDuOrCHNtfYwJ7CoU78gQ2Wjkpe5IdQkvWHKWhLCFa0PJnmE8l1Q39zSnhGnG
        QiCPaBlR8GDbXop0F9Uk25qiNbu2ePfQQ96C0HI/v8nEEUKTyg6+6tCkMcBcklo8=
X-Google-Smtp-Source: AMsMyM7g+Q3AB6pqX0xkbp6CQwZ0/z+OucgSC6XhXHgeKmy9xAKO/d3fHeEv1Wv7kA07uU3SC0PyHag0M3p2yw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP
 id w6-20020a17090ac98600b00205f08ca82bmr1438pjt.1.1666215386332; Wed, 19 Oct
 2022 14:36:26 -0700 (PDT)
Date:   Wed, 19 Oct 2022 14:36:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019213620.1953281-1-jmattson@google.com>
Subject: [PATCH v2 0/2] KVM: nVMX: Add IBPB between L2 and L1 to
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

Since L1 and L2 share branch prediction modes (guest {kernel,user}), the
hardware will not protect indirect branches in L1 from steering by a
malicious agent in L2. However, IBRS guarantees this protection. (For
basic IBRS, a value of 1 must be written to IA32_SPEC_CTRL.IBRS after
the transition  from L2 to L1.)

Fix the regression introduced in commit 5c911beff20a ("KVM: nVMX: Skip
IBPB when switching between vmcs01 and vmcs02") by issuing an IBPB when
emulating a VM-exit from L2 to L1.

This is CVE-2022-2196.

v2: Reworded some comments [Sean].

Jim Mattson (2):
  KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
  KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c    | 10 ++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.38.0.413.g74048e4d9e-goog

