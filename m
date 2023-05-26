Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6861E712EA2
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 23:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbjEZVDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 17:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjEZVDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 17:03:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89F1BB
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:03:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-530277cf88bso1141704a12.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685135023; x=1687727023;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqGO8S3myeC+eomQOIi6rDzjkLbzZroWYlXbkpWLdc0=;
        b=UOGD5pQjkXpfeiJifIscMBoLdKIcW4HlfIkgcSVUThmQ+Kjhba5PfkMDXdG9Au13SJ
         7k7vTo+LeVlcwDpTEfhlV+/GfFv/dvO77+0VEaYAqfpfVDRN8/2/m4ad3CiLe6n0cTkM
         Qc2ELGoDiv+Uf9qPENHYsbOQdVkBk2zSh0Mn9MRq5Wnw4xcUeUptwKZrxBw/Uzqwa2k0
         PIy3b7l/76nDrP/3TbM8RkarztBK0UhsA5RJ0O64YZw1ZTxNB9ETZdabSOXUAmxWNg1Q
         YPztFGv72I0nSxQgr7sJ71816BuYb7Xy9MIkLzy65Qe+RzD25hC0oK7oNoWyUMJZGxrz
         dobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685135023; x=1687727023;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bqGO8S3myeC+eomQOIi6rDzjkLbzZroWYlXbkpWLdc0=;
        b=aiDwyogOsTYBeUZGFBs8mIos/nBF6U4J92iG2SJ+AHW4LTXn2rqFrnatUDUziCGsGl
         kNWPYv87G1dEUoV65FYpp+zAc8dIVCEbgcjWIwxWfZm41wZJF/DJ1QgX3KMK0maAY8KY
         4GAfnpUnzGJ3SAsp7u7Yyq5RDowe0yMcmXfg9xYs2kvzSfU5KSv9LOHS7ZML2lOWmqxQ
         ikPqMmEABL3IZDmIH9ylSqY2UR33EXL/LEtZBo0q609xZgFSMQUizIe5XTWmFUjA3PQ2
         eesPEEWzNZAI65bc0WSJ6gtygUswZouf6FfkPZ141IlO/MDAPaawp2U+1QOJf8MsAguA
         wPlQ==
X-Gm-Message-State: AC+VfDym8sfO8eIHaRpp6d2fagc+HFSkS9C/sVg0LaIxoc9TpQlV3ie+
        lqv2En/YMW/9Jc8vDFG4kxtOdHodk0g=
X-Google-Smtp-Source: ACHHUZ4Q83cLf6FFFwF+jYvtMfxR58orvfBIhh9bjGbnpTN4GHMdHebotzGhf3wNfm/msjEFJjtPuYSPkCo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6889:0:b0:52c:999a:fce2 with SMTP id
 e9-20020a656889000000b0052c999afce2mr149604pgt.10.1685135023201; Fri, 26 May
 2023 14:03:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 26 May 2023 14:03:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526210340.2799158-1-seanjc@google.com>
Subject: [PATCH v3 0/2] KVM: x86: Report actual nent from KVM_GET_CPUID2
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takahiro Itazuri <itazur@amazon.com>
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

Essentially v3 of Takahiro's patch.  Update cpuid->nent on a successful
KVM_GET_CPUID2 so that userspace knows exactly how many entries were
filled.  Add a testcase to verify KVM's ABI.

v3:
 - Don't bother updating cpuid->nent in the error path, the data is never
   copied to userspace.
 - Add testcase to cpuid_test

v2: https://lore.kernel.org/all/20230413175844.21760-1-itazur@amazon.com
v1: https://lore.kernel.org/all/20230410141820.57328-1-itazur@amazon.com

Sean Christopherson (2):
  KVM: x86: Update number of entries for KVM_GET_CPUID2 on success, not
    failure
  KVM: selftests: Extend cpuid_test to verify KVM_GET_CPUID2 "nent"
    updates

 arch/x86/kvm/cpuid.c                          | 13 ++++--------
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 21 +++++++++++++++++++
 2 files changed, 25 insertions(+), 9 deletions(-)


base-commit: b9846a698c9aff4eb2214a06ac83638ad098f33f
-- 
2.41.0.rc0.172.g3f132b7071-goog

