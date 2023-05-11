Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8307E6FFD5D
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbjEKXeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbjEKXeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:34:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5717ED5
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:07 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-643a1fed384so4792470b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848046; x=1686440046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iMwZebLgqrimvcRjxTfXs1dPRahEkXvBmYggFarwQK8=;
        b=6B1XJv4N1xwFm9+hw3yUdlyIha5yGy5ism5usAmm7EBXKHEUSxlhvEuMjk30Ogb6/g
         OPwyvr1uYzs1afzyIN6AKaE+VoaJRpnxiqIVgwCSe3qpJLDAZ/caTCsZP1HDWtYpaDqF
         5MajFgVb/NeKV08xJhzUy5dWZkSBb8oqSQh150nLBW/30x+CZrkAiptOJa1TuO00zExa
         Ki+4/RHftZI/v6X81Fuf9m0yL+VvVGLS+XMT7BxI2Xw5q/UW5sVKgsgFGjrfSW3plTtS
         ACrHIqyH0QRZ6rulFJHprnjG738oBMuikGZKQOcv92lB+NbZTlahrsPqhzDdeeMMJh+7
         PaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848046; x=1686440046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMwZebLgqrimvcRjxTfXs1dPRahEkXvBmYggFarwQK8=;
        b=OmjjIBujbFm3O6EBXby3c1+tHl9z06rS3DG6lnfmaDIuJBErJzP/GMYHsrJjie/occ
         CEyP+SNWxMud3DNv+von3c9uuJr+cumL3AoNQmP533RACdf2SA9I26p7ciNiYnCyf/go
         92LuOmOF5/WduX+3ocCzaS6vr3jHIGu2HB43vEABq5PPFchGYTcNjfDgFkT5kKkGlb/c
         1SaCl8EUqTkMKcFGjJsyHE4R32nKourpnDrdoLDzOk5UmIMdcEp78s9Z3BWhXZzeFDGt
         YXLZ6wvYlysIXqRdm6nDlY3FfqxqVujboS6lVe8Di3Y6bunUjGJuUx4YBmLiY/SBaPTX
         6q0g==
X-Gm-Message-State: AC+VfDyM4mk32EQ+PpvjiobOqHECmciXpEjj8LbFIC3NdP/GSU9iEoSu
        ylcSql/P4BEKE00FZKnnapdsKXCV5yM=
X-Google-Smtp-Source: ACHHUZ67LH1NiixyVkjq5fPUolV9uAqWss+HXNXn8k4dRBVaKjw6O1IJN/ccbOyUYvmeLb8xFHG0hPyoWow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7d6:b0:624:5886:4b4b with SMTP id
 n22-20020a056a0007d600b0062458864b4bmr5999295pfu.5.1683848046330; Thu, 11 May
 2023 16:34:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:50 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-8-seanjc@google.com>
Subject: [PATCH v2 7/8] KVM: x86: Make kvm_mtrr_valid() static now that there
 are no external users
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Make kvm_mtrr_valid() local to mtrr.c now that it's not used to check the
validity of a PAT MSR value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mtrr.c | 3 +--
 arch/x86/kvm/x86.h  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index cdbbb511f940..3eb6e7f47e96 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -65,7 +65,7 @@ static bool valid_mtrr_type(unsigned t)
 	return t < 8 && (1 << t) & 0x73; /* 0, 1, 4, 5, 6 */
 }
 
-bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+static bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	int i;
 	u64 mask;
@@ -100,7 +100,6 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 	return (data & mask) == 0;
 }
-EXPORT_SYMBOL_GPL(kvm_mtrr_valid);
 
 static bool mtrr_is_enabled(struct kvm_mtrr *mtrr_state)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..82e3dafc5453 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -309,7 +309,6 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 
 void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu);
 u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
-bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
-- 
2.40.1.606.ga4b1b128d6-goog

