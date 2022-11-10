Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87CE6238D3
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiKJBaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiKJBaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:30:06 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033F622B19
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:30:06 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x14-20020a17090a2b0e00b002134b1401ddso233744pjc.8
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGW9SN/GU1zlYr612KLp3zu/eRHjgyHcOmNcSA044xE=;
        b=Vr19dn9AojCDpmbeuLHsQIs320UZS/f9vRkdbWhgZ76TTVay1/WB+OheKVdr3k/Kgp
         VjZry09gHmd3XLJLmidZYD7TJn/xJfCO6FQuC91vY5JvHa/odf112ViOSJc+9h2v+yJo
         pfHqrQzjpUcpspCwiLfQpFDMIjXGMlIzewZSxzlCfYkCzFz3Xbs+6KxrvJQho0aQbjC3
         7v9v2UguuY9ghN5fejm5UGajgyc7xxOX7uLbDc7kOA2fy2jpWQk+T6UtQKixExc2v30U
         LWNW59Yuhm4Aijz9kJyQuP1hZQ9+K/0VZK/2DAVpAsN9IvsrkpN970uVTvtLWqBe92fh
         iIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGW9SN/GU1zlYr612KLp3zu/eRHjgyHcOmNcSA044xE=;
        b=mYVfrIo96sqWCjo+h5zxhYQIduxb4GO+H1JXSySjiW9vl9vMfRVQWqrBS+fQbQawVK
         LcylTe7eEiNjp0m99VxoQ77kIG+RSFOHCAOoiW1xvfQjRaj4i83HYDrqDjrPdWpuOcja
         b5OKllcZ4bW+g5yfMug3SdUZ9PqemZLSyWNl7yIxTY4du6zEKF4KslaozXTPQcw4p7J8
         ZLl5KwP0mWSIgb3aOxEMuVHDupHfFyASBarvqXTuBaWvw/BDeYCUHp7OZulawmZlotEW
         u/ePx5Sw4K3Hfj5I4RPMsSCT7u1ivWg8I9oNu3PpHbDNZn9qVqfN2xLlFGEQCYKD3rIm
         d1ew==
X-Gm-Message-State: ACrzQf2kSXh9HjnOwXj9jGsCEhr46WTaad9PQo9ErfX6SMZzu59NZQe5
        Yh0x5waGets1F4YmNqKmOfcX5FZScEI=
X-Google-Smtp-Source: AMsMyM400SkFFxkF1iT6t1XOvw3bzHsCwRfac5RUsDcthCc2zo6ufwdOqy7sT0L4hI8vABmlxsDL+rcddnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf01:b0:188:571f:3756 with SMTP id
 bi1-20020a170902bf0100b00188571f3756mr35538364plb.171.1668043805499; Wed, 09
 Nov 2022 17:30:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:30:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110013003.1421895-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: Mark vendor module param read-only after init
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Mark the read-only VMX and SVM module params, and a few other global
variables, read-only after init.  In many cases, KVM is royally hosed if
a configuration knob changes while VMs are running, e.g. toggling the TDP
knob would result in spectacular fireworks.

This series is probably best queued very early in a cycle, as the result
of mis-labeled variable is an unexpected kernel #PF.

Sean Christopherson (3):
  KVM: VMX: Make module params and other variables read-only after init
  KVM: SVM: Make MSR permission bitmap offsets read-only after init
  KVM: SVM: Make module params and other variables read-only after init

 arch/x86/kvm/svm/svm.c          | 38 ++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/capabilities.h | 16 +++++++-------
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/sgx.c          |  2 +-
 arch/x86/kvm/vmx/sgx.h          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 36 +++++++++++++++----------------
 7 files changed, 50 insertions(+), 50 deletions(-)


base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

