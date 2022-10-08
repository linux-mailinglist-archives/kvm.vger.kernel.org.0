Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B418B5F816F
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 02:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJHAIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 20:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJHAIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 20:08:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C42B7ED5
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 17:08:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lx7so5683348pjb.0
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 17:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=as3WS17Gnx9AR/romeESWOMzl4ad8aHYMl/EG9oavUE=;
        b=KO+KZrxFgvhdm7B0H0z15n+SygZGszI1xR/xDdnqwz6pzXztnSg4kb7d1kV24YMIF0
         8e8B/VW5nS3dPA9aDAnkpXGLerK4unma+ro9chUciNW5g6m0EKUNVSRBbde/L/ijXFVh
         QrUeL6PjDwDO+g5YQA5jbq659F5WKfj7Bcrtvn/r83wXugVtfXA/PtJ82zSlitsyiSZk
         QFXCVdLctXEM4KI9myCX5Pn72TPiUO79F2pmX87LnPqX3KMzf3aoiIn3ec8L7eKtPF6K
         r6rAA2ORfdcdAZvaEDumyn1B92VMsOxSXHRKnsZDUA8DfNPgWqZyfHlfFbEDCpf1rp9X
         7RbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=as3WS17Gnx9AR/romeESWOMzl4ad8aHYMl/EG9oavUE=;
        b=CA5mOxYuiNLDeLvGnc/em1tS2FQHGmHFzcWd4znksmaCvxZYDq8/q1GXaGaRc05Jtd
         oCu3tnjafI16X+rHIMBVzzqv/r6kloTY17/1++ez4trLUlRKBojxekZyeG1vi/EDtL5S
         zZnYetFAgau5jic6EsXU2UJDu0yA9O8qF7oA2qgFJtDPwesYM5eYIsTzOrN8AHetdLUt
         SndtgOd336lhxZaTMmJgedXco2BkBXvgmzAmNysbMVhZ/pwSyfTNYoOSFV+CsfHBHtEY
         UNhXJwoqXTvjjowvo66FGmqx0VCinOKXWi0uWwFHKsqqbijcjGKPUOILxN2sM/qj6qDD
         FGhA==
X-Gm-Message-State: ACrzQf3A10Mrp2eekP4WEr4TVayoBlYUYBgkJPaJTCEecm+91zAFsGrt
        Js0/yd+3C1lgrcp69BXzJ+q8hgPYMSDvow==
X-Google-Smtp-Source: AMsMyM6aztOzQe3OG/o/I/UOLJgVgPnPziaOr52kM6gdlmGk0WHj2C2guPmYerbKkJJ5HQodTCZI7Q==
X-Received: by 2002:a17:902:7102:b0:17f:3da:f18c with SMTP id a2-20020a170902710200b0017f03daf18cmr7474793pll.24.1665187688471;
        Fri, 07 Oct 2022 17:08:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z20-20020aa79494000000b00537fb1f9f25sm2180447pfk.110.2022.10.07.17.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 17:08:07 -0700 (PDT)
Date:   Sat, 8 Oct 2022 00:08:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 3/7] kvm: x86/pmu: prepare the pmu event filter for
 masked events
Message-ID: <Y0C/Y1qGE1Ne9QBJ@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174603.302510-4-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, Aaron Lewis wrote:
> Create an internal representation for filter events to abstract the
> events userspace uses from the events the kernel uses.  That will allow
> the kernel to use a common event and a common code path between the
> different types of filter events used in userspace once masked events
> are introduced.
> 
> No functional changes intended
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/pmu.c | 116 ++++++++++++++++++++++++++++++++-------------
>  arch/x86/kvm/pmu.h |  16 +++++++
>  2 files changed, 98 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e7d94e6b7f28..7ce8bfafea91 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -239,6 +239,19 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  	return true;
>  }

Hoisting the definition of the union here to make it easier to review.

> +
> +struct kvm_pmu_filter_entry {
> +	union {
> +		u64 raw;
> +		struct {
> +			u64 event_select:12;
> +			u64 unit_mask:8;
> +			u64 rsvd:44;
> +		};
> +	};
> +};
> +
> +#define KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask) \
> +	(((event_select) & 0xFFFULL) | \
> +	(((unit_mask) & 0xFFULL) << 12))
> +
>  #endif /* __KVM_X86_PMU_H */

...

> +static inline u16 get_event_select(u64 eventsel)
> +{
> +	u64 e = eventsel &
> +		static_call(kvm_x86_pmu_get_eventsel_event_mask)();
> +
> +	return (e & ARCH_PERFMON_EVENTSEL_EVENT) | ((e >> 24) & 0xF00ULL);

This is nasty.  It bleeds vendor details and is unnecessarily complex.  It also
forces this code to care about umask (more on that in patch 4).  Maybe the filter
code ends up caring about the umask anyways, but I think we can defer that until
it's actually necessary.

Rather than pack the data into an arbitrary format, preserve the architectural
format and fill in the gaps.  Then there's no need for a separate in-kernel
layout, and no need to encode anything.

Then this patch is a rather simple refactoring:

---
 arch/x86/kvm/pmu.c | 54 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 384cefbe20dd..882b0870735e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -257,40 +257,50 @@ static int cmp_u64(const void *pa, const void *pb)
 	return (a > b) - (a < b);
 }
 
+static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+{
+	return bsearch(&key, filter->events, filter->nevents,
+		       sizeof(filter->events[0]), cmp_u64);
+}
+
+static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
+{
+	if (find_filter_entry(filter, eventsel & kvm_pmu_ops.EVENTSEL_MASK))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
+static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
+{
+	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
+
+	if (filter->action == KVM_PMU_EVENT_DENY &&
+	    test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+	if (filter->action == KVM_PMU_EVENT_ALLOW &&
+	    !test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+
+	return true;
+}
+
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
-	bool allow_event = true;
-	__u64 key;
-	int idx;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
 		return false;
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
-		goto out;
+		return true;
 
-	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & kvm_pmu_ops.EVENTSEL_MASK;
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
-	} else {
-		idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-	}
+	if (pmc_is_gp(pmc))
+		return is_gp_event_allowed(filter, pmc->eventsel);
 
-out:
-	return allow_event;
+	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)

base-commit: 214272b6e5c3c64394cf52dc81bd5bf099167e5d
-- 

