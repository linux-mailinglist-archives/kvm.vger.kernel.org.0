Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346F654BD23
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 23:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbiFNV6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355064AbiFNV6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF3F1E3DB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id l2-20020a17090a72c200b001e325e14e3eso4178664pjk.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=0mmsgcPAIZJfYehAVs0Zfdox5FsqJk2L7a9PvpXjF6E=;
        b=sQ/pbXychTmfvMgUvUaXmvMGjTtuVHoxQSK/DnCff8MVhk4D2Sjj3qlvtZ7v5R859S
         i43rSTaPupW3CkU4c+HN1vHFdC6keEdcn/xwn1Iqy7vR4U6sVZUtvZayLLLS+tLIVcHc
         IGFDQOjrOjsu9gLK3bDrHGnrXheePfpzhgDm0M2wxHqL+dch1AKJ2bG/fZ4c6QHnSGFQ
         +40TNB3dyMvYbyEMti6mZfmByZWllAoFSVYSLE1Od3KDqttyA6p7wc4zQAnugm9P3EIN
         jykMAuVgaXc6UkYaGQjoZV5C7Ahq8/7WT0QOgWFP57fOio5PuKiUzLEa+bpTUdwP3Fr9
         BRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=0mmsgcPAIZJfYehAVs0Zfdox5FsqJk2L7a9PvpXjF6E=;
        b=szAkZYJdACEfkGyjz0GZJVpGybF4e3iYzqa9lEit3IZMU4KwFJBm8A47ihT5Wwtz/2
         ahuwp5uGyAvUTQUTFbhNNmh4xVilK9t8Gs9ULwEd/WaRoS+TOcBaPCnowllQ+Nz6yJlX
         078p6QRMNNInhqqYXrrFhW5ndl1DqKJQICIFdordNKxXwFBfg3KBHX1zzzYnPX9BYmsH
         xaygBCNtS4F4EoQH/sT2Qur1m0LZhmkOtnHdpt+C/KHpA8AGxMQHakuAH4LBHjddb4+0
         iqHeo8Gm9quo+g9px5UY5lHaWnNTttXK/q+UOQuF/yN9u8BT/MX5LpvTPfSqkf/i+Sc8
         QCEA==
X-Gm-Message-State: AOAM533YM/RE/e/mgMpjqZAIX4LS6xWqIgbp5H44eXyhN1xRKw+kLmWL
        tfWf0aHbYuJGGmcfRE8Znm6awG9kAFg=
X-Google-Smtp-Source: ABdhPJy/7VewsNVEFx2GcjypGNbbVRWI6qtdNm2Xn24L0W/qrnva2ba4fGKXFDiaV8TZ6SwN/oYuOJhCdyU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:a50c:0:b0:510:6b52:cd87 with SMTP id
 v12-20020a62a50c000000b005106b52cd87mr6757272pfm.30.1655243914388; Tue, 14
 Jun 2022 14:58:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:26 +0000
Message-Id: <20220614215831.3762138-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/5] KVM: nVMX: Support loading MSRs before nested state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Wang <lei4.wang@intel.com>
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

Fix two edge cases in nested VM-Enter where KVM loads garbage into
BNDCFGS and/or DEBUGCTL when migrating a vCPU with L2 active.  If userspace
restores MSRs before nested state, userspace expects KVM to propagate L2's
values to vmcs02.  KVM already mostly handles this scenario, so even though
I personally think it's rather ridiculous, it's easy for KVM to support,
and given that our VMM does KVM_SET_MSRS before KVM_SET_NESTED_STATE...

Patches 4 and 5 are minor optimizations to handle BNDCFGS more like
DEBUGCTL and/or the PKS MSR.

Sean Christopherson (5):
  KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
  KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
  KVM: nVMX: Rename nested.vmcs01_* fields to nested.pre_vmenter_*
  KVM: nVMX: Save BNDCFGS to vmcs12 iff relevant controls are exposed to
    L1
  KVM: nVMX: Update vmcs12 on BNDCFGS write, not at vmcs02=>vmcs12 sync

 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 arch/x86/kvm/vmx/vmx.c    | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.h    | 15 ++++++++++++---
 3 files changed, 33 insertions(+), 11 deletions(-)


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

