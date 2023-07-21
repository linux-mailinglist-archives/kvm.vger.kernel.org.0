Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F7675D7F6
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjGUX4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGUX4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:56:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16EB30E1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:56:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c6db61f7f64so2449375276.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689983802; x=1690588602;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JB0mHFDmU3sjG3ZEt8YBjzzYwrb6CiQP2HeKKPMa64Q=;
        b=7czSKVArYbjKlvoWLYM4+2xHiBQTDnu3Z/9oVQoar2KUiQzZAgwYxz3oOv8ym8DuTV
         pN1AKDyE4SdPxwA2BT+iv8gVeyjp1wTWYsKvZiHNV/fmSrUvTufu95z6kGt2dIUISU3x
         1c27kC1rh/khD5B81SxRPUqTgvLNlsynfLXkaL1avx9Ar52ADcQuljq4IsS8EfXqFUBy
         l9jhwpeqZFWsPVeiCL5tzNlikMDJ/oW0r5SQQhYmpLVV7B4YWKKRZykthM7PvZNA/ZcH
         tOEo3v52H/61wRwlAacjF8ocUCVNAMylnS3FXcPpM1n8Ns5VDBiQDCgnRE0J/Q/1hQOj
         10NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689983802; x=1690588602;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JB0mHFDmU3sjG3ZEt8YBjzzYwrb6CiQP2HeKKPMa64Q=;
        b=AKxarwfcicM6HawdLDrvenjY4BqYsJmlHi1W7WC8vMnPAke7VC8RkvJGEEGP3xL+Rb
         kechrdCRN1pjBKBlTQ4YrXeB5l5TITu5jD4t6sFG31wjnUhioyrVGqQ0jX/5mXDY9N9F
         I45XO3yI59gncBA4ct82C7PfY/6v09MBxho/+nTnxEl26QWPwkRbL4dEq1ExYp5T3/VC
         rKETqq34ZRaauD0qFXS/zy0xgxcnRHm5TzoJLTRxMWnptMtZKZuRczAzI1HhOEGxxIQU
         gb6BihdsBMSn2j83CPD3jMYwGzn+OFvdJ0NqUc3FHXfG0d9HcqTT6aJ4rzDDCndgH5DS
         op1w==
X-Gm-Message-State: ABy/qLbSibTD6kQzTwMOaxJ4MHnN7RoeNwGTbHRNRT0WEVZzn9H3es7C
        yQpDn4g86q2lyY9mqUvVyqpfZS5IdSU=
X-Google-Smtp-Source: APBJJlHgc576QAi6DYUQZK18LKw7N9a5DJivtJPsdnyGXgzH3beYmcRhfE35qveH6GZoAfMIX9NVh9RQyfA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:404a:0:b0:cbf:8936:4cb8 with SMTP id
 n71-20020a25404a000000b00cbf89364cb8mr20393yba.2.1689983802147; Fri, 21 Jul
 2023 16:56:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:56:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721235637.2345403-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: VMX: Make VMREAD error trampoline noinstr friendly
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Su Hui <suhui@nfschina.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add another trampoline for the CONFIG_CC_HAS_ASM_GOTO_OUTPUT=n VMREAD error
path in order to enable instrumentation, i.e. to make objtool happy, before
calling pr_warn_ratelimited().

Sean Christopherson (2):
  KVM: VMX: Make VMREAD error path play nice with noinstr
  KVM: VMX: Use vmread_error() to report VM-Fail in "goto" path

 arch/x86/kvm/vmx/vmenter.S |  8 ++++----
 arch/x86/kvm/vmx/vmx.c     | 18 ++++++++++++++----
 arch/x86/kvm/vmx/vmx_ops.h | 12 +++++++++---
 3 files changed, 27 insertions(+), 11 deletions(-)


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

