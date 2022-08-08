Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7191B58BE7E
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 02:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiHHAgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiHHAgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 20:36:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD8E63A9
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 17:36:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q193-20020a632aca000000b0041d95d7ee81so102656pgq.3
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 17:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=ldduIU/m0IhSFb2TxSrTcvwnMILyzEYEmP5XNPE0Qxk=;
        b=XECQ1hV/f1lERFZRWFkfRrPsJsInZJhd2r1LY+BtWKd480OKauaMlHs1IC0brcLyVh
         8DkWQcxAQH1+XXwZGg3Rtb6mnwjSEm1R35ggyyi279XGTaWChfTvUjYU6V5eoHYFcR6B
         vXcmAC8jaTOG6lxq2UfN3ReLi2IVlJzIdqw6qtShM5MxSws8lqpiLTrwUFWquiYYIeDy
         QBeJVXPBoeYJCmJEsKwyJPyQFjNhshrVUGDR1sh8KXg5mzM92OPVEhx9Rfcs6EKSCc8i
         jNtIP3RtShUkHN0uK3LKG0sSP0Ge8yLCOaXXB329/aiprRTFozS4C2v8Sbaw+8jaDTj+
         jrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=ldduIU/m0IhSFb2TxSrTcvwnMILyzEYEmP5XNPE0Qxk=;
        b=A5OeGSk2V5PwNyHWDYMyR75L3UCz44C6Z/ajDSah9CeTFmCC8nDLQxV3v+KSg57fU5
         Q0khQNQgqYqYmN2DLUXXA4rKwE6jcVowdPTniL7u3Zqaut50v2s+SNwRaWxHVmxux5Sf
         VIhHumzLmVtkT0Zw+qw41p2OXvEXdKimVgNR4HnitYKJnb5hbJsSG/JNIiPAIqwVyPnJ
         N4ejK5IUtxvtgCS3JN5R3Gi7L7MIw/WRBC1zTHJpxsxFVLYcmkLh/29af9YVOCxBAhUk
         yZnVsbSvAbJ449Q+dwYOYwB606HFGaHnnhfSTM1IrY13EN9d62XP4WLBIiUnnIS07mG0
         MxHQ==
X-Gm-Message-State: ACgBeo2GQJBdREtSP/t3RSJDtPcPNhoHBWJVmiLSrNfG3kF9br9x5Lf9
        RAvpmNnmplgk1UGf1bWwfKzepz4U5iUD
X-Google-Smtp-Source: AA6agR55KsqCqECm9mnYdYXVsUD/wRg7jWiFCeWc/7oOo2Lx/gEmqO74hvY/fEGgRhnFa/2NwUSM9VZal+7I
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:5b0d:b0:1f3:137d:7927 with SMTP id
 o13-20020a17090a5b0d00b001f3137d7927mr17953562pji.18.1659918969226; Sun, 07
 Aug 2022 17:36:09 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  8 Aug 2022 00:36:03 +0000
Message-Id: <20220808003606.424212-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 0/3] Extend KVM trace_kvm_nested_vmrun() to support VMX
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
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

This patch set update trace_kvm_nested_vmrun() to support VMX. In
addition, add the guest_pgd field to enrich the trace information.

v2 -> v3:
 - Split the insertion of guest pgd field into a separate patch [seanjc].
 - Update field names as suggested [seanjc].

v2:
 - https://lore.kernel.org/lkml/YurMLf3MDAK0RiZc@google.com/T/

v1 link:
 - https://lore.kernel.org/lkml/20220708232304.1001099-2-mizhang@google.com/T/

David Matlack (1):
  KVM: nVMX: Add tracepoint for nested vmenter

Mingwei Zhang (2):
  KVM: x86: Update trace function for nested VM entry to support VMX
  KVM: x86: Print guest pgd in kvm_nested_vmenter()

 arch/x86/kvm/svm/nested.c |  8 ++++++--
 arch/x86/kvm/trace.h      | 33 +++++++++++++++++++++++----------
 arch/x86/kvm/vmx/nested.c | 10 ++++++++++
 arch/x86/kvm/x86.c        |  2 +-
 4 files changed, 40 insertions(+), 13 deletions(-)


base-commit: 922d4578cfd017da67f545bfd07331bda86f795d
-- 
2.37.1.559.g78731f0fdb-goog

