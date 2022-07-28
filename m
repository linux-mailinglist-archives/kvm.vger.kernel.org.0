Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEF8584814
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiG1WSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiG1WSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:18:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC16D54E
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e17-20020a656491000000b0041b51b1c9edso1458993pgv.12
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=nmSFdwgcuE5SfSU8QrIA95a2sshWJa8QHPw1OmKiKkE=;
        b=aI8VbxGDdSh4aW1HVorxqf3OFz4YOYdqY3zro1KyrPx/dtkwSBZElzlcE8FrYFjdKf
         2YvFQzq/pyVJ0f2W7mr+DNzgq3LuLoxLbSoIMu3kRcVkn4o44xU2AcGlBAHh/1nxMzrW
         oOnmmUZGUhjqiq6IowyZtwLTOjXgo3q5SiC+dNW5yrDi5/JvD59lzn+nnNCF9zzwCU17
         U8l2tzuz6FZBICOW+SmE+0bvK98ay8Fa3upjrzcZ80tf7t4gDFHbI8Js2LO8t7BbYvNA
         ELd/k2sNWESXpjk5M7aX2V/DiuenKhHUCTKZnoE5We+YF8x3BwHoZrQZl3VMl4YCe2W6
         17+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=nmSFdwgcuE5SfSU8QrIA95a2sshWJa8QHPw1OmKiKkE=;
        b=CnZ6vmEQiWTaZ9pdtHwem31J1+28XxqtfppiI+FNBkQlpLsvX2zvAvfURiL1za+u4u
         wZOidKEBdw6jAlUx8cg8nUBFul3G7aT2L7Siq2VxHUd2FtI7Rsvb1MT7aIQ928XWhKoe
         skN1L65aRhMsY8EZ8988A6gzkNVHe6y54R7xliEdCw//HERWaGOGXWiFsz6fAARdOJWt
         ki/Xo0hyvEO62iakUTq+FL63sCnA0kpMAW+1xiUTDWW4Ey+uIi0ZK644NeIcNM2gushj
         7o8TDhy+B0d89lAbJezGoL3UKvk5Pm21qB2w/EOB0QcFqUhQ1VKDLHtoaRnDKMwgR313
         ovwg==
X-Gm-Message-State: ACgBeo2vHLSBhfzR50m4ygkIpA6BqK7LIKfMF/rIyftQ7hVie+UK/mmf
        XCsggeG0TLaC6FVjNB29JImTe8sXInE=
X-Google-Smtp-Source: AA6agR42e24oo1TzeL/rjcuJmVi7KOwUsV+NJa/JRa+nLhldOIxrwG4TOaNOr8+awav+IotkFF67JhnjE8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id
 q18-20020a17090311d200b001678a0f8d33mr876844plh.95.1659046682325; Thu, 28 Jul
 2022 15:18:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Jul 2022 22:17:55 +0000
Message-Id: <20220728221759.3492539-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 0/4] KVM: x86/mmu: MMIO caching bug fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
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

Fix two bugs I introduced when adding the enable_mmio_caching module param.

Bug #1 is that KVM unintentionally makes disabling caching due to a config
incompatibility "sticky", e.g. disabling caching because there are no
reserved PA bits prevents KVM from enabling when "switching" to an EPT
config (doesn't rely on PA bits) or when SVM adjusts the MMIO masks to
account for C-bit shenanigans (even if MAXPHYADDR=52 and C-bit=51, there
can be reserved PA bits due to the "real" MAXPHYADDR being reduced).

Bug #2 is that KVM doesn't explicitly check that MMIO caching is enabled
when doing SEV-ES setup.  Prior to the module param, MMIO caching was
guaranteed when SEV-ES could be enabled as SEV-ES-capable CPUs effectively
guarantee there will be at least one reserved PA bit (see above).  With
the module param, userspace can explicitly disable MMIO caching, thus
silently breaking SEV-ES.

I believe I tested all combinations of things getting disabled and enabled
by hacking kvm_mmu_reset_all_pte_masks() to disable MMIO caching on a much
lower MAXPHYADDR, e.g. 43 instead of 52.  That said, definitely wait for a
thumbs up from the AMD folks before queueing.

Sean Christopherson (4):
  KVM: x86: Tag kvm_mmu_x86_module_init() with __init
  KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change
  KVM: SVM: Adjust MMIO masks (for caching) before doing SEV(-ES) setup
  KVM: SVM: Disable SEV-ES support if MMIO caching is disable

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  6 +++++-
 arch/x86/kvm/mmu/spte.c         | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/spte.h         |  3 +--
 arch/x86/kvm/svm/sev.c          | 10 ++++++++++
 arch/x86/kvm/svm/svm.c          |  9 ++++++---
 7 files changed, 45 insertions(+), 7 deletions(-)


base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.455.g008518b4e5-goog

