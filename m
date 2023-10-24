Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10157D43F0
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjJXA0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjJXA0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:26:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DA310C7
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1caaaa873efso28040145ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107206; x=1698712006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cKw2oFXjDBeLUy3TN9d0wAQBta1CYNuO3g/uAt5rkPU=;
        b=vKn+/AUweDCsC14TZMn+KQtWldIkLL/EkEtYsn7yPtJgZgLCDuGNTFQyNehKIDs1R7
         2FB+dXItFGodP1BAWiHTDoszQ/2epqk2+DLDZ3/icmwMhkqkXPB7LO/IEaZhjCoFY75L
         KfyRKl2evBUXW1EqhZY37jGU9mukWm7yqYjEcVWsmx1MBH5F7zZFaVLBCmeaUs9euDKy
         kV8CtKhvlLu+3oOrHnCLyg66x6ADD307XIa10ei2nGsQWCB9oF5lGxaxcfxvQ25lqhQJ
         9YIhQ5BaLmhXjViiiGegjaV+2ew5fo0UFqXaFCOxQOvfna56hAqEm7rZ29ar39TuCVYF
         t4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107206; x=1698712006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cKw2oFXjDBeLUy3TN9d0wAQBta1CYNuO3g/uAt5rkPU=;
        b=Je4yo3GrjTC3MxcEdGW0gteHzD7o6kqvuF+YkzJWASeeEpS32CmkJYnD3MloE41qZk
         X62WUNOrFRBoDOfp3baYMPP2BFZ+riDJPzfkm+W267HCabu1UBLwkv2Eaeqfh4a4zvn5
         9qKJ83hX/Uy5dIcMd49YkJyBQCJhaQ67AYc4RBN13LtDUTSD+22/sL1Yv9uPkecQV2Jl
         3vNJtq/VvSwVdi5OErmaTAu9ryHQiuo/qixWjjkzacAkCtqqs/DWHKJMLig7WNK9imYU
         Cwk8f1d8eVjY5zvCvmGXVFG7Zbu8GaWrXGowcboQ8/DLroDnpiJ+oBxP6VoNskqaK1nI
         DSOA==
X-Gm-Message-State: AOJu0YxnO5Mm7RJruDeddvZ02g4vq35EcmBD2XdbJHRBH2I7SsR1q0Oi
        0k6psLp2kuyrTi1E6Ud4EjWBrINCJQA=
X-Google-Smtp-Source: AGHT+IHCk1iJEjqyU6r8Xnv/6T2nNERPiPMyxUaFyJVNh/usThtDLM2yp4ID9P1oppjz5D7IP0MxYMcn2uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab5a:b0:1c7:3462:ce8d with SMTP id
 ij26-20020a170902ab5a00b001c73462ce8dmr193856plb.10.1698107205898; Mon, 23
 Oct 2023 17:26:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:25 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-6-seanjc@google.com>
Subject: [PATCH v5 05/13] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
the name is redundant with the macro, i.e. it's truly useless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a01931f7d954..2d9771151dd9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -289,7 +289,7 @@ struct kvm_x86_cpu_property {
 struct kvm_x86_pmu_feature {
 	struct kvm_x86_cpu_feature anti_feature;
 };
-#define	KVM_X86_PMU_FEATURE(name, __bit)					\
+#define	KVM_X86_PMU_FEATURE(__bit)						\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
 		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
@@ -298,7 +298,7 @@ struct kvm_x86_pmu_feature {
 	feature;								\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-- 
2.42.0.758.gaed0368e0e-goog

