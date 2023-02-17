Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5172C69B525
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBQWAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQWAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EDB59726
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v74-20020a252f4d000000b0087f69905709so2321287ybv.10
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PW2KdVUqNPbPkEzfcwjROGUM9ZPAiqhDv7wTs+xZ4ZA=;
        b=JncmWJ0cuquSd6NCm6T5mAe2VD62yllYSbbgjhYLjWUiE4o2/8cIpWdhgkyrbnWrkT
         srA1DfhQRFUHa+GrdvHA5PqcCvGJiArIttAYfJly+UZ720Fc7lSDaAaT5AgiSKDipzpn
         4uMQ/6UqQ8KIb3SrV8H3iiCcvlV1tepjL/opOf6H3gXqXZ05jaP882ezGzwBuy5i3uYn
         SDBpR0M+/1qrXH4P6dx90igJVzWVsx2HXsRxPiWv1/r2cjqL/kaoMP5h34jxCijTs8ml
         +hkpji66Bul/Nts2X9MlckSyM/9R0+GXiLlha7LMVjc0+jU17PrXxJY3/ZohJpF8Fngn
         M3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PW2KdVUqNPbPkEzfcwjROGUM9ZPAiqhDv7wTs+xZ4ZA=;
        b=WZlRTEk9cZ+0oqzsR4MqTF8g6TMWcmm+yGAfdex5DW9PdW5Ue4uDBQn5CwKE6KcsXs
         92RIOUBq0+aEOFWxNoC2x7k+QC4zS0l4u0XSDxat3SitLt0KAQBFoJApIMlhjO5KO6RJ
         B8nrezs6oirr7LIcggOJ2GSlz2kyzI/K47wgt1YtZDEi7EPnf06VQLvFwbiB7ewWzh1M
         6WCXKPC61dnit+HOp3BM/VzOtc9GD8IU6+HkDNgaW+Z9cJPzgWC5Hi02ysJlz+Y5+Rro
         zAh9NETHEg7AFehr6qvtNQMgXkswD4HMWxxE8Rg7BwZgm0sPqTVGArQ6+GCHPLw0Ubw5
         ocrQ==
X-Gm-Message-State: AO0yUKVt/oa56pl7C07qBJdgl417VNXTqpLLPSIG7DEcQgDHXd0F12YX
        DBQPc6FTqRYzt2Z6rAN27YAveK4eP+xJIw0f90Y+pvdF2i2EPykOjhT28m01u+YeKi7r1U/KKjz
        i/H/0mXaJkU7QwpDvxHFq0w1vLbDByBXYuUiPWJL9q/XHe2OaHEcyFlL0hPLGYQiz43TN
X-Google-Smtp-Source: AK7set9YsXeSm5bbBKIYmCnkphhO6yv7TCVSJE7yorMdtgl3GEc4rx1fS/2tW0qBjg7TTsEYKdXP0zAaJiJ+AN2F
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a0d:ff41:0:b0:52e:e9cb:115e with SMTP
 id p62-20020a0dff41000000b0052ee9cb115emr1377139ywf.110.1676671210042; Fri,
 17 Feb 2023 14:00:10 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-1-aaronlewis@google.com>
Subject: [PATCH 0/5] Overhauling amx_test, part 2
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

Here are a few additional checks that were missing from the
selftest, amx_test.

My hope is to append these to the end of part 1 of this series, so
we have one series with all of these fixes in it.

Aaron Lewis (5):
  KVM: selftests: Assert that XTILE is XSAVE-enabled
  KVM: selftests: Assert that both XTILE{CFG,DATA} are XSAVE-enabled
  KVM: selftests: Remove redundant check that XSAVE is supported
  KVM: selftests: Check that the palette table exists before using it
  KVM: selftests: Check that XTILEDATA supports XFD

 .../selftests/kvm/include/x86_64/processor.h  |  2 ++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 21 +++++++------------
 2 files changed, 10 insertions(+), 13 deletions(-)

-- 
2.39.2.637.g21b0678d19-goog

