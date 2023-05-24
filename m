Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BDE710124
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbjEXWwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjEXWwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:52:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7734BA9
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:52:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56561689700so29248757b3.2
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684968755; x=1687560755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQzJt7PVzKE0RYFdY1/R7evjIQ4fazx/fIwgD8umm1c=;
        b=UOZwS8V9j5Vj7d6BBP7lbPtOOLPMognA4evyDEpUyGLMRrcV3vgnjijCWqXJ/5ltPU
         U/2EPX4zrJ1eKb4Q8NLvxVex6T5Ef3lsZ+VdAPcoeYlEVCYMKRy57K39xvYAg/PFtCfq
         wrBALWHCCZ1+AmBbdvK5bhdoQK+FyI1SOnq5HJI/peN0LRAXsi2iLy2VRfVaTyqdwzWM
         KebH4Oj1WwtZrCDJILN6und2ITGTKK8RdBaPUY/eqiVzxiFQUdM7N8CXWuEhIpV89n6W
         ZmB4aRYkuRZeu3eUWuXSahUmkeOPfoXOGGBKuM5cusjBU/DhJdgjHaXioqtV4DS3T2hK
         +X1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684968755; x=1687560755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XQzJt7PVzKE0RYFdY1/R7evjIQ4fazx/fIwgD8umm1c=;
        b=goeLd5bxMAGxvEmP/943aMhxYsjOMqfy2yxPwjBHunmw8alMxwc62+2N3VN6op3FGy
         cddhqYy5np7EZv5Hlk1613AOxLgGTmkl+gTo3a1HL36/nv833ivCxrokDea26YX3UKa5
         TFSGMt5J12K4uCTdO4Brp3+hBW4D2Ojl7iBmkA8pI2rOu/DJZUHJqVWms0LlOZh65qGa
         wFlP9Cz+LXr3MFkK8lq2mT2MKZKPRvuWOxrecv0Nh6UWlMWbx/DwZVNa9ALyRR/ctdW0
         w7+7QjG1uTXtnPiueHLGhqt5byr7h23DaTEG1BOXJM439iBUnD+aGYD6R4ZAI/Yh9Lc2
         XR1g==
X-Gm-Message-State: AC+VfDzPve70N7C7xsK2jSdYSu9XjqAp7suthd08a6gpC9/nPM49D6CF
        VnhvaXbylUgFgfLnDBHZyeTzuShp/ec=
X-Google-Smtp-Source: ACHHUZ7OAaaoJI95qhata3HKErnQCfVYLGT5GDZUYkSPYRW9Lty5Acw8p9+3sQpUzr+WaRtb9wncucayCQM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441b:0:b0:55d:9484:f153 with SMTP id
 r27-20020a81441b000000b0055d9484f153mr12017925ywa.7.1684968755778; Wed, 24
 May 2023 15:52:35 -0700 (PDT)
Date:   Wed, 24 May 2023 15:52:34 -0700
In-Reply-To: <20230323072714.82289-8-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-8-likexu@tencent.com>
Message-ID: <ZG6VMrYK2xgR/v95@google.com>
Subject: Re: [PATCH 7/7] KVM: selftests: Test Intel counters' bit width emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Like Xu wrote:
> +static uint64_t test_ctrs_bit_width_setup(struct kvm_vcpu *vcpu,
> +					  uint8_t bit_width,
> +					  uint64_t perf_cap,
> +					  uint32_t msr_base)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	bool fw_wr = perf_cap & PMU_CAP_FW_WRITES;
> +	uint64_t kvm_width;
> +	uint64_t value;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	if (msr_base != MSR_CORE_PERF_FIXED_CTR0) {
> +		kvm_width = kvm_gp_ctr_bit_width();
> +		entry->eax = (entry->eax & ~GP_WIDTH_MASK) |
> +			(bit_width << GP_WIDTH_OFS_BIT);
> +	} else {
> +		kvm_width = kvm_fixed_ctr_bit_width();
> +		entry->edx = (entry->edx & ~FIXED_WIDTH_MASK) |
> +			(bit_width << FIXED_WIDTH_OFS_BIT);
> +	}
> +	TEST_REQUIRE(kvm_width > 31);

Unfortunately, using TEST_REQUIRE() in a subtest is generally a bad idea.  This
will skip _all_ tests if the requirement isn't met.  That might be a signal that
the test is doing too much, i.e. should be split into multiple tests.  Unlike KUT,
selftests are more geared towards lots of small tests, not a handful of massive
tests.
