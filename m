Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7317B5470BC
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348049AbiFKA6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242810AbiFKA6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893069CD4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:57:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o16-20020a170902d4d000b00166d7813226so367810plg.13
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7gJN3lrU8qyje7cASe7iBluFaQ8qPCHxf1ZASubji/8=;
        b=i401VRM3BdP1yFCLSTJPyfJttxtMuC+2jOlsXYKablbrwtaNWpGQ3qpfi8UowuyXCE
         XG13C3QZlDgALw7OqvQl175+p792tGhAYJTl/HGjiNI7zSqN9IXK+Tfgb+3HfR1DIh3e
         gb1me/M4GPZgRVSEctJN4DWHpKEu3DgvuYNebrptgKHr+JEmJFX9b4Z1BHiNmPxiLSYg
         MaMPXzz4+Pk/7ohCjbWFuwsZQk1ZQxCHEohbjzdyJ62a2yWP/mI4b5+FPQ2EyOoef4XP
         XSFOI9asNgWZ9N3KzuvYDvS5vpcqxyT/bUxleI3KFwEAv9HEywsBqVaGkDnCz/FOHg1F
         YyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=7gJN3lrU8qyje7cASe7iBluFaQ8qPCHxf1ZASubji/8=;
        b=GV4HU+49hWCnVQjU6qWP9CgBIpXg+U/+pUeMQPkEXHZnJfKvHVzsmRtJZDFVDpPh9j
         vlbVrOeCLWxvjOrhu2VeLD33Cz76gNip3F0GaMcg7AIykWPlXN39Fnj9MBBrTNO8JHZT
         T05FjwHIpb4zslS0SXBogSxcZok+VdQ+jw/eGElG1k0OX3P+Uv1leZSfVpV3YvsYnmNb
         +BdM0BeOEEirhgtSxkTBtRotVw2HeYCQUmuWA15Uk7lyIhxZiX2ezcA+4S2LIX8eYFJs
         1ykQysP5hFi5B1TZk5Got2IvCmUxwXlNK1Hvz1sXLyKxLD/KJvXtxecYpkD3IDZ9wW1z
         febA==
X-Gm-Message-State: AOAM533wbs/q/E4lEvbzRx2cIpjKvYepFGLA/QexqD8B5Kvx8o7f55Uu
        Kv3ItitFXiM+EvFP71U8/zSnmqcm87Y=
X-Google-Smtp-Source: ABdhPJzdYBXSayqgnpHOkPm+Lkn6jrp1qulOQq9tcNpPvYdd+MdMsPF9Krmg0ouGuHb8OkxWGJVrrMT08Ao=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:88cc:0:b0:51c:319e:772c with SMTP id
 k12-20020aa788cc000000b0051c319e772cmr24146299pff.41.1654909077779; Fri, 10
 Jun 2022 17:57:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:48 +0000
Message-Id: <20220611005755.753273-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/7] KVM: x86: Attempt to wrangle PEBS/PMU into submission
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

Attempt to fix the myriad PEBS/PMU issues in kvm/next.  Ideally this would
have been code review feedback, but I missed that boat.

Lightly tested, and I haven't thought through the host_initiated stuff too
deeply, but KUT and selftests are happy.

Sean Christopherson (7):
  KVM: x86: Give host userspace full control of MSR_IA32_MISC_ENABLES
  KVM: VMX:  Give host userspace full control of
    MSR_IA32_PERF_CAPABILITIES
  Revert "KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated
    if !enable_pmu"
  Revert "KVM: x86: always allow host-initiated writes to PMU MSRs"
  KVM: VMX: Use vcpu_get_perf_capabilities() to get guest-visible value
  KVM: x86: Ignore benign host accesses to "unsupported" PEBS and BTS
    MSRs
  KVM: x86: Ignore benign host writes to "unsupported" F15H_PERF_CTL
    MSRs

 arch/x86/kvm/pmu.c           | 12 ++------
 arch/x86/kvm/pmu.h           |  4 +--
 arch/x86/kvm/svm/pmu.c       | 13 ++-------
 arch/x86/kvm/vmx/pmu_intel.c | 43 +++++++++++-----------------
 arch/x86/kvm/x86.c           | 55 ++++++++++++++++++++++++------------
 5 files changed, 59 insertions(+), 68 deletions(-)


base-commit: 0cfd9c71371d4c7f96212d20833c36953eccdb91
-- 
2.36.1.476.g0c4daa206d-goog

