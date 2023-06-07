Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2669727051
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjFGVKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbjFGVKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7437A92
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:02 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-65313d304e6so2035197b3a.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172202; x=1688764202;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yI/eiJnVBRg9pCkgFUkTmEwoLDo9Vh826wMkw5iSGNo=;
        b=BxlaTfzZRF+T0DFeciPEZJULVwlOrq/kHqKdNZ0QITpxpRjjaAHWKVry1jUrmB0Fz3
         rSZZ0K3xGQW4xHXF9bqpLN7tGjA79QXYROIv2PLSzI1uEue2NbLqH5kkBi4TFoBy7Gaf
         Yh/Hh/RdPFlayw7QnT+eSL+cft7BBCKELxJkyJM29LMK64JjJUIPDNSrez/sxwu2bowU
         bY4t/liSvitJWKalysW5v92PZCIdPq8i/lNKVPw9Oi6pRpLcY8NwNIksCT3Kt+yP7r7+
         h8EVvJ1dJSbxyETDe79t6f7emQu9J8gQgpRoaRfqy0iPcEpXx2TawcfrYkBWlMJOo8FH
         /z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172202; x=1688764202;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yI/eiJnVBRg9pCkgFUkTmEwoLDo9Vh826wMkw5iSGNo=;
        b=F8dYwxCpyx2MNFnC4pPszvEAAGboizPE2XYipypwIDNn4736Ddp9M+WXZUyvxfOBJQ
         0F5VbMTMgYpG5XqINmLOeXBRdS9TFyxBTOb2TjVhVfD8hrVt4cwnf7GrK2TGxHm46A/9
         t7LyiNAje4cPRmX3YqZhf7nUW6k6U0CK4SbelGyEnKL7Foj2VQ9G+p77zsYQLEvaJQP8
         fzZctFsqtXLo+3vHb/mTe41G5wA58PLSqQpc3Qo+X05zII+BwbWh+blAEu4sIA1kiMZz
         VJe63FFKBOCNepTIduL09deMtToZqZhqi3UyixtTqBpJ8XrAouL7fEqKeIIHu79tuqIP
         aS8A==
X-Gm-Message-State: AC+VfDxSaqMYAd10aI/IFz0rjAhK7xQWwx4neEkWb/EwkYc1az9Ew6zT
        tnPYN1WSvyBbLCWR69rCin2o3KpSMkQ=
X-Google-Smtp-Source: ACHHUZ4/chXcqWVnaGT5F02U5w/9xmfrZIDEIYICbhtfmjPHQiEBhR9ADpPdHZnrTCPcb7JbM3jeJ51foes=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1354:b0:64d:2cb0:c623 with SMTP id
 k20-20020a056a00135400b0064d2cb0c623mr2757678pfu.4.1686172201977; Wed, 07 Jun
 2023 14:10:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:53 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/6] x86: nSVM: Fix bugs in LBRV tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix bugs in the LBRV tests, and try to make them a bit less painful to
debug (goes from "excruitating" to just "awful").  The tests have been
failing on our Milan systems for quite some time, but debugging them was
painful and I wasn't sufficiently motivated until I wanted to clean up
KVM's code :-/

The Milan failures are due to AMD shoving a "mispredict" bit in the LBR
records, i.e. the tests fail if the CPU mispredicts the branch being
tested.  Debug was especially difficult because the tests also neglected
to setup a guest stack, i.e. adding debug code created a completely
different failure that looked similar at first glance.

Sean Christopherson (6):
  x86: nSVM: Set up a guest stack in LBRV tests
  lib: Expose a subset of VMX's assertion macros
  x86: Add defines for the various LBR record bit definitions
  x86: nSVM: Ignore mispredict bit in LBR records
  x86: nSVM: Replace check_dbgctl() with TEST_EXPECT_EQ() in LBRV test
  x86: nSVM: Print out RIP and LBRs from VMCB if LBRV guest test fails

 lib/util.h      |  31 ++++++++++++++
 lib/x86/msr.h   |  11 +++++
 x86/svm.c       |   7 +++-
 x86/svm.h       |   2 +-
 x86/svm_tests.c | 108 +++++++++++++++++++++---------------------------
 x86/vmx.h       |  32 ++------------
 6 files changed, 99 insertions(+), 92 deletions(-)


base-commit: 02d8befe99f8205d4caea402d8b0800354255681
-- 
2.41.0.162.gfafddb0af9-goog

