Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C367446A
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjASVbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjASVbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:31:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC34A7906
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:25:27 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s4-20020a056a00194400b0058d9b9fecb6so1459026pfk.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vgnyLDNSgvwVcu8AmZopvdgW3ASujbk2oM4NuNZjZP0=;
        b=g898MByqpR4QSdftZPPM8wJDP652HbA9+ZoMck6HqIY8547fIVJkQecY35bALgkuPd
         PwVfUBLHI/Pc1DE+zmAXJ9FoEqn7DOqt7PwrqU6yyZSn7YCmGVfH2QIQmUWB7Xp4j5no
         DkjiYEr8kDHWxOVqs3B22PKilcSQ65XNsUUM1RaWm9kTSjcjeQewFvrsBsr9jhq8B54m
         Dm4z3FlRDZzfXGw1sxpe76q8kM+QRApZA/E16DnbeYu5tG2boGFuHaPhKsL2sNLhSru+
         8f92Y8e1sIWEb0uLYDXnx0XLEfL83kjSWOuL1N78+JcgqIlRhHGLkx97xR4ZklUL0T++
         RVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vgnyLDNSgvwVcu8AmZopvdgW3ASujbk2oM4NuNZjZP0=;
        b=iOhfDEanrhMC1NtLK0YmnL4WN9TPJIJ5ZHJly8xcDlxtczF1c/u0N4uDxf0cnlR30+
         HQY03nVNMnJppot/wU5UrLTGtz2+zthvKmVgnha+5vyqKNdWMEM+l1JGnkGdYmXhI85I
         FVpXxA+EdBeALiMkWoLIRP/ZBAhMlCIBWwiYDzlS/N5O0Am9Ti2kEwkixFj6odCUgKX7
         2zvT01kD9qgaRlYaZL+S8GTx5sIMEcm638fenld2tJd2y9xepadkUJZoTPD99aiaPWG4
         6yf6iKYHCOgTTfW1uoZYLDDPBYt5Z/XD5kXbUbErHEeSVH0Siu1GOiXXMWjaPMxb5bl8
         7aMw==
X-Gm-Message-State: AFqh2kqdkyHW+bkgCRBDfWl0NSvqpoKKea+QWuZsFl/5570/B1ws7flX
        1CrBN8islMXPm1ufzdsteQVma4L+mGhH
X-Google-Smtp-Source: AMrXdXsRjd0daJT+VjjXiboL/8dO+R8B8aw5WpitBxaWhaDlAZ5nDoMUEkMtP6482azch2U/BAwlzi7Iqqq6
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:d505:b0:229:1740:1051 with SMTP id
 t5-20020a17090ad50500b0022917401051mr1239826pju.111.1674163513524; Thu, 19
 Jan 2023 13:25:13 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:25:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230119212510.3938454-1-bgardon@google.com>
Subject: [PATCH 0/2] selftests: KVM: Add a test for eager page splitting
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
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

David Matlack recently added a feature known as eager page splitting
to x86 KVM. This feature improves vCPU performance during dirty
logging because the splitting operation is moved out of the page
fault path, avoiding EPT/NPT violations or allowing the vCPU threads
to resolve the violation in the fast path.

While this feature is a great performance improvement, it does not
have adequate testing in KVM selftests. Add a test to provide coverage
of eager page splitting.

Patch 1 is a quick refactor to be able to re-use some code from
dirty_log_perf_test.
Patch 2 adds the actual test.

Please ignore the RFC version of this series. It was not meant as an RFC
and did not include a cover letter.

Ben Gardon (2):
  selftests: KVM: Move dirty logging functions to memstress.(c|h)
  selftests: KVM: Add page splitting test

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/dirty_log_perf_test.c       |  84 +----
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 .../testing/selftests/kvm/include/memstress.h |   8 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
 tools/testing/selftests/kvm/lib/memstress.c   |  72 ++++
 .../kvm/x86_64/page_splitting_test.c          | 314 ++++++++++++++++++
 7 files changed, 409 insertions(+), 77 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/page_splitting_test.c

-- 
2.39.1.405.gd4c25cc71f-goog

