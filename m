Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C675F5D52
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJEXwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJEXwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:16 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C157C76C
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:14 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 11-20020a63060b000000b00449979478e3so118606pgg.19
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8gkYQ0rFgQnjC6nE59q9xoa2jh+5mMBg8Q61YfACMkE=;
        b=kGh06vXg0dpCASzK8k6atO8K7Pw5jD1ii5C4Fq98ZIvKJSw25N99oVSz7ZUwhqduDg
         0rMiJsfSx0fnMdOGSzRspTiGZoRVhLLG16l534pq2/pJpD79vl53kPSroz20TZgbKLBJ
         5QZdyuH/tf9TsdAWPeo8BuIgcIEnDA8uZOd4balAgjikawKW6rECbpY0jpJcgxdrCa3b
         KrMgZ1Q3SeaLt4xjACNW/7IqJ0D4EtKAsALa4sJjWy1hrbcZbYBgvgErOgGTu36vm3y3
         Hg3Y6EdGilSe0D6p277NCW/HUuAvd1IAtsZW6hyeKWgGNNtReLKnEFLCd3D6koJiGI44
         aEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gkYQ0rFgQnjC6nE59q9xoa2jh+5mMBg8Q61YfACMkE=;
        b=YbvqqX+nR6HE5OCa+p9OcIVfFv3gPebXePeyx7SMDl5eshLdgxeZaEL2AZrCS+dn0q
         V9m0sEvDv7KxQT1NDb+5Dw4RBJxtn3RkVoN0Do5d/8lp2maE/RByeMEE4cQkGxW7U2uc
         phHv5fY5SPLoBWJ+fLTVXbV/Bt3jGPtNSgu4ESxPl9X36/orTAH/cr7f5b5wmKKT/hA8
         T8+9NQ9vJuYl2E2Mu1F+mym5R2T+ciEsIzxszO8sl2ckNCwBgBTW5XNcoP1uAqRJ6gGH
         qk6/OACkD7ATKKl7gyHDPROVTVeEFgL8TX2s0Qvm+52lfixJywMRbPjzB0x2/G2JeYGu
         jPNA==
X-Gm-Message-State: ACrzQf1SjA4xM+MOdQVxfCpPqswnNoxHwR0ZQWqaX8rqJ/VgKhHbz0wV
        wOh6qT9pytQIE7a4YFML7hMFljQtOOs=
X-Google-Smtp-Source: AMsMyM6rFeZ0MGN4qBZLLKZllc5XsruQaWf7CgyttjupQs3Kbn6q4fQb16yjyha219Xvz5PiNNTBNmSzFGU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1705:b0:55a:b9c4:6e14 with SMTP id
 h5-20020a056a00170500b0055ab9c46e14mr2241299pfc.40.1665013934500; Wed, 05 Oct
 2022 16:52:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 0/9] x86: n{VMX,SVM} exception tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
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

This is a continuation of Manali's series[*] to add nSVM exception routing
tests.  The functionality is largely the same, but instead of copy+pasting
nVMX tests (and vice versa), move the helpers that generate exceptions to
processor.h so that at least the gory details can be shared.

An added bonus is that by consolidating code, nVMX can do some of the same
cleanups that Manali's patches do for nSVM, e.g. move more testcases to
the generic framework and drop fully redundant tests.

https://lore.kernel.org/all/20220810050738.7442-1-manali.shukla@amd.com

Manali Shukla (4):
  x86: nSVM: Add an exception test framework and tests
  x86: nSVM: Move #BP test to exception test framework
  x86: nSVM: Move #OF test to exception test framework
  x86: nSVM: Move part of #NM test to exception test framework

Sean Christopherson (5):
  nVMX: Add "nop" after setting EFLAGS.TF to guarantee single-step #DB
  x86: Move helpers to generate misc exceptions to processor.h
  nVMX: Move #OF test to generic exceptions test
  nVMX: Drop one-off INT3=>#BP test
  nVMX: Move #NM test to generic exception test framework

 lib/x86/processor.h |  97 ++++++++++++++++++++
 x86/svm_tests.c     | 195 ++++++++++++++++++----------------------
 x86/vmx_tests.c     | 214 ++++++--------------------------------------
 3 files changed, 210 insertions(+), 296 deletions(-)


base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e
-- 
2.38.0.rc1.362.ged0d419d3c-goog

