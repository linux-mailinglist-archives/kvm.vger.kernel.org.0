Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6E648930
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLITuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLITuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:50:04 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BE22F39C
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:50:04 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s16-20020a632c10000000b0047084b16f23so3643071pgs.7
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 11:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O8SjvYiMaT2y0qYdp6mF85H2g6bjWANTLYcMsqwC1ME=;
        b=IfHgqCWk/g09o94CdKn1AXE3i4yB310SP8060aBZdpiLjaBqmct7AVVseksW2OWARJ
         ERP+8XQFA7YMYZzgYltQ1JNax3AeQNSbt6xIGRaMqpCl0qadZoDFrLH+1PYC6cXJJji6
         +mAflBK95yFr2mBhOZvuYdivdU6D3GmcV6r1T5441mLKu564CL5KAb7NUTd7IwdjCWBF
         dHDQexO4kFghhm8cVWWyxrB5ViFYt8kr0GdV96sCa942shgfFbt1NVJlZGY1oscvfXV0
         GqO+MEky/J+ujN71HNXft/2f3yrZann/uHmg5ut27KzU11qPHgbgMSLZP/s23RBS9gFd
         bm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O8SjvYiMaT2y0qYdp6mF85H2g6bjWANTLYcMsqwC1ME=;
        b=MRMHZoEr3Qz0oHSq37KNV05WqqlbPBSeEJ6T0DnZpA6KYopkkqH5vRNrfdp0FUY02s
         +zGEQmycO7uL2w88m/D9IBfuMtAIJ/nDxNP+0GigbWI67SmPnEfsDPCRP+wn6ASEw7Wb
         rkdvaSyB1pvcsNlhVc9nLwa1P+j1vNlhL1pi5qf6bw30bxJ/jh1heVKS9s/c4dNDLpbr
         TpZCPP1EIdrpM1Nr0kZYNUg7So8oVC2vJVGvSQBQunAAsJ/pYTEvYnh4Iei8//RKZ8sh
         c7kpPAcvpExp3IFiFVIndnRnnVEUQVPKgrqo+IMoCpZy5M13eBHRbSm34fSpvTS3OeOg
         6IHQ==
X-Gm-Message-State: ANoB5pmpxLiGnt2gNBmmxQBxfVGtWtOpgMN7F7rBRS83SKSe9JZ1e41h
        nDOL1O87HLnFqAiJD3GE8rwlE8JX+/mvI8UFEzvkXsIIeLjpschRR7pq1BSx7hXQVfm/SLkLpwB
        0jvBq6PyAxpypsgglN/PEY92hG62jIbU258zomqzCZMLeXJIt9pITbkDjekGkvoAsJY10
X-Google-Smtp-Source: AA0mqf6BI9xQdBqKMBuGQ7eIMvMdVCXRdqdXjqE8PDCVnWlscbI/UYDC2ZQ/n5Te4rotiHAwmyZdu7fwCBUv+nJE
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:d88c:b0:186:a7f1:8d2b with SMTP
 id b12-20020a170902d88c00b00186a7f18d2bmr80520064plz.137.1670615403475; Fri,
 09 Dec 2022 11:50:03 -0800 (PST)
Date:   Fri,  9 Dec 2022 19:49:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221209194957.2774423-1-aaronlewis@google.com>
Subject: [PATCH 0/2] Fix "Instructions Retired" from incorrectly counting
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

This series fixes an issue with the PMU event "Instructions Retired"
(0xc0), then tests the fix to verify it works.  Running the test
updates without the fix will result in the following test assert.

"Disallowed PMU event, instructions retired, is counting"

Aaron Lewis (2):
  KVM: x86/pmu: Prevent the PMU from counting disallowed events
  KVM: selftests: Test the PMU event "Instructions retired"

 arch/x86/kvm/pmu.c                            |   4 +-
 .../kvm/x86_64/pmu_event_filter_test.c        | 157 ++++++++++++------
 2 files changed, 113 insertions(+), 48 deletions(-)

-- 
2.39.0.rc1.256.g54fd8350bd-goog

