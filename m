Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2816166C6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKBQAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKBQAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:00:16 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6F927FF5
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:00:14 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id s15-20020a056e02216f00b00300d14ba82bso1537746ilv.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CdCaHBJOLAr/Rfn6Q3dVwACvagg7gE9stE5ywVMabM0=;
        b=PkRnxFzmz03fiK/ppQFdY4AXjUry7YUVPwd4TN8nAOmiLjOz6/cyzs3EdUUQ+zL0xB
         1w5KpykzHXlIOkl0NnX4vnuozvEXbqAC3gwxN7CgD3zVk+5Ec07xau37RJfJt0FiJ5rk
         nvvef1jUbYk06Run06OYb0gMA3NdoxozUZrS2tKtoz20Mou9tza7iZ6thioieCTnwXHC
         N92RYs4s/fUfAyMXmYT/qVlIiRQn0ZJHLAJ6fLwpjCdywbll/F1s5u65ADV5+i/dw5k3
         sLANeqtKaV+YiUO9ILEu9zf588s3YOIAAzRf2jAjb7NEdVpwui4FeYpXwSQJLbC0T6KW
         qZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CdCaHBJOLAr/Rfn6Q3dVwACvagg7gE9stE5ywVMabM0=;
        b=BeEzgBGsN7Ez7gs44/Vjpn4k5lahRaFfAIgU21Gjui4DvA6uHIGI98vd+eBwWlXOIo
         Bplg7JW9SRh9KwPaCM613BKUKoPNraT3zwxUE77VtUpXYWmDrGhshPDJiOZZzl2aT4i8
         V5kk3lz9cxfaiN8ecZf2mYM+348bihJ4svo4AF9Om5Djx1jF/skCVtUERidtT1aM/ZxF
         JametP+f7sHW7iwWQgzNM01QvrxnzV8tda0pAJ0zo/4/mVyxQ3GPpQ1klkOKWtxvSWjb
         2v5nPwOKbvyNchqTie25xUY9ObHNVxcjPMOHQAuPFDrhrRlQHEuRgXMO2vvoxZyX7e8Q
         K2wA==
X-Gm-Message-State: ACrzQf0ATXzrib0BAroXOxyoIWXTBGTaV+iPpDbDYPJfjV/yi5Ie6c7E
        Kuy+sN5F4iM3HP+NJ7vwJL9LnV8c2m/redCpUzIrjpazPm/1MA31oWgpvN/dqYJYp3fR92MdjJF
        EGjhSkatG1cU+kOts9D2EJautaGPPVXiXJ65Xk2waGRJwmvjIt6KwR5EW4JWzR6mAbWtmgwA=
X-Google-Smtp-Source: AMsMyM69+KgjI8YAma6sgYgnOVaxYWJjmhEX7q6uTOZlydBWXll2jkZCEmhrF3zegXju0epqR3cEamUTp8uNBtF+3g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:c8cb:0:b0:36e:3514:bdfe with SMTP
 id q11-20020a02c8cb000000b0036e3514bdfemr16855898jao.172.1667404814085; Wed,
 02 Nov 2022 09:00:14 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:00:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102160007.1279193-1-coltonlewis@google.com>
Subject: [PATCH v9 0/4] randomize memory access of dirty_log_perf_test
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

v9:

Move declaration of rand_state to one commit later to reflect where it
is first used.

Formatting.

Colton Lewis (4):
  KVM: selftests: implement random number generator for guest code
  KVM: selftests: create -r argument to specify random seed
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 57 ++++++++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  7 +++
 .../selftests/kvm/lib/perf_test_util.c        | 33 +++++++++--
 tools/testing/selftests/kvm/lib/test_util.c   | 17 ++++++
 6 files changed, 100 insertions(+), 24 deletions(-)

--
2.38.1.273.g43a17bfeac-goog
