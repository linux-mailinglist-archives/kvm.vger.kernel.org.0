Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200C75892B6
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiHCT1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiHCT1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2547E5A14D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ng1-20020a17090b1a8100b001f4f9f69d48so1548705pjb.4
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=pubjVED0BoBlj/p5UniQdmKFhKP0erdMehcit07w1Xc=;
        b=V/n/vMZRu+2+sx1k/94A1X+hKQmzD4su5cyvN0W8gCb+UDecM7Dzc0xv9fxSXNlzbg
         WrhFFxqVaCUv8c+72XHzpgT9KPhxgIVj92G8orOu0r2DNchv+9GzjRRyT4hIA5YinsjM
         snGjCqI4NIydpKY3u/9H4s2FNN8wMXyEOaWMlydbCNrz+/ixl1+0OE/mI9oajENTUB9M
         hshvVMs5lxYdozh0MAYYbYwwPbZFJS4XHI1/qmx1Yrm7A1h9p4vxUgj5/Rw5LivYhI/q
         LSgckFpjYIp/4OeZttuaIrxJ+A6wBll4G0+m3gaGmuKQ38MnZlLvpv34a1fNOSZLfpQD
         GzeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=pubjVED0BoBlj/p5UniQdmKFhKP0erdMehcit07w1Xc=;
        b=e+196jVkmCljrW5FT9CDSCELyUqBSx8qdx2ceMgfHaCs2b2yAk2fw4zR/4ICXG35H3
         LhZwzQQChU9LF31MP/1Hgv/ILQp2olOBcUKCzoDHSieLnhU7E+zpqiy9rMdmExnrqrnX
         2gJoKracyCvcYLNUcO27ulPUZsWxWgjP2oUJ0DeVnigOw2NJIuyTBmjw5gNsMwpTCj6L
         XtWqbW/Do3tI7E+1CJJsb0bBq/ANTd8s1OR3RunKw45Z4L85g2pi0hGB86nBwHiLe9sC
         cC9h98hxwzKxuiQJjLdpIXE1xikRiNcIjOjwQn0Ur+WfqJNt6fJGc2M1QtYQfZT3VDOD
         Dyqg==
X-Gm-Message-State: ACgBeo0F/TimcuTXdvuR/Rqdt9Bxn1RfH212I8zfUgKAEu1xUwLa6GsE
        Ok9Q9RVYnzekEvDhtBUZ0gHEJoyUOJM=
X-Google-Smtp-Source: AA6agR4SmuyM1ck3bZ1o8K58VylIsD5sfq4HiuedgIvq/RCqq3O2egwmPnV3LEHYaJ84anCSgkQUKLE2jlA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:80c7:0:b0:41c:62dd:2109 with SMTP id
 j190-20020a6380c7000000b0041c62dd2109mr7897814pgd.449.1659554829551; Wed, 03
 Aug 2022 12:27:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:55 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 4/7] KVM: VMX: Advertise PMU LBRs if and only if perf
 supports LBRs
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

Advertise LBR support to userspace via MSR_IA32_PERF_CAPABILITIES if and
only if perf fully supports LBRs.  Perf may disable LBRs (by zeroing the
number of LBRs) even on platforms the allegedly support LBRs, e.g. if
probing any LBR MSRs during setup fails.

Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Reported-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..d2fdaf888d33 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -404,6 +404,7 @@ static inline bool vmx_pebs_supported(void)
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
 	u64 host_perf_cap = 0;
 
 	if (!enable_pmu)
@@ -412,7 +413,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	x86_perf_get_lbr(&lbr);
+	if (lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 
 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
-- 
2.37.1.559.g78731f0fdb-goog

