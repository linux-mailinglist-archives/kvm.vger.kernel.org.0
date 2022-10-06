Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C845F5D71
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJFADY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJFADV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F2D86800
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cb7-20020a056a00430700b00561b86e0265so196949pfb.13
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RhM6iZSMqYtBZOLPIkknX0vr2yAb2zl+Qo+V+WJBCzM=;
        b=QeCiF3Wy7QypRn8LL6KEND4sblDwtIs2fywt4CssoMs9BpJHlhBJcHOH3u43seZLRE
         qMg27TeaFQ0Skzfkp4wyjubVvS7ovR02YzTtPff43g1mSM+LkapNVwe62udL+/hKa5J2
         zgtEJPXtDjfeMCM+FF0PRPDQvbOgBWaPr8Wfw5K2vQnHtva2TP9+3rvBceYBJa9THvGH
         NcFsMd6akL0ZMAN06laMZAJkq9k29RUydhmc7cEQGVqa9/DrtPkW7kOmXIUzmWZMd1Xq
         hM2NB1jtMICf+WgaqGs3z8I8akjjg20Jwutnhg7RvSoZuQc7wjHnbr1aiiM01y0lZPoi
         whNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RhM6iZSMqYtBZOLPIkknX0vr2yAb2zl+Qo+V+WJBCzM=;
        b=ydeUjTUoyvDz2jREkftESg5QW+pfW5OB9CWgGejowNfmhrGbIM/nlxCCExmMA3Kevl
         w1GBo8LzVpNoohsvmIP6T1GXx3EFdrpKkjv2qjgZhTZy9NsT+ul/Pv+EiZcDZK23b0DQ
         VGgA3aup2W1SZ2PsUDCTaP1uW447PaA7unnrzyQdKBMM07JFpGbxfwdJOiwLjU3VloLA
         y5zPNtdT47EeCyBg3WsBJl0ACY5yv9hl0E8n/XrQI2n3j9XxftLPSjAiYcjxrKl3A5FZ
         9KSR6S3lDkXZ3yveNnRMXKr+dLoFqXTemGuX5LJenRjmNw1yO9Y1Q7BIL20OFySnaIAH
         oDJQ==
X-Gm-Message-State: ACrzQf0N+C9KhUEUfWha/+3Lw0tvQwss15Pmw+1E8BclGCQNYBIwVKy8
        rHclH3rF53oplEd5geHdc/QC6tVuhgU=
X-Google-Smtp-Source: AMsMyM6Krv128iFVqVqEOV6EZrfbhUl8komxmlaBGDQkso9y7sj6k62Ayi2e7U/8PAwFvB9I8ORgP6hUqEI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:179c:b0:561:71d3:e112 with SMTP id
 s28-20020a056a00179c00b0056171d3e112mr1899973pfg.12.1665014599587; Wed, 05
 Oct 2022 17:03:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:07 +0000
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006000314.73240-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-2-seanjc@google.com>
Subject: [PATCH v5 1/8] perf/x86/core: Zero @lbr instead of returning -1 in
 x86_perf_get_lbr() stub
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

Drop the return value from x86_perf_get_lbr() and have the stub zero out
the @lbr structure instead of returning -1 to indicate "no LBR support".
KVM doesn't actually check the return value, and instead subtly relies on
zeroing the number of LBRs in intel_pmu_init().

Formalize "nr=0 means unsupported" so that KVM doesn't need to add a
pointless check on the return value to fix KVM's benign bug.

Note, the stub is necessary even though KVM x86 selects PERF_EVENTS and
the caller exists only when CONFIG_KVM_INTEL=y.  Despite the name,
KVM_INTEL doesn't strictly require CPU_SUP_INTEL, it can be built with
any of INTEL || CENTAUR || ZHAOXIN CPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/lbr.c       | 6 +-----
 arch/x86/include/asm/perf_event.h | 6 +++---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 47fca6a7a8bc..3abf7b041220 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1876,10 +1876,8 @@ void __init intel_pmu_arch_lbr_init(void)
  * x86_perf_get_lbr - get the LBR records information
  *
  * @lbr: the caller's memory to store the LBR records information
- *
- * Returns: 0 indicates the LBR info has been successfully obtained
  */
-int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
+void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
 
@@ -1887,8 +1885,6 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 	lbr->from = x86_pmu.lbr_from;
 	lbr->to = x86_pmu.lbr_to;
 	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f6fc8dd51ef4..18c105571d11 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -542,12 +542,12 @@ static inline void perf_check_microcode(void) { }
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
-extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
+extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
-static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
+static inline void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
-	return -1;
+	memset(lbr, 0, sizeof(*lbr));
 }
 #endif
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

