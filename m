Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8077844D
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjHJXt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjHJXtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:49:22 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2292D44
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-686bc3f11feso1854861b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711361; x=1692316161;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCCbjs9yndiAMHKk4zASKNfGLKmo2+2FE4R0zJsZx6Q=;
        b=FAc2CxSHLC8ZxlV75t3HwLsw3iguLOIiobsunskpVdaaDLobGTrDJNCqxHOV5ZztvF
         nEi2bjCYtZcX2d6Xc9r34XQ5tf3WDS9tsxpSMrvq30i4m8eN10rkjwr4+TIafkaYvchN
         UlIyjlmZc0jE1fZGO6VD4N89rDsiqUAojHW7SpaEclte1hgZeZmzXTzfOsZCOiOoTB8a
         f5EEwkSyykDz+aYoKOO3tlgF6Ma8LqCYWIZPTUTd1VkS8lbB20MP7lkrCujOoaeBtA3I
         0Ydn6LJ3aIPpJD+KUsTqsgiwv1R0J47J8VXt4pBAs8pMdsi1F0FdVonb/ymJamRErN+A
         fBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711361; x=1692316161;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCCbjs9yndiAMHKk4zASKNfGLKmo2+2FE4R0zJsZx6Q=;
        b=GJ/iCtaztFs0uuC2Car7nmrLukkLg2Nvnq6eLFZHhRQZPwaxdqfBx1Cl4/9Tnn/3pH
         ieLMVh/XUYmHjDWGv73nhF67kgk/r/NSzBRUSCJn8W8bqvQjGVUpl9ITotexNH4hlJPs
         xGq5oWcpr6fXH7H9v2SRFbOaXBwiV499lAGobS++nTJeY5B/p3CXVTumEK+nKBdpyYyB
         DtmR6Er2Kyo/aOXJoZE3qIHmHzInRk/XMYyAc3EkFXNeZ305m4Fbqzggsk32vza2Q1oM
         mMx6LSeD1EgME2dnL9EL0sXGRQEr/gTuXUs03jsHeWhWt3IR+w1jN2B/7L49veEm2ZMG
         trfA==
X-Gm-Message-State: AOJu0YzulA3H0A5lSPtgO5d1j0KSEZkzAUiOmgjeCK7xPqg0OQPHngnk
        tFQ+XhD5vMj/+M3C+2zs+R0hbKwROn0=
X-Google-Smtp-Source: AGHT+IG/qTAJddN4VYilmPHo9b5dSyzm2/iYFGk9Z2MZOQ0XKIW6/vUu1BscGUmTQICHDP/2SKBq+d+O6p0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1d0d:b0:666:8f6c:c8ad with SMTP id
 a13-20020a056a001d0d00b006668f6cc8admr1036745pfx.2.1691711360993; Thu, 10 Aug
 2023 16:49:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Aug 2023 16:49:16 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230810234919.145474-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
an INT3 as part of re-injecting the associated #BP that got kinda sorta
intercepted due to a #NPF occuring while vectoring/delivering the #BP.

I haven't actually confirmed that patch 1 fixes the bug, as it's a
different change than what I originally proposed.  I'm 99% certain it will
work, but I definitely need verification that it fixes the problem

Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
not working when NRIPS is disabled.

Sean Christopherson (2):
  KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
    insn
  KVM: SVM: Require nrips support for SEV guests (and beyond)

 arch/x86/kvm/svm/sev.c |  2 +-
 arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 22 insertions(+), 18 deletions(-)


base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0.694.ge786442a9b-goog

