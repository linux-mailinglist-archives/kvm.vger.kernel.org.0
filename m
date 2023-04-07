Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC596DB72A
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjDGXdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDGXdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6462729
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:32:58 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-632389f445cso14629b3a.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910377;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRFfGCNYU6a9c7OPY08Uh3X5qPL1V3ieihDSvLze5po=;
        b=Kvf1I863Px7zDIwZUoHF/9GN4oS1ZdCANhbqOYWGjePhqDS0RqTcfqz9NIDd/62xWL
         FQspUh8spjciJCMHCtzu0CVkTByfvX5Pv7SfexMl8O9ghC4sMDQVGO9J1vIzNkqiv7FB
         prGjHI4cS5z+jRy3BOabpa4KCl6mdNXLDq1x9ER3JMG3ChuMi+eSc+vy3qscbh5tMEdq
         n3viIQn2ncEzFruzeMGrm2FQJAkU48ggJqw8XhZipXKQeI+wXcXLr4tdeSTzlPl5rXca
         w/B+dNyOfziZwNhl4kTQLAdbQbscb38x+R3WrhR6toclvS3s+qTk8squWiYAGC0qD+OI
         dy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910377;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRFfGCNYU6a9c7OPY08Uh3X5qPL1V3ieihDSvLze5po=;
        b=14Ize+le4V3VJd9gC+Z2arlVGyZgqfKhBHwmzPD/G3BmOmNLlbbx/hC41VtRafAH+a
         woPt8UU9mM8WfY4PA7O+4F6BNc++nIFQ/UdCLQnnCpKPnyvhb/kmHcroPUboBX08IuqP
         tSlGzNjrFTGS1rbRvHiZpLIPkB2S24Z04PDCW8pwuVng6ILvjpIBWQjGxflkhWk9K/UC
         ogfQlZu/j+dF2uvk8ogyCltZD6qrSr2RMjaqfLi3gwrMcAwguvG6vCYid2LN9Om2G5Lg
         XBqh4FOA51qc8lu33U9ASXg3MD/2Ma92EpP80z0ssHVZ8cWH/PFfLNVJhXUN0KVR+VHQ
         cNwg==
X-Gm-Message-State: AAQBX9fXjPwLYOe5MTaeP6R2XC6ZWKEUo2Mok0dlPbWWEFScCY+H0qfV
        He/gBhcVuDA9XQrC7rUTU1halMnvZ+I=
X-Google-Smtp-Source: AKy350bys/8h6CZ4FEZilBfTeR9Twb/7vd9zDyxnMtQCVv8tB6XefkqXa6lZKKO4bQkEBCTsxLHv/XH9AI8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1916:b0:624:5886:4b4b with SMTP id
 y22-20020a056a00191600b0062458864b4bmr119487pfi.5.1680910377692; Fri, 07 Apr
 2023 16:32:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:48 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-1-seanjc@google.com>
Subject: [PATCH v4 0/6] KVM: selftests: Add "instructions required" testcase
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
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

This is the selftests portion of Aaron's series[*] to fix incorrect
"instructions required" counting.  The big change from v3 is to use a
common struct to copy counter values to/from the guest instead of smushing
the values into a single 64-bit value.

[*] https://lkml.kernel.org/r/20230307141400.1486314-1-aaronlewis%40google.com

Aaron Lewis (4):
  KVM: selftests: Add a common helper for the PMU event filter guest
    code
  KVM: selftests: Add helpers for PMC asserts in PMU event filter test
  KVM: selftests: Print detailed info in PMU event filter asserts
  KVM: selftests: Test the PMU event "Instructions retired"

Sean Christopherson (2):
  KVM: selftests: Use error codes to signal errors in PMU event filter
    test
  KVM: selftests: Copy full counter values from guest in PMU event
    filter test

 .../kvm/x86_64/pmu_event_filter_test.c        | 252 ++++++++++--------
 1 file changed, 140 insertions(+), 112 deletions(-)


base-commit: b821bf96cf3bed0c1c8d34659299a3a1dc47218d
-- 
2.40.0.577.gac1e443424-goog

