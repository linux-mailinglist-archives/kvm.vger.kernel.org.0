Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D6E75D8A1
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 03:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjGVBX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 21:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjGVBXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 21:23:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA14835B3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57059e6f9c7so43097467b3.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689989032; x=1690593832;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjOGI0rtHJ0Xllp/eOzp2m4a8FZifh6yDGUlOPnX5JQ=;
        b=mR41XkAUtB4o5mYfqLuTYY+l4LWmXM/Qu71oinEDo21mv55ssG0ngGgmvah527PCli
         hJI1iJlYTvgiwcTV9rH+o6xwTjaV0LPYpmh/VPDl06sIOkON5t/dPvpAIZLzDKXl5MVR
         wk0DRTFkMJGHmdP8Xc0HklC4SD08YDHgwfiC8z0rH0W55H5Sm+BLqkLbPqgICPEurj9S
         qEeqgJvoZmTplAu57lhg1rCV0NysaIS8CpI5XWXffSVcIFIhHcjBOA6ry+dmII+WofFE
         hdTez1UkIbIwKp27TsdAoG3Z0+cqopYavklupVmTkLi3s5pHzEX9fojy9kZxZ7aIspVY
         RayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689989032; x=1690593832;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjOGI0rtHJ0Xllp/eOzp2m4a8FZifh6yDGUlOPnX5JQ=;
        b=EEdaKKCWC5w+mKoheGrgULfxjVW7kVoQw9tPV/rQGIdgeXoT1YtQk2WYJSypwUu3en
         VhVAMGj8PnTxm/Q3MQW5PQsKDReqPp27oYZvW3ktP6R/Jny35mz5bEnpRBaMwm8iAmAf
         E1AJu9v6doCPMOGTxEDtPgFVao4QaotbNyxIGSUQEzhEP56zunqdV6n8tgINeu56H6pN
         5sUc3vp+uVYVhvh9SkdEqVTHeno+S1kHLYgefVa/e61Lx16PsxbNSgriDTnFLT5fU3dN
         FXlORZpiT2Wp3o6ZYHVQZ1+Spuhp8ynw92+EbbQoBDoChW2UWnxKUCvPkdpiHbhz9uKn
         4ppw==
X-Gm-Message-State: ABy/qLbgCX+NgRrrCWxeWzIZfim1TvIW9WIUxnfA+iiFuSHtMgXmvgWq
        xvj3eT6XHls95F4Lo/7TGgGuYdZcdwU=
X-Google-Smtp-Source: APBJJlFS9ME3Zza1Hm4myHB5l+fWYD2RqQf58E4vS2zZVlRLpslggxoSm25aBC9Ylr2Ofh/bnuXFeQIkSQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3086:b0:57a:6bb:c027 with SMTP id
 ez6-20020a05690c308600b0057a06bbc027mr20450ywb.1.1689989032191; Fri, 21 Jul
 2023 18:23:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 18:23:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722012350.2371049-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86/mmu: Don't synthesize triple fault on bad root
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RISK_FREE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the handling of !visible guest root gfns to wait until the guest
actually tries to access memory before synthesizing a fault.  KVM currently
just immediately synthesizes triple fault, which causes problems for nVMX
and nSVM as immediately injecting a fault causes KVM to try and forward the
fault to L1 (as a VM-Exit) before completing nested VM-Enter, e.g. if L1
runs L2 with a "bad" nested TDP root.

To get around the conundrum of not wanting to shadow garbage, load a dummy
root, backed by the zero page, into CR3/EPTP/nCR3, and then inject an
appropriate page fault when the guest (likely) hits a !PRESENT fault.

Note, KVM's behavior is still not strictly correct with respect to x86
architecture, the primary goal is purely to prevent triggering KVM's WARN
at will.  No real world guest intentionally loads CR3 (or EPTP or nCR3)
with a GPA that points at MMIO and expects it to work (and KVM has a long
and storied history of punting on emulated MMIO corner cases).

I didn't Cc any of this for stable because syzkaller is really the only
thing that I expect to care, and the whole dummy root thing isn't exactly
risk free.  If someone _really_ wants to squash the WARN in LTS kernels,
the way to do that would be to exempt triple fault shutdown VM-Exits from
the sanity checks in nVMX and nSVM, i.e. sweep the problem under the rug.

I have a KUT test for this that'll I'll post next week.

Sean Christopherson (5):
  KVM: x86/mmu: Add helper to convert root hpa to shadow page
  KVM: x86/mmu: Harden new PGD against roots without shadow pages
  KVM: x86/mmu: Harden TDP MMU iteration against root w/o shadow page
  KVM: x86/mmu: Disallow guest from using !visible slots for page tables
  KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest
    roots

 arch/x86/kvm/mmu/mmu.c          | 88 ++++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 18 ++++++-
 arch/x86/kvm/mmu/spte.h         | 12 +++++
 arch/x86/kvm/mmu/tdp_iter.c     | 11 +++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 6 files changed, 93 insertions(+), 48 deletions(-)


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

