Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD261FD5E
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiKGSWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiKGSWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:22:36 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B251AF0D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:22:32 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id 15-20020a056e0220cf00b0030099e75602so9377499ilq.21
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CPH7Fyc6lBr9UZD8MCVONU1MftilQDvFU6aPtcRL9X0=;
        b=tXUOF0ORSw+B0jy6sE9c74s8+AfI2/J+WyFNFLZQAFcO2ZW8rGyFFoYh0i+0A4dMrk
         h/9jUGm7U+0iWQL2LLHN9EkLRZuWq+iopURmG3qlj5yy6iSseLEBt9kcfG5gSI7a+eyj
         kpSF+HiFY8Uck3+O0JiUq2loVTHPJcncTfc8w0z4fcq6zawvMjBiv8MwR3/gXj+zxyIx
         mM3qMfIVYmlKXJHppMxunxIpv10RwymL/jjf7tQRJ01cqbCQesmmZiL0fyFfuuW4iYEY
         6ae3hHkNMIgepD/j0Cg8o6tPBBouyKkt3FbTUPAWpC9fEpLQIBkIF0OdwSRNN7p1Iimg
         nNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CPH7Fyc6lBr9UZD8MCVONU1MftilQDvFU6aPtcRL9X0=;
        b=3bf7ao5dziKoW7y2CSEaLxgGqASguEM810KeQ16Sk640Mw5VnS5rj/wlJp0al3RyZm
         ZcMq8VGV1y+Ay6hR1MpjP5r1KUYtYbXprbC4qXaYUUFk7+5Mb+2DdjgBiR2GKvg8RlXM
         PdL9ixw+E3f2W1dVufdgRHxWsS/16F06St86VairIXsx/W5K9CAgu1w275Gh5aDhfwVT
         BH+fjOpi/dGxtRWJ+/Fxz8ADXpV0SJ2QY6Pf5zBrSCo2vXRLhIYin0OYzQiOphFVkHBB
         MVOhJ4LiU3Tehs13+Rb88mLRrJBB11cRiKD49KMt9PtuYTa4mEWW/OXtitinQlblmlrw
         5zNA==
X-Gm-Message-State: ACrzQf0iJOIsgBwK4T/24nxzrB2hFJJUQr9qpc9iMfoVQ9syY2XQapYG
        QGfznkN6vifghPcEw/uLbbIq1wfU2Mu0htXzHkKfJM+9AfRmOZ8hsy0mZ1mJ2B2Nx6o7F0WXISu
        pYDRSVZVrg5whMfzgn9SnMCx9UmkIOCtvMQiN49rwdVpLZzJfWyUi9hzMeaXyCVKqstbmx60=
X-Google-Smtp-Source: AMsMyM5TADBv2QkNPeb5vpbWhw96xD82U2zYx9EYJzI4h8JvFt+zznTmMDfKYaRqkhlp2WslAjTgSKeHlJs/qvZDnQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:3e89:b0:372:8e2d:18c3 with
 SMTP id ch9-20020a0566383e8900b003728e2d18c3mr29724542jab.158.1667845352111;
 Mon, 07 Nov 2022 10:22:32 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:22:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107182208.479157-1-coltonlewis@google.com>
Subject: [PATCH v10 0/4] randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

Add the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

v10:

Move setting default random seed to argument parsing code.

Colton Lewis (4):
  KVM: selftests: implement random number generator for guest code
  KVM: selftests: create -r argument to specify random seed
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 59 ++++++++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  7 +++
 .../selftests/kvm/lib/perf_test_util.c        | 33 +++++++++--
 tools/testing/selftests/kvm/lib/test_util.c   | 17 ++++++
 6 files changed, 102 insertions(+), 24 deletions(-)

--
2.38.1.431.g37b22c650d-goog
