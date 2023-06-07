Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C732725155
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbjFGBCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbjFGBCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:02:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CECD10EA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:02:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-564fb1018bcso111399177b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 18:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099736; x=1688691736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JyEnJxnIYsauq/wSH1IM7vfFjE0o1hylh2ce6s6Y23k=;
        b=C/OMltvMIzfjvYtFziX8yWQNaRTGcBJ8pVtIQ97zHN8U1eAsZnzA7+xtl1uFr6bcSa
         AlL4dV//ptBOZZgYGa/KVmR17MrH8C+nPizWoZsE+bs/EaM5JpuDF3oSpgQDlcpKbwd1
         SGHkw+XbxcKpxnuQElcNWiiuY6b2zMNU+b5jVpILaG07IUR+wgFU6gTm/dnbSW2FwvCr
         stTjkNBflDFmeZz2nfMUQq4cAEIB2T3NlUC7VNqhDkC5vuLQEWo+NH6BD1BnaWrsOarJ
         4OPyBlbTbvStZkPaFIkuP9E+K9D0Kflm2Vn17/PwsrbO1xC7AZhwKpwbJFqQNEVnd2c8
         oIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099736; x=1688691736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JyEnJxnIYsauq/wSH1IM7vfFjE0o1hylh2ce6s6Y23k=;
        b=P3M1Y/fXh0oS/xw6FqOSV62C7p29cb5Ye6nGeQfPbcPFoKelrFCbDz3zTMNRM6JrlE
         7ehHBeQMCfTYk3CH2HRJlseEu1hvxIsrORK7/gHRCk4FMlFQDjRCmQmLaikS0pz4bkeT
         yCiAK5kMiRuIBj7ZTqddpIPkhcpr5F4TFfovDqa2zppNwVhLbiTAUVSVbGzG2srJqNGM
         SQB5xzoQhU9UnyFiJJepm+H2jO357kNrJi4IFdpsozJWLj5OkjrLZlTUb72w8ZyfpYoK
         M8L/c9lROcQbxCGxdAeS09ZJ7n24PXyGzONBSTZjOxNjDDmUECmHv8viVmLFgJ477lhb
         hSDg==
X-Gm-Message-State: AC+VfDyte4fKlSq4nOJa0rdTN21CxaxnMMAIWUrr8JVMsDkenFpGIFHQ
        +cV5rQMvbqRQCh48JRRsyQ87sQ0tmYs=
X-Google-Smtp-Source: ACHHUZ4MvXrHaFNari3YZ+IxskSB2J2fPXHKEZ3qPZEIMqZzn+iGLDZkHtk/iquHC25eZxEh9NBJzHGxLwc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1882:b0:ba8:95dd:3ccb with SMTP id
 cj2-20020a056902188200b00ba895dd3ccbmr2093612ybb.5.1686099736605; Tue, 06 Jun
 2023 18:02:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 18:02:06 -0700
In-Reply-To: <20230607010206.1425277-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607010206.1425277-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: x86/pmu: Move .hw_event_available() check out of PMC
 filter helper
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Move the call to kvm_x86_pmu.hw_event_available(), which has nothing to
with the userspace PMU filter, out of check_pmu_event_filter() and into
its sole caller pmc_event_is_allowed().  pmc_event_is_allowed() didn't
exist when commit 7aadaa988c5e ("KVM: x86/pmu: Drop amd_event_mapping[]
in the KVM context"), so presumably the motivation for invoking
.hw_event_available() from check_pmu_event_filter() was to avoid having
to add multiple call sites.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1690d41c1830..2a32dc6aa3f7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -387,9 +387,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
 
-	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
-		return false;
-
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		return true;
@@ -403,6 +400,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 {
 	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
+	       static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
 	       check_pmu_event_filter(pmc);
 }
 
-- 
2.41.0.162.gfafddb0af9-goog

