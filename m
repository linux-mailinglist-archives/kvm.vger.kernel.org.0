Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66D55F5D7B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJFAEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJFADl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9045F868B2
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:29 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g2-20020a17090a3c8200b0020ab5f733d2so62723pjc.3
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OOUVOx92e9TPbHiMSq0GFIi0JU6k8DvZUcmie6j5t9E=;
        b=eL/uz7eLgvELZ04pGzDuj2OMzJCUZuUVaPwvFBeZMIboI6rKy6nEP5EnUouwL6jZYy
         5XvfIKLr0XgaExVQkeaB1uRq767AWbDrqdMBA202GJFPWdMXZnKQ3rGL1KOo2A3yX/kU
         tl4mpDFSjPqbhAp7QT/Vi+NvBjxJ+JRJNnUh4anob9bsVrvfjb8wtS4gEb5UWynbtFyR
         8MTtlSKCnOJkDSbnJQMK3jNGFZGamvaNruD34ZVaIEhx90ZbdydGzWl4n4yRP34kTi81
         e+V5gLSdjvi7oSbqf8jSJP6P2oDueisaiM4Za7/qduvhGnrAm+bc1ebwq2/SyfGgdHHM
         itzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OOUVOx92e9TPbHiMSq0GFIi0JU6k8DvZUcmie6j5t9E=;
        b=a3P1JqzjRT4WRaQ87Kq0ky76hsaiuXAoJ3u8F7iqeIGhtS3oBGSTEKSjdr/s6BOZoU
         APslHR/o+0VCXFId7XgETwvbbkIz0hcC/fVtK+NqS20hgeZ4dsd6Q3kQ+1Zj+e09xwff
         8Tkm8enx/1nUl5VyxrmhHlMXi9txODFEyKHOY+c1tn/ZyF8Y/K3e93gaoHXC0pYkt4Pj
         /AKMv0rc+kMDrcHfviaQnTrRcDOnhEBYqjHqSCXIJBIinwzyiSM/+tICnL+jK+oQJ7tk
         1L402rct4QQp1rcdhSOb6sqhld5r41teUZ7uW7Ax/kHisuZL5SBGGioZIm37PgPRndHT
         XW3Q==
X-Gm-Message-State: ACrzQf3cJ99lny4Fj1sEtJOHwpHz0uUGjUK6LD8Qv3pAMYR/RPY0JJ+C
        rGJ08xYdwSzrt9HYz/6M4zG7WJNTRDU=
X-Google-Smtp-Source: AMsMyM6ihFR3Fgp9UWKZShMmVif5xSTGipKmZyOjO6hfiLOnqQy5RAaUef7tz5vYtJEmsELaX8tp+hDd1Wc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7c4a:b0:20a:b201:461a with SMTP id
 e10-20020a17090a7c4a00b0020ab201461amr2195880pjl.181.1665014608006; Wed, 05
 Oct 2022 17:03:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:12 +0000
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006000314.73240-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-7-seanjc@google.com>
Subject: [PATCH v5 6/8] KVM: x86: Init vcpu->arch.perf_capabilities in common
 x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize vcpu->arch.perf_capabilities in x86's kvm_arch_vcpu_create()
instead of deferring initialization to vendor code.  For better or worse,
common x86 handles reads and writes to the MSR, and so common x86 should
also handle initializing the MSR.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 1 -
 arch/x86/kvm/x86.c           | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 24f4c22691f8..49343ee48062 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -631,7 +631,6 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].current_config = 0;
 	}
 
-	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..b6a973d53f93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11821,6 +11821,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
 	kvm_async_pf_hash_reset(vcpu);
+
+	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	kvm_pmu_init(vcpu);
 
 	vcpu->arch.pending_external_vector = -1;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

