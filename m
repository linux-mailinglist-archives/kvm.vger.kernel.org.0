Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA25892BE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbiHCT1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbiHCT10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9805B7AC
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q11-20020a170902dacb00b0016efd6984c3so4041754plx.17
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=miAlPwrbCQgN0E56eM5ssFJVYzMR4KpxRDlfQ+ZlXIY=;
        b=D0UbA+P6z2AObS7Jny22QIU9JpwXlxc7eVpeSbs4iLwVBu/ML/aZ6JaS3Wagmy9rNQ
         243ST+j1zEGSYdXQK4HrC7rGsRSmx4OX6MIU11kiQSYK0dB52FW9aB+uz+1fLWMSbgqE
         PmZkbB8H6w6xE6GIqOnzw6d5sBC7h8E3Q3ZR+Rlk8wA/I0fN1IhOJpUMbRocequv6p35
         OKppsjNxoCJgNzY5Zn7LxjKZLKcP2YdgIz4sDxr2FPqwiwXJAKQpdDpZ4ir0Zl2vzz+d
         Qsml54AQ25D78PJKwfbH2VBwg+G7LzBVIFK8K3SXh3VJu8Njpk0iPw5Mzv1Frl4jnib0
         aibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=miAlPwrbCQgN0E56eM5ssFJVYzMR4KpxRDlfQ+ZlXIY=;
        b=QmVxccjP7wt6mLwkLa6ZbTllr0y5r2IXGSYSi9HNexVi18uN5/0xa1Rqxi1lu4Nq8c
         MYj0Rgu8gU0qvHdlO1MY9AaSIyyfs0FFGoT9R0C8ujpRKer61rt+IbwGWIa1PLbvTMnk
         SHAHQm5EEol7brJE46ksrrWO+r5htRblJ4aq5HareUoXnCj70+waCxZlBSPoJjj5SIFT
         lqY+debefFO5tUiglk2EcBB2VnlkQDM9GXVbFC4lLvXqLVMrxvDoD9/L8kcPSMRTofcS
         Y4RYud7qSagl3ZWLNIoZPRX0TWIBbGw8cLy46C/s5cdLmsX0uihHL/JxcjhK31sTgF8g
         srZA==
X-Gm-Message-State: ACgBeo2VtX0LuaetuUJadXhWO96+dpchkOpzy/yd0VmmAc0YhV4K8Xdj
        RZGzgU5zXeSclHujMMqAa7Lfn+/Odsg=
X-Google-Smtp-Source: AA6agR6lAdTPvlttjsLtXWWxIk5IZzJW8lJsYP3jKoyPIMRir4soD844K2FCZGswawiXrim1VMllZqU/H90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1786:b0:52e:625d:a08d with SMTP id
 s6-20020a056a00178600b0052e625da08dmr730293pfg.76.1659554834636; Wed, 03 Aug
 2022 12:27:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:58 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 7/7] KVM: VMX: Simplify capability check when handling
 PERF_CAPABILITIES write
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

Explicitly check for the absence of host support for LBRs or PEBS when
userspace attempts to enable said features by writing PERF_CAPABILITIES.
Comparing host support against the incoming value is unnecessary and
weird since the checks are buried inside an if-statement that verifies
userspace wants to enable the feature.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..0ada0ee234b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2323,15 +2323,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
 		if (data & PMU_CAP_LBR_FMT) {
-			if ((data & PMU_CAP_LBR_FMT) !=
-			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+			if (!(vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
-			if ((data & PERF_CAP_PEBS_MASK) !=
-			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+			if (!(vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
 				return 1;
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
 				return 1;
-- 
2.37.1.559.g78731f0fdb-goog

