Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297375B380C
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiIIMnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiIIMnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:43:02 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7788BD283
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:43:01 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id o15-20020a056e02188f00b002f01f1dfebcso1138028ilu.10
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=BpqbkPKcDhdlIRWrabhwCy/ar1vPs4MzAW/ZR1quW9E=;
        b=HKSju2SGXgvt9DTlrQHi0JfMQHGp1PPlpPD/AYoOfBmNw3++YSpe/qmHSl72yVHuMX
         8y13EQIsOLD8/FjuErS/SIzXHA7J9dJbGzC7+mQmI5YnUQS+EUHcUvlgX00oV951QqXt
         Xdlc+WxS026ReEbqaVjlqIOMijawAMCxhNtKvNtyqOziuYefwfyORi5NbjTpKujv5N8G
         GTGwWdgD4GMck7V1ZtO2RA+3WvwGKX+kIHMxVEnJJ07+Km8g2XevJu+2kg2il48PGNCD
         dfefJAC5gnq0xUApe2v1web7PirysQku5M6Ecj+Cg9X42DbnuFlQtfkc9xgH1xlz13mo
         nujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=BpqbkPKcDhdlIRWrabhwCy/ar1vPs4MzAW/ZR1quW9E=;
        b=fcR1KgHhtfk/RUu8myQrsoYUxxqGbTgz7iB1aUpuCVPy0zxe1lGNXISswzV1iZdQrO
         xVmuUW8ZCjg3VZY/LlLffIebVZq/rlV7Zid4jOGfgyKmKto93ME5C2D+v+UPXk9015sG
         9zcehWhG4Gj6HDZjipEr7qrJHB3jeQub+UNA+pPq6UnAEVDFxgkOCCqzGErT9GnlQeEC
         Hc5WK9I8lfBL9E+XED70QgxAjQw7DeISZ1AilXSV97dWQSO9GPFeqw/ndydFHIklEX8h
         yObpD32scf+LKJCZ1OvoRzjyPRCHKWhj8vjG2AISHW7kIzYKGorDH7DZghMHr4UndiKv
         ckrg==
X-Gm-Message-State: ACgBeo1N3KcqmRqViBZ7PuombncviVW+rNSEe8fCHXpQe/uVZf/YJuKr
        Mp2g3Q2IZpIoqkRlbBMl4Y7swgjhYaGrjJUHzBM6Mx811Spraq49JawuAikAoV0CjgBtzAMnNMP
        x2wKOlC9Qti5TzOpVwddsFg1NuNC6oyeukeIeYWFUUtfKDlxffQdX1A2uU3U4CdvuVmJ+09I=
X-Google-Smtp-Source: AA6agR6IHVZbKK9EVvJ6D/6EcmlJb/MDt9omQFTl+o4PoLdB9HHwDcps+3cBNYSRAkhxo9sESbsc4KodTJeWJlumxg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:b885:0:b0:680:4929:618e with SMTP
 id i127-20020a6bb885000000b006804929618emr6268739iof.30.1662727381087; Fri,
 09 Sep 2022 05:43:01 -0700 (PDT)
Date:   Fri,  9 Sep 2022 12:42:57 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909124300.3409187-1-coltonlewis@google.com>
Subject: [PATCH v5 0/3] KVM: selftests: randomize memory access of dirty_log_perf_test
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

v5:

Return a few lines in guest_code that got lost when rebasing for v4.

Provide the populate settings _before_ the vcpu threads start to
ensure they take effect for the whole populate phase.

Colton Lewis (3):
  KVM: selftests: implement random number generation for guest code
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 49 +++++++++++++------
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/lib/perf_test_util.c        | 36 +++++++++++---
 tools/testing/selftests/kvm/lib/test_util.c   |  9 ++++
 6 files changed, 81 insertions(+), 25 deletions(-)

--
2.37.2.789.g6183377224-goog
