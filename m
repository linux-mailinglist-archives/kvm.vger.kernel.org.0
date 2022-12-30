Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1B7659410
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 02:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiL3Bg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 20:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiL3Bgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 20:36:54 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601C81649A
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id ot18-20020a17090b3b5200b00219c3543529so13026770pjb.1
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4xiV62pNGQJSedRAUEw6KR0NzlfpO3uaytwwH7Lc8pk=;
        b=ivbqF4HvviyfhLpUZMG7IqEXiKHm8yQAw4zGpcAEm8FWGUUySiiwYO7Rh8j9DsRxPB
         PdY7YDIKN1tHqGoAflwkAyfWTKRO1Os6M1jtGBL7nuLNCt5qFCFvJoDW7RDTKyGBTHLF
         kKrDi/+IvSaGQzDqdtbOGNiaoAV+dZgH6JZy6TSnaXf1QZ051VsrPUqRwfg6/30Zm4O5
         J9UVx5dqxuxhDycbNR+OEBnkB6JgqxphVnN+z5+0g6yrN3if4vXiVnXybA+6GF5A9Zz8
         3PNOydsBkl7jhug5gefGjHB8pm0L1zVOM5mzF1qFeNuWyUMDAucasGtYD0inb8cjy85o
         1FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4xiV62pNGQJSedRAUEw6KR0NzlfpO3uaytwwH7Lc8pk=;
        b=H9Hm2b8/7mSt0PADe1NVBglxthTyUE+z6dnZif9GYRZq5xBYPRK9B/LD3TIqHEoAT6
         oNkKG+yebRDvK4sgSydA/oLJmxwkIlO/HWqmn6jDe4zMJ5VAGqMWcGQEgrV/FveEKT1o
         PRGQFnHO+GO9rOk5PPq5wYXT5OVbR5evGLePTmfHUFzUXNz/Qqit/yZQCbj1LmbZsgrN
         hvqfHCYnReGN9OWKPF6lU4syGyfaf4z3s80/hjvNPz8uV0rM7Cda8gHldMEvBlUu28HH
         4BQIeqj91COwgzPX2a6HVWgTCyco/YBPZWFRivREZstdG2+ZIyFK1yJpF1sSib5KfmHU
         uh6g==
X-Gm-Message-State: AFqh2kr7QuhnCGEpR4vSR/OBml/yD7rTm1mbNPNSdkqoXk0w9thudmG0
        1nbXjrtsASiqLuoyU92Bc4vafWDd1Lqga8nGyylyd4U9U8tw4VSNwzQC/cv4gvnccDDYWV4Pj2c
        cfeXKpU9wTLslyzimtDzvbhpCG+MI3DpQPUtS4k0X7H9quL2dXimtDoPELLBz8eUkvD20
X-Google-Smtp-Source: AMrXdXsXenBZaLG/822hBDQYzlBt87ax5psM836XQXCBhPtwrHnjd0jm+yMSo1Y91Y25fqTBET1KFvhAjPorlveR
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:f0f:b0:225:eaa2:3f5d with SMTP
 id br15-20020a17090b0f0f00b00225eaa23f5dmr321574pjb.2.1672364211880; Thu, 29
 Dec 2022 17:36:51 -0800 (PST)
Date:   Fri, 30 Dec 2022 01:36:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230013648.2850519-1-aaronlewis@google.com>
Subject: [PATCH v2 0/2] Fix check in amx_test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Two fixes for the same check in amx_test.
  1. Add an assert that XSAVE supports XTILE, rather than doing nothing with it.
  2. Assert that XSAVE supports both XTILECFG and XTILEDATA.

Aaron Lewis (2):
  KVM: selftests: Assert that XSAVE supports XTILE in amx_test
  KVM: selftests: Assert that XSAVE supports both XTILE{CFG,DATA}

 tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

