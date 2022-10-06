Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5855F5D7E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJFAEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJFADs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3815868BD
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:30 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e13-20020a17090ab38d00b0020b06ff019aso285230pjr.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cEkG9GEBTiUE8th5TFZ42NZiqyxd5/5OjQ/JbzJymEQ=;
        b=HZpuKtQwKzlujbVYW3M11GQu0M8KWSz0k/1l9wTjCp+9BEGr2WT/wWmHO+zcKJ4mkS
         p6vnMq3+ZeY75KvwgsBZr/0R8nJTVeMbbU0rDuIYoHWnHllB83NE0YS/GXitghHa+995
         nER/VuLKCZKssKvFOKrMqnVe+wSTNJ7fbX5i0IDdDmKYZlm1x04g5eBH5aD7nStplxL4
         HMY6/ZNWZpqTopZXWJaqOl90rnZ05if94Lyrlbrcem5/sovXyehgVbIf8tDITvxTe3kT
         1aoCB0ZiaC37HHPRiDWbSejAwDHs0/cDAeh+dJkACaBDLcqJGCta2y9GsYXKAvRIgl0o
         U/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEkG9GEBTiUE8th5TFZ42NZiqyxd5/5OjQ/JbzJymEQ=;
        b=Z1H49ILlstWbwOF+FZmnOd6LgXrwXcJHXQqLtvu/XHADBXTjeZmbSksR65xu0+OmrJ
         eVqnkKQLSQbij4lw4RSBl/rDtwGXQXhXwfJRgIi0xGfiE4oF6jcLG/e7lJucNlX21h/g
         1e/OHzpeLpJzVXE4CsmeGv3CzI6orvu0NmLpVzj9dnsIAIzheLK9WqPYJMyw/rV9VsNp
         gvDblFPYt5x8JicY1Di6GKB+QiwjDIMR64Oltav3RC6avka5whGXlbnfhM/BLA5wzzY6
         PqcJSU3AxtPG8nKhZuY7Vs0x5tOsM1nY5mKNcrjBhDA6o5H9zY505A7km2Xzd4PHCtO5
         aAzw==
X-Gm-Message-State: ACrzQf0a6Zl1Mh5ly9rTUejWQCbc5V3titRsQN2fhLN76A2C3/LPN7SJ
        onYvOjOs+ApxfJE95R5riI4mEFnD3pk=
X-Google-Smtp-Source: AMsMyM4vYKF91WDVjIeLWeM1NERAi/CGUxBO8aM/E7dVqea8tHTIQPPArdz7NyDaAfOAviH4bem/pSr9+mU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f791:b0:17c:c1dd:a3b5 with SMTP id
 q17-20020a170902f79100b0017cc1dda3b5mr1821332pln.141.1665014609775; Wed, 05
 Oct 2022 17:03:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:13 +0000
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006000314.73240-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-8-seanjc@google.com>
Subject: [PATCH v5 7/8] KVM: x86: Handle PERF_CAPABILITIES in common x86's kvm_get_msr_feature()
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

Handle PERF_CAPABILITIES directly in kvm_get_msr_feature() now that the
supported value is available in kvm_caps.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 arch/x86/kvm/x86.c     | 3 +++
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6b680b249975..0d8935e7a943 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2714,9 +2714,6 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 		if (boot_cpu_has(X86_FEATURE_LFENCE_RDTSC))
 			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
 		break;
-	case MSR_IA32_PERF_CAPABILITIES:
-		msr->data = kvm_caps.supported_perf_cap;
-		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 850ff6e683d1..6ff832178e48 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1849,9 +1849,6 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
-	case MSR_IA32_PERF_CAPABILITIES:
-		msr->data = kvm_caps.supported_perf_cap;
-		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6a973d53f93..9443ddb358e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1653,6 +1653,9 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 	case MSR_IA32_ARCH_CAPABILITIES:
 		msr->data = kvm_get_arch_capabilities();
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		msr->data = kvm_caps.supported_perf_cap;
+		break;
 	case MSR_IA32_UCODE_REV:
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

