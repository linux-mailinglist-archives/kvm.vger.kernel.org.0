Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6C5B61F5
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiILT6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiILT6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:58:52 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0D72A97B
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:51 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id d7-20020a056e02214700b002f3cbbcc8cbso3353223ilv.7
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=VC2NrjXUq6HrhQH+SnRXgomip2bCrQDorn2D2uLnJwc=;
        b=GuUyRllI2LhE7x4gBcI6tiTDX/hKhyLknUT8o/vh3GzO72kFFbqZXExrSRpD6H0zJQ
         XFqntUmZ1QcwtDjD4TZlnne4mlm2JarMXhbmOVJrAC9CryFvqIvYn9kpOkxpoHJS2SBB
         8P0cVcdAUOvewsA0liKYSDaE6amkdTwbS37/c8V83a+ojEwP6ii9VCe7YvvNRjT/+Ath
         5Ia9DamcDMafps0v39CerU8MdOeR42LE+xkT8YzJjBGXmZZUHzzhmRpuXRxlKVCIjj/e
         JEdte0stuh7L97EfPLnnoOoMxjIbxr6s582ZBbQDJspSF0kygxPHiSG9l135vMZmF9Sq
         9vNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=VC2NrjXUq6HrhQH+SnRXgomip2bCrQDorn2D2uLnJwc=;
        b=5yxpvGchzmQGRoodsSMdxPbLPKonwATa1XXi1hM5VA/Nwjzm+H6JyRK3mwMvYMSP3b
         LzIQwkQWWE1M0e1x6DsYOJNDamer8irigSawKlJ4MEzErDXeCwMQ3rju/SJZhd7rO8Bl
         JZZ4LH4am+w3ujZ7Ut7/Aq0Tpa6ci4/6CW26VEWRCzrglDSdFHREyAnjEXDat3rR63Ol
         wDqvnnY68+Umh2rjEp34q3WfiBO+T+tBQnev7N9cZNil+tDGxkYw3Z+03e14nKrNgbAX
         CO7gEpL3vza60c87TQiENAPs5t+WL9r9WCF9qtcf88aN8CdxBXVZuM7nZ+QcFV7x07Wj
         vvDA==
X-Gm-Message-State: ACgBeo3YQArsK8ZQHE1TG5mI6rEzKCBYFMn1vJjzlSmnMGTsj5p7MQxY
        n4a4lJZ5lTKBsayUUOYWLr7qfjucjJ/w2zquyVBeROzdz8aQ0N8FGYkJnnNR+CNm0GVzjquMRuf
        k2K9+BM1rvjPikOd9grq8U6ur7hT6yVUrBniRZrnz2KGApdNuyjibcZEQHW0Uz0dQevsvz5k=
X-Google-Smtp-Source: AA6agR5ttGDnBTIDqBQcnxRFRIAsq1oELVN0++E/grBBaRSgOE+gsOGo6gYReOdlZhf8LfaZZnlAsUixCKikq/ehbA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:4191:b0:68a:144c:82dd with
 SMTP id bx17-20020a056602419100b0068a144c82ddmr13150305iob.33.1663012730828;
 Mon, 12 Sep 2022 12:58:50 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:58:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912195849.3989707-1-coltonlewis@google.com>
Subject: [PATCH v6 0/3] KVM: selftests: randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev, Colton Lewis <coltonlewis@google.com>
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

Add the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

v6:

Change default random seed to the constant 0.

Explain why 100% writes in populate phase, why no random access in
populate phase, and why use two random numbers in the guest code.

Colton Lewis (3):
  KVM: selftests: implement random number generation for guest code
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 55 ++++++++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/lib/perf_test_util.c        | 39 ++++++++++---
 tools/testing/selftests/kvm/lib/test_util.c   |  9 +++
 6 files changed, 90 insertions(+), 25 deletions(-)

--
2.37.2.789.g6183377224-goog
