Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54558AEE3
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbiHER3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 13:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbiHER3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 13:29:50 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9F218E21
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 10:29:49 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z5-20020a056a001d8500b0052e691eed53so1491615pfw.13
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=RxSh7K3S45ZS7TxuBdImLm9RuwwaToxTVXAGKV2hZuM=;
        b=NtjkkInM90AxcQRMSnSbblj44/A29BSsbEf2TOdUdI1CgYWgEPH8m7+MIUk8HfjEjs
         mtmiKlthASEyrrB2kiPINotrcZcMjBEunuezV1xE1/p318dctzO4QiU0M6KpDyujX7S6
         eC2ZrnuRRi+ORbdfmSfWWdtvZhmlpL9PwsxXW8zZIkkRVtrOQm2gOHI4wt8zGi4nXVX1
         Lk4+WYJWc990kvpZubB0Xsdws5kSEBXPTucMqQZfgRugpLsrHuFNX0LdBKmMgBoK0/r+
         nefm7mNw8YH2ta0tAO/Z5+jyH/xoiroMXcX7Ia2yAvBrgdnqE04SfJ1SbKNPicNxRce1
         Z1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=RxSh7K3S45ZS7TxuBdImLm9RuwwaToxTVXAGKV2hZuM=;
        b=I9EhCRUmm2jbVAz6sEfXzm95JyF1Z0MJit/gbCkMlQkD2Ap5pV3dIMLSOVXhWTL9em
         OyRBnVaHzneal9KBRp7RopEsKyxbxO81lwi0IUzgGLL49kBedjRC23TfGraoIq+ZkW+D
         7TpXa9+YiuEY3YYHV0C6s1mHj2oXENkdKhbJM2MLRjcJo15Z59FP4XIODuscc7MQ3X+s
         +lo2+XrGMECwBBsfYBtTHnVrYamPYjETqply9sHIiHiQ9+fA3VKdAdHYb0MjFE+BZbud
         w/jeRFTV8srjdR+g6F5/IPYXbgBD2vayUERXsBX8kHjKrURKQi9jZiMTvrFA/k8Pu6C3
         Ui/g==
X-Gm-Message-State: ACgBeo22mWzlOtGVqXvRrFWgKn/ptTJ5utGIFLjJo5V5zxIu5wfYCOal
        2KU0oRCak4E57FgIHZrK5064n7v16RI=
X-Google-Smtp-Source: AA6agR4jUoYOw1mLWClYVP1G66ez7Cv+lfgp0J8lUz7oTPC7xIJj2JmLz3i+/ZiZmF/iFIv4p6nVNEAQtAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c88:b0:16c:5301:8a52 with SMTP id
 y8-20020a1709027c8800b0016c53018a52mr7664129pll.95.1659720588888; Fri, 05 Aug
 2022 10:29:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 17:29:42 +0000
Message-Id: <20220805172945.35412-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC PATCH 0/3] KVM: x86: Disallow writes to feature MSRs post-KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give feature MSRs that same treatment as CPUID and disallow changing said
MSRs after KVM_RUN.

RFC as this is lightly tested and should come with a selftests update to
verify it actually works.  Posting early to get feedback on the overall
idea, and on the VMX MSRs trickery (though I think patches 1-2 are a good
idea irrespective of trying to reduce the overhead of the new check).

Sean Christopherson (3):
  KVM: x86: Add macros to track first...last VMX feature MSRs
  KVM: x86: Generate set of VMX feature MSRs using first/last
    definitions
  KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN

 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  8 ++--
 arch/x86/kvm/x86.c     | 90 +++++++++++++++++++++++++++---------------
 arch/x86/kvm/x86.h     |  8 ++++
 4 files changed, 72 insertions(+), 36 deletions(-)


base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.559.g78731f0fdb-goog

