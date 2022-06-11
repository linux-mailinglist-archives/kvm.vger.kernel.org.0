Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE775470BE
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348760AbiFKA6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344017AbiFKA6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2AF69CEE
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n8-20020a635908000000b00401a7b6235bso302195pgb.5
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xJFWCgWI3EZenc2tlDcSehPBrfChnvoivOJPRUBuTOk=;
        b=OI2RYCYvH9YEFwqQYZCeFKsUd8hIlfgy8Qfm16pgMy3uNoPO3vPz7kQAI8sxh9hwd6
         iTYqMqbreCW4+yPgj9JD6jQou46MTuJiq2LuQYVJyoKx73RSel+DViKa6Eg6lHYqpvbs
         ZyKlge2JPsxJWb+NxbZ8NHbT9jqIC7NWq//fec+IFcNlFjhCmI1UkWl/Wk1FarNxetX3
         tY1EPve4Hp/NDLSCrwfO2O6oCOVxFnZqdfDv/z1LGYc45HHtAp7/a7KuqSu7b4DQbZ7X
         9MaMNOMZUVrF+9IevRUYJ2CIW9Fy4s+XCRKs6VTWkveUywNfPhkVN2BWuNhoVKQw32/Q
         yPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xJFWCgWI3EZenc2tlDcSehPBrfChnvoivOJPRUBuTOk=;
        b=d71BrdIGM8lo631+Ebz06k/dJl/IkURaekuNw6hLglWVLuykxL1Fq8bvtUnHtPl5bo
         OShNnYqpltFWw5ym6Nx8RCk35iEn237RfLMj7LSB3DBeej3oWC93cMSG6prB5vxB/p2C
         nwKkLdpplPWQ7w+ZUzKpbmRmntw0PR/FpIsXXEnk3tZHZJDI/yZk8a/TOCFw2mGBDm74
         wAo+UE0d4sWGE/iezy1cVjBA4JkcbT5fIjUqxWT07+k6t8wsk2f2JRC2U8AiC69px/ep
         ROzxtAWreXPuFrJFkRXv1NZ74Q/JKtnoC39+l7ZaHJrcWU7ne1n+ilDy6Eb/AKG0rm++
         lrMg==
X-Gm-Message-State: AOAM533b9IQj+7KC0L7ABeP+JzysQa0dBhYIFCtwy5QOhEXrvzcb5FfF
        qXnUKbsHVovEdHzS7t9mOsiLBDMQrgA=
X-Google-Smtp-Source: ABdhPJx+qfVTFFmlfIT6OsNBQeUg4btE9LEEK5spRpsXxEqgb919qH0klWyJfztDfRY/nMYWkZ77jIXvXjY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr13457pje.0.1654909081383; Fri, 10 Jun
 2022 17:58:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:50 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/7] KVM: VMX:  Give host userspace full control of MSR_IA32_PERF_CAPABILITIES
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

Do not clear manipulate MSR_IA32_PERF_CAPABILITIES in intel_pmu_refresh(),
i.e. give userspace full control over capability/read-only MSRs.  KVM is
not a babysitter, it is userspace's responsiblity to provide a valid and
coherent vCPU model.

Attempting to "help" the guest by forcing a consistent model creates edge
cases, and ironicially leads to inconsistent behavior.

Example #1:  KVM doesn't do intel_pmu_refresh() when userspace writes
the MSR.

Example #2: KVM doesn't clear the bits when the PMU is disabled, or when
there's no architectural PMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3b324ce0b142..b62012766226 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -619,8 +619,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->pebs_enable_mask =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
-	} else {
-		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
 
-- 
2.36.1.476.g0c4daa206d-goog

