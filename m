Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DF36AD383
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCGAzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCGAzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:55:52 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793632884F
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:55:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d185-20020a25e6c2000000b008fa1d22bd55so12495537ybh.21
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678150550;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NGOAsr/xqDKppYOJ/B6BgMqUFwruIKR4W1/kqwYVKdU=;
        b=P9sNKQAy94nPOzIs/Vh6lGutXWcqu6GzArgbiSMPghU2no1bh9QzHar4qhAfqfi6m+
         xEbC6chzYduJdmy/kZ5MASeHGctIRQDoIzrbu7YaOzffKTIPdwU19dRncRHSa/ukeUCB
         2noxBMIJ6NnPpxBU9vfBF2SzR/UyaAORbhLogT7yel45OGmwsujoGHre9K/OUnXM+Iqu
         kMY6NJOLG0k0YYFJdzLUbhXPYwX21pgax7FJAS+3sTXeBxkfD436o3zxEuTIMyMXOVz9
         dojOBuzQzZcZFQ0QKbEuIT8V1f8iLKk5WeNSbe/GlTAbmVuQoGj0ZdvSMbM81mJSpu+i
         UQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678150550;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NGOAsr/xqDKppYOJ/B6BgMqUFwruIKR4W1/kqwYVKdU=;
        b=vy/eBwgdPhusENQxXSs72YHLO/1Ga8MghOmAiKihslva/DfO/WVbVjTYMlSl13CgxH
         JmTVqxNzntdjaLx6fnZn1qYZuDDRhLnDl1ibKoUPLGyZRDEs6pm67qjyBSIi+W8Uk5Fw
         v4Zw/2jGSdQ6w41WFgSpGz+JmnagFtM6agJjwb0Aldr4G5cVlZIhnQu/MBhvGUwJWujS
         TrgoEpYeQKIz4OCJ4DmWkW1eZI3ABR2d4CbiKEYCvmeFrG8YnPqjSBS0UTOOqRTGYBSl
         1WMVMB3WDGq8VCIq6EUOVicZ4YhRhe+frb9Ns3AB+6KODTZ8sZ0WORi1TvMNuSvFC+re
         jd3w==
X-Gm-Message-State: AO0yUKXsEc7nT5aicgx9BSNLcBN/1y+0G96qJdpSszhxGaJtToz2bVJp
        3W8Rv40idpt24kIcAZvwqGpVlYB/XDRsVw==
X-Google-Smtp-Source: AK7set+nBWaQGBVvicbgEkF6BzgmuF83Gj7qqSI2zrITrp/ATWf2xTkfT2ApCEM/61SxXhjzYkJKHuvHUz0PlA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:208:b0:a98:bd27:91de with SMTP
 id j8-20020a056902020800b00a98bd2791demr7552025ybs.7.1678150550782; Mon, 06
 Mar 2023 16:55:50 -0800 (PST)
Date:   Mon,  6 Mar 2023 16:55:45 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307005547.607353-1-dmatlack@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: Fixes for rdpid test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Fix 2 small issues with the rdpid test that is a part of x86/tsc.c.
Notably, the test is not currently running since qemu is not configured
to advertise RDPID support and fixing that uncovers a bug in the test
when compiling with Clang.

David Matlack (2):
  x86: Run the tsc test with -cpu max
  x86: Mark RDPID asm volatile to avoid dropping instructions

 x86/tsc.c         | 2 +-
 x86/unittests.cfg | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

