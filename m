Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB447271EC
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjFGWp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjFGWp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED7F19AC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bacfa4ef059so58000276.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177924; x=1688769924;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m3owb4sKUypoRPdh9mlYjXA6mdRzuVwdXPlbDuacY8Y=;
        b=gc1K0p55ZUBxeICSeqYaFUFR+ujqJuREWqQ+c4i7zfjE+Ola1lOqIXMQURH2VGOVlh
         zUVPxDdj5wf3QyVQcSRZp/EtBrX6Ujyt6YFV+JXJwec42FPxddSkvbeOeThSg6oO3866
         3Y+rX0ZsXR3ggazj8POOXnjgQYyvKtqCMkekaAT5dzib+Ov7X11ekY4+UQdYgxxaWVYo
         0DRbtvL69V8f+4urCV1lzVb2z4C2t1NZMUndhnViD2V1w6/cYArpXZIHDQF/vxyReQCy
         1VsdMELue9KvBmUMqz1pxmZ2B1GYH6S89T8fXaVrowYPq7H7V7qUWDtja+2GsizJZ1YP
         MGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177924; x=1688769924;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m3owb4sKUypoRPdh9mlYjXA6mdRzuVwdXPlbDuacY8Y=;
        b=akiMxoafmzn7PpdeIdbspEaSBI4mcSGp9SNIOvjZJNhQmVEX34AiWq823/88W5bo48
         Cd0FmYL8RtPrN7DhK51AUMb50XWnktgTmzJhRHNFxQSki6XXhU7W93BBNYd6rQtiXmWb
         o3mAKTtAwz2KQTlwR6+q3vYheod67D03XWAft6eSdwbLRtZQdOXut2/5A+661J4bCV5m
         xHOu6ABSk9Y37VKTCtMTX0OZd8hP2vPSO34XbNMI5LhaZg+8tb4Q7UyETHvWI9/HbGEx
         40gVNQAPL1hJuIQ7YKg3WFmW/SOKDWE+waCuGFYKwFiVPbrxyQM3EsAWbQ/CoY6iVH4L
         G+MQ==
X-Gm-Message-State: AC+VfDzhu4i5hRGUsw6Ck6IUVjxO95XZEidjZiLozk/a40/5135yoGTq
        3YDfdrbj9RK9gxYJb61wLLRN5PolLe8B/G2t5VXyZtGgFMO7l2CCQVaP3xX59kQyTqyHDAv8FS+
        y8GO+vdIh2A1gq7WOFxv290sJcYh7PRp44Jm/3q6G47b5ele1k9+m8z35upWAEhkii+RM
X-Google-Smtp-Source: ACHHUZ7cpqDPQKs4BsZAQobTFM7BvjNsRaqI3Lm3PcxgI5gCb45LnZn2weDNMF34iY4Ah7Rn4tfAmVaDLRVxxw0s
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a25:105:0:b0:bab:a276:caac with SMTP id
 5-20020a250105000000b00baba276caacmr4083352ybb.3.1686177924572; Wed, 07 Jun
 2023 15:45:24 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-1-aaronlewis@google.com>
Subject: [PATCH v3 0/5] Add printf and formatted asserts in the guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Extend the ucall framework to offer GUEST_PRINTF() and GUEST_ASSERT_FMT()
in selftests.  This will allow for better and easier guest debugging.

v2 -> v3
 - s/kvm_vsnprintf/guest_vsnprintf/ [Sean]
 - GUEST_ASSERT on error in guest_vsnprintf() [Sean]
 - Added "Fixes" tag to patch #3 [Sean]
 - Removed memset to zero ucall.buffer to save cycles [Sean]
 - Added REPORT_GUEST_PRINTF() for the host [Sean]
 - Removed ucall_fmt2() and squashed it into __GUEST_ASSERT_FMT [Sean]
 - Fixed stack overflow in guest_print_test Sean called out
 - Refactored test_limits() in guest_print_test to account for updates

v1 -> v2:
 - Added a proper selftest [Sean]
 - Added support for snprintf [Shaoqin]
 - Added ucall_nr_pages_required() [Sean]
 - Added ucall_fmt2() for GUEST_ASSERT_FMT()
 - Dropped the original version of printf.c [Sean]
 - Dropped patches 1-2 and 8 [Sean]

Aaron Lewis (5):
  KVM: selftests: Add strnlen() to the string overrides
  KVM: selftests: Add guest_snprintf() to KVM selftests
  KVM: selftests: Add additional pages to the guest to accommodate ucall
  KVM: selftests: Add string formatting options to ucall
  KVM: selftests: Add a selftest for guest prints and formatted asserts

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/guest_print_test.c  | 222 +++++++++++++
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../selftests/kvm/include/ucall_common.h      |  24 ++
 .../testing/selftests/kvm/lib/guest_sprintf.c | 307 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +
 .../selftests/kvm/lib/string_override.c       |   9 +
 .../testing/selftests/kvm/lib/ucall_common.c  |  22 ++
 8 files changed, 594 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c

-- 
2.41.0.rc0.172.g3f132b7071-goog

