Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D9A4F6F1D
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiDGAZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiDGAZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:25:16 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF06A13E14A
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:23:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mp4-20020a17090b190400b001ca7801fe4dso2519909pjb.4
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=NPDZju+gtB7kVd1H2fSg6BF4jp8vlYSjp64iiNlwXWM=;
        b=my5jn/IWgd3GpSGzEFbwpmzVhgIglR5ZMm+VNZyX6s7vvwJsQ1bTgxRMnGlNFkZVBQ
         VinknO0h7GZjlwLNwjQJuLPMq0rd/N7ePzVy4s+SlPfTdulkAN38oByCCXxpbbW1u9nR
         9LG5R23KpyIqujrxjaynKDduGe1OWyVdoflVYR95RBShQEunIu4OBFIqmI5yri70kfpl
         ojMaXnEoUAps+qyeubRfwK9yH4Qr9/NQ665Ln+iuxsvqyI1oMw5rH9jFx+TEfhjKg1vR
         K73cg75dAZBJIGXlY1A3tPuZ95X5Bsq8mN+4wonMGAnD8oJo5xAhi+q/Mv+QQ1mNJCsZ
         B6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=NPDZju+gtB7kVd1H2fSg6BF4jp8vlYSjp64iiNlwXWM=;
        b=KpZS7dX2hJNhdx1Fqr4f8UguXA1q6B5A06ztsyNoqf4RyO5+OVfmY4nUymHP+2mVup
         EStVnXA7Gn27uKiNDQ/gQCXMPPal7lzFPR7z3sYXY9yJd6+tq8b/7tN3+ZhaA9huz9mK
         iPLqgpp+kAT6OPAgpXKWLWCjnXEC7He9Uye/NJ2RzgmwWq5vAOI/k72WoC8ZrPdkvkt9
         NT9gNgK5DiTfKkwuxLpbYbrMgfIvu1oc07mwWLmHHIebgsrl927QJ3uQYm1GvfPfhd1l
         wLbYDVpfZu1WL5a6Rz95GDJDK/S2Mc88dD3h3xjTeyk7S2efL1Nf9UnqKQm7zNlK2x/3
         DOGA==
X-Gm-Message-State: AOAM530tlGHRghQ6XyYdNhZa+y5f/xig3SuaIyMVE0+VBKRQuUk1DsO7
        NnO1TJs7UWwIVhxY/unq7lI3OgfYQ68=
X-Google-Smtp-Source: ABdhPJx7eRWdji1HciFWW9BZhO7Qc1mk6oc63JfsMISBKJSAXDAeLfKTG1GfHQP3/8VJqKwLnnx94A3u0n8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8f:b0:156:3b3c:b128 with SMTP id
 j15-20020a170902da8f00b001563b3cb128mr11646620plx.50.1649290998394; Wed, 06
 Apr 2022 17:23:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  7 Apr 2022 00:23:12 +0000
Message-Id: <20220407002315.78092-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 0/3] KVM: x86: Nested fixes (mostly #DF/#TF)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 removes an assertion that is going to fail miserably once KVM
allows save/restore of pending triple faults.

Patches 2 and 3 are fixes for edge cases for nVMX related to saving exit
info on failed VM-Entry, #DF and triple fault, that in all likelihood no
one cares about.

Sean Christopherson (3):
  KVM: x86: Drop WARNs that assert a triple fault never "escapes" from
    L2
  KVM: nVMX: Leave most VM-Exit info fields unmodified on failed
    VM-Entry
  KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple
    fault

 arch/x86/kvm/svm/nested.c |  3 ---
 arch/x86/kvm/vmx/nested.c | 48 ++++++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmcs.h   |  5 ++++
 3 files changed, 42 insertions(+), 14 deletions(-)


base-commit: 7d4cda14f55ae6998220aaecd2ab00e20d0e8f57
-- 
2.35.1.1094.g7c7d902a7c-goog

