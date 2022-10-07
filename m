Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80D5F8119
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJGXZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJGXZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:25:45 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376C81D667
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:25:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g28so6148328pfk.8
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 16:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wpYcL6puLH5IRh/3zaDl/Ty/Y5dYFy1uUWVihN8ymUk=;
        b=NX0gjoQtK4KM/2pxOgeH5df6WyrYGf9jSaUGUEibtY4JTa37/lUL0LhvFrSwfGY/hP
         iXdH8ksTT4CniqvDFzcAdEOmZpnzkpl+C+CdKfmm6aa1Ipw7Ujn6T6fJjlRUhWDlk8Ll
         7lBgcdpYjFXV1CwmrqaeFbcnZSD8YtS8cqMpY2VUqG9lbXs+3/PBDaXpMr8q/KimmKGa
         dV7eN33N3Y6sBIjKtXLIPLbeWD64wAIvJto5jQSQTrFP+Iy/AXjFUdkKVShGN7YN4fz5
         nWTpml2BInTufyJdWcAwFniDQtTiMtpK24kHkpVKHLatSY55LvTaQl9wtrDf7+yuCusW
         7Pdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpYcL6puLH5IRh/3zaDl/Ty/Y5dYFy1uUWVihN8ymUk=;
        b=H4N2OUZcE98elc6Go8jy0VbZCZPTOclFusLdRgfAADVC/w0MyaCw5bxHD/ZpCF01zM
         E1lTfuuOT9+M46nrLTvqUgxCSiHPGEY6xrBv+KdBSzokiZ0u5Eegp2QvuY5hD/PNped+
         MFL/NbkQosCPGvF0jUBKDiIqD3D2djHQwl6yDdSLKntTFmtWPI4GsY1uuMXE+fZnQX+Y
         TO1sj3YkIfpF1QknFY3IelE2Xwth9ZvtUVDWbqTLndKUQCIC3qg2gQQZ0VOdHbgHAELx
         7bG6NajGQZwHFMTDI3ZXbiKu8wOhtnRj+BFBR09D80JtMTONrqramWCPDBTvh+RE3EwM
         7hqQ==
X-Gm-Message-State: ACrzQf1Mp6DdZJH/Qbky0PVAfmm5/UOwRuU/L1Dl7jyt6yH42sE2RAa5
        UJGhRmM0QlANNY8F8UU0Yt7nstv5xSb9ug==
X-Google-Smtp-Source: AMsMyM5GmTMMteQ9iZM8HCSgXww3+USTPXnYBJo5GBjO6QM9lHNYf0we9riFyYFKEwC3XEa4p37DfA==
X-Received: by 2002:aa7:9218:0:b0:560:f3f1:d2d4 with SMTP id 24-20020aa79218000000b00560f3f1d2d4mr7628170pfo.14.1665185143421;
        Fri, 07 Oct 2022 16:25:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090ac40600b002036006d65bsm1990871pjt.39.2022.10.07.16.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 16:25:42 -0700 (PDT)
Date:   Fri, 7 Oct 2022 23:25:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 1/7] kvm: x86/pmu: Correct the mask used in a pmu
 event filter lookup
Message-ID: <Y0C1c2bBNVF4qxJq@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174603.302510-2-aaronlewis@google.com>
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
> When checking if a pmu event the guest is attempting to program should
> be filtered, only consider the event select + unit mask in that
> decision. Use an architecture specific mask to mask out all other bits,
> including bits 35:32 on Intel.  Those bits are not part of the event
> select and should not be considered in that decision.
> 
> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
>  arch/x86/kvm/pmu.c                     | 15 ++++++++++++++-
>  arch/x86/kvm/pmu.h                     |  1 +
>  arch/x86/kvm/svm/pmu.c                 |  6 ++++++
>  arch/x86/kvm/vmx/pmu_intel.c           |  6 ++++++
>  5 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index c17e3e96fc1d..e0280cc3e6e4 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
>  KVM_X86_PMU_OP(refresh)
>  KVM_X86_PMU_OP(init)
>  KVM_X86_PMU_OP(reset)
> +KVM_X86_PMU_OP(get_eventsel_event_mask)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
>  
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 02f9e4f245bd..98f383789579 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -247,6 +247,19 @@ static int cmp_u64(const void *pa, const void *pb)
>  	return (a > b) - (a < b);
>  }
>  
> +static inline u64 get_event_select(u64 eventsel)
> +{
> +	return eventsel & static_call(kvm_x86_pmu_get_eventsel_event_mask)();

There's no need to use a callback, both values are constant.  And with a constant,
this line becomes much shorter and this helper goes away.  More below.

> +}
> +
> +static inline u64 get_raw_event(u64 eventsel)

As a general rule, don't tag local static functions as "inline".  Unless something
_needs_ to be inline, the compiler is almost always going to be smarter, and if
something absolutely must be inlined, then __always_inline is requires as "inline"
is purely a hint.

> +{
> +	u64 event_select = get_event_select(eventsel);
> +	u64 unit_mask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;

And looking forward, I think it makes sense for kvm_pmu_ops to hold the entire
mask.  This code from patch 3 is unnecessarily complex, and bleeds vendor details
where they don't belong.  I'll follow up more in patches 3 and 4.

  static inline u16 get_event_select(u64 eventsel)
  {
        u64 e = eventsel &
                static_call(kvm_x86_pmu_get_eventsel_event_mask)();

        return (e & ARCH_PERFMON_EVENTSEL_EVENT) | ((e >> 24) & 0xF00ULL);
  }

> +
> +	return event_select | unit_mask;
> +}
> +
>  static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu_event_filter *filter;
> @@ -263,7 +276,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  		goto out;
>  
>  	if (pmc_is_gp(pmc)) {
> -		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
> +		key = get_raw_event(pmc->eventsel);

With the above suggestion, this is simply:

		key = pmc->eventsel & kvm_pmu_.ops.EVENTSEL_MASK;

And the total patch is:

---
 arch/x86/kvm/pmu.c           | 2 +-
 arch/x86/kvm/pmu.h           | 2 ++
 arch/x86/kvm/svm/pmu.c       | 2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d9b9a0f0db17..d0e2c7eda65b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -273,7 +273,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 		goto out;
 
 	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
+		key = pmc->eventsel & kvm_pmu_ops.EVENTSEL_MASK;
 		if (bsearch(&key, filter->events, filter->nevents,
 			    sizeof(__u64), cmp_u64))
 			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..45a7dd24125d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,8 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+
+	const u64 EVENTSEL_MASK;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b68956299fa8..6ef7d1fcdbc2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -228,4 +228,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.EVENTSEL_MASK = AMD64_EVENTSEL_EVENT |
+			 ARCH_PERFMON_EVENTSEL_UMASK,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 25b70a85bef5..0a1c95b64ef1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -811,4 +811,6 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.EVENTSEL_MASK = ARCH_PERFMON_EVENTSEL_EVENT |
+			 ARCH_PERFMON_EVENTSEL_UMASK,
 };

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 

